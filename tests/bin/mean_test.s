	.text
	.file	"tests/mean_test.c"
	.file	1 "/usr/lib/llvm-3.8/bin/../lib/clang/3.8.0/include" "stddef.h"
	.file	2 "tests" "mean_test.c"
	.file	3 "/usr/include" "stdint.h"
	.file	4 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	5 "/usr/include" "time.h"
	.file	6 "/usr/include/x86_64-linux-gnu/sys" "timeb.h"
	.section	.rodata.cst4,"aM",@progbits,4
	.align	4
.LCPI0_0:
	.long	1048576000              # float 0.25
.LCPI0_1:
	.long	1065353216              # float 1
	.text
	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
.Lfunc_begin0:
	.loc	2 257 0                 # tests/mean_test.c:257:0
	.cfi_startproc
# BB#0:
	.loc	2 258 17 prologue_end   # tests/mean_test.c:258:17
	pushq	%r15
.Ltmp0:
	.cfi_def_cfa_offset 16
	pushq	%r14
.Ltmp1:
	.cfi_def_cfa_offset 24
	pushq	%r13
.Ltmp2:
	.cfi_def_cfa_offset 32
	pushq	%r12
.Ltmp3:
	.cfi_def_cfa_offset 40
	pushq	%rbx
.Ltmp4:
	.cfi_def_cfa_offset 48
	subq	$16, %rsp
.Ltmp5:
	.cfi_def_cfa_offset 64
.Ltmp6:
	.cfi_offset %rbx, -48
.Ltmp7:
	.cfi_offset %r12, -40
.Ltmp8:
	.cfi_offset %r13, -32
.Ltmp9:
	.cfi_offset %r14, -24
.Ltmp10:
	.cfi_offset %r15, -16
	movl	$394033218, %edi        # imm = 0x177C7842
	callq	new_random1@PLT
	movq	%rax, %rdi
	.loc	2 258 15 is_stmt 0      # tests/mean_test.c:258:15
	movq	%rdi, generator(%rip)
	movl	$24, %ebx
.Ltmp11:
	#DEBUG_VALUE: i <- 0
	jmp	.LBB0_1
	.align	16, 0x90
.LBB0_2:                                # %._crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
.Ltmp12:
	#DEBUG_VALUE: max_iter <- %R8
	#DEBUG_VALUE: offset1 <- %R13
	#DEBUG_VALUE: offset0 <- %R12
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: array_count <- %R14
	.loc	2 262 13 is_stmt 1      # tests/mean_test.c:262:13
	movq	generator(%rip), %rdi
.Ltmp13:
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	.loc	2 261 30 discriminator 1 # tests/mean_test.c:261:30
	movl	$1, %esi
	movl	$500, %edx              # imm = 0x1F4
	callq	random_dist_u32@PLT
	.loc	2 261 30 is_stmt 0      # tests/mean_test.c:261:30
	movl	%eax, %r14d
.Ltmp14:
	#DEBUG_VALUE: array_count <- %R14
	.loc	2 264 13 is_stmt 1      # tests/mean_test.c:264:13
	movq	generator(%rip), %rdi
	.loc	2 263 28 discriminator 1 # tests/mean_test.c:263:28
	movl	$750000, %esi           # imm = 0xB71B0
	movl	$900000, %edx           # imm = 0xDBBA0
	callq	random_dist_u32@PLT
	.loc	2 263 28 is_stmt 0      # tests/mean_test.c:263:28
	movl	%eax, %r15d
.Ltmp15:
	#DEBUG_VALUE: bin_count <- %R15
	.loc	2 266 42 is_stmt 1      # tests/mean_test.c:266:42
	movq	generator(%rip), %rdi
	.loc	2 266 26 is_stmt 0 discriminator 1 # tests/mean_test.c:266:26
	xorl	%esi, %esi
	movl	$15, %edx
	callq	random_dist_u32@PLT
	.loc	2 266 26                # tests/mean_test.c:266:26
	movl	%eax, %r12d
.Ltmp16:
	#DEBUG_VALUE: offset0 <- %R12
	.loc	2 267 42 is_stmt 1      # tests/mean_test.c:267:42
	movq	generator(%rip), %rdi
	.loc	2 266 26 discriminator 1 # tests/mean_test.c:266:26
	xorl	%esi, %esi
	movl	$15, %edx
	.loc	2 267 26 discriminator 1 # tests/mean_test.c:267:26
	callq	random_dist_u32@PLT
	.loc	2 267 26 is_stmt 0      # tests/mean_test.c:267:26
	movl	%eax, %r13d
.Ltmp17:
	#DEBUG_VALUE: offset1 <- %R13
	.loc	2 268 61 is_stmt 1      # tests/mean_test.c:268:61
	movq	generator(%rip), %rdi
	.loc	2 266 26 discriminator 1 # tests/mean_test.c:266:26
	xorl	%esi, %esi
	.loc	2 268 45 discriminator 1 # tests/mean_test.c:268:45
	movl	$12, %edx
	callq	random_dist_u32@PLT
	.loc	2 268 45 is_stmt 0      # tests/mean_test.c:268:45
	movl	%eax, %eax
	vcvtsi2ssq	%rax, %xmm0, %xmm0
	.loc	2 268 43                # tests/mean_test.c:268:43
	vmovss	.LCPI0_0(%rip), %xmm1   # xmm1 = mem[0],zero,zero,zero
	vmulss	%xmm1, %xmm0, %xmm0
	.loc	2 268 35                # tests/mean_test.c:268:35
	vmovss	.LCPI0_1(%rip), %xmm1   # xmm1 = mem[0],zero,zero,zero
	vaddss	%xmm1, %xmm0, %xmm0
	.loc	2 268 30                # tests/mean_test.c:268:30
	vcvtss2sd	%xmm0, %xmm0, %xmm0
.Ltmp18:
	#DEBUG_VALUE: sigma_lower <- [%RSP+8]
	.loc	2 269 61 is_stmt 1      # tests/mean_test.c:269:61
	vmovsd	%xmm0, 8(%rsp)          # 8-byte Spill
	movq	generator(%rip), %rdi
	.loc	2 266 26 discriminator 1 # tests/mean_test.c:266:26
	xorl	%esi, %esi
	.loc	2 268 45 discriminator 1 # tests/mean_test.c:268:45
	movl	$12, %edx
	.loc	2 269 45 discriminator 1 # tests/mean_test.c:269:45
	callq	random_dist_u32@PLT
.Ltmp19:
	.loc	2 269 45 is_stmt 0      # tests/mean_test.c:269:45
	movl	%eax, %eax
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ssq	%rax, %xmm0, %xmm0
	.loc	2 269 43                # tests/mean_test.c:269:43
	vmulss	.LCPI0_0(%rip), %xmm0, %xmm0
	.loc	2 269 35                # tests/mean_test.c:269:35
	vaddss	.LCPI0_1(%rip), %xmm0, %xmm0
	.loc	2 269 30                # tests/mean_test.c:269:30
	vcvtss2sd	%xmm0, %xmm0, %xmm0
.Ltmp20:
	#DEBUG_VALUE: sigma_upper <- [%RSP+0]
	.loc	2 271 13 is_stmt 1      # tests/mean_test.c:271:13
	vmovsd	%xmm0, (%rsp)           # 8-byte Spill
	movq	generator(%rip), %rdi
	.loc	2 266 26 discriminator 1 # tests/mean_test.c:266:26
	xorl	%esi, %esi
	movl	$15, %edx
	.loc	2 270 27 discriminator 1 # tests/mean_test.c:270:27
	callq	random_dist_u32@PLT
.Ltmp21:
	.loc	2 270 27 is_stmt 0      # tests/mean_test.c:270:27
	movl	%eax, %r8d
.Ltmp22:
	#DEBUG_VALUE: max_iter <- %R8
	.loc	2 273 9 is_stmt 1       # tests/mean_test.c:273:9
	movq	%r14, %rdi
	movq	%r15, %rsi
	movq	%r12, %rdx
	movq	%r13, %rcx
	vmovsd	8(%rsp), %xmm0          # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vmovsd	(%rsp), %xmm1           # 8-byte Reload
                                        # xmm1 = mem[0],zero
	callq	test_mean
.Ltmp23:
	.loc	2 260 5 discriminator 1 # tests/mean_test.c:260:5
	decq	%rbx
	jne	.LBB0_2
.Ltmp24:
# BB#3:
	#DEBUG_VALUE: max_iter <- %R8
	#DEBUG_VALUE: offset1 <- %R13
	#DEBUG_VALUE: offset0 <- %R12
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: array_count <- %R14
	.loc	2 278 1                 # tests/mean_test.c:278:1
	xorl	%eax, %eax
	addq	$16, %rsp
	popq	%rbx
	popq	%r12
.Ltmp25:
	popq	%r13
.Ltmp26:
	popq	%r14
.Ltmp27:
	popq	%r15
.Ltmp28:
	retq
.Ltmp29:
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc

	.section	.rodata.cst16,"aM",@progbits,16
	.align	16
.LCPI1_0:
	.long	0                       # 0x0
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	3                       # 0x3
.LCPI1_1:
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	6                       # 0x6
	.long	7                       # 0x7
.LCPI1_2:
	.long	8                       # 0x8
	.long	9                       # 0x9
	.long	10                      # 0xa
	.long	11                      # 0xb
.LCPI1_3:
	.long	12                      # 0xc
	.long	13                      # 0xd
	.long	14                      # 0xe
	.long	15                      # 0xf
.LCPI1_4:
	.long	16                      # 0x10
	.long	17                      # 0x11
	.long	18                      # 0x12
	.long	19                      # 0x13
.LCPI1_5:
	.long	20                      # 0x14
	.long	21                      # 0x15
	.long	22                      # 0x16
	.long	23                      # 0x17
.LCPI1_6:
	.long	24                      # 0x18
	.long	25                      # 0x19
	.long	26                      # 0x1a
	.long	27                      # 0x1b
.LCPI1_7:
	.long	28                      # 0x1c
	.long	29                      # 0x1d
	.long	30                      # 0x1e
	.long	31                      # 0x1f
.LCPI1_9:
	.long	1127219200              # 0x43300000
	.long	1160773632              # 0x45300000
	.long	0                       # 0x0
	.long	0                       # 0x0
.LCPI1_10:
	.quad	4841369599423283200     # double 4503599627370496
	.quad	4985484787499139072     # double 1.9342813113834067E+25
	.section	.rodata.cst8,"aM",@progbits,8
	.align	8
.LCPI1_8:
	.quad	4696837146684686336     # double 1.0E+6
.LCPI1_14:
	.quad	0                       # double 0
	.section	.rodata.cst4,"aM",@progbits,4
	.align	4
.LCPI1_11:
	.long	1199570944              # float 65536
.LCPI1_12:
	.long	2143289344              # float NaN
.LCPI1_13:
	.long	1065353216              # float 1
	.text
	.align	16, 0x90
	.type	test_mean,@function
test_mean:                              # @test_mean
.Lfunc_begin1:
	.loc	2 137 0                 # tests/mean_test.c:137:0
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp30:
	.cfi_def_cfa_offset 16
.Ltmp31:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp32:
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$264, %rsp              # imm = 0x108
.Ltmp33:
	.cfi_offset %rbx, -56
.Ltmp34:
	.cfi_offset %r12, -48
.Ltmp35:
	.cfi_offset %r13, -40
.Ltmp36:
	.cfi_offset %r14, -32
.Ltmp37:
	.cfi_offset %r15, -24
	#DEBUG_VALUE: test_mean:array_count <- %RDI
	#DEBUG_VALUE: test_mean:bin_count <- %RSI
	#DEBUG_VALUE: test_mean:offset0 <- %RDX
	#DEBUG_VALUE: test_mean:offset1 <- %RCX
	#DEBUG_VALUE: test_mean:sigma_lower <- %XMM0
	#DEBUG_VALUE: test_mean:sigma_upper <- %XMM1
	#DEBUG_VALUE: test_mean:max_iter <- %R8
	movq	%r8, -256(%rbp)         # 8-byte Spill
.Ltmp38:
	#DEBUG_VALUE: test_mean:max_iter <- [%RBP+-256]
	vmovsd	%xmm1, -272(%rbp)       # 8-byte Spill
.Ltmp39:
	#DEBUG_VALUE: test_mean:sigma_upper <- [%RBP+-272]
	vmovsd	%xmm0, -280(%rbp)       # 8-byte Spill
.Ltmp40:
	#DEBUG_VALUE: test_mean:sigma_lower <- [%RBP+-280]
	movq	%rcx, %rbx
.Ltmp41:
	#DEBUG_VALUE: test_mean:offset1 <- %RBX
	movq	%rdx, %r13
.Ltmp42:
	#DEBUG_VALUE: test_mean:offset0 <- %R13
	movq	%rsi, %r14
.Ltmp43:
	#DEBUG_VALUE: test_mean:bin_count <- %R14
	movq	%rdi, %r12
.Ltmp44:
	#DEBUG_VALUE: test_mean:array_count <- %R12
	.loc	2 138 58 prologue_end   # tests/mean_test.c:138:58
	movq	generator(%rip), %rdi
	.loc	2 138 49 is_stmt 0      # tests/mean_test.c:138:49
	callq	get_seed@PLT
	movq	%rax, %rcx
	.loc	2 138 5 discriminator 1 # tests/mean_test.c:138:5
	leaq	.L.str(%rip), %rdi
	xorl	%eax, %eax
	movq	%rcx, %rsi
	callq	printf@PLT
	.loc	2 139 5 is_stmt 1       # tests/mean_test.c:139:5
	leaq	.L.str.1(%rip), %rdi
	xorl	%eax, %eax
	movq	%r12, %rsi
	movq	%r14, %rdx
	callq	printf@PLT
	.loc	2 140 5                 # tests/mean_test.c:140:5
	leaq	.L.str.2(%rip), %rdi
	xorl	%eax, %eax
	movq	%r13, %rsi
	movq	%rbx, %rdx
	callq	printf@PLT
	.loc	2 142 5                 # tests/mean_test.c:142:5
	leaq	-1(%r12), %rax
	movq	%rax, -240(%rbp)        # 8-byte Spill
	cmpq	$500, %rax              # imm = 0x1F4
	jae	.LBB1_71
.Ltmp45:
# BB#1:
	#DEBUG_VALUE: test_mean:array_count <- %R12
	#DEBUG_VALUE: test_mean:bin_count <- %R14
	#DEBUG_VALUE: test_mean:offset0 <- %R13
	#DEBUG_VALUE: test_mean:offset1 <- %RBX
	#DEBUG_VALUE: test_mean:sigma_lower <- [%RBP+-280]
	#DEBUG_VALUE: test_mean:sigma_upper <- [%RBP+-272]
	#DEBUG_VALUE: test_mean:max_iter <- [%RBP+-256]
	.loc	2 143 5                 # tests/mean_test.c:143:5
	leaq	-750000(%r14), %rax
	cmpq	$150001, %rax           # imm = 0x249F1
	jae	.LBB1_72
.Ltmp46:
# BB#2:
	#DEBUG_VALUE: test_mean:max_iter <- [%RBP+-256]
	#DEBUG_VALUE: test_mean:sigma_upper <- [%RBP+-272]
	#DEBUG_VALUE: test_mean:sigma_lower <- [%RBP+-280]
	#DEBUG_VALUE: test_mean:offset1 <- %RBX
	#DEBUG_VALUE: test_mean:offset0 <- %R13
	#DEBUG_VALUE: test_mean:bin_count <- %R14
	#DEBUG_VALUE: test_mean:array_count <- %R12
	.loc	2 144 5                 # tests/mean_test.c:144:5
	cmpq	$16, %r13
	jae	.LBB1_73
.Ltmp47:
# BB#3:
	#DEBUG_VALUE: test_mean:array_count <- %R12
	#DEBUG_VALUE: test_mean:bin_count <- %R14
	#DEBUG_VALUE: test_mean:offset0 <- %R13
	#DEBUG_VALUE: test_mean:offset1 <- %RBX
	#DEBUG_VALUE: test_mean:sigma_lower <- [%RBP+-280]
	#DEBUG_VALUE: test_mean:sigma_upper <- [%RBP+-272]
	#DEBUG_VALUE: test_mean:max_iter <- [%RBP+-256]
	.loc	2 145 5                 # tests/mean_test.c:145:5
	cmpq	$16, %rbx
	jae	.LBB1_74
.Ltmp48:
# BB#4:
	#DEBUG_VALUE: test_mean:max_iter <- [%RBP+-256]
	#DEBUG_VALUE: test_mean:sigma_upper <- [%RBP+-272]
	#DEBUG_VALUE: test_mean:sigma_lower <- [%RBP+-280]
	#DEBUG_VALUE: test_mean:offset1 <- %RBX
	#DEBUG_VALUE: test_mean:offset0 <- %R13
	#DEBUG_VALUE: test_mean:bin_count <- %R14
	#DEBUG_VALUE: test_mean:array_count <- %R12
	.loc	2 147 5                 # tests/mean_test.c:147:5
	movq	%rsp, %r15
	addq	$-4000, %r15            # imm = 0xFFFFFFFFFFFFF060
	movq	%r15, %rsp
.Ltmp49:
	#DEBUG_VALUE: i <- 0
	.loc	2 149 27                # tests/mean_test.c:149:27
	xorl	%esi, %esi
	movl	$4000, %edx             # imm = 0xFA0
	movq	%r15, %rdi
	callq	memset@PLT
.Ltmp50:
	.loc	2 98 9                  # tests/mean_test.c:98:9
	movzbl	get_shuffled_array_counts.init(%rip), %eax
	andl	$1, %eax
	cmpl	$1, %eax
	jne	.LBB1_6
.Ltmp51:
# BB#5:                                 # %get_shuffled_array_counts.exit.thread
	#DEBUG_VALUE: test_mean:array_count <- %R12
	#DEBUG_VALUE: test_mean:bin_count <- %R14
	#DEBUG_VALUE: test_mean:offset0 <- %R13
	#DEBUG_VALUE: test_mean:offset1 <- %RBX
	#DEBUG_VALUE: test_mean:sigma_lower <- [%RBP+-280]
	#DEBUG_VALUE: test_mean:sigma_upper <- [%RBP+-272]
	#DEBUG_VALUE: test_mean:max_iter <- [%RBP+-256]
	movq	%rbx, -224(%rbp)        # 8-byte Spill
	.loc	2 104 17                # tests/mean_test.c:104:17
	movq	generator(%rip), %rdi
	.loc	2 104 5 is_stmt 0       # tests/mean_test.c:104:5
	leaq	get_shuffled_array_counts.numbers(%rip), %rsi
	movl	$500, %edx              # imm = 0x1F4
	callq	shuffle_u32@PLT
.Ltmp52:
	#DEBUG_VALUE: i <- 0
	jmp	.LBB1_9
.Ltmp53:
.LBB1_6:                                # %min.iters.checked
	#DEBUG_VALUE: test_mean:array_count <- %R12
	#DEBUG_VALUE: test_mean:bin_count <- %R14
	#DEBUG_VALUE: test_mean:offset0 <- %R13
	#DEBUG_VALUE: test_mean:offset1 <- %RBX
	#DEBUG_VALUE: test_mean:sigma_lower <- [%RBP+-280]
	#DEBUG_VALUE: test_mean:sigma_upper <- [%RBP+-272]
	#DEBUG_VALUE: test_mean:max_iter <- [%RBP+-256]
	.loc	2 154 32 is_stmt 1 discriminator 1 # tests/mean_test.c:154:32
	movb	$1, get_shuffled_array_counts.init(%rip)
	xorl	%eax, %eax
.Ltmp54:
	#DEBUG_VALUE: i <- 0
	vmovdqa	.LCPI1_0(%rip), %xmm8   # xmm8 = [0,1,2,3]
	vmovdqa	.LCPI1_1(%rip), %xmm10  # xmm10 = [4,5,6,7]
	vmovdqa	.LCPI1_2(%rip), %xmm11  # xmm11 = [8,9,10,11]
	vmovdqa	.LCPI1_3(%rip), %xmm12  # xmm12 = [12,13,14,15]
	vmovdqa	.LCPI1_4(%rip), %xmm4   # xmm4 = [16,17,18,19]
	vmovdqa	.LCPI1_5(%rip), %xmm5   # xmm5 = [20,21,22,23]
	vmovdqa	.LCPI1_6(%rip), %xmm6   # xmm6 = [24,25,26,27]
	vmovdqa	.LCPI1_7(%rip), %xmm7   # xmm7 = [28,29,30,31]
	.loc	2 101 24                # tests/mean_test.c:101:24
.Ltmp55:
	leaq	get_shuffled_array_counts.numbers(%rip), %rcx
.Ltmp56:
	.align	16, 0x90
.LBB1_7:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	vmovd	%eax, %xmm0
	vpshufd	$0, %xmm0, %xmm0        # xmm0 = xmm0[0,0,0,0]
	vpaddd	%xmm8, %xmm0, %xmm9
	vpaddd	%xmm10, %xmm0, %xmm1
	vinsertf128	$1, %xmm1, %ymm9, %ymm1
	vpaddd	%xmm11, %xmm0, %xmm9
	vpaddd	%xmm12, %xmm0, %xmm2
	vinsertf128	$1, %xmm2, %ymm9, %ymm2
	vpaddd	%xmm4, %xmm0, %xmm9
	vpaddd	%xmm5, %xmm0, %xmm3
	vinsertf128	$1, %xmm3, %ymm9, %ymm3
	vpaddd	%xmm6, %xmm0, %xmm9
	vpaddd	%xmm7, %xmm0, %xmm0
	vinsertf128	$1, %xmm0, %ymm9, %ymm0
	vmovupd	%ymm1, (%rcx,%rax,4)
	vmovups	%ymm2, 32(%rcx,%rax,4)
	vmovups	%ymm3, 64(%rcx,%rax,4)
	vmovupd	%ymm0, 96(%rcx,%rax,4)
