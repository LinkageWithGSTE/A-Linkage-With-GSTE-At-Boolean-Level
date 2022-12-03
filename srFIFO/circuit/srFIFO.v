
module srFIFO(clock,rst,dataIn,push,pop,dataOut,full,empty);
    parameter	    MSBD = 3;
    parameter	    LAST = 15;
    parameter	    MSBA = 3;
    input	    clock;
    input           rst;
    input [MSBD:0]  dataIn;
    input	    push;
    input	    pop;
    output [MSBD:0] dataOut;
    output	    full;
    output	    empty;

    reg [MSBD:0]    mem[0:LAST];
    reg [MSBA:0]    tail;
    reg		    empty;
    integer	    i;

    initial begin
	for (i = 0; i <= LAST; i = i + 1)
	    mem[i] = 0;
	tail = 0;
	empty = 1;
    end // initial begin

    always @ (posedge clock) begin
	if (rst) begin tail = 0;
	              empty = 1;
                 end
	else if (push & ~full) begin
	    for (i = LAST; i > 0; i = i - 1)
            mem[i] = mem[i - 1];
            mem[0] = dataIn;
	    if (~empty)
            tail = tail + 1;
            empty = 0;
	end // if (push & ~full)
	else if (pop & ~empty) begin
	    if (tail == 0)
		empty = 1;
	    else
		tail = tail - 1;
	end // if (pop & ~empty)
    end // always @ (posedge clock)

    assign dataOut = mem[tail];
	
    assign full = tail == LAST;

endmodule // srFIFO

