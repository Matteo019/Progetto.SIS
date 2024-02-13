module morra_cinese (
  	input logic CLK,
    input logic [1:0] PRIMO,
    input logic [1:0] SECONDO,
    input logic INIZIA,
    output logic [1:0] MANCHE,
    output logic [1:0] PARTITA
);

    // Define internal signals and variables here
    logic [1:0] player1_last_move, player2_last_move;
    logic [1:0] moves_count, max_manches, manche_result;
    logic [1:0] player1_score, player2_score;

    always_ff @(posedge INIZIA or posedge CLK) begin
        // Implement FSM and game logic here
        if (INIZIA) begin
            // Reset internal signals and variables
            moves_count <= 4;
            max_manches <= {PRIMO, SECONDO};
            manche_result <= 2'b00;
            player1_score <= 2'b00;
            player2_score <= 2'b00;
        end
        else begin
            case (moves_count)
                4: begin
                    if (PRIMO != player1_last_move && SECONDO != player2_last_move) begin
                        // Apply game rules
                        if (PRIMO == 2'b01 && SECONDO == 2'b11) begin
                            manche_result <= 2'b01;
                            player1_score <= player1_score + 1;
                        end
                        else if (PRIMO == 2'b10 && SECONDO == 2'b01) begin
                            manche_result <= 2'b01;
                            player1_score <= player1_score + 1;
                        end
                        else if (PRIMO == 2'b11 && SECONDO == 2'b01) begin
                            manche_result <= 2'b10;
                            player2_score <= player2_score + 1;
                        end
                        else if (PRIMO == 2'b01 && SECONDO == 2'b10) begin
                            manche_result <= 2'b10;
                            player2_score <= player2_score + 1;
                        end
                        else begin
                            manche_result <= 2'b11;
                        end
                        
                        // Update previous moves
                        player1_last_move <= PRIMO;
                        player2_last_move <= SECONDO;
                    end
                    else begin
                        // Manche is not valid
                        manche_result <= 2'b00;
                    end
                    moves_count <= moves_count + 1;
                end
                20: begin
                    if (player1_score > player2_score + 2) begin
                        PARTITA <= 2'b01;
                    end
                    else if (player2_score > player1_score + 2) begin
                        PARTITA <= 2'b10;
                    end
                    else begin
                        PARTITA <= 2'b11;
                    end
                end
                default: begin
                    moves_count <= moves_count + 1;
                end
            endcase
        end
    end

    // Assign output values based on the game results
    always_comb begin
        MANCHE = manche_result;
    end

endmodule