.Ltmp57:
	.loc	2 100 9 discriminator 1 # tests/mean_test.c:100:9
	addq	$32, %rax
	cmpq	$480, %rax              # imm = 0x1E0
	jne	.LBB1_7
.Ltmp58:
# BB#8:                                 # %scalar.ph
	movq	%rbx, -224(%rbp)        # 8-byte Spill
	.loc	2 101 24                # tests/mean_test.c:101:24
.Ltmp59:
	movabsq	$2065879269856, %rax    # imm = 0x1E1000001E0
	movq	%rax, get_shuffled_array_counts.numbers+1920(%rip)
	leaq	get_shuffled_array_counts.numbers(%rip), %rsi
	movabsq	$2074469204450, %rax    # imm = 0x1E3000001E2
	movq	%rax, get_shuffled_array_counts.numbers+1928(%rip)
	movabsq	$2083059139044, %rax    # imm = 0x1E5000001E4
	movq	%rax, get_shuffled_array_counts.numbers+1936(%rip)
	movabsq	$2091649073638, %rax    # imm = 0x1E7000001E6
	movq	%rax, get_shuffled_array_counts.numbers+1944(%rip)
	movabsq	$2100239008232, %rax    # imm = 0x1E9000001E8
	movq	%rax, get_shuffled_array_counts.numbers+1952(%rip)
	movabsq	$2108828942826, %rax    # imm = 0x1EB000001EA
	movq	%rax, get_shuffled_array_counts.numbers+1960(%rip)
	movabsq	$2117418877420, %rax    # imm = 0x1ED000001EC
	movq	%rax, get_shuffled_array_counts.numbers+1968(%rip)
	movabsq	$2126008812014, %rax    # imm = 0x1EF000001EE
	movq	%rax, get_shuffled_array_counts.numbers+1976(%rip)
	movabsq	$2134598746608, %rax    # imm = 0x1F1000001F0
	movq	%rax, get_shuffled_array_counts.numbers+1984(%rip)
	movabsq	$2143188681202, %rax    # imm = 0x1F3000001F2
	movq	%rax, get_shuffled_array_counts.numbers+1992(%rip)
.Ltmp60:
	.loc	2 104 17                # tests/mean_test.c:104:17
	movq	generator(%rip), %rdi
	.loc	2 104 5 is_stmt 0       # tests/mean_test.c:104:5
	movl	$500, %edx              # imm = 0x1F4
	vzeroupper
	callq	shuffle_u32@PLT
	#DEBUG_VALUE: i <- 0
	movb	$1, %al
.Ltmp61:
	.loc	2 155 26 is_stmt 1 discriminator 1 # tests/mean_test.c:155:26
	testq	%r12, %r12
	je	.LBB1_14
.LBB1_9:                                # %.lr.ph43.preheader
	xorl	%edx, %edx
	.loc	2 156 43                # tests/mean_test.c:156:43
.Ltmp62:
	testb	$3, %r12b
	je	.LBB1_12
# BB#10:                                # %.lr.ph43.prol.preheader
	movl	%r12d, %eax
	andl	$3, %eax
	leaq	get_shuffled_array_counts.numbers(%rip), %rcx
	xorl	%edx, %edx
	.loc	2 156 40 is_stmt 0      # tests/mean_test.c:156:40
	leaq	input_data(%rip), %rsi
	.align	16, 0x90
.LBB1_11:                               # %.lr.ph43.prol
                                        # =>This Inner Loop Header: Depth=1
	.loc	2 156 43                # tests/mean_test.c:156:43
	movl	(%rcx), %edi
	.loc	2 156 55                # tests/mean_test.c:156:55
	imulq	%r14, %rdi
	.loc	2 156 40                # tests/mean_test.c:156:40
	leaq	(%rsi,%rdi,2), %rdi
	.loc	2 156 68                # tests/mean_test.c:156:68
	leaq	(%rdi,%r13,2), %rdi
	.loc	2 156 27                # tests/mean_test.c:156:27
	movq	%rdi, (%r15,%rdx,8)
.Ltmp63:
	.loc	2 155 41 is_stmt 1 discriminator 3 # tests/mean_test.c:155:41
	incq	%rdx
.Ltmp64:
	#DEBUG_VALUE: i <- %RDX
	.loc	2 155 5 is_stmt 0 discriminator 1 # tests/mean_test.c:155:5
	addq	$4, %rcx
	cmpq	%rdx, %rax
	jne	.LBB1_11
.Ltmp65:
.LBB1_12:                               # %.lr.ph43.preheader.split
	.loc	2 156 43 is_stmt 1      # tests/mean_test.c:156:43
	cmpq	$3, -240(%rbp)          # 8-byte Folded Reload
	jb	.LBB1_13
# BB#17:                                # %.lr.ph43.preheader.split.split
	movq	%r12, %rax
	subq	%rdx, %rax
	leaq	24(%r15,%rdx,8), %rcx
	leaq	get_shuffled_array_counts.numbers(%rip), %rsi
	leaq	12(%rsi,%rdx,4), %rdx
	.loc	2 156 40 is_stmt 0      # tests/mean_test.c:156:40
	leaq	input_data(%rip), %rsi
	.align	16, 0x90
.LBB1_18:                               # %.lr.ph43
                                        # =>This Inner Loop Header: Depth=1
	.loc	2 156 43                # tests/mean_test.c:156:43
	movl	-12(%rdx), %edi
	.loc	2 156 55                # tests/mean_test.c:156:55
	imulq	%r14, %rdi
	.loc	2 156 40                # tests/mean_test.c:156:40
	leaq	(%rsi,%rdi,2), %rdi
	.loc	2 156 68                # tests/mean_test.c:156:68
	leaq	(%rdi,%r13,2), %rdi
	.loc	2 156 27                # tests/mean_test.c:156:27
	movq	%rdi, -24(%rcx)
	.loc	2 156 43                # tests/mean_test.c:156:43
	movl	-8(%rdx), %edi
	.loc	2 156 55                # tests/mean_test.c:156:55
	imulq	%r14, %rdi
	.loc	2 156 40                # tests/mean_test.c:156:40
	leaq	(%rsi,%rdi,2), %rdi
	.loc	2 156 68                # tests/mean_test.c:156:68
	leaq	(%rdi,%r13,2), %rdi
	.loc	2 156 27                # tests/mean_test.c:156:27
	movq	%rdi, -16(%rcx)
	.loc	2 156 43                # tests/mean_test.c:156:43
	movl	-4(%rdx), %edi
	.loc	2 156 55                # tests/mean_test.c:156:55
	imulq	%r14, %rdi
	.loc	2 156 40                # tests/mean_test.c:156:40
	leaq	(%rsi,%rdi,2), %rdi
	.loc	2 156 68                # tests/mean_test.c:156:68
	leaq	(%rdi,%r13,2), %rdi
	.loc	2 156 27                # tests/mean_test.c:156:27
	movq	%rdi, -8(%rcx)
	.loc	2 156 43                # tests/mean_test.c:156:43
	movl	(%rdx), %edi
	.loc	2 156 55                # tests/mean_test.c:156:55
	imulq	%r14, %rdi
	.loc	2 156 40                # tests/mean_test.c:156:40
	leaq	(%rsi,%rdi,2), %rdi
	.loc	2 156 68                # tests/mean_test.c:156:68
	leaq	(%rdi,%r13,2), %rdi
	.loc	2 156 27                # tests/mean_test.c:156:27
	movq	%rdi, (%rcx)
.Ltmp66:
	.loc	2 155 5 is_stmt 1 discriminator 1 # tests/mean_test.c:155:5
	addq	$32, %rcx
	addq	$16, %rdx
	addq	$-4, %rax
	jne	.LBB1_18
.Ltmp67:
.LBB1_13:
	xorl	%eax, %eax
.LBB1_14:                               # %._crit_edge44
	movl	%eax, -300(%rbp)        # 4-byte Spill
	.loc	2 162 56                # tests/mean_test.c:162:56
.Ltmp68:
	leaq	(%r14,%r14), %rsi
	leaq	-96(%rbp), %rdi
.Ltmp69:
	#DEBUG_VALUE: test_mean:input_page <- [%RDI+0]
	.loc	2 162 9 is_stmt 0       # tests/mean_test.c:162:9
	xorl	%edx, %edx
	callq	init_canary_page@PLT
	.loc	2 162 72                # tests/mean_test.c:162:72
	testl	%eax, %eax
	jne	.LBB1_15
.Ltmp70:
# BB#19:
	#DEBUG_VALUE: test_mean:input_page <- [%RDI+0]
	.loc	2 167 22 is_stmt 1      # tests/mean_test.c:167:22
	movq	-96(%rbp), %rbx
	.loc	2 166 36                # tests/mean_test.c:166:36
	movq	generator(%rip), %rdi
.Ltmp71:
	.loc	2 166 62 is_stmt 0      # tests/mean_test.c:166:62
	leal	-1(%r12), %edx
	.loc	2 166 20                # tests/mean_test.c:166:20
	xorl	%esi, %esi
	callq	random_dist_u32@PLT
	.loc	2 166 5                 # tests/mean_test.c:166:5
	movl	%eax, %eax
	.loc	2 167 9 is_stmt 1       # tests/mean_test.c:167:9
	movq	%rbx, (%r15,%rax,8)
	.loc	2 171 37                # tests/mean_test.c:171:37
	leaq	(,%r14,4), %rsi
	movq	-224(%rbp), %rdx        # 8-byte Reload
	.loc	2 171 58 is_stmt 0      # tests/mean_test.c:171:58
	shlq	$2, %rdx
	leaq	-136(%rbp), %rdi
.Ltmp72:
	#DEBUG_VALUE: test_mean:output_page <- [%RDI+0]
	.loc	2 170 5 is_stmt 1       # tests/mean_test.c:170:5
	callq	init_canary_page@PLT
	.loc	2 173 41                # tests/mean_test.c:173:41
	movq	-136(%rbp), %rax
.Ltmp73:
	#DEBUG_VALUE: test_mean:output_pointer <- [%RBP+-296]
	.loc	2 176 43                # tests/mean_test.c:176:43
	movq	%rax, -296(%rbp)        # 8-byte Spill
	movq	generator(%rip), %rdi
.Ltmp74:
	.loc	2 166 20                # tests/mean_test.c:166:20
	xorl	%esi, %esi
	.loc	2 176 27 discriminator 1 # tests/mean_test.c:176:27
	movl	$3071, %edx             # imm = 0xBFF
	callq	random_dist_u32@PLT
.Ltmp75:
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: test_mean:base <- %EAX
	#DEBUG_VALUE: random_fill:base <- %EAX
	.loc	2 177 5 discriminator 1 # tests/mean_test.c:177:5
	movq	%rax, -232(%rbp)        # 8-byte Spill
	movl	-300(%rbp), %eax        # 4-byte Reload
.Ltmp76:
	testb	%al, %al
	jne	.LBB1_25
# BB#20:                                # %.lr.ph40
	#DEBUG_VALUE: test_mean:output_pointer <- [%RBP+-296]
	xorl	%eax, %eax
	movq	%rax, -248(%rbp)        # 8-byte Spill
	.align	16, 0x90
.LBB1_21:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_23 Depth 2
	testq	%r14, %r14
.Ltmp77:
	#DEBUG_VALUE: i <- 0
	je	.LBB1_24
# BB#22:                                #   in Loop: Header=BB1_21 Depth=1
	.loc	2 178 21                # tests/mean_test.c:178:21
.Ltmp78:
	movq	-248(%rbp), %rax        # 8-byte Reload
	movq	(%r15,%rax,8), %r13
.Ltmp79:
	#DEBUG_VALUE: random_fill:out <- %R13
	.loc	2 178 9 is_stmt 0       # tests/mean_test.c:178:9
	movq	%r14, %rax
.Ltmp80:
	.align	16, 0x90
.LBB1_23:                               # %.lr.ph.i
                                        #   Parent Loop BB1_21 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	.loc	2 110 33 is_stmt 1      # tests/mean_test.c:110:33
	movq	%rax, -224(%rbp)        # 8-byte Spill
	movq	generator(%rip), %rdi
	.loc	2 110 22 is_stmt 0 discriminator 1 # tests/mean_test.c:110:22
.Ltmp81:
	callq	random_u32@PLT
	movl	%eax, %ebx
.Ltmp82:
	#DEBUG_VALUE: r <- %EBX
	.loc	2 111 33 is_stmt 1      # tests/mean_test.c:111:33
	movq	generator(%rip), %rdi
	.loc	2 111 22 is_stmt 0 discriminator 1 # tests/mean_test.c:111:22
.Ltmp83:
	callq	random_u32@PLT
	movq	-232(%rbp), %r9         # 8-byte Reload
.Ltmp84:
	#DEBUG_VALUE: s <- %EAX
	.loc	2 113 22 is_stmt 1      # tests/mean_test.c:113:22
	movl	%ebx, %ecx
	andl	$127, %ecx
	.loc	2 114 11                # tests/mean_test.c:114:11
	movl	%ebx, %edx
	shrl	$10, %edx
.Ltmp85:
	#DEBUG_VALUE: r <- %EDX
	.loc	2 115 16                # tests/mean_test.c:115:16
	leal	(,%rdx,8), %esi
	subl	%edx, %esi
	.loc	2 115 30 is_stmt 0      # tests/mean_test.c:115:30
	andl	$1023, %esi             # imm = 0x3FF
	.loc	2 116 11 is_stmt 1      # tests/mean_test.c:116:11
	shrl	$20, %ebx
.Ltmp86:
	#DEBUG_VALUE: r <- %EBX
	.loc	2 117 16                # tests/mean_test.c:117:16
	leal	(%rbx,%rbx,4), %r8d
	.loc	2 119 16                # tests/mean_test.c:119:16
	leal	(,%rax,8), %edi
	subl	%eax, %edi
	.loc	2 119 30 is_stmt 0      # tests/mean_test.c:119:30
	andl	$1023, %edi             # imm = 0x3FF
	.loc	2 120 11 is_stmt 1      # tests/mean_test.c:120:11
	movl	%eax, %ebx
.Ltmp87:
	shrl	$10, %ebx
.Ltmp88:
	#DEBUG_VALUE: s <- %EBX
	.loc	2 121 16                # tests/mean_test.c:121:16
	leal	(,%rbx,8), %edx
	subl	%ebx, %edx
	.loc	2 121 30 is_stmt 0      # tests/mean_test.c:121:30
	andl	$1023, %edx             # imm = 0x3FF
	.loc	2 122 11 is_stmt 1      # tests/mean_test.c:122:11
	shrl	$20, %eax
.Ltmp89:
	#DEBUG_VALUE: s <- %EAX
	.loc	2 123 16                # tests/mean_test.c:123:16
	leal	(%rax,%rax,2), %eax
.Ltmp90:
	.loc	2 115 11                # tests/mean_test.c:115:11
	leal	(%r9,%rcx,8), %ecx
	.loc	2 117 11                # tests/mean_test.c:117:11
	addl	%r8d, %ecx
	.loc	2 119 11                # tests/mean_test.c:119:11
	addl	%esi, %ecx
	.loc	2 121 11                # tests/mean_test.c:121:11
	addl	%eax, %ecx
	movq	-224(%rbp), %rax        # 8-byte Reload
	.loc	2 123 11                # tests/mean_test.c:123:11
	addl	%edi, %ecx
	.loc	2 125 20                # tests/mean_test.c:125:20
	addl	%edx, %ecx
	.loc	2 125 16 is_stmt 0      # tests/mean_test.c:125:16
	movw	%cx, (%r13)
.Ltmp91:
	.loc	2 109 5 is_stmt 1 discriminator 1 # tests/mean_test.c:109:5
	addq	$2, %r13
	decq	%rax
	jne	.LBB1_23
.Ltmp92:
.LBB1_24:                               # %random_fill.exit
                                        #   in Loop: Header=BB1_21 Depth=1
	movq	-248(%rbp), %rax        # 8-byte Reload
	.loc	2 177 41 discriminator 3 # tests/mean_test.c:177:41
	incq	%rax
.Ltmp93:
	#DEBUG_VALUE: i <- %RAX
	.loc	2 177 5 is_stmt 0 discriminator 1 # tests/mean_test.c:177:5
	movq	%rax, -248(%rbp)        # 8-byte Spill
	cmpq	%r12, %rax
.Ltmp94:
	#DEBUG_VALUE: i <- [%RBP+-248]
	jne	.LBB1_21
.Ltmp95:
.LBB1_25:                               # %._crit_edge41
	.loc	2 181 45 is_stmt 1      # tests/mean_test.c:181:45
	movq	generator(%rip), %rdi
	.loc	2 181 29 is_stmt 0 discriminator 1 # tests/mean_test.c:181:29
	movl	$1, %esi
	movl	$16, %edx
	callq	random_dist_u32@PLT
	movl	%eax, %r13d
.Ltmp96:
	#DEBUG_VALUE: test_mean:thread_count <- %R13D
	.loc	2 184 5 is_stmt 1       # tests/mean_test.c:184:5
	leaq	.L.str.9(%rip), %rdi
	movb	$2, %al
	vmovsd	-280(%rbp), %xmm0       # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vmovsd	-272(%rbp), %xmm1       # 8-byte Reload
                                        # xmm1 = mem[0],zero
	movq	-256(%rbp), %rbx        # 8-byte Reload
	movq	%rbx, %rsi
	callq	printf@PLT
	.loc	2 185 5                 # tests/mean_test.c:185:5
	leaq	.L.str.10(%rip), %rdi
	xorl	%eax, %eax
	movl	%r13d, %esi
	callq	printf@PLT
	.loc	2 186 5                 # tests/mean_test.c:186:5
	leaq	timer_begin(%rip), %rdi
	callq	ftime@PLT
.Ltmp97:
	#DEBUG_VALUE: u16_input:result [bit_piece offset=256 size=64] <- %R14
	#DEBUG_VALUE: u16_input:result [bit_piece offset=192 size=64] <- %R12
	#DEBUG_VALUE: u16_input:result [bit_piece offset=320 size=32] <- 0
	.loc	2 76 12                 # tests/mean_test.c:76:12
	leaq	u16_input_loop(%rip), %rax
	movq	%rax, -184(%rbp)
	leaq	no_op(%rip), %rax
	movq	%rax, -176(%rbp)
	movq	%r15, -168(%rbp)
	movq	%r12, -160(%rbp)
	movq	%r14, -152(%rbp)
	movl	$0, -144(%rbp)
	leaq	-216(%rbp), %rdi
.Ltmp98:
	.loc	2 196 9                 # tests/mean_test.c:196:9
	vmovsd	-280(%rbp), %xmm0       # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vmovsd	-272(%rbp), %xmm1       # 8-byte Reload
                                        # xmm1 = mem[0],zero
	movq	%rbx, %rsi
	callq	mediocre_clipped_mean_functor2@PLT
	.loc	2 190 18                # tests/mean_test.c:190:18
	subq	$80, %rsp
	vmovups	-184(%rbp), %ymm0
	vmovups	-168(%rbp), %ymm1
	vmovups	%ymm1, 16(%rsp)
	vmovups	%ymm0, (%rsp)
	vmovups	-216(%rbp), %ymm0
	vmovups	%ymm0, 48(%rsp)
	movq	-296(%rbp), %rdi        # 8-byte Reload
	movl	%r13d, %esi
	vzeroupper
	callq	mediocre_combine_destroy@PLT
	addq	$80, %rsp
	movl	%eax, -224(%rbp)        # 4-byte Spill
.Ltmp99:
	#DEBUG_VALUE: test_mean:status <- [%RBP+-224]
	.loc	2 200 5                 # tests/mean_test.c:200:5
	leaq	.L.str.11(%rip), %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	.loc	2 201 50                # tests/mean_test.c:201:50
	movq	%r14, %rbx
	imulq	%r12, %rbx
.Ltmp100:
	#DEBUG_VALUE: print_timer_elapsed:item_count <- %RBX
	.loc	2 201 5 is_stmt 0       # tests/mean_test.c:201:5
	movq	timer_begin(%rip), %r13
.Ltmp101:
	#DEBUG_VALUE: print_timer_elapsed:before [bit_piece offset=0 size=64] <- %R13
	#DEBUG_VALUE: ms_elapsed:before [bit_piece offset=0 size=64] <- %R13
	movzwl	timer_begin+8(%rip), %eax
	.file	7 "src/inline" "testing.h"
	.loc	7 71 5 is_stmt 1        # src/inline/testing.h:71:5
.Ltmp102:
	movq	%rax, -232(%rbp)        # 8-byte Spill
	leaq	-56(%rbp), %rdi
.Ltmp103:
	#DEBUG_VALUE: ms_elapsed:now <- [%RDI+0]
	callq	ftime@PLT
	.loc	7 73 31                 # src/inline/testing.h:73:31
	movq	-56(%rbp), %rax
	.loc	7 73 38 is_stmt 0       # src/inline/testing.h:73:38
	movzwl	-48(%rbp), %esi
.Ltmp104:
	.loc	7 78 15 is_stmt 1 discriminator 1 # src/inline/testing.h:78:15
	subq	%r13, %rax
	imulq	$1000, %rax, %rax       # imm = 0x3E8
	.loc	7 73 36                 # src/inline/testing.h:73:36
.Ltmp105:
	subq	-232(%rbp), %rsi        # 8-byte Folded Reload
	.loc	7 74 19                 # src/inline/testing.h:74:19
	addq	%rax, %rsi
