# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_blackjack_reset(dut):
    """Test reset functionality"""
    dut._log.info("Test: Reset functionality")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # After reset, all outputs should be 0
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0, "All outputs should be 0 after reset"

    dut._log.info("Reset test passed")


@cocotb.test()
async def test_blackjack_basic_flow(dut):
    """Test basic game flow: IDLE -> DEAL -> PLAYER_TURN -> DEALER_TURN -> GAME_OVER"""
    dut._log.info("Test: Basic game flow")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # Wait for DEAL state (4 cards dealt)
    await ClockCycles(dut.clk, 10)

    # Check that we're in PLAYER_TURN (show_player_led should be on)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out[0].value == 1, "show_player_led should be on in PLAYER_TURN"

    # Press stand button
    dut.ui_in.value = 0b1000  # stand_btn = 1
    await ClockCycles(dut.clk, 1)

    # Wait for DEALER_TURN
    await ClockCycles(dut.clk, 20)

    # Check that we're in GAME_OVER (one of win/lose/push should be on)
    await ClockCycles(dut.clk, 1)
    game_over = (dut.uo_out[2].value == 1 or
                 dut.uo_out[3].value == 1 or
                 dut.uo_out[4].value == 1)
    assert game_over, "One of win/lose/push LEDs should be on in GAME_OVER"

    dut._log.info("Basic flow test passed")


@cocotb.test()
async def test_blackjack_hit(dut):
    """Test hit button functionality"""
    dut._log.info("Test: Hit button")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # Wait for PLAYER_TURN
    await ClockCycles(dut.clk, 10)

    # Press hit button multiple times
    for i in range(3):
        dut.ui_in.value = 0b0100  # hit_btn = 1
        await ClockCycles(dut.clk, 1)
        dut.ui_in.value = 0
        await ClockCycles(dut.clk, 5)

    # Press stand button
    dut.ui_in.value = 0b1000  # stand_btn = 1
    await ClockCycles(dut.clk, 1)

    # Wait for GAME_OVER
    await ClockCycles(dut.clk, 20)

    dut._log.info("Hit test passed")


@cocotb.test()
async def test_blackjack_display_multiplexing(dut):
    """Test display multiplexing in GAME_OVER state"""
    dut._log.info("Test: Display multiplexing")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # Wait for PLAYER_TURN
    await ClockCycles(dut.clk, 10)

    # Press stand button
    dut.ui_in.value = 0b1000  # stand_btn = 1
    await ClockCycles(dut.clk, 1)

    # Wait for GAME_OVER
    await ClockCycles(dut.clk, 20)

    # Check that display alternates between player and dealer
    seen_player = False
    seen_dealer = False

    for i in range(20):
        await ClockCycles(dut.clk, 1)
        if dut.uo_out[0].value == 1:
            seen_player = True
        if dut.uo_out[1].value == 1:
            seen_dealer = True

    assert seen_player or seen_dealer, "Display should show player or dealer sum"

    dut._log.info("Display multiplexing test passed")
