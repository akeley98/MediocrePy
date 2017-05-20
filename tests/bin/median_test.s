	.text
	.file	"tests/median_test.c"
	.file	1 "/usr/lib/llvm-3.8/bin/../lib/clang/3.8.0/include" "stddef.h"
	.file	2 "tests" "median_test.c"
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
.LCPI0_33:
	.long	1056964608              # float 0.5
.LCPI0_34:
	.long	4286578688              # float -Inf
.LCPI0_35:
	.long	2139095040              # float +Inf
	.section	.rodata,"a",@progbits
	.align	32
.LCPI0_2:
	.long	0                       # 0x0
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	3                       # 0x3
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	6                       # 0x6
	.long	7                       # 0x7
.LCPI0_3:
	.long	8                       # 0x8
	.long	9                       # 0x9
	.long	10                      # 0xa
	.long	11                      # 0xb
	.long	12                      # 0xc
	.long	13                      # 0xd
	.long	14                      # 0xe
	.long	15                      # 0xf
.LCPI0_4:
	.long	16                      # 0x10
	.long	17                      # 0x11
	.long	18                      # 0x12
	.long	19                      # 0x13
	.long	20                      # 0x14
	.long	21                      # 0x15
	.long	22                      # 0x16
	.long	23                      # 0x17
.LCPI0_5:
	.long	24                      # 0x18
	.long	25                      # 0x19
	.long	26                      # 0x1a
	.long	27                      # 0x1b
	.long	28                      # 0x1c
	.long	29                      # 0x1d
	.long	30                      # 0x1e
	.long	31                      # 0x1f
.LCPI0_6:
	.long	32                      # 0x20
	.long	33                      # 0x21
	.long	34                      # 0x22
	.long	35                      # 0x23
	.long	36                      # 0x24
	.long	37                      # 0x25
	.long	38                      # 0x26
	.long	39                      # 0x27
.LCPI0_7:
	.long	40                      # 0x28
	.long	41                      # 0x29
	.long	42                      # 0x2a
	.long	43                      # 0x2b
	.long	44                      # 0x2c
	.long	45                      # 0x2d
	.long	46                      # 0x2e
	.long	47                      # 0x2f
.LCPI0_8:
	.long	48                      # 0x30
	.long	49                      # 0x31
	.long	50                      # 0x32
	.long	51                      # 0x33
	.long	52                      # 0x34
	.long	53                      # 0x35
	.long	54                      # 0x36
	.long	55                      # 0x37
.LCPI0_9:
	.long	56                      # 0x38
	.long	57                      # 0x39
	.long	58                      # 0x3a
	.long	59                      # 0x3b
	.long	60                      # 0x3c
	.long	61                      # 0x3d
	.long	62                      # 0x3e
	.long	63                      # 0x3f
.LCPI0_10:
	.long	64                      # 0x40
	.long	65                      # 0x41
	.long	66                      # 0x42
	.long	67                      # 0x43
	.long	68                      # 0x44
	.long	69                      # 0x45
	.long	70                      # 0x46
	.long	71                      # 0x47
.LCPI0_11:
	.long	72                      # 0x48
	.long	73                      # 0x49
	.long	74                      # 0x4a
	.long	75                      # 0x4b
	.long	76                      # 0x4c
	.long	77                      # 0x4d
	.long	78                      # 0x4e
	.long	79                      # 0x4f
.LCPI0_12:
	.long	80                      # 0x50
	.long	81                      # 0x51
	.long	82                      # 0x52
	.long	83                      # 0x53
	.long	84                      # 0x54
	.long	85                      # 0x55
	.long	86                      # 0x56
	.long	87                      # 0x57
.LCPI0_13:
	.long	88                      # 0x58
	.long	89                      # 0x59
	.long	90                      # 0x5a
	.long	91                      # 0x5b
	.long	92                      # 0x5c
	.long	93                      # 0x5d
	.long	94                      # 0x5e
	.long	95                      # 0x5f
.LCPI0_14:
	.long	96                      # 0x60
	.long	97                      # 0x61
	.long	98                      # 0x62
	.long	99                      # 0x63
	.long	100                     # 0x64
	.long	101                     # 0x65
	.long	102                     # 0x66
	.long	103                     # 0x67
.LCPI0_15:
	.long	104                     # 0x68
	.long	105                     # 0x69
	.long	106                     # 0x6a
	.long	107                     # 0x6b
	.long	108                     # 0x6c
	.long	109                     # 0x6d
	.long	110                     # 0x6e
	.long	111                     # 0x6f
.LCPI0_16:
	.long	112                     # 0x70
	.long	113                     # 0x71
	.long	114                     # 0x72
	.long	115                     # 0x73
	.long	116                     # 0x74
	.long	117                     # 0x75
	.long	118                     # 0x76
	.long	119                     # 0x77
.LCPI0_17:
	.long	120                     # 0x78
	.long	121                     # 0x79
	.long	122                     # 0x7a
	.long	123                     # 0x7b
	.long	124                     # 0x7c
	.long	125                     # 0x7d
	.long	126                     # 0x7e
	.long	127                     # 0x7f
.LCPI0_18:
	.long	128                     # 0x80
	.long	129                     # 0x81
	.long	130                     # 0x82
	.long	131                     # 0x83
	.long	132                     # 0x84
	.long	133                     # 0x85
	.long	134                     # 0x86
	.long	135                     # 0x87
.LCPI0_19:
	.long	136                     # 0x88
	.long	137                     # 0x89
	.long	138                     # 0x8a
	.long	139                     # 0x8b
	.long	140                     # 0x8c
	.long	141                     # 0x8d
	.long	142                     # 0x8e
	.long	143                     # 0x8f
.LCPI0_20:
	.long	144                     # 0x90
	.long	145                     # 0x91
	.long	146                     # 0x92
	.long	147                     # 0x93
	.long	148                     # 0x94
	.long	149                     # 0x95
	.long	150                     # 0x96
	.long	151                     # 0x97
.LCPI0_21:
	.long	152                     # 0x98
	.long	153                     # 0x99
	.long	154                     # 0x9a
	.long	155                     # 0x9b
	.long	156                     # 0x9c
	.long	157                     # 0x9d
	.long	158                     # 0x9e
	.long	159                     # 0x9f
.LCPI0_22:
	.long	160                     # 0xa0
	.long	161                     # 0xa1
	.long	162                     # 0xa2
	.long	163                     # 0xa3
	.long	164                     # 0xa4
	.long	165                     # 0xa5
	.long	166                     # 0xa6
	.long	167                     # 0xa7
.LCPI0_23:
	.long	168                     # 0xa8
	.long	169                     # 0xa9
	.long	170                     # 0xaa
	.long	171                     # 0xab
	.long	172                     # 0xac
	.long	173                     # 0xad
	.long	174                     # 0xae
	.long	175                     # 0xaf
.LCPI0_24:
	.long	176                     # 0xb0
	.long	177                     # 0xb1
	.long	178                     # 0xb2
	.long	179                     # 0xb3
	.long	180                     # 0xb4
	.long	181                     # 0xb5
	.long	182                     # 0xb6
	.long	183                     # 0xb7
.LCPI0_25:
	.long	184                     # 0xb8
	.long	185                     # 0xb9
	.long	186                     # 0xba
	.long	187                     # 0xbb
	.long	188                     # 0xbc
	.long	189                     # 0xbd
	.long	190                     # 0xbe
	.long	191                     # 0xbf
.LCPI0_26:
	.long	192                     # 0xc0
	.long	193                     # 0xc1
	.long	194                     # 0xc2
	.long	195                     # 0xc3
	.long	196                     # 0xc4
	.long	197                     # 0xc5
	.long	198                     # 0xc6
	.long	199                     # 0xc7
.LCPI0_27:
	.long	200                     # 0xc8
	.long	201                     # 0xc9
	.long	202                     # 0xca
	.long	203                     # 0xcb
	.long	204                     # 0xcc
	.long	205                     # 0xcd
	.long	206                     # 0xce
	.long	207                     # 0xcf
.LCPI0_28:
	.long	208                     # 0xd0
	.long	209                     # 0xd1
	.long	210                     # 0xd2
	.long	211                     # 0xd3
	.long	212                     # 0xd4
	.long	213                     # 0xd5
	.long	214                     # 0xd6
	.long	215                     # 0xd7
.LCPI0_29:
	.long	216                     # 0xd8
	.long	217                     # 0xd9
	.long	218                     # 0xda
	.long	219                     # 0xdb
	.long	220                     # 0xdc
	.long	221                     # 0xdd
	.long	222                     # 0xde
	.long	223                     # 0xdf
	.section	.rodata.cst8,"aM",@progbits,8
	.align	8
.LCPI0_30:
	.quad	4696837146684686336     # double 1.0E+6
	.section	.rodata.cst16,"aM",@progbits,16
	.align	16
.LCPI0_31:
	.long	1127219200              # 0x43300000
	.long	1160773632              # 0x45300000
	.long	0                       # 0x0
	.long	0                       # 0x0
.LCPI0_32:
	.quad	4841369599423283200     # double 4503599627370496
	.quad	4985484787499139072     # double 1.9342813113834067E+25
	.text
	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
.Lfunc_begin0:
	.loc	2 255 0                 # tests/median_test.c:255:0
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
	subq	$440, %rsp              # imm = 0x1B8
.Ltmp6:
	.cfi_def_cfa_offset 496
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
	.loc	2 256 17 prologue_end   # tests/median_test.c:256:17
.Ltmp13:
	callq	new_random@PLT
	movq	%rax, %rdi
	.loc	2 256 15 is_stmt 0      # tests/median_test.c:256:15
	movq	%rdi, generator(%rip)
.Ltmp14:
	#DEBUG_VALUE: i <- 0
	.loc	2 129 27 is_stmt 1      # tests/median_test.c:129:27
	leaq	test_median.input_pointers(%rip), %rbx
	xorl	%r14d, %r14d
	jmp	.LBB0_1
.Ltmp15:
	.align	16, 0x90
.LBB0_86:                               # %test_median.exit._crit_edge
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test_median:b <- %RSI
	#DEBUG_VALUE: i <- %R14
	.loc	2 260 13                # tests/median_test.c:260:13
	movq	generator(%rip), %rdi
.Ltmp16:
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_17 Depth 2
                                        #     Child Loop BB0_20 Depth 2
                                        #       Child Loop BB0_22 Depth 3
                                        #     Child Loop BB0_26 Depth 2
                                        #       Child Loop BB0_31 Depth 3
                                        #       Child Loop BB0_33 Depth 3
                                        #         Child Loop BB0_56 Depth 4
                                        #         Child Loop BB0_44 Depth 4
                                        #         Child Loop BB0_68 Depth 4
	.loc	2 259 30 discriminator 1 # tests/median_test.c:259:30
	movl	$50, %esi
	movl	$250, %edx
	callq	random_dist_u32@PLT
	.loc	2 259 30 is_stmt 0      # tests/median_test.c:259:30
	movl	%eax, %r13d
.Ltmp17:
	#DEBUG_VALUE: array_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: current_count <- %R13
	.loc	2 263 13 is_stmt 1      # tests/median_test.c:263:13
	movq	generator(%rip), %rdi
	.loc	2 262 28 discriminator 1 # tests/median_test.c:262:28
	movl	$400000, %esi           # imm = 0x61A80
	movl	$450000, %edx           # imm = 0x6DDD0
	callq	random_dist_u32@PLT
	.loc	2 262 28 is_stmt 0      # tests/median_test.c:262:28
	movl	%eax, %r15d
.Ltmp18:
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	.loc	2 265 42 is_stmt 1      # tests/median_test.c:265:42
	movq	generator(%rip), %rdi
	xorl	%esi, %esi
	.loc	2 265 26 is_stmt 0 discriminator 1 # tests/median_test.c:265:26
	movl	$15, %edx
	callq	random_dist_u32@PLT
	.loc	2 265 26                # tests/median_test.c:265:26
	movl	%eax, %ebp
.Ltmp19:
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	.loc	2 266 42 is_stmt 1      # tests/median_test.c:266:42
	movq	generator(%rip), %rdi
	xorl	%esi, %esi
	.loc	2 265 26 discriminator 1 # tests/median_test.c:265:26
	movl	$15, %edx
	.loc	2 266 26 discriminator 1 # tests/median_test.c:266:26
	callq	random_dist_u32@PLT
	.loc	2 266 26 is_stmt 0      # tests/median_test.c:266:26
	movl	%eax, %eax
.Ltmp20:
	#DEBUG_VALUE: offset1 <- [%RSP+208]
	#DEBUG_VALUE: test_median:offset1 <- [%RSP+208]
	.loc	2 267 61 is_stmt 1      # tests/median_test.c:267:61
	movq	%rax, 208(%rsp)         # 8-byte Spill
	movq	generator(%rip), %rdi
	xorl	%esi, %esi
	.loc	2 267 45 is_stmt 0 discriminator 1 # tests/median_test.c:267:45
	movl	$12, %edx
	callq	random_dist_u32@PLT
.Ltmp21:
	.loc	2 267 45                # tests/median_test.c:267:45
	movl	%eax, %eax
	.loc	2 268 61 is_stmt 1      # tests/median_test.c:268:61
	movq	%rax, 240(%rsp)         # 8-byte Spill
	movq	generator(%rip), %rdi
	xorl	%esi, %esi
	.loc	2 267 45 discriminator 1 # tests/median_test.c:267:45
	movl	$12, %edx
	.loc	2 268 45 discriminator 1 # tests/median_test.c:268:45
	callq	random_dist_u32@PLT
	.loc	2 268 45 is_stmt 0      # tests/median_test.c:268:45
	movl	%eax, %r12d
	.loc	2 270 13 is_stmt 1      # tests/median_test.c:270:13
	movq	generator(%rip), %rdi
	xorl	%esi, %esi
	.loc	2 269 27 discriminator 1 # tests/median_test.c:269:27
	movl	$5, %edx
	callq	random_dist_u32@PLT
	.loc	2 269 27 is_stmt 0      # tests/median_test.c:269:27
	movl	%eax, %eax
.Ltmp22:
	#DEBUG_VALUE: max_iter <- [%RSP+184]
	#DEBUG_VALUE: test_median:max_iter <- [%RSP+184]
	.loc	2 122 5 is_stmt 1       # tests/median_test.c:122:5
	movq	%rax, 184(%rsp)         # 8-byte Spill
	leaq	-50(%r13), %rax
	cmpq	$201, %rax
	jae	.LBB0_88
.Ltmp23:
# BB#2:                                 #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test_median:max_iter <- [%RSP+184]
	#DEBUG_VALUE: max_iter <- [%RSP+184]
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: array_count <- %R13
	.loc	2 123 5                 # tests/median_test.c:123:5
	leaq	-400000(%r15), %rax
	cmpq	$50001, %rax            # imm = 0xC351
	jae	.LBB0_89
.Ltmp24:
# BB#3:                                 #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: array_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	#DEBUG_VALUE: max_iter <- [%RSP+184]
	#DEBUG_VALUE: test_median:max_iter <- [%RSP+184]
	.loc	2 124 5                 # tests/median_test.c:124:5
	cmpl	$16, %ebp
	jae	.LBB0_90
.Ltmp25:
# BB#4:                                 #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test_median:max_iter <- [%RSP+184]
	#DEBUG_VALUE: max_iter <- [%RSP+184]
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: array_count <- %R13
	movq	%rbp, 152(%rsp)         # 8-byte Spill
	.loc	2 125 5                 # tests/median_test.c:125:5
	movq	208(%rsp), %rax         # 8-byte Reload
	cmpl	$15, %eax
	ja	.LBB0_7
.Ltmp26:
# BB#5:                                 # %.preheader14.preheader.i
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: array_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	#DEBUG_VALUE: max_iter <- [%RSP+184]
	#DEBUG_VALUE: test_median:max_iter <- [%RSP+184]
	xorl	%esi, %esi
	.loc	2 129 27                # tests/median_test.c:129:27
.Ltmp27:
	movl	$2000, %edx             # imm = 0x7D0
	movq	%rbx, %rdi
	callq	memset@PLT
.Ltmp28:
	.loc	2 82 9                  # tests/median_test.c:82:9
	movzbl	get_shuffled_array_counts.init(%rip), %eax
	andl	$1, %eax
	cmpl	$1, %eax
	jne	.LBB0_8
.Ltmp29:
# BB#6:                                 # %get_shuffled_array_counts.exit.thread.i
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: array_count <- %R13
	.loc	2 88 17                 # tests/median_test.c:88:17
	movq	generator(%rip), %rdi
	.loc	2 88 5 is_stmt 0        # tests/median_test.c:88:5
	movl	$250, %edx
	leaq	get_shuffled_array_counts.numbers(%rip), %rsi
	callq	shuffle_u32@PLT
.Ltmp30:
	#DEBUG_VALUE: i <- 0
	jmp	.LBB0_9
.Ltmp31:
	.align	16, 0x90
.LBB0_8:                                # %scalar.ph84
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: array_count <- %R13
	.loc	2 134 32 is_stmt 1 discriminator 1 # tests/median_test.c:134:32
	movb	$1, get_shuffled_array_counts.init(%rip)
.Ltmp32:
	#DEBUG_VALUE: i <- 0
	.loc	2 85 24                 # tests/median_test.c:85:24
	vmovaps	.LCPI0_2(%rip), %ymm0   # ymm0 = [0,1,2,3,4,5,6,7]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers(%rip)
	vmovaps	.LCPI0_3(%rip), %ymm0   # ymm0 = [8,9,10,11,12,13,14,15]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+32(%rip)
	vmovaps	.LCPI0_4(%rip), %ymm0   # ymm0 = [16,17,18,19,20,21,22,23]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+64(%rip)
	vmovaps	.LCPI0_5(%rip), %ymm0   # ymm0 = [24,25,26,27,28,29,30,31]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+96(%rip)
	vmovaps	.LCPI0_6(%rip), %ymm0   # ymm0 = [32,33,34,35,36,37,38,39]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+128(%rip)
	vmovaps	.LCPI0_7(%rip), %ymm0   # ymm0 = [40,41,42,43,44,45,46,47]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+160(%rip)
	vmovaps	.LCPI0_8(%rip), %ymm0   # ymm0 = [48,49,50,51,52,53,54,55]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+192(%rip)
	vmovaps	.LCPI0_9(%rip), %ymm0   # ymm0 = [56,57,58,59,60,61,62,63]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+224(%rip)
	vmovaps	.LCPI0_10(%rip), %ymm0  # ymm0 = [64,65,66,67,68,69,70,71]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+256(%rip)
	vmovaps	.LCPI0_11(%rip), %ymm0  # ymm0 = [72,73,74,75,76,77,78,79]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+288(%rip)
	vmovaps	.LCPI0_12(%rip), %ymm0  # ymm0 = [80,81,82,83,84,85,86,87]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+320(%rip)
	vmovaps	.LCPI0_13(%rip), %ymm0  # ymm0 = [88,89,90,91,92,93,94,95]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+352(%rip)
	vmovaps	.LCPI0_14(%rip), %ymm0  # ymm0 = [96,97,98,99,100,101,102,103]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+384(%rip)
	vmovaps	.LCPI0_15(%rip), %ymm0  # ymm0 = [104,105,106,107,108,109,110,111]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+416(%rip)
	vmovaps	.LCPI0_16(%rip), %ymm0  # ymm0 = [112,113,114,115,116,117,118,119]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+448(%rip)
	vmovaps	.LCPI0_17(%rip), %ymm0  # ymm0 = [120,121,122,123,124,125,126,127]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+480(%rip)
	vmovaps	.LCPI0_18(%rip), %ymm0  # ymm0 = [128,129,130,131,132,133,134,135]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+512(%rip)
	vmovaps	.LCPI0_19(%rip), %ymm0  # ymm0 = [136,137,138,139,140,141,142,143]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+544(%rip)
	vmovaps	.LCPI0_20(%rip), %ymm0  # ymm0 = [144,145,146,147,148,149,150,151]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+576(%rip)
	vmovaps	.LCPI0_21(%rip), %ymm0  # ymm0 = [152,153,154,155,156,157,158,159]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+608(%rip)
	vmovaps	.LCPI0_22(%rip), %ymm0  # ymm0 = [160,161,162,163,164,165,166,167]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+640(%rip)
	vmovaps	.LCPI0_23(%rip), %ymm0  # ymm0 = [168,169,170,171,172,173,174,175]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+672(%rip)
	vmovaps	.LCPI0_24(%rip), %ymm0  # ymm0 = [176,177,178,179,180,181,182,183]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+704(%rip)
	vmovaps	.LCPI0_25(%rip), %ymm0  # ymm0 = [184,185,186,187,188,189,190,191]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+736(%rip)
	vmovaps	.LCPI0_26(%rip), %ymm0  # ymm0 = [192,193,194,195,196,197,198,199]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+768(%rip)
	vmovaps	.LCPI0_27(%rip), %ymm0  # ymm0 = [200,201,202,203,204,205,206,207]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+800(%rip)
	vmovaps	.LCPI0_28(%rip), %ymm0  # ymm0 = [208,209,210,211,212,213,214,215]
	vmovaps	%ymm0, get_shuffled_array_counts.numbers+832(%rip)
	vmovapd	.LCPI0_29(%rip), %ymm0  # ymm0 = [216,217,218,219,220,221,222,223]
	vmovapd	%ymm0, get_shuffled_array_counts.numbers+864(%rip)
	movabsq	$966367641824, %rax     # imm = 0xE1000000E0
	movq	%rax, get_shuffled_array_counts.numbers+896(%rip)
	movabsq	$974957576418, %rax     # imm = 0xE3000000E2
	movq	%rax, get_shuffled_array_counts.numbers+904(%rip)
	movabsq	$983547511012, %rax     # imm = 0xE5000000E4
	movq	%rax, get_shuffled_array_counts.numbers+912(%rip)
	movabsq	$992137445606, %rax     # imm = 0xE7000000E6
	movq	%rax, get_shuffled_array_counts.numbers+920(%rip)
	movabsq	$1000727380200, %rax    # imm = 0xE9000000E8
	movq	%rax, get_shuffled_array_counts.numbers+928(%rip)
	movabsq	$1009317314794, %rax    # imm = 0xEB000000EA
	movq	%rax, get_shuffled_array_counts.numbers+936(%rip)
	movabsq	$1017907249388, %rax    # imm = 0xED000000EC
	movq	%rax, get_shuffled_array_counts.numbers+944(%rip)
	movabsq	$1026497183982, %rax    # imm = 0xEF000000EE
	movq	%rax, get_shuffled_array_counts.numbers+952(%rip)
	movabsq	$1035087118576, %rax    # imm = 0xF1000000F0
	movq	%rax, get_shuffled_array_counts.numbers+960(%rip)
	movabsq	$1043677053170, %rax    # imm = 0xF3000000F2
	movq	%rax, get_shuffled_array_counts.numbers+968(%rip)
	movabsq	$1052266987764, %rax    # imm = 0xF5000000F4
	movq	%rax, get_shuffled_array_counts.numbers+976(%rip)
	movabsq	$1060856922358, %rax    # imm = 0xF7000000F6
	movq	%rax, get_shuffled_array_counts.numbers+984(%rip)
	movabsq	$1069446856952, %rax    # imm = 0xF9000000F8
	movq	%rax, get_shuffled_array_counts.numbers+992(%rip)
.Ltmp33:
	.loc	2 88 17                 # tests/median_test.c:88:17
	movq	generator(%rip), %rdi
	.loc	2 88 5 is_stmt 0        # tests/median_test.c:88:5
	movl	$250, %edx
	leaq	get_shuffled_array_counts.numbers(%rip), %rsi
	vzeroupper
	callq	shuffle_u32@PLT
	#DEBUG_VALUE: i <- 0
	movb	$1, %al
.Ltmp34:
	.loc	2 135 26 is_stmt 1 discriminator 1 # tests/median_test.c:135:26
	movl	%eax, 180(%rsp)         # 4-byte Spill
	testl	%r13d, %r13d
	je	.LBB0_13
.Ltmp35:
.LBB0_9:                                # %.lr.ph49.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: array_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	movl	$0, %edx
	.loc	2 136 43                # tests/median_test.c:136:43
