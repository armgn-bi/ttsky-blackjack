// Blackjack - TinyTapeout 1x1
// TinyTapeout Standard Interface Wrapper

module tt_um_blackjack (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // All bidirectional IOs are unused - set as inputs
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Internal active-high reset from active-low rst_n
    wire rst = ~rst_n;

    // Input mapping
    wire hit_btn   = ui_in[0];
    wire stand_btn = ui_in[1];

    // Internal wires for outputs
    wire show_player_led;
    wire show_dealer_led;
    wire win_led;
    wire lose_led;
    wire push_led;
    wire [2:0] sum_out;
    wire [2:0] current_state;

    // Output mapping (matching info.yaml pinout)
    // uo_out[0] = show_player_led
    // uo_out[1] = show_dealer_led
    // uo_out[2] = win_led
    // uo_out[3] = lose_led
    // uo_out[4] = push_led
    // uo_out[7:5] = sum[2:0]
    assign uo_out = {sum_out, push_led, lose_led, win_led, show_dealer_led, show_player_led};

    // ========================================
    // State Machine
    // ========================================

    // State definitions
    localparam IDLE         = 3'b000;
    localparam DEAL         = 3'b001;
    localparam PLAYER_TURN  = 3'b010;
    localparam DEALER_TURN  = 3'b011;
    localparam GAME_OVER    = 3'b100;

    // State register
    reg [2:0] game_state, next_state;

    assign current_state = game_state;

    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst)
            game_state <= IDLE;
        else
            game_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = game_state;

        case (game_state)
            IDLE: begin
                next_state = DEAL;
            end

            DEAL: begin
                // DEAL -> PLAYER_TURN when 4 cards dealt
                if (deal_counter == 3'd4)
                    next_state = PLAYER_TURN;
            end

            PLAYER_TURN: begin
                if (player_bust) begin
                    next_state = GAME_OVER;
                end else if (player_blackjack) begin
                    next_state = GAME_OVER;
                end else if (stand_btn) begin
                    next_state = DEALER_TURN;
                end
            end

            DEALER_TURN: begin
                if (dealer_bust || dealer_effective_sum >= 5'd17)
                    next_state = GAME_OVER;
            end

            GAME_OVER: begin
                // Stay in GAME_OVER until reset
                next_state = GAME_OVER;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // ========================================
    // Card Logic (LFSR + dealing)
    // ========================================

    // LFSR for random card generation (8-bit)
    reg [7:0] lfsr;
    wire [3:0] card_value;

    // LFSR update (polynomial: x^8 + x^6 + x^5 + x^4 + 1)
    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr <= 8'hA5; // Seed value
        else
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
    end

    // Map LFSR to card value (2-10, J/Q/K=10, A=1)
    assign card_value = (lfsr[3:0] == 4'b0000) ? 4'd2  :
                        (lfsr[3:0] == 4'b0001) ? 4'd3  :
                        (lfsr[3:0] == 4'b0010) ? 4'd4  :
                        (lfsr[3:0] == 4'b0011) ? 4'd5  :
                        (lfsr[3:0] == 4'b0100) ? 4'd6  :
                        (lfsr[3:0] == 4'b0101) ? 4'd7  :
                        (lfsr[3:0] == 4'b0110) ? 4'd8  :
                        (lfsr[3:0] == 4'b0111) ? 4'd9  :
                        (lfsr[3:0] == 4'b1000) ? 4'd10 :
                        (lfsr[3:0] == 4'b1001) ? 4'd10 : // J=10
                        (lfsr[3:0] == 4'b1010) ? 4'd10 : // Q=10
                        (lfsr[3:0] == 4'b1011) ? 4'd10 : // K=10
                        4'd1;                              // A=1

    // Player and dealer sums (5-bit for values up to 31)
    reg [4:0] player_sum;
    reg [4:0] dealer_sum;

    // Ace flags for 1/11 logic
    reg player_has_ace;
    reg dealer_has_ace;

    // Effective sums (with ace 1/11 logic)
    wire [4:0] player_effective_sum = (player_has_ace && (player_sum + 5'd10 <= 5'd21)) ? player_sum + 5'd10 : player_sum;
    wire [4:0] dealer_effective_sum = (dealer_has_ace && (dealer_sum + 5'd10 <= 5'd21)) ? dealer_sum + 5'd10 : dealer_sum;

    // Bust and blackjack flags (using effective sums)
    wire player_bust = (player_effective_sum > 5'd21);
    wire dealer_bust = (dealer_effective_sum > 5'd21);
    wire player_blackjack = (player_effective_sum == 5'd21);
    wire dealer_blackjack = (dealer_effective_sum == 5'd21);

    // Card dealing logic
    reg [2:0] deal_counter; // 0-3 for 4 cards, 4 for done

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            player_sum     <= 5'd0;
            dealer_sum     <= 5'd0;
            deal_counter   <= 3'd0;
            player_has_ace <= 1'b0;
            dealer_has_ace <= 1'b0;
        end else begin
            case (game_state)
                DEAL: begin
                    // Deal 4 cards: player, dealer, player, dealer
                    if (deal_counter < 3'd4) begin
                        deal_counter <= deal_counter + 3'd1;

                        case (deal_counter)
                            3'd0: begin
                                player_sum <= player_sum + {1'b0, card_value};
                                if (card_value == 4'd1) player_has_ace <= 1'b1;
                            end
                            3'd1: begin
                                dealer_sum <= dealer_sum + {1'b0, card_value};
                                if (card_value == 4'd1) dealer_has_ace <= 1'b1;
                            end
                            3'd2: begin
                                player_sum <= player_sum + {1'b0, card_value};
                                if (card_value == 4'd1) player_has_ace <= 1'b1;
                            end
                            3'd3: begin
                                dealer_sum <= dealer_sum + {1'b0, card_value};
                                if (card_value == 4'd1) dealer_has_ace <= 1'b1;
                            end
                        endcase
                    end
                end

                PLAYER_TURN: begin
                    if (hit_btn && !player_bust) begin
                        player_sum <= player_sum + {1'b0, card_value};
                        if (card_value == 4'd1) player_has_ace <= 1'b1;
                    end
                end

                DEALER_TURN: begin
                    if (!dealer_bust && dealer_effective_sum < 5'd17) begin
                        dealer_sum <= dealer_sum + {1'b0, card_value};
                        if (card_value == 4'd1) dealer_has_ace <= 1'b1;
                    end
                end

                default: begin
                    // IDLE, GAME_OVER - no card dealing
                end
            endcase
        end
    end

    // ========================================
    // Win/Lose/Push Logic
    // ========================================

    // Result comparison logic (using effective sums)
    wire player_wins = (player_bust == 1'b0) && (
        dealer_bust ||
        (player_blackjack && !dealer_blackjack) ||
        (!player_blackjack && !dealer_blackjack && player_effective_sum > dealer_effective_sum)
    );

    wire dealer_wins = (dealer_bust == 1'b0) && (
        player_bust ||
        (dealer_blackjack && !player_blackjack) ||
        (!player_blackjack && !dealer_bust && dealer_effective_sum > player_effective_sum)
    );

    wire push = (!player_bust && !dealer_bust) && (
        (player_blackjack && dealer_blackjack) ||
        (player_effective_sum == dealer_effective_sum)
    );

    // ========================================
    // Display Multiplexing
    // ========================================

    // Multiplexing logic for GAME_OVER state
    reg [3:0] mux_counter;
    wire show_player = (game_state == PLAYER_TURN) || (game_state == GAME_OVER && mux_counter[3] == 1'b0);
    wire show_dealer = (game_state == DEALER_TURN) || (game_state == GAME_OVER && mux_counter[3] == 1'b1);

    // Mux counter for alternating display in GAME_OVER
    always @(posedge clk or posedge rst) begin
        if (rst)
            mux_counter <= 4'd0;
        else if (game_state == GAME_OVER)
            mux_counter <= mux_counter + 4'd1;
        else
            mux_counter <= 4'd0;
    end

    // Output assignments
    assign show_player_led = show_player;
    assign show_dealer_led = show_dealer;
    assign win_led  = (game_state == GAME_OVER) && player_wins;
    assign lose_led = (game_state == GAME_OVER) && dealer_wins;
    assign push_led = (game_state == GAME_OVER) && push;

    // Sum output (multiplexed, using effective sums)
    assign sum_out = show_player ? player_effective_sum[2:0] : dealer_effective_sum[2:0];

    // Suppress unused inputs warning
    wire _unused = &{ena, ui_in[7:2], uio_in, 1'b0};

endmodule