.Ltmp106:
	#DEBUG_VALUE: print_timer_elapsed:ms <- %RSI
	.loc	7 79 26                 # src/inline/testing.h:79:26
	vcvtsi2sdq	%rsi, %xmm0, %xmm0
	.loc	7 79 29 is_stmt 0       # src/inline/testing.h:79:29
	vmulsd	.LCPI1_8(%rip), %xmm0, %xmm0
	.loc	7 79 37                 # src/inline/testing.h:79:37
	vmovq	%rbx, %xmm1
	vpunpckldq	.LCPI1_9(%rip), %xmm1, %xmm1 # xmm1 = xmm1[0],mem[0],xmm1[1],mem[1]
	vsubpd	.LCPI1_10(%rip), %xmm1, %xmm1
	vhaddpd	%xmm1, %xmm1, %xmm1
	.loc	7 79 35                 # src/inline/testing.h:79:35
	vdivsd	%xmm1, %xmm0, %xmm0
.Ltmp107:
	#DEBUG_VALUE: print_timer_elapsed:ns_per_item <- %XMM0
	.loc	7 80 5 is_stmt 1        # src/inline/testing.h:80:5
	leaq	.L.str.18(%rip), %rdi
.Ltmp108:
	movb	$1, %al
	callq	printf@PLT
.Ltmp109:
	.loc	2 202 5                 # tests/mean_test.c:202:5
	leaq	.Lstr(%rip), %rdi
	callq	puts@PLT
	.loc	2 204 9                 # tests/mean_test.c:204:9
	cmpl	$0, -224(%rbp)          # 4-byte Folded Reload
.Ltmp110:
	#DEBUG_VALUE: u16_input:result [bit_piece offset=0 size=64] <- %RAX
	#DEBUG_VALUE: u16_input:result [bit_piece offset=64 size=64] <- %RAX
	jne	.LBB1_75
.Ltmp111:
# BB#26:                                # %.preheader14
	#DEBUG_VALUE: u16_input:result [bit_piece offset=64 size=64] <- %RAX
	#DEBUG_VALUE: print_timer_elapsed:ns_per_item <- %XMM0
	#DEBUG_VALUE: print_timer_elapsed:ms <- %RSI
	#DEBUG_VALUE: ms_elapsed:before [bit_piece offset=0 size=64] <- %R13
	#DEBUG_VALUE: print_timer_elapsed:before [bit_piece offset=0 size=64] <- %R13
	#DEBUG_VALUE: print_timer_elapsed:item_count <- %RBX
	#DEBUG_VALUE: test_mean:status <- [%RBP+-224]
	movq	-256(%rbp), %rcx        # 8-byte Reload
	.loc	2 213 44 discriminator 1 # tests/mean_test.c:213:44
.Ltmp112:
	incq	%rcx
	.loc	2 216 34                # tests/mean_test.c:216:34
.Ltmp113:
	movl	%r12d, %r10d
	andl	$1, %r10d
.Ltmp114:
	.loc	2 211 9                 # tests/mean_test.c:211:9
	movq	%r10, -288(%rbp)        # 8-byte Spill
	leaq	8(%r15), %rax
.Ltmp115:
	movq	%rax, -264(%rbp)        # 8-byte Spill
	.loc	2 218 27                # tests/mean_test.c:218:27
.Ltmp116:
	vmovss	.LCPI1_13(%rip), %xmm6  # xmm6 = mem[0],zero,zero,zero
                                        # implicit-def: %XMM3
	movq	%rcx, %r8
	vmovsd	-272(%rbp), %xmm8       # 8-byte Reload
                                        # xmm8 = mem[0],zero
	vmovsd	-280(%rbp), %xmm5       # 8-byte Reload
                                        # xmm5 = mem[0],zero
	movl	-300(%rbp), %r13d       # 4-byte Reload
.Ltmp117:
	.align	16, 0x90
.LBB1_27:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_28 Depth 2
                                        #       Child Loop BB1_42 Depth 3
                                        #       Child Loop BB1_55 Depth 3
	vpxor	%xmm7, %xmm7, %xmm7
.Ltmp118:
	#DEBUG_VALUE: it <- 0
	vmovss	.LCPI1_11(%rip), %xmm0  # xmm0 = mem[0],zero,zero,zero
	vmovaps	%xmm0, %xmm4
	movl	$0, %r11d
	testq	%r8, %r8
.Ltmp119:
	#DEBUG_VALUE: upper_bound <- 6.553600e+04
	#DEBUG_VALUE: lower_bound <- 0.000000e+00
	je	.LBB1_33
	.align	16, 0x90
.LBB1_28:                               # %.preheader
                                        #   Parent Loop BB1_27 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_42 Depth 3
                                        #       Child Loop BB1_55 Depth 3
	vxorps	%xmm0, %xmm0, %xmm0
	.loc	2 215 13 discriminator 1 # tests/mean_test.c:215:13
	testb	%r13b, %r13b
	je	.LBB1_34
# BB#29:                                #   in Loop: Header=BB1_28 Depth=2
	vmovss	.LCPI1_12(%rip), %xmm1  # xmm1 = mem[0],zero,zero,zero
	vmovaps	%xmm1, %xmm3
	vxorps	%xmm1, %xmm1, %xmm1
	jmp	.LBB1_30
	.align	16, 0x90
.LBB1_34:                               # %.lr.ph23.preheader
                                        #   in Loop: Header=BB1_28 Depth=2
	vxorpd	%xmm1, %xmm1, %xmm1
	movl	$0, %ecx
	vxorps	%xmm2, %xmm2, %xmm2
	testq	%r10, %r10
	je	.LBB1_40
# BB#35:                                # %.lr.ph23.prol
                                        #   in Loop: Header=BB1_28 Depth=2
	.loc	2 216 34                # tests/mean_test.c:216:34
.Ltmp120:
	movq	(%r15), %rax
	.loc	2 216 27 is_stmt 0      # tests/mean_test.c:216:27
	movzwl	-2(%rax,%r14,2), %eax
	vcvtsi2ssl	%eax, %xmm0, %xmm3
.Ltmp121:
	#DEBUG_VALUE: n <- %XMM3
	#DEBUG_VALUE: sum <- %XMM3
	.loc	2 217 23 is_stmt 1      # tests/mean_test.c:217:23
	vucomiss	%xmm7, %xmm3
	setb	%al
	.loc	2 217 43 is_stmt 0 discriminator 1 # tests/mean_test.c:217:43
	vucomiss	%xmm3, %xmm4
	setb	%cl
	.loc	2 217 38                # tests/mean_test.c:217:38
	orb	%al, %cl
.Ltmp122:
	#DEBUG_VALUE: count <- 1.000000e+00
	vxorpd	%xmm1, %xmm1, %xmm1
	vxorps	%xmm2, %xmm2, %xmm2
	jne	.LBB1_37
.Ltmp123:
# BB#36:                                # %.lr.ph23.prol
                                        #   in Loop: Header=BB1_28 Depth=2
	#DEBUG_VALUE: sum <- %XMM3
	#DEBUG_VALUE: n <- %XMM3
	vmovaps	%xmm3, %xmm2
.Ltmp124:
.LBB1_37:                               # %.lr.ph23.prol
                                        #   in Loop: Header=BB1_28 Depth=2
	#DEBUG_VALUE: sum <- %XMM3
	#DEBUG_VALUE: n <- %XMM3
	jne	.LBB1_39
.Ltmp125:
# BB#38:                                # %.lr.ph23.prol
                                        #   in Loop: Header=BB1_28 Depth=2
	#DEBUG_VALUE: n <- %XMM3
	#DEBUG_VALUE: sum <- %XMM3
	vmovaps	%xmm6, %xmm1
.Ltmp126:
.LBB1_39:                               # %.lr.ph23.prol
                                        #   in Loop: Header=BB1_28 Depth=2
	#DEBUG_VALUE: n <- %XMM3
	#DEBUG_VALUE: sum <- %XMM3
	#DEBUG_VALUE: a <- 1
	movl	$1, %ecx
.Ltmp127:
.LBB1_40:                               # %.lr.ph23.preheader.split
                                        #   in Loop: Header=BB1_28 Depth=2
	cmpq	$0, -240(%rbp)          # 8-byte Folded Reload
	je	.LBB1_47
# BB#41:                                # %.lr.ph23.preheader.split.split
                                        #   in Loop: Header=BB1_28 Depth=2
	.loc	2 216 34 is_stmt 1      # tests/mean_test.c:216:34
	movq	%r12, %rax
	subq	%rcx, %rax
	movq	-264(%rbp), %rdx        # 8-byte Reload
	leaq	(%rdx,%rcx,8), %rcx
	.align	16, 0x90
.LBB1_42:                               # %.lr.ph23
                                        #   Parent Loop BB1_27 Depth=1
                                        #     Parent Loop BB1_28 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movq	-8(%rcx), %rsi
	movq	(%rcx), %rdi
	.loc	2 216 27 is_stmt 0      # tests/mean_test.c:216:27
	movzwl	-2(%rsi,%r14,2), %esi
	vcvtsi2ssl	%esi, %xmm0, %xmm3
.Ltmp128:
	#DEBUG_VALUE: n <- %XMM3
	.loc	2 217 23 is_stmt 1      # tests/mean_test.c:217:23
	vucomiss	%xmm7, %xmm3
	setb	%bl
	.loc	2 217 43 is_stmt 0 discriminator 1 # tests/mean_test.c:217:43
	vucomiss	%xmm3, %xmm4
	setb	%dl
	.loc	2 217 38                # tests/mean_test.c:217:38
	orb	%bl, %dl
	jne	.LBB1_44
.Ltmp129:
# BB#43:                                # %.lr.ph23
                                        #   in Loop: Header=BB1_42 Depth=3
	#DEBUG_VALUE: n <- %XMM3
	.loc	2 218 27 is_stmt 1      # tests/mean_test.c:218:27
	vaddss	%xmm6, %xmm1, %xmm1
.Ltmp130:
	#DEBUG_VALUE: count <- %XMM1
	.loc	2 219 25                # tests/mean_test.c:219:25
	vaddss	%xmm3, %xmm2, %xmm2
.Ltmp131:
	#DEBUG_VALUE: sum <- %XMM2
.LBB1_44:                               # %.lr.ph23
                                        #   in Loop: Header=BB1_42 Depth=3
	#DEBUG_VALUE: n <- %XMM3
	.loc	2 216 27                # tests/mean_test.c:216:27
	movzwl	-2(%rdi,%r14,2), %edx
	vcvtsi2ssl	%edx, %xmm0, %xmm3
.Ltmp132:
	.loc	2 217 23                # tests/mean_test.c:217:23
	vucomiss	%xmm7, %xmm3
	setb	%dl
	.loc	2 217 43 is_stmt 0 discriminator 1 # tests/mean_test.c:217:43
	vucomiss	%xmm3, %xmm4
	setb	%bl
	.loc	2 217 38                # tests/mean_test.c:217:38
	orb	%dl, %bl
	jne	.LBB1_46
# BB#45:                                # %.lr.ph23
                                        #   in Loop: Header=BB1_42 Depth=3
	.loc	2 218 27 is_stmt 1      # tests/mean_test.c:218:27
.Ltmp133:
	vaddss	%xmm6, %xmm1, %xmm1
	.loc	2 219 25                # tests/mean_test.c:219:25
	vaddss	%xmm3, %xmm2, %xmm2
.Ltmp134:
.LBB1_46:                               # %.lr.ph23
                                        #   in Loop: Header=BB1_42 Depth=3
	.loc	2 215 13 discriminator 1 # tests/mean_test.c:215:13
	addq	$16, %rcx
	addq	$-2, %rax
	jne	.LBB1_42
.Ltmp135:
.LBB1_47:                               # %._crit_edge24
                                        #   in Loop: Header=BB1_28 Depth=2
	.loc	2 222 32                # tests/mean_test.c:222:32
	vdivss	%xmm1, %xmm2, %xmm3
.Ltmp136:
	#DEBUG_VALUE: a <- 0
	#DEBUG_VALUE: ss <- 0.000000e+00
	#DEBUG_VALUE: clipped_mean <- %XMM3
	.loc	2 224 13 discriminator 1 # tests/mean_test.c:224:13
	testb	%r13b, %r13b
	jne	.LBB1_30
.Ltmp137:
# BB#48:                                # %.lr.ph29.preheader
                                        #   in Loop: Header=BB1_28 Depth=2
	#DEBUG_VALUE: clipped_mean <- %XMM3
	vxorps	%xmm0, %xmm0, %xmm0
	movl	$0, %ecx
	testq	%r10, %r10
	je	.LBB1_53
.Ltmp138:
# BB#49:                                # %.lr.ph29.prol
                                        #   in Loop: Header=BB1_28 Depth=2
	#DEBUG_VALUE: clipped_mean <- %XMM3
	.loc	2 225 34                # tests/mean_test.c:225:34
	movq	(%r15), %rax
	.loc	2 225 27 is_stmt 0      # tests/mean_test.c:225:27
	movzwl	-2(%rax,%r14,2), %eax
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ssl	%eax, %xmm0, %xmm2
.Ltmp139:
	#DEBUG_VALUE: n <- %XMM2
	.loc	2 226 23 is_stmt 1      # tests/mean_test.c:226:23
	vucomiss	%xmm7, %xmm2
	vxorps	%xmm0, %xmm0, %xmm0
	jb	.LBB1_52
.Ltmp140:
# BB#50:                                # %.lr.ph29.prol
                                        #   in Loop: Header=BB1_28 Depth=2
	#DEBUG_VALUE: clipped_mean <- %XMM3
	#DEBUG_VALUE: n <- %XMM2
	vucomiss	%xmm2, %xmm4
	movl	$1, %ecx
	jb	.LBB1_53
.Ltmp141:
# BB#51:                                #   in Loop: Header=BB1_28 Depth=2
	#DEBUG_VALUE: n <- %XMM2
	#DEBUG_VALUE: clipped_mean <- %XMM3
	.loc	2 227 36                # tests/mean_test.c:227:36
	vsubss	%xmm3, %xmm2, %xmm0
	.loc	2 227 34 is_stmt 0      # tests/mean_test.c:227:34
	vcvtss2sd	%xmm0, %xmm0, %xmm0
.Ltmp142:
	#DEBUG_VALUE: dev <- %XMM0
	.loc	2 228 31 is_stmt 1      # tests/mean_test.c:228:31
	vmulsd	%xmm0, %xmm0, %xmm0
.Ltmp143:
	.loc	2 228 24 is_stmt 0      # tests/mean_test.c:228:24
	vaddsd	.LCPI1_14(%rip), %xmm0, %xmm0
.Ltmp144:
.LBB1_52:                               # %.lr.ph29.preheader.split
                                        #   in Loop: Header=BB1_28 Depth=2
	#DEBUG_VALUE: clipped_mean <- %XMM3
	#DEBUG_VALUE: n <- %XMM2
	#DEBUG_VALUE: ss <- %XMM0
	movl	$1, %ecx
.Ltmp145:
.LBB1_53:                               # %.lr.ph29.preheader.split
                                        #   in Loop: Header=BB1_28 Depth=2
	#DEBUG_VALUE: clipped_mean <- %XMM3
	cmpq	$0, -240(%rbp)          # 8-byte Folded Reload
	je	.LBB1_30
.Ltmp146:
# BB#54:                                # %.lr.ph29.preheader.split.split
                                        #   in Loop: Header=BB1_28 Depth=2
	#DEBUG_VALUE: clipped_mean <- %XMM3
	.loc	2 225 34 is_stmt 1      # tests/mean_test.c:225:34
	movq	%r12, %rax
	subq	%rcx, %rax
	movq	-264(%rbp), %rdx        # 8-byte Reload
	leaq	(%rdx,%rcx,8), %rcx
.Ltmp147:
	.align	16, 0x90
.LBB1_55:                               # %.lr.ph29
                                        #   Parent Loop BB1_27 Depth=1
                                        #     Parent Loop BB1_28 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movq	-8(%rcx), %rdx
	.loc	2 225 27 is_stmt 0      # tests/mean_test.c:225:27
	movzwl	-2(%rdx,%r14,2), %edx
	vcvtsi2ssl	%edx, %xmm0, %xmm2
.Ltmp148:
	#DEBUG_VALUE: n <- %XMM2
	.loc	2 226 23 is_stmt 1      # tests/mean_test.c:226:23
	vucomiss	%xmm7, %xmm2
	jb	.LBB1_58
.Ltmp149:
# BB#56:                                # %.lr.ph29
                                        #   in Loop: Header=BB1_55 Depth=3
	#DEBUG_VALUE: n <- %XMM2
	vucomiss	%xmm2, %xmm4
	jb	.LBB1_58
.Ltmp150:
# BB#57:                                #   in Loop: Header=BB1_55 Depth=3
	#DEBUG_VALUE: n <- %XMM2
	.loc	2 227 36                # tests/mean_test.c:227:36
	vsubss	%xmm3, %xmm2, %xmm2
.Ltmp151:
	.loc	2 227 34 is_stmt 0      # tests/mean_test.c:227:34
	vcvtss2sd	%xmm2, %xmm2, %xmm2
.Ltmp152:
	#DEBUG_VALUE: dev <- %XMM2
	.loc	2 228 31 is_stmt 1      # tests/mean_test.c:228:31
	vmulsd	%xmm2, %xmm2, %xmm2
.Ltmp153:
	.loc	2 228 24 is_stmt 0      # tests/mean_test.c:228:24
	vaddsd	%xmm2, %xmm0, %xmm0
.Ltmp154:
	#DEBUG_VALUE: ss <- %XMM0
.LBB1_58:                               # %.lr.ph29.183
                                        #   in Loop: Header=BB1_55 Depth=3
	.loc	2 225 34 is_stmt 1      # tests/mean_test.c:225:34
	movq	(%rcx), %rdx
	.loc	2 225 27 is_stmt 0      # tests/mean_test.c:225:27
	movzwl	-2(%rdx,%r14,2), %edx
	vcvtsi2ssl	%edx, %xmm0, %xmm2
	.loc	2 226 23 is_stmt 1      # tests/mean_test.c:226:23
.Ltmp155:
	vucomiss	%xmm7, %xmm2
	jb	.LBB1_61
# BB#59:                                # %.lr.ph29.183
                                        #   in Loop: Header=BB1_55 Depth=3
	vucomiss	%xmm2, %xmm4
	jb	.LBB1_61
# BB#60:                                #   in Loop: Header=BB1_55 Depth=3
	.loc	2 227 36                # tests/mean_test.c:227:36
.Ltmp156:
	vsubss	%xmm3, %xmm2, %xmm2
	.loc	2 227 34 is_stmt 0      # tests/mean_test.c:227:34
	vcvtss2sd	%xmm2, %xmm2, %xmm2
	.loc	2 228 31 is_stmt 1      # tests/mean_test.c:228:31
	vmulsd	%xmm2, %xmm2, %xmm2
	.loc	2 228 24 is_stmt 0      # tests/mean_test.c:228:24
	vaddsd	%xmm2, %xmm0, %xmm0
.Ltmp157:
.LBB1_61:                               #   in Loop: Header=BB1_55 Depth=3
	.loc	2 224 13 is_stmt 1 discriminator 1 # tests/mean_test.c:224:13
	addq	$16, %rcx
	addq	$-2, %rax
	jne	.LBB1_55
.Ltmp158:
	.align	16, 0x90
.LBB1_30:                               # %._crit_edge30
                                        #   in Loop: Header=BB1_28 Depth=2
	.loc	2 231 35                # tests/mean_test.c:231:35
	vcvtss2sd	%xmm1, %xmm1, %xmm1
	.loc	2 231 33 is_stmt 0      # tests/mean_test.c:231:33
	vdivsd	%xmm1, %xmm0, %xmm1
	.loc	2 231 25 discriminator 1 # tests/mean_test.c:231:25
	vxorps	%xmm0, %xmm0, %xmm0
	vsqrtsd	%xmm1, %xmm0, %xmm0
	.loc	2 231 20                # tests/mean_test.c:231:20
	vucomisd	%xmm0, %xmm0
	jnp	.LBB1_32
# BB#31:                                # %call.sqrt
                                        #   in Loop: Header=BB1_28 Depth=2
	vmovapd	%xmm1, %xmm0
	movq	%r8, %rbx
	vmovss	%xmm7, -224(%rbp)       # 4-byte Spill
	vmovss	%xmm4, -232(%rbp)       # 4-byte Spill
	movq	%r11, -248(%rbp)        # 8-byte Spill
	vmovss	%xmm3, -256(%rbp)       # 4-byte Spill
	callq	sqrt@PLT
	vmovss	-256(%rbp), %xmm3       # 4-byte Reload
                                        # xmm3 = mem[0],zero,zero,zero
	movq	-248(%rbp), %r11        # 8-byte Reload
	vmovss	-232(%rbp), %xmm4       # 4-byte Reload
                                        # xmm4 = mem[0],zero,zero,zero
	vmovss	-224(%rbp), %xmm7       # 4-byte Reload
                                        # xmm7 = mem[0],zero,zero,zero
	.loc	2 218 27 is_stmt 1      # tests/mean_test.c:218:27
.Ltmp159:
	vmovss	.LCPI1_13(%rip), %xmm6  # xmm6 = mem[0],zero,zero,zero
	movq	-288(%rbp), %r10        # 8-byte Reload
	vmovsd	-280(%rbp), %xmm5       # 8-byte Reload
                                        # xmm5 = mem[0],zero
	vmovsd	-272(%rbp), %xmm8       # 8-byte Reload
                                        # xmm8 = mem[0],zero
	movq	%rbx, %r8
.Ltmp160:
.LBB1_32:                               # %._crit_edge30.split
                                        #   in Loop: Header=BB1_28 Depth=2
	.loc	2 232 36                # tests/mean_test.c:232:36
	vcvtss2sd	%xmm3, %xmm3, %xmm1
.Ltmp161:
	#DEBUG_VALUE: sd <- %XMM0
	.loc	2 232 62 is_stmt 0      # tests/mean_test.c:232:62
	vmulsd	%xmm5, %xmm0, %xmm2
	.loc	2 232 49                # tests/mean_test.c:232:49
	vsubsd	%xmm2, %xmm1, %xmm2
	.loc	2 232 28                # tests/mean_test.c:232:28
	vcvtsd2ss	%xmm2, %xmm2, %xmm2