.Ltmp36:
	testb	$1, %r13b
	.loc	2 136 40 is_stmt 0      # tests/median_test.c:136:40
	leaq	input_data(%rip), %rdi
	movq	152(%rsp), %rbp         # 8-byte Reload
.Ltmp37:
	je	.LBB0_11
.Ltmp38:
# BB#10:                                # %.lr.ph49.i.prol
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: array_count <- %R13
	.loc	2 136 43                # tests/median_test.c:136:43
	movl	get_shuffled_array_counts.numbers(%rip), %eax
	.loc	2 136 55                # tests/median_test.c:136:55
	imulq	%r15, %rax
	.loc	2 136 40                # tests/median_test.c:136:40
	leaq	(%rdi,%rax,2), %rax
	.loc	2 136 68                # tests/median_test.c:136:68
	leaq	(%rax,%rbp,2), %rax
	.loc	2 136 27                # tests/median_test.c:136:27
	movq	%rax, test_median.input_pointers(%rip)
.Ltmp39:
	#DEBUG_VALUE: i <- 1
	movl	$1, %edx
.Ltmp40:
.LBB0_11:                               # %.lr.ph49.i.preheader.split
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: array_count <- %R13
	.loc	2 136 43                # tests/median_test.c:136:43
	cmpl	$1, %r13d
	je	.LBB0_12
.Ltmp41:
# BB#16:                                # %.lr.ph49.i.preheader.split.split
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: array_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	movq	%r13, %rax
	subq	%rdx, %rax
	leaq	8(%rbx,%rdx,8), %rcx
.Ltmp42:
	.loc	2 88 5 is_stmt 1        # tests/median_test.c:88:5
	leaq	get_shuffled_array_counts.numbers(%rip), %rsi
.Ltmp43:
	.loc	2 136 43                # tests/median_test.c:136:43
	leaq	4(%rsi,%rdx,4), %rdx
.Ltmp44:
	.align	16, 0x90
.LBB0_17:                               # %.lr.ph49.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	-4(%rdx), %esi
	.loc	2 136 55 is_stmt 0      # tests/median_test.c:136:55
	imulq	%r15, %rsi
	.loc	2 136 40                # tests/median_test.c:136:40
	leaq	(%rdi,%rsi,2), %rsi
	.loc	2 136 68                # tests/median_test.c:136:68
	leaq	(%rsi,%rbp,2), %rsi
	.loc	2 136 27                # tests/median_test.c:136:27
	movq	%rsi, -8(%rcx)
	.loc	2 136 43                # tests/median_test.c:136:43
	movl	(%rdx), %esi
	.loc	2 136 55                # tests/median_test.c:136:55
	imulq	%r15, %rsi
	.loc	2 136 40                # tests/median_test.c:136:40
	leaq	(%rdi,%rsi,2), %rsi
	.loc	2 136 68                # tests/median_test.c:136:68
	leaq	(%rsi,%rbp,2), %rsi
	.loc	2 136 27                # tests/median_test.c:136:27
	movq	%rsi, (%rcx)
.Ltmp45:
	.loc	2 135 5 is_stmt 1 discriminator 1 # tests/median_test.c:135:5
	addq	$16, %rcx
	addq	$8, %rdx
	addq	$-2, %rax
	jne	.LBB0_17
.Ltmp46:
.LBB0_12:                               #   in Loop: Header=BB0_1 Depth=1
	movl	$0, 180(%rsp)           # 4-byte Folded Spill
.LBB0_13:                               # %._crit_edge50.i
                                        #   in Loop: Header=BB0_1 Depth=1
	.loc	2 142 56                # tests/median_test.c:142:56
.Ltmp47:
	leaq	(%r15,%r15), %rsi
.Ltmp48:
	#DEBUG_VALUE: test_median:input_page <- undef
	xorl	%edx, %edx
	leaq	384(%rsp), %rdi
	.loc	2 142 9 is_stmt 0       # tests/median_test.c:142:9
	callq	init_canary_page@PLT
	.loc	2 142 72                # tests/median_test.c:142:72
	testl	%eax, %eax
	jne	.LBB0_14
.Ltmp49:
# BB#18:                                #   in Loop: Header=BB0_1 Depth=1
	movq	%r14, 136(%rsp)         # 8-byte Spill
	.loc	2 267 45 is_stmt 1      # tests/median_test.c:267:45
	vcvtsi2ssq	240(%rsp), %xmm0, %xmm0 # 8-byte Folded Reload
	.loc	2 268 45                # tests/median_test.c:268:45
	vcvtsi2ssq	%r12, %xmm0, %xmm1
	.loc	2 267 43                # tests/median_test.c:267:43
	vmovss	.LCPI0_0(%rip), %xmm2   # xmm2 = mem[0],zero,zero,zero
	vmulss	%xmm2, %xmm0, %xmm0
	.loc	2 268 43                # tests/median_test.c:268:43
	vmulss	%xmm2, %xmm1, %xmm1
	.loc	2 267 35                # tests/median_test.c:267:35
	vmovss	.LCPI0_1(%rip), %xmm2   # xmm2 = mem[0],zero,zero,zero
	vaddss	%xmm2, %xmm0, %xmm0
	.loc	2 268 35                # tests/median_test.c:268:35
	vaddss	%xmm2, %xmm1, %xmm1
	.loc	2 267 30                # tests/median_test.c:267:30
	vcvtss2sd	%xmm0, %xmm0, %xmm0
.Ltmp50:
	#DEBUG_VALUE: sigma_lower <- [%RSP+200]
	#DEBUG_VALUE: test_median:sigma_lower <- [%RSP+200]
	.loc	2 268 30                # tests/median_test.c:268:30
	vmovsd	%xmm0, 200(%rsp)        # 8-byte Spill
	vcvtss2sd	%xmm1, %xmm1, %xmm0
.Ltmp51:
	#DEBUG_VALUE: sigma_upper <- [%RSP+192]
	#DEBUG_VALUE: test_median:sigma_upper <- [%RSP+192]
	.loc	2 147 22                # tests/median_test.c:147:22
	vmovsd	%xmm0, 192(%rsp)        # 8-byte Spill
	movq	384(%rsp), %rbp
	.loc	2 146 36                # tests/median_test.c:146:36
	movq	generator(%rip), %rdi
	.loc	2 146 62 is_stmt 0      # tests/median_test.c:146:62
	leaq	-1(%r13), %rdx
	.loc	2 146 20                # tests/median_test.c:146:20
	movq	%rdx, 160(%rsp)         # 8-byte Spill
	xorl	%esi, %esi
	callq	random_dist_u32@PLT
.Ltmp52:
	.loc	2 146 5                 # tests/median_test.c:146:5
	movl	%eax, %eax
	.loc	2 147 9 is_stmt 1       # tests/median_test.c:147:9
	movq	%rbp, (%rbx,%rax,8)
	.loc	2 151 37                # tests/median_test.c:151:37
	leaq	(,%r15,4), %rsi
	.loc	2 151 58 is_stmt 0      # tests/median_test.c:151:58
	movq	208(%rsp), %rax         # 8-byte Reload
	leaq	(,%rax,4), %rdx
.Ltmp53:
	#DEBUG_VALUE: test_median:output_page <- undef
	leaq	344(%rsp), %rdi
	.loc	2 150 5 is_stmt 1       # tests/median_test.c:150:5
	callq	init_canary_page@PLT
	.loc	2 153 41                # tests/median_test.c:153:41
	movq	344(%rsp), %rax
.Ltmp54:
	#DEBUG_VALUE: test_median:output_pointer <- [%RSP+168]
	.loc	2 156 43                # tests/median_test.c:156:43
	movq	%rax, 168(%rsp)         # 8-byte Spill
	movq	generator(%rip), %rdi
	xorl	%esi, %esi
	.loc	2 156 27 is_stmt 0 discriminator 1 # tests/median_test.c:156:27
.Ltmp55:
	movl	$3071, %edx             # imm = 0xBFF
	callq	random_dist_u32@PLT
.Ltmp56:
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: test_median:base <- %EAX
	#DEBUG_VALUE: random_fill:base <- %EAX
	.loc	2 157 5 is_stmt 1 discriminator 1 # tests/median_test.c:157:5
	movq	%rax, 240(%rsp)         # 8-byte Spill
	movl	180(%rsp), %eax         # 4-byte Reload
.Ltmp57:
	testb	%al, %al
	jne	.LBB0_24
# BB#19:                                # %.lr.ph46.i
                                        #   in Loop: Header=BB0_1 Depth=1
	xorl	%eax, %eax
	movq	%rax, 224(%rsp)         # 8-byte Spill
.Ltmp58:
	.align	16, 0x90
.LBB0_20:                               #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_22 Depth 3
	testl	%r15d, %r15d
.Ltmp59:
	#DEBUG_VALUE: i <- 0
	je	.LBB0_23
# BB#21:                                #   in Loop: Header=BB0_20 Depth=2
	.loc	2 158 21                # tests/median_test.c:158:21
.Ltmp60:
	movq	224(%rsp), %rax         # 8-byte Reload
	movq	(%rbx,%rax,8), %r12
.Ltmp61:
	#DEBUG_VALUE: random_fill:out <- %R12
	.loc	2 158 9 is_stmt 0       # tests/median_test.c:158:9
	movq	%r15, %r14
.Ltmp62:
	.align	16, 0x90
.LBB0_22:                               # %.lr.ph.i.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_20 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	.loc	2 94 33 is_stmt 1       # tests/median_test.c:94:33
	movq	generator(%rip), %rdi
	.loc	2 94 22 is_stmt 0 discriminator 1 # tests/median_test.c:94:22
.Ltmp63:
	callq	random_u32@PLT
	movl	%eax, %ebp
.Ltmp64:
	#DEBUG_VALUE: r <- %EBP
	.loc	2 95 33 is_stmt 1       # tests/median_test.c:95:33
	movq	generator(%rip), %rdi
	.loc	2 95 22 is_stmt 0 discriminator 1 # tests/median_test.c:95:22
.Ltmp65:
	callq	random_u32@PLT
	movq	240(%rsp), %r9          # 8-byte Reload
.Ltmp66:
	#DEBUG_VALUE: s <- %EAX
	.loc	2 97 22 is_stmt 1       # tests/median_test.c:97:22
	movl	%ebp, %ecx
	andl	$127, %ecx
	.loc	2 98 11                 # tests/median_test.c:98:11
	movl	%ebp, %esi
	shrl	$10, %esi
.Ltmp67:
	#DEBUG_VALUE: r <- %ESI
	.loc	2 99 16                 # tests/median_test.c:99:16
	leal	(,%rsi,8), %edx
	subl	%esi, %edx
	.loc	2 99 30 is_stmt 0       # tests/median_test.c:99:30
	andl	$1023, %edx             # imm = 0x3FF
	.loc	2 100 11 is_stmt 1      # tests/median_test.c:100:11
	shrl	$20, %ebp
.Ltmp68:
	#DEBUG_VALUE: r <- %EBP
	.loc	2 101 16                # tests/median_test.c:101:16
	leal	(%rbp,%rbp,4), %r8d
	.loc	2 103 16                # tests/median_test.c:103:16
	leal	(,%rax,8), %edi
	subl	%eax, %edi
	.loc	2 103 30 is_stmt 0      # tests/median_test.c:103:30
	andl	$1023, %edi             # imm = 0x3FF
	.loc	2 104 11 is_stmt 1      # tests/median_test.c:104:11
	movl	%eax, %ebp
.Ltmp69:
	shrl	$10, %ebp
.Ltmp70:
	#DEBUG_VALUE: s <- %EBP
	.loc	2 105 16                # tests/median_test.c:105:16
	leal	(,%rbp,8), %esi
	subl	%ebp, %esi
	.loc	2 105 30 is_stmt 0      # tests/median_test.c:105:30
	andl	$1023, %esi             # imm = 0x3FF
	.loc	2 106 11 is_stmt 1      # tests/median_test.c:106:11
	shrl	$20, %eax
.Ltmp71:
	#DEBUG_VALUE: s <- %EAX
	.loc	2 107 16                # tests/median_test.c:107:16
	leal	(%rax,%rax,2), %eax
.Ltmp72:
	.loc	2 99 11                 # tests/median_test.c:99:11
	leal	(%r9,%rcx,8), %ecx
	.loc	2 101 11                # tests/median_test.c:101:11
	addl	%r8d, %ecx
	.loc	2 103 11                # tests/median_test.c:103:11
	addl	%edx, %ecx
	.loc	2 105 11                # tests/median_test.c:105:11
	addl	%eax, %ecx
	.loc	2 107 11                # tests/median_test.c:107:11
	addl	%edi, %ecx
	.loc	2 109 20                # tests/median_test.c:109:20
	addl	%esi, %ecx
	.loc	2 109 16 is_stmt 0      # tests/median_test.c:109:16
	movw	%cx, (%r12)
.Ltmp73:
	.loc	2 93 5 is_stmt 1 discriminator 1 # tests/median_test.c:93:5
	addq	$2, %r12
	decq	%r14
	jne	.LBB0_22
.Ltmp74:
.LBB0_23:                               # %random_fill.exit.i
                                        #   in Loop: Header=BB0_20 Depth=2
	movq	224(%rsp), %rax         # 8-byte Reload
	.loc	2 157 41 discriminator 3 # tests/median_test.c:157:41
.Ltmp75:
	incq	%rax
.Ltmp76:
	#DEBUG_VALUE: i <- %RAX
	.loc	2 157 5 is_stmt 0 discriminator 1 # tests/median_test.c:157:5
	movq	%rax, 224(%rsp)         # 8-byte Spill
	cmpq	%r13, %rax
.Ltmp77:
	#DEBUG_VALUE: i <- [%RSP+224]
	jne	.LBB0_20
.Ltmp78:
.LBB0_24:                               # %._crit_edge47.i
                                        #   in Loop: Header=BB0_1 Depth=1
	.loc	2 162 45 is_stmt 1      # tests/median_test.c:162:45
	movq	generator(%rip), %rdi
	.loc	2 162 29 is_stmt 0 discriminator 1 # tests/median_test.c:162:29
.Ltmp79:
	movl	$1, %esi
.Ltmp80:
	.loc	2 267 45 is_stmt 1 discriminator 1 # tests/median_test.c:267:45
	movl	$12, %edx
	.loc	2 162 29 discriminator 1 # tests/median_test.c:162:29
.Ltmp81:
	callq	random_dist_u32@PLT
	movl	%eax, %r14d
.Ltmp82:
	#DEBUG_VALUE: test_median:thread_count <- %R14D
	.loc	2 164 58                # tests/median_test.c:164:58
	movq	generator(%rip), %rdi
	.loc	2 164 49 is_stmt 0      # tests/median_test.c:164:49
	callq	get_seed@PLT
	movq	%rax, %rcx
	xorl	%eax, %eax
	.loc	2 164 5 discriminator 1 # tests/median_test.c:164:5
.Ltmp83:
	leaq	.L.str.6(%rip), %rdi
	movq	%rcx, %rsi
	callq	printf@PLT
	xorl	%eax, %eax
.Ltmp84:
	.loc	2 165 5 is_stmt 1       # tests/median_test.c:165:5
	leaq	.L.str.7(%rip), %rdi
	movq	%r13, %rsi
	movq	%r15, %rdx
	callq	printf@PLT
	xorl	%eax, %eax
	.loc	2 166 5                 # tests/median_test.c:166:5
	leaq	.L.str.8(%rip), %rdi
	movq	152(%rsp), %rsi         # 8-byte Reload
	movq	208(%rsp), %rdx         # 8-byte Reload
	callq	printf@PLT
	.loc	2 167 5                 # tests/median_test.c:167:5
	movb	$2, %al
	leaq	.L.str.9(%rip), %rdi
	vmovsd	200(%rsp), %xmm0        # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vmovsd	192(%rsp), %xmm1        # 8-byte Reload
                                        # xmm1 = mem[0],zero
	movq	184(%rsp), %rbp         # 8-byte Reload
	movq	%rbp, %rsi
	callq	printf@PLT
	xorl	%eax, %eax
	.loc	2 168 5                 # tests/median_test.c:168:5
	leaq	.L.str.10(%rip), %rdi
	movl	%r14d, %esi
	callq	printf@PLT
	.loc	2 173 5                 # tests/median_test.c:173:5
	leaq	timer_begin(%rip), %rdi
	callq	ftime@PLT
.Ltmp85:
	#DEBUG_VALUE: u16_input:result [bit_piece offset=320 size=32] <- 0
	.loc	2 58 12                 # tests/median_test.c:58:12
	leaq	u16_input_loop(%rip), %rax
	movq	%rax, 296(%rsp)
	leaq	no_op(%rip), %rax
	movq	%rax, 304(%rsp)
	movq	%rbx, 312(%rsp)
	movq	%r13, 320(%rsp)
	movq	%r15, 328(%rsp)
	movl	$0, 336(%rsp)
	leaq	264(%rsp), %rdi
.Ltmp86:
	.loc	2 177 9                 # tests/median_test.c:177:9
	vmovsd	200(%rsp), %xmm0        # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vmovsd	192(%rsp), %xmm1        # 8-byte Reload
                                        # xmm1 = mem[0],zero
	movq	%rbp, %rsi
	callq	mediocre_clipped_median_functor2@PLT
	.loc	2 174 18                # tests/median_test.c:174:18
	vmovups	296(%rsp), %ymm0
	vmovups	312(%rsp), %ymm1
	vmovups	%ymm1, 16(%rsp)
	vmovups	%ymm0, (%rsp)
	vmovups	264(%rsp), %ymm0
	vmovups	%ymm0, 48(%rsp)
	movq	168(%rsp), %rdi         # 8-byte Reload
	movl	%r14d, %esi
	vzeroupper
	callq	mediocre_combine_destroy@PLT
	movl	%eax, 240(%rsp)         # 4-byte Spill
.Ltmp87:
	#DEBUG_VALUE: test_median:status <- [%RSP+240]
	xorl	%eax, %eax
	.loc	2 181 5                 # tests/median_test.c:181:5
	leaq	.L.str.11(%rip), %rdi
	callq	printf@PLT
.Ltmp88:
	.loc	2 182 50                # tests/median_test.c:182:50
	movq	%r15, %rbp
	imulq	%r13, %rbp
.Ltmp89:
	#DEBUG_VALUE: print_timer_elapsed:item_count <- %RBP
	.loc	2 182 5 is_stmt 0       # tests/median_test.c:182:5
	movq	timer_begin(%rip), %r12
.Ltmp90:
	#DEBUG_VALUE: print_timer_elapsed:before [bit_piece offset=0 size=64] <- %R12
	#DEBUG_VALUE: ms_elapsed:before [bit_piece offset=0 size=64] <- %R12
	movzwl	timer_begin+8(%rip), %r14d
.Ltmp91:
	#DEBUG_VALUE: ms_elapsed:now <- undef
	leaq	424(%rsp), %rdi
	.file	7 "src/inline" "testing.h"
	.loc	7 71 5 is_stmt 1        # src/inline/testing.h:71:5
.Ltmp92:
	callq	ftime@PLT
	.loc	7 73 31                 # src/inline/testing.h:73:31
	movq	424(%rsp), %rax
	.loc	7 73 38 is_stmt 0       # src/inline/testing.h:73:38
	movzwl	432(%rsp), %esi
.Ltmp93:
	.loc	7 78 15 is_stmt 1 discriminator 1 # src/inline/testing.h:78:15
	subq	%r12, %rax
	imulq	$1000, %rax, %rax       # imm = 0x3E8
	.loc	7 73 36                 # src/inline/testing.h:73:36
.Ltmp94:
	subq	%r14, %rsi
	.loc	7 74 19                 # src/inline/testing.h:74:19
	addq	%rax, %rsi
.Ltmp95:
	#DEBUG_VALUE: print_timer_elapsed:ms <- %RSI
	.loc	7 79 26                 # src/inline/testing.h:79:26
	vcvtsi2sdq	%rsi, %xmm0, %xmm0
	.loc	7 79 29 is_stmt 0       # src/inline/testing.h:79:29
	vmulsd	.LCPI0_30(%rip), %xmm0, %xmm0
	.loc	7 79 37                 # src/inline/testing.h:79:37
	vmovq	%rbp, %xmm1
	vpunpckldq	.LCPI0_31(%rip), %xmm1, %xmm1 # xmm1 = xmm1[0],mem[0],xmm1[1],mem[1]
	vsubpd	.LCPI0_32(%rip), %xmm1, %xmm1
	vhaddpd	%xmm1, %xmm1, %xmm1
	.loc	7 79 35                 # src/inline/testing.h:79:35
	vdivsd	%xmm1, %xmm0, %xmm0
.Ltmp96:
	#DEBUG_VALUE: print_timer_elapsed:ns_per_item <- %XMM0
	movb	$1, %al
	.loc	7 80 5 is_stmt 1        # src/inline/testing.h:80:5
	leaq	.L.str.18(%rip), %rdi
	callq	printf@PLT
.Ltmp97:
	.loc	2 183 5                 # tests/median_test.c:183:5
	leaq	.Lstr(%rip), %rdi
	callq	puts@PLT
	.loc	2 185 9                 # tests/median_test.c:185:9
	cmpl	$0, 240(%rsp)           # 4-byte Folded Reload
.Ltmp98:
	#DEBUG_VALUE: u16_input:result [bit_piece offset=0 size=64] <- undef
	#DEBUG_VALUE: u16_input:result [bit_piece offset=64 size=64] <- undef
	#DEBUG_VALUE: u16_input:result [bit_piece offset=128 size=64] <- %RBX
	jne	.LBB0_91
.Ltmp99:
# BB#25:                                # %.preheader13.i
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: u16_input:result [bit_piece offset=128 size=64] <- %RBX
	#DEBUG_VALUE: print_timer_elapsed:ns_per_item <- %XMM0
	#DEBUG_VALUE: print_timer_elapsed:ms <- %RSI
	#DEBUG_VALUE: ms_elapsed:before [bit_piece offset=0 size=64] <- %R12
	#DEBUG_VALUE: print_timer_elapsed:before [bit_piece offset=0 size=64] <- %R12
	#DEBUG_VALUE: print_timer_elapsed:item_count <- %RBP
	.loc	2 203 32                # tests/median_test.c:203:32
	movq	%r13, %rax
	shrq	%rax
	movq	%rax, 152(%rsp)         # 8-byte Spill
	.loc	2 203 62 is_stmt 0      # tests/median_test.c:203:62
	shrq	160(%rsp)               # 8-byte Folded Spill
	.loc	2 197 32 is_stmt 1      # tests/median_test.c:197:32
.Ltmp100:
	movl	%r13d, %eax
	andl	$1, %eax
	movl	%eax, 148(%rsp)         # 4-byte Spill
.Ltmp101:
	.loc	2 199 9                 # tests/median_test.c:199:9
	leaq	test_median.sorted(%rip), %r12
.Ltmp102:
	movq	184(%rsp), %r14         # 8-byte Reload
.Ltmp103:
	.align	16, 0x90
.LBB0_26:                               #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_31 Depth 3
                                        #       Child Loop BB0_33 Depth 3
                                        #         Child Loop BB0_56 Depth 4
                                        #         Child Loop BB0_44 Depth 4
                                        #         Child Loop BB0_68 Depth 4
	#DEBUG_VALUE: a <- 0
	.loc	2 196 9 discriminator 1 # tests/median_test.c:196:9
	movl	180(%rsp), %eax         # 4-byte Reload
	testb	%al, %al
	jne	.LBB0_32
.Ltmp104:
# BB#27:                                # %.lr.ph22.i.preheader
                                        #   in Loop: Header=BB0_26 Depth=2
	movl	$0, %edx
	cmpl	$0, 148(%rsp)           # 4-byte Folded Reload
	je	.LBB0_29
# BB#28:                                # %.lr.ph22.i.prol
                                        #   in Loop: Header=BB0_26 Depth=2
	.loc	2 197 32                # tests/median_test.c:197:32
.Ltmp105:
	movq	test_median.input_pointers(%rip), %rax
	.loc	2 197 25 is_stmt 0      # tests/median_test.c:197:25
	movzwl	-2(%rax,%r15,2), %eax
	vcvtsi2ssl	%eax, %xmm0, %xmm0
	.loc	2 197 23                # tests/median_test.c:197:23
	vmovss	%xmm0, test_median.sorted(%rip)
