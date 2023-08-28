'timescale 1ns / 1ps

module serializer
#(
    parameter MAX_COUNT = 16;
) 
(
    input [15:0] data_i,
    input clk_i,
    input srst_i,
    input [3:0] data_mod_i,
    input data_val_i,

    output ser_data_o,
    output ser_data_val_o,
    output busy_o
);

logic [15:0] data;
logic [3:0] data_mod;
logic [4:0] counter;
logic busy_reg;

always_ff @(posedge clk_i)
    begin
        if (srst_i)
            begin
                counter <= '0; 
            end
        else if (counter == MAX_COUNT)
            begin
                counter <= '0;
            end
        else
            begin
                counter <= counter + 1;
            end
    end

always_ff @(posedge clk_i)
    begin
        if (srst_i)
            begin
                temp <= 0;
            end
        else
            begin
                if ((counter == 0) & (data_val_i == 1) & (busy_o != 0) & (data_mod_reg > 2))
                    begin
                        temp <= data_i;
                    end
                else
                    if (counter != MAX_COUNT)
                        begin
                            if (data_mod_reg == 0)
                                begin
                                    temp <= temp << 1;
                                end
                            else
                                if ((data_mod_reg == 1) | (data_mod_reg == 2))
                                    begin
                                        temp = '0;
                                    end
                            else
                                begin
                                    temp <= temp & data_mod_reg;
                                    temp <= temp << 1;
                                end
                        end
                else
                    begin
                        temp <= '0;
                    end
            end
    end

always_ff @(posedge clk_i)
    begin
        if (srst_i)
            begin
                busy_reg <= 0;
            end
        else 
            if (counter > 0)
                begin
                    busy_reg <= 1;
                end
        else
            begin
                busy_reg <= busy_reg;
            end
    end

assign busy_o <= busy_reg;
assign o_data <= temp[15];
assign data_mod_reg <= data_mod_i;

endmodule
