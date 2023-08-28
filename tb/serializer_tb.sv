'timescale 1ns / 1ps

parameter PERIOD_CLK = 100;

module testbench();

logic [15:0] data_i;
logic        clk_i;
logic        srst_i;
logic [3:0]  data_mod_i;
logic        data_val_i;

logic        ser_data_o;
logic        ser_data_val_o;
logic        busy_o;

initial 
    begin
        clk_i <= 1;
        #(PERIOD_CLK/2);
        forever 
            begin
                #(PERIOD_CLK/2);
                clk_i <= ~clk_i
            end
    end

initial
    begin
        srst_i <= 0;
        #400
        srst_i <= 1;
    end

initial
    begin
        wait(srst_i)
        data_val_i <= 1;
        busy_o <= 0;
        data_mod_i <= 15;
    end

initial
    begin
        wait((srst_i) & (data_val_i) & (~busy_o));
        data_i <= 16'b1111_1111_1111_1111;
        #1800
        data_i <= 16'b1010_1111_1010_1111;
        data_val_i <= 0;
        #150
        data_valid <= 1;
        #1800
        data_i <= 16'b1111_1010_1111_1010;
    end

serializer 
#(
    .MAX_COUNT(16)
)
DUT
(
    .clk_i (clk_i),
    .data_i (data_i),
    .srst_i (srst_i),
    .data_mod_i (data_mod_i),
    .data_val_i (data_val_i),

    .ser_data_o (ser_data_o),
    .ser_data_val_o (ser_data_val_o),
    .busy_o (busy_o)
);