.Ltmp106:
	#DEBUG_VALUE: a <- 1
	movl	$1, %edx
.LBB0_29:                               # %.lr.ph22.i.preheader.split
                                        #   in Loop: Header=BB0_26 Depth=2
	cmpl	$1, %r13d
	je	.LBB0_32
# BB#30:                                # %.lr.ph22.i.preheader.split.split
                                        #   in Loop: Header=BB0_26 Depth=2
	.loc	2 197 32                # tests/median_test.c:197:32
	movq	%r13, %rax
	subq	%rdx, %rax
	leaq	4(%r12,%rdx,4), %rcx
	leaq	8(%rbx,%rdx,8), %rdx
	.align	16, 0x90
.LBB0_31:                               # %.lr.ph22.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_26 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movq	-8(%rdx), %rsi
	.loc	2 197 25                # tests/median_test.c:197:25
	movzwl	-2(%rsi,%r15,2), %esi
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ssl	%esi, %xmm0, %xmm0
	.loc	2 197 23                # tests/median_test.c:197:23
	vmovss	%xmm0, -4(%rcx)
	.loc	2 197 32                # tests/median_test.c:197:32
	movq	(%rdx), %rsi
	.loc	2 197 25                # tests/median_test.c:197:25
	movzwl	-2(%rsi,%r15,2), %esi
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ssl	%esi, %xmm0, %xmm0
	.loc	2 197 23                # tests/median_test.c:197:23
	vmovss	%xmm0, (%rcx)
.Ltmp107:
	.loc	2 196 9 is_stmt 1 discriminator 1 # tests/median_test.c:196:9
	addq	$8, %rcx
	addq	$16, %rdx
	addq	$-2, %rax
	jne	.LBB0_31
.Ltmp108:
.LBB0_32:                               # %._crit_edge23.i
                                        #   in Loop: Header=BB0_26 Depth=2
	.loc	2 199 9                 # tests/median_test.c:199:9
	movq	%r12, %rdi
	movq	%r13, %rsi
	vzeroupper
	callq	sort_floats@PLT
	.loc	2 203 13                # tests/median_test.c:203:13
	movq	152(%rsp), %rax         # 8-byte Reload
	vmovss	(%r12,%rax,4), %xmm0    # xmm0 = mem[0],zero,zero,zero
	.loc	2 203 37 is_stmt 0      # tests/median_test.c:203:37
	movq	160(%rsp), %rax         # 8-byte Reload
	vaddss	(%r12,%rax,4), %xmm0, %xmm0
.Ltmp109:
	#DEBUG_VALUE: iter <- 0
	#DEBUG_VALUE: upper_bound <- inf
	#DEBUG_VALUE: lower_bound <- -inf
	vmovss	.LCPI0_33(%rip), %xmm10 # xmm10 = mem[0],zero,zero,zero
	.loc	2 202 29 is_stmt 1      # tests/median_test.c:202:29
	vmulss	%xmm10, %xmm0, %xmm15
.Ltmp110:
	.loc	2 272 9                 # tests/median_test.c:272:9
	movq	%r13, %rbp
	movl	$0, %esi
	vmovss	.LCPI0_35(%rip), %xmm0  # xmm0 = mem[0],zero,zero,zero
	vmovaps	%xmm0, %xmm13
	vmovss	.LCPI0_34(%rip), %xmm0  # xmm0 = mem[0],zero,zero,zero
	vmovaps	%xmm0, %xmm14
	testl	%r14d, %r14d
	vmovdqa	.LCPI0_31(%rip), %xmm8  # xmm8 = [1127219200,1160773632,0,0]
	vmovapd	.LCPI0_32(%rip), %xmm9  # xmm9 = [4.503600e+15,1.934281e+25]
	vmovsd	200(%rsp), %xmm11       # 8-byte Reload
                                        # xmm11 = mem[0],zero
	vmovsd	192(%rsp), %xmm12       # 8-byte Reload
                                        # xmm12 = mem[0],zero
	je	.LBB0_76
	.align	16, 0x90
.LBB0_33:                               # %.preheader.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_26 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_56 Depth 4
                                        #         Child Loop BB0_44 Depth 4
                                        #         Child Loop BB0_68 Depth 4
	vxorps	%xmm0, %xmm0, %xmm0
	.loc	2 209 34 discriminator 1 # tests/median_test.c:209:34
.Ltmp111:
	testq	%rbp, %rbp
	je	.LBB0_58
.Ltmp112:
# BB#34:                                # %.lr.ph26.i.preheader
                                        #   in Loop: Header=BB0_33 Depth=3
	vxorps	%xmm0, %xmm0, %xmm0
	.loc	2 210 27                # tests/median_test.c:210:27
.Ltmp113:
	cmpq	$3, %rbp
	ja	.LBB0_51
# BB#35:                                #   in Loop: Header=BB0_33 Depth=3
	xorl	%ecx, %ecx
	jmp	.LBB0_36
	.align	16, 0x90
.LBB0_51:                               # %min.iters.checked
                                        #   in Loop: Header=BB0_33 Depth=3
	movq	%rbp, %rax
	movl	$0, %ecx
	andq	$-4, %rax
	je	.LBB0_36
# BB#52:                                # %vector.ph
                                        #   in Loop: Header=BB0_33 Depth=3
	vpermilps	$0, %xmm14, %xmm0 # xmm0 = xmm14[0,0,0,0]
	vpermilps	$0, %xmm13, %xmm1 # xmm1 = xmm13[0,0,0,0]
	vpermilps	$0, %xmm15, %xmm2 # xmm2 = xmm15[0,0,0,0]
	leaq	-4(%rbp), %rdx
	movq	%rdx, %rcx
	shrq	$2, %rcx
	vxorpd	%ymm3, %ymm3, %ymm3
	btq	$2, %rdx
	movl	$0, %edx
	jb	.LBB0_54
# BB#53:                                # %vector.body.prol
                                        #   in Loop: Header=BB0_33 Depth=3
	vmovaps	test_median.sorted(%rip), %xmm3
	.loc	2 211 23                # tests/median_test.c:211:23
.Ltmp114:
	vcmpnleps	%xmm3, %xmm0, %xmm4
	.loc	2 211 43 is_stmt 0 discriminator 1 # tests/median_test.c:211:43
.Ltmp115:
	vcmpnleps	%xmm1, %xmm3, %xmm5
.Ltmp116:
	.loc	2 211 38                # tests/median_test.c:211:38
	vorps	%xmm5, %xmm4, %xmm4
	vpmovsxdq	%xmm4, %xmm5
	vpshufd	$78, %xmm4, %xmm4       # xmm4 = xmm4[2,3,0,1]
	vpmovsxdq	%xmm4, %xmm4
	vinsertf128	$1, %xmm4, %ymm5, %ymm4
	.loc	2 212 36 is_stmt 1      # tests/median_test.c:212:36
.Ltmp117:
	vsubps	%xmm2, %xmm3, %xmm3
	.loc	2 212 34 is_stmt 0      # tests/median_test.c:212:34
	vcvtps2pd	%xmm3, %ymm3
	.loc	2 213 31 is_stmt 1      # tests/median_test.c:213:31
	vmulpd	%ymm3, %ymm3, %ymm3
	.loc	2 213 24 is_stmt 0      # tests/median_test.c:213:24
	vxorpd	%ymm5, %ymm5, %ymm5
	vaddpd	%ymm5, %ymm3, %ymm3
.Ltmp118:
	.loc	2 272 9 is_stmt 1       # tests/median_test.c:272:9
	vblendvpd	%ymm4, %ymm5, %ymm3, %ymm3
	movl	$4, %edx
.LBB0_54:                               # %vector.ph.split
                                        #   in Loop: Header=BB0_33 Depth=3
	.loc	2 210 27                # tests/median_test.c:210:27
.Ltmp119:
	testq	%rcx, %rcx
	je	.LBB0_57
# BB#55:                                # %vector.ph.split.split
                                        #   in Loop: Header=BB0_33 Depth=3
	movq	%rbp, %rcx
	andq	$-4, %rcx
	subq	%rdx, %rcx
	leaq	16(%r12,%rdx,4), %rdx
	.align	16, 0x90
.LBB0_56:                               # %vector.body
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_26 Depth=2
                                        #       Parent Loop BB0_33 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovaps	-16(%rdx), %xmm4
	vmovaps	(%rdx), %xmm5
	.loc	2 211 23                # tests/median_test.c:211:23
.Ltmp120:
	vcmpnleps	%xmm4, %xmm0, %xmm6
	.loc	2 211 43 is_stmt 0 discriminator 1 # tests/median_test.c:211:43
.Ltmp121:
	vcmpnleps	%xmm1, %xmm4, %xmm7
.Ltmp122:
	.loc	2 211 38                # tests/median_test.c:211:38
	vorps	%xmm7, %xmm6, %xmm6
	vpmovsxdq	%xmm6, %xmm7
	vpshufd	$78, %xmm6, %xmm6       # xmm6 = xmm6[2,3,0,1]
	vpmovsxdq	%xmm6, %xmm6
	vinsertf128	$1, %xmm6, %ymm7, %ymm6
	.loc	2 212 36 is_stmt 1      # tests/median_test.c:212:36
.Ltmp123:
	vsubps	%xmm2, %xmm4, %xmm4
	.loc	2 212 34 is_stmt 0      # tests/median_test.c:212:34
	vcvtps2pd	%xmm4, %ymm4
	.loc	2 213 31 is_stmt 1      # tests/median_test.c:213:31
	vmulpd	%ymm4, %ymm4, %ymm4
	.loc	2 213 24 is_stmt 0      # tests/median_test.c:213:24
	vaddpd	%ymm4, %ymm3, %ymm4
.Ltmp124:
	.loc	2 272 9 is_stmt 1       # tests/median_test.c:272:9
	vblendvpd	%ymm6, %ymm3, %ymm4, %ymm3
	.loc	2 211 23                # tests/median_test.c:211:23
.Ltmp125:
	vcmpnleps	%xmm5, %xmm0, %xmm4
	.loc	2 211 43 is_stmt 0 discriminator 1 # tests/median_test.c:211:43
.Ltmp126:
	vcmpnleps	%xmm1, %xmm5, %xmm6
.Ltmp127:
	.loc	2 211 38                # tests/median_test.c:211:38
	vorps	%xmm6, %xmm4, %xmm4
	vpmovsxdq	%xmm4, %xmm6
	vpshufd	$78, %xmm4, %xmm4       # xmm4 = xmm4[2,3,0,1]
	vpmovsxdq	%xmm4, %xmm4
	vinsertf128	$1, %xmm4, %ymm6, %ymm4
	.loc	2 212 36 is_stmt 1      # tests/median_test.c:212:36
.Ltmp128:
	vsubps	%xmm2, %xmm5, %xmm5
	.loc	2 212 34 is_stmt 0      # tests/median_test.c:212:34
	vcvtps2pd	%xmm5, %ymm5
	.loc	2 213 31 is_stmt 1      # tests/median_test.c:213:31
	vmulpd	%ymm5, %ymm5, %ymm5
	.loc	2 213 24 is_stmt 0      # tests/median_test.c:213:24
	vaddpd	%ymm5, %ymm3, %ymm5
.Ltmp129:
	.loc	2 272 9 is_stmt 1       # tests/median_test.c:272:9
	vblendvpd	%ymm4, %ymm3, %ymm5, %ymm3
	.loc	2 210 27                # tests/median_test.c:210:27
.Ltmp130:
	addq	$32, %rdx
	addq	$-8, %rcx
	jne	.LBB0_56
.Ltmp131:
.LBB0_57:                               # %middle.block
                                        #   in Loop: Header=BB0_33 Depth=3
	.loc	2 272 9                 # tests/median_test.c:272:9
	vextractf128	$1, %ymm3, %xmm0
	vaddpd	%ymm0, %ymm3, %ymm0
	vhaddpd	%ymm0, %ymm0, %ymm0
	movq	%rax, %rcx
	cmpq	%rax, %rbp
	je	.LBB0_58
	.align	16, 0x90
.LBB0_36:                               # %.lr.ph26.i.preheader103
                                        #   in Loop: Header=BB0_33 Depth=3
	.loc	2 210 27                # tests/median_test.c:210:27
.Ltmp132:
	movl	%ebp, %edx
	subl	%ecx, %edx
	leaq	-1(%rbp), %rax
	testb	$1, %dl
	jne	.LBB0_38
# BB#37:                                #   in Loop: Header=BB0_33 Depth=3
	movq	%rcx, %rdx
	jmp	.LBB0_42
	.align	16, 0x90
.LBB0_38:                               # %.lr.ph26.i.prol
                                        #   in Loop: Header=BB0_33 Depth=3
	vmovss	(%r12,%rcx,4), %xmm1    # xmm1 = mem[0],zero,zero,zero
.Ltmp133:
	#DEBUG_VALUE: n <- %XMM1
	.loc	2 211 23                # tests/median_test.c:211:23
	vucomiss	%xmm14, %xmm1
	jb	.LBB0_41
.Ltmp134:
# BB#39:                                # %.lr.ph26.i.prol
                                        #   in Loop: Header=BB0_33 Depth=3
	#DEBUG_VALUE: n <- %XMM1
	vucomiss	%xmm1, %xmm13
	jb	.LBB0_41
.Ltmp135:
# BB#40:                                #   in Loop: Header=BB0_33 Depth=3
	#DEBUG_VALUE: n <- %XMM1
	.loc	2 212 36                # tests/median_test.c:212:36
	vsubss	%xmm15, %xmm1, %xmm1
.Ltmp136:
	.loc	2 212 34 is_stmt 0      # tests/median_test.c:212:34
	vcvtss2sd	%xmm1, %xmm1, %xmm1
.Ltmp137:
	#DEBUG_VALUE: dev <- %XMM1
	.loc	2 213 31 is_stmt 1      # tests/median_test.c:213:31
	vmulsd	%xmm1, %xmm1, %xmm1
.Ltmp138:
	.loc	2 213 24 is_stmt 0      # tests/median_test.c:213:24
	vaddsd	%xmm1, %xmm0, %xmm0
.Ltmp139:
	#DEBUG_VALUE: ss <- %XMM0
.LBB0_41:                               #   in Loop: Header=BB0_33 Depth=3
	.loc	2 209 51 is_stmt 1 discriminator 3 # tests/median_test.c:209:51
	movq	%rcx, %rdx
	orq	$1, %rdx
.Ltmp140:
	#DEBUG_VALUE: c <- %RDX
.LBB0_42:                               # %.lr.ph26.i.preheader103.split
                                        #   in Loop: Header=BB0_33 Depth=3
	.loc	2 210 27                # tests/median_test.c:210:27
	cmpq	%rcx, %rax
	je	.LBB0_58
# BB#43:                                # %.lr.ph26.i.preheader103.split.split
                                        #   in Loop: Header=BB0_33 Depth=3
	movq	%rbp, %rax
	subq	%rdx, %rax
	leaq	4(%r12,%rdx,4), %rcx
	.align	16, 0x90
.LBB0_44:                               # %.lr.ph26.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_26 Depth=2
                                        #       Parent Loop BB0_33 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovss	-4(%rcx), %xmm1         # xmm1 = mem[0],zero,zero,zero
.Ltmp141:
	#DEBUG_VALUE: n <- %XMM1
	.loc	2 211 23                # tests/median_test.c:211:23
	vucomiss	%xmm14, %xmm1
	jb	.LBB0_47
.Ltmp142:
# BB#45:                                # %.lr.ph26.i
                                        #   in Loop: Header=BB0_44 Depth=4
	#DEBUG_VALUE: n <- %XMM1
	vucomiss	%xmm1, %xmm13
	jb	.LBB0_47
.Ltmp143:
# BB#46:                                #   in Loop: Header=BB0_44 Depth=4
	#DEBUG_VALUE: n <- %XMM1
	.loc	2 212 36                # tests/median_test.c:212:36
	vsubss	%xmm15, %xmm1, %xmm1
.Ltmp144:
	.loc	2 212 34 is_stmt 0      # tests/median_test.c:212:34
	vcvtss2sd	%xmm1, %xmm1, %xmm1
.Ltmp145:
	#DEBUG_VALUE: dev <- %XMM1
	.loc	2 213 31 is_stmt 1      # tests/median_test.c:213:31
	vmulsd	%xmm1, %xmm1, %xmm1
.Ltmp146:
	.loc	2 213 24 is_stmt 0      # tests/median_test.c:213:24
	vaddsd	%xmm1, %xmm0, %xmm0
.Ltmp147:
	#DEBUG_VALUE: ss <- %XMM0
.LBB0_47:                               # %.lr.ph26.i.1128
                                        #   in Loop: Header=BB0_44 Depth=4
	.loc	2 210 27 is_stmt 1      # tests/median_test.c:210:27
	vmovss	(%rcx), %xmm1           # xmm1 = mem[0],zero,zero,zero
	.loc	2 211 23                # tests/median_test.c:211:23
.Ltmp148:
	vucomiss	%xmm14, %xmm1
	jb	.LBB0_50
# BB#48:                                # %.lr.ph26.i.1128
                                        #   in Loop: Header=BB0_44 Depth=4
	vucomiss	%xmm1, %xmm13
	jb	.LBB0_50
# BB#49:                                #   in Loop: Header=BB0_44 Depth=4
	.loc	2 212 36                # tests/median_test.c:212:36
.Ltmp149:
	vsubss	%xmm15, %xmm1, %xmm1
	.loc	2 212 34 is_stmt 0      # tests/median_test.c:212:34
	vcvtss2sd	%xmm1, %xmm1, %xmm1
	.loc	2 213 31 is_stmt 1      # tests/median_test.c:213:31
	vmulsd	%xmm1, %xmm1, %xmm1
	.loc	2 213 24 is_stmt 0      # tests/median_test.c:213:24
	vaddsd	%xmm1, %xmm0, %xmm0
.Ltmp150:
.LBB0_50:                               #   in Loop: Header=BB0_44 Depth=4
	.loc	2 209 13 is_stmt 1 discriminator 1 # tests/median_test.c:209:13
	addq	$8, %rcx
	addq	$-2, %rax
	jne	.LBB0_44
.Ltmp151:
.LBB0_58:                               # %._crit_edge27.i
                                        #   in Loop: Header=BB0_33 Depth=3
	.loc	2 216 35                # tests/median_test.c:216:35
	vmovq	%rbp, %xmm1
	vpunpckldq	%xmm8, %xmm1, %xmm1 # xmm1 = xmm1[0],xmm8[0],xmm1[1],xmm8[1]
	vsubpd	%xmm9, %xmm1, %xmm1
	vhaddpd	%xmm1, %xmm1, %xmm1
	.loc	2 216 33 is_stmt 0      # tests/median_test.c:216:33
	vdivsd	%xmm1, %xmm0, %xmm1
	.loc	2 216 25 discriminator 1 # tests/median_test.c:216:25
.Ltmp152:
	vxorps	%xmm0, %xmm0, %xmm0
	vsqrtsd	%xmm1, %xmm0, %xmm0
.Ltmp153:
	.loc	2 216 20                # tests/median_test.c:216:20
	vucomisd	%xmm0, %xmm0
	jnp	.LBB0_60
# BB#59:                                # %call.sqrt
                                        #   in Loop: Header=BB0_33 Depth=3
	vmovapd	%xmm1, %xmm0
	movq	%rsi, %r14
	vmovaps	%xmm13, 240(%rsp)       # 16-byte Spill
	vmovaps	%xmm14, 224(%rsp)       # 16-byte Spill
	vmovaps	%xmm15, 208(%rsp)       # 16-byte Spill
	vzeroupper
	callq	sqrt@PLT
	vmovaps	208(%rsp), %xmm15       # 16-byte Reload
	vmovaps	224(%rsp), %xmm14       # 16-byte Reload
	vmovaps	240(%rsp), %xmm13       # 16-byte Reload
	movq	%r14, %rsi
	vmovsd	192(%rsp), %xmm12       # 8-byte Reload
                                        # xmm12 = mem[0],zero
	vmovsd	200(%rsp), %xmm11       # 8-byte Reload
                                        # xmm11 = mem[0],zero
	movq	184(%rsp), %r14         # 8-byte Reload
	vmovss	.LCPI0_33(%rip), %xmm10 # xmm10 = mem[0],zero,zero,zero
	vmovapd	.LCPI0_32(%rip), %xmm9  # xmm9 = [4.503600e+15,1.934281e+25]
	vmovdqa	.LCPI0_31(%rip), %xmm8  # xmm8 = [1127219200,1160773632,0,0]
.LBB0_60:                               # %._crit_edge27.i.split
                                        #   in Loop: Header=BB0_33 Depth=3
.Ltmp154:
	#DEBUG_VALUE: sd <- %XMM0
	.loc	2 217 36 is_stmt 1      # tests/median_test.c:217:36
	vcvtss2sd	%xmm15, %xmm15, %xmm1
	.loc	2 217 56 is_stmt 0      # tests/median_test.c:217:56
	vmulsd	%xmm0, %xmm11, %xmm2
	.loc	2 217 43                # tests/median_test.c:217:43
	vsubsd	%xmm2, %xmm1, %xmm2
	.loc	2 217 28                # tests/median_test.c:217:28
	vcvtsd2ss	%xmm2, %xmm2, %xmm2
.Ltmp155:
	#DEBUG_VALUE: new_lb <- %XMM2
	.loc	2 218 56 is_stmt 1      # tests/median_test.c:218:56
	vmulsd	%xmm0, %xmm12, %xmm0
.Ltmp156:
	.loc	2 218 43 is_stmt 0      # tests/median_test.c:218:43
	vaddsd	%xmm0, %xmm1, %xmm0
	.loc	2 218 28                # tests/median_test.c:218:28
	vcvtsd2ss	%xmm0, %xmm0, %xmm0
.Ltmp157:
	#DEBUG_VALUE: new_ub <- %XMM0
	.loc	2 220 27 is_stmt 1      # tests/median_test.c:220:27
	vmaxss	%xmm2, %xmm14, %xmm14
.Ltmp158:
	#DEBUG_VALUE: lower_bound <- %XMM14
	.loc	2 221 27                # tests/median_test.c:221:27
	vminss	%xmm0, %xmm13, %xmm13
.Ltmp159:
	#DEBUG_VALUE: c <- 0
	#DEBUG_VALUE: new_count <- 0
	#DEBUG_VALUE: upper_bound <- %XMM13
	movl	$0, %eax
	testq	%rbp, %rbp
	je	.LBB0_75
.Ltmp160:
# BB#61:                                # %.lr.ph31.i.preheader
                                        #   in Loop: Header=BB0_33 Depth=3
	#DEBUG_VALUE: upper_bound <- %XMM13
	#DEBUG_VALUE: lower_bound <- %XMM14
	#DEBUG_VALUE: new_ub <- %XMM0
	#DEBUG_VALUE: new_lb <- %XMM2
                                        # implicit-def: %RAX
	movl	$0, %ecx
	movl	$0, %edx
	.loc	2 225 27                # tests/median_test.c:225:27
.Ltmp161:
	testb	$1, %bpl
	je	.LBB0_66
.Ltmp162:
# BB#62:                                # %.lr.ph31.i.prol
                                        #   in Loop: Header=BB0_33 Depth=3
	#DEBUG_VALUE: new_lb <- %XMM2
	#DEBUG_VALUE: new_ub <- %XMM0
	#DEBUG_VALUE: lower_bound <- %XMM14
	#DEBUG_VALUE: upper_bound <- %XMM13
	vmovss	test_median.sorted(%rip), %xmm0 # xmm0 = mem[0],zero,zero,zero
.Ltmp163:
	#DEBUG_VALUE: n <- %XMM0
	.loc	2 226 23                # tests/median_test.c:226:23
	vucomiss	%xmm14, %xmm0
	jb	.LBB0_63
.Ltmp164:
# BB#64:                                # %.lr.ph31.i.prol
                                        #   in Loop: Header=BB0_33 Depth=3
	#DEBUG_VALUE: upper_bound <- %XMM13
	#DEBUG_VALUE: lower_bound <- %XMM14
	#DEBUG_VALUE: new_lb <- %XMM2
	#DEBUG_VALUE: n <- %XMM0
	vucomiss	%xmm0, %xmm13
	movl	$0, %eax
	movl	$1, %ecx
	movl	$0, %edx
	jb	.LBB0_66
