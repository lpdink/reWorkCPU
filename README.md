相较于repoForCPUDeisn，重写了第一阶段代码，并在重写的基础上完成了第2，3阶段。
thirdcode.txt即第三阶段的指令。
开始进行流水线部分的设计，拆分步骤如下：
1. 参考IR.v，添加四个流水线寄存器.v文件，根据自己对控制信号的定义，完成I/O的定义。
2. 根据寄存器定义，进行实体化。
3. 修改其他部分组件的实体化，使它们支持流水线。
4. 继续回放学习，获得更多关于阻塞与旁路，解决冒险的指导，完成流水线设计。

更新日志：
4-15 完成1。
4-16 
    修正：
	交换了IF_ID.V,ID_EX.V的定义，及文件名
	修正了EX_MEM级reg_rd_out的位定义。
    在ID_EX中补充了EXT_IN及EXT_OUT。
    修改了EX_MEM中控制信号定义MEM2R系列。
    补充：
    在MIPS中添加了各级寄存器的输出定义，对于连续同传的值，根据本级的先一级命名，以做区分。比如IF_ID寄存器的PC_PLUS4_OUT_IF。
    利用补充的EXT_OUT及来自ID/EX级的PC_PLUS4_OUT_ID，实例化了EX/MEM级的位移量拓展后的PC地址，写法非常麻烦，后续验证或许可以修订为：
        PC_PLUS4_OUT_ID+(EXT_OUT<<2)
    MIPS中添加了各级寄存器的实体化，对于连续同传的值根据上述规则进行了区分。

    待完成：
    PCWR信号的决定需要重写，完全遵照多选器的格式，否则会导致各级信号的不区分。
    整个PC部分或许都需要重写，PC的决定应该在回传阶段。
    

