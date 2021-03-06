library verilog;
use verilog.vl_types.all;
entity ID_EX is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ID_EX_WR        : in     vl_logic;
        PC_PLUS4_IN     : in     vl_logic_vector(31 downto 0);
        PC_PLUS4_OUT    : out    vl_logic_vector(31 downto 0);
        INSTR_iN        : in     vl_logic_vector(31 downto 0);
        INSTR_OUT       : out    vl_logic_vector(31 downto 0);
        RD1_IN          : in     vl_logic_vector(31 downto 0);
        RD1_OUT         : out    vl_logic_vector(31 downto 0);
        RD2_IN          : in     vl_logic_vector(31 downto 0);
        RD2_OUT         : out    vl_logic_vector(31 downto 0);
        EXT_IN          : in     vl_logic_vector(31 downto 0);
        EXT_OUT         : out    vl_logic_vector(31 downto 0);
        reg_rd_in       : in     vl_logic_vector(4 downto 0);
        reg_rd_out      : out    vl_logic_vector(4 downto 0);
        RegDst_in       : in     vl_logic;
        RegDst_out      : out    vl_logic;
        Branch_in       : in     vl_logic_vector(1 downto 0);
        Branch_OUT      : out    vl_logic_vector(1 downto 0);
        MemR_in         : in     vl_logic;
        MemR_out        : out    vl_logic;
        Mem2R_in        : in     vl_logic;
        Mem2R_out       : out    vl_logic;
        MemW_in         : in     vl_logic;
        MemW_out        : out    vl_logic;
        RegW_in         : in     vl_logic;
        RegW_out        : out    vl_logic;
        Alusrc_in       : in     vl_logic;
        Alusrc_out      : out    vl_logic;
        EXTOp_in        : in     vl_logic_vector(1 downto 0);
        EXTOp_out       : out    vl_logic_vector(1 downto 0);
        Aluctrl_in      : in     vl_logic_vector(4 downto 0);
        Aluctrl_out     : out    vl_logic_vector(4 downto 0);
        STALL           : in     vl_logic;
        Flush           : in     vl_logic
    );
end ID_EX;