.Ltmp165:
# BB#65:                                #   in Loop: Header=BB0_33 Depth=3
	#DEBUG_VALUE: n <- %XMM0
	#DEBUG_VALUE: new_lb <- %XMM2
	#DEBUG_VALUE: lower_bound <- %XMM14
	#DEBUG_VALUE: upper_bound <- %XMM13
	#DEBUG_VALUE: new_count <- 1
	.loc	2 227 41                # tests/median_test.c:227:41
	vmovss	%xmm0, test_median.sorted(%rip)
	movl	$1, %eax
	movl	$1, %ecx
	movl	$1, %edx
	jmp	.LBB0_66
.Ltmp166:
.LBB0_63:                               #   in Loop: Header=BB0_33 Depth=3
	#DEBUG_VALUE: upper_bound <- %XMM13
	#DEBUG_VALUE: lower_bound <- %XMM14
	#DEBUG_VALUE: new_lb <- %XMM2
	#DEBUG_VALUE: n <- %XMM0
	xorl	%eax, %eax
	movl	$1, %ecx
	xorl	%edx, %edx
.Ltmp167:
	.align	16, 0x90
.LBB0_66:                               # %.lr.ph31.i.preheader.split
                                        #   in Loop: Header=BB0_33 Depth=3
	#DEBUG_VALUE: new_lb <- %XMM2
	#DEBUG_VALUE: lower_bound <- %XMM14
	#DEBUG_VALUE: upper_bound <- %XMM13
	.loc	2 225 27                # tests/median_test.c:225:27
	cmpq	$1, %rbp
	je	.LBB0_75
.Ltmp168:
# BB#67:                                # %.lr.ph31.i.preheader.split.split
                                        #   in Loop: Header=BB0_33 Depth=3
	#DEBUG_VALUE: upper_bound <- %XMM13
	#DEBUG_VALUE: lower_bound <- %XMM14
	#DEBUG_VALUE: new_lb <- %XMM2
	subq	%rcx, %rbp
	leaq	4(%r12,%rcx,4), %rcx
.Ltmp169:
	.loc	2 272 9                 # tests/median_test.c:272:9
	movq	%rdx, %rax
.Ltmp170:
	.align	16, 0x90
.LBB0_68:                               # %.lr.ph31.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_26 Depth=2
                                        #       Parent Loop BB0_33 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	.loc	2 225 27                # tests/median_test.c:225:27
	vmovss	-4(%rcx), %xmm0         # xmm0 = mem[0],zero,zero,zero
.Ltmp171:
	#DEBUG_VALUE: n <- %XMM0
	.loc	2 226 23                # tests/median_test.c:226:23
	vucomiss	%xmm14, %xmm0
	jb	.LBB0_71
.Ltmp172:
# BB#69:                                # %.lr.ph31.i
                                        #   in Loop: Header=BB0_68 Depth=4
	#DEBUG_VALUE: n <- %XMM0
	vucomiss	%xmm0, %xmm13
	jb	.LBB0_71
.Ltmp173:
# BB#70:                                #   in Loop: Header=BB0_68 Depth=4
	#DEBUG_VALUE: n <- %XMM0
	#DEBUG_VALUE: new_count <- %RAX
	.loc	2 227 41                # tests/median_test.c:227:41
	vmovss	%xmm0, (%r12,%rax,4)
	.loc	2 227 37 is_stmt 0      # tests/median_test.c:227:37
	incq	%rax
.Ltmp174:
.LBB0_71:                               # %.lr.ph31.i.1131
                                        #   in Loop: Header=BB0_68 Depth=4
	#DEBUG_VALUE: n <- %XMM0
	.loc	2 225 27 is_stmt 1      # tests/median_test.c:225:27
	vmovss	(%rcx), %xmm0           # xmm0 = mem[0],zero,zero,zero
.Ltmp175:
	.loc	2 226 23                # tests/median_test.c:226:23
	vucomiss	%xmm14, %xmm0
	jb	.LBB0_74
# BB#72:                                # %.lr.ph31.i.1131
                                        #   in Loop: Header=BB0_68 Depth=4
	vucomiss	%xmm0, %xmm13
	jb	.LBB0_74
# BB#73:                                #   in Loop: Header=BB0_68 Depth=4
.Ltmp176:
	#DEBUG_VALUE: current_count <- %RAX
	.loc	2 227 41                # tests/median_test.c:227:41
	vmovss	%xmm0, (%r12,%rax,4)
	.loc	2 227 37 is_stmt 0      # tests/median_test.c:227:37
	incq	%rax
.Ltmp177:
.LBB0_74:                               #   in Loop: Header=BB0_68 Depth=4
	.loc	2 224 13 is_stmt 1 discriminator 1 # tests/median_test.c:224:13
	addq	$8, %rcx
	addq	$-2, %rbp
	jne	.LBB0_68
.Ltmp178:
.LBB0_75:                               # %._crit_edge32.i
                                        #   in Loop: Header=BB0_33 Depth=3
	.loc	2 233 66                # tests/median_test.c:233:66
	leaq	(%rax,%rax), %rcx
	.loc	2 233 38 is_stmt 0      # tests/median_test.c:233:38
	andq	$-4, %rcx
	.loc	2 233 17                # tests/median_test.c:233:17
	vmovss	(%rcx,%r12), %xmm0      # xmm0 = mem[0],zero,zero,zero
	.loc	2 233 45                # tests/median_test.c:233:45
	leaq	-2(%rax,%rax), %rcx
	.loc	2 233 70                # tests/median_test.c:233:70
	andq	$-4, %rcx
	.loc	2 233 43                # tests/median_test.c:233:43
	vaddss	(%rcx,%r12), %xmm0, %xmm0
.Ltmp179:
	.loc	2 207 49 is_stmt 1 discriminator 3 # tests/median_test.c:207:49
	incq	%rsi
.Ltmp180:
	#DEBUG_VALUE: iter <- %RSI
	.loc	2 202 29                # tests/median_test.c:202:29
	vmulss	%xmm10, %xmm0, %xmm15
.Ltmp181:
	.loc	2 272 9                 # tests/median_test.c:272:9
	movq	%rax, %rbp
	.loc	2 207 36 discriminator 1 # tests/median_test.c:207:36
.Ltmp182:
	cmpq	%r14, %rsi
	jne	.LBB0_33
.Ltmp183:
.LBB0_76:                               # %._crit_edge42.i
                                        #   in Loop: Header=BB0_26 Depth=2
	.loc	2 194 9                 # tests/median_test.c:194:9
	leaq	-1(%r15), %rsi
.Ltmp184:
	#DEBUG_VALUE: test_median:b <- %RSI
	.loc	2 236 23                # tests/median_test.c:236:23
	movq	168(%rsp), %rax         # 8-byte Reload
	vmovss	-4(%rax,%r15,4), %xmm1  # xmm1 = mem[0],zero,zero,zero
.Ltmp185:
	.loc	2 236 13 is_stmt 0      # tests/median_test.c:236:13
	vucomiss	%xmm1, %xmm15
	jne	.LBB0_77
	jnp	.LBB0_82
.Ltmp186:
.LBB0_77:
	#DEBUG_VALUE: test_median:b <- %RSI
	.loc	2 237 44 is_stmt 1      # tests/median_test.c:237:44
	vcvtss2sd	%xmm15, %xmm15, %xmm0
	.loc	2 237 52 is_stmt 0      # tests/median_test.c:237:52
	vcvtss2sd	%xmm1, %xmm1, %xmm1
	.loc	2 237 13                # tests/median_test.c:237:13
	leaq	.L.str.14(%rip), %rdi
	movb	$2, %al
	vzeroupper
	callq	printf@PLT
.Ltmp187:
	#DEBUG_VALUE: a <- 0
	.loc	2 238 13 is_stmt 1 discriminator 1 # tests/median_test.c:238:13
	movl	180(%rsp), %eax         # 4-byte Reload
	testb	%al, %al
	je	.LBB0_78
	jmp	.LBB0_80
.Ltmp188:
	.align	16, 0x90
.LBB0_82:                               #   in Loop: Header=BB0_26 Depth=2
	#DEBUG_VALUE: test_median:b <- %RSI
	.loc	2 272 9                 # tests/median_test.c:272:9
	movq	%rsi, %r15
	.loc	2 244 5 discriminator 1 # tests/median_test.c:244:5
.Ltmp189:
	testq	%rsi, %rsi
	jne	.LBB0_26
.Ltmp190:
# BB#83:                                #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test_median:b <- %RSI
	.loc	2 246 9                 # tests/median_test.c:246:9
	movq	376(%rsp), %rax
	movq	%rax, 32(%rsp)
	vmovups	344(%rsp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	check_canary_page@PLT
	.loc	2 246 40 is_stmt 0      # tests/median_test.c:246:40
	testl	%eax, %eax
	jne	.LBB0_84
.Ltmp191:
# BB#85:                                # %test_median.exit
                                        #   in Loop: Header=BB0_1 Depth=1
	#DEBUG_VALUE: test_median:b <- %RSI
	.loc	2 251 5 is_stmt 1       # tests/median_test.c:251:5
	movq	416(%rsp), %rax
	movq	%rax, 32(%rsp)
	vmovups	384(%rsp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	free_canary_page@PLT
	.loc	2 252 5                 # tests/median_test.c:252:5
	movq	376(%rsp), %rax
	movq	%rax, 32(%rsp)
	vmovups	344(%rsp), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	free_canary_page@PLT
	movq	136(%rsp), %r14         # 8-byte Reload
.Ltmp192:
	.loc	2 258 40 discriminator 3 # tests/median_test.c:258:40
	incq	%r14
.Ltmp193:
	#DEBUG_VALUE: i <- %R14
	.loc	2 258 5 is_stmt 0 discriminator 1 # tests/median_test.c:258:5
	cmpq	$7, %r14
	jbe	.LBB0_86
.Ltmp194:
# BB#87:
	#DEBUG_VALUE: test_median:b <- %RSI
	#DEBUG_VALUE: i <- %R14
	.loc	2 277 1 is_stmt 1       # tests/median_test.c:277:1
	xorl	%eax, %eax
	addq	$440, %rsp              # imm = 0x1B8
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
.Ltmp195:
	popq	%r15
	popq	%rbp
	retq
.Ltmp196:
.LBB0_78:
	#DEBUG_VALUE: test_median:b <- %RSI
	.loc	2 239 17                # tests/median_test.c:239:17
	leaq	.L.str.15(%rip), %rbp
.Ltmp197:
	.align	16, 0x90
.LBB0_79:                               # %.lr.ph.i
                                        # =>This Inner Loop Header: Depth=1
	.loc	2 239 31 is_stmt 0      # tests/median_test.c:239:31
	movq	(%rbx), %rax
	movzwl	-2(%rax,%r15,2), %esi
	.loc	2 239 17                # tests/median_test.c:239:17
	xorl	%eax, %eax
	movq	%rbp, %rdi
	callq	printf@PLT
.Ltmp198:
	.loc	2 238 13 is_stmt 1 discriminator 1 # tests/median_test.c:238:13
	addq	$8, %rbx
	decq	%r13
	jne	.LBB0_79
.Ltmp199:
.LBB0_80:                               # %._crit_edge.i
	.loc	2 241 13                # tests/median_test.c:241:13
	leaq	.Lstr.20(%rip), %rdi
.LBB0_81:                               # %._crit_edge.i
	callq	puts@PLT
	.loc	2 242 13                # tests/median_test.c:242:13
	movl	$1, %edi
	callq	exit@PLT
.Ltmp200:
.LBB0_88:
	#DEBUG_VALUE: test_median:max_iter <- [%RSP+184]
	#DEBUG_VALUE: max_iter <- [%RSP+184]
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: array_count <- %R13
	.loc	2 122 5 discriminator 3 # tests/median_test.c:122:5
	leaq	.L.str(%rip), %rdi
	leaq	.L.str.1(%rip), %rsi
	leaq	.L__PRETTY_FUNCTION__.test_median(%rip), %rcx
	movl	$122, %edx
	callq	__assert_fail@PLT
.Ltmp201:
.LBB0_89:
	#DEBUG_VALUE: array_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	#DEBUG_VALUE: max_iter <- [%RSP+184]
	#DEBUG_VALUE: test_median:max_iter <- [%RSP+184]
	.loc	2 123 5 discriminator 3 # tests/median_test.c:123:5
	leaq	.L.str.2(%rip), %rdi
	leaq	.L.str.1(%rip), %rsi
	leaq	.L__PRETTY_FUNCTION__.test_median(%rip), %rcx
	movl	$123, %edx
	callq	__assert_fail@PLT
.Ltmp202:
.LBB0_90:
	#DEBUG_VALUE: test_median:max_iter <- [%RSP+184]
	#DEBUG_VALUE: max_iter <- [%RSP+184]
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: array_count <- %R13
	.loc	2 124 5 discriminator 2 # tests/median_test.c:124:5
	leaq	.L.str.3(%rip), %rdi
	leaq	.L.str.1(%rip), %rsi
	leaq	.L__PRETTY_FUNCTION__.test_median(%rip), %rcx
	movl	$124, %edx
	callq	__assert_fail@PLT
.Ltmp203:
.LBB0_7:
	#DEBUG_VALUE: array_count <- %R13
	#DEBUG_VALUE: test_median:array_count <- %R13
	#DEBUG_VALUE: current_count <- %R13
	#DEBUG_VALUE: bin_count <- %R15
	#DEBUG_VALUE: test_median:bin_count <- %R15
	#DEBUG_VALUE: random_fill:bin_count <- %R15
	#DEBUG_VALUE: offset0 <- %RBP
	#DEBUG_VALUE: test_median:offset0 <- %RBP
	#DEBUG_VALUE: max_iter <- [%RSP+184]
	#DEBUG_VALUE: test_median:max_iter <- [%RSP+184]
	.loc	2 125 5 discriminator 2 # tests/median_test.c:125:5
	leaq	.L.str.4(%rip), %rdi
	leaq	.L.str.1(%rip), %rsi
	leaq	.L__PRETTY_FUNCTION__.test_median(%rip), %rcx
	movl	$125, %edx
	callq	__assert_fail@PLT
.Ltmp204:
.LBB0_14:
	.loc	2 143 9                 # tests/median_test.c:143:9
	leaq	.L.str.5(%rip), %rdi
	jmp	.LBB0_15
.Ltmp205:
.LBB0_91:
	#DEBUG_VALUE: u16_input:result [bit_piece offset=128 size=64] <- %RBX
	#DEBUG_VALUE: print_timer_elapsed:ns_per_item <- %XMM0
	#DEBUG_VALUE: print_timer_elapsed:ms <- %RSI
	#DEBUG_VALUE: ms_elapsed:before [bit_piece offset=0 size=64] <- %R12
	#DEBUG_VALUE: print_timer_elapsed:before [bit_piece offset=0 size=64] <- %R12
	#DEBUG_VALUE: print_timer_elapsed:item_count <- %RBP
	.loc	2 186 9                 # tests/median_test.c:186:9
	leaq	.L.str.13(%rip), %rdi
.Ltmp206:
.LBB0_15:
	.loc	2 143 9                 # tests/median_test.c:143:9
	callq	perror@PLT
	.loc	2 144 9                 # tests/median_test.c:144:9
	movl	$1, %edi
	callq	exit@PLT
.Ltmp207:
.LBB0_84:
	#DEBUG_VALUE: test_median:b <- %RSI
	.loc	2 247 9                 # tests/median_test.c:247:9
	leaq	.Lstr.19(%rip), %rdi
	jmp	.LBB0_81
.Ltmp208:
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
	.file	8 "include" "mediocre.h"

	.align	16, 0x90
	.type	u16_input_loop,@function
u16_input_loop:                         # @u16_input_loop
.Lfunc_begin1:
	.loc	2 16 0                  # tests/median_test.c:16:0
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp209:
	.cfi_def_cfa_offset 16
	pushq	%r15
.Ltmp210:
	.cfi_def_cfa_offset 24
	pushq	%r14
.Ltmp211:
	.cfi_def_cfa_offset 32
	pushq	%r13
.Ltmp212:
	.cfi_def_cfa_offset 40
	pushq	%r12
.Ltmp213:
	.cfi_def_cfa_offset 48
	pushq	%rbx
.Ltmp214:
	.cfi_def_cfa_offset 56
	subq	$88, %rsp
.Ltmp215:
	.cfi_def_cfa_offset 144
.Ltmp216:
	.cfi_offset %rbx, -56
.Ltmp217:
	.cfi_offset %r12, -48
.Ltmp218:
	.cfi_offset %r13, -40
.Ltmp219:
	.cfi_offset %r14, -32
.Ltmp220:
	.cfi_offset %r15, -24
.Ltmp221:
	.cfi_offset %rbp, -16
	#DEBUG_VALUE: u16_input_loop:dimension [bit_piece offset=0 size=64] <- %RDX
	#DEBUG_VALUE: u16_input_loop:dimension [bit_piece offset=64 size=64] <- %RCX
	#DEBUG_VALUE: u16_input_loop:control <- %RDI
	#DEBUG_VALUE: u16_input_loop:user_data <- %RSI
	movq	%rsi, %r12
.Ltmp222:
	#DEBUG_VALUE: u16_input_loop:user_data <- %R12
	movq	%rdi, %r14
.Ltmp223:
	#DEBUG_VALUE: u16_input_loop:control <- %R14
	leaq	48(%rsp), %rdi
	.loc	2 22 5 prologue_end     # tests/median_test.c:22:5
.Ltmp224:
	movq	%r14, %rsi
	callq	mediocre_input_control_get@PLT
	.loc	2 22 5 is_stmt 0 discriminator 1 # tests/median_test.c:22:5
.Ltmp225:
	cmpq	$0, 48(%rsp)
	jne	.LBB1_12
.Ltmp226:
# BB#1:                                 # %.preheader.lr.ph
	#DEBUG_VALUE: u16_input_loop:control <- %R14
	#DEBUG_VALUE: u16_input_loop:user_data <- %R12
	#DEBUG_VALUE: u16_input_loop:dimension [bit_piece offset=64 size=64] <- %RCX
	.loc	2 22 5 discriminator 3  # tests/median_test.c:22:5
	movq	80(%rsp), %r13
.Ltmp227:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=256 size=64] <- %R13
	movq	72(%rsp), %r11
.Ltmp228:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=192 size=64] <- %R11
	movq	56(%rsp), %r8
.Ltmp229:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=64 size=64] <- %R8
	movq	64(%rsp), %r15
.Ltmp230:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=128 size=64] <- %R15
	.align	16, 0x90
.LBB1_2:                                # %.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_4 Depth 2
                                        #       Child Loop BB1_9 Depth 3
	.loc	2 28 42 is_stmt 1 discriminator 1 # tests/median_test.c:28:42
	testq	%r15, %r15
	je	.LBB1_11
# BB#3:                                 # %.lr.ph4
                                        #   in Loop: Header=BB1_2 Depth=1
	.loc	8 265 13                # include/mediocre.h:265:13
.Ltmp231:
	movl	%r11d, %r9d
	andl	$1, %r9d
	xorl	%ecx, %ecx
.Ltmp232:
	.align	16, 0x90
.LBB1_4:                                #   Parent Loop BB1_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_9 Depth 3
	testq	%r11, %r11
.Ltmp233:
	#DEBUG_VALUE: n <- 0
	je	.LBB1_10
# BB#5:                                 # %.lr.ph.preheader
                                        #   in Loop: Header=BB1_4 Depth=2
	.loc	2 29 44                 # tests/median_test.c:29:44
	movq	(%r12,%rcx,8), %r10
	movl	$0, %edx
	testq	%r9, %r9
	je	.LBB1_7
# BB#6:                                 # %.lr.ph.prol
                                        #   in Loop: Header=BB1_4 Depth=2
	.loc	8 277 13                # include/mediocre.h:277:13
.Ltmp234:
	movq	%rcx, %rax
	shlq	$5, %rax
.Ltmp235:
	#DEBUG_VALUE: mediocre_chunk_ptr:chunk_ptr <- %R13
	#DEBUG_VALUE: mediocre_chunk_ptr:width_axis <- 1
	.loc	2 34 22                 # tests/median_test.c:34:22
	movzwl	(%r10,%r8,2), %edi
	vcvtsi2ssl	%edi, %xmm0, %xmm0
	.loc	2 34 20 is_stmt 0       # tests/median_test.c:34:20
	vmovss	%xmm0, (%r13,%rax)
.Ltmp236:
	#DEBUG_VALUE: n <- 1
	movl	$1, %edx
.Ltmp237:
.LBB1_7:                                # %.lr.ph.preheader.split
                                        #   in Loop: Header=BB1_4 Depth=2
	cmpq	$1, %r11
	je	.LBB1_10
# BB#8:                                 # %.lr.ph.preheader.split.split
                                        #   in Loop: Header=BB1_4 Depth=2
	.loc	8 265 13 is_stmt 1      # include/mediocre.h:265:13
.Ltmp238:
	leaq	2(%r10,%r8,2), %rdi
	.align	16, 0x90
.LBB1_9:                                # %.lr.ph
                                        #   Parent Loop BB1_2 Depth=1
                                        #     Parent Loop BB1_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	.loc	8 271 47                # include/mediocre.h:271:47
	movq	%rdx, %rax
	shrq	$3, %rax
	.loc	8 271 52 is_stmt 0      # include/mediocre.h:271:52
	imulq	%r15, %rax
	.loc	8 271 32                # include/mediocre.h:271:32
	shlq	$5, %rax
	addq	%r13, %rax
.Ltmp239:
	#DEBUG_VALUE: mediocre_chunk_ptr:chunk_ptr <- %RAX
	.loc	8 275 36 is_stmt 1      # include/mediocre.h:275:36
	movq	%rcx, %rbx
	shlq	$5, %rbx
	addq	%rbx, %rax
.Ltmp240:
	#DEBUG_VALUE: mediocre_chunk_ptr:vector_ptr <- %RAX
	.loc	8 277 47                # include/mediocre.h:277:47
	movl	%edx, %esi
	andl	$7, %esi
.Ltmp241:
	.loc	2 34 22                 # tests/median_test.c:34:22
	movzwl	-2(%rdi,%rdx,2), %ebp
	vcvtsi2ssl	%ebp, %xmm0, %xmm0
	.loc	2 34 20 is_stmt 0       # tests/median_test.c:34:20
	vmovss	%xmm0, (%rax,%rsi,4)
.Ltmp242:
	.loc	2 31 44 is_stmt 1 discriminator 3 # tests/median_test.c:31:44
	leaq	1(%rdx), %rax
.Ltmp243:
	#DEBUG_VALUE: mediocre_chunk_ptr:width_axis <- %RAX
	#DEBUG_VALUE: n <- %RAX
	.loc	8 271 47                # include/mediocre.h:271:47
	movq	%rax, %rsi
	shrq	$3, %rsi
	.loc	8 271 52 is_stmt 0      # include/mediocre.h:271:52
	imulq	%r15, %rsi
	.loc	8 271 32                # include/mediocre.h:271:32
	shlq	$5, %rsi
	addq	%r13, %rsi
	.loc	8 275 36 is_stmt 1      # include/mediocre.h:275:36
	addq	%rbx, %rsi
	.loc	8 277 47                # include/mediocre.h:277:47
	andl	$7, %eax
.Ltmp244:
	.loc	2 34 22                 # tests/median_test.c:34:22
	movzwl	(%rdi,%rdx,2), %ebp
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ssl	%ebp, %xmm0, %xmm0
	.loc	2 34 20 is_stmt 0       # tests/median_test.c:34:20
	vmovss	%xmm0, (%rsi,%rax,4)
.Ltmp245:
	.loc	2 31 44 is_stmt 1 discriminator 3 # tests/median_test.c:31:44
	addq	$2, %rdx
	.loc	2 31 34 is_stmt 0 discriminator 1 # tests/median_test.c:31:34
	cmpq	%rdx, %r11
	jne	.LBB1_9
.Ltmp246:
.LBB1_10:                               # %._crit_edge
                                        #   in Loop: Header=BB1_4 Depth=2
	.loc	2 28 58 is_stmt 1 discriminator 3 # tests/median_test.c:28:58
	incq	%rcx
