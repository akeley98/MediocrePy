	.text
	.file	"tests/convert_test.c"
	.section	.rodata.cst4,"aM",@progbits,4
	.align	4
.LCPI0_0:
	.long	1199571021              # float 65536.6015
.LCPI0_1:
	.long	1056964608              # float 0.5
.LCPI0_3:
	.long	3243633541              # float -13.3699999
.LCPI0_4:
	.long	1199570944              # float 65536
	.section	.rodata.cst8,"aM",@progbits,8
	.align	8
.LCPI0_2:
	.quad	-4619792497756654797    # double -0.59999999999999998
.LCPI0_5:
	.quad	4696837146684686336     # double 1.0E+6
	.text
	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp0:
	.cfi_def_cfa_offset 16
	pushq	%r15
.Ltmp1:
	.cfi_def_cfa_offset 24
	pushq	%r14
.Ltmp2:
	.cfi_def_cfa_offset 32
	pushq	%r13
.Ltmp3:
	.cfi_def_cfa_offset 40
	pushq	%r12
.Ltmp4:
	.cfi_def_cfa_offset 48
	pushq	%rbx
.Ltmp5:
	.cfi_def_cfa_offset 56
	subq	$216, %rsp
.Ltmp6:
	.cfi_def_cfa_offset 272
.Ltmp7:
	.cfi_offset %rbx, -56
.Ltmp8:
	.cfi_offset %r12, -48
.Ltmp9:
	.cfi_offset %r13, -40
.Ltmp10:
	.cfi_offset %r14, -32
.Ltmp11:
	.cfi_offset %r15, -24
.Ltmp12:
	.cfi_offset %rbp, -16
	xorl	%eax, %eax
	callq	new_random
	movq	%rax, generator(%rip)
	movq	%rax, %rdi
	callq	get_seed
	movq	%rax, %rcx
	movl	$.L.str, %edi
	xorl	%eax, %eax
	movq	%rcx, %rsi
	callq	printf
	movq	generator(%rip), %rdi
	movl	$.L.str.2, %r13d
	xorl	%ebp, %ebp
	.align	16, 0x90
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_8 Depth 2
                                        #     Child Loop BB0_19 Depth 2
                                        #     Child Loop BB0_33 Depth 2
                                        #     Child Loop BB0_40 Depth 2
                                        #     Child Loop BB0_43 Depth 2
	movl	$300000000, %esi        # imm = 0x11E1A300
	movl	$310000000, %edx        # imm = 0x127A3980
	callq	random_dist_u32
	movl	%eax, %r12d
	movq	generator(%rip), %rdi
	callq	random_u32
	movl	%eax, %r15d
	movl	%r15d, %ebx
	andl	$1, %ebx
	movl	$.L.str.3, %edx
	cmovneq	%r13, %rdx
	movl	$.L.str.1, %edi
	xorl	%eax, %eax
	movq	%r12, %rsi
	callq	printf
	leaq	7(%r12), %r14
	movabsq	$8589934584, %rax       # imm = 0x1FFFFFFF8
	andq	%rax, %r14
	testl	%ebx, %ebx
	je	.LBB0_3
# BB#2:                                 #   in Loop: Header=BB0_1 Depth=1
	movq	%r14, %rdx
	subq	%r12, %rdx
	addq	%rdx, %rdx
	jmp	.LBB0_4
	.align	16, 0x90
.LBB0_3:                                #   in Loop: Header=BB0_1 Depth=1
	movl	$-8, %ebx
	subl	%r12d, %ebx
	movq	generator(%rip), %rdi
	movl	$1, %esi
	movl	$7, %edx
	callq	random_dist_u32
	movl	%eax, %edx
	addl	%ebx, %edx
	addl	%edx, %edx
	andl	$14, %edx
