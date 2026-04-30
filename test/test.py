# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


async def reset_dut(dut):
    """Apply reset to the DUT and initialize inputs."""
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)


def get_outputs(dut):
    """Parse uo_out into individual signals."""
    uo = dut.uo_out.value.integer
    return {
        "show_player_led": (uo >> 0) & 1,
        "show_dealer_led": (uo >> 1) & 1,
        "win_led":         (uo >> 2) & 1,
        "lose_led":        (uo >> 3) & 1,
        "push_led":        (uo >> 4) & 1,
        "sum":             (uo >> 5) & 0x7,
    }


@cocotb.test()
async def test_reset(dut):
    """Test that reset properly initializes the design."""
    dut._log.info("Test: Reset behavior")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    await reset_dut(dut)

    # After reset release, state should be IDLE then transition to DEAL
    # Check that outputs are in a valid initial state
    outputs = get_outputs(dut)
    dut._log.info(f"After reset: {outputs}")

    # Win/lose/push LEDs should be off right after reset
    assert outputs["win_led"] == 0, "win_led should be 0 after reset"
    assert outputs["lose_led"] == 0, "lose_led should be 0 after reset"
    assert outputs["push_led"] == 0, "push_led should be 0 after reset"

    dut._log.info("PASS: Reset test")


@cocotb.test()
async def test_deal_phase(dut):
    """Test that DEAL phase deals 4 cards and transitions to PLAYER_TURN."""
    dut._log.info("Test: Deal phase")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    await reset_dut(dut)

    # After reset: IDLE -> DEAL (1 cycle), then DEAL for 4 cycles dealing cards
    # deal_counter goes 0,1,2,3,4 => at 4 transitions to PLAYER_TURN
    # Wait enough cycles for dealing to complete
    await ClockCycles(dut.clk, 10)

    outputs = get_outputs(dut)
    dut._log.info(f"After deal phase: {outputs}")

    # In PLAYER_TURN, show_player_led should be 1
    assert outputs["show_player_led"] == 1, "show_player_led should be 1 in PLAYER_TURN"

    dut._log.info("PASS: Deal phase test")


@cocotb.test()
async def test_stand_transition(dut):
    """Test that pressing stand transitions from PLAYER_TURN to DEALER_TURN."""
    dut._log.info("Test: Stand transition")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    await reset_dut(dut)

    # Wait for deal phase to complete
    await ClockCycles(dut.clk, 10)

    # Verify we're in PLAYER_TURN
    outputs = get_outputs(dut)
    assert outputs["show_player_led"] == 1, "Should be in PLAYER_TURN"

    # Press stand button (ui_in[1])
    dut.ui_in.value = 0b00000010  # stand_btn = 1
    await ClockCycles(dut.clk, 1)

    # Release stand button
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 1)

    outputs = get_outputs(dut)
    dut._log.info(f"After stand: {outputs}")

    # After stand, we should be in DEALER_TURN or GAME_OVER
    # (dealer may immediately reach >= 17 and go to GAME_OVER)
    # Either show_dealer_led is 1, or we're in GAME_OVER with result LEDs
    in_dealer_or_gameover = (
        outputs["show_dealer_led"] == 1 or
        outputs["win_led"] == 1 or
        outputs["lose_led"] == 1 or
        outputs["push_led"] == 1
    )
    assert in_dealer_or_gameover, "Should be in DEALER_TURN or GAME_OVER after stand"

    dut._log.info("PASS: Stand transition test")


@cocotb.test()
async def test_hit_button(dut):
    """Test that pressing hit adds a card during PLAYER_TURN."""
    dut._log.info("Test: Hit button")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    await reset_dut(dut)

    # Wait for deal phase
    await ClockCycles(dut.clk, 10)

    # Record initial sum
    outputs_before = get_outputs(dut)
    dut._log.info(f"Before hit: sum={outputs_before['sum']}")

    # Press hit button (ui_in[0])
    dut.ui_in.value = 0b00000001  # hit_btn = 1
    await ClockCycles(dut.clk, 1)

    # Release hit button
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 1)

    outputs_after = get_outputs(dut)
    dut._log.info(f"After hit: sum={outputs_after['sum']}")

    # We should still be in PLAYER_TURN or GAME_OVER (if bust/blackjack)
    in_valid_state = (
        outputs_after["show_player_led"] == 1 or
        outputs_after["win_led"] == 1 or
        outputs_after["lose_led"] == 1 or
        outputs_after["push_led"] == 1
    )
    assert in_valid_state, "Should remain in PLAYER_TURN or transition to GAME_OVER"

    dut._log.info("PASS: Hit button test")


@cocotb.test()
async def test_full_game_flow(dut):
    """Test a complete game flow: IDLE -> DEAL -> PLAYER_TURN -> DEALER_TURN -> GAME_OVER."""
    dut._log.info("Test: Full game flow")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    await reset_dut(dut)

    # Wait for deal phase to complete
    await ClockCycles(dut.clk, 10)

    # Should be in PLAYER_TURN
    outputs = get_outputs(dut)
    dut._log.info(f"After deal: {outputs}")
    assert outputs["show_player_led"] == 1, "Should be in PLAYER_TURN after dealing"

    # Press stand to go to DEALER_TURN
    dut.ui_in.value = 0b00000010  # stand_btn = 1
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 1)

    # Wait for dealer to finish (dealer draws until >= 17)
    await ClockCycles(dut.clk, 20)

    # Should now be in GAME_OVER
    outputs = get_outputs(dut)
    dut._log.info(f"Game over: {outputs}")

    # Exactly one of win/lose/push should be active
    result_count = outputs["win_led"] + outputs["lose_led"] + outputs["push_led"]
    assert result_count == 1, f"Exactly one result LED should be active, got {result_count}: win={outputs['win_led']}, lose={outputs['lose_led']}, push={outputs['push_led']}"

    dut._log.info("PASS: Full game flow test")


@cocotb.test()
async def test_gameover_multiplexing(dut):
    """Test that GAME_OVER state alternates between player and dealer display."""
    dut._log.info("Test: GAME_OVER multiplexing")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    await reset_dut(dut)

    # Play through to GAME_OVER
    await ClockCycles(dut.clk, 10)  # Deal phase

    dut.ui_in.value = 0b00000010  # stand
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 20)  # Dealer plays out

    # Now in GAME_OVER - check multiplexing over several cycles
    saw_player = False
    saw_dealer = False

    for _ in range(32):  # Run for 32 cycles to see both displays
        await ClockCycles(dut.clk, 1)
        outputs = get_outputs(dut)
        if outputs["show_player_led"] == 1:
            saw_player = True
        if outputs["show_dealer_led"] == 1:
            saw_dealer = True

    assert saw_player, "Should display player sum during GAME_OVER multiplexing"
    assert saw_dealer, "Should display dealer sum during GAME_OVER multiplexing"

    dut._log.info("PASS: GAME_OVER multiplexing test")