.Ltmp247:
	#DEBUG_VALUE: array_i <- %RCX
	#DEBUG_VALUE: mediocre_chunk_ptr:combine_axis <- %RCX
	.loc	2 28 42 is_stmt 0 discriminator 1 # tests/median_test.c:28:42
	cmpq	%r15, %rcx
	jne	.LBB1_4
.Ltmp248:
.LBB1_11:                               # %._crit_edge5
                                        #   in Loop: Header=BB1_2 Depth=1
	leaq	8(%rsp), %rdi
	.loc	2 22 5 is_stmt 1 discriminator 2 # tests/median_test.c:22:5
	movq	%r14, %rsi
	callq	mediocre_input_control_get@PLT
	.loc	2 22 5 is_stmt 0 discriminator 4 # tests/median_test.c:22:5
.Ltmp249:
	movq	16(%rsp), %r8
.Ltmp250:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=64 size=64] <- %R8
	movq	24(%rsp), %r15
.Ltmp251:
	#DEBUG_VALUE: mediocre_chunk_ptr:combine_count <- %R15
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=128 size=64] <- %R15
	movq	32(%rsp), %r11
.Ltmp252:
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=192 size=64] <- %R11
	movq	40(%rsp), %r13
.Ltmp253:
	#DEBUG_VALUE: mediocre_chunk_ptr:chunks <- %R13
	#DEBUG_VALUE: u16_input_loop:command [bit_piece offset=256 size=64] <- %R13
	.loc	2 22 5 discriminator 1  # tests/median_test.c:22:5
	cmpq	$0, 8(%rsp)
	je	.LBB1_2
.Ltmp254:
.LBB1_12:                               # %._crit_edge10
	.loc	2 38 1 is_stmt 1        # tests/median_test.c:38:1
	addq	$88, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Ltmp255:
.Lfunc_end1:
	.size	u16_input_loop, .Lfunc_end1-u16_input_loop
	.cfi_endproc
	.file	9 "/usr/lib/llvm-3.8/bin/../lib/clang/3.8.0/include" "avxintrin.h"

	.align	16, 0x90
	.type	no_op,@function
no_op:                                  # @no_op
.Lfunc_begin2:
	.loc	2 40 0                  # tests/median_test.c:40:0
	.cfi_startproc
# BB#0:
	#DEBUG_VALUE: no_op:ignored <- %RDI
	.loc	2 42 1 prologue_end     # tests/median_test.c:42:1
	retq
.Ltmp256:
.Lfunc_end2:
	.size	no_op, .Lfunc_end2-no_op
	.cfi_endproc

	.type	generator,@object       # @generator
	.local	generator
	.comm	generator,8,8
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"min_array_count <= array_count && array_count <= max_array_count"
	.size	.L.str, 65

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"tests/median_test.c"
	.size	.L.str.1, 20

	.type	.L__PRETTY_FUNCTION__.test_median,@object # @__PRETTY_FUNCTION__.test_median
.L__PRETTY_FUNCTION__.test_median:
	.asciz	"void test_median(size_t, size_t, size_t, size_t, double, double, size_t)"
	.size	.L__PRETTY_FUNCTION__.test_median, 73

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"min_bin_count <= bin_count && bin_count <= max_bin_count"
	.size	.L.str.2, 57

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"offset0 <= max_offset"
	.size	.L.str.3, 22

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"offset1 <= max_offset"
	.size	.L.str.4, 22

	.type	test_median.input_pointers,@object # @test_median.input_pointers
	.local	test_median.input_pointers
	.comm	test_median.input_pointers,2000,16
	.type	input_data,@object      # @input_data
	.local	input_data
	.comm	input_data,225000032,16
	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"test_mean init_canary_page"
	.size	.L.str.5, 27

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"Seed = %llu\n"
	.size	.L.str.6, 13

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"\tMedian of %zi arrays of %zi integers.\n"
	.size	.L.str.7, 40

	.type	.L.str.8,@object        # @.str.8
.L.str.8:
	.asciz	"\tinput offset %zi output offset %zi.\n"
	.size	.L.str.8, 38

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
	.asciz	"\033[32m\033[1mmedian:       "
	.size	.L.str.11, 24

	.type	.L.str.13,@object       # @.str.13
.L.str.13:
	.asciz	"mediocre_clipped_median_u16 failed"
	.size	.L.str.13, 35

	.type	test_median.sorted,@object # @test_median.sorted
	.local	test_median.sorted
	.comm	test_median.sorted,1000,16
	.type	.L.str.14,@object       # @.str.14
.L.str.14:
	.asciz	"[%zi] %f != %f\n["
	.size	.L.str.14, 17

	.type	.L.str.15,@object       # @.str.15
.L.str.15:
	.asciz	"%u,"
	.size	.L.str.15, 4

	.type	get_shuffled_array_counts.numbers,@object # @get_shuffled_array_counts.numbers
	.local	get_shuffled_array_counts.numbers
	.comm	get_shuffled_array_counts.numbers,1000,32
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
	.asciz	"tests/median_test.c"   # string offset=54
.Linfo_string2:
	.asciz	"/home/david/src/MediocrePy" # string offset=74
.Linfo_string3:
	.asciz	"test_count"            # string offset=101
.Linfo_string4:
	.asciz	"long unsigned int"     # string offset=112
.Linfo_string5:
	.asciz	"size_t"                # string offset=130
.Linfo_string6:
	.asciz	"min_array_count"       # string offset=137
.Linfo_string7:
	.asciz	"max_array_count"       # string offset=153
.Linfo_string8:
	.asciz	"min_bin_count"         # string offset=169
.Linfo_string9:
	.asciz	"max_bin_count"         # string offset=183
.Linfo_string10:
	.asciz	"max_offset"            # string offset=197
.Linfo_string11:
	.asciz	"min_max_iter"          # string offset=208
.Linfo_string12:
	.asciz	"unsigned int"          # string offset=221
.Linfo_string13:
	.asciz	"uint32_t"              # string offset=234
.Linfo_string14:
	.asciz	"max_max_iter"          # string offset=243
.Linfo_string15:
	.asciz	"generator"             # string offset=256
.Linfo_string16:
	.asciz	"Random"                # string offset=266
.Linfo_string17:
	.asciz	"input_pointers"        # string offset=273
.Linfo_string18:
	.asciz	"unsigned short"        # string offset=288
.Linfo_string19:
	.asciz	"uint16_t"              # string offset=303
.Linfo_string20:
	.asciz	"sizetype"              # string offset=312
.Linfo_string21:
	.asciz	"max_threads"           # string offset=321
.Linfo_string22:
	.asciz	"sorted"                # string offset=333
.Linfo_string23:
	.asciz	"float"                 # string offset=340
.Linfo_string24:
	.asciz	"numbers"               # string offset=346
.Linfo_string25:
	.asciz	"init"                  # string offset=354
.Linfo_string26:
	.asciz	"_Bool"                 # string offset=359
.Linfo_string27:
	.asciz	"input_data"            # string offset=365
.Linfo_string28:
	.asciz	"timer_begin"           # string offset=376
.Linfo_string29:
	.asciz	"time"                  # string offset=388
.Linfo_string30:
	.asciz	"long int"              # string offset=393
.Linfo_string31:
	.asciz	"__time_t"              # string offset=402
.Linfo_string32:
	.asciz	"time_t"                # string offset=411
.Linfo_string33:
	.asciz	"millitm"               # string offset=418
.Linfo_string34:
	.asciz	"timezone"              # string offset=426
.Linfo_string35:
	.asciz	"short"                 # string offset=435
.Linfo_string36:
	.asciz	"dstflag"               # string offset=441
.Linfo_string37:
	.asciz	"timeb"                 # string offset=449
.Linfo_string38:
	.asciz	"int"                   # string offset=455
.Linfo_string39:
	.asciz	"long long unsigned int" # string offset=459
.Linfo_string40:
	.asciz	"test_median"           # string offset=482
.Linfo_string41:
	.asciz	"array_count"           # string offset=494
.Linfo_string42:
	.asciz	"bin_count"             # string offset=506
.Linfo_string43:
	.asciz	"offset0"               # string offset=516
.Linfo_string44:
	.asciz	"offset1"               # string offset=524
.Linfo_string45:
	.asciz	"sigma_lower"           # string offset=532
.Linfo_string46:
	.asciz	"double"                # string offset=544
.Linfo_string47:
	.asciz	"sigma_upper"           # string offset=551
.Linfo_string48:
	.asciz	"max_iter"              # string offset=563
.Linfo_string49:
	.asciz	"b"                     # string offset=572
.Linfo_string50:
	.asciz	"input_page"            # string offset=574
.Linfo_string51:
	.asciz	"ptr"                   # string offset=585
.Linfo_string52:
	.asciz	"mapped_"               # string offset=589
.Linfo_string53:
	.asciz	"mapped_length_"        # string offset=597
.Linfo_string54:
	.asciz	"canary_data_"          # string offset=612
.Linfo_string55:
	.asciz	"unsigned char"         # string offset=625
.Linfo_string56:
	.asciz	"canary_length_"        # string offset=639
.Linfo_string57:
	.asciz	"CanaryPage"            # string offset=654
.Linfo_string58:
	.asciz	"output_page"           # string offset=665
.Linfo_string59:
	.asciz	"output_pointer"        # string offset=677
.Linfo_string60:
	.asciz	"base"                  # string offset=692
.Linfo_string61:
	.asciz	"thread_count"          # string offset=697
.Linfo_string62:
	.asciz	"status"                # string offset=710
.Linfo_string63:
	.asciz	"shuffled"              # string offset=717
.Linfo_string64:
	.asciz	"input_pointers2"       # string offset=726
.Linfo_string65:
	.asciz	"i"                     # string offset=742
.Linfo_string66:
	.asciz	"current_count"         # string offset=744
.Linfo_string67:
	.asciz	"upper_bound"           # string offset=758
.Linfo_string68:
	.asciz	"lower_bound"           # string offset=770
.Linfo_string69:
	.asciz	"median"                # string offset=782
.Linfo_string70:
	.asciz	"a"                     # string offset=789
.Linfo_string71:
	.asciz	"iter"                  # string offset=791
.Linfo_string72:
	.asciz	"ss"                    # string offset=796
.Linfo_string73:
	.asciz	"sd"                    # string offset=799
.Linfo_string74:
	.asciz	"new_lb"                # string offset=802
.Linfo_string75:
	.asciz	"new_ub"                # string offset=809
.Linfo_string76:
	.asciz	"new_count"             # string offset=816
.Linfo_string77:
	.asciz	"c"                     # string offset=826
.Linfo_string78:
	.asciz	"n"                     # string offset=828
.Linfo_string79:
	.asciz	"dev"                   # string offset=830
.Linfo_string80:
	.asciz	"get_shuffled_array_counts" # string offset=834
.Linfo_string81:
	.asciz	"random_fill"           # string offset=860
.Linfo_string82:
	.asciz	"out"                   # string offset=872
.Linfo_string83:
	.asciz	"r"                     # string offset=876
.Linfo_string84:
	.asciz	"s"                     # string offset=878
.Linfo_string85:
	.asciz	"u16_input"             # string offset=880
.Linfo_string86:
	.asciz	"loop_function"         # string offset=890
.Linfo_string87:
	.asciz	"mediocre_input_control" # string offset=904
.Linfo_string88:
	.asciz	"MediocreInputControl"  # string offset=927
.Linfo_string89:
	.asciz	"combine_count"         # string offset=948
.Linfo_string90:
	.asciz	"width"                 # string offset=962
.Linfo_string91:
	.asciz	"mediocre_dimension"    # string offset=968
.Linfo_string92:
	.asciz	"MediocreDimension"     # string offset=987
.Linfo_string93:
	.asciz	"destructor"            # string offset=1005
.Linfo_string94:
	.asciz	"user_data"             # string offset=1016
.Linfo_string95:
	.asciz	"dimension"             # string offset=1026
.Linfo_string96:
	.asciz	"nonzero_error"         # string offset=1036
.Linfo_string97:
	.asciz	"mediocre_input"        # string offset=1050
.Linfo_string98:
	.asciz	"MediocreInput"         # string offset=1065
.Linfo_string99:
	.asciz	"result"                # string offset=1079
.Linfo_string100:
	.asciz	"ms_elapsed"            # string offset=1086
.Linfo_string101:
	.asciz	"before"                # string offset=1097
.Linfo_string102:
	.asciz	"now"                   # string offset=1104
.Linfo_string103:
	.asciz	"before_ms"             # string offset=1108
.Linfo_string104:
	.asciz	"now_ms"                # string offset=1118
.Linfo_string105:
	.asciz	"print_timer_elapsed"   # string offset=1125
.Linfo_string106:
	.asciz	"item_count"            # string offset=1145
.Linfo_string107:
	.asciz	"ms"                    # string offset=1156
.Linfo_string108:
	.asciz	"ns_per_item"           # string offset=1159
.Linfo_string109:
	.asciz	"mediocre_chunk_ptr"    # string offset=1171
.Linfo_string110:
	.asciz	"chunks"                # string offset=1190
.Linfo_string111:
	.asciz	"__m256"                # string offset=1197
.Linfo_string112:
	.asciz	"combine_axis"          # string offset=1204
.Linfo_string113:
	.asciz	"width_axis"            # string offset=1217
.Linfo_string114:
	.asciz	"chunk_ptr"             # string offset=1228
.Linfo_string115:
	.asciz	"vector_ptr"            # string offset=1238
.Linfo_string116:
	.asciz	"main"                  # string offset=1249
.Linfo_string117:
	.asciz	"u16_input_loop"        # string offset=1254
.Linfo_string118:
	.asciz	"no_op"                 # string offset=1269
.Linfo_string119:
	.asciz	"control"               # string offset=1275
.Linfo_string120:
	.asciz	"command"               # string offset=1283
.Linfo_string121:
	.asciz	"_exit"                 # string offset=1291
.Linfo_string122:
	.asciz	"offset"                # string offset=1297
.Linfo_string123:
	.asciz	"output_chunks"         # string offset=1304
.Linfo_string124:
	.asciz	"mediocre_input_command" # string offset=1318
.Linfo_string125:
	.asciz	"MediocreInputCommand"  # string offset=1341
.Linfo_string126:
	.asciz	"array_i"               # string offset=1362
.Linfo_string127:
	.asciz	"offset_array"          # string offset=1370
.Linfo_string128:
	.asciz	"p"                     # string offset=1383
.Linfo_string129:
	.asciz	"ignored"               # string offset=1385
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Ltmp14-.Lfunc_begin0
	.quad	.Ltmp15-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp16-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	.Ltmp193-.Lfunc_begin0
	.quad	.Ltmp195-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp16-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	.Ltmp184-.Lfunc_begin0
	.quad	.Ltmp197-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	.Ltmp207-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Ltmp17-.Lfunc_begin0
	.quad	.Ltmp44-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	.Ltmp200-.Lfunc_begin0
	.quad	.Ltmp204-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Ltmp17-.Lfunc_begin0
	.quad	.Ltmp44-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	.Ltmp200-.Lfunc_begin0
	.quad	.Ltmp204-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	0
	.quad	0
.Ldebug_loc4:
	.quad	.Ltmp17-.Lfunc_begin0
	.quad	.Ltmp44-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	.Ltmp176-.Lfunc_begin0
	.quad	.Ltmp177-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	.Ltmp200-.Lfunc_begin0
	.quad	.Ltmp204-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	0
	.quad	0
.Ldebug_loc5:
	.quad	.Ltmp18-.Lfunc_begin0
	.quad	.Ltmp44-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	.Ltmp200-.Lfunc_begin0
	.quad	.Ltmp204-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	0
	.quad	0
.Ldebug_loc6:
	.quad	.Ltmp18-.Lfunc_begin0
	.quad	.Ltmp44-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	.Ltmp200-.Lfunc_begin0
	.quad	.Ltmp204-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	0
	.quad	0
.Ldebug_loc7:
	.quad	.Ltmp18-.Lfunc_begin0
	.quad	.Ltmp44-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	.Ltmp200-.Lfunc_begin0
	.quad	.Ltmp204-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	0
	.quad	0
.Ldebug_loc8:
	.quad	.Ltmp19-.Lfunc_begin0
	.quad	.Ltmp37-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	86                      # DW_OP_reg6
	.quad	.Ltmp200-.Lfunc_begin0
	.quad	.Ltmp204-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	86                      # DW_OP_reg6
	.quad	0
	.quad	0
.Ldebug_loc9:
	.quad	.Ltmp19-.Lfunc_begin0
	.quad	.Ltmp37-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	86                      # DW_OP_reg6
	.quad	.Ltmp200-.Lfunc_begin0
	.quad	.Ltmp204-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	86                      # DW_OP_reg6
	.quad	0
	.quad	0
.Ldebug_loc10:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp21-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	208                     # 208
	.byte	1                       # 
	.quad	0
	.quad	0
.Ldebug_loc11:
	.quad	.Ltmp20-.Lfunc_begin0
	.quad	.Ltmp21-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	208                     # 208
	.byte	1                       # 
	.quad	0
	.quad	0
.Ldebug_loc12:
	.quad	.Ltmp22-.Lfunc_begin0
	.quad	.Ltmp28-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	184                     # 184
	.byte	1                       # 
	.quad	.Ltmp200-.Lfunc_begin0
	.quad	.Ltmp204-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	184                     # 184
	.byte	1                       # 
	.quad	0
	.quad	0
.Ldebug_loc13:
	.quad	.Ltmp22-.Lfunc_begin0
	.quad	.Ltmp28-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	184                     # 184
	.byte	1                       # 
	.quad	.Ltmp200-.Lfunc_begin0
	.quad	.Ltmp204-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	184                     # 184
	.byte	1                       # 
	.quad	0
	.quad	0
.Ldebug_loc14:
	.quad	.Ltmp30-.Lfunc_begin0
	.quad	.Ltmp39-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp39-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	1                       # 1
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc15:
	.quad	.Ltmp50-.Lfunc_begin0
	.quad	.Ltmp52-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	200                     # 200
	.byte	1                       # 
	.quad	0
	.quad	0
.Ldebug_loc16:
	.quad	.Ltmp50-.Lfunc_begin0
	.quad	.Ltmp52-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	200                     # 200
	.byte	1                       # 
	.quad	0
	.quad	0
.Ldebug_loc17:
	.quad	.Ltmp51-.Lfunc_begin0
	.quad	.Ltmp52-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	192                     # 192
	.byte	1                       # 
	.quad	0
	.quad	0
.Ldebug_loc18:
	.quad	.Ltmp51-.Lfunc_begin0
	.quad	.Ltmp52-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	192                     # 192
	.byte	1                       # 
	.quad	0
	.quad	0
.Ldebug_loc19:
	.quad	.Ltmp54-.Lfunc_begin0
	.quad	.Ltmp56-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	168                     # 168
	.byte	1                       # 
	.quad	0
	.quad	0
.Ldebug_loc20:
	.quad	.Ltmp56-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp77-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	.Ltmp77-.Lfunc_begin0
	.quad	.Ltmp78-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	224                     # 224
	.byte	1                       # 
	.quad	0
	.quad	0
.Ldebug_loc21:
	.quad	.Ltmp56-.Lfunc_begin0
	.quad	.Ltmp57-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	80                      # super-register DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	0
	.quad	0
.Ldebug_loc22:
	.quad	.Ltmp56-.Lfunc_begin0
	.quad	.Ltmp57-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	80                      # super-register DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	0
	.quad	0
.Ldebug_loc23:
	.quad	.Ltmp61-.Lfunc_begin0
	.quad	.Ltmp62-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	92                      # DW_OP_reg12
	.quad	0
	.quad	0
.Ldebug_loc24:
	.quad	.Ltmp64-.Lfunc_begin0
	.quad	.Ltmp67-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	86                      # super-register DW_OP_reg6
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	.Ltmp67-.Lfunc_begin0
	.quad	.Ltmp68-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	84                      # super-register DW_OP_reg4
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	.Ltmp68-.Lfunc_begin0
	.quad	.Ltmp69-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	86                      # super-register DW_OP_reg6
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	0
	.quad	0
.Ldebug_loc25:
	.quad	.Ltmp66-.Lfunc_begin0
	.quad	.Ltmp70-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	80                      # super-register DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	.Ltmp70-.Lfunc_begin0
	.quad	.Ltmp71-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	86                      # super-register DW_OP_reg6
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	.Ltmp71-.Lfunc_begin0
	.quad	.Ltmp72-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	80                      # super-register DW_OP_reg0
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	0
	.quad	0
.Ldebug_loc26:
	.quad	.Ltmp82-.Lfunc_begin0
	.quad	.Ltmp91-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	94                      # super-register DW_OP_reg14
	.byte	147                     # DW_OP_piece
	.byte	4                       # 4
	.quad	0
	.quad	0
.Ldebug_loc27:
	.quad	.Ltmp85-.Lfunc_begin0
	.quad	.Ltmp98-.Lfunc_begin0
	.short	5                       # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	40                      # 40
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp98-.Lfunc_begin0
	.quad	.Ltmp103-.Lfunc_begin0
	.short	5                       # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	16                      # 16
	.byte	83                      # DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp205-.Lfunc_begin0
	.quad	.Ltmp206-.Lfunc_begin0
	.short	5                       # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	16                      # 16
	.byte	83                      # DW_OP_reg3
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc28:
	.quad	.Ltmp87-.Lfunc_begin0
	.quad	.Ltmp88-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	119                     # DW_OP_breg7
	.byte	240                     # 240
	.byte	1                       # 
	.quad	0
	.quad	0
.Ldebug_loc29:
	.quad	.Ltmp89-.Lfunc_begin0
	.quad	.Ltmp103-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	86                      # DW_OP_reg6
	.quad	.Ltmp205-.Lfunc_begin0
	.quad	.Ltmp206-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	86                      # DW_OP_reg6
	.quad	0
	.quad	0
.Ldebug_loc30:
	.quad	.Ltmp90-.Lfunc_begin0
	.quad	.Ltmp102-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	92                      # DW_OP_reg12
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp205-.Lfunc_begin0
	.quad	.Ltmp206-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	92                      # DW_OP_reg12
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc31:
	.quad	.Ltmp90-.Lfunc_begin0
	.quad	.Ltmp102-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	92                      # DW_OP_reg12
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp205-.Lfunc_begin0
	.quad	.Ltmp206-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	92                      # DW_OP_reg12
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc32:
	.quad	.Ltmp95-.Lfunc_begin0
	.quad	.Ltmp103-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	.Ltmp205-.Lfunc_begin0
	.quad	.Ltmp206-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	0
	.quad	0
.Ldebug_loc33:
	.quad	.Ltmp96-.Lfunc_begin0
	.quad	.Ltmp103-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	.Ltmp205-.Lfunc_begin0
	.quad	.Ltmp206-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc34:
	.quad	.Ltmp103-.Lfunc_begin0
	.quad	.Ltmp106-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp106-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	1                       # 1
	.byte	159                     # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc35:
	.quad	.Ltmp109-.Lfunc_begin0
	.quad	.Ltmp180-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp180-.Lfunc_begin0
	.quad	.Ltmp183-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	0
	.quad	0
.Ldebug_loc36:
	.quad	.Ltmp159-.Lfunc_begin0
	.quad	.Ltmp170-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	110                     # DW_OP_reg30
	.quad	0
	.quad	0
.Ldebug_loc37:
	.quad	.Ltmp158-.Lfunc_begin0
	.quad	.Ltmp170-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	111                     # DW_OP_reg31
	.quad	0
	.quad	0
.Ldebug_loc38:
	.quad	.Ltmp133-.Lfunc_begin0
	.quad	.Ltmp136-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	98                      # DW_OP_reg18
	.quad	.Ltmp141-.Lfunc_begin0
	.quad	.Ltmp144-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	98                      # DW_OP_reg18
	.quad	0
	.quad	0
.Ldebug_loc39:
	.quad	.Ltmp137-.Lfunc_begin0
	.quad	.Ltmp138-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	98                      # DW_OP_reg18
	.quad	.Ltmp145-.Lfunc_begin0
	.quad	.Ltmp146-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	98                      # DW_OP_reg18
	.quad	0
	.quad	0
.Ldebug_loc40:
	.quad	.Ltmp139-.Lfunc_begin0
	.quad	.Ltmp139-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	.Ltmp147-.Lfunc_begin0
	.quad	.Ltmp147-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc41:
	.quad	.Ltmp140-.Lfunc_begin0
	.quad	.Ltmp140-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	81                      # DW_OP_reg1
	.quad	0
	.quad	0
