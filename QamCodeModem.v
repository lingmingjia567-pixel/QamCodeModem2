//这是QamCodeModem.v文件的程序清单
//16QAM调制解调系统顶层模块（含载波调制和滤波）
module QamCodeModem (
	rst,clk,din,
	dout,i,q,code_out,mod_out,carrier_real,carrier_imag); 
	
	input		rst;   //复位信号，高电平有效
	input		clk;   //FPGA系统时钟
	input	 [3:0]	din;     //输入的原始数据
	output [3:0]	dout;    //解调后的原始数据
	output [2:0]   i;       //星座映射的I支路数据（实部）
	output [2:0]   q;       //星座映射的Q支路数据（虚部）
	output [3:0]   code_out; //差分编码后的code信号
	output signed [15:0]	mod_out;      //载波调制输出信号
	output signed [17:0]	carrier_real;  //载波实部（cos）
	output signed [17:0]	carrier_imag;  //载波虚部（sin）

	
	//实例化16QAM编码模块
	wire  [2:0] it,qt;
	wire  [3:0] code;
   CodeMap u1 (
	   .rst (rst),
		.clk (clk),
		.din (din),
		.I (it),
		.Q (qt),
		.code_out (code));
		
	//实例化解调模块
   DeCodeMap u2 (
	   .rst (rst),
		.clk (clk),
		.dout (dout),
		.I (it),
		.Q (qt));
		
	//实例化滤波器包装模块
	wire [7:0] i_filtered, q_filtered;
	FilterWrapper u_filter (
		.rst (rst),
		.clk (clk),
		.i_in (it),
		.q_in (qt),
		.i_out (i_filtered),
		.q_out (q_filtered));
		
	//实例化载波调制模块
	CarrierModulator u3 (
		.rst (rst),
		.clk (clk),
		.i (i_filtered),  //使用完整的8位滤波后数据
		.q (q_filtered),
		.mod_out (mod_out),
		.carrier_real (carrier_real),
		.carrier_imag (carrier_imag));
	

	

		
	assign i = it;
	assign q = qt;
	assign code_out = code;
	
endmodule
