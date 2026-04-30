// Blackjack - TinyTapout 1x1
// Faz 2-3: Temel Modül + Kart Mantığı

module blackjack (
    input  wire clk,
    input  wire rst,
    input  wire hit_btn,
    input  wire stand_btn,
    output wire show_player_led,
    output wire show_dealer_led,
    output wire win_led,
    output wire lose_led,
    output wire push_led,
    output wire [2:0] sum,
    output wire [2:0] state  // For testing only
);

// State definitions
localparam IDLE         = 3'b000;
localparam DEAL         = 3'b001;
localparam PLAYER_TURN  = 3'b010;
localparam DEALER_TURN  = 3'b011;
localparam GAME_OVER    = 3'b100;

// State register
reg [2:0] state, next_state;

// State transition logic
always @(posedge clk or posedge rst) begin
    if (rst)
        state <= IDLE;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    next_state = state;

    case (state)
        IDLE: begin
            next_state = DEAL;
        end

        DEAL: begin
            // DEAL → PLAYER_TURN when 4 cards dealt
            if (deal_counter == 3'd4)
                next_state = PLAYER_TURN;
        end

        PLAYER_TURN: begin
            // Faz 4: Oyuncu State Geçişleri
            if (player_bust) begin
                next_state = GAME_OVER;
            end else if (player_blackjack) begin
                next_state = GAME_OVER;
            end else if (hit_btn) begin
                next_state = PLAYER_TURN;
            end else if (stand_btn) begin
                next_state = DEALER_TURN;
            end
        end

        DEALER_TURN: begin
            // Faz 5: Dağıtıcı State Geçişleri
            if (dealer_bust || dealer_effective_sum >= 5'd17)
                next_state = GAME_OVER;
        end

        GAME_OVER: begin
            if (rst)
                next_state = IDLE;
        end

        default: begin
            next_state = IDLE;
        end
    endcase
end

// ========================================
// Faz 3: Kart Mantığı
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

// Map LFSR to card value (2-10, simplified)
assign card_value = (lfsr[3:0] == 4'b0000) ? 4'b0010 :  // 2
                    (lfsr[3:0] == 4'b0001) ? 4'b0011 :  // 3
                    (lfsr[3:0] == 4'b0010) ? 4'b0100 :  // 4
                    (lfsr[3:0] == 4'b0011) ? 4'b0101 :  // 5
                    (lfsr[3:0] == 4'b0100) ? 4'b0110 :  // 6
                    (lfsr[3:0] == 4'b0101) ? 4'b0111 :  // 7
                    (lfsr[3:0] == 4'b0110) ? 4'b1000 :  // 8
                    (lfsr[3:0] == 4'b0111) ? 4'b1001 :  // 9
                    (lfsr[3:0] == 4'b1000) ? 4'b1010 :  // 10
                    (lfsr[3:0] == 4'b1001) ? 4'b1010 :  // J=10
                    (lfsr[3:0] == 4'b1010) ? 4'b1010 :  // Q=10
                    (lfsr[3:0] == 4'b1011) ? 4'b1010 :  // K=10
                    4'b0001;                              // A=1

// Player and dealer sums (5-bit for values up to 31)
reg [4:0] player_sum;
reg [4:0] dealer_sum;

// Ace flags for 1/11 logic
reg player_has_ace;
reg dealer_has_ace;

// Effective sums (with ace 1/11 logic)
wire [4:0] player_effective_sum = player_has_ace && (player_sum + 5'd10 <= 5'd21) ? player_sum + 5'd10 : player_sum;
wire [4:0] dealer_effective_sum = dealer_has_ace && (dealer_sum + 5'd10 <= 5'd21) ? dealer_sum + 5'd10 : dealer_sum;

// Bust and blackjack flags (using effective sums)
wire player_bust = (player_effective_sum > 5'd21);
wire dealer_bust = (dealer_effective_sum > 5'd21);
wire player_blackjack = (player_effective_sum == 5'd21);
wire dealer_blackjack = (dealer_effective_sum == 5'd21);

// Card dealing logic
reg deal_card;
reg [2:0] deal_counter; // 0-3 for 4 cards, 4 for done

always @(posedge clk or posedge rst) begin
    if (rst) begin
        player_sum <= 5'd0;
        dealer_sum <= 5'd0;
        deal_card <= 1'b0;
        deal_counter <= 3'd0;
        player_has_ace <= 1'b0;
        dealer_has_ace <= 1'b0;
    end else begin
        deal_card <= 1'b0;

        case (state)
            DEAL: begin
                // Deal 4 cards: player, dealer, player, dealer
                if (deal_counter < 3'd4) begin
                    deal_card <= 1'b1;
                    deal_counter <= deal_counter + 3'd1;

                    case (deal_counter)
                        3'd0: begin
                            player_sum <= player_sum + card_value;
                            if (card_value == 4'b0001) player_has_ace <= 1'b1;  // Ace
                        end
                        3'd1: begin
                            dealer_sum <= dealer_sum + card_value;
                            if (card_value == 4'b0001) dealer_has_ace <= 1'b1;  // Ace
                        end
                        3'd2: begin
                            player_sum <= player_sum + card_value;
                            if (card_value == 4'b0001) player_has_ace <= 1'b1;  // Ace
                        end
                        3'd3: begin
                            dealer_sum <= dealer_sum + card_value;
                            if (card_value == 4'b0001) dealer_has_ace <= 1'b1;  // Ace
                        end
                    endcase
                end
            end

            PLAYER_TURN: begin
                if (hit_btn && !player_bust) begin
                    player_sum <= player_sum + card_value;
                    deal_card <= 1'b1;
                    if (card_value == 4'b0001) player_has_ace <= 1'b1;  // Ace
                end
            end

            DEALER_TURN: begin
                if (!dealer_bust && dealer_effective_sum < 5'd17) begin
                    dealer_sum <= dealer_sum + card_value;
                    deal_card <= 1'b1;
                    if (card_value == 4'b0001) dealer_has_ace <= 1'b1;  // Ace
                end
            end

            GAME_OVER: begin
                if (rst) begin
                    player_sum <= 5'd0;
                    dealer_sum <= 5'd0;
                    deal_counter <= 3'd0;
                    player_has_ace <= 1'b0;
                    dealer_has_ace <= 1'b0;
                end
            end

            default: begin
                deal_counter <= 3'd0;
            end
        endcase
    end
end

// ========================================
// Faz 6: Kazanma Mantığı
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

// Multiplexing logic for GAME_OVER state
reg [3:0] mux_counter;
wire show_player = (state == PLAYER_TURN) || (state == GAME_OVER && mux_counter[3] == 1'b0);
wire show_dealer = (state == DEALER_TURN) || (state == GAME_OVER && mux_counter[3] == 1'b1);

// Mux counter for alternating display in GAME_OVER
always @(posedge clk or posedge rst) begin
    if (rst)
        mux_counter <= 4'd0;
    else if (state == GAME_OVER)
        mux_counter <= mux_counter + 4'd1;
    else
        mux_counter <= 4'd0;
end

// Output logic
assign show_player_led = show_player;
assign show_dealer_led = show_dealer;
assign win_led = (state == GAME_OVER) && player_wins;
assign lose_led = (state == GAME_OVER) && dealer_wins;
assign push_led = (state == GAME_OVER) && push;

// Sum output (multiplexed, using effective sums)
assign sum = show_player ? player_effective_sum[2:0] : dealer_effective_sum[2:0];

endmodule