.LBB0_4:                                #   in Loop: Header=BB0_1 Depth=1
	leaq	(%r12,%r12), %rbx
	leaq	120(%rsp), %rdi
	movq	%rbx, %rsi
	callq	init_canary_page
	testl	%eax, %eax
	js	.LBB0_45
# BB#5:                                 #   in Loop: Header=BB0_1 Depth=1
	movq	%rbp, 48(%rsp)          # 8-byte Spill
	leaq	(,%r14,4), %rbp
	movq	%r14, 88(%rsp)          # 8-byte Spill
	xorl	%edx, %edx
	leaq	160(%rsp), %rdi
	movq	%rbp, %rsi
	callq	init_canary_page
	testl	%eax, %eax
	js	.LBB0_45
# BB#6:                                 #   in Loop: Header=BB0_1 Depth=1
	movl	%r15d, %r13d
	movl	%r15d, 76(%rsp)         # 4-byte Spill
	andl	$2, %r13d
	movq	160(%rsp), %r14
	movq	120(%rsp), %r15
	movl	$42, %esi
	movq	%r14, %rdi
	movq	%rbp, %rdx
	movq	%rbp, 56(%rsp)          # 8-byte Spill
	callq	memset
	movl	$42, %esi
	movq	%r15, %rdi
	movq	%rbx, %rdx
	movq	%rbx, 64(%rsp)          # 8-byte Spill
	callq	memset
	testl	%r13d, %r13d
	movl	$.L.str.7, %ecx
	movl	$.L.str.6, %eax
	cmovneq	%rax, %rcx
	movl	$.L.str.5, %edi
	xorl	%eax, %eax
	movq	%r14, %rsi
	movq	%r15, %rdx
	callq	printf
	testl	%r12d, %r12d
	je	.LBB0_9
# BB#7:                                 # %.lr.ph10.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	movq	%r14, %rbx
	movq	%r12, %rbp
	.align	16, 0x90
.LBB0_8:                                # %.lr.ph10.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	generator(%rip), %rdi
	callq	random_u32
	vmovss	.LCPI0_0(%rip), %xmm0   # xmm0 = mem[0],zero,zero,zero
	vmovaps	%xmm0, %xmm1
	movl	%eax, %eax
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ssq	%rax, %xmm0, %xmm0
	vdivss	%xmm1, %xmm0, %xmm0
	vmovss	%xmm0, (%rbx)
	addq	$4, %rbx
	decq	%rbp
	jne	.LBB0_8
.LBB0_9:                                # %._crit_edge11.i
                                        #   in Loop: Header=BB0_1 Depth=1
	testl	%r13d, %r13d
	je	.LBB0_11
# BB#10:                                #   in Loop: Header=BB0_1 Depth=1
	movl	%r13d, 80(%rsp)         # 4-byte Spill
	vxorps	%xmm0, %xmm0, %xmm0
	vmovsd	%xmm0, 40(%rsp)         # 8-byte Spill
	movq	$-1, %r13
	jmp	.LBB0_14
	.align	16, 0x90
.LBB0_11:                               #   in Loop: Header=BB0_1 Depth=1
	movl	%r13d, 80(%rsp)         # 4-byte Spill
	movq	generator(%rip), %rdi
	callq	random_u32
	xorl	$-2147483648, %eax      # imm = 0xFFFFFFFF80000000
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ssl	%eax, %xmm0, %xmm0
	vmulss	.LCPI0_1(%rip), %xmm0, %xmm0
	vcvtss2sd	%xmm0, %xmm0, %xmm1
	vucomisd	.LCPI0_2(%rip), %xmm1
	vmovss	.LCPI0_3(%rip), %xmm1   # xmm1 = mem[0],zero,zero,zero
	ja	.LBB0_13
# BB#12:                                #   in Loop: Header=BB0_1 Depth=1
	vmovaps	%xmm0, %xmm1
