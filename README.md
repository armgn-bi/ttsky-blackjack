# 1x1 Blackjack - TinyTapout

A Tiny Tapeout 1x1 project that implements a playable Blackjack game.

## Features

- **5-state state machine**: IDLE → DEAL → PLAYER_TURN → DEALER_TURN → GAME_OVER
- **Random card generation**: 8-bit LFSR for card values (2-10, J/Q/K=10, A=1)
- **Player controls**: Hit (draw card) and Stand (stop)
- **Dealer AI**: Automatically draws until 17 or bust
- **Multiplexed display**: Shows player and dealer sums alternately
- **Result LEDs**: Win, lose, and push indicators

## Quick Start

### Simulation

```bash
# Compile and run testbench
iverilog -o tb_blackjack.vvp tb_blackjack.v blackjack.v
vvp tb_blackjack.vvp
```

### Synthesis

```bash
# Run Yosys synthesis
yosys config.tcl
```

See [SENTEZ.md](SENTEZ.md) for detailed synthesis information.

## Hardware Interface

### Inputs (4/8 used)

| Pin | Signal | Description |
|-----|--------|-------------|
| ui[0] | clk | Clock (100MHz) |
| ui[1] | rst | Reset (active high) |
| ui[2] | hit_btn | Player draws a card |
| ui[3] | stand_btn | Player stops drawing |

### Outputs (8/8 used)

| Pin | Signal | Description |
|-----|--------|-------------|
| uo[0] | show_player_led | Showing player sum |
| uo[1] | show_dealer_led | Showing dealer sum |
| uo[2] | win_led | Player won |
| uo[3] | lose_led | Player lost |
| uo[4] | push_led | Tie game |
| uo[5] | sum[0] | Sum bit 0 |
| uo[6] | sum[1] | Sum bit 1 |
| uo[7] | sum[2] | Sum bit 2 |

## Game Rules

1. **Initial deal**: Player and dealer each receive 2 cards
2. **Player turn**: Hit (draw) or Stand (stop)
3. **Dealer turn**: Dealer draws until 17 or bust
4. **Ace logic**: Ace counts as 1 or 11 (whichever is better, without busting)
5. **Win conditions**:
   - Player has 21 (Blackjack)
   - Dealer busts (over 21)
   - Player sum > dealer sum (both under 21)
6. **Lose conditions**:
   - Player busts (over 21)
   - Dealer has 21 (Blackjack)
   - Dealer sum > player sum (both under 21)
7. **Push**: Both have same sum (both under 21)

## Resource Usage

- **Logic cells**: ~55-64 (1x1 tile limit: ~64)
- **State bits**: 30
- **Clock frequency**: 100MHz
- **Note**: Ace 1/11 logic adds ~2 logic cells

## Project Structure

```
.
├── blackjack.v          # Main module
├── tb_blackjack.v       # Testbench
├── config.tcl           # Yosys synthesis config
├── PROJE_PLANI.md       # Project plan (Turkish)
├── SENTEZ.md            # Synthesis report (Turkish)
└── README.md            # This file
```

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://www.tinytapeout.com/guides/local-hardening/)