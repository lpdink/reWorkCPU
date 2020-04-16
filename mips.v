module mips();
   reg clk, rst;
//C:/Users/lpdink/Desktop/code.txt
//D:/appDate/QQrefile/testCode/Project1/Test_6_Instr.txt
   initial begin
      $readmemh( "thirdcode.txt" , U_IM.imem ) ;
      $monitor("PC = 0x%8X, IR = 0x%8X", U_PC.PC, instr ); 
      clk = 1 ;
      rst = 0 ;
      #5 ;
      rst = 1 ;
      #20 ;
      rst = 0 ;
   end
   
   always
	   #(50) clk = ~clk;
   //PC
   wire [31:0] NPC;
   wire [31:0] PC;
   reg [1:0] PCWr;
   
   //assign PCWr=((Branch&&Zero)==1)?1:0;

   //EXT
   wire [15:0] Imm16;
   wire [31:0] Imm32;
   wire [25:0] IMM;

   //IM
   wire [4:0] rs,rt,rd,shamt;
   wire [5:0] Op,Funct;
   wire [31:0] im_dout;
   wire [31:0] instr;
   assign instr=im_dout;
   assign Op = instr[31:26];
   assign Funct = instr[5:0];
   assign rs = instr[25:21];
   assign rt = instr[20:16];
   assign rd = instr[15:11];
   assign shamt=instr[10:6];
   assign Imm16 = instr[15:0];
   assign IMM = instr[25:0];//支持J指令。

   //RF
   //assign A3=(RegDst==1)?instr[20:16]:instr[15:11];
   wire [31:0] WD;
   //assign WD= (Mem2R==1)?dm_dout:alu_c;
   wire  [31:0] RD1;
   wire [31:0] RD2;
   wire [31:0] ra;//用于读出32号寄存器存储的PC值
   wire [4:0] A3;

   //ALU
   wire Zero;
   wire [31:0] alu_c;
   wire [31:0] alu_b;
   //assign alu_b = (Alusrc==1)?Imm32:RD2;
   //DM
   wire [31:0] dm_dout;
   wire [9:0] dm_addr;
   //assign dm_addr=alu_c[11:2];
   //CTRL
   wire[1:0] 		jump;						//指令跳转
	wire 		RegDst;						
	wire[1:0] 		Branch;						//分支
	wire 		MemR;						//读存储器
	wire 		Mem2R;						//数据存储器到寄存器堆
	wire 		MemW;						//写数据存储器
	wire 		RegW;						//寄存器堆写入数据
	wire		Alusrc;						//运算器操作数选择
	wire [1:0]		EXTOp;						//位扩展/符号扩展选择
	wire [4:0]  Aluctrl;						//Alu运算选择

   //寄存器写信号
   wire IF_ID_WR;
   wire ID_EX_WR;
   wire EX_MEM_WR;
   wire MEM_EB_WR;

   //寄存器输出
   //IF_ID
   wire [31:0] PC_PLUS4_OUT_IF;
   wire [31:0] INSTR_OUT_IF;
   //ID_EX
   wire [31:0] PC_PLUS4_OUT_ID;
   wire [31:0] INSTR_OUT_ID;
   wire [31:0] RD1_OUT;
   wire [31:0] RD2_OUT;
   wire [31:0] EXT_OUT;
   wire [4:0] reg_rd_out_ID;
   wire [1:0] jump_out;
   wire RegDst_out;
   wire [1:0] Branch_OUT_ID;
   wire MEMR_OUT_ID;
   wire MEM2R_OUT_ID;
   wire MEMW_OUT_ID;
   wire REGW_OUT_ID;
   wire Alusrc_out;
   wire [1:0] EXTOp_out;
   wire [4:0] Aluctrl_out;
   //EX_MEM
  wire  [31:0] NPC_OUT;
  wire  [31:0] ALU_C_OUT;
  wire  [31:0] RT_DATA_OUT;
  wire ZERO_OUT;
  wire reg_rd_out_EX;
  wire [1:0] Branch_OUT_EX;
  wire MEMR_OUT_EX;
  wire MEMW_OUT_EX;
  wire REGW_OUT_EX;
  wire MEM2R_OUT_EX;
   //MEM_WB
  wire [31:0] DM_DATA_OUT;
  wire [31:0] DM_ADRESS_OUT;
  wire [4:0] reg_rd_out_MEM;
  wire REGW_OUT_MEM;
  wire MEM2R_OUT_MEM;

   //mips_tb U_mips_tb();
   //PC：PCWr:input,branch有效且零信号有效为1，决定分支有效。NPC：input,由EXT传来的基于原PC的分支地址。PC：output,当前指令地址，传给im以读出指令。
   assign NPC=(jump==2'b11)?ra:Imm32;
   //if(Branch==2'b01&&Zero)assign PCWr=1;
   //if(Branch==2'b10&&Zero==0)assign PCWr=1;
   //assign PCWr=(((Branch==2'b01&&Zero)||(Branch==2'b10&&Zero==0))==1)?2'b01:2'b00;
   always@(Branch or Zero or jump)begin
   if((Branch==2'b01&&Zero)||(Branch==2'b10&&Zero==0)) PCWr=2'b01;
   else if(Branch==2'b11&&(jump==2'b01||jump==2'b10)) PCWr=2'b10;
   else if(jump==2'b11)PCWr=2'b11;
   else  PCWr=2'b00;
   end
   //assign PCWr=((Branch==2'b10&&Zero==0)==1)?1:0;
   //else assign PCWr=0;
   //assign PCWr=((Branch&&Zero)==1)?1:0;
   /*
   always@(Branch or Zero)
      begin
         case (Branch)
            2'b00: if(Zero)PCWr=1;
            2'b01: if(~Zero)PCWr=1;
         default:  PCWr=0;
         endcase
      end
*/
   //寄存器实体化
   IF_ID U_IF_ID (.clk(clk), .rst(rst), .IF_ID_WR(IF_ID_WR), .PC_PLUS4_IN(PC+4),
                  .PC_PLUS4_OUT(PC_PLUS4_OUT_IF), .INSTR_IN(instr),.INSTR_OUT(INSTR_OUT_IF));

   ID_EX U_ID_EX (.clk(clk), .rst(rst), .ID_EX_WR(ID_EX_WR),.PC_PLUS4_IN(PC_PLUS4_OUT_IF),.PC_PLUS4_OUT(PC_PLUS4_OUT_ID),
               .INSTR_iN(INSTR_OUT_IF),.INSTR_OUT(INSTR_OUT_ID),.RD1_IN(RD1),.RD1_OUT(RD1_OUT),
            .RD2_IN(RD2),.RD2_OUT(RD2_OUT),.EXT_IN(Imm32),.EXT_OUT(EXT_OUT),.reg_rd_in(rs),.reg_rd_out(reg_rd_out_ID),
            .jump_in(jump),.jump_out(jump_out),.RegDst_in(RegDst),.RegDst_out(RegDst_out),.Branch_in(Branch),
            .Branch_OUT(Branch_OUT_ID),.MemR_in(MemR),.MemR_out(MEMR_OUT_ID),
            .Mem2R_in(Mem2R),.Mem2R_out(MEM2R_OUT_ID),.MemW_in(MemW),.MemW_out(MEMW_OUT_ID),.RegW_in(RegW),.RegW_out(REGW_OUT_ID),
            .Alusrc_in(Alusrc),.Alusrc_out(Alusrc_out),.EXTOp_in(EXTOp),.EXTOp_out(EXTOp_out),
            .Aluctrl_in(Aluctrl),.Aluctrl_out(Aluctrl_out));
            //或许后续可以优化为： PC_PLUS4_OUT_ID+(EXT_OUT<<2)


   reg [31:0] EX_NPC;
   reg [31:0] temp;
   integer i;
   always@(PC_PLUS4_OUT_ID or EXT_OUT)
   begin
   for(i=0;i<30;i=i+1) temp[31-i]=EXT_OUT[29-i];

   temp[0]=0;temp[1]=0;

   EX_NPC=PC_PLUS4_OUT_ID+temp;
   end                                        
   EX_MEM U_EX_MEM (.clk(clk), .rst(rst), .EX_MEM_WR(EX_MEM_WR), .NPC_IN(EX_NPC),.NPC_OUT(NPC_OUT),
                     .ALU_C_IN(alu_c),.ALU_C_OUT(ALU_C_OUT),.ZERO_IN(Zero),.ZERO_OUT(ZERO_OUT),.RT_DATA_IN(RD2_OUT),
                     .RT_DATA_OUT(RT_DATA_OUT),.reg_rd_in(reg_rd_out_ID),.reg_rd_out(reg_rd_out_EX),
                     .Branch_IN(Branch_OUT_ID),.Branch_OUT(Branch_OUT_EX),.MEMR_IN(MEMR_OUT_ID),.MEMR_OUT(MEMR_OUT_EX),.MEMW_IN(MEMW_OUT_ID),
                     .MEMW_OUT(MEMW_OUT_EX),.REGW_IN(REGW_OUT_ID),.REGW_OUT(REGW_OUT_EX),.MEM2R_IN(MEM2R_OUT_ID),.MEM2R_OUT(MEM2R_OUT_EX));
   
   MEM_WB U_MEM_WB (.clk(clk), .rst(rst), .MEM_WB_WR(MEM_WB_WR), .DM_ADRESS_IN(dm_addr),.DM_ADRESS_OUT(DM_ADRESS_OUT),
                     .DM_DATA_IN(RT_DATA_OUT),.DM_DATA_OUT(DM_DATA_OUT),.reg_rd_in(reg_rd_out_EX),
                     .reg_rd_out(reg_rd_out_MEM),.REGW_IN(REGW_OUT_EX),.REGW_OUT(REGW_OUT_MEM)
                     .MEM2R_IN(MEM2R_OUT_EX),.MEM2R_OUT(MEM2R_OUT_MEM));
   PC U_PC (
      .clk(clk), .rst(rst), .PCWr(PCWr), .NPC(NPC), .PC(PC),.IMM(IMM)
   ); 
   //IM
   im_4k U_IM ( 
      .addr(PC[11:2]) , .dout(im_dout)
   );
   
   //RF
   assign A3=(jump==2'b10)?5'b11111:((RegDst==1)?instr[20:16]:instr[15:11]);//如果jump决定jal可用，则直接访问寄存器32号。否则进行instr的判断。
   assign WD=(jump==2'b10)?PC+4:( (Mem2R==1)?dm_dout:alu_c);
   RF U_RF (
      .A1(rs), .A2(rt), .A3(A3), .WD(WD), .clk(clk), 
      .RFWr(RegW), .RD1(RD1), .RD2(RD2),.ra(ra)
   );

   //EXT
   assign Imm16 = instr[15:0];
   EXT U_EXT( .Imm16(Imm16), .EXTOp(EXTOp), .Imm32(Imm32) );

   //ALU
   assign alu_b = (Alusrc==1)?Imm32:RD2;
   alu U_alu (.A(RD1), .B(alu_b), .ALUOp(Aluctrl), .C(alu_c), .Zero(Zero),.shamt(shamt));
   //DM
   assign dm_addr=alu_c[11:2];
   dm_4k U_dm_4k( .addr(dm_addr), .din(RD2), .DMWr(MemW), .clk(clk), .dout(dm_dout));//,.dread(MemR) );
   //CTRL
  	Ctrl U_Ctrl(.jump(jump),.RegDst(RegDst),.Branch(Branch),.MemR(MemR),.Mem2R(Mem2R)
				,.MemW(MemW),.RegW(RegW),.Alusrc(Alusrc),.EXTOp(EXTOp),.Aluctrl(Aluctrl)
				,.OpCode(Op),.Funct(Funct));

            
endmodule