.LBB0_13:                               #   in Loop: Header=BB0_1 Depth=1
	vcmpltss	.LCPI0_4(%rip), %xmm0, %xmm2
	vblendvps	%xmm2, %xmm1, %xmm0, %xmm0
	vmovaps	%xmm0, 96(%rsp)         # 16-byte Spill
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	vmovsd	%xmm0, 40(%rsp)         # 8-byte Spill
	movl	$.L.str.8, %edi
	movb	$1, %al
	callq	printf
	movq	generator(%rip), %rdi
	callq	random_u32
	xorl	%edx, %edx
	divl	%r12d
	movl	%edx, %r13d
	vmovaps	96(%rsp), %xmm0         # 16-byte Reload
	vmovss	%xmm0, (%r14,%r13,4)
.LBB0_14:                               #   in Loop: Header=BB0_1 Depth=1
	movl	$timer_begin, %edi
	callq	ftime
	movl	$1, %ecx
	movq	%r15, %rdi
	movq	%r14, %rsi
	movq	%r12, %rdx
	callq	load_u16_from_m256_stride
	movl	%eax, 84(%rsp)          # 4-byte Spill
	movq	timer_begin(%rip), %rbx
	movzwl	timer_begin+8(%rip), %ebp
	leaq	200(%rsp), %rdi
	callq	ftime
	movq	200(%rsp), %rax
	movzwl	208(%rsp), %esi
	subq	%rbx, %rax
	imulq	$1000, %rax, %rax       # imm = 0x3E8
	subq	%rbp, %rsi
	addq	%rax, %rsi
	vcvtsi2sdq	%rsi, %xmm0, %xmm0
	vmulsd	.LCPI0_5(%rip), %xmm0, %xmm0
	vcvtsi2sdq	%r12, %xmm0, %xmm1
	vmovsd	%xmm1, 96(%rsp)         # 8-byte Spill
	vdivsd	%xmm1, %xmm0, %xmm0
	movl	$.L.str.13, %edi
	movb	$1, %al
	callq	printf
	movl	$0, %esi
	testl	%r12d, %r12d
	je	.LBB0_15
	.align	16, 0x90
.LBB0_19:                               # %.lr.ph.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	cmpq	%rsi, %r13
	je	.LBB0_18
# BB#20:                                # %.lr.ph.i
                                        #   in Loop: Header=BB0_19 Depth=2
	movzwl	(%r15,%rsi,2), %edx
	vmovss	(%r14,%rsi,4), %xmm0    # xmm0 = mem[0],zero,zero,zero
	vroundss	$12, %xmm0, %xmm0, %xmm1
	vcvttss2si	%xmm1, %eax
	cmpl	%eax, %edx
	jne	.LBB0_21
.LBB0_18:                               #   in Loop: Header=BB0_19 Depth=2
	incq	%rsi
	cmpq	%r12, %rsi
	jb	.LBB0_19
.LBB0_15:                               # %._crit_edge.i
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	80(%rsp), %edx          # 4-byte Reload
	testl	%edx, %edx
	setne	%al
	cmpl	$0, 84(%rsp)            # 4-byte Folded Reload
	sete	%cl
	xorb	%al, %cl
	jne	.LBB0_16
