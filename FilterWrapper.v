//这是FilterWrapper.v文件的程序清单
//滤波器包装模块：处理I/Q信号的并行滤波
module FilterWrapper (
    rst, clk, i_in, q_in,
    i_out, q_out
); 
    
    input           rst;        //复位信号，高电平有效
    input           clk;        //FPGA系统时钟
    input   [2:0]   i_in;       //输入I支路数据
    input   [2:0]   q_in;       //输入Q支路数据
    output  [7:0]   i_out;      //输出滤波后的I支路数据
    output  [7:0]   q_out;      //输出滤波后的Q支路数据

    //===========================================
    // 直接传递数据（暂时绕过滤波器）
    //===========================================
    // 信号扩展：3位 → 8位
    assign i_out = {{5{i_in[2]}}, i_in};  //符号扩展到8位
    assign q_out = {{5{q_in[2]}}, q_in};

endmodule