.Ltmp162:
	#DEBUG_VALUE: new_lb <- %XMM2
	.loc	2 233 62 is_stmt 1      # tests/mean_test.c:233:62
	vmulsd	%xmm8, %xmm0, %xmm0
.Ltmp163:
	.loc	2 233 49 is_stmt 0      # tests/mean_test.c:233:49
	vaddsd	%xmm0, %xmm1, %xmm0
	.loc	2 233 28                # tests/mean_test.c:233:28
	vcvtsd2ss	%xmm0, %xmm0, %xmm0
.Ltmp164:
	#DEBUG_VALUE: new_ub <- %XMM0
	.loc	2 235 27 is_stmt 1      # tests/mean_test.c:235:27
	vmaxss	%xmm2, %xmm7, %xmm7
.Ltmp165:
	#DEBUG_VALUE: lower_bound <- %XMM7
	.loc	2 236 27                # tests/mean_test.c:236:27
	vminss	%xmm0, %xmm4, %xmm4
.Ltmp166:
	#DEBUG_VALUE: upper_bound <- %XMM4
	.loc	2 213 49 discriminator 3 # tests/mean_test.c:213:49
	incq	%r11
.Ltmp167:
	#DEBUG_VALUE: it <- %R11
	.loc	2 213 32 is_stmt 0 discriminator 1 # tests/mean_test.c:213:32
	cmpq	%r8, %r11
	jne	.LBB1_28
.Ltmp168:
.LBB1_33:                               # %._crit_edge36
                                        #   in Loop: Header=BB1_27 Depth=1
	.loc	2 211 9 is_stmt 1       # tests/mean_test.c:211:9
	leaq	-1(%r14), %rsi
.Ltmp169:
	#DEBUG_VALUE: test_mean:i <- %RSI
	.loc	2 238 29                # tests/mean_test.c:238:29
	movq	-296(%rbp), %rax        # 8-byte Reload
	vmovss	-4(%rax,%r14,4), %xmm1  # xmm1 = mem[0],zero,zero,zero
.Ltmp170:
	.loc	2 238 13 is_stmt 0      # tests/mean_test.c:238:13
	vucomiss	%xmm1, %xmm3
	jne	.LBB1_62
	jnp	.LBB1_67
	jmp	.LBB1_62
.Ltmp171:
.LBB1_67:                               #   in Loop: Header=BB1_27 Depth=1
	#DEBUG_VALUE: test_mean:i <- %RSI
	movq	%rsi, %r14
	.loc	2 246 5 is_stmt 1 discriminator 1 # tests/mean_test.c:246:5
	testq	%rsi, %rsi
	jne	.LBB1_27
.Ltmp172:
# BB#68:
	#DEBUG_VALUE: test_mean:i <- %RSI
	.loc	2 248 8                 # tests/mean_test.c:248:8
	subq	$48, %rsp
	movq	-104(%rbp), %rax
	movq	%rax, 32(%rsp)
	vmovups	-136(%rbp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	check_canary_page@PLT
	addq	$48, %rsp
.Ltmp173:
	.loc	2 248 8 is_stmt 0       # tests/mean_test.c:248:8
	testl	%eax, %eax
	js	.LBB1_69
.Ltmp174:
# BB#70:
	#DEBUG_VALUE: test_mean:i <- %RSI
	.loc	2 253 5 is_stmt 1       # tests/mean_test.c:253:5
	subq	$48, %rsp
	movq	-64(%rbp), %rax
	movq	%rax, 32(%rsp)
	vmovups	-96(%rbp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	free_canary_page@PLT
	addq	$48, %rsp
	.loc	2 254 5                 # tests/mean_test.c:254:5
	subq	$48, %rsp
	movq	-104(%rbp), %rax
	movq	%rax, 32(%rsp)
	vmovups	-136(%rbp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	free_canary_page@PLT
	.loc	2 255 1                 # tests/mean_test.c:255:1
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Ltmp175:
.LBB1_62:
	#DEBUG_VALUE: test_mean:i <- %RSI
	.loc	2 239 44                # tests/mean_test.c:239:44
	vcvtss2sd	%xmm3, %xmm3, %xmm0
	.loc	2 239 58 is_stmt 0      # tests/mean_test.c:239:58
	vcvtss2sd	%xmm1, %xmm1, %xmm1
	.loc	2 239 13                # tests/mean_test.c:239:13
	leaq	.L.str.14(%rip), %rdi
	movb	$2, %al
	callq	printf@PLT
.Ltmp176:
	#DEBUG_VALUE: a <- 0
	.loc	2 240 13 is_stmt 1 discriminator 1 # tests/mean_test.c:240:13
	testb	%r13b, %r13b
	jne	.LBB1_65
.Ltmp177:
# BB#63:
	#DEBUG_VALUE: test_mean:i <- %RSI
	.loc	2 241 17                # tests/mean_test.c:241:17
	leaq	.L.str.15(%rip), %rbx
.Ltmp178:
	.align	16, 0x90
.LBB1_64:                               # %.lr.ph
                                        # =>This Inner Loop Header: Depth=1
	.loc	2 241 31 is_stmt 0      # tests/mean_test.c:241:31
	movq	(%r15), %rax
	movzwl	-2(%rax,%r14,2), %esi
	.loc	2 241 17                # tests/mean_test.c:241:17
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
.Ltmp179:
	.loc	2 240 13 is_stmt 1 discriminator 1 # tests/mean_test.c:240:13
	addq	$8, %r15
	decq	%r12
	jne	.LBB1_64
.Ltmp180:
.LBB1_65:                               # %._crit_edge
	.loc	2 243 13                # tests/mean_test.c:243:13
	leaq	.Lstr.20(%rip), %rdi
.LBB1_66:                               # %._crit_edge
	callq	puts@PLT
	.loc	2 244 13                # tests/mean_test.c:244:13
	movl	$1, %edi
	callq	exit@PLT
.Ltmp181:
.LBB1_71:
	#DEBUG_VALUE: test_mean:array_count <- %R12
	#DEBUG_VALUE: test_mean:bin_count <- %R14
	#DEBUG_VALUE: test_mean:offset0 <- %R13
	#DEBUG_VALUE: test_mean:offset1 <- %RBX
	#DEBUG_VALUE: test_mean:sigma_lower <- [%RBP+-280]
	#DEBUG_VALUE: test_mean:sigma_upper <- [%RBP+-272]
	#DEBUG_VALUE: test_mean:max_iter <- [%RBP+-256]
	.loc	2 142 5 discriminator 3 # tests/mean_test.c:142:5
	leaq	.L.str.3(%rip), %rdi
	leaq	.L.str.4(%rip), %rsi
	leaq	.L__PRETTY_FUNCTION__.test_mean(%rip), %rcx
	movl	$142, %edx
	callq	__assert_fail@PLT
.Ltmp182:
.LBB1_72:
	#DEBUG_VALUE: test_mean:max_iter <- [%RBP+-256]
	#DEBUG_VALUE: test_mean:sigma_upper <- [%RBP+-272]
	#DEBUG_VALUE: test_mean:sigma_lower <- [%RBP+-280]
	#DEBUG_VALUE: test_mean:offset1 <- %RBX
	#DEBUG_VALUE: test_mean:offset0 <- %R13
	#DEBUG_VALUE: test_mean:bin_count <- %R14
	#DEBUG_VALUE: test_mean:array_count <- %R12
	.loc	2 143 5 discriminator 3 # tests/mean_test.c:143:5
	leaq	.L.str.5(%rip), %rdi
	leaq	.L.str.4(%rip), %rsi
	leaq	.L__PRETTY_FUNCTION__.test_mean(%rip), %rcx
	movl	$143, %edx
	callq	__assert_fail@PLT
.Ltmp183:
.LBB1_73:
	#DEBUG_VALUE: test_mean:array_count <- %R12
	#DEBUG_VALUE: test_mean:bin_count <- %R14
	#DEBUG_VALUE: test_mean:offset0 <- %R13
	#DEBUG_VALUE: test_mean:offset1 <- %RBX
	#DEBUG_VALUE: test_mean:sigma_lower <- [%RBP+-280]
	#DEBUG_VALUE: test_mean:sigma_upper <- [%RBP+-272]
	#DEBUG_VALUE: test_mean:max_iter <- [%RBP+-256]
	.loc	2 144 5 discriminator 2 # tests/mean_test.c:144:5
	leaq	.L.str.6(%rip), %rdi
	leaq	.L.str.4(%rip), %rsi
	leaq	.L__PRETTY_FUNCTION__.test_mean(%rip), %rcx
	movl	$144, %edx
	callq	__assert_fail@PLT
.Ltmp184:
.LBB1_74:
	#DEBUG_VALUE: test_mean:max_iter <- [%RBP+-256]
	#DEBUG_VALUE: test_mean:sigma_upper <- [%RBP+-272]
	#DEBUG_VALUE: test_mean:sigma_lower <- [%RBP+-280]
	#DEBUG_VALUE: test_mean:offset1 <- %RBX
	#DEBUG_VALUE: test_mean:offset0 <- %R13
	#DEBUG_VALUE: test_mean:bin_count <- %R14
	#DEBUG_VALUE: test_mean:array_count <- %R12
	.loc	2 145 5 discriminator 2 # tests/mean_test.c:145:5
	leaq	.L.str.7(%rip), %rdi
	leaq	.L.str.4(%rip), %rsi
	leaq	.L__PRETTY_FUNCTION__.test_mean(%rip), %rcx
	movl	$145, %edx
	callq	__assert_fail@PLT
.Ltmp185:
.LBB1_15:
	#DEBUG_VALUE: test_mean:input_page <- [%RDI+0]
	.loc	2 163 9                 # tests/mean_test.c:163:9
	leaq	.L.str.8(%rip), %rdi
.Ltmp186:
	jmp	.LBB1_16
.Ltmp187:
.LBB1_75:
	#DEBUG_VALUE: u16_input:result [bit_piece offset=64 size=64] <- %RAX
	#DEBUG_VALUE: print_timer_elapsed:ns_per_item <- %XMM0
	#DEBUG_VALUE: print_timer_elapsed:ms <- %RSI
	#DEBUG_VALUE: ms_elapsed:before [bit_piece offset=0 size=64] <- %R13
	#DEBUG_VALUE: print_timer_elapsed:before [bit_piece offset=0 size=64] <- %R13
	#DEBUG_VALUE: print_timer_elapsed:item_count <- %RBX
	#DEBUG_VALUE: test_mean:status <- [%RBP+-224]
	.loc	2 205 9                 # tests/mean_test.c:205:9
	leaq	.L.str.13(%rip), %rdi
.Ltmp188:
.LBB1_16:
	.loc	2 163 9                 # tests/mean_test.c:163:9
	callq	perror@PLT
	.loc	2 164 9                 # tests/mean_test.c:164:9
	movl	$1, %edi
	callq	exit@PLT
.Ltmp189:
.LBB1_69:
	#DEBUG_VALUE: test_mean:i <- %RSI
	.loc	2 249 9                 # tests/mean_test.c:249:9
	leaq	.Lstr.19(%rip), %rdi
	jmp	.LBB1_66
.Ltmp190:
.Lfunc_end1:
	.size	test_mean, .Lfunc_end1-test_mean
	.cfi_endproc
	.file	8 "include" "mediocre.h"

	.align	16, 0x90
	.type	u16_input_loop,@function
u16_input_loop:                         # @u16_input_loop
.Lfunc_begin2:
	.loc	2 34 0                  # tests/mean_test.c:34:0
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp191:
	.cfi_def_cfa_offset 16
	pushq	%r15
.Ltmp192:
	.cfi_def_cfa_offset 24
	pushq	%r14
.Ltmp193:
	.cfi_def_cfa_offset 32
	pushq	%r13
.Ltmp194:
	.cfi_def_cfa_offset 40
	pushq	%r12
.Ltmp195:
	.cfi_def_cfa_offset 48
	pushq	%rbx
.Ltmp196:
	.cfi_def_cfa_offset 56
	subq	$88, %rsp
.Ltmp197:
	.cfi_def_cfa_offset 144
.Ltmp198:
	.cfi_offset %rbx, -56
.Ltmp199:
	.cfi_offset %r12, -48
.Ltmp200:
	.cfi_offset %r13, -40
.Ltmp201:
	.cfi_offset %r14, -32
.Ltmp202:
	.cfi_offset %r15, -24
.Ltmp203:
	.cfi_offset %rbp, -16
	#DEBUG_VALUE: u16_input_loop:dimension [bit_piece offset=0 size=64] <- %RDX
	#DEBUG_VALUE: u16_input_loop:dimension [bit_piece offset=64 size=64] <- %RCX
	#DEBUG_VALUE: u16_input_loop:control <- %RDI
	#DEBUG_VALUE: u16_input_loop:user_data <- %RSI
	movq	%rsi, %r12
.Ltmp204:
	#DEBUG_VALUE: u16_input_loop:user_data <- %R12
	movq	%rdi, %r14
.Ltmp205:
	#DEBUG_VALUE: u16_input_loop:control <- %R14
	leaq	48(%rsp), %rdi
	.loc	2 40 5 prologue_end     # tests/mean_test.c:40:5
.Ltmp206:
	movq	%r14, %rsi
	callq	mediocre_input_control_get@PLT
	.loc	2 40 5 is_stmt 0 discriminator 1 # tests/mean_test.c:40:5
.Ltmp207:
	cmpq	$0, 48(%rsp)
	jne	.LBB2_12
.Ltmp208:
# BB#1:                                 # %.preheader.lr.ph
	#DEBUG_VALUE: u16_input_loop:control <- %R14
	#DEBUG_VALUE: u16_input_loop:user_data <- %R12
	#DEBUG_VALUE: u16_input_loop:dimension [bit_piece offset=64 size=64] <- %RCX
	.loc	2 40 5 discriminator 3  # tests/mean_test.c:40:5
	movq	80(%rsp), %r13
.Ltmp209:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=256 size=64] <- %R13
	movq	72(%rsp), %r11
.Ltmp210:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=192 size=64] <- %R11
	movq	56(%rsp), %r8
.Ltmp211:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=64 size=64] <- %R8
	movq	64(%rsp), %r15
.Ltmp212:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=128 size=64] <- %R15
	.align	16, 0x90
.LBB2_2:                                # %.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_4 Depth 2
                                        #       Child Loop BB2_9 Depth 3
	.loc	2 46 42 is_stmt 1 discriminator 1 # tests/mean_test.c:46:42
	testq	%r15, %r15
	je	.LBB2_11
# BB#3:                                 # %.lr.ph4
                                        #   in Loop: Header=BB2_2 Depth=1
	.loc	8 267 13                # include/mediocre.h:267:13
.Ltmp213:
	movl	%r11d, %r9d
	andl	$1, %r9d
	xorl	%ecx, %ecx
.Ltmp214:
	.align	16, 0x90
.LBB2_4:                                #   Parent Loop BB2_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_9 Depth 3
	testq	%r11, %r11
.Ltmp215:
	#DEBUG_VALUE: n <- 0
	je	.LBB2_10
# BB#5:                                 # %.lr.ph.preheader
                                        #   in Loop: Header=BB2_4 Depth=2
	.loc	2 47 44                 # tests/mean_test.c:47:44
	movq	(%r12,%rcx,8), %r10
	movl	$0, %edx
	testq	%r9, %r9
	je	.LBB2_7
# BB#6:                                 # %.lr.ph.prol
                                        #   in Loop: Header=BB2_4 Depth=2
	.loc	8 279 13                # include/mediocre.h:279:13
.Ltmp216:
	movq	%rcx, %rax
	shlq	$5, %rax
.Ltmp217:
	#DEBUG_VALUE: mediocre_chunk_ptr:chunk_ptr <- %R13
	#DEBUG_VALUE: mediocre_chunk_ptr:width_axis <- 1
	.loc	2 52 22                 # tests/mean_test.c:52:22
	movzwl	(%r10,%r8,2), %edi
	vcvtsi2ssl	%edi, %xmm0, %xmm0
	.loc	2 52 20 is_stmt 0       # tests/mean_test.c:52:20
	vmovss	%xmm0, (%r13,%rax)
.Ltmp218:
	#DEBUG_VALUE: n <- 1
	movl	$1, %edx
.Ltmp219:
.LBB2_7:                                # %.lr.ph.preheader.split
                                        #   in Loop: Header=BB2_4 Depth=2
	cmpq	$1, %r11
	je	.LBB2_10
# BB#8:                                 # %.lr.ph.preheader.split.split
                                        #   in Loop: Header=BB2_4 Depth=2
	.loc	8 267 13 is_stmt 1      # include/mediocre.h:267:13
.Ltmp220:
	leaq	2(%r10,%r8,2), %rdi
	.align	16, 0x90
.LBB2_9:                                # %.lr.ph
                                        #   Parent Loop BB2_2 Depth=1
                                        #     Parent Loop BB2_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	.loc	8 273 47                # include/mediocre.h:273:47
	movq	%rdx, %rax
	shrq	$3, %rax
	.loc	8 273 52 is_stmt 0      # include/mediocre.h:273:52
	imulq	%r15, %rax
	.loc	8 273 32                # include/mediocre.h:273:32
	shlq	$5, %rax
	addq	%r13, %rax
.Ltmp221:
	#DEBUG_VALUE: mediocre_chunk_ptr:chunk_ptr <- %RAX
	.loc	8 277 36 is_stmt 1      # include/mediocre.h:277:36
	movq	%rcx, %rbx
	shlq	$5, %rbx
	addq	%rbx, %rax
.Ltmp222:
	#DEBUG_VALUE: mediocre_chunk_ptr:vector_ptr <- %RAX
	.loc	8 279 47                # include/mediocre.h:279:47
	movl	%edx, %esi
	andl	$7, %esi
.Ltmp223:
	.loc	2 52 22                 # tests/mean_test.c:52:22
	movzwl	-2(%rdi,%rdx,2), %ebp
	vcvtsi2ssl	%ebp, %xmm0, %xmm0
	.loc	2 52 20 is_stmt 0       # tests/mean_test.c:52:20
	vmovss	%xmm0, (%rax,%rsi,4)
.Ltmp224:
	.loc	2 49 44 is_stmt 1 discriminator 3 # tests/mean_test.c:49:44
	leaq	1(%rdx), %rax
.Ltmp225:
	#DEBUG_VALUE: mediocre_chunk_ptr:width_axis <- %RAX
	#DEBUG_VALUE: n <- %RAX
	.loc	8 273 47                # include/mediocre.h:273:47
	movq	%rax, %rsi
	shrq	$3, %rsi
	.loc	8 273 52 is_stmt 0      # include/mediocre.h:273:52
	imulq	%r15, %rsi
	.loc	8 273 32                # include/mediocre.h:273:32
	shlq	$5, %rsi
	addq	%r13, %rsi
	.loc	8 277 36 is_stmt 1      # include/mediocre.h:277:36
	addq	%rbx, %rsi
	.loc	8 279 47                # include/mediocre.h:279:47
	andl	$7, %eax
.Ltmp226:
	.loc	2 52 22                 # tests/mean_test.c:52:22
	movzwl	(%rdi,%rdx,2), %ebp
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ssl	%ebp, %xmm0, %xmm0
	.loc	2 52 20 is_stmt 0       # tests/mean_test.c:52:20
	vmovss	%xmm0, (%rsi,%rax,4)
.Ltmp227:
	.loc	2 49 44 is_stmt 1 discriminator 3 # tests/mean_test.c:49:44
	addq	$2, %rdx
	.loc	2 49 34 is_stmt 0 discriminator 1 # tests/mean_test.c:49:34
	cmpq	%rdx, %r11
	jne	.LBB2_9
.Ltmp228:
.LBB2_10:                               # %._crit_edge
                                        #   in Loop: Header=BB2_4 Depth=2
	.loc	2 46 58 is_stmt 1 discriminator 3 # tests/mean_test.c:46:58
	incq	%rcx
.Ltmp229:
	#DEBUG_VALUE: array_i <- %RCX
	#DEBUG_VALUE: mediocre_chunk_ptr:combine_axis <- %RCX
	.loc	2 46 42 is_stmt 0 discriminator 1 # tests/mean_test.c:46:42
	cmpq	%r15, %rcx
	jne	.LBB2_4
.Ltmp230:
.LBB2_11:                               # %._crit_edge5
                                        #   in Loop: Header=BB2_2 Depth=1
	leaq	8(%rsp), %rdi
	.loc	2 40 5 is_stmt 1 discriminator 2 # tests/mean_test.c:40:5
	movq	%r14, %rsi
	callq	mediocre_input_control_get@PLT
	.loc	2 40 5 is_stmt 0 discriminator 4 # tests/mean_test.c:40:5
.Ltmp231:
	movq	16(%rsp), %r8
.Ltmp232:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=64 size=64] <- %R8
	movq	24(%rsp), %r15
.Ltmp233:
	#DEBUG_VALUE: mediocre_chunk_ptr:combine_count <- %R15
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=128 size=64] <- %R15
	movq	32(%rsp), %r11
.Ltmp234:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=192 size=64] <- %R11
	movq	40(%rsp), %r13
.Ltmp235:
	#DEBUG_VALUE: mediocre_chunk_ptr:chunks <- %R13
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=256 size=64] <- %R13
	.loc	2 40 5 discriminator 1  # tests/mean_test.c:40:5
	cmpq	$0, 8(%rsp)
	je	.LBB2_2
.Ltmp236:
.LBB2_12:                               # %._crit_edge10
	.loc	2 56 1 is_stmt 1        # tests/mean_test.c:56:1
	addq	$88, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Ltmp237:
.Lfunc_end2:
	.size	u16_input_loop, .Lfunc_end2-u16_input_loop
	.cfi_endproc
	.file	9 "/usr/lib/llvm-3.8/bin/../lib/clang/3.8.0/include" "avxintrin.h"

	.align	16, 0x90
	.type	no_op,@function
