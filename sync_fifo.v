`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2026 00:05:55
// Design Name: 
// Module Name: sync_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sync_fifo #(
    parameter data_width=8,
    parameter depth=16,
    parameter addr_width=$clog2(depth)
    )(
    input clk,rst,
    input wr_en,rd_en,
    input [data_width-1:0] din,
    output reg [data_width-1:0] dout,
    output full,empty
    );
    //fifo memory array
    reg[data_width-1:0]mem[0:depth-1]; 
    //pointers
    reg[addr_width-1:0] wr_ptr=0;
    reg[addr_width-1:0] rd_ptr=0;
    //counter
    reg[addr_width:0]cnt;
    
    //full and empty
    assign full=(cnt==depth);
    assign empty=(cnt==0);
    
    always@(posedge clk)
      begin
        if(rst)
          begin
            wr_ptr<=0;
            rd_ptr<=0;
            cnt<=0;
            dout<=0;
          end
        else
          begin
            //write
            if(wr_en&&!full)
              begin
                mem[wr_ptr]<=din;
                wr_ptr<=wr_ptr+1;
              end
            //read
            if(rd_en&&!empty)
              begin
                dout<=mem[rd_ptr];
                rd_ptr<=rd_ptr+1;
              end
            //counter update
            case({wr_en&&!full,rd_en&&!empty})
              2'b10: cnt<=cnt+1;
              2'b01:cnt<=cnt-1;
              2'b11:cnt<=cnt;
              default:cnt<=cnt;
            endcase
          end
      end
    
endmodule

module basys3_fifo_top(
    input CLK100MHZ,
    input BTNU,        // Write Enable
    input BTND,        // Read Enable
    input CPU_RESET,   // Reset
    input [7:0] SW,    // Data Input
    output reg [3:0] an,
    output reg [6:0] seg,
    output [1:0] led   // led[1]=Full, led[0]=Empty
    );

    wire [7:0] fifo_dout;
    wire full, empty;

    // --- 1. Button Debouncing and Edge Detection ---
    wire btnu_clean, btnd_clean;
    reg btnu_d, btnd_d;

    debouncer db_u (.clk(CLK100MHZ), .btn_in(BTNU), .btn_out(btnu_clean));
    debouncer db_d (.clk(CLK100MHZ), .btn_in(BTND), .btn_out(btnd_clean));

    always @(posedge CLK100MHZ) begin
        btnu_d <= btnu_clean;
        btnd_d <= btnd_clean;
    end
    
    wire wr_pulse = btnu_clean & !btnu_d;
    wire rd_pulse = btnd_clean & !btnd_d;

    // --- 2. Instantiate Your Sync FIFO ---
    sync_fifo #(.data_width(8), .depth(16)) my_fifo (
        .clk(CLK100MHZ),
        .rst(CPU_RESET),
        .wr_en(wr_pulse),
        .rd_en(rd_pulse),
        .din(SW),
        .dout(fifo_dout),
        .full(full),
        .empty(empty)
    );
    
    assign led = {full, empty};

    // --- 3. Binary to BCD (0-255) ---
    reg [3:0] d100, d10, d1;
    integer i;
    always @(*) begin
        {d100, d10, d1} = 12'b0;
        for (i = 7; i >= 0; i = i - 1) begin
            if (d1 >= 5)   d1 = d1 + 3;
            if (d10 >= 5)  d10 = d10 + 3;
            if (d100 >= 5) d100 = d100 + 3;
            {d100, d10, d1} = {d100[2:0], d10, d1, fifo_dout[i]};
        end
    end

    // --- 4. Display Refresh and Decoding ---
    reg [17:0] refresh_counter = 0;
    always @(posedge CLK100MHZ) refresh_counter <= refresh_counter + 1;

    reg [3:0] bcd_mux;
    always @(*) begin
        case (refresh_counter[17:16])
            2'b00: begin an = 4'b1110; bcd_mux = d1;    end
            2'b01: begin an = 4'b1101; bcd_mux = d10;   end
            2'b10: begin an = 4'b1011; bcd_mux = d100;  end
            2'b11: begin an = 4'b0111; bcd_mux = 4'hF;  end // Turn off 4th digit
        endcase
    end

    // 7-segment Decoder (Active Low for Basys 3)
    always @(*) begin
        case(bcd_mux)
            4'h0: seg = 7'b1000000; 4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100; 4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001; 4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010; 4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000; 4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111; // Off
        endcase
    end
endmodule

module debouncer(
    input clk,
    input btn_in,
    output reg btn_out
);

    // 2-FF Synchronizer
    reg btn_sync0, btn_sync1;

    always @(posedge clk) begin
        btn_sync0 <= btn_in;
        btn_sync1 <= btn_sync0;
    end

    // Debounce Counter
    reg [15:0] counter = 0;
    reg stable_state = 0;

    always @(posedge clk) begin
        if (btn_sync1 == stable_state) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
            if (counter == 16'hFFFF) begin
                stable_state <= btn_sync1;
                counter <= 0;
            end
        end
    end

    always @(posedge clk)
        btn_out <= stable_state;

endmodule