.Ldebug_loc42:
	.quad	.Ltmp154-.Lfunc_begin0
	.quad	.Ltmp156-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc43:
	.quad	.Ltmp155-.Lfunc_begin0
	.quad	.Ltmp170-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	99                      # DW_OP_reg19
	.quad	0
	.quad	0
.Ldebug_loc44:
	.quad	.Ltmp157-.Lfunc_begin0
	.quad	.Ltmp163-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc45:
	.quad	.Ltmp159-.Lfunc_begin0
	.quad	.Ltmp165-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp165-.Lfunc_begin0
	.quad	.Ltmp173-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	1                       # 1
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp173-.Lfunc_begin0
	.quad	.Ltmp174-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	0
	.quad	0
.Ldebug_loc46:
	.quad	.Ltmp163-.Lfunc_begin0
	.quad	.Ltmp167-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	.Ltmp171-.Lfunc_begin0
	.quad	.Ltmp175-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	97                      # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc47:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp230-.Lfunc_begin0
	.short	6                       # Loc expr size
	.byte	81                      # DW_OP_reg1
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	82                      # DW_OP_reg2
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	0
	.quad	0
.Ldebug_loc48:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp223-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	85                      # DW_OP_reg5
	.quad	.Ltmp223-.Lfunc_begin0
	.quad	.Ltmp230-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	94                      # DW_OP_reg14
	.quad	0
	.quad	0
.Ldebug_loc49:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp222-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	84                      # DW_OP_reg4
	.quad	.Ltmp222-.Lfunc_begin0
	.quad	.Ltmp230-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	92                      # DW_OP_reg12
	.quad	0
	.quad	0
.Ldebug_loc50:
	.quad	.Ltmp227-.Lfunc_begin0
	.quad	.Ltmp228-.Lfunc_begin0
	.short	5                       # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	32                      # 32
	.byte	93                      # DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp228-.Lfunc_begin0
	.quad	.Ltmp229-.Lfunc_begin0
	.short	8                       # Loc expr size
	.byte	147                     # DW_OP_piece
	.byte	24                      # 24
	.byte	91                      # DW_OP_reg11
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.byte	93                      # DW_OP_reg13
	.byte	147                     # DW_OP_piece
	.byte	8                       # 8
	.quad	.Ltmp229-.Lfunc_begin0
	.quad	.Ltmp230-.Lfunc_begin0
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
	.quad	.Ltmp230-.Lfunc_begin0
	.quad	.Ltmp230-.Lfunc_begin0
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
	.quad	.Ltmp250-.Lfunc_begin0
	.quad	.Ltmp254-.Lfunc_begin0
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
.Ldebug_loc51:
	.quad	.Ltmp233-.Lfunc_begin0
	.quad	.Ltmp236-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	0                       # 0
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp236-.Lfunc_begin0
	.quad	.Ltmp243-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	1                       # 1
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp243-.Lfunc_begin0
	.quad	.Ltmp244-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	0
	.quad	0
.Ldebug_loc52:
	.quad	.Ltmp235-.Lfunc_begin0
	.quad	.Ltmp237-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	93                      # DW_OP_reg13
	.quad	.Ltmp239-.Lfunc_begin0
	.quad	.Ltmp240-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	0
	.quad	0
.Ldebug_loc53:
	.quad	.Ltmp235-.Lfunc_begin0
	.quad	.Ltmp243-.Lfunc_begin0
	.short	3                       # Loc expr size
	.byte	16                      # DW_OP_constu
	.byte	1                       # 1
	.byte	159                     # DW_OP_stack_value
	.quad	.Ltmp243-.Lfunc_begin0
	.quad	.Ltmp244-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	0
	.quad	0
.Ldebug_loc54:
	.quad	.Ltmp240-.Lfunc_begin0
	.quad	.Ltmp243-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	80                      # DW_OP_reg0
	.quad	0
	.quad	0
.Ldebug_loc55:
	.quad	.Ltmp247-.Lfunc_begin0
	.quad	.Ltmp248-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	82                      # DW_OP_reg2
	.quad	0
	.quad	0
.Ldebug_loc56:
	.quad	.Ltmp247-.Lfunc_begin0
	.quad	.Ltmp248-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	82                      # DW_OP_reg2
	.quad	0
	.quad	0
.Ldebug_loc57:
	.quad	.Ltmp251-.Lfunc_begin0
	.quad	.Ltmp254-.Lfunc_begin0
	.short	1                       # Loc expr size
	.byte	95                      # DW_OP_reg15
	.quad	0
	.quad	0
.Ldebug_loc58:
	.quad	.Ltmp253-.Lfunc_begin0
	.quad	.Ltmp254-.Lfunc_begin0
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
	.byte	1                       # DW_TAG_array_type
	.byte	1                       # DW_CHILDREN_yes
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	11                      # Abbreviation Code
	.byte	33                      # DW_TAG_subrange_type
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	55                      # DW_AT_count
	.byte	11                      # DW_FORM_data1
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	12                      # Abbreviation Code
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
	.byte	13                      # Abbreviation Code
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
	.byte	18                      # Abbreviation Code
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
	.byte	19                      # Abbreviation Code
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
	.byte	20                      # Abbreviation Code
	.byte	11                      # DW_TAG_lexical_block
	.byte	1                       # DW_CHILDREN_yes
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	21                      # Abbreviation Code
	.byte	15                      # DW_TAG_pointer_type
	.byte	0                       # DW_CHILDREN_no
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	22                      # Abbreviation Code
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
	.byte	23                      # Abbreviation Code
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
	.byte	24                      # Abbreviation Code
	.byte	21                      # DW_TAG_subroutine_type
	.byte	1                       # DW_CHILDREN_yes
	.byte	39                      # DW_AT_prototyped
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	25                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	26                      # Abbreviation Code
	.byte	38                      # DW_TAG_const_type
	.byte	0                       # DW_CHILDREN_no
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	27                      # Abbreviation Code
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
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	63                      # DW_AT_external
	.byte	25                      # DW_FORM_flag_present
	.ascii	"\341\177"              # DW_AT_APPLE_optimized
	.byte	25                      # DW_FORM_flag_present
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	28                      # Abbreviation Code
	.byte	11                      # DW_TAG_lexical_block
	.byte	1                       # DW_CHILDREN_yes
	.byte	85                      # DW_AT_ranges
	.byte	23                      # DW_FORM_sec_offset
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	29                      # Abbreviation Code
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
	.byte	30                      # Abbreviation Code
	.byte	29                      # DW_TAG_inlined_subroutine
	.byte	1                       # DW_CHILDREN_yes
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	85                      # DW_AT_ranges
	.byte	23                      # DW_FORM_sec_offset
	.byte	88                      # DW_AT_call_file
	.byte	11                      # DW_FORM_data1
	.byte	89                      # DW_AT_call_line
	.byte	5                       # DW_FORM_data2
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	31                      # Abbreviation Code
	.byte	5                       # DW_TAG_formal_parameter
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	32                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	2                       # DW_AT_location
	.byte	23                      # DW_FORM_sec_offset
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	33                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	34                      # Abbreviation Code
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
	.byte	35                      # Abbreviation Code
	.byte	11                      # DW_TAG_lexical_block
	.byte	1                       # DW_CHILDREN_yes
	.byte	17                      # DW_AT_low_pc
	.byte	1                       # DW_FORM_addr
	.byte	18                      # DW_AT_high_pc
	.byte	6                       # DW_FORM_data4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	36                      # Abbreviation Code
	.byte	52                      # DW_TAG_variable
	.byte	0                       # DW_CHILDREN_no
	.byte	28                      # DW_AT_const_value
	.byte	15                      # DW_FORM_udata
	.byte	49                      # DW_AT_abstract_origin
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	37                      # Abbreviation Code
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
	.byte	38                      # Abbreviation Code
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
	.byte	39                      # Abbreviation Code
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
	.byte	40                      # Abbreviation Code
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
	.byte	41                      # Abbreviation Code
	.byte	1                       # DW_TAG_array_type
	.byte	1                       # DW_CHILDREN_yes
	.ascii	"\207B"                 # DW_AT_GNU_vector
	.byte	25                      # DW_FORM_flag_present
	.byte	73                      # DW_AT_type
	.byte	19                      # DW_FORM_ref4
	.byte	0                       # EOM(1)
	.byte	0                       # EOM(2)
	.byte	42                      # Abbreviation Code
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
	.byte	43                      # Abbreviation Code
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
	.byte	44                      # Abbreviation Code
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
	.byte	45                      # Abbreviation Code
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
	.byte	0                       # EOM(3)
	.section	.debug_info,"",@progbits