# BB#25:                                #   in Loop: Header=BB0_1 Depth=1
	movq	192(%rsp), %rax
	movq	%rax, 32(%rsp)
	vmovups	160(%rsp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	check_canary_page
	movl	%eax, %ebx
	movq	152(%rsp), %rax
	movq	%rax, 32(%rsp)
	vmovups	120(%rsp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	check_canary_page
	movl	%eax, %ebp
	movq	192(%rsp), %rax
	movq	%rax, 32(%rsp)
	vmovups	160(%rsp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	free_canary_page
	movq	152(%rsp), %rax
	movq	%rax, 32(%rsp)
	vmovups	120(%rsp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	free_canary_page
	orl	%ebx, %ebp
	movq	88(%rsp), %rbp          # 8-byte Reload
	movl	76(%rsp), %ebx          # 4-byte Reload
	js	.LBB0_46
# BB#26:                                # %test_load_u16.exit
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	%ebx, %eax
	andl	$4, %eax
	shrl	$2, %eax
	testb	%al, %al
	movl	$.L.str.3, %edx
	movl	$.L.str.2, %r13d
	cmovneq	%r13, %rdx
	movl	$.L.str.14, %edi
	xorl	%eax, %eax
	movq	%r12, %rsi
	callq	printf
	andl	$4, %ebx
	je	.LBB0_28
# BB#27:                                #   in Loop: Header=BB0_1 Depth=1
	subq	%r12, %rbp
	addq	%rbp, %rbp
	jmp	.LBB0_29
	.align	16, 0x90
.LBB0_28:                               #   in Loop: Header=BB0_1 Depth=1
	movl	$-8, %ebx
	subl	%r12d, %ebx
	movq	generator(%rip), %rdi
	movl	$1, %esi
	movl	$7, %edx
	callq	random_dist_u32
	movl	%eax, %ebp
	addl	%ebx, %ebp
	addl	%ebp, %ebp
	andl	$14, %ebp
.LBB0_29:                               #   in Loop: Header=BB0_1 Depth=1
	movq	64(%rsp), %rbx          # 8-byte Reload
	leaq	120(%rsp), %rdi
	movq	%rbx, %rsi
	movq	%rbp, %rdx
	callq	init_canary_page
	testl	%eax, %eax
	js	.LBB0_45
# BB#30:                                #   in Loop: Header=BB0_1 Depth=1
	xorl	%edx, %edx
	leaq	160(%rsp), %rdi
	movq	56(%rsp), %rbp          # 8-byte Reload
	movq	%rbp, %rsi
	callq	init_canary_page
	testl	%eax, %eax
	js	.LBB0_45
# BB#31:                                #   in Loop: Header=BB0_1 Depth=1
	movq	160(%rsp), %r14
	movq	120(%rsp), %r15
	movl	$42, %esi
	movq	%r14, %rdi
	movq	%rbp, %rdx
	callq	memset
	movl	$42, %esi
	movq	%r15, %rdi
	movq	%rbx, %rdx
	callq	memset
	movl	$.L.str.15, %edi
	xorl	%eax, %eax
	movq	%r14, %rsi
	movq	%r15, %rdx
	callq	printf
	testl	%r12d, %r12d
	je	.LBB0_34
# BB#32:                                # %.lr.ph19.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	movq	%r15, %rbx
	movq	%r12, %rbp
	.align	16, 0x90
.LBB0_33:                               # %.lr.ph19.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	generator(%rip), %rdi
	callq	random_u32
	movw	%ax, (%rbx)
	addq	$2, %rbx
	decq	%rbp
	jne	.LBB0_33
.LBB0_34:                               # %._crit_edge20.i
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$timer_begin, %edi
	callq	ftime
	movl	$1, %ecx
	movq	%r14, %rdi
	movq	%r15, %rsi
	movq	%r12, %rdx
	callq	load_m256_from_u16_stride
	movq	timer_begin(%rip), %rbx
	movzwl	timer_begin+8(%rip), %ebp
	leaq	200(%rsp), %rdi
	callq	ftime
	movq	200(%rsp), %rax
	movzwl	208(%rsp), %esi
	subq	%rbx, %rax
	imulq	$1000, %rax, %rax       # imm = 0x3E8
	subq	%rbp, %rsi
	addq	%rax, %rsi
	vcvtsi2sdq	%rsi, %xmm0, %xmm0
	vmulsd	.LCPI0_5(%rip), %xmm0, %xmm0
	vdivsd	96(%rsp), %xmm0, %xmm0  # 8-byte Folded Reload
	movl	$.L.str.13, %edi
	movb	$1, %al
	callq	printf
	movl	$0, %esi
	testl	%r12d, %r12d
	je	.LBB0_35
	.align	16, 0x90
.LBB0_40:                               # %.lr.ph15.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movzwl	(%r15,%rsi,2), %edx
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ssl	%edx, %xmm0, %xmm1
	vmovss	(%r14,%rsi,4), %xmm0    # xmm0 = mem[0],zero,zero,zero
	vucomiss	%xmm0, %xmm1
	jne	.LBB0_41
	jnp	.LBB0_39
.LBB0_41:
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	movl	$.L.str.16, %edi
	jmp	.LBB0_22
	.align	16, 0x90
.LBB0_39:                               #   in Loop: Header=BB0_40 Depth=2
	incq	%rsi
	cmpq	%r12, %rsi
	jb	.LBB0_40
.LBB0_35:                               # %._crit_edge16.i
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$.L.str.17, %edi
	xorl	%eax, %eax
	movq	%r12, %rsi
	callq	printf
	movl	$timer_begin, %edi
	callq	ftime
	movl	$1, %ecx
	movq	%r14, %rdi
	movq	%r15, %rsi
	movq	%r12, %rdx
	callq	iadd_m256_by_u16_stride
	movq	timer_begin(%rip), %rbx
	movzwl	timer_begin+8(%rip), %ebp
	leaq	200(%rsp), %rdi
	callq	ftime
	movq	200(%rsp), %rax
	movzwl	208(%rsp), %esi
	subq	%rbx, %rax
	imulq	$1000, %rax, %rax       # imm = 0x3E8
	subq	%rbp, %rsi
	addq	%rax, %rsi
	vcvtsi2sdq	%rsi, %xmm0, %xmm0
	vmulsd	.LCPI0_5(%rip), %xmm0, %xmm0
	vdivsd	96(%rsp), %xmm0, %xmm0  # 8-byte Folded Reload
	movl	$.L.str.13, %edi
	movb	$1, %al
	callq	printf
	movl	$0, %esi
	testl	%r12d, %r12d
	je	.LBB0_36
	.align	16, 0x90
.LBB0_43:                               # %.lr.ph.i9
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movzwl	(%r15,%rsi,2), %edx
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ssl	%edx, %xmm0, %xmm0
	vaddss	%xmm0, %xmm0, %xmm1
	vmovss	(%r14,%rsi,4), %xmm0    # xmm0 = mem[0],zero,zero,zero
	vucomiss	%xmm0, %xmm1
	jne	.LBB0_44
	jnp	.LBB0_42
.LBB0_44:
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	movl	$.L.str.18, %edi
	jmp	.LBB0_22
	.align	16, 0x90
.LBB0_42:                               #   in Loop: Header=BB0_43 Depth=2
	incq	%rsi
	cmpq	%r12, %rsi
	jb	.LBB0_43
.LBB0_36:                               # %._crit_edge.i8
                                        #   in Loop: Header=BB0_1 Depth=1
	movq	192(%rsp), %rax
	movq	%rax, 32(%rsp)
	vmovups	160(%rsp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	check_canary_page
	movl	%eax, %ebx
	movq	152(%rsp), %rax
	movq	%rax, 32(%rsp)
	vmovups	120(%rsp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	check_canary_page
	movl	%eax, %ebp
	movq	192(%rsp), %rax
	movq	%rax, 32(%rsp)
	vmovups	160(%rsp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	free_canary_page
	movq	152(%rsp), %rax
	movq	%rax, 32(%rsp)
	vmovups	120(%rsp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	free_canary_page
	orl	%ebx, %ebp
	js	.LBB0_46
# BB#37:                                # %test_load_and_iadd_m256.exit
                                        #   in Loop: Header=BB0_1 Depth=1
	movq	48(%rsp), %rbp          # 8-byte Reload
	incq	%rbp
	movq	generator(%rip), %rdi
	cmpq	$32, %rbp
	jb	.LBB0_1
# BB#38:
	callq	delete_random
	xorl	%eax, %eax
	addq	$216, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB0_21:
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	movl	$.L.str.9, %edi
.LBB0_22:
	movb	$1, %al
	callq	printf
	movl	$1, %edi
	callq	exit
.LBB0_45:
	movl	$.L.str.4, %edi
	callq	perror
	movl	$1, %edi
	callq	exit
.LBB0_46:
	movl	$.Lstr.20, %edi
	callq	puts
	movl	$1, %edi
	callq	exit
.LBB0_16:
	testl	%edx, %edx
	je	.LBB0_17
# BB#23:
	movl	$.Lstr.19, %edi
	callq	puts
	movl	$1, %edi
	callq	exit
.LBB0_17:
	movl	$.L.str.10, %edi
	movb	$1, %al
	movq	%r13, %rsi
	vmovsd	40(%rsp), %xmm0         # 8-byte Reload
                                        # xmm0 = mem[0],zero
	callq	printf
	movl	$1, %edi
	callq	exit
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc

	.type	generator,@object       # @generator
	.local	generator
	.comm	generator,8,8
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"seed = %lli\n"
	.size	.L.str, 13

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"Converting %zi floats to uint16_t (%s).\n"
	.size	.L.str.1, 41

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"aligned"
	.size	.L.str.2, 8

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"not aligned"
	.size	.L.str.3, 12

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"test_load_u16"
	.size	.L.str.4, 14

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"floats @ %p, uint16_t @ %p expecting %s.\n"
	.size	.L.str.5, 42

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"no error"
	.size	.L.str.6, 9

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"an error"
	.size	.L.str.7, 9

	.type	.L.str.8,@object        # @.str.8
.L.str.8:
	.asciz	"%f (bad float)\n"
	.size	.L.str.8, 16

	.type	timer_begin,@object     # @timer_begin
	.local	timer_begin
	.comm	timer_begin,16,8
	.type	.L.str.9,@object        # @.str.9
.L.str.9:
	.asciz	"[%zi] %i != %f\n"
	.size	.L.str.9, 16

	.type	.L.str.10,@object       # @.str.10
.L.str.10:
	.asciz	"[%zi] %f should have triggered overflow error.\n"
	.size	.L.str.10, 48

	.type	.L.str.13,@object       # @.str.13
.L.str.13:
	.asciz	"        %lims elapsed (%4.2fns per item).\n"
	.size	.L.str.13, 43

	.type	.L.str.14,@object       # @.str.14
.L.str.14:
	.asciz	"Converting %zi uint16_t to floats (%s).\n"
	.size	.L.str.14, 41

	.type	.L.str.15,@object       # @.str.15
.L.str.15:
	.asciz	"floats @ %p, uint16_t @ %p\n"
	.size	.L.str.15, 28

	.type	.L.str.16,@object       # @.str.16
.L.str.16:
	.asciz	"[%zi] %i != %f.\n"
	.size	.L.str.16, 17

	.type	.L.str.17,@object       # @.str.17
.L.str.17:
	.asciz	"Adding %zi uint16_t to floats.\n"
	.size	.L.str.17, 32

	.type	.L.str.18,@object       # @.str.18
.L.str.18:
	.asciz	"[%zi] %i * 2. != %f.\n"
	.size	.L.str.18, 22

	.type	.Lstr.19,@object        # @str.19
	.section	.rodata.str1.16,"aMS",@progbits,1
	.align	16
.Lstr.19:
	.asciz	"load_u16_from_m256 returned unexpected error."
	.size	.Lstr.19, 46

	.type	.Lstr.20,@object        # @str.20
	.align	16
.Lstr.20:
	.asciz	"Buffer overrun detected."
	.size	.Lstr.20, 25


	.ident	"clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)"
	.section	".note.GNU-stack","",@progbits
