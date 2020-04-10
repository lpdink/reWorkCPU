`include "ctrl_encode_def.v"
module alu (A, B, ALUOp, C, Zero);
           
   input  [31:0] A, B;
   input  [4:0]  ALUOp;
   output [31:0] C;
   output        Zero;
   
   reg [31:0] C;
       
   always @( A or B or ALUOp ) begin
      case ( ALUOp )

         `ALUOp_ADDU: C = A + B;
         `ALUOp_SUBU: C = A - B;
         `ALUOp_ADD:  C=A+B;
         `ALUOp_SUB:  C=A-B;
         `ALUOp_OR:   C=A|B;
         `ALUOp_AND:  C=A&B;
         `ALUOp_SLT:  C=(A>B)?1:0;
       
         default:   ;
      endcase
   end // end always;
   
   assign Zero = (A == B) ? 1 : 0;

endmodule
    
