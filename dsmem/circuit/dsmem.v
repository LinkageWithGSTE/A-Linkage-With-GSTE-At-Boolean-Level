
module dsmem(clk,rst,shift,d,addr,q);
    parameter	    MSBD = 3;
    parameter	    LAST = 15;
    parameter	    MSBA = 3;
    input	    clk;
    input           rst;
    input [MSBD:0]  d;
    input [MSBA:0]  addr;
    input	    shift;
    output [MSBD:0] q;


    reg [MSBD:0]    mem[0:LAST];
    reg [MSBA:0]    write_addr;
     //wire [MSBA:0]  read_addr;
	integer i;

	initial begin
	for (i = 0; i <= LAST; i = i + 1)
	    mem[i] = 0;
 	write_addr = 0;
    end // initial begin


    always @ (posedge clk) begin
	if (rst) write_addr = 0;
	else if (shift) begin
		mem[write_addr] = d;
	    write_addr = write_addr +1;
	end 
    end // always @ (posedge clock)
	
    assign q = mem[write_addr-1-addr];

endmodule // srFIFO
