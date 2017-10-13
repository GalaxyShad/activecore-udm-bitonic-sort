## See LICENSE file for license details

source ../riscv_pipe.tcl

rtl::module riscv_4stage

	riscv_pipe::declare_wrapper_ports

	pipe::pproc instrpipe clk_i rst_i

		riscv_pipe::declare_pcontext


		pipe::pstage IFETCH

			riscv_pipe::process_pc
			pipe::mcopipe_rdreq instr_mem [cnct {curinstr_addr curinstr_addr}]

		pipe::pstage IDECODE

			pipe::mcopipe_resp instr_mem instr_code
			riscv_pipe::process_decode
			riscv_pipe::process_regfetch

			# pipeline MEM forwarding
			begif [s&& [pipe::isworking MEM] [pipe::prr MEM rd_req]]
				begif [s== [pipe::prr MEM rd_addr] rs1_addr]
					begif [pipe::prr MEM rd_rdy]
						s= rs1_rdata [pipe::prr MEM rd_wdata]
					endif
					begelse
						pipe::pstall
					endif
				endif
				begif [s== [pipe::prr MEM rd_addr] rs2_addr]
					begif [pipe::prr MEM rd_rdy]
						s= rs2_rdata [pipe::prr MEM rd_wdata]
					endif
					begelse
						pipe::pstall
					endif
				endif
			endif

			# pipeline EXEC forwarding
			begif [s&& [pipe::isworking EXEC] [pipe::prr EXEC rd_req]]
				begif [s== [pipe::prr EXEC rd_addr] rs1_addr]
					begif [pipe::prr EXEC rd_rdy]
						s= rs1_rdata [pipe::prr EXEC rd_wdata]
					endif
					begelse
						pipe::pstall
					endif
				endif
				begif [s== [pipe::prr EXEC rd_addr] rs2_addr]
					begif [pipe::prr EXEC rd_rdy]
						s= rs2_rdata [pipe::prr EXEC rd_wdata]
					endif
					begelse
						pipe::pstall
					endif
				endif
			endif

		pipe::pstage EXEC

			riscv_pipe::process_alu
			riscv_pipe::process_rd_csr_prev
			riscv_pipe::process_jump_op
			riscv_pipe::process_mem_reqdata

		pipe::pstage MEM
			
			riscv_pipe::process_branch

			# memory access
			begif mem_req
				begif mem_cmd
					pipe::mcopipe_wrreq data_mem [cnct {mem_addr mem_be mem_wdata}]
				endif
				begelse
					pipe::mcopipe_rdreq data_mem [cnct {mem_addr mem_be mem_wdata}]
					begif [pipe::mcopipe_resp data_mem mem_rdata]
						s= rd_rdy	1
					endif
				endif
			endif

			riscv_pipe::process_rd_mem_wdata
			riscv_pipe::process_wb

	pipe::endpproc

	riscv_pipe::connect_copipes

#endmodule