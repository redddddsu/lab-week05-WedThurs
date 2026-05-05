module top
(
  input  CLK, //FPGA's clocck

	output LCD_CLK,//LCD clock. 
	output LCD_DEN,
	output [4:0] LCD_R,
	output [5:0] LCD_G,
	output [4:0] LCD_B
);


lcd u_lcd (
    .rst(0),      
    .pclk(CLK),
    .LCD_DE(LCD_DEN),
    .LCD_R(LCD_R),
    .LCD_G(LCD_G),
    .LCD_B(LCD_B)
);
assign LCD_CLK = CLK;

endmodule

module lcd
(
    input  rst,
    input  pclk,        

    output LCD_DE,      // Display Enable

    output [4:0] LCD_B, // 5-bit blue color data
    output [5:0] LCD_G, // 6-bit green color data
    output [4:0] LCD_R  // 5-bit red color data
);

parameter H_ACTIVE = 480;
parameter V_ACTIVE = 272;

parameter H_TOTAL = 525;
parameter V_TOTAL = 285;

logic[10:0] horizontal;
logic[10:0] vertical;

always_ff @(posedge pclk) begin
    if (rst) begin
        horizontal <= 0;
        vertical <= 0;
    end else begin 
        if (horizontal == H_TOTAL - 1) begin
            horizontal <= 0;
            if (vertical == V_TOTAL - 1)
                vertical <= 0;
            else
                vertical <= vertical + 1;
        end else begin
            horizontal <= horizontal + 1;
end
    
    end
end

always_ff @(posedge pclk) begin
    LCD_DE <= (horizontal < H_ACTIVE) && (vertical < V_ACTIVE);
end

always_ff @(posedge pclk) begin
    if (LCD_DE) begin
        if (horizontal < 160) begin
            LCD_R <= 5'b11111; 
            LCD_G <= 0;
            LCD_B <= 0;
        end else if (horizontal < 320) begin
            LCD_R <= 0;
            LCD_G <= 6'b111111; 
            LCD_B <= 0;
        end else begin
            LCD_R <= 0;
            LCD_G <= 0;
            LCD_B <= 5'b11111; 
        end
    end else begin
        LCD_R <= 0;
        LCD_G <= 0;
        LCD_B <= 0;
    end
end



endmodule