no_op:                                  # @no_op
.Lfunc_begin3:
	.loc	2 58 0                  # tests/mean_test.c:58:0
	.cfi_startproc
# BB#0:
	#DEBUG_VALUE: no_op:ignored <- %RDI
	.loc	2 60 1 prologue_end     # tests/mean_test.c:60:1
	retq
.Ltmp238:
.Lfunc_end3:
	.size	no_op, .Lfunc_end3-no_op
	.cfi_endproc

	.type	generator,@object       # @generator
	.local	generator
	.comm	generator,8,8
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Seed = %llu\n"
	.size	.L.str, 13

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"\tAveraging %zi arrays of %zi integers.\n"
	.size	.L.str.1, 40

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"\tinput offset %zi output offset %zi.\n"
	.size	.L.str.2, 38

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"min_array_count <= array_count && array_count <= max_array_count"
	.size	.L.str.3, 65

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"tests/mean_test.c"
	.size	.L.str.4, 18

	.type	.L__PRETTY_FUNCTION__.test_mean,@object # @__PRETTY_FUNCTION__.test_mean
.L__PRETTY_FUNCTION__.test_mean:
	.asciz	"void test_mean(size_t, size_t, size_t, size_t, double, double, size_t)"
	.size	.L__PRETTY_FUNCTION__.test_mean, 71

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"min_bin_count <= bin_count && bin_count <= max_bin_count"
	.size	.L.str.5, 57

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"offset0 <= max_offset"
	.size	.L.str.6, 22

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"offset1 <= max_offset"
	.size	.L.str.7, 22

	.type	input_data,@object      # @input_data
	.local	input_data
	.comm	input_data,900000032,16
	.type	.L.str.8,@object        # @.str.8
.L.str.8:
	.asciz	"test_mean init_canary_page"
	.size	.L.str.8, 27

	.type	.L.str.9,@object        # @.str.9
.L.str.9:
	.asciz	"sigma[-%f, %f] max_iter %zi\n"
	.size	.L.str.9, 29

	.type	.L.str.10,@object       # @.str.10
.L.str.10:
	.asciz	"thread_count = %i\n"
	.size	.L.str.10, 19

	.type	timer_begin,@object     # @timer_begin
	.local	timer_begin
	.comm	timer_begin,16,8
	.type	.L.str.11,@object       # @.str.11
.L.str.11:
	.asciz	"\033[36m\033[1mclipped mean: "
	.size	.L.str.11, 24

	.type	.L.str.13,@object       # @.str.13
.L.str.13:
	.asciz	"mediocre_clipped_mean_u16 failed"
	.size	.L.str.13, 33

	.type	.L.str.14,@object       # @.str.14
.L.str.14:
	.asciz	"[%zi] %f != %f\n["
	.size	.L.str.14, 17

	.type	.L.str.15,@object       # @.str.15
.L.str.15:
	.asciz	" %u"
	.size	.L.str.15, 4

	.type	get_shuffled_array_counts.numbers,@object # @get_shuffled_array_counts.numbers
	.local	get_shuffled_array_counts.numbers
	.comm	get_shuffled_array_counts.numbers,2000,16
	.type	get_shuffled_array_counts.init,@object # @get_shuffled_array_counts.init
	.local	get_shuffled_array_counts.init
	.comm	get_shuffled_array_counts.init,1,1
	.type	.L.str.18,@object       # @.str.18
.L.str.18:
	.asciz	"%lims elapsed (%4.2fns per item)."
	.size	.L.str.18, 34

	.type	.Lstr,@object           # @str
.Lstr:
	.asciz	"\033[0m"
	.size	.Lstr, 5

	.type	.Lstr.19,@object        # @str.19
	.section	.rodata.str1.16,"aMS",@progbits,1
	.align	16
.Lstr.19:
	.asciz	"Output buffer overrun."
	.size	.Lstr.19, 23

	.type	.Lstr.20,@object        # @str.20
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr.20:
	.asciz	" ]"
	.size	.Lstr.20, 3

	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)" # string offset=0
.Linfo_string1:
	.asciz	"tests/mean_test.c"     # string offset=54
.Linfo_string2:
	.asciz	"/home/david/src/MediocrePy" # string offset=72
.Linfo_string3:
	.asciz	"min_array_count"       # string offset=99
.Linfo_string4:
	.asciz	"long unsigned int"     # string offset=115
.Linfo_string5:
	.asciz	"size_t"                # string offset=133
.Linfo_string6:
	.asciz	"max_array_count"       # string offset=140
.Linfo_string7:
	.asciz	"min_bin_count"         # string offset=156
.Linfo_string8:
	.asciz	"max_bin_count"         # string offset=170
.Linfo_string9:
	.asciz	"max_offset"            # string offset=184
.Linfo_string10:
	.asciz	"min_max_iter"          # string offset=195
.Linfo_string11:
	.asciz	"unsigned int"          # string offset=208
.Linfo_string12:
	.asciz	"uint32_t"              # string offset=221
.Linfo_string13:
	.asciz	"max_max_iter"          # string offset=230
.Linfo_string14:
	.asciz	"generator"             # string offset=243
.Linfo_string15:
	.asciz	"Random"                # string offset=253
.Linfo_string16:
	.asciz	"numbers"               # string offset=260
.Linfo_string17:
	.asciz	"sizetype"              # string offset=268
.Linfo_string18:
	.asciz	"init"                  # string offset=277
.Linfo_string19:
	.asciz	"_Bool"                 # string offset=282
.Linfo_string20:
	.asciz	"input_data"            # string offset=288
.Linfo_string21:
	.asciz	"unsigned short"        # string offset=299
.Linfo_string22:
	.asciz	"uint16_t"              # string offset=314
.Linfo_string23:
	.asciz	"timer_begin"           # string offset=323
.Linfo_string24:
	.asciz	"time"                  # string offset=335
.Linfo_string25:
	.asciz	"long int"              # string offset=340
.Linfo_string26:
	.asciz	"__time_t"              # string offset=349
.Linfo_string27:
	.asciz	"time_t"                # string offset=358
.Linfo_string28:
	.asciz	"millitm"               # string offset=365
.Linfo_string29:
	.asciz	"timezone"              # string offset=373
.Linfo_string30:
	.asciz	"short"                 # string offset=382
.Linfo_string31:
	.asciz	"dstflag"               # string offset=388
.Linfo_string32:
	.asciz	"timeb"                 # string offset=396
.Linfo_string33:
	.asciz	"long long unsigned int" # string offset=402
.Linfo_string34:
	.asciz	"int"                   # string offset=425
.Linfo_string35:
	.asciz	"float"                 # string offset=429
.Linfo_string36:
	.asciz	"get_shuffled_array_counts" # string offset=435
.Linfo_string37:
	.asciz	"i"                     # string offset=461
.Linfo_string38:
	.asciz	"random_fill"           # string offset=463
.Linfo_string39:
	.asciz	"out"                   # string offset=475
.Linfo_string40:
	.asciz	"bin_count"             # string offset=479
.Linfo_string41:
	.asciz	"base"                  # string offset=489
.Linfo_string42:
	.asciz	"r"                     # string offset=494
.Linfo_string43:
	.asciz	"s"                     # string offset=496
.Linfo_string44:
	.asciz	"a"                     # string offset=498
.Linfo_string45:
	.asciz	"u16_input"             # string offset=500
.Linfo_string46:
	.asciz	"loop_function"         # string offset=510
.Linfo_string47:
	.asciz	"mediocre_input_control" # string offset=524
.Linfo_string48:
	.asciz	"MediocreInputControl"  # string offset=547
.Linfo_string49:
	.asciz	"combine_count"         # string offset=568
.Linfo_string50:
	.asciz	"width"                 # string offset=582
.Linfo_string51:
	.asciz	"mediocre_dimension"    # string offset=588
.Linfo_string52:
	.asciz	"MediocreDimension"     # string offset=607
.Linfo_string53:
	.asciz	"destructor"            # string offset=625
.Linfo_string54:
	.asciz	"user_data"             # string offset=636
.Linfo_string55:
	.asciz	"dimension"             # string offset=646
.Linfo_string56:
	.asciz	"nonzero_error"         # string offset=656
.Linfo_string57:
	.asciz	"mediocre_input"        # string offset=670
.Linfo_string58:
	.asciz	"MediocreInput"         # string offset=685
.Linfo_string59:
	.asciz	"input_pointers"        # string offset=699
.Linfo_string60:
	.asciz	"result"                # string offset=714
.Linfo_string61:
	.asciz	"ms_elapsed"            # string offset=721
.Linfo_string62:
	.asciz	"before"                # string offset=732
.Linfo_string63:
	.asciz	"now"                   # string offset=739
.Linfo_string64:
	.asciz	"before_ms"             # string offset=743
.Linfo_string65:
	.asciz	"now_ms"                # string offset=753
.Linfo_string66:
	.asciz	"print_timer_elapsed"   # string offset=760
.Linfo_string67:
	.asciz	"item_count"            # string offset=780
.Linfo_string68:
	.asciz	"ms"                    # string offset=791
.Linfo_string69:
	.asciz	"ns_per_item"           # string offset=794
.Linfo_string70:
	.asciz	"double"                # string offset=806
.Linfo_string71:
	.asciz	"mediocre_chunk_ptr"    # string offset=813
.Linfo_string72:
	.asciz	"chunks"                # string offset=832
.Linfo_string73:
	.asciz	"__m256"                # string offset=839
.Linfo_string74:
	.asciz	"combine_axis"          # string offset=846
.Linfo_string75:
	.asciz	"width_axis"            # string offset=859
.Linfo_string76:
	.asciz	"chunk_ptr"             # string offset=870
.Linfo_string77:
	.asciz	"vector_ptr"            # string offset=880
.Linfo_string78:
	.asciz	"main"                  # string offset=891
.Linfo_string79:
	.asciz	"test_mean"             # string offset=896
.Linfo_string80:
	.asciz	"u16_input_loop"        # string offset=906
.Linfo_string81:
	.asciz	"no_op"                 # string offset=921
.Linfo_string82:
	.asciz	"max_iter"              # string offset=927
.Linfo_string83:
	.asciz	"offset1"               # string offset=936
.Linfo_string84:
	.asciz	"offset0"               # string offset=944
.Linfo_string85:
	.asciz	"array_count"           # string offset=952
.Linfo_string86:
	.asciz	"sigma_lower"           # string offset=964
.Linfo_string87:
	.asciz	"sigma_upper"           # string offset=976
.Linfo_string88:
	.asciz	"input_page"            # string offset=988
.Linfo_string89:
	.asciz	"ptr"                   # string offset=999
.Linfo_string90:
	.asciz	"mapped_"               # string offset=1003
.Linfo_string91:
	.asciz	"mapped_length_"        # string offset=1011
.Linfo_string92:
	.asciz	"canary_data_"          # string offset=1026
.Linfo_string93:
	.asciz	"unsigned char"         # string offset=1039
.Linfo_string94:
	.asciz	"canary_length_"        # string offset=1053
.Linfo_string95:
	.asciz	"CanaryPage"            # string offset=1068
.Linfo_string96:
	.asciz	"output_page"           # string offset=1079
.Linfo_string97:
	.asciz	"output_pointer"        # string offset=1091
.Linfo_string98:
	.asciz	"thread_count"          # string offset=1106
.Linfo_string99:
	.asciz	"status"                # string offset=1119
.Linfo_string100:
	.asciz	"it"                    # string offset=1126
.Linfo_string101:
	.asciz	"upper_bound"           # string offset=1129
.Linfo_string102:
	.asciz	"lower_bound"           # string offset=1141
.Linfo_string103:
	.asciz	"n"                     # string offset=1153
.Linfo_string104:
	.asciz	"sum"                   # string offset=1155
.Linfo_string105:
	.asciz	"count"                 # string offset=1159
.Linfo_string106:
	.asciz	"ss"                    # string offset=1165
.Linfo_string107:
	.asciz	"clipped_mean"          # string offset=1168
.Linfo_string108:
	.asciz	"dev"                   # string offset=1181
.Linfo_string109:
	.asciz	"sd"                    # string offset=1185
.Linfo_string110:
	.asciz	"new_lb"                # string offset=1188
.Linfo_string111:
	.asciz	"new_ub"                # string offset=1195
.Linfo_string112:
	.asciz	"shuffled"              # string offset=1202
.Linfo_string113:
	.asciz	"control"               # string offset=1211
.Linfo_string114:
	.asciz	"command"               # string offset=1219
.Linfo_string115:
	.asciz	"_exit"                 # string offset=1227
.Linfo_string116:
	.asciz	"offset"                # string offset=1233
.Linfo_string117:
	.asciz	"output_chunks"         # string offset=1240
.Linfo_string118:
	.asciz	"mediocre_input_command" # string offset=1254
.Linfo_string119:
	.asciz	"MediocreInputCommand"  # string offset=1277
.Linfo_string120:
	.asciz	"array_i"               # string offset=1298
.Linfo_string121:
	.asciz	"offset_array"          # string offset=1306
.Linfo_string122:
	.asciz	"p"                     # string offset=1319
.Linfo_string123:
	.asciz	"ignored"               # string offset=1321
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	88                      # DW_OP_reg8
	.quad	.Ltmp22-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	88                      # DW_OP_reg8
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	.Ltmp17-.Lfunc_begin0
	.quad	.Ltmp26-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	92                      # DW_OP_reg12
	.quad	.Ltmp16-.Lfunc_begin0
	.quad	.Ltmp25-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	92                      # DW_OP_reg12
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp28-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	0
	.quad	0
.Ldebug_loc4:
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	.Ltmp14-.Lfunc_begin0
	.quad	.Ltmp27-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	0
	.quad	0
.Ldebug_loc5:
	.quad	.Ltmp18-.Lfunc_begin0
	.quad	.Ltmp19-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc6:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp21-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	0                       # 0
	.quad	0
	.quad	0
.Ldebug_loc7:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp44-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	.Ltmp44-.Lfunc_begin0
	.quad	.Ltmp56-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	92                      # DW_OP_reg12
	.quad	.Ltmp181-.Lfunc_begin0
	.quad	.Ltmp185-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	92                      # DW_OP_reg12
	.quad	0
	.quad	0
.Ldebug_loc8:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp43-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	.Ltmp43-.Lfunc_begin0
	.quad	.Ltmp56-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	.Ltmp181-.Lfunc_begin0
	.quad	.Ltmp185-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	0
	.quad	0
.Ldebug_loc9:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp42-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	81                      # DW_OP_reg1
	.quad	.Ltmp42-.Lfunc_begin0
	.quad	.Ltmp56-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	.Ltmp181-.Lfunc_begin0
	.quad	.Ltmp185-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	0
	.quad	0
.Ldebug_loc10:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp41-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	82                      # DW_OP_reg2
	.quad	.Ltmp41-.Lfunc_begin0
	.quad	.Ltmp56-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.quad	.Ltmp181-.Lfunc_begin0
	.quad	.Ltmp185-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.quad	0
	.quad	0
.Ldebug_loc11:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp40-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	.Ltmp40-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	118                     # DW_OP_breg6
	.byte	232                     # -280
	.byte	125                     # 
	.quad	0
	.quad	0
.Ldebug_loc12:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp39-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	98                      # DW_OP_reg18
	.quad	.Ltmp39-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	118                     # DW_OP_breg6
	.byte	240                     # -272
	.byte	125                     # 
	.quad	0
	.quad	0
.Ldebug_loc13:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp38-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	88                      # DW_OP_reg8
	.quad	.Ltmp38-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	118                     # DW_OP_breg6
	.byte	128                     # -256
	.byte	126                     # 
	.quad	0
	.quad	0
.Ldebug_loc14:
	.quad	.Ltmp52-.Lfunc_begin0
	.quad	.Ltmp64-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp64-.Lfunc_begin0
	.quad	.Ltmp65-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	81                      # DW_OP_reg1
	.quad	0
	.quad	0
.Ldebug_loc15:
	.quad	.Ltmp69-.Lfunc_begin0
	.quad	.Ltmp71-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	117                     # DW_OP_breg5
	.byte	0                       # 0
	.quad	.Ltmp185-.Lfunc_begin0
	.quad	.Ltmp186-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	117                     # DW_OP_breg5
	.byte	0                       # 0
	.quad	0
	.quad	0
.Ldebug_loc16:
	.quad	.Ltmp72-.Lfunc_begin0
	.quad	.Ltmp74-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	117                     # DW_OP_breg5
	.byte	0                       # 0
	.quad	0
	.quad	0
.Ldebug_loc17:
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp93-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp93-.Lfunc_begin0
	.quad	.Ltmp94-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	.Ltmp94-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	118                     # DW_OP_breg6
	.byte	136                     # -248
	.byte	126                     # 
	.quad	0
	.quad	0
.Ldebug_loc18:
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	80                      # super-register DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	0
	.quad	0
.Ldebug_loc19:
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	80                      # super-register DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	0
	.quad	0
.Ldebug_loc20:
	.quad	.Ltmp79-.Lfunc_begin0
	.quad	.Ltmp80-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	0
	.quad	0
.Ldebug_loc21:
	.quad	.Ltmp82-.Lfunc_begin0
	.quad	.Ltmp85-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	83                      # super-register DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	.Ltmp85-.Lfunc_begin0
	.quad	.Ltmp86-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	81                      # super-register DW_OP_reg1
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	.Ltmp86-.Lfunc_begin0
	.quad	.Ltmp87-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	83                      # super-register DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	0
	.quad	0
.Ldebug_loc22:
	.quad	.Ltmp84-.Lfunc_begin0
	.quad	.Ltmp88-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	80                      # super-register DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	.Ltmp88-.Lfunc_begin0
	.quad	.Ltmp89-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	83                      # super-register DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	.Ltmp89-.Lfunc_begin0
	.quad	.Ltmp90-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	80                      # super-register DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	0
	.quad	0
.Ldebug_loc23:
	.quad	.Ltmp96-.Lfunc_begin0
	.quad	.Ltmp101-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	93                      # super-register DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	0
	.quad	0
.Ldebug_loc24:
	.quad	.Ltmp97-.Lfunc_begin0
	.quad	.Ltmp110-.Lfunc_begin0
	.short	11                      # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	24                      # 24
	.byte	92                      # DW_OP_reg12
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	94                      # DW_OP_reg14
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp110-.Lfunc_begin0
	.quad	.Ltmp115-.Lfunc_begin0
	.short	17                      # Loc expr size
	.byte	80                      # DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	80                      # DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	92                      # DW_OP_reg12
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	94                      # DW_OP_reg14
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp187-.Lfunc_begin0
	.quad	.Ltmp188-.Lfunc_begin0
	.short	17                      # Loc expr size
	.byte	80                      # DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	80                      # DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	92                      # DW_OP_reg12
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	94                      # DW_OP_reg14
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc25:
	.quad	.Ltmp100-.Lfunc_begin0
	.quad	.Ltmp117-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.quad	.Ltmp187-.Lfunc_begin0
	.quad	.Ltmp188-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	83                      # DW_OP_reg3
	.quad	0
	.quad	0
.Ldebug_loc26:
	.quad	.Ltmp101-.Lfunc_begin0
	.quad	.Ltmp117-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp187-.Lfunc_begin0
	.quad	.Ltmp188-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc27:
	.quad	.Ltmp101-.Lfunc_begin0
	.quad	.Ltmp117-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp187-.Lfunc_begin0
	.quad	.Ltmp188-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc28:
	.quad	.Ltmp103-.Lfunc_begin0
	.quad	.Ltmp108-.Lfunc_begin0
	.short	2                       # Loc expr size
	.byte	117                     # DW_OP_breg5
	.byte	0                       # 0
	.quad	0
	.quad	0
.Ldebug_loc29:
	.quad	.Ltmp106-.Lfunc_begin0
	.quad	.Ltmp117-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	.Ltmp187-.Lfunc_begin0
	.quad	.Ltmp188-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	0
	.quad	0
.Ldebug_loc30:
	.quad	.Ltmp107-.Lfunc_begin0
	.quad	.Ltmp117-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	.Ltmp187-.Lfunc_begin0
	.quad	.Ltmp188-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc31:
	.quad	.Ltmp118-.Lfunc_begin0
	.quad	.Ltmp167-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp167-.Lfunc_begin0
	.quad	.Ltmp168-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	91                      # DW_OP_reg11
	.quad	0
	.quad	0
.Ldebug_loc32:
	.quad	.Ltmp166-.Lfunc_begin0
	.quad	.Ltmp168-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	101                     # DW_OP_reg21
	.quad	0
	.quad	0
.Ldebug_loc33:
	.quad	.Ltmp165-.Lfunc_begin0
	.quad	.Ltmp168-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	104                     # DW_OP_reg24
	.quad	0
	.quad	0
.Ldebug_loc34:
	.quad	.Ltmp121-.Lfunc_begin0
	.quad	.Ltmp127-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	100                     # DW_OP_reg20
	.quad	.Ltmp128-.Lfunc_begin0
	.quad	.Ltmp132-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	100                     # DW_OP_reg20
	.quad	0
	.quad	0
.Ldebug_loc35:
	.quad	.Ltmp121-.Lfunc_begin0
	.quad	.Ltmp127-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	100                     # DW_OP_reg20
	.quad	.Ltmp131-.Lfunc_begin0
	.quad	.Ltmp131-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	99                      # DW_OP_reg19
	.quad	0
	.quad	0
.Ldebug_loc36:
	.quad	.Ltmp130-.Lfunc_begin0
	.quad	.Ltmp131-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	98                      # DW_OP_reg18
	.quad	0
	.quad	0
.Ldebug_loc37:
	.quad	.Ltmp144-.Lfunc_begin0
	.quad	.Ltmp145-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	.Ltmp154-.Lfunc_begin0
	.quad	.Ltmp154-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc38:
	.quad	.Ltmp136-.Lfunc_begin0
	.quad	.Ltmp147-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	100                     # DW_OP_reg20
	.quad	0
	.quad	0