.Lsection_info:
.Lcu_begin0:
	.long	2881                    # Length of Unit
	.short	4                       # DWARF version number
	.long	.Lsection_abbrev        # Offset Into Abbrev. Section
	.byte	8                       # Address Size (in bytes)
	.byte	1                       # Abbrev [1] 0xb:0xb3a DW_TAG_compile_unit
	.long	.Linfo_string0          # DW_AT_producer
	.short	12                      # DW_AT_language
	.long	.Linfo_string1          # DW_AT_name
	.long	.Lline_table_start0     # DW_AT_stmt_list
	.long	.Linfo_string2          # DW_AT_comp_dir
                                        # DW_AT_APPLE_optimized
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end2-.Lfunc_begin0 # DW_AT_high_pc
	.byte	2                       # Abbrev [2] 0x2a:0xc DW_TAG_variable
	.long	.Linfo_string3          # DW_AT_name
	.long	54                      # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	64                      # DW_AT_decl_line
	.byte	8                       # DW_AT_const_value
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
	.byte	2                       # Abbrev [2] 0x4d:0xc DW_TAG_variable
	.long	.Linfo_string6          # DW_AT_name
	.long	54                      # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	66                      # DW_AT_decl_line
	.byte	50                      # DW_AT_const_value
	.byte	2                       # Abbrev [2] 0x59:0xd DW_TAG_variable
	.long	.Linfo_string7          # DW_AT_name
	.long	54                      # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	67                      # DW_AT_decl_line
	.ascii	"\372\001"              # DW_AT_const_value
	.byte	2                       # Abbrev [2] 0x66:0xe DW_TAG_variable
	.long	.Linfo_string8          # DW_AT_name
	.long	54                      # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	68                      # DW_AT_decl_line
	.ascii	"\200\265\030"          # DW_AT_const_value
	.byte	2                       # Abbrev [2] 0x74:0xe DW_TAG_variable
	.long	.Linfo_string9          # DW_AT_name
	.long	54                      # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	69                      # DW_AT_decl_line
	.ascii	"\320\273\033"          # DW_AT_const_value
	.byte	2                       # Abbrev [2] 0x82:0xc DW_TAG_variable
	.long	.Linfo_string10         # DW_AT_name
	.long	54                      # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	65                      # DW_AT_decl_line
	.byte	15                      # DW_AT_const_value
	.byte	2                       # Abbrev [2] 0x8e:0xc DW_TAG_variable
	.long	.Linfo_string11         # DW_AT_name
	.long	154                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	70                      # DW_AT_decl_line
	.byte	0                       # DW_AT_const_value
	.byte	3                       # Abbrev [3] 0x9a:0x5 DW_TAG_const_type
	.long	159                     # DW_AT_type
	.byte	4                       # Abbrev [4] 0x9f:0xb DW_TAG_typedef
	.long	170                     # DW_AT_type
	.long	.Linfo_string13         # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	51                      # DW_AT_decl_line
	.byte	5                       # Abbrev [5] 0xaa:0x7 DW_TAG_base_type
	.long	.Linfo_string12         # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	2                       # Abbrev [2] 0xb1:0xc DW_TAG_variable
	.long	.Linfo_string14         # DW_AT_name
	.long	154                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	71                      # DW_AT_decl_line
	.byte	5                       # DW_AT_const_value
	.byte	6                       # Abbrev [6] 0xbd:0x15 DW_TAG_variable
	.long	.Linfo_string15         # DW_AT_name
	.long	210                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	61                      # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	generator
	.byte	7                       # Abbrev [7] 0xd2:0x5 DW_TAG_pointer_type
	.long	215                     # DW_AT_type
	.byte	8                       # Abbrev [8] 0xd7:0x5 DW_TAG_structure_type
	.long	.Linfo_string16         # DW_AT_name
                                        # DW_AT_declaration
	.byte	9                       # Abbrev [9] 0xdc:0x30 DW_TAG_subprogram
	.long	587                     # DW_AT_abstract_origin
	.byte	6                       # Abbrev [6] 0xe1:0x15 DW_TAG_variable
	.long	.Linfo_string17         # DW_AT_name
	.long	268                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	127                     # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	test_median.input_pointers
	.byte	6                       # Abbrev [6] 0xf6:0x15 DW_TAG_variable
	.long	.Linfo_string22         # DW_AT_name
	.long	322                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	190                     # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	test_median.sorted
	.byte	0                       # End Of Children Mark
	.byte	10                      # Abbrev [10] 0x10c:0xc DW_TAG_array_type
	.long	280                     # DW_AT_type
	.byte	11                      # Abbrev [11] 0x111:0x6 DW_TAG_subrange_type
	.long	303                     # DW_AT_type
	.byte	250                     # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x118:0x5 DW_TAG_pointer_type
	.long	285                     # DW_AT_type
	.byte	4                       # Abbrev [4] 0x11d:0xb DW_TAG_typedef
	.long	296                     # DW_AT_type
	.long	.Linfo_string19         # DW_AT_name
	.byte	3                       # DW_AT_decl_file
	.byte	49                      # DW_AT_decl_line
	.byte	5                       # Abbrev [5] 0x128:0x7 DW_TAG_base_type
	.long	.Linfo_string18         # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	2                       # DW_AT_byte_size
	.byte	12                      # Abbrev [12] 0x12f:0x7 DW_TAG_base_type
	.long	.Linfo_string20         # DW_AT_name
	.byte	8                       # DW_AT_byte_size
	.byte	7                       # DW_AT_encoding
	.byte	2                       # Abbrev [2] 0x136:0xc DW_TAG_variable
	.long	.Linfo_string21         # DW_AT_name
	.long	154                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	72                      # DW_AT_decl_line
	.byte	12                      # DW_AT_const_value
	.byte	10                      # Abbrev [10] 0x142:0xc DW_TAG_array_type
	.long	334                     # DW_AT_type
	.byte	11                      # Abbrev [11] 0x147:0x6 DW_TAG_subrange_type
	.long	303                     # DW_AT_type
	.byte	250                     # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	5                       # Abbrev [5] 0x14e:0x7 DW_TAG_base_type
	.long	.Linfo_string23         # DW_AT_name
	.byte	4                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	9                       # Abbrev [9] 0x155:0x26 DW_TAG_subprogram
	.long	1112                    # DW_AT_abstract_origin
	.byte	6                       # Abbrev [6] 0x15a:0x15 DW_TAG_variable
	.long	.Linfo_string24         # DW_AT_name
	.long	379                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	79                      # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	get_shuffled_array_counts.numbers
	.byte	13                      # Abbrev [13] 0x16f:0xb DW_TAG_variable
	.long	.Linfo_string25         # DW_AT_name
	.long	391                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	80                      # DW_AT_decl_line
	.byte	0                       # End Of Children Mark
	.byte	10                      # Abbrev [10] 0x17b:0xc DW_TAG_array_type
	.long	159                     # DW_AT_type
	.byte	11                      # Abbrev [11] 0x180:0x6 DW_TAG_subrange_type
	.long	303                     # DW_AT_type
	.byte	250                     # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	5                       # Abbrev [5] 0x187:0x7 DW_TAG_base_type
	.long	.Linfo_string26         # DW_AT_name
	.byte	2                       # DW_AT_encoding
	.byte	1                       # DW_AT_byte_size
	.byte	6                       # Abbrev [6] 0x18e:0x15 DW_TAG_variable
	.long	.Linfo_string27         # DW_AT_name
	.long	419                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	74                      # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	input_data
	.byte	10                      # Abbrev [10] 0x1a3:0xf DW_TAG_array_type
	.long	285                     # DW_AT_type
	.byte	14                      # Abbrev [14] 0x1a8:0x9 DW_TAG_subrange_type
	.long	303                     # DW_AT_type
	.long	112500016               # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	6                       # Abbrev [6] 0x1b2:0x15 DW_TAG_variable
	.long	.Linfo_string28         # DW_AT_name
	.long	455                     # DW_AT_type
	.byte	2                       # DW_AT_decl_file
	.byte	62                      # DW_AT_decl_line
	.byte	9                       # DW_AT_location
	.byte	3
	.quad	timer_begin
	.byte	15                      # Abbrev [15] 0x1c7:0x39 DW_TAG_structure_type
	.long	.Linfo_string37         # DW_AT_name
	.byte	16                      # DW_AT_byte_size
	.byte	6                       # DW_AT_decl_file
	.byte	31                      # DW_AT_decl_line
	.byte	16                      # Abbrev [16] 0x1cf:0xc DW_TAG_member
	.long	.Linfo_string29         # DW_AT_name
	.long	512                     # DW_AT_type
	.byte	6                       # DW_AT_decl_file
	.byte	33                      # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x1db:0xc DW_TAG_member
	.long	.Linfo_string33         # DW_AT_name
	.long	296                     # DW_AT_type
	.byte	6                       # DW_AT_decl_file
	.byte	34                      # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x1e7:0xc DW_TAG_member
	.long	.Linfo_string34         # DW_AT_name
	.long	541                     # DW_AT_type
	.byte	6                       # DW_AT_decl_file
	.byte	35                      # DW_AT_decl_line
	.byte	10                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x1f3:0xc DW_TAG_member
	.long	.Linfo_string36         # DW_AT_name
	.long	541                     # DW_AT_type
	.byte	6                       # DW_AT_decl_file
	.byte	36                      # DW_AT_decl_line
	.byte	12                      # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0x200:0xb DW_TAG_typedef
	.long	523                     # DW_AT_type
	.long	.Linfo_string32         # DW_AT_name
	.byte	5                       # DW_AT_decl_file
	.byte	75                      # DW_AT_decl_line
	.byte	4                       # Abbrev [4] 0x20b:0xb DW_TAG_typedef
	.long	534                     # DW_AT_type
	.long	.Linfo_string31         # DW_AT_name
	.byte	4                       # DW_AT_decl_file
	.byte	139                     # DW_AT_decl_line
	.byte	5                       # Abbrev [5] 0x216:0x7 DW_TAG_base_type
	.long	.Linfo_string30         # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	5                       # Abbrev [5] 0x21d:0x7 DW_TAG_base_type
	.long	.Linfo_string35         # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	2                       # DW_AT_byte_size
	.byte	5                       # Abbrev [5] 0x224:0x7 DW_TAG_base_type
	.long	.Linfo_string38         # DW_AT_name
	.byte	5                       # DW_AT_encoding
	.byte	4                       # DW_AT_byte_size
	.byte	5                       # Abbrev [5] 0x22b:0x7 DW_TAG_base_type
	.long	.Linfo_string39         # DW_AT_name
	.byte	7                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	7                       # Abbrev [7] 0x232:0x5 DW_TAG_pointer_type
	.long	567                     # DW_AT_type
	.byte	3                       # Abbrev [3] 0x237:0x5 DW_TAG_const_type
	.long	572                     # DW_AT_type
	.byte	7                       # Abbrev [7] 0x23c:0x5 DW_TAG_pointer_type
	.long	577                     # DW_AT_type
	.byte	3                       # Abbrev [3] 0x241:0x5 DW_TAG_const_type
	.long	285                     # DW_AT_type
	.byte	7                       # Abbrev [7] 0x246:0x5 DW_TAG_pointer_type
	.long	334                     # DW_AT_type
	.byte	17                      # Abbrev [17] 0x24b:0x1af DW_TAG_subprogram
	.long	.Linfo_string40         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	113                     # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	18                      # Abbrev [18] 0x253:0xb DW_TAG_formal_parameter
	.long	.Linfo_string41         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	114                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x25e:0xb DW_TAG_formal_parameter
	.long	.Linfo_string42         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	115                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x269:0xb DW_TAG_formal_parameter
	.long	.Linfo_string43         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	116                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x274:0xb DW_TAG_formal_parameter
	.long	.Linfo_string44         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	117                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x27f:0xb DW_TAG_formal_parameter
	.long	.Linfo_string45         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	118                     # DW_AT_decl_line
	.long	1018                    # DW_AT_type
	.byte	18                      # Abbrev [18] 0x28a:0xb DW_TAG_formal_parameter
	.long	.Linfo_string47         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	119                     # DW_AT_decl_line
	.long	1018                    # DW_AT_type
	.byte	18                      # Abbrev [18] 0x295:0xb DW_TAG_formal_parameter
	.long	.Linfo_string48         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	120                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	19                      # Abbrev [19] 0x2a0:0xb DW_TAG_variable
	.long	.Linfo_string49         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	192                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	19                      # Abbrev [19] 0x2ab:0xb DW_TAG_variable
	.long	.Linfo_string50         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	139                     # DW_AT_decl_line
	.long	1025                    # DW_AT_type
	.byte	19                      # Abbrev [19] 0x2b6:0xb DW_TAG_variable
	.long	.Linfo_string58         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	139                     # DW_AT_decl_line
	.long	1025                    # DW_AT_type
	.byte	19                      # Abbrev [19] 0x2c1:0xb DW_TAG_variable
	.long	.Linfo_string59         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	153                     # DW_AT_decl_line
	.long	582                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x2cc:0xb DW_TAG_variable
	.long	.Linfo_string60         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	156                     # DW_AT_decl_line
	.long	154                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x2d7:0xb DW_TAG_variable
	.long	.Linfo_string61         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	162                     # DW_AT_decl_line
	.long	548                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x2e2:0xb DW_TAG_variable
	.long	.Linfo_string62         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	174                     # DW_AT_decl_line
	.long	548                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x2ed:0xb DW_TAG_variable
	.long	.Linfo_string63         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	134                     # DW_AT_decl_line
	.long	1107                    # DW_AT_type
	.byte	19                      # Abbrev [19] 0x2f8:0xb DW_TAG_variable
	.long	.Linfo_string64         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	170                     # DW_AT_decl_line
	.long	562                     # DW_AT_type
	.byte	20                      # Abbrev [20] 0x303:0xd DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x304:0xb DW_TAG_variable
	.long	.Linfo_string65         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	128                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	20                      # Abbrev [20] 0x310:0xd DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x311:0xb DW_TAG_variable
	.long	.Linfo_string65         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	135                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	20                      # Abbrev [20] 0x31d:0xd DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x31e:0xb DW_TAG_variable
	.long	.Linfo_string65         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	157                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	20                      # Abbrev [20] 0x32a:0xcf DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x32b:0xb DW_TAG_variable
	.long	.Linfo_string66         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	200                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	19                      # Abbrev [19] 0x336:0xb DW_TAG_variable
	.long	.Linfo_string67         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	205                     # DW_AT_decl_line
	.long	334                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x341:0xb DW_TAG_variable
	.long	.Linfo_string68         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	205                     # DW_AT_decl_line
	.long	334                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x34c:0xb DW_TAG_variable
	.long	.Linfo_string69         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	202                     # DW_AT_decl_line
	.long	334                     # DW_AT_type
	.byte	20                      # Abbrev [20] 0x357:0xd DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x358:0xb DW_TAG_variable
	.long	.Linfo_string70         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	196                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	20                      # Abbrev [20] 0x364:0x87 DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x365:0xb DW_TAG_variable
	.long	.Linfo_string71         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	207                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x370:0x7a DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x371:0xb DW_TAG_variable
	.long	.Linfo_string72         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	208                     # DW_AT_decl_line
	.long	1018                    # DW_AT_type
	.byte	19                      # Abbrev [19] 0x37c:0xb DW_TAG_variable
	.long	.Linfo_string73         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	216                     # DW_AT_decl_line
	.long	1018                    # DW_AT_type
	.byte	19                      # Abbrev [19] 0x387:0xb DW_TAG_variable
	.long	.Linfo_string74         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	217                     # DW_AT_decl_line
	.long	334                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x392:0xb DW_TAG_variable
	.long	.Linfo_string75         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	218                     # DW_AT_decl_line
	.long	334                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x39d:0xb DW_TAG_variable
	.long	.Linfo_string76         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	223                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x3a8:0x27 DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x3a9:0xb DW_TAG_variable
	.long	.Linfo_string77         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	209                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x3b4:0x1a DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x3b5:0xb DW_TAG_variable
	.long	.Linfo_string78         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	210                     # DW_AT_decl_line
	.long	334                     # DW_AT_type
	.byte	20                      # Abbrev [20] 0x3c0:0xd DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x3c1:0xb DW_TAG_variable
	.long	.Linfo_string79         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	212                     # DW_AT_decl_line
	.long	1018                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	20                      # Abbrev [20] 0x3cf:0x1a DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x3d0:0xb DW_TAG_variable
	.long	.Linfo_string77         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	224                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x3db:0xd DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x3dc:0xb DW_TAG_variable
	.long	.Linfo_string78         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	225                     # DW_AT_decl_line
	.long	334                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	20                      # Abbrev [20] 0x3eb:0xd DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x3ec:0xb DW_TAG_variable
	.long	.Linfo_string70         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	238                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	5                       # Abbrev [5] 0x3fa:0x7 DW_TAG_base_type
	.long	.Linfo_string46         # DW_AT_name
	.byte	4                       # DW_AT_encoding
	.byte	8                       # DW_AT_byte_size
	.byte	15                      # Abbrev [15] 0x401:0x45 DW_TAG_structure_type
	.long	.Linfo_string57         # DW_AT_name
	.byte	40                      # DW_AT_byte_size
	.byte	7                       # DW_AT_decl_file
	.byte	101                     # DW_AT_decl_line
	.byte	16                      # Abbrev [16] 0x409:0xc DW_TAG_member
	.long	.Linfo_string51         # DW_AT_name
	.long	1094                    # DW_AT_type
	.byte	7                       # DW_AT_decl_file
	.byte	102                     # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x415:0xc DW_TAG_member
	.long	.Linfo_string52         # DW_AT_name
	.long	1094                    # DW_AT_type
	.byte	7                       # DW_AT_decl_file
	.byte	104                     # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x421:0xc DW_TAG_member
	.long	.Linfo_string53         # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	7                       # DW_AT_decl_file
	.byte	105                     # DW_AT_decl_line
	.byte	16                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x42d:0xc DW_TAG_member
	.long	.Linfo_string54         # DW_AT_name
	.long	1095                    # DW_AT_type
	.byte	7                       # DW_AT_decl_file
	.byte	106                     # DW_AT_decl_line
	.byte	24                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x439:0xc DW_TAG_member
	.long	.Linfo_string56         # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	7                       # DW_AT_decl_file
	.byte	107                     # DW_AT_decl_line
	.byte	32                      # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	21                      # Abbrev [21] 0x446:0x1 DW_TAG_pointer_type
	.byte	7                       # Abbrev [7] 0x447:0x5 DW_TAG_pointer_type
	.long	1100                    # DW_AT_type
	.byte	5                       # Abbrev [5] 0x44c:0x7 DW_TAG_base_type
	.long	.Linfo_string55         # DW_AT_name
	.byte	8                       # DW_AT_encoding
	.byte	1                       # DW_AT_byte_size
	.byte	7                       # Abbrev [7] 0x453:0x5 DW_TAG_pointer_type
	.long	154                     # DW_AT_type
	.byte	22                      # Abbrev [22] 0x458:0x1a DW_TAG_subprogram
	.long	.Linfo_string80         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	78                      # DW_AT_decl_line
	.long	1107                    # DW_AT_type
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	20                      # Abbrev [20] 0x464:0xd DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x465:0xb DW_TAG_variable
	.long	.Linfo_string65         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	84                      # DW_AT_decl_line
	.long	159                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	17                      # Abbrev [17] 0x472:0x5a DW_TAG_subprogram
	.long	.Linfo_string81         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	92                      # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	18                      # Abbrev [18] 0x47a:0xb DW_TAG_formal_parameter
	.long	.Linfo_string82         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	92                      # DW_AT_decl_line
	.long	280                     # DW_AT_type
	.byte	18                      # Abbrev [18] 0x485:0xb DW_TAG_formal_parameter
	.long	.Linfo_string42         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	92                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x490:0xb DW_TAG_formal_parameter
	.long	.Linfo_string60         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	92                      # DW_AT_decl_line
	.long	159                     # DW_AT_type
	.byte	20                      # Abbrev [20] 0x49b:0x30 DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x49c:0xb DW_TAG_variable
	.long	.Linfo_string65         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	93                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	20                      # Abbrev [20] 0x4a7:0x23 DW_TAG_lexical_block
	.byte	19                      # Abbrev [19] 0x4a8:0xb DW_TAG_variable
	.long	.Linfo_string83         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	94                      # DW_AT_decl_line
	.long	159                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x4b3:0xb DW_TAG_variable
	.long	.Linfo_string84         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	95                      # DW_AT_decl_line
	.long	159                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x4be:0xb DW_TAG_variable
	.long	.Linfo_string70         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	97                      # DW_AT_decl_line
	.long	285                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	23                      # Abbrev [23] 0x4cc:0x39 DW_TAG_subprogram
	.long	.Linfo_string85         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	44                      # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	1285                    # DW_AT_type
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	18                      # Abbrev [18] 0x4d8:0xb DW_TAG_formal_parameter
	.long	.Linfo_string17         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	45                      # DW_AT_decl_line
	.long	562                     # DW_AT_type
	.byte	18                      # Abbrev [18] 0x4e3:0xb DW_TAG_formal_parameter
	.long	.Linfo_string89         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	46                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	18                      # Abbrev [18] 0x4ee:0xb DW_TAG_formal_parameter
	.long	.Linfo_string90         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	47                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	19                      # Abbrev [19] 0x4f9:0xb DW_TAG_variable
	.long	.Linfo_string99         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	49                      # DW_AT_decl_line
	.long	1285                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0x505:0xb DW_TAG_typedef
	.long	1296                    # DW_AT_type
	.long	.Linfo_string98         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.byte	53                      # DW_AT_decl_line
	.byte	15                      # Abbrev [15] 0x510:0x45 DW_TAG_structure_type
	.long	.Linfo_string97         # DW_AT_name
	.byte	48                      # DW_AT_byte_size
	.byte	8                       # DW_AT_decl_file
	.byte	40                      # DW_AT_decl_line
	.byte	16                      # Abbrev [16] 0x518:0xc DW_TAG_member
	.long	.Linfo_string86         # DW_AT_name
	.long	1365                    # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	41                      # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x524:0xc DW_TAG_member
	.long	.Linfo_string93         # DW_AT_name
	.long	1458                    # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	46                      # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x530:0xc DW_TAG_member
	.long	.Linfo_string94         # DW_AT_name
	.long	1408                    # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	47                      # DW_AT_decl_line
	.byte	16                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x53c:0xc DW_TAG_member
	.long	.Linfo_string95         # DW_AT_name
	.long	1414                    # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	48                      # DW_AT_decl_line
	.byte	24                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x548:0xc DW_TAG_member
	.long	.Linfo_string96         # DW_AT_name
	.long	548                     # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	50                      # DW_AT_decl_line
	.byte	40                      # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x555:0x5 DW_TAG_pointer_type
	.long	1370                    # DW_AT_type
	.byte	24                      # Abbrev [24] 0x55a:0x11 DW_TAG_subroutine_type
                                        # DW_AT_prototyped
	.byte	25                      # Abbrev [25] 0x55b:0x5 DW_TAG_formal_parameter
	.long	1387                    # DW_AT_type
	.byte	25                      # Abbrev [25] 0x560:0x5 DW_TAG_formal_parameter
	.long	1408                    # DW_AT_type
	.byte	25                      # Abbrev [25] 0x565:0x5 DW_TAG_formal_parameter
	.long	1414                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x56b:0x5 DW_TAG_pointer_type
	.long	1392                    # DW_AT_type
	.byte	4                       # Abbrev [4] 0x570:0xb DW_TAG_typedef
	.long	1403                    # DW_AT_type
	.long	.Linfo_string88         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.byte	19                      # DW_AT_decl_line
	.byte	8                       # Abbrev [8] 0x57b:0x5 DW_TAG_structure_type
	.long	.Linfo_string87         # DW_AT_name
                                        # DW_AT_declaration
	.byte	7                       # Abbrev [7] 0x580:0x5 DW_TAG_pointer_type
	.long	1413                    # DW_AT_type
	.byte	26                      # Abbrev [26] 0x585:0x1 DW_TAG_const_type
	.byte	4                       # Abbrev [4] 0x586:0xb DW_TAG_typedef
	.long	1425                    # DW_AT_type
	.long	.Linfo_string92         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.byte	37                      # DW_AT_decl_line
	.byte	15                      # Abbrev [15] 0x591:0x21 DW_TAG_structure_type
	.long	.Linfo_string91         # DW_AT_name
	.byte	16                      # DW_AT_byte_size
	.byte	8                       # DW_AT_decl_file
	.byte	34                      # DW_AT_decl_line
	.byte	16                      # Abbrev [16] 0x599:0xc DW_TAG_member
	.long	.Linfo_string89         # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	35                      # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0x5a5:0xc DW_TAG_member
	.long	.Linfo_string90         # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	36                      # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x5b2:0x5 DW_TAG_pointer_type
	.long	1463                    # DW_AT_type
	.byte	24                      # Abbrev [24] 0x5b7:0x7 DW_TAG_subroutine_type
                                        # DW_AT_prototyped
	.byte	25                      # Abbrev [25] 0x5b8:0x5 DW_TAG_formal_parameter
	.long	1094                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	23                      # Abbrev [23] 0x5be:0x39 DW_TAG_subprogram
	.long	.Linfo_string100        # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	69                      # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	534                     # DW_AT_type
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	18                      # Abbrev [18] 0x5ca:0xb DW_TAG_formal_parameter
	.long	.Linfo_string101        # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	69                      # DW_AT_decl_line
	.long	455                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x5d5:0xb DW_TAG_variable
	.long	.Linfo_string102        # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	70                      # DW_AT_decl_line
	.long	455                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x5e0:0xb DW_TAG_variable
	.long	.Linfo_string103        # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	72                      # DW_AT_decl_line
	.long	534                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x5eb:0xb DW_TAG_variable
	.long	.Linfo_string104        # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	73                      # DW_AT_decl_line
	.long	534                     # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	17                      # Abbrev [17] 0x5f7:0x35 DW_TAG_subprogram
	.long	.Linfo_string105        # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	77                      # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	18                      # Abbrev [18] 0x5ff:0xb DW_TAG_formal_parameter
	.long	.Linfo_string101        # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	77                      # DW_AT_decl_line
	.long	455                     # DW_AT_type
	.byte	18                      # Abbrev [18] 0x60a:0xb DW_TAG_formal_parameter
	.long	.Linfo_string106        # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	77                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	19                      # Abbrev [19] 0x615:0xb DW_TAG_variable
	.long	.Linfo_string107        # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	78                      # DW_AT_decl_line
	.long	534                     # DW_AT_type
	.byte	19                      # Abbrev [19] 0x620:0xb DW_TAG_variable
	.long	.Linfo_string108        # DW_AT_name
	.byte	7                       # DW_AT_decl_file
	.byte	79                      # DW_AT_decl_line
	.long	1018                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	27                      # Abbrev [27] 0x62c:0x309 DW_TAG_subprogram
	.quad	.Lfunc_begin0           # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0 # DW_AT_high_pc
                                        # DW_AT_APPLE_omit_frame_ptr
	.byte	1                       # DW_AT_frame_base
	.byte	87
	.long	.Linfo_string116        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	255                     # DW_AT_decl_line
	.long	548                     # DW_AT_type
                                        # DW_AT_external
                                        # DW_AT_APPLE_optimized
	.byte	28                      # Abbrev [28] 0x645:0x2ef DW_TAG_lexical_block
	.long	.Ldebug_ranges15        # DW_AT_ranges
	.byte	29                      # Abbrev [29] 0x64a:0x10 DW_TAG_variable
	.long	.Ldebug_loc0            # DW_AT_location
	.long	.Linfo_string65         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	258                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	28                      # Abbrev [28] 0x65a:0x2d9 DW_TAG_lexical_block
	.long	.Ldebug_ranges14        # DW_AT_ranges
	.byte	29                      # Abbrev [29] 0x65f:0x10 DW_TAG_variable
	.long	.Ldebug_loc2            # DW_AT_location
	.long	.Linfo_string41         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	259                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	29                      # Abbrev [29] 0x66f:0x10 DW_TAG_variable
	.long	.Ldebug_loc5            # DW_AT_location
	.long	.Linfo_string42         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	262                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	29                      # Abbrev [29] 0x67f:0x10 DW_TAG_variable
	.long	.Ldebug_loc8            # DW_AT_location
	.long	.Linfo_string43         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	265                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	29                      # Abbrev [29] 0x68f:0x10 DW_TAG_variable
	.long	.Ldebug_loc10           # DW_AT_location
	.long	.Linfo_string44         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	266                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	29                      # Abbrev [29] 0x69f:0x10 DW_TAG_variable
	.long	.Ldebug_loc12           # DW_AT_location
	.long	.Linfo_string48         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	269                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	29                      # Abbrev [29] 0x6af:0x10 DW_TAG_variable
	.long	.Ldebug_loc15           # DW_AT_location
	.long	.Linfo_string45         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	267                     # DW_AT_decl_line
	.long	1018                    # DW_AT_type
	.byte	29                      # Abbrev [29] 0x6bf:0x10 DW_TAG_variable
	.long	.Ldebug_loc17           # DW_AT_location
	.long	.Linfo_string47         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.short	268                     # DW_AT_decl_line
	.long	1018                    # DW_AT_type
	.byte	30                      # Abbrev [30] 0x6cf:0x263 DW_TAG_inlined_subroutine
	.long	587                     # DW_AT_abstract_origin
	.long	.Ldebug_ranges0         # DW_AT_ranges
	.byte	2                       # DW_AT_call_file
	.short	272                     # DW_AT_call_line
	.byte	31                      # Abbrev [31] 0x6db:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc3            # DW_AT_location
	.long	595                     # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0x6e4:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc6            # DW_AT_location
	.long	606                     # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0x6ed:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc9            # DW_AT_location
	.long	617                     # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0x6f6:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc11           # DW_AT_location
	.long	628                     # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0x6ff:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc16           # DW_AT_location
	.long	639                     # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0x708:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc18           # DW_AT_location
	.long	650                     # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0x711:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc13           # DW_AT_location
	.long	661                     # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x71a:0x9 DW_TAG_variable
	.long	.Ldebug_loc1            # DW_AT_location
	.long	672                     # DW_AT_abstract_origin
	.byte	33                      # Abbrev [33] 0x723:0x5 DW_TAG_variable
	.long	683                     # DW_AT_abstract_origin
	.byte	33                      # Abbrev [33] 0x728:0x5 DW_TAG_variable
	.long	694                     # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x72d:0x9 DW_TAG_variable
	.long	.Ldebug_loc19           # DW_AT_location
	.long	705                     # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x736:0x9 DW_TAG_variable
	.long	.Ldebug_loc21           # DW_AT_location
	.long	716                     # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x73f:0x9 DW_TAG_variable
	.long	.Ldebug_loc26           # DW_AT_location
	.long	727                     # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x748:0x9 DW_TAG_variable
	.long	.Ldebug_loc28           # DW_AT_location
	.long	738                     # DW_AT_abstract_origin
	.byte	34                      # Abbrev [34] 0x751:0x21 DW_TAG_inlined_subroutine
	.long	1112                    # DW_AT_abstract_origin
	.long	.Ldebug_ranges1         # DW_AT_ranges
	.byte	2                       # DW_AT_call_file
	.byte	134                     # DW_AT_call_line
	.byte	1                       # DW_AT_GNU_discriminator
	.byte	35                      # Abbrev [35] 0x75d:0x14 DW_TAG_lexical_block
	.quad	.Ltmp32                 # DW_AT_low_pc
	.long	.Ltmp33-.Ltmp32         # DW_AT_high_pc
	.byte	36                      # Abbrev [36] 0x76a:0x6 DW_TAG_variable
	.byte	0                       # DW_AT_const_value
	.long	1125                    # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	28                      # Abbrev [28] 0x772:0xf DW_TAG_lexical_block
	.long	.Ldebug_ranges2         # DW_AT_ranges
	.byte	32                      # Abbrev [32] 0x777:0x9 DW_TAG_variable
	.long	.Ldebug_loc14           # DW_AT_location
	.long	785                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	35                      # Abbrev [35] 0x781:0x7a DW_TAG_lexical_block
	.quad	.Ltmp56                 # DW_AT_low_pc
	.long	.Ltmp78-.Ltmp56         # DW_AT_high_pc
	.byte	32                      # Abbrev [32] 0x78e:0x9 DW_TAG_variable
	.long	.Ldebug_loc20           # DW_AT_location
	.long	798                     # DW_AT_abstract_origin
	.byte	37                      # Abbrev [37] 0x797:0x63 DW_TAG_inlined_subroutine
	.long	1138                    # DW_AT_abstract_origin
	.quad	.Ltmp62                 # DW_AT_low_pc
	.long	.Ltmp74-.Ltmp62         # DW_AT_high_pc
	.byte	2                       # DW_AT_call_file
	.byte	158                     # DW_AT_call_line
	.byte	31                      # Abbrev [31] 0x7aa:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc23           # DW_AT_location
	.long	1146                    # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0x7b3:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc7            # DW_AT_location
	.long	1157                    # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0x7bc:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc22           # DW_AT_location
	.long	1168                    # DW_AT_abstract_origin
	.byte	35                      # Abbrev [35] 0x7c5:0x34 DW_TAG_lexical_block
	.quad	.Ltmp62                 # DW_AT_low_pc
	.long	.Ltmp74-.Ltmp62         # DW_AT_high_pc
	.byte	36                      # Abbrev [36] 0x7d2:0x6 DW_TAG_variable
	.byte	0                       # DW_AT_const_value
	.long	1180                    # DW_AT_abstract_origin
	.byte	35                      # Abbrev [35] 0x7d8:0x20 DW_TAG_lexical_block
	.quad	.Ltmp62                 # DW_AT_low_pc
	.long	.Ltmp73-.Ltmp62         # DW_AT_high_pc
	.byte	32                      # Abbrev [32] 0x7e5:0x9 DW_TAG_variable
	.long	.Ldebug_loc24           # DW_AT_location
	.long	1192                    # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x7ee:0x9 DW_TAG_variable
	.long	.Ldebug_loc25           # DW_AT_location
	.long	1203                    # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	37                      # Abbrev [37] 0x7fb:0x1d DW_TAG_inlined_subroutine
	.long	1228                    # DW_AT_abstract_origin
	.quad	.Ltmp85                 # DW_AT_low_pc
	.long	.Ltmp86-.Ltmp85         # DW_AT_high_pc
	.byte	2                       # DW_AT_call_file
	.byte	176                     # DW_AT_call_line
	.byte	32                      # Abbrev [32] 0x80e:0x9 DW_TAG_variable
	.long	.Ldebug_loc27           # DW_AT_location
	.long	1273                    # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	37                      # Abbrev [37] 0x818:0x53 DW_TAG_inlined_subroutine
	.long	1527                    # DW_AT_abstract_origin
	.quad	.Ltmp92                 # DW_AT_low_pc
	.long	.Ltmp97-.Ltmp92         # DW_AT_high_pc
	.byte	2                       # DW_AT_call_file
	.byte	182                     # DW_AT_call_line
	.byte	31                      # Abbrev [31] 0x82b:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc30           # DW_AT_location
	.long	1535                    # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0x834:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc29           # DW_AT_location
	.long	1546                    # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x83d:0x9 DW_TAG_variable
	.long	.Ldebug_loc32           # DW_AT_location
	.long	1557                    # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x846:0x9 DW_TAG_variable
	.long	.Ldebug_loc33           # DW_AT_location
	.long	1568                    # DW_AT_abstract_origin
	.byte	34                      # Abbrev [34] 0x84f:0x1b DW_TAG_inlined_subroutine
	.long	1470                    # DW_AT_abstract_origin
	.long	.Ldebug_ranges3         # DW_AT_ranges
	.byte	7                       # DW_AT_call_file
	.byte	78                      # DW_AT_call_line
	.byte	1                       # DW_AT_GNU_discriminator
	.byte	31                      # Abbrev [31] 0x85b:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc31           # DW_AT_location
	.long	1482                    # DW_AT_abstract_origin
	.byte	33                      # Abbrev [33] 0x864:0x5 DW_TAG_variable
	.long	1493                    # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	28                      # Abbrev [28] 0x86b:0xc6 DW_TAG_lexical_block
	.long	.Ldebug_ranges13        # DW_AT_ranges
	.byte	32                      # Abbrev [32] 0x870:0x9 DW_TAG_variable
	.long	.Ldebug_loc4            # DW_AT_location
	.long	811                     # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x879:0x9 DW_TAG_variable
	.long	.Ldebug_loc36           # DW_AT_location
	.long	822                     # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x882:0x9 DW_TAG_variable
	.long	.Ldebug_loc37           # DW_AT_location
	.long	833                     # DW_AT_abstract_origin
	.byte	28                      # Abbrev [28] 0x88b:0xf DW_TAG_lexical_block
	.long	.Ldebug_ranges4         # DW_AT_ranges
	.byte	32                      # Abbrev [32] 0x890:0x9 DW_TAG_variable
	.long	.Ldebug_loc34           # DW_AT_location
	.long	856                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	28                      # Abbrev [28] 0x89a:0x8a DW_TAG_lexical_block
	.long	.Ldebug_ranges11        # DW_AT_ranges
	.byte	32                      # Abbrev [32] 0x89f:0x9 DW_TAG_variable
	.long	.Ldebug_loc35           # DW_AT_location
	.long	869                     # DW_AT_abstract_origin
	.byte	28                      # Abbrev [28] 0x8a8:0x7b DW_TAG_lexical_block
	.long	.Ldebug_ranges10        # DW_AT_ranges
	.byte	32                      # Abbrev [32] 0x8ad:0x9 DW_TAG_variable
	.long	.Ldebug_loc40           # DW_AT_location
	.long	881                     # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x8b6:0x9 DW_TAG_variable
	.long	.Ldebug_loc42           # DW_AT_location
	.long	892                     # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x8bf:0x9 DW_TAG_variable
	.long	.Ldebug_loc43           # DW_AT_location
	.long	903                     # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x8c8:0x9 DW_TAG_variable
	.long	.Ldebug_loc44           # DW_AT_location
	.long	914                     # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0x8d1:0x9 DW_TAG_variable
	.long	.Ldebug_loc45           # DW_AT_location
	.long	925                     # DW_AT_abstract_origin
	.byte	28                      # Abbrev [28] 0x8da:0x2d DW_TAG_lexical_block
	.long	.Ldebug_ranges7         # DW_AT_ranges
	.byte	32                      # Abbrev [32] 0x8df:0x9 DW_TAG_variable
	.long	.Ldebug_loc41           # DW_AT_location
	.long	937                     # DW_AT_abstract_origin
	.byte	28                      # Abbrev [28] 0x8e8:0x1e DW_TAG_lexical_block
	.long	.Ldebug_ranges6         # DW_AT_ranges
	.byte	32                      # Abbrev [32] 0x8ed:0x9 DW_TAG_variable
	.long	.Ldebug_loc38           # DW_AT_location
	.long	949                     # DW_AT_abstract_origin
	.byte	28                      # Abbrev [28] 0x8f6:0xf DW_TAG_lexical_block
	.long	.Ldebug_ranges5         # DW_AT_ranges
	.byte	32                      # Abbrev [32] 0x8fb:0x9 DW_TAG_variable
	.long	.Ldebug_loc39           # DW_AT_location
	.long	961                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	28                      # Abbrev [28] 0x907:0x1b DW_TAG_lexical_block
	.long	.Ldebug_ranges9         # DW_AT_ranges
	.byte	36                      # Abbrev [36] 0x90c:0x6 DW_TAG_variable
	.byte	0                       # DW_AT_const_value
	.long	976                     # DW_AT_abstract_origin
	.byte	28                      # Abbrev [28] 0x912:0xf DW_TAG_lexical_block
	.long	.Ldebug_ranges8         # DW_AT_ranges
	.byte	32                      # Abbrev [32] 0x917:0x9 DW_TAG_variable
	.long	.Ldebug_loc46           # DW_AT_location
	.long	988                     # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	28                      # Abbrev [28] 0x924:0xc DW_TAG_lexical_block
	.long	.Ldebug_ranges12        # DW_AT_ranges
	.byte	36                      # Abbrev [36] 0x929:0x6 DW_TAG_variable
	.byte	0                       # DW_AT_const_value
	.long	1004                    # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	38                      # Abbrev [38] 0x935:0x56 DW_TAG_subprogram
	.long	.Linfo_string109        # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	264                     # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	582                     # DW_AT_type
                                        # DW_AT_APPLE_optimized
	.byte	1                       # DW_AT_inline
	.byte	39                      # Abbrev [39] 0x942:0xc DW_TAG_formal_parameter
	.long	.Linfo_string110        # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	265                     # DW_AT_decl_line
	.long	2443                    # DW_AT_type
	.byte	39                      # Abbrev [39] 0x94e:0xc DW_TAG_formal_parameter
	.long	.Linfo_string89         # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	265                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	39                      # Abbrev [39] 0x95a:0xc DW_TAG_formal_parameter
	.long	.Linfo_string112        # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	265                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	39                      # Abbrev [39] 0x966:0xc DW_TAG_formal_parameter
	.long	.Linfo_string113        # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	265                     # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	40                      # Abbrev [40] 0x972:0xc DW_TAG_variable
	.long	.Linfo_string114        # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	271                     # DW_AT_decl_line
	.long	2443                    # DW_AT_type
	.byte	40                      # Abbrev [40] 0x97e:0xc DW_TAG_variable
	.long	.Linfo_string115        # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.short	275                     # DW_AT_decl_line
	.long	2443                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	7                       # Abbrev [7] 0x98b:0x5 DW_TAG_pointer_type
	.long	2448                    # DW_AT_type
	.byte	4                       # Abbrev [4] 0x990:0xb DW_TAG_typedef
	.long	2459                    # DW_AT_type
	.long	.Linfo_string111        # DW_AT_name
	.byte	9                       # DW_AT_decl_file
	.byte	42                      # DW_AT_decl_line
	.byte	41                      # Abbrev [41] 0x99b:0xc DW_TAG_array_type
                                        # DW_AT_GNU_vector
	.long	334                     # DW_AT_type
	.byte	11                      # Abbrev [11] 0x9a0:0x6 DW_TAG_subrange_type
	.long	303                     # DW_AT_type
	.byte	8                       # DW_AT_count
	.byte	0                       # End Of Children Mark
	.byte	42                      # Abbrev [42] 0x9a7:0x136 DW_TAG_subprogram
	.quad	.Lfunc_begin1           # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1 # DW_AT_high_pc
                                        # DW_AT_APPLE_omit_frame_ptr
	.byte	1                       # DW_AT_frame_base
	.byte	87
	.long	.Linfo_string117        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	12                      # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_APPLE_optimized
	.byte	43                      # Abbrev [43] 0x9bc:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc48           # DW_AT_location
	.long	.Linfo_string119        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	13                      # DW_AT_decl_line
	.long	1387                    # DW_AT_type
	.byte	43                      # Abbrev [43] 0x9cb:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc49           # DW_AT_location
	.long	.Linfo_string94         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	14                      # DW_AT_decl_line
	.long	1408                    # DW_AT_type
	.byte	43                      # Abbrev [43] 0x9da:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc47           # DW_AT_location
	.long	.Linfo_string95         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	15                      # DW_AT_decl_line
	.long	1414                    # DW_AT_type
	.byte	44                      # Abbrev [44] 0x9e9:0xf DW_TAG_variable
	.long	.Ldebug_loc50           # DW_AT_location
	.long	.Linfo_string120        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	17                      # DW_AT_decl_line
	.long	2816                    # DW_AT_type
	.byte	19                      # Abbrev [19] 0x9f8:0xb DW_TAG_variable
	.long	.Linfo_string17         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	18                      # DW_AT_decl_line
	.long	562                     # DW_AT_type
	.byte	35                      # Abbrev [35] 0xa03:0xd9 DW_TAG_lexical_block
	.quad	.Ltmp230                # DW_AT_low_pc
	.long	.Ltmp248-.Ltmp230       # DW_AT_high_pc
	.byte	19                      # Abbrev [19] 0xa10:0xb DW_TAG_variable
	.long	.Linfo_string110        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	23                      # DW_AT_decl_line
	.long	2443                    # DW_AT_type
	.byte	19                      # Abbrev [19] 0xa1b:0xb DW_TAG_variable
	.long	.Linfo_string122        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	24                      # DW_AT_decl_line
	.long	54                      # DW_AT_type
	.byte	19                      # Abbrev [19] 0xa26:0xb DW_TAG_variable
	.long	.Linfo_string41         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	25                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	19                      # Abbrev [19] 0xa31:0xb DW_TAG_variable
	.long	.Linfo_string90         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	26                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	35                      # Abbrev [35] 0xa3c:0x9f DW_TAG_lexical_block
	.quad	.Ltmp230                # DW_AT_low_pc
	.long	.Ltmp248-.Ltmp230       # DW_AT_high_pc
	.byte	44                      # Abbrev [44] 0xa49:0xf DW_TAG_variable
	.long	.Ldebug_loc55           # DW_AT_location
	.long	.Linfo_string126        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	28                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	35                      # Abbrev [35] 0xa58:0x82 DW_TAG_lexical_block
	.quad	.Ltmp231                # DW_AT_low_pc
	.long	.Ltmp246-.Ltmp231       # DW_AT_high_pc
	.byte	19                      # Abbrev [19] 0xa65:0xb DW_TAG_variable
	.long	.Linfo_string127        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	29                      # DW_AT_decl_line
	.long	572                     # DW_AT_type
	.byte	28                      # Abbrev [28] 0xa70:0x69 DW_TAG_lexical_block
	.long	.Ldebug_ranges18        # DW_AT_ranges
	.byte	44                      # Abbrev [44] 0xa75:0xf DW_TAG_variable
	.long	.Ldebug_loc51           # DW_AT_location
	.long	.Linfo_string78         # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	31                      # DW_AT_decl_line
	.long	59                      # DW_AT_type
	.byte	28                      # Abbrev [28] 0xa84:0x54 DW_TAG_lexical_block
	.long	.Ldebug_ranges17        # DW_AT_ranges
	.byte	19                      # Abbrev [19] 0xa89:0xb DW_TAG_variable
	.long	.Linfo_string128        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	32                      # DW_AT_decl_line
	.long	582                     # DW_AT_type
	.byte	34                      # Abbrev [34] 0xa94:0x43 DW_TAG_inlined_subroutine
	.long	2357                    # DW_AT_abstract_origin
	.long	.Ldebug_ranges16        # DW_AT_ranges
	.byte	2                       # DW_AT_call_file
	.byte	32                      # DW_AT_call_line
	.byte	1                       # DW_AT_GNU_discriminator
	.byte	31                      # Abbrev [31] 0xaa0:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc58           # DW_AT_location
	.long	2370                    # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0xaa9:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc57           # DW_AT_location
	.long	2382                    # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0xab2:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc56           # DW_AT_location
	.long	2394                    # DW_AT_abstract_origin
	.byte	31                      # Abbrev [31] 0xabb:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc53           # DW_AT_location
	.long	2406                    # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0xac4:0x9 DW_TAG_variable
	.long	.Ldebug_loc52           # DW_AT_location
	.long	2418                    # DW_AT_abstract_origin
	.byte	32                      # Abbrev [32] 0xacd:0x9 DW_TAG_variable
	.long	.Ldebug_loc54           # DW_AT_location
	.long	2430                    # DW_AT_abstract_origin
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.byte	42                      # Abbrev [42] 0xadd:0x23 DW_TAG_subprogram
	.quad	.Lfunc_begin2           # DW_AT_low_pc
	.long	.Lfunc_end2-.Lfunc_begin2 # DW_AT_high_pc
                                        # DW_AT_APPLE_omit_frame_ptr
	.byte	1                       # DW_AT_frame_base
	.byte	87
	.long	.Linfo_string118        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	40                      # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_APPLE_optimized
	.byte	45                      # Abbrev [45] 0xaf2:0xd DW_TAG_formal_parameter
	.byte	1                       # DW_AT_location
	.byte	85
	.long	.Linfo_string129        # DW_AT_name
	.byte	2                       # DW_AT_decl_file
	.byte	40                      # DW_AT_decl_line
	.long	1094                    # DW_AT_type
	.byte	0                       # End Of Children Mark
	.byte	4                       # Abbrev [4] 0xb00:0xb DW_TAG_typedef
	.long	2827                    # DW_AT_type
	.long	.Linfo_string125        # DW_AT_name
	.byte	8                       # DW_AT_decl_file
	.byte	192                     # DW_AT_decl_line
	.byte	15                      # Abbrev [15] 0xb0b:0x39 DW_TAG_structure_type
	.long	.Linfo_string124        # DW_AT_name
	.byte	40                      # DW_AT_byte_size
	.byte	8                       # DW_AT_decl_file
	.byte	187                     # DW_AT_decl_line
	.byte	16                      # Abbrev [16] 0xb13:0xc DW_TAG_member
	.long	.Linfo_string121        # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	188                     # DW_AT_decl_line
	.byte	0                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0xb1f:0xc DW_TAG_member
	.long	.Linfo_string122        # DW_AT_name
	.long	59                      # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	189                     # DW_AT_decl_line
	.byte	8                       # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0xb2b:0xc DW_TAG_member
	.long	.Linfo_string95         # DW_AT_name
	.long	1414                    # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	190                     # DW_AT_decl_line
	.byte	16                      # DW_AT_data_member_location
	.byte	16                      # Abbrev [16] 0xb37:0xc DW_TAG_member
	.long	.Linfo_string123        # DW_AT_name
	.long	2443                    # DW_AT_type
	.byte	8                       # DW_AT_decl_file
	.byte	191                     # DW_AT_decl_line
	.byte	32                      # DW_AT_data_member_location
	.byte	0                       # End Of Children Mark
	.byte	0                       # End Of Children Mark
	.section	.debug_ranges,"",@progbits
