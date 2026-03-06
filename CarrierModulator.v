//这是CarrierModulator.v文件的程序清单
//载波调制模块：基于NCO IP Core的实现
//参考：使用Quartus NCO IP Core生成正交载波，使用8×8有符号乘法器实现混频
module CarrierModulator (
	rst,clk,i,q,
	mod_out,carrier_real,carrier_imag); 
	
	input		rst;        //复位信号，高电平有效
	input		clk;        //FPGA系统时钟
	input	 [7:0]	i;    //基带I支路数据（实部）- 滤波后
	input	 [7:0]	q;    //基带Q支路数据（虚部）- 滤波后
	output signed [15:0]	mod_out;      //调制输出信号
	output signed [17:0]	carrier_real;  //载波实部（cos）
	output signed [17:0]	carrier_imag;  //载波虚部（sin）

	//===========================================
	// 参数定义（匹配MATLAB参数）
	//===========================================
	// Fs = 8 MHz (采样频率)
	// Rs = 1 MHz (符号速率)
	// sps = 8 (每符号采样数)
	// fc = 2 MHz (载波频率)
	
	//===========================================
	// NCO IP Core 实例化
	//===========================================
	// NCO IP Core的正确端口定义
	parameter PHI_INC = 32'd1073741824;  // 相位增量值：(2 MHz × 2^32) / 8 MHz
	
	// NCO输出位宽调整：从18位调整到10位
	wire [17:0] fsin_o;   // NCO正弦输出（18位）
	wire [17:0] fcos_o;   // NCO余弦输出（18位）
	
	nco nco_inst (
		.phi_inc_i(PHI_INC), // 相位增量输入
		.clk(clk),           // 时钟输入
		.reset_n(!rst),      // 复位输入（低电平有效）
		.clken(1'b1),        // 时钟使能，始终使能
		.fsin_o(fsin_o),     // 正弦输出
		.fcos_o(fcos_o),     // 余弦输出
		.out_valid()         // 输出有效（未使用）
	);
	
	// 直接使用NCO的18位输出，不进行量化
	assign carrier_real = fcos_o;  // 余弦输出（18位）
	assign carrier_imag = fsin_o;  // 正弦输出（18位）
	
	//===========================================
	// I/Q数据寄存器对齐（直接使用8位输入）
	//===========================================
	reg signed [7:0] i_reg;
	reg signed [7:0] q_reg;
	
	always @(posedge clk or posedge rst)
		if (rst) begin
			i_reg <= 8'd0;
			q_reg <= 8'd0;
		end
		else begin
			i_reg <= i;  //直接使用8位输入
			q_reg <= q;
		end
	
	//===========================================
	// 8×18有符号乘法器实现混频
	// I·cos 和 Q·sin
	//===========================================
	wire signed [25:0] mult_i_cos;  // I * cos (8位 × 18位 = 26位)
	wire signed [25:0] mult_q_sin;  // Q * sin (8位 × 18位 = 26位)
	
	// 使用Verilog内置乘法器（确保正确的符号处理）
	// 显式类型转换，确保符号正确
	assign mult_i_cos = (i_reg * carrier_real);  // 8位 × 18位 = 26位
	assign mult_q_sin = (q_reg * carrier_imag);  // 8位 × 18位 = 26位
	
	// 乘法结果寄存器对齐
	reg signed [25:0] mult_i_cos_reg;
	reg signed [25:0] mult_q_sin_reg;
	
	always @(posedge clk or posedge rst)
		if (rst) begin
			mult_i_cos_reg <= 26'd0;
			mult_q_sin_reg <= 26'd0;
		end
		else begin
			mult_i_cos_reg <= mult_i_cos;
			mult_q_sin_reg <= mult_q_sin;
		end
	
	//===========================================
	// I/Q路混频结果相加：I·cos - Q·sin
	//===========================================
	wire signed [26:0] mod_result;
	assign mod_result = mult_i_cos_reg - mult_q_sin_reg;
	
	// 输出寄存器（调整截取位宽）
	reg signed [15:0] mod_out_reg;
	
	always @(posedge clk or posedge rst)
		if (rst)
			mod_out_reg <= 16'sd0;
		else
			mod_out_reg <= mod_result[24:9];  //调整截取位置，从26位中取16位
	
	assign mod_out = mod_out_reg;
	
endmodule