.Ldebug_loc39:
	.quad	.Ltmp139-.Lfunc_begin0
	.quad	.Ltmp145-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	99                      # DW_OP_reg19
	.quad	.Ltmp148-.Lfunc_begin0
	.quad	.Ltmp151-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	99                      # DW_OP_reg19
	.quad	0
	.quad	0
.Ldebug_loc40:
	.quad	.Ltmp142-.Lfunc_begin0
	.quad	.Ltmp143-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	.Ltmp152-.Lfunc_begin0
	.quad	.Ltmp153-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	99                      # DW_OP_reg19
	.quad	0
	.quad	0
.Ldebug_loc41:
	.quad	.Ltmp161-.Lfunc_begin0
	.quad	.Ltmp163-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc42:
	.quad	.Ltmp162-.Lfunc_begin0
	.quad	.Ltmp168-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	99                      # DW_OP_reg19
	.quad	0
	.quad	0
.Ldebug_loc43:
	.quad	.Ltmp164-.Lfunc_begin0
	.quad	.Ltmp168-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc44:
	.quad	.Ltmp169-.Lfunc_begin0
	.quad	.Ltmp178-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	.Ltmp189-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	0
	.quad	0
.Ldebug_loc45:
	.quad	.Lfunc_begin2-.Lfunc_begin0
	.quad	.Ltmp212-.Lfunc_begin0
	.short	6                       # Loc expr size
	.byte	81                      # DW_OP_reg1
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	82                      # DW_OP_reg2
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc46:
	.quad	.Lfunc_begin2-.Lfunc_begin0
	.quad	.Ltmp205-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	.Ltmp205-.Lfunc_begin0
	.quad	.Ltmp212-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	0
	.quad	0
.Ldebug_loc47:
	.quad	.Lfunc_begin2-.Lfunc_begin0
	.quad	.Ltmp204-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	.Ltmp204-.Lfunc_begin0
	.quad	.Ltmp212-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	92                      # DW_OP_reg12
	.quad	0
	.quad	0
.Ldebug_loc48:
	.quad	.Ltmp209-.Lfunc_begin0
	.quad	.Ltmp210-.Lfunc_begin0
	.short	5                       # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	32                      # 32
	.byte	93                      # DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp210-.Lfunc_begin0
	.quad	.Ltmp211-.Lfunc_begin0
	.short	8                       # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	24                      # 24
	.byte	91                      # DW_OP_reg11
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	93                      # DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp211-.Lfunc_begin0
	.quad	.Ltmp212-.Lfunc_begin0
	.short	13                      # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	88                      # DW_OP_reg8
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	91                      # DW_OP_reg11
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	93                      # DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp212-.Lfunc_begin0
	.quad	.Ltmp212-.Lfunc_begin0
	.short	14                      # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	88                      # DW_OP_reg8
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	95                      # DW_OP_reg15
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	91                      # DW_OP_reg11
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	93                      # DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp232-.Lfunc_begin0
	.quad	.Ltmp236-.Lfunc_begin0
	.short	14                      # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	88                      # DW_OP_reg8
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	95                      # DW_OP_reg15
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	91                      # DW_OP_reg11
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	93                      # DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc49:
	.quad	.Ltmp215-.Lfunc_begin0
	.quad	.Ltmp218-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp218-.Lfunc_begin0
	.quad	.Ltmp225-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	1                       # 1
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp225-.Lfunc_begin0
	.quad	.Ltmp226-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	0
	.quad	0
.Ldebug_loc50:
	.quad	.Ltmp217-.Lfunc_begin0
	.quad	.Ltmp219-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	.Ltmp221-.Lfunc_begin0
	.quad	.Ltmp222-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	0
	.quad	0
.Ldebug_loc51:
	.quad	.Ltmp217-.Lfunc_begin0
	.quad	.Ltmp225-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	1                       # 1
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp225-.Lfunc_begin0
	.quad	.Ltmp226-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	0
	.quad	0
.Ldebug_loc52:
	.quad	.Ltmp222-.Lfunc_begin0
	.quad	.Ltmp225-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	0
	.quad	0
.Ldebug_loc53:
	.quad	.Ltmp229-.Lfunc_begin0
	.quad	.Ltmp230-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	82                      # DW_OP_reg2
	.quad	0
	.quad	0
.Ldebug_loc54:
	.quad	.Ltmp229-.Lfunc_begin0
	.quad	.Ltmp230-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	82                      # DW_OP_reg2
	.quad	0
	.quad	0
.Ldebug_loc55:
	.quad	.Ltmp233-.Lfunc_begin0
	.quad	.Ltmp236-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	0
	.quad	0
.Ldebug_loc56:
	.quad	.Ltmp235-.Lfunc_begin0
	.quad	.Ltmp236-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	0
	.quad	0
	.section	.debug_abbrev,"",@progbits
.Lsection_abbrev:
	.byte	1                       # Abbreviation Code
	.byte	17                      # DW_TAG_compile_unit
	.byte	1                       # DW_CHILDREN_yes
	.byte	37                      # DW_AT_producer
	.byte	14                      # DW_FORM_strp
	.byte	19                      # DW_AT_language
	.byte	5                       # DW_FORM_data2
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	16                      # DW_AT_stmt_list
	.byte	23                      # DW_FORM_sec_offset
	.byte	27                      # DW_AT_comp_dir
	.byte	14                      # DW_FORM_strp
	.ascii	"\341\177"              # DW_AT_APPLE_optimized
	.byte	25                      # DW_FORM_flag_present
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	2                       # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	28                      # DW_AT_const_value
	.byte	15                      # DW_FORM_udata
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	3                       # Abbreviation Code
	.byte	38                      # DW_TAG_const_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	4                       # Abbreviation Code
	.byte	22                      # DW_TAG_typedef
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	5                       # Abbreviation Code
	.byte	36                      # DW_TAG_base_type
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	62                      # DW_AT_encoding
	.byte	11                      # DW_FORM_data1
	.byte	11                      # DW_AT_byte_size
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	6                       # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	2                       # DW_AT_location
	.byte	24                      # DW_FORM_exprloc
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	7                       # Abbreviation Code
	.byte	15                      # DW_TAG_pointer_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	8                       # Abbreviation Code
	.byte	19                      # DW_TAG_structure_type
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	60                      # DW_AT_declaration
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	9                       # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	10                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	11                      # Abbreviation Code
	.byte	1                       # DW_TAG_array_type
	.byte	1                       # DW_CHILDREN_yes
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	12                      # Abbreviation Code
	.byte	33                      # DW_TAG_subrange_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	55                      # DW_AT_count
	.byte	5                       # DW_FORM_data2
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	13                      # Abbreviation Code
	.byte	36                      # DW_TAG_base_type
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	11                      # DW_AT_byte_size
	.byte	11                      # DW_FORM_data1
	.byte	62                      # DW_AT_encoding
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	14                      # Abbreviation Code
	.byte	33                      # DW_TAG_subrange_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	55                      # DW_AT_count
	.byte	6                       # DW_FORM_data4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	15                      # Abbreviation Code
	.byte	19                      # DW_TAG_structure_type
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	11                      # DW_AT_byte_size
	.byte	11                      # DW_FORM_data1
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	16                      # Abbreviation Code
	.byte	13                      # DW_TAG_member
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	56                      # DW_AT_data_member_location
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	17                      # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.ascii	"\347\177"              # DW_AT_APPLE_omit_frame_ptr
	.byte	25                      # DW_FORM_flag_present
	.byte	64                      # DW_AT_frame_base
	.byte	24                      # DW_FORM_exprloc
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	5                       # DW_FORM_data2
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.ascii	"\341\177"              # DW_AT_APPLE_optimized
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	18                      # Abbreviation Code
	.byte	11                      # DW_TAG_lexical_block
	.byte	1                       # DW_CHILDREN_yes
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	19                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	28                      # DW_AT_const_value
	.byte	15                      # DW_FORM_udata
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	5                       # DW_FORM_data2
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	20                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	5                       # DW_FORM_data2
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	21                      # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.ascii	"\341\177"              # DW_AT_APPLE_optimized
	.byte	25                      # DW_FORM_flag_present
	.byte	32                      # DW_AT_inline
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	22                      # Abbreviation Code
	.byte	11                      # DW_TAG_lexical_block
	.byte	1                       # DW_CHILDREN_yes
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	23                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	24                      # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.ascii	"\341\177"              # DW_AT_APPLE_optimized
	.byte	25                      # DW_FORM_flag_present
	.byte	32                      # DW_AT_inline
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	25                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	26                      # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.ascii	"\341\177"              # DW_AT_APPLE_optimized
	.byte	25                      # DW_FORM_flag_present
	.byte	32                      # DW_AT_inline
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	27                      # Abbreviation Code
	.byte	21                      # DW_TAG_subroutine_type
	.byte	1                       # DW_CHILDREN_yes
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	28                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	29                      # Abbreviation Code
	.byte	38                      # DW_TAG_const_type
	.byte	0                       # DW_CHILDREN_no
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	30                      # Abbreviation Code
	.byte	15                      # DW_TAG_pointer_type
	.byte	0                       # DW_CHILDREN_no
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	31                      # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.ascii	"\347\177"              # DW_AT_APPLE_omit_frame_ptr
	.byte	25                      # DW_FORM_flag_present
	.byte	64                      # DW_AT_frame_base
	.byte	24                      # DW_FORM_exprloc
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.ascii	"\341\177"              # DW_AT_APPLE_optimized
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	32                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	33                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	34                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	24                      # DW_FORM_exprloc
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	35                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	28                      # DW_AT_const_value
	.byte	15                      # DW_FORM_udata
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	36                      # Abbreviation Code
	.byte	29                      # DW_TAG_inlined_subroutine
	.byte	1                       # DW_CHILDREN_yes
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	85                      # DW_AT_ranges
	.byte	23                      # DW_FORM_sec_offset
	.byte	88                      # DW_AT_call_file
	.byte	11                      # DW_FORM_data1
	.byte	89                      # DW_AT_call_line
	.byte	11                      # DW_FORM_data1
	.ascii	"\266B"                 # DW_AT_GNU_discriminator
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	37                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	28                      # DW_AT_const_value
	.byte	15                      # DW_FORM_udata
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	38                      # Abbreviation Code
	.byte	29                      # DW_TAG_inlined_subroutine
	.byte	1                       # DW_CHILDREN_yes
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	88                      # DW_AT_call_file
	.byte	11                      # DW_FORM_data1
	.byte	89                      # DW_AT_call_line
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	39                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	40                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	41                      # Abbreviation Code
	.byte	11                      # DW_TAG_lexical_block
	.byte	1                       # DW_CHILDREN_yes
	.byte	85                      # DW_AT_ranges
	.byte	23                      # DW_FORM_sec_offset
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	42                      # Abbreviation Code
	.byte	46                      # DW_TAG_subprogram
	.byte	1                       # DW_CHILDREN_yes
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	5                       # DW_FORM_data2
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.ascii	"\341\177"              # DW_AT_APPLE_optimized
	.byte	25                      # DW_FORM_flag_present
	.byte	32                      # DW_AT_inline
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	43                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	5                       # DW_FORM_data2
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	44                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	5                       # DW_FORM_data2
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	45                      # Abbreviation Code
	.byte	1                       # DW_TAG_array_type
	.byte	1                       # DW_CHILDREN_yes
	.ascii	"\207B"                 # DW_AT_GNU_vector
	.byte	25                      # DW_FORM_flag_present
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	46                      # Abbreviation Code
	.byte	33                      # DW_TAG_subrange_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	55                      # DW_AT_count
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	47                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	24                      # DW_FORM_exprloc
	.byte	3                       # DW_AT_name
	.byte	14                      # DW_FORM_strp
	.byte	58                      # DW_AT_decl_file
	.byte	11                      # DW_FORM_data1
	.byte	59                      # DW_AT_decl_line
	.byte	11                      # DW_FORM_data1
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	48                      # Abbreviation Code
	.byte	33                      # DW_TAG_subrange_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	0                       # EOM(3)
	.section	.debug_info,"",@progbits