.Ldebug_range:
.Ldebug_ranges0:
	.quad	.Ltmp14-.Lfunc_begin0
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp22-.Lfunc_begin0
	.quad	.Ltmp49-.Lfunc_begin0
	.quad	.Ltmp51-.Lfunc_begin0
	.quad	.Ltmp80-.Lfunc_begin0
	.quad	.Ltmp81-.Lfunc_begin0
	.quad	.Ltmp110-.Lfunc_begin0
	.quad	.Ltmp111-.Lfunc_begin0
	.quad	.Ltmp118-.Lfunc_begin0
	.quad	.Ltmp119-.Lfunc_begin0
	.quad	.Ltmp124-.Lfunc_begin0
	.quad	.Ltmp125-.Lfunc_begin0
	.quad	.Ltmp129-.Lfunc_begin0
	.quad	.Ltmp130-.Lfunc_begin0
	.quad	.Ltmp131-.Lfunc_begin0
	.quad	.Ltmp132-.Lfunc_begin0
	.quad	.Ltmp169-.Lfunc_begin0
	.quad	.Ltmp170-.Lfunc_begin0
	.quad	.Ltmp181-.Lfunc_begin0
	.quad	.Ltmp182-.Lfunc_begin0
	.quad	.Ltmp188-.Lfunc_begin0
	.quad	.Ltmp189-.Lfunc_begin0
	.quad	.Ltmp192-.Lfunc_begin0
	.quad	.Ltmp196-.Lfunc_begin0
	.quad	.Ltmp208-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges1:
	.quad	.Ltmp28-.Lfunc_begin0
	.quad	.Ltmp31-.Lfunc_begin0
	.quad	.Ltmp32-.Lfunc_begin0
	.quad	.Ltmp34-.Lfunc_begin0
	.quad	.Ltmp42-.Lfunc_begin0
	.quad	.Ltmp43-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges2:
	.quad	.Ltmp34-.Lfunc_begin0
	.quad	.Ltmp42-.Lfunc_begin0
	.quad	.Ltmp43-.Lfunc_begin0
	.quad	.Ltmp46-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges3:
	.quad	.Ltmp92-.Lfunc_begin0
	.quad	.Ltmp93-.Lfunc_begin0
	.quad	.Ltmp94-.Lfunc_begin0
	.quad	.Ltmp95-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges4:
	.quad	.Ltmp100-.Lfunc_begin0
	.quad	.Ltmp101-.Lfunc_begin0
	.quad	.Ltmp103-.Lfunc_begin0
	.quad	.Ltmp108-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges5:
	.quad	.Ltmp117-.Lfunc_begin0
	.quad	.Ltmp118-.Lfunc_begin0
	.quad	.Ltmp123-.Lfunc_begin0
	.quad	.Ltmp124-.Lfunc_begin0
	.quad	.Ltmp128-.Lfunc_begin0
	.quad	.Ltmp129-.Lfunc_begin0
	.quad	.Ltmp135-.Lfunc_begin0
	.quad	.Ltmp139-.Lfunc_begin0
	.quad	.Ltmp143-.Lfunc_begin0
	.quad	.Ltmp147-.Lfunc_begin0
	.quad	.Ltmp149-.Lfunc_begin0
	.quad	.Ltmp150-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges6:
	.quad	.Ltmp113-.Lfunc_begin0
	.quad	.Ltmp118-.Lfunc_begin0
	.quad	.Ltmp119-.Lfunc_begin0
	.quad	.Ltmp124-.Lfunc_begin0
	.quad	.Ltmp125-.Lfunc_begin0
	.quad	.Ltmp129-.Lfunc_begin0
	.quad	.Ltmp130-.Lfunc_begin0
	.quad	.Ltmp131-.Lfunc_begin0
	.quad	.Ltmp132-.Lfunc_begin0
	.quad	.Ltmp139-.Lfunc_begin0
	.quad	.Ltmp140-.Lfunc_begin0
	.quad	.Ltmp150-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges7:
	.quad	.Ltmp111-.Lfunc_begin0
	.quad	.Ltmp118-.Lfunc_begin0
	.quad	.Ltmp119-.Lfunc_begin0
	.quad	.Ltmp124-.Lfunc_begin0
	.quad	.Ltmp125-.Lfunc_begin0
	.quad	.Ltmp129-.Lfunc_begin0
	.quad	.Ltmp130-.Lfunc_begin0
	.quad	.Ltmp131-.Lfunc_begin0
	.quad	.Ltmp132-.Lfunc_begin0
	.quad	.Ltmp151-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges8:
	.quad	.Ltmp161-.Lfunc_begin0
	.quad	.Ltmp169-.Lfunc_begin0
	.quad	.Ltmp170-.Lfunc_begin0
	.quad	.Ltmp177-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges9:
	.quad	.Ltmp161-.Lfunc_begin0
	.quad	.Ltmp169-.Lfunc_begin0
	.quad	.Ltmp170-.Lfunc_begin0
	.quad	.Ltmp178-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges10:
	.quad	.Ltmp111-.Lfunc_begin0
	.quad	.Ltmp118-.Lfunc_begin0
	.quad	.Ltmp119-.Lfunc_begin0
	.quad	.Ltmp124-.Lfunc_begin0
	.quad	.Ltmp125-.Lfunc_begin0
	.quad	.Ltmp129-.Lfunc_begin0
	.quad	.Ltmp130-.Lfunc_begin0
	.quad	.Ltmp131-.Lfunc_begin0
	.quad	.Ltmp132-.Lfunc_begin0
	.quad	.Ltmp169-.Lfunc_begin0
	.quad	.Ltmp170-.Lfunc_begin0
	.quad	.Ltmp179-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges11:
	.quad	.Ltmp111-.Lfunc_begin0
	.quad	.Ltmp118-.Lfunc_begin0
	.quad	.Ltmp119-.Lfunc_begin0
	.quad	.Ltmp124-.Lfunc_begin0
	.quad	.Ltmp125-.Lfunc_begin0
	.quad	.Ltmp129-.Lfunc_begin0
	.quad	.Ltmp130-.Lfunc_begin0
	.quad	.Ltmp131-.Lfunc_begin0
	.quad	.Ltmp132-.Lfunc_begin0
	.quad	.Ltmp169-.Lfunc_begin0
	.quad	.Ltmp170-.Lfunc_begin0
	.quad	.Ltmp180-.Lfunc_begin0
	.quad	.Ltmp182-.Lfunc_begin0
	.quad	.Ltmp183-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges12:
	.quad	.Ltmp187-.Lfunc_begin0
	.quad	.Ltmp188-.Lfunc_begin0
	.quad	.Ltmp196-.Lfunc_begin0
	.quad	.Ltmp199-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges13:
	.quad	.Ltmp99-.Lfunc_begin0
	.quad	.Ltmp110-.Lfunc_begin0
	.quad	.Ltmp111-.Lfunc_begin0
	.quad	.Ltmp118-.Lfunc_begin0
	.quad	.Ltmp119-.Lfunc_begin0
	.quad	.Ltmp124-.Lfunc_begin0
	.quad	.Ltmp125-.Lfunc_begin0
	.quad	.Ltmp129-.Lfunc_begin0
	.quad	.Ltmp130-.Lfunc_begin0
	.quad	.Ltmp131-.Lfunc_begin0
	.quad	.Ltmp132-.Lfunc_begin0
	.quad	.Ltmp169-.Lfunc_begin0
	.quad	.Ltmp170-.Lfunc_begin0
	.quad	.Ltmp181-.Lfunc_begin0
	.quad	.Ltmp182-.Lfunc_begin0
	.quad	.Ltmp188-.Lfunc_begin0
	.quad	.Ltmp196-.Lfunc_begin0
	.quad	.Ltmp200-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges14:
	.quad	.Ltmp14-.Lfunc_begin0
	.quad	.Ltmp192-.Lfunc_begin0
	.quad	.Ltmp196-.Lfunc_begin0
	.quad	.Ltmp208-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges15:
	.quad	.Ltmp14-.Lfunc_begin0
	.quad	.Ltmp194-.Lfunc_begin0
	.quad	.Ltmp196-.Lfunc_begin0
	.quad	.Ltmp208-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges16:
	.quad	.Ltmp231-.Lfunc_begin0
	.quad	.Ltmp232-.Lfunc_begin0
	.quad	.Ltmp234-.Lfunc_begin0
	.quad	.Ltmp235-.Lfunc_begin0
	.quad	.Ltmp238-.Lfunc_begin0
	.quad	.Ltmp241-.Lfunc_begin0
	.quad	.Ltmp243-.Lfunc_begin0
	.quad	.Ltmp244-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges17:
	.quad	.Ltmp231-.Lfunc_begin0
	.quad	.Ltmp232-.Lfunc_begin0
	.quad	.Ltmp234-.Lfunc_begin0
	.quad	.Ltmp242-.Lfunc_begin0
	.quad	.Ltmp243-.Lfunc_begin0
	.quad	.Ltmp245-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges18:
	.quad	.Ltmp231-.Lfunc_begin0
	.quad	.Ltmp232-.Lfunc_begin0
	.quad	.Ltmp234-.Lfunc_begin0
	.quad	.Ltmp246-.Lfunc_begin0
	.quad	0
	.quad	0
	.section	.debug_macinfo,"",@progbits
	.byte	0                       # End Of Macro List Mark
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end0-.LpubNames_begin0 # Length of Public Names Info
.LpubNames_begin0:
	.short	2                       # DWARF Version
	.long	.Lcu_begin0             # Offset of Compilation Unit Info
	.long	2885                    # Compilation Unit Length
	.long	225                     # DIE offset
	.asciz	"input_pointers"        # External Name
	.long	102                     # DIE offset
	.asciz	"min_bin_count"         # External Name
	.long	116                     # DIE offset
	.asciz	"max_bin_count"         # External Name
	.long	189                     # DIE offset
	.asciz	"generator"             # External Name
	.long	1138                    # DIE offset
	.asciz	"random_fill"           # External Name
	.long	398                     # DIE offset
	.asciz	"input_data"            # External Name
	.long	1527                    # DIE offset
	.asciz	"print_timer_elapsed"   # External Name
	.long	1228                    # DIE offset
	.asciz	"u16_input"             # External Name
	.long	130                     # DIE offset
	.asciz	"max_offset"            # External Name
	.long	246                     # DIE offset
	.asciz	"sorted"                # External Name
	.long	2781                    # DIE offset
	.asciz	"no_op"                 # External Name
	.long	346                     # DIE offset
	.asciz	"numbers"               # External Name
	.long	2471                    # DIE offset
	.asciz	"u16_input_loop"        # External Name
	.long	434                     # DIE offset
	.asciz	"timer_begin"           # External Name
	.long	1580                    # DIE offset
	.asciz	"main"                  # External Name
	.long	42                      # DIE offset
	.asciz	"test_count"            # External Name
	.long	1112                    # DIE offset
	.asciz	"get_shuffled_array_counts" # External Name
	.long	77                      # DIE offset
	.asciz	"min_array_count"       # External Name
	.long	89                      # DIE offset
	.asciz	"max_array_count"       # External Name
	.long	587                     # DIE offset
	.asciz	"test_median"           # External Name
	.long	310                     # DIE offset
	.asciz	"max_threads"           # External Name
	.long	367                     # DIE offset
	.asciz	"init"                  # External Name
	.long	2357                    # DIE offset
	.asciz	"mediocre_chunk_ptr"    # External Name
	.long	142                     # DIE offset
	.asciz	"min_max_iter"          # External Name
	.long	1470                    # DIE offset
	.asciz	"ms_elapsed"            # External Name
	.long	177                     # DIE offset
	.asciz	"max_max_iter"          # External Name
	.long	0                       # End Mark
.LpubNames_end0:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end0-.LpubTypes_begin0 # Length of Public Types Info
.LpubTypes_begin0:
	.short	2                       # DWARF Version
	.long	.Lcu_begin0             # Offset of Compilation Unit Info
	.long	2885                    # Compilation Unit Length
	.long	512                     # DIE offset
	.asciz	"time_t"                # External Name
	.long	170                     # DIE offset
	.asciz	"unsigned int"          # External Name
	.long	391                     # DIE offset
	.asciz	"_Bool"                 # External Name
	.long	548                     # DIE offset
	.asciz	"int"                   # External Name
	.long	1425                    # DIE offset
	.asciz	"mediocre_dimension"    # External Name
	.long	59                      # DIE offset
	.asciz	"size_t"                # External Name
	.long	1414                    # DIE offset
	.asciz	"MediocreDimension"     # External Name
	.long	455                     # DIE offset
	.asciz	"timeb"                 # External Name
	.long	1296                    # DIE offset
	.asciz	"mediocre_input"        # External Name
	.long	1285                    # DIE offset
	.asciz	"MediocreInput"         # External Name
	.long	70                      # DIE offset
	.asciz	"long unsigned int"     # External Name
	.long	285                     # DIE offset
	.asciz	"uint16_t"              # External Name
	.long	159                     # DIE offset
	.asciz	"uint32_t"              # External Name
	.long	534                     # DIE offset
	.asciz	"long int"              # External Name
	.long	2816                    # DIE offset
	.asciz	"MediocreInputCommand"  # External Name
	.long	1018                    # DIE offset
	.asciz	"double"                # External Name
	.long	523                     # DIE offset
	.asciz	"__time_t"              # External Name
	.long	1025                    # DIE offset
	.asciz	"CanaryPage"            # External Name
	.long	555                     # DIE offset
	.asciz	"long long unsigned int" # External Name
	.long	2448                    # DIE offset
	.asciz	"__m256"                # External Name
	.long	296                     # DIE offset
	.asciz	"unsigned short"        # External Name
	.long	541                     # DIE offset
	.asciz	"short"                 # External Name
	.long	2827                    # DIE offset
	.asciz	"mediocre_input_command" # External Name
	.long	334                     # DIE offset
	.asciz	"float"                 # External Name
	.long	1392                    # DIE offset
	.asciz	"MediocreInputControl"  # External Name
	.long	1100                    # DIE offset
	.asciz	"unsigned char"         # External Name
	.long	0                       # End Mark
.LpubTypes_end0:

	.ident	"clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)"
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