.Lsection_info:
.Lcu_begin0:
	.long	2655                    # Length of Unit
	.short	4                       # DWARF version number
	.long	.Lsection_abbrev        # Offset Into Abbrev. Section
	.byte	8                       # Address Size (in bytes)
	.byte	1                       # Abbrev [1] 0xb:0xa58 DW_TAG_compile_unit
	.long	.Linfo_string0          # DW_AT_producer
	.short	12                      # DW_AT_language
	.long	.Linfo_string1          # DW_AT_name
	.long	.Lline_table_start0     # DW_AT_stmt_list
	.long	.Linfo_string2          # DW_AT_comp_dir
                                        # DW_AT_APPLE_optimized
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end3-.Lfunc_begin0 # DW_AT_high_pc
	.byte	2                       # Abbrev [2] 0x2a:0xc DW_TAG_variable
	.long	.Linfo_string3          # DW_AT_name
	.long	54                      # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	83                      # DW_AT_decl_line
	.byte	1                       # DW_AT_const_value
	.byte	3                       # Abbrev [3] 0x36:0x5 DW_TAG_const_type
	.long	59                      # DW_AT_type
	.byte	4                       # Abbrev [4] 0x3b:0xb DW_TAG_typedef
	.long	70                      # DW_AT_type
	.long	.Linfo_string5          # DW_AT_name
	.byte	1                       # DW_AT_decl_file
	.byte	62                      # DW_AT_decl_line
	.byte	5                       # Abbrev [5] 0x46:0x7 DW_TAG_base_type
	.long	.Linfo_string4          # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	2                       # Abbrev [2] 0x4d:0xd DW_TAG_variable
	.long	.Linfo_string6          # DW_AT_name
	.long	54                      # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	84                      # DW_AT_decl_line
	.ascii	"\364\003"              # DW_AT_const_value
	.byte	2                       # Abbrev [2] 0x5a:0xe DW_TAG_variable
	.long	.Linfo_string7          # DW_AT_name
	.long	54                      # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	85                      # DW_AT_decl_line
	.ascii	"\260\343-"             # DW_AT_const_value
	.byte	2                       # Abbrev [2] 0x68:0xe DW_TAG_variable
	.long	.Linfo_string8          # DW_AT_name
	.long	54                      # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	86                      # DW_AT_decl_line
	.ascii	"\240\3676"             # DW_AT_const_value
	.byte	2                       # Abbrev [2] 0x76:0xc DW_TAG_variable
	.long	.Linfo_string9          # DW_AT_name
	.long	54                      # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	82                      # DW_AT_decl_line
	.byte	15                      # DW_AT_const_value
	.byte	2                       # Abbrev [2] 0x82:0xc DW_TAG_variable
	.long	.Linfo_string10         # DW_AT_name
	.long	142                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	87                      # DW_AT_decl_line
	.byte	0                       # DW_AT_const_value
	.byte	3                       # Abbrev [3] 0x8e:0x5 DW_TAG_const_type
	.long	147                     # DW_AT_type
	.byte	4                       # Abbrev [4] 0x93:0xb DW_TAG_typedef
	.long	158                     # DW_AT_type
	.long	.Linfo_string12         # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	51                      # DW_AT_decl_line
	.byte	5                       # Abbrev [5] 0x9e:0x7 DW_TAG_base_type
	.long	.Linfo_string11         # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	2                       # Abbrev [2] 0xa5:0xc DW_TAG_variable
	.long	.Linfo_string13         # DW_AT_name
	.long	142                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	88                      # DW_AT_decl_line
	.byte	15                      # DW_AT_const_value
	.byte	6                       # Abbrev [6] 0xb1:0x15 DW_TAG_variable
	.long	.Linfo_string14         # DW_AT_name
	.long	198                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	79                      # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	generator
	.byte	7                       # Abbrev [7] 0xc6:0x5 DW_TAG_pointer_type
	.long	203                     # DW_AT_type
	.byte	8                       # Abbrev [8] 0xcb:0x5 DW_TAG_structure_type
	.long	.Linfo_string15         # DW_AT_name
                                        # DW_AT_declaration
	.byte	9                       # Abbrev [9] 0xd0:0x26 DW_TAG_subprogram
	.long	667                     # DW_AT_abstract_origin
	.byte	6                       # Abbrev [6] 0xd5:0x15 DW_TAG_variable
	.long	.Linfo_string16         # DW_AT_name
	.long	246                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	95                      # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	get_shuffled_array_counts.numbers
	.byte	10                      # Abbrev [10] 0xea:0xb DW_TAG_variable
	.long	.Linfo_string18         # DW_AT_name
	.long	266                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	96                      # DW_AT_decl_line
	.byte	0                       # End Of Children Mark
	.byte	11                      # Abbrev [11] 0xf6:0xd DW_TAG_array_type
	.long	147                     # DW_AT_type
	.byte	12                      # Abbrev [12] 0xfb:0x7 DW_TAG_subrange_type
	.long	259                     # DW_AT_type
	.short	500                     # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	13                      # Abbrev [13] 0x103:0x7 DW_TAG_base_type
	.long	.Linfo_string17         # DW_AT_name
	.byte	8                       # DW_AT_byte_size
	.byte	7                       # DW_AT_encoding
	.byte	5                       # Abbrev [5] 0x10a:0x7 DW_TAG_base_type
	.long	.Linfo_string19         # DW_AT_name
	.byte	2                       # DW_AT_encoding
	.byte	1                       # DW_AT_byte_size
	.byte	6                       # Abbrev [6] 0x111:0x15 DW_TAG_variable
	.long	.Linfo_string20         # DW_AT_name
	.long	294                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	90                      # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	input_data
	.byte	11                      # Abbrev [11] 0x126:0xf DW_TAG_array_type
	.long	309                     # DW_AT_type
	.byte	14                      # Abbrev [14] 0x12b:0x9 DW_TAG_subrange_type
	.long	259                     # DW_AT_type
	.long	450000016               # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0x135:0xb DW_TAG_typedef
	.long	320                     # DW_AT_type
	.long	.Linfo_string22         # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	49                      # DW_AT_decl_line
	.byte	5                       # Abbrev [5] 0x140:0x7 DW_TAG_base_type
	.long	.Linfo_string21         # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	2                       # DW_AT_byte_size
	.byte	6                       # Abbrev [6] 0x147:0x15 DW_TAG_variable
	.long	.Linfo_string23         # DW_AT_name
	.long	348                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	80                      # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	timer_begin
	.byte	15                      # Abbrev [15] 0x15c:0x39 DW_TAG_structure_type
	.long	.Linfo_string32         # DW_AT_name
	.byte	16                      # DW_AT_byte_size
	.byte	6                       # DW_AT_decl_file
	.byte	31                      # DW_AT_decl_line
	.byte	16                      # Abbrev [16] 0x164:0xc DW_TAG_member
	.long	.Linfo_string24         # DW_AT_name
	.long	405                     # DW_AT_type
	.byte	6                       # DW_AT_decl_file
	.byte	33                      # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x170:0xc DW_TAG_member
	.long	.Linfo_string28         # DW_AT_name
	.long	320                     # DW_AT_type
	.byte	6                       # DW_AT_decl_file
	.byte	34                      # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x17c:0xc DW_TAG_member
	.long	.Linfo_string29         # DW_AT_name
	.long	434                     # DW_AT_type
	.byte	6                       # DW_AT_decl_file
	.byte	35                      # DW_AT_decl_line
	.byte	10                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x188:0xc DW_TAG_member
	.long	.Linfo_string31         # DW_AT_name
	.long	434                     # DW_AT_type
	.byte	6                       # DW_AT_decl_file
	.byte	36                      # DW_AT_decl_line
	.byte	12                      # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0x195:0xb DW_TAG_typedef
	.long	416                     # DW_AT_type
	.long	.Linfo_string27         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	75                      # DW_AT_decl_line
	.byte	4                       # Abbrev [4] 0x1a0:0xb DW_TAG_typedef
	.long	427                     # DW_AT_type
	.long	.Linfo_string26         # DW_AT_name
	.byte	4                       # DW_AT_decl_file
	.byte	139                     # DW_AT_decl_line
	.byte	5                       # Abbrev [5] 0x1ab:0x7 DW_TAG_base_type
	.long	.Linfo_string25         # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	5                       # Abbrev [5] 0x1b2:0x7 DW_TAG_base_type
	.long	.Linfo_string30         # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	2                       # DW_AT_byte_size
	.byte	5                       # Abbrev [5] 0x1b9:0x7 DW_TAG_base_type
	.long	.Linfo_string33         # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	5                       # Abbrev [5] 0x1c0:0x7 DW_TAG_base_type
	.long	.Linfo_string34         # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	7                       # Abbrev [7] 0x1c7:0x5 DW_TAG_pointer_type
	.long	460                     # DW_AT_type
	.byte	3                       # Abbrev [3] 0x1cc:0x5 DW_TAG_const_type
	.long	465                     # DW_AT_type
	.byte	7                       # Abbrev [7] 0x1d1:0x5 DW_TAG_pointer_type
	.long	470                     # DW_AT_type
	.byte	3                       # Abbrev [3] 0x1d6:0x5 DW_TAG_const_type
	.long	309                     # DW_AT_type
	.byte	5                       # Abbrev [5] 0x1db:0x7 DW_TAG_base_type
	.long	.Linfo_string35         # DW_AT_name
	.byte	4                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	7                       # Abbrev [7] 0x1e2:0x5 DW_TAG_pointer_type
	.long	475                     # DW_AT_type
	.byte	17                      # Abbrev [17] 0x1e7:0xb4 DW_TAG_subprogram
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0 # DW_AT_high_pc
                                        # DW_AT_APPLE_omit_frame_ptr
	.byte	1                       # DW_AT_frame_base
	.byte	87
	.long	.Linfo_string78         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	257                     # DW_AT_decl_line
	.long	448                     # DW_AT_type
                                        # DW_AT_external
                                        # DW_AT_APPLE_optimized
	.byte	18                      # Abbrev [18] 0x201:0x99 DW_TAG_lexical_block
	.quad	.Ltmp12                 # DW_AT_low_pc
	.long	.Ltmp24-.Ltmp12         # DW_AT_high_pc
	.byte	19                      # Abbrev [19] 0x20e:0xd DW_TAG_variable
	.byte	0                       # DW_AT_const_value
	.long	.Linfo_string37         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	260                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x21b:0x7e DW_TAG_lexical_block
	.quad	.Ltmp12                 # DW_AT_low_pc
	.long	.Ltmp23-.Ltmp12         # DW_AT_high_pc
	.byte	20                      # Abbrev [20] 0x228:0x10 DW_TAG_variable
	.long	.Ldebug_loc0            # DW_AT_location
	.long	.Linfo_string82         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	270                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x238:0x10 DW_TAG_variable
	.long	.Ldebug_loc1            # DW_AT_location
	.long	.Linfo_string83         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	267                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x248:0x10 DW_TAG_variable
	.long	.Ldebug_loc2            # DW_AT_location
	.long	.Linfo_string84         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	266                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x258:0x10 DW_TAG_variable
	.long	.Ldebug_loc3            # DW_AT_location
	.long	.Linfo_string40         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	263                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x268:0x10 DW_TAG_variable
	.long	.Ldebug_loc4            # DW_AT_location
	.long	.Linfo_string85         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	261                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x278:0x10 DW_TAG_variable
	.long	.Ldebug_loc5            # DW_AT_location
	.long	.Linfo_string86         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	268                     # DW_AT_decl_line
	.long	1146                    # DW_AT_type
	.byte	20                      # Abbrev [20] 0x288:0x10 DW_TAG_variable
	.long	.Ldebug_loc6            # DW_AT_location
	.long	.Linfo_string87         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	269                     # DW_AT_decl_line
	.long	1146                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	21                      # Abbrev [21] 0x29b:0x1a DW_TAG_subprogram
	.long	.Linfo_string36         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	94                      # DW_AT_decl_line
	.long	693                     # DW_AT_type
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	22                      # Abbrev [22] 0x2a7:0xd DW_TAG_lexical_block
	.byte	23                      # Abbrev [23] 0x2a8:0xb DW_TAG_variable
	.long	.Linfo_string37         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	100                     # DW_AT_decl_line
	.long	147                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x2b5:0x5 DW_TAG_pointer_type
	.long	142                     # DW_AT_type
	.byte	24                      # Abbrev [24] 0x2ba:0x5a DW_TAG_subprogram
	.long	.Linfo_string38         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	108                     # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	25                      # Abbrev [25] 0x2c2:0xb DW_TAG_formal_parameter
	.long	.Linfo_string39         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	108                     # DW_AT_decl_line
	.long	788                     # DW_AT_type
	.byte	25                      # Abbrev [25] 0x2cd:0xb DW_TAG_formal_parameter
	.long	.Linfo_string40         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	108                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	25                      # Abbrev [25] 0x2d8:0xb DW_TAG_formal_parameter
	.long	.Linfo_string41         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	108                     # DW_AT_decl_line
	.long	147                     # DW_AT_type
	.byte	22                      # Abbrev [22] 0x2e3:0x30 DW_TAG_lexical_block
	.byte	23                      # Abbrev [23] 0x2e4:0xb DW_TAG_variable
	.long	.Linfo_string37         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	109                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	22                      # Abbrev [22] 0x2ef:0x23 DW_TAG_lexical_block
	.byte	23                      # Abbrev [23] 0x2f0:0xb DW_TAG_variable
	.long	.Linfo_string42         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	110                     # DW_AT_decl_line
	.long	147                     # DW_AT_type
	.byte	23                      # Abbrev [23] 0x2fb:0xb DW_TAG_variable
	.long	.Linfo_string43         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	111                     # DW_AT_decl_line
	.long	147                     # DW_AT_type
	.byte	23                      # Abbrev [23] 0x306:0xb DW_TAG_variable
	.long	.Linfo_string44         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	113                     # DW_AT_decl_line
	.long	309                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x314:0x5 DW_TAG_pointer_type
	.long	309                     # DW_AT_type
	.byte	26                      # Abbrev [26] 0x319:0x39 DW_TAG_subprogram
	.long	.Linfo_string45         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	62                      # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	850                     # DW_AT_type
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	25                      # Abbrev [25] 0x325:0xb DW_TAG_formal_parameter
	.long	.Linfo_string59         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	63                      # DW_AT_decl_line
	.long	455                     # DW_AT_type
	.byte	25                      # Abbrev [25] 0x330:0xb DW_TAG_formal_parameter
	.long	.Linfo_string49         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	64                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	25                      # Abbrev [25] 0x33b:0xb DW_TAG_formal_parameter
	.long	.Linfo_string50         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	65                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	23                      # Abbrev [23] 0x346:0xb DW_TAG_variable
	.long	.Linfo_string60         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	67                      # DW_AT_decl_line
	.long	850                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0x352:0xb DW_TAG_typedef
	.long	861                     # DW_AT_type
	.long	.Linfo_string58         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.byte	53                      # DW_AT_decl_line
	.byte	15                      # Abbrev [15] 0x35d:0x45 DW_TAG_structure_type
	.long	.Linfo_string57         # DW_AT_name
	.byte	48                      # DW_AT_byte_size
	.byte	8                       # DW_AT_decl_file
	.byte	40                      # DW_AT_decl_line
	.byte	16                      # Abbrev [16] 0x365:0xc DW_TAG_member
	.long	.Linfo_string46         # DW_AT_name
	.long	930                     # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	41                      # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x371:0xc DW_TAG_member
	.long	.Linfo_string53         # DW_AT_name
	.long	1023                    # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	46                      # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x37d:0xc DW_TAG_member
	.long	.Linfo_string54         # DW_AT_name
	.long	973                     # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	47                      # DW_AT_decl_line
	.byte	16                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x389:0xc DW_TAG_member
	.long	.Linfo_string55         # DW_AT_name
	.long	979                     # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	48                      # DW_AT_decl_line
	.byte	24                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x395:0xc DW_TAG_member
	.long	.Linfo_string56         # DW_AT_name
	.long	448                     # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	50                      # DW_AT_decl_line
	.byte	40                      # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x3a2:0x5 DW_TAG_pointer_type
	.long	935                     # DW_AT_type
	.byte	27                      # Abbrev [27] 0x3a7:0x11 DW_TAG_subroutine_type
                                        # DW_AT_prototyped
	.byte	28                      # Abbrev [28] 0x3a8:0x5 DW_TAG_formal_parameter
	.long	952                     # DW_AT_type
	.byte	28                      # Abbrev [28] 0x3ad:0x5 DW_TAG_formal_parameter
	.long	973                     # DW_AT_type
	.byte	28                      # Abbrev [28] 0x3b2:0x5 DW_TAG_formal_parameter
	.long	979                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x3b8:0x5 DW_TAG_pointer_type
	.long	957                     # DW_AT_type
	.byte	4                       # Abbrev [4] 0x3bd:0xb DW_TAG_typedef
	.long	968                     # DW_AT_type
	.long	.Linfo_string48         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.byte	19                      # DW_AT_decl_line
	.byte	8                       # Abbrev [8] 0x3c8:0x5 DW_TAG_structure_type
	.long	.Linfo_string47         # DW_AT_name
                                        # DW_AT_declaration
	.byte	7                       # Abbrev [7] 0x3cd:0x5 DW_TAG_pointer_type
	.long	978                     # DW_AT_type
	.byte	29                      # Abbrev [29] 0x3d2:0x1 DW_TAG_const_type
	.byte	4                       # Abbrev [4] 0x3d3:0xb DW_TAG_typedef
	.long	990                     # DW_AT_type
	.long	.Linfo_string52         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.byte	37                      # DW_AT_decl_line
	.byte	15                      # Abbrev [15] 0x3de:0x21 DW_TAG_structure_type
	.long	.Linfo_string51         # DW_AT_name
	.byte	16                      # DW_AT_byte_size
	.byte	8                       # DW_AT_decl_file
	.byte	34                      # DW_AT_decl_line
	.byte	16                      # Abbrev [16] 0x3e6:0xc DW_TAG_member
	.long	.Linfo_string49         # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	35                      # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x3f2:0xc DW_TAG_member
	.long	.Linfo_string50         # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	36                      # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x3ff:0x5 DW_TAG_pointer_type
	.long	1028                    # DW_AT_type
	.byte	27                      # Abbrev [27] 0x404:0x7 DW_TAG_subroutine_type
                                        # DW_AT_prototyped
	.byte	28                      # Abbrev [28] 0x405:0x5 DW_TAG_formal_parameter
	.long	1035                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	30                      # Abbrev [30] 0x40b:0x1 DW_TAG_pointer_type
	.byte	26                      # Abbrev [26] 0x40c:0x39 DW_TAG_subprogram
	.long	.Linfo_string61         # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	69                      # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	427                     # DW_AT_type
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	25                      # Abbrev [25] 0x418:0xb DW_TAG_formal_parameter
	.long	.Linfo_string62         # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	69                      # DW_AT_decl_line
	.long	348                     # DW_AT_type
	.byte	23                      # Abbrev [23] 0x423:0xb DW_TAG_variable
	.long	.Linfo_string63         # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	70                      # DW_AT_decl_line
	.long	348                     # DW_AT_type
	.byte	23                      # Abbrev [23] 0x42e:0xb DW_TAG_variable
	.long	.Linfo_string64         # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	72                      # DW_AT_decl_line
	.long	427                     # DW_AT_type
	.byte	23                      # Abbrev [23] 0x439:0xb DW_TAG_variable
	.long	.Linfo_string65         # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	73                      # DW_AT_decl_line
	.long	427                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	24                      # Abbrev [24] 0x445:0x35 DW_TAG_subprogram
	.long	.Linfo_string66         # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	77                      # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	25                      # Abbrev [25] 0x44d:0xb DW_TAG_formal_parameter
	.long	.Linfo_string62         # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	77                      # DW_AT_decl_line
	.long	348                     # DW_AT_type
	.byte	25                      # Abbrev [25] 0x458:0xb DW_TAG_formal_parameter
	.long	.Linfo_string67         # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	77                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	23                      # Abbrev [23] 0x463:0xb DW_TAG_variable
	.long	.Linfo_string68         # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	78                      # DW_AT_decl_line
	.long	427                     # DW_AT_type
	.byte	23                      # Abbrev [23] 0x46e:0xb DW_TAG_variable
	.long	.Linfo_string69         # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	79                      # DW_AT_decl_line
	.long	1146                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	5                       # Abbrev [5] 0x47a:0x7 DW_TAG_base_type
	.long	.Linfo_string70         # DW_AT_name
	.byte	4                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	31                      # Abbrev [31] 0x481:0x376 DW_TAG_subprogram
	.quad	.Lfunc_begin1           # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1 # DW_AT_high_pc
                                        # DW_AT_APPLE_omit_frame_ptr
	.byte	1                       # DW_AT_frame_base
	.byte	86
	.long	.Linfo_string79         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	129                     # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_APPLE_optimized
	.byte	32                      # Abbrev [32] 0x496:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc7            # DW_AT_location
	.long	.Linfo_string85         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	130                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	32                      # Abbrev [32] 0x4a5:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc8            # DW_AT_location
	.long	.Linfo_string40         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	131                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	32                      # Abbrev [32] 0x4b4:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc9            # DW_AT_location
	.long	.Linfo_string84         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	132                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	32                      # Abbrev [32] 0x4c3:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc10           # DW_AT_location
	.long	.Linfo_string83         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	133                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	32                      # Abbrev [32] 0x4d2:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc11           # DW_AT_location
	.long	.Linfo_string86         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	134                     # DW_AT_decl_line
	.long	1146                    # DW_AT_type
	.byte	32                      # Abbrev [32] 0x4e1:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc12           # DW_AT_location
	.long	.Linfo_string87         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	135                     # DW_AT_decl_line
	.long	1146                    # DW_AT_type
	.byte	32                      # Abbrev [32] 0x4f0:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc13           # DW_AT_location
	.long	.Linfo_string82         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	136                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	33                      # Abbrev [33] 0x4ff:0xf DW_TAG_variable
	.long	.Ldebug_loc15           # DW_AT_location
	.long	.Linfo_string88         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	159                     # DW_AT_decl_line
	.long	2498                    # DW_AT_type
	.byte	33                      # Abbrev [33] 0x50e:0xf DW_TAG_variable
	.long	.Ldebug_loc16           # DW_AT_location
	.long	.Linfo_string96         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	159                     # DW_AT_decl_line
	.long	2498                    # DW_AT_type
	.byte	34                      # Abbrev [34] 0x51d:0xf DW_TAG_variable
	.byte	3                       # DW_AT_location
	.byte	145
	.ascii	"\330}"
	.long	.Linfo_string97         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	173                     # DW_AT_decl_line
	.long	482                     # DW_AT_type
	.byte	33                      # Abbrev [33] 0x52c:0xf DW_TAG_variable
	.long	.Ldebug_loc18           # DW_AT_location
	.long	.Linfo_string41         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	176                     # DW_AT_decl_line
	.long	142                     # DW_AT_type
	.byte	33                      # Abbrev [33] 0x53b:0xf DW_TAG_variable
	.long	.Ldebug_loc23           # DW_AT_location
	.long	.Linfo_string98         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	181                     # DW_AT_decl_line
	.long	448                     # DW_AT_type
	.byte	34                      # Abbrev [34] 0x54a:0xf DW_TAG_variable
	.byte	3                       # DW_AT_location
	.byte	145
	.ascii	"\240~"
	.long	.Linfo_string99         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	190                     # DW_AT_decl_line
	.long	448                     # DW_AT_type
	.byte	33                      # Abbrev [33] 0x559:0xf DW_TAG_variable
	.long	.Ldebug_loc44           # DW_AT_location
	.long	.Linfo_string37         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	209                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	23                      # Abbrev [23] 0x568:0xb DW_TAG_variable
	.long	.Linfo_string59         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	147                     # DW_AT_decl_line
	.long	2579                    # DW_AT_type
	.byte	23                      # Abbrev [23] 0x573:0xb DW_TAG_variable
	.long	.Linfo_string112        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	154                     # DW_AT_decl_line
	.long	693                     # DW_AT_type
	.byte	18                      # Abbrev [18] 0x57e:0x1a DW_TAG_lexical_block
	.quad	.Ltmp49                 # DW_AT_low_pc
	.long	.Ltmp50-.Ltmp49         # DW_AT_high_pc
	.byte	35                      # Abbrev [35] 0x58b:0xc DW_TAG_variable
	.byte	0                       # DW_AT_const_value
	.long	.Linfo_string37         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	148                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	36                      # Abbrev [36] 0x598:0x21 DW_TAG_inlined_subroutine
	.long	667                     # DW_AT_abstract_origin
	.long	.Ldebug_ranges0         # DW_AT_ranges
	.byte	2                       # DW_AT_call_file
	.byte	154                     # DW_AT_call_line
	.byte	1                       # DW_AT_GNU_discriminator
	.byte	18                      # Abbrev [18] 0x5a4:0x14 DW_TAG_lexical_block
	.quad	.Ltmp55                 # DW_AT_low_pc
	.long	.Ltmp60-.Ltmp55         # DW_AT_high_pc
	.byte	37                      # Abbrev [37] 0x5b1:0x6 DW_TAG_variable
	.byte	0                       # DW_AT_const_value
	.long	680                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	18                      # Abbrev [18] 0x5b9:0x1d DW_TAG_lexical_block
	.quad	.Ltmp61                 # DW_AT_low_pc
	.long	.Ltmp67-.Ltmp61         # DW_AT_high_pc
	.byte	33                      # Abbrev [33] 0x5c6:0xf DW_TAG_variable
	.long	.Ldebug_loc14           # DW_AT_location
	.long	.Linfo_string37         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	155                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	18                      # Abbrev [18] 0x5d6:0x77 DW_TAG_lexical_block
	.quad	.Ltmp75                 # DW_AT_low_pc
	.long	.Ltmp95-.Ltmp75         # DW_AT_high_pc
	.byte	33                      # Abbrev [33] 0x5e3:0xf DW_TAG_variable
	.long	.Ldebug_loc17           # DW_AT_location
	.long	.Linfo_string37         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	177                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	38                      # Abbrev [38] 0x5f2:0x5a DW_TAG_inlined_subroutine
	.long	698                     # DW_AT_abstract_origin
	.quad	.Ltmp80                 # DW_AT_low_pc
	.long	.Ltmp92-.Ltmp80         # DW_AT_high_pc
	.byte	2                       # DW_AT_call_file
	.byte	178                     # DW_AT_call_line
	.byte	39                      # Abbrev [39] 0x605:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc20           # DW_AT_location
	.long	706                     # DW_AT_abstract_origin
	.byte	39                      # Abbrev [39] 0x60e:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc19           # DW_AT_location
	.long	728                     # DW_AT_abstract_origin
	.byte	18                      # Abbrev [18] 0x617:0x34 DW_TAG_lexical_block
	.quad	.Ltmp80                 # DW_AT_low_pc
	.long	.Ltmp92-.Ltmp80         # DW_AT_high_pc
	.byte	37                      # Abbrev [37] 0x624:0x6 DW_TAG_variable
	.byte	0                       # DW_AT_const_value
	.long	740                     # DW_AT_abstract_origin
	.byte	18                      # Abbrev [18] 0x62a:0x20 DW_TAG_lexical_block
	.quad	.Ltmp80                 # DW_AT_low_pc
	.long	.Ltmp91-.Ltmp80         # DW_AT_high_pc
	.byte	40                      # Abbrev [40] 0x637:0x9 DW_TAG_variable
	.long	.Ldebug_loc21           # DW_AT_location
	.long	752                     # DW_AT_abstract_origin
	.byte	40                      # Abbrev [40] 0x640:0x9 DW_TAG_variable
	.long	.Ldebug_loc22           # DW_AT_location
	.long	763                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	38                      # Abbrev [38] 0x64d:0x1d DW_TAG_inlined_subroutine
	.long	793                     # DW_AT_abstract_origin
	.quad	.Ltmp97                 # DW_AT_low_pc
	.long	.Ltmp98-.Ltmp97         # DW_AT_high_pc
	.byte	2                       # DW_AT_call_file
	.byte	192                     # DW_AT_call_line
	.byte	40                      # Abbrev [40] 0x660:0x9 DW_TAG_variable
	.long	.Ldebug_loc24           # DW_AT_location
	.long	838                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	38                      # Abbrev [38] 0x66a:0x57 DW_TAG_inlined_subroutine
	.long	1093                    # DW_AT_abstract_origin
	.quad	.Ltmp102                # DW_AT_low_pc
	.long	.Ltmp109-.Ltmp102       # DW_AT_high_pc
	.byte	2                       # DW_AT_call_file
	.byte	201                     # DW_AT_call_line
	.byte	39                      # Abbrev [39] 0x67d:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc26           # DW_AT_location
	.long	1101                    # DW_AT_abstract_origin
	.byte	39                      # Abbrev [39] 0x686:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc25           # DW_AT_location
	.long	1112                    # DW_AT_abstract_origin
	.byte	40                      # Abbrev [40] 0x68f:0x9 DW_TAG_variable
	.long	.Ldebug_loc29           # DW_AT_location
	.long	1123                    # DW_AT_abstract_origin
	.byte	40                      # Abbrev [40] 0x698:0x9 DW_TAG_variable
	.long	.Ldebug_loc30           # DW_AT_location
	.long	1134                    # DW_AT_abstract_origin
	.byte	36                      # Abbrev [36] 0x6a1:0x1f DW_TAG_inlined_subroutine
	.long	1036                    # DW_AT_abstract_origin
	.long	.Ldebug_ranges1         # DW_AT_ranges
	.byte	7                       # DW_AT_call_file
	.byte	78                      # DW_AT_call_line
	.byte	1                       # DW_AT_GNU_discriminator
	.byte	39                      # Abbrev [39] 0x6ad:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc27           # DW_AT_location
	.long	1048                    # DW_AT_abstract_origin
	.byte	40                      # Abbrev [40] 0x6b6:0x9 DW_TAG_variable
	.long	.Ldebug_loc28           # DW_AT_location
	.long	1059                    # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	41                      # Abbrev [41] 0x6c1:0x135 DW_TAG_lexical_block
	.long	.Ldebug_ranges7         # DW_AT_ranges
	.byte	33                      # Abbrev [33] 0x6c6:0xf DW_TAG_variable
	.long	.Ldebug_loc32           # DW_AT_location
	.long	.Linfo_string101        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	212                     # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	33                      # Abbrev [33] 0x6d5:0xf DW_TAG_variable
	.long	.Ldebug_loc33           # DW_AT_location
	.long	.Linfo_string102        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	212                     # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	33                      # Abbrev [33] 0x6e4:0xf DW_TAG_variable
	.long	.Ldebug_loc38           # DW_AT_location
	.long	.Linfo_string107        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	212                     # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	41                      # Abbrev [41] 0x6f3:0xe8 DW_TAG_lexical_block
	.long	.Ldebug_ranges6         # DW_AT_ranges
	.byte	33                      # Abbrev [33] 0x6f8:0xf DW_TAG_variable
	.long	.Ldebug_loc31           # DW_AT_location
	.long	.Linfo_string100        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	213                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	41                      # Abbrev [41] 0x707:0xd3 DW_TAG_lexical_block
	.long	.Ldebug_ranges5         # DW_AT_ranges
	.byte	33                      # Abbrev [33] 0x70c:0xf DW_TAG_variable
	.long	.Ldebug_loc35           # DW_AT_location
	.long	.Linfo_string104        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	214                     # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	33                      # Abbrev [33] 0x71b:0xf DW_TAG_variable
	.long	.Ldebug_loc36           # DW_AT_location
	.long	.Linfo_string105        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	214                     # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	33                      # Abbrev [33] 0x72a:0xf DW_TAG_variable
	.long	.Ldebug_loc37           # DW_AT_location
	.long	.Linfo_string106        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	223                     # DW_AT_decl_line
	.long	1146                    # DW_AT_type
	.byte	33                      # Abbrev [33] 0x739:0xf DW_TAG_variable
	.long	.Ldebug_loc41           # DW_AT_location
	.long	.Linfo_string109        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	231                     # DW_AT_decl_line
	.long	1146                    # DW_AT_type
	.byte	33                      # Abbrev [33] 0x748:0xf DW_TAG_variable
	.long	.Ldebug_loc42           # DW_AT_location
	.long	.Linfo_string110        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	232                     # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	33                      # Abbrev [33] 0x757:0xf DW_TAG_variable
	.long	.Ldebug_loc43           # DW_AT_location
	.long	.Linfo_string111        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	233                     # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	41                      # Abbrev [41] 0x766:0x27 DW_TAG_lexical_block
	.long	.Ldebug_ranges3         # DW_AT_ranges
	.byte	35                      # Abbrev [35] 0x76b:0xc DW_TAG_variable
	.byte	1                       # DW_AT_const_value
	.long	.Linfo_string44         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	215                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	41                      # Abbrev [41] 0x777:0x15 DW_TAG_lexical_block
	.long	.Ldebug_ranges2         # DW_AT_ranges
	.byte	33                      # Abbrev [33] 0x77c:0xf DW_TAG_variable
	.long	.Ldebug_loc34           # DW_AT_location
	.long	.Linfo_string103        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	216                     # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	18                      # Abbrev [18] 0x78d:0x4c DW_TAG_lexical_block
	.quad	.Ltmp136                # DW_AT_low_pc
	.long	.Ltmp158-.Ltmp136       # DW_AT_high_pc
	.byte	35                      # Abbrev [35] 0x79a:0xc DW_TAG_variable
	.byte	0                       # DW_AT_const_value
	.long	.Linfo_string44         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	224                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x7a6:0x32 DW_TAG_lexical_block
	.quad	.Ltmp138                # DW_AT_low_pc
	.long	.Ltmp157-.Ltmp138       # DW_AT_high_pc
	.byte	33                      # Abbrev [33] 0x7b3:0xf DW_TAG_variable
	.long	.Ldebug_loc39           # DW_AT_location
	.long	.Linfo_string103        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	225                     # DW_AT_decl_line
	.long	475                     # DW_AT_type
	.byte	41                      # Abbrev [41] 0x7c2:0x15 DW_TAG_lexical_block
	.long	.Ldebug_ranges4         # DW_AT_ranges
	.byte	33                      # Abbrev [33] 0x7c7:0xf DW_TAG_variable
	.long	.Ldebug_loc40           # DW_AT_location
	.long	.Linfo_string108        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	227                     # DW_AT_decl_line
	.long	1146                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	18                      # Abbrev [18] 0x7db:0x1a DW_TAG_lexical_block
	.quad	.Ltmp176                # DW_AT_low_pc
	.long	.Ltmp180-.Ltmp176       # DW_AT_high_pc
	.byte	35                      # Abbrev [35] 0x7e8:0xc DW_TAG_variable
	.byte	0                       # DW_AT_const_value
	.long	.Linfo_string44         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	240                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	42                      # Abbrev [42] 0x7f7:0x56 DW_TAG_subprogram
	.long	.Linfo_string71         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	266                     # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	482                     # DW_AT_type
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	43                      # Abbrev [43] 0x804:0xc DW_TAG_formal_parameter
	.long	.Linfo_string72         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	267                     # DW_AT_decl_line
	.long	2125                    # DW_AT_type
	.byte	43                      # Abbrev [43] 0x810:0xc DW_TAG_formal_parameter
	.long	.Linfo_string49         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	267                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	43                      # Abbrev [43] 0x81c:0xc DW_TAG_formal_parameter
	.long	.Linfo_string74         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	267                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	43                      # Abbrev [43] 0x828:0xc DW_TAG_formal_parameter
	.long	.Linfo_string75         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	267                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	44                      # Abbrev [44] 0x834:0xc DW_TAG_variable
	.long	.Linfo_string76         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	273                     # DW_AT_decl_line
	.long	2125                    # DW_AT_type
	.byte	44                      # Abbrev [44] 0x840:0xc DW_TAG_variable
	.long	.Linfo_string77         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	277                     # DW_AT_decl_line
	.long	2125                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x84d:0x5 DW_TAG_pointer_type
	.long	2130                    # DW_AT_type
	.byte	4                       # Abbrev [4] 0x852:0xb DW_TAG_typedef
	.long	2141                    # DW_AT_type
	.long	.Linfo_string73         # DW_AT_name
	.byte	9                       # DW_AT_decl_file
	.byte	42                      # DW_AT_decl_line
	.byte	45                      # Abbrev [45] 0x85d:0xc DW_TAG_array_type
                                        # DW_AT_GNU_vector
	.long	475                     # DW_AT_type
	.byte	46                      # Abbrev [46] 0x862:0x6 DW_TAG_subrange_type
	.long	259                     # DW_AT_type
	.byte	8                       # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	31                      # Abbrev [31] 0x869:0x136 DW_TAG_subprogram
	.quad	.Lfunc_begin2           # DW_AT_low_pc
	.long	.Lfunc_end2-.Lfunc_begin2 # DW_AT_high_pc
                                        # DW_AT_APPLE_omit_frame_ptr
	.byte	1                       # DW_AT_frame_base
	.byte	87
	.long	.Linfo_string80         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	30                      # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_APPLE_optimized
	.byte	32                      # Abbrev [32] 0x87e:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc46           # DW_AT_location
	.long	.Linfo_string113        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	31                      # DW_AT_decl_line
	.long	952                     # DW_AT_type
	.byte	32                      # Abbrev [32] 0x88d:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc47           # DW_AT_location
	.long	.Linfo_string54         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	32                      # DW_AT_decl_line
	.long	973                     # DW_AT_type
	.byte	32                      # Abbrev [32] 0x89c:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc45           # DW_AT_location
	.long	.Linfo_string55         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	33                      # DW_AT_decl_line
	.long	979                     # DW_AT_type
	.byte	33                      # Abbrev [33] 0x8ab:0xf DW_TAG_variable
	.long	.Ldebug_loc48           # DW_AT_location
	.long	.Linfo_string114        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	35                      # DW_AT_decl_line
	.long	2590                    # DW_AT_type
	.byte	23                      # Abbrev [23] 0x8ba:0xb DW_TAG_variable
	.long	.Linfo_string59         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	36                      # DW_AT_decl_line
	.long	455                     # DW_AT_type
	.byte	18                      # Abbrev [18] 0x8c5:0xd9 DW_TAG_lexical_block
	.quad	.Ltmp212                # DW_AT_low_pc
	.long	.Ltmp230-.Ltmp212       # DW_AT_high_pc
	.byte	23                      # Abbrev [23] 0x8d2:0xb DW_TAG_variable
	.long	.Linfo_string72         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	41                      # DW_AT_decl_line
	.long	2125                    # DW_AT_type
	.byte	23                      # Abbrev [23] 0x8dd:0xb DW_TAG_variable
	.long	.Linfo_string116        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	42                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	23                      # Abbrev [23] 0x8e8:0xb DW_TAG_variable
	.long	.Linfo_string85         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	43                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	23                      # Abbrev [23] 0x8f3:0xb DW_TAG_variable
	.long	.Linfo_string50         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	44                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x8fe:0x9f DW_TAG_lexical_block
	.quad	.Ltmp212                # DW_AT_low_pc
	.long	.Ltmp230-.Ltmp212       # DW_AT_high_pc
	.byte	33                      # Abbrev [33] 0x90b:0xf DW_TAG_variable
	.long	.Ldebug_loc53           # DW_AT_location
	.long	.Linfo_string120        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	46                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x91a:0x82 DW_TAG_lexical_block
	.quad	.Ltmp213                # DW_AT_low_pc
	.long	.Ltmp228-.Ltmp213       # DW_AT_high_pc
	.byte	23                      # Abbrev [23] 0x927:0xb DW_TAG_variable
	.long	.Linfo_string121        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	47                      # DW_AT_decl_line
	.long	465                     # DW_AT_type
	.byte	41                      # Abbrev [41] 0x932:0x69 DW_TAG_lexical_block
	.long	.Ldebug_ranges10        # DW_AT_ranges
	.byte	33                      # Abbrev [33] 0x937:0xf DW_TAG_variable
	.long	.Ldebug_loc49           # DW_AT_location
	.long	.Linfo_string103        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	49                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	41                      # Abbrev [41] 0x946:0x54 DW_TAG_lexical_block
	.long	.Ldebug_ranges9         # DW_AT_ranges
	.byte	23                      # Abbrev [23] 0x94b:0xb DW_TAG_variable
	.long	.Linfo_string122        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	50                      # DW_AT_decl_line
	.long	482                     # DW_AT_type
	.byte	36                      # Abbrev [36] 0x956:0x43 DW_TAG_inlined_subroutine
	.long	2039                    # DW_AT_abstract_origin
	.long	.Ldebug_ranges8         # DW_AT_ranges
	.byte	2                       # DW_AT_call_file
	.byte	50                      # DW_AT_call_line
	.byte	1                       # DW_AT_GNU_discriminator
	.byte	39                      # Abbrev [39] 0x962:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc56           # DW_AT_location
	.long	2052                    # DW_AT_abstract_origin
	.byte	39                      # Abbrev [39] 0x96b:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc55           # DW_AT_location
	.long	2064                    # DW_AT_abstract_origin
	.byte	39                      # Abbrev [39] 0x974:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc54           # DW_AT_location
	.long	2076                    # DW_AT_abstract_origin
	.byte	39                      # Abbrev [39] 0x97d:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc51           # DW_AT_location
	.long	2088                    # DW_AT_abstract_origin
	.byte	40                      # Abbrev [40] 0x986:0x9 DW_TAG_variable
	.long	.Ldebug_loc50           # DW_AT_location
	.long	2100                    # DW_AT_abstract_origin
	.byte	40                      # Abbrev [40] 0x98f:0x9 DW_TAG_variable
	.long	.Ldebug_loc52           # DW_AT_location
	.long	2112                    # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	31                      # Abbrev [31] 0x99f:0x23 DW_TAG_subprogram
	.quad	.Lfunc_begin3           # DW_AT_low_pc
	.long	.Lfunc_end3-.Lfunc_begin3 # DW_AT_high_pc
                                        # DW_AT_APPLE_omit_frame_ptr
	.byte	1                       # DW_AT_frame_base
	.byte	87
	.long	.Linfo_string81         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	58                      # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_APPLE_optimized
	.byte	47                      # Abbrev [47] 0x9b4:0xd DW_TAG_formal_parameter
	.byte	1                       # DW_AT_location
	.byte	85
	.long	.Linfo_string123        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	58                      # DW_AT_decl_line
	.long	1035                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	15                      # Abbrev [15] 0x9c2:0x45 DW_TAG_structure_type
	.long	.Linfo_string95         # DW_AT_name
	.byte	40                      # DW_AT_byte_size
	.byte	7                       # DW_AT_decl_file
	.byte	101                     # DW_AT_decl_line
	.byte	16                      # Abbrev [16] 0x9ca:0xc DW_TAG_member
	.long	.Linfo_string89         # DW_AT_name
	.long	1035                    # DW_AT_type
	.byte	7                       # DW_AT_decl_file
	.byte	102                     # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x9d6:0xc DW_TAG_member
	.long	.Linfo_string90         # DW_AT_name
	.long	1035                    # DW_AT_type
	.byte	7                       # DW_AT_decl_file
	.byte	104                     # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x9e2:0xc DW_TAG_member
	.long	.Linfo_string91         # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	7                       # DW_AT_decl_file
	.byte	105                     # DW_AT_decl_line
	.byte	16                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x9ee:0xc DW_TAG_member
	.long	.Linfo_string92         # DW_AT_name
	.long	2567                    # DW_AT_type
	.byte	7                       # DW_AT_decl_file
	.byte	106                     # DW_AT_decl_line
	.byte	24                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x9fa:0xc DW_TAG_member
	.long	.Linfo_string94         # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	7                       # DW_AT_decl_file
	.byte	107                     # DW_AT_decl_line
	.byte	32                      # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0xa07:0x5 DW_TAG_pointer_type
	.long	2572                    # DW_AT_type
	.byte	5                       # Abbrev [5] 0xa0c:0x7 DW_TAG_base_type
	.long	.Linfo_string93         # DW_AT_name
	.byte	8                       # DW_AT_encoding
	.byte	1                       # DW_AT_byte_size
	.byte	11                      # Abbrev [11] 0xa13:0xb DW_TAG_array_type
	.long	788                     # DW_AT_type
	.byte	48                      # Abbrev [48] 0xa18:0x5 DW_TAG_subrange_type
	.long	259                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0xa1e:0xb DW_TAG_typedef
	.long	2601                    # DW_AT_type
	.long	.Linfo_string119        # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.byte	194                     # DW_AT_decl_line
	.byte	15                      # Abbrev [15] 0xa29:0x39 DW_TAG_structure_type
	.long	.Linfo_string118        # DW_AT_name
	.byte	40                      # DW_AT_byte_size
	.byte	8                       # DW_AT_decl_file
	.byte	189                     # DW_AT_decl_line
	.byte	16                      # Abbrev [16] 0xa31:0xc DW_TAG_member
	.long	.Linfo_string115        # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	190                     # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0xa3d:0xc DW_TAG_member
	.long	.Linfo_string116        # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	191                     # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0xa49:0xc DW_TAG_member
	.long	.Linfo_string55         # DW_AT_name
	.long	979                     # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	192                     # DW_AT_decl_line
	.byte	16                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0xa55:0xc DW_TAG_member
	.long	.Linfo_string117        # DW_AT_name
	.long	2125                    # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	193                     # DW_AT_decl_line
	.byte	32                      # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.section	.debug_ranges,"",@progbits
.Ldebug_range:
.Ldebug_ranges0:
	.quad	.Ltmp50-.Lfunc_begin0
	.quad	.Ltmp53-.Lfunc_begin0
	.quad	.Ltmp55-.Lfunc_begin0
	.quad	.Ltmp61-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges1:
	.quad	.Ltmp102-.Lfunc_begin0
	.quad	.Ltmp104-.Lfunc_begin0
	.quad	.Ltmp105-.Lfunc_begin0
	.quad	.Ltmp106-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges2:
	.quad	.Ltmp113-.Lfunc_begin0
	.quad	.Ltmp114-.Lfunc_begin0
	.quad	.Ltmp116-.Lfunc_begin0
	.quad	.Ltmp117-.Lfunc_begin0
	.quad	.Ltmp120-.Lfunc_begin0
	.quad	.Ltmp134-.Lfunc_begin0
	.quad	.Ltmp159-.Lfunc_begin0
	.quad	.Ltmp160-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges3:
	.quad	.Ltmp113-.Lfunc_begin0
	.quad	.Ltmp114-.Lfunc_begin0
	.quad	.Ltmp116-.Lfunc_begin0
	.quad	.Ltmp135-.Lfunc_begin0
	.quad	.Ltmp159-.Lfunc_begin0
	.quad	.Ltmp160-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges4:
	.quad	.Ltmp141-.Lfunc_begin0
	.quad	.Ltmp144-.Lfunc_begin0
	.quad	.Ltmp150-.Lfunc_begin0
	.quad	.Ltmp154-.Lfunc_begin0
	.quad	.Ltmp156-.Lfunc_begin0
	.quad	.Ltmp157-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges5:
	.quad	.Ltmp113-.Lfunc_begin0
	.quad	.Ltmp114-.Lfunc_begin0
	.quad	.Ltmp116-.Lfunc_begin0
	.quad	.Ltmp166-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges6:
	.quad	.Ltmp112-.Lfunc_begin0
	.quad	.Ltmp114-.Lfunc_begin0
	.quad	.Ltmp116-.Lfunc_begin0
	.quad	.Ltmp168-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges7:
	.quad	.Ltmp112-.Lfunc_begin0
	.quad	.Ltmp171-.Lfunc_begin0
	.quad	.Ltmp175-.Lfunc_begin0
	.quad	.Ltmp181-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges8:
	.quad	.Ltmp213-.Lfunc_begin0
	.quad	.Ltmp214-.Lfunc_begin0
	.quad	.Ltmp216-.Lfunc_begin0
	.quad	.Ltmp217-.Lfunc_begin0
	.quad	.Ltmp220-.Lfunc_begin0
	.quad	.Ltmp223-.Lfunc_begin0
	.quad	.Ltmp225-.Lfunc_begin0
	.quad	.Ltmp226-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges9:
	.quad	.Ltmp213-.Lfunc_begin0
	.quad	.Ltmp214-.Lfunc_begin0
	.quad	.Ltmp216-.Lfunc_begin0
	.quad	.Ltmp224-.Lfunc_begin0
	.quad	.Ltmp225-.Lfunc_begin0
	.quad	.Ltmp227-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges10:
	.quad	.Ltmp213-.Lfunc_begin0
	.quad	.Ltmp214-.Lfunc_begin0
	.quad	.Ltmp216-.Lfunc_begin0
	.quad	.Ltmp228-.Lfunc_begin0
	.quad	0
	.quad	0
	.section	.debug_macinfo,"",@progbits
	.byte	0                       # End Of Macro List Mark
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end0-.LpubNames_begin0 # Length of Public Names Info
.LpubNames_begin0:
	.short	2                       # DWARF Version
	.long	.Lcu_begin0             # Offset of Compilation Unit Info
	.long	2659                    # Compilation Unit Length
	.long	1036                    # DIE offset
	.asciz	"ms_elapsed"            # External Name
	.long	1153                    # DIE offset
	.asciz	"test_mean"             # External Name
	.long	90                      # DIE offset
	.asciz	"min_bin_count"         # External Name
	.long	327                     # DIE offset
	.asciz	"timer_begin"           # External Name
	.long	104                     # DIE offset
	.asciz	"max_bin_count"         # External Name
	.long	177                     # DIE offset
	.asciz	"generator"             # External Name
	.long	698                     # DIE offset
	.asciz	"random_fill"           # External Name
	.long	667                     # DIE offset
	.asciz	"get_shuffled_array_counts" # External Name
	.long	273                     # DIE offset
	.asciz	"input_data"            # External Name
	.long	42                      # DIE offset
	.asciz	"min_array_count"       # External Name
	.long	77                      # DIE offset
	.asciz	"max_array_count"       # External Name
	.long	118                     # DIE offset
	.asciz	"max_offset"            # External Name
	.long	793                     # DIE offset
	.asciz	"u16_input"             # External Name
	.long	487                     # DIE offset
	.asciz	"main"                  # External Name
	.long	1093                    # DIE offset
	.asciz	"print_timer_elapsed"   # External Name
	.long	2153                    # DIE offset
	.asciz	"u16_input_loop"        # External Name
	.long	234                     # DIE offset
	.asciz	"init"                  # External Name
	.long	2039                    # DIE offset
	.asciz	"mediocre_chunk_ptr"    # External Name
	.long	2463                    # DIE offset
	.asciz	"no_op"                 # External Name
	.long	213                     # DIE offset
	.asciz	"numbers"               # External Name
	.long	130                     # DIE offset
	.asciz	"min_max_iter"          # External Name
	.long	165                     # DIE offset
	.asciz	"max_max_iter"          # External Name
	.long	0                       # End Mark
.LpubNames_end0:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end0-.LpubTypes_begin0 # Length of Public Types Info
.LpubTypes_begin0:
	.short	2                       # DWARF Version
	.long	.Lcu_begin0             # Offset of Compilation Unit Info
	.long	2659                    # Compilation Unit Length
	.long	405                     # DIE offset
	.asciz	"time_t"                # External Name
	.long	158                     # DIE offset
	.asciz	"unsigned int"          # External Name
	.long	266                     # DIE offset
	.asciz	"_Bool"                 # External Name
	.long	448                     # DIE offset
	.asciz	"int"                   # External Name
	.long	990                     # DIE offset
	.asciz	"mediocre_dimension"    # External Name
	.long	59                      # DIE offset
	.asciz	"size_t"                # External Name
	.long	979                     # DIE offset
	.asciz	"MediocreDimension"     # External Name
	.long	348                     # DIE offset
	.asciz	"timeb"                 # External Name
	.long	861                     # DIE offset
	.asciz	"mediocre_input"        # External Name
	.long	70                      # DIE offset
	.asciz	"long unsigned int"     # External Name
	.long	147                     # DIE offset
	.asciz	"uint32_t"              # External Name
	.long	309                     # DIE offset
	.asciz	"uint16_t"              # External Name
	.long	1146                    # DIE offset
	.asciz	"double"                # External Name
	.long	2498                    # DIE offset
	.asciz	"CanaryPage"            # External Name
	.long	2590                    # DIE offset
	.asciz	"MediocreInputCommand"  # External Name
	.long	427                     # DIE offset
	.asciz	"long int"              # External Name
	.long	416                     # DIE offset
	.asciz	"__time_t"              # External Name
	.long	850                     # DIE offset
	.asciz	"MediocreInput"         # External Name
	.long	441                     # DIE offset
	.asciz	"long long unsigned int" # External Name
	.long	2130                    # DIE offset
	.asciz	"__m256"                # External Name
	.long	320                     # DIE offset
	.asciz	"unsigned short"        # External Name
	.long	434                     # DIE offset
	.asciz	"short"                 # External Name
	.long	2601                    # DIE offset
	.asciz	"mediocre_input_command" # External Name
	.long	475                     # DIE offset
	.asciz	"float"                 # External Name
	.long	957                     # DIE offset
	.asciz	"MediocreInputControl"  # External Name
	.long	2572                    # DIE offset
	.asciz	"unsigned char"         # External Name
	.long	0                       # End Mark
.LpubTypes_end0:

	.ident	"clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)"
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
