;SECTION_000:

;Note: All following code belongs to the System class. Most routines either belong to the Main or NMI subclass. All 
;explanations do not include System.NMI or System.Main in the routine/variable names.

;The following are multiplication routines. They simply take Math.A and multiply it by Math.B, storing the result
;in Math.Answer. Math.A0 represents the low 8 bits of Math.A, Math.A1 represents the 8 bits above that, etc. So
;if one wants to make Math.A equal $FE20, they make Math.A1 $FE, and Math.A0 $20. Math.B and Math.Answer work the same way.
;Math.A and Math.B are 32 bits wide, but for multiplication Math.A can only be 24 bits wide, but Math.B can most of the time
;be 32 bits. The reason for this is because Math.Answer is 48 bits wide. The sum of the bitwidths of Math.A and Math.B is ;equal to the bitwidth of the answer. So these sums can never exceed 48. If Math.A is 4 bits wide, then Math.B can be 32 bits ;wide because 32+4 is less than 48. However, once Math.A is bigger than 16 bits, the possible width of B declines. So if ;Math.A is 18 bits, Math.B can only be 30 bits wide, since it's the very limit before it starts exceeding 48. So if Math.A ;is greater than 16 bits, Math.B max bitwidth = 48 - Math.A Bitwidth. 

;The following routines are designed so that anyone can multiply any two numbers and take the least amount of time.
;However, there are some guidelines to using them. First of all, the routine names are designed in the following manner:
;Multiply.MathABitWidth.MathBBitWidth. Secondly, since these routines are designed to take the least amount of CPU
;cycles, Math.A can never be greater bitwidth than Math B. Math A bitwidth must always be of lesser or equal value to Math.B.
;Since this is the case, Multiply.8.5 is not a real routine. If one needs to multiply an 8 bit by 5 bit number,
;They must make Math.A the 5 bit value. Multiply.5.8 is a real routine, and would be the one to use. Lastly,
;One must load X with the bit width of Math.A before going to one of the multiplication routines. An example would be:
;lda #$83
;sta Math.B0
;lda #$01
;sta Math.B1
;lda #$23
;sta Math.A0
;ldx #6
;jsr Multiply.6.9
;Know that only specified bits of Math.A are used in the routine. In the above example, the low 6 bits are acknowledged
;and the rest are ignored. However, for Math.B, all bits to the next multiple of 8 are processed. So if one makes
;Math.A $FFFF, specifying the bitwidth as 9, Math.A will be seen as $1FFF. If one makes Math.B $FFFF and jumps to
;Multiply.6.9, all 16 bits of Math.B are processed. It will not be seen as $1FFF, but $FFFF. To prevent this, make sure
;that each used BYTE of Math.B has unused bits cleared.


Standard.Main.Multiply.1.7:		;23 to 33 cycles
Standard.Main.Multiply.1.6:		;23 to 33 cycles
Standard.Main.Multiply.1.5:		;23 to 33 cycles
Standard.Main.Multiply.1.4:		;23 to 33 cycles
Standard.Main.Multiply.1.3:		;23 to 33 cycles
Standard.Main.Multiply.1.2:		;23 to 33 cycles
Standard.Main.Multiply.1.1:		;23 to 33 cycles
Standard.Main.Multiply.2.6:		;41 to 61 cycles
Standard.Main.Multiply.2.5:		;41 to 61 cycles
Standard.Main.Multiply.2.4:		;41 to 61 cycles
Standard.Main.Multiply.2.3:		;41 to 61 cycles
Standard.Main.Multiply.2.2:		;41 to 61 cycles
Standard.Main.Multiply.3.5:		;59 to 89 cycles
Standard.Main.Multiply.3.4:		;59 to 89 cycles
Standard.Main.Multiply.3.3:		;59 to 89 cycles
Standard.Main.Multiply.4.4:		;77 to 117 cycles

Standard.Main.Multiply.0.8.0.8
;Math A = 0 to 8 bits
;Math B = 8 - A bits or less (A + B must be greater than 0 and less than 8)
;Answer = 0 to 8 bits
;Example: Math A (3) * Math B (5) = 8 bits


	lda #$00				;2
	sta Standard.Main.Math.Answer0		;5

-
	lsr Standard.Main.Math.A0			;5
	bcc +					;7
	clc					;9
	lda Standard.Main.Math.Answer0		;12
	adc Standard.Main.Math.B0			;15
	sta Standard.Main.Math.Answer0		;18
+
	asl Standard.Main.Math.B0			;13/23
	dex					;15/25
	bne -					;18/28

	rts


Standard.Main.Multiply.1.8:			;36 to 55 cycles
Standard.Main.Multiply.2.8:			;59 to 97 cycles
Standard.Main.Multiply.2.7:			;59 to 97 cycles
Standard.Main.Multiply.3.8:			;82 to 139 cycles
Standard.Main.Multiply.3.7:			;82 to 139 cycles
Standard.Main.Multiply.3.6:			;82 to 139 cycles
Standard.Main.Multiply.4.8:			;105 to 181 cycles
Standard.Main.Multiply.4.7:			;105 to 181 cycles
Standard.Main.Multiply.4.6:			;105 to 181 cycles
Standard.Main.Multiply.4.5:			;105 to 181 cycles
Standard.Main.Multiply.5.8:			;128 to 223 cycles
Standard.Main.Multiply.5.7:			;128 to 223 cycles
Standard.Main.Multiply.5.6:			;128 to 223 cycles
Standard.Main.Multiply.5.5:			;128 to 223 cycles
Standard.Main.Multiply.6.8:			;151 to 265 cycles
Standard.Main.Multiply.6.7:			;151 to 265 cycles
Standard.Main.Multiply.6.6:			;151 to 265 cycles
Standard.Main.Multiply.7.8:			;174 to 307 cycles
Standard.Main.Multiply.7.7:			;174 to 307 cycles
Standard.Main.Multiply.8.8:			;206 to 349 cycles
	lda #$00
	sta Standard.Main.Math.B1

Standard.Main.Multiply.1.15:			;31 to 50 cycles
Standard.Main.Multiply.1.14:			;31 to 50 cycles
Standard.Main.Multiply.1.13:			;31 to 50 cycles
Standard.Main.Multiply.1.12:			;31 to 50 cycles
Standard.Main.Multiply.1.11:			;31 to 50 cycles
Standard.Main.Multiply.1.10:			;31 to 50 cycles
Standard.Main.Multiply.1.9:			;31 to 50 cycles
Standard.Main.Multiply.2.14:			;54 to 92 cycles
Standard.Main.Multiply.2.13:			;54 to 92 cycles
Standard.Main.Multiply.2.12:			;54 to 92 cycles
Standard.Main.Multiply.2.11:			;54 to 92 cycles
Standard.Main.Multiply.2.10:			;54 to 92 cycles
Standard.Main.Multiply.2.9:			;54 to 92 cycles
Standard.Main.Multiply.3.13:			;77 to 134 cycles
Standard.Main.Multiply.3.12:			;77 to 134 cycles
Standard.Main.Multiply.3.11:			;77 to 134 cycles
Standard.Main.Multiply.3.10:			;77 to 134 cycles
Standard.Main.Multiply.3.9:			;77 to 134 cycles
Standard.Main.Multiply.4.12:			;100 to 176 cycles
Standard.Main.Multiply.4.11:			;100 to 176 cycles
Standard.Main.Multiply.4.10:			;100 to 176 cycles
Standard.Main.Multiply.4.9:			;100 to 176 cycles
Standard.Main.Multiply.5.11			;123 to 218 cycles
Standard.Main.Multiply.5.10:			;123 to 218 cycles
Standard.Main.Multiply.5.9:			;123 to 218 cycles
Standard.Main.Multiply.6.10:			;146 to 260 cycles
Standard.Main.Multiply.6.9:			;146 to 260 cycles
Standard.Main.Multiply.7.9:			;169 to 302 cycles

Standard.Main.Multiply.0.8.8.16:
;Math A = 0 to 8 bits
;Math B = 16 - A bits or less (A + B must be greater than 8 and less than 16)
;Answer = 8 to 16 bits
;Example: Math A (7) * Math B (3) = 10 bits

	lda #$00				;2
	sta Standard.Main.Math.Answer0		;5
	sta Standard.Main.Math.Answer1		;8
	
-
	lsr Standard.Main.Math.A0			;5
	bcc +					;7
	clc					;9
	lda Standard.Main.Math.Answer0		;12
	adc Standard.Main.Math.B0			;15
	sta Standard.Main.Math.Answer0		;18
	lda Standard.Main.Math.Answer1		;21
	adc Standard.Main.Math.B1			;24
	sta Standard.Main.Math.Answer1		;27
+
	asl Standard.Main.Math.B0			;13/32
	rol Standard.Main.Math.B1			;18/37
	dex					;20/39
	bne -					;23/42
	rts


Standard.Main.Multiply.1.16:			;44 to 72 cycles
Standard.Main.Multiply.2.16:			;82 to 128 cycles
Standard.Main.Multiply.2.15:			;82 to 128 cycles
Standard.Main.Multiply.3.16:			;100 to 184 cycles
Standard.Main.Multiply.3.15:			;100 to 184 cycles
Standard.Main.Multiply.3.14:			;100 to 184 cycles
Standard.Main.Multiply.4.16:			;128 to 240 cycles
Standard.Main.Multiply.4.15:			;128 to 240 cycles
Standard.Main.Multiply.4.14:			;128 to 240 cycles
Standard.Main.Multiply.4.13:			;128 to 240 cycles
Standard.Main.Multiply.5.16:			;156 to 296 cycles
Standard.Main.Multiply.5.15:			;156 to 296 cycles
Standard.Main.Multiply.5.14:			;156 to 296 cycles
Standard.Main.Multiply.5.13:			;156 to 296 cycles
Standard.Main.Multiply.5.12:			;156 to 296 cycles
Standard.Main.Multiply.6.16:			;184 to 352 cycles
Standard.Main.Multiply.6.15:			;184 to 352 cycles
Standard.Main.Multiply.6.14:			;184 to 352 cycles
Standard.Main.Multiply.6.13:			;184 to 352 cycles
Standard.Main.Multiply.6.12:			;184 to 352 cycles
Standard.Main.Multiply.6.11:			;184 to 352 cycles
Standard.Main.Multiply.7.16:			;212 to 408 cycles
Standard.Main.Multiply.7.15:			;212 to 408 cycles
Standard.Main.Multiply.7.14:			;212 to 408 cycles
Standard.Main.Multiply.7.13:			;212 to 408 cycles
Standard.Main.Multiply.7.12:			;212 to 408 cycles
Standard.Main.Multiply.7.11:			;212 to 408 cycles
Standard.Main.Multiply.7.10:			;212 to 408 cycles
Standard.Main.Multiply.8.16:			;240 to 464 cycles
Standard.Main.Multiply.8.15:			;240 to 464 cycles
Standard.Main.Multiply.8.14:			;240 to 464 cycles
Standard.Main.Multiply.8.11:			;240 to 464 cycles
Standard.Main.Multiply.8.10:			;240 to 464 cycles
Standard.Main.Multiply.8.9:			;240 to 464 cycles
	lda #$00
	sta Standard.Main.Math.B2

Standard.Main.Multiply.1.23:			;39 to 67 cycles
Standard.Main.Multiply.1.22:			;39 to 67 cycles
Standard.Main.Multiply.1.21:			;39 to 67 cycles
Standard.Main.Multiply.1.20:			;39 to 67 cycles
Standard.Main.Multiply.1.19:			;39 to 67 cycles
Standard.Main.Multiply.1.18:			;39 to 67 cycles
Standard.Main.Multiply.1.17:			;39 to 67 cycles
Standard.Main.Multiply.2.22:			;67 to 123 cycles
Standard.Main.Multiply.2.21:			;67 to 123 cycles
Standard.Main.Multiply.2.20:			;67 to 123 cycles
Standard.Main.Multiply.2.19:			;67 to 123 cycles
Standard.Main.Multiply.2.18:			;67 to 123 cycles
Standard.Main.Multiply.2.17:			;67 to 123 cycles
Standard.Main.Multiply.3.21:			;95 to 179 cycles
Standard.Main.Multiply.3.20:			;95 to 179 cycles
Standard.Main.Multiply.3.19:			;95 to 179 cycles
Standard.Main.Multiply.3.18:			;95 to 179 cycles
Standard.Main.Multiply.3.17:			;95 to 179 cycles
Standard.Main.Multiply.4.20:			;123 to 235 cycles
Standard.Main.Multiply.4.19:			;123 to 235 cycles
Standard.Main.Multiply.4.18:			;123 to 235 cycles
Standard.Main.Multiply.4.17:			;123 to 235 cycles
Standard.Main.Multiply.5.19:			;151 to 291 cycles
Standard.Main.Multiply.5.18:			;151 to 291 cycles
Standard.Main.Multiply.5.17:			;151 to 291 cycles
Standard.Main.Multiply.6.18:			;179 to 347 cycles
Standard.Main.Multiply.6.17:			;179 to 347 cycles
Standard.Main.Multiply.7.17:			;207 to 403 cycles

Standard.Main.Multiply.0.8.16.24:
;Math A = 0 to 8 bits
;Math B = 24 - A bits or less (A + B must be greater than 16 and less than 24)
;Math B must be greater than 8 bits
;Answer = 16 to 24 bits
;Example: Math A (6) * Math B (12) = 18 bits

	lda #$00				;2
	sta Standard.Main.Math.Answer0		;5
	sta Standard.Main.Math.Answer1		;8
	sta Standard.Main.Math.Answer2		;11
	
-
	lsr Standard.Main.Math.A0			;5
	bcc +					;7
	clc					;9
	lda Standard.Main.Math.Answer0		;12
	adc Standard.Main.Math.B0			;15
	sta Standard.Main.Math.Answer0		;18
	lda Standard.Main.Math.Answer1		;21
	adc Standard.Main.Math.B1			;24
	sta Standard.Main.Math.Answer1		;27
	lda Standard.Main.Math.Answer2		;30
	adc Standard.Main.Math.B2			;33
	sta Standard.Main.Math.Answer2		;36
+
	asl Standard.Main.Math.B0			;13/41
	rol Standard.Main.Math.B1			;18/46
	rol Standard.Main.Math.B2			;23/51
	dex					;25/53
	bne -					;28/56

	rts


Standard.Main.Multiply.1.24:			;52 to 89 cycles
Standard.Main.Multiply.2.24:			;85 to 159 cycles
Standard.Main.Multiply.2.23:			;85 to 159 cycles
Standard.Main.Multiply.3.24:			;118 to 229 cycles
Standard.Main.Multiply.3.23:			;118 to 229 cycles
Standard.Main.Multiply.3.22:			;118 to 229 cycles
Standard.Main.Multiply.4.24:			;151 to 299 cycles
Standard.Main.Multiply.4.23:			;151 to 299 cycles
Standard.Main.Multiply.4.22:			;151 to 299 cycles
Standard.Main.Multiply.4.21:			;151 to 299 cycles
Standard.Main.Multiply.5.24:			;184 to 369 cycles
Standard.Main.Multiply.5.23:			;184 to 369 cycles
Standard.Main.Multiply.5.22:			;184 to 369 cycles
Standard.Main.Multiply.5.21:			;184 to 369 cycles
Standard.Main.Multiply.5.20:			;184 to 369 cycles
Standard.Main.Multiply.6.24:			;217 to 439 cycles
Standard.Main.Multiply.6.23:			;217 to 439 cycles
Standard.Main.Multiply.6.22:			;217 to 439 cycles
Standard.Main.Multiply.6.21:			;217 to 439 cycles
Standard.Main.Multiply.6.20:			;217 to 439 cycles
Standard.Main.Multiply.6.19:			;217 to 439 cycles
Standard.Main.Multiply.7.24:			;250 to 509 cycles
Standard.Main.Multiply.7.23:			;250 to 509 cycles
Standard.Main.Multiply.7.22:			;250 to 509 cycles
Standard.Main.Multiply.7.21:			;250 to 509 cycles
Standard.Main.Multiply.7.20:			;250 to 509 cycles
Standard.Main.Multiply.7.19:			;250 to 509 cycles
Standard.Main.Multiply.7.18:			;250 to 509 cycles
Standard.Main.Multiply.8.24:			;283 to 579 cycles
Standard.Main.Multiply.8.23:			;283 to 579 cycles
Standard.Main.Multiply.8.22:			;283 to 579 cycles
Standard.Main.Multiply.8.21:			;283 to 579 cycles
Standard.Main.Multiply.8.20:			;283 to 579 cycles
Standard.Main.Multiply.8.19:			;283 to 579 cycles
Standard.Main.Multiply.8.18:			;283 to 579 cycles
Standard.Main.Multiply.8.17:			;283 to 579 cycles
	lda #$00
	sta Standard.Main.Math.B3

Standard.Main.Multiply.1.31:			;47 to 84 cycles
Standard.Main.Multiply.1.30:			;47 to 84 cycles
Standard.Main.Multiply.1.29:			;47 to 84 cycles
Standard.Main.Multiply.1.28:			;47 to 84 cycles
Standard.Main.Multiply.1.27:			;47 to 84 cycles
Standard.Main.Multiply.1.26:			;47 to 84 cycles
Standard.Main.Multiply.1.25:			;47 to 84 cycles
Standard.Main.Multiply.2.30:			;80 to 154 cycles
Standard.Main.Multiply.2.29:			;80 to 154 cycles
Standard.Main.Multiply.2.28:			;80 to 154 cycles
Standard.Main.Multiply.2.27:			;80 to 154 cycles
Standard.Main.Multiply.2.26:			;80 to 154 cycles
Standard.Main.Multiply.2.25:			;80 to 154 cycles
Standard.Main.Multiply.3.29:			;113 to 224 cycles
Standard.Main.Multiply.3.28:			;113 to 224 cycles
Standard.Main.Multiply.3.27:			;113 to 224 cycles
Standard.Main.Multiply.3.26:			;113 to 224 cycles
Standard.Main.Multiply.3.25:			;113 to 224 cycles
Standard.Main.Multiply.4.28:			;146 to 294 cycles
Standard.Main.Multiply.4.27:			;146 to 294 cycles
Standard.Main.Multiply.4.26:			;146 to 294 cycles
Standard.Main.Multiply.4.25:			;146 to 294 cycles
Standard.Main.Multiply.5.27:			;179 to 364 cycles
Standard.Main.Multiply.5.26:			;179 to 364 cycles
Standard.Main.Multiply.5.25:			;179 to 364 cycles
Standard.Main.Multiply.6.26:			;212 to 434 cycles
Standard.Main.Multiply.6.25:			;212 to 434 cycles
Standard.Main.Multiply.7.25:			;245 to 504 cycles

Standard.Main.Multiply.0.8.24.32:
;Math A = 0 to 8 bits
;Math B = 32 - A bits or less (A + B must be greater than 24 and less than 32)
;Math B must be greater than 16 bits
;Answer = 24 to 32 bits
;Example: Math A (8) * Math B (17) = 25 bits

	lda #$00				;2
	sta Standard.Main.Math.Answer0		;5
	sta Standard.Main.Math.Answer1		;8
	sta Standard.Main.Math.Answer2		;11
	sta Standard.Main.Math.Answer3		;14
	
-
	lsr Standard.Main.Math.A0			;5
	bcc +					;7
	clc					;9
	lda Standard.Main.Math.Answer0		;12
	adc Standard.Main.Math.B0			;15
	sta Standard.Main.Math.Answer0		;18
	lda Standard.Main.Math.Answer1		;21
	adc Standard.Main.Math.B1			;24
	sta Standard.Main.Math.Answer1		;27
	lda Standard.Main.Math.Answer2		;30
	adc Standard.Main.Math.B2			;33
	sta Standard.Main.Math.Answer2		;36
	lda Standard.Main.Math.Answer3		;39
	adc Standard.Main.Math.B3			;42
	sta Standard.Main.Math.Answer3		;45
+
	asl Standard.Main.Math.B0			;13/50
	rol Standard.Main.Math.B1			;18/55
	rol Standard.Main.Math.B2			;23/60
	rol Standard.Main.Math.B3			;28/65
	dex					;30/67
	bne -					;33/70

;47, 80, 113, 146, 179, 212, 245, 278
;84, 154, 224, 294, 364, 434, 504, 574
	
	rts

Standard.Main.Multiply.1.32:			;65 to 111 cycles
Standard.Main.Multiply.2.32:			;103 to 195 cycles
Standard.Main.Multiply.2.31:			;103 to 195 cycles
Standard.Main.Multiply.3.32:			;141 to 279 cycles
Standard.Main.Multiply.3.31:			;141 to 279 cycles
Standard.Main.Multiply.3.30:			;141 to 279 cycles
Standard.Main.Multiply.4.32:			;179 to 363 cycles
Standard.Main.Multiply.4.31:			;179 to 363 cycles
Standard.Main.Multiply.4.30:			;179 to 363 cycles
Standard.Main.Multiply.4.29:			;179 to 363 cycles
Standard.Main.Multiply.5.32:			;217 to 447 cycles
Standard.Main.Multiply.5.31:			;217 to 447 cycles
Standard.Main.Multiply.5.30:			;217 to 447 cycles
Standard.Main.Multiply.5.29:			;217 to 447 cycles
Standard.Main.Multiply.5.28:			;217 to 447 cycles
Standard.Main.Multiply.6.32:			;255 to 531 cycles
Standard.Main.Multiply.6.31:			;255 to 531 cycles
Standard.Main.Multiply.6.30:			;255 to 531 cycles
Standard.Main.Multiply.6.29:			;255 to 531 cycles
Standard.Main.Multiply.6.28:			;255 to 531 cycles
Standard.Main.Multiply.6.27:			;255 to 531 cycles
Standard.Main.Multiply.7.32:			;293 to 615 cycles
Standard.Main.Multiply.7.31:			;293 to 615 cycles
Standard.Main.Multiply.7.30:			;293 to 615 cycles
Standard.Main.Multiply.7.29:			;293 to 615 cycles
Standard.Main.Multiply.7.28:			;293 to 615 cycles
Standard.Main.Multiply.7.27:			;293 to 615 cycles
Standard.Main.Multiply.7.26:			;293 to 615 cycles
Standard.Main.Multiply.8.32:			;331 to 699 cycles
Standard.Main.Multiply.8.31:			;331 to 699 cycles
Standard.Main.Multiply.8.30:			;331 to 699 cycles
Standard.Main.Multiply.8.29:			;331 to 699 cycles
Standard.Main.Multiply.8.28:			;331 to 699 cycles
Standard.Main.Multiply.8.27:			;331 to 699 cycles
Standard.Main.Multiply.8.26:			;331 to 699 cycles
Standard.Main.Multiply.8.25:			;331 to 699 cycles

Standard.Main.Multiply.0.8.32.40:
;Math A = 0 to 8 bits
;Math B = 24 to 32 bits (A + B must be greater than 32)
;Math B must be greater than 24 bits
;Answer = 32 to 40 bits
;Example: Math A (5) * Math B (32) = 37 bits

	lda Standard.Main.ZTempVar1		;3
	pha					;6

	lda #$00				;8
	sta Standard.Main.Math.Answer0		;11
	sta Standard.Main.Math.Answer1		;14
	sta Standard.Main.Math.Answer2		;17
	sta Standard.Main.Math.Answer3		;20
	
-
	lsr Standard.Main.Math.A0			;5
	bcc +					;7
	clc					;9
	lda Standard.Main.Math.Answer0		;12
	adc Standard.Main.Math.B0			;15
	sta Standard.Main.Math.Answer0		;18
	lda Standard.Main.Math.Answer1		;21
	adc Standard.Main.Math.B1			;24
	sta Standard.Main.Math.Answer1		;27
	lda Standard.Main.Math.Answer2		;30
	adc Standard.Main.Math.B2			;33
	sta Standard.Main.Math.Answer2		;36
	lda Standard.Main.Math.Answer3		;39
	adc Standard.Main.Math.B3			;42
	sta Standard.Main.Math.Answer3		;45
	lda Standard.Main.Math.Answer4		;48
	adc Standard.Main.ZTempVar1		;51
	sta Standard.Main.Math.Answer4		;54
+
	asl Standard.Main.Math.B0			;13/59
	rol Standard.Main.Math.B1			;18/64
	rol Standard.Main.Math.B2			;23/69
	rol Standard.Main.Math.B3			;28/74
	rol Standard.Main.ZTempVar1		;33/79
	dex					;35/81
	bne -					;38/84

	pla					;24
	sta Standard.Main.ZTempVar1		;27
	rts

;065, 103, 141, 179, 217, 255, 293, 331
;111, 195, 279, 363, 447, 531, 615, 699

Standard.Main.Multiply.9.15:			;311 to 563 cycles
Standard.Main.Multiply.9.14:			;311 to 563 cycles
Standard.Main.Multiply.9.13:			;311 to 563 cycles
Standard.Main.Multiply.9.12:			;311 to 563 cycles
Standard.Main.Multiply.9.11:			;311 to 563 cycles
Standard.Main.Multiply.9.10:			;311 to 563 cycles
Standard.Main.Multiply.9.9:			;311 to 563 cycles
Standard.Main.Multiply.10.14:			;344 to 624 cycles
Standard.Main.Multiply.10.13:			;344 to 624 cycles
Standard.Main.Multiply.10.12:			;344 to 624 cycles
Standard.Main.Multiply.10.11:			;344 to 624 cycles
Standard.Main.Multiply.10.10:			;344 to 624 cycles
Standard.Main.Multiply.11.13:			;377 to 685 cycles
Standard.Main.Multiply.11.12:			;377 to 685 cycles
Standard.Main.Multiply.11.11:			;377 to 685 cycles
Standard.Main.Multiply.12.12:			;410 to 746 cycles

Standard.Main.Multiply.8.16.16.24:
;Math A = 8 to 16 bits
;Math B = 8 to 16 bits (24 - Math A) (A + B must be between 16 and 24)
;Answer = 16 to 24 bits
;Example: Math A (9) * Math B (10) = 19 bits

	lda #$00				;2
	sta Standard.Main.Math.Answer0		;5
	sta Standard.Main.Math.Answer1		;8
	sta Standard.Main.Math.Answer2		;11
	sta Standard.Main.Math.B2			;14

-
	lsr Standard.Main.Math.A1			;5
	ror Standard.Main.Math.A0			;10
	bcc +					;12
	clc					;14
	lda Standard.Main.Math.Answer0		;17
	adc Standard.Main.Math.B0			;20
	sta Standard.Main.Math.Answer0		;23
	lda Standard.Main.Math.Answer1		;26
	adc Standard.Main.Math.B1			;29
	sta Standard.Main.Math.Answer1		;32
	lda Standard.Main.Math.Answer2		;35
	adc Standard.Main.Math.B2			;38
	sta Standard.Main.Math.Answer2		;41
+
	asl Standard.Main.Math.B0			;18/46
	rol Standard.Main.Math.B1			;23/51
	rol Standard.Main.Math.B2			;28/56
	dex					;30/58
	bne -					;33/61
	rts

;311, 344, 377, 410
;563, 624, 685, 746

Standard.Main.Multiply.9.16:			;364 to 697 cycles
Standard.Main.Multiply.10.16:			;402 to 782 cycles
Standard.Main.Multiply.10.15:			;402 to 782 cycles
Standard.Main.Multiply.11.16:			;440 to 847 cycles
Standard.Main.Multiply.11.15:			;440 to 847 cycles
Standard.Main.Multiply.11.14:			;440 to 847 cycles
Standard.Main.Multiply.12.16:			;478 to 922 cycles
Standard.Main.Multiply.12.15:			;478 to 922 cycles
Standard.Main.Multiply.12.14:			;478 to 922 cycles
Standard.Main.Multiply.12.13:			;478 to 922 cycles
Standard.Main.Multiply.13.16:			;516 to 997 cycles
Standard.Main.Multiply.13.15:			;516 to 997 cycles
Standard.Main.Multiply.13.14:			;516 to 997 cycles
Standard.Main.Multiply.13.13:			;516 to 997 cycles
Standard.Main.Multiply.14.16:			;554 to 1081 cycles
Standard.Main.Multiply.14.15:			;554 to 1081 cycles
Standard.Main.Multiply.14.14:			;554 to 1081 cycles
Standard.Main.Multiply.15.16:			;592 to 1147 cycles
Standard.Main.Multiply.15.15:			;592 to 1147 cycles
Standard.Main.Multiply.16.16:			;630 to 1222 cycles
	lda #$00
	sta Standard.Main.Math.B2

Standard.Main.Multiply.9.23:			;359 to 692 cycles
Standard.Main.Multiply.9.22:			;359 to 692 cycles
Standard.Main.Multiply.9.21:			;359 to 692 cycles
Standard.Main.Multiply.9.20:			;359 to 692 cycles
Standard.Main.Multiply.9.19:			;359 to 692 cycles
Standard.Main.Multiply.9.18:			;359 to 692 cycles
Standard.Main.Multiply.9.17:			;359 to 692 cycles
Standard.Main.Multiply.10.22:			;397 to 767 cycles
Standard.Main.Multiply.10.21:			;397 to 767 cycles
Standard.Main.Multiply.10.20:			;397 to 767 cycles
Standard.Main.Multiply.10.19:			;397 to 767 cycles
Standard.Main.Multiply.10.18:			;397 to 767 cycles
Standard.Main.Multiply.10.17:			;397 to 767 cycles
Standard.Main.Multiply.11.21:			;435 to 842 cycles
Standard.Main.Multiply.11.20:			;435 to 842 cycles
Standard.Main.Multiply.11.19:			;435 to 842 cycles
Standard.Main.Multiply.11.18:			;435 to 842 cycles
Standard.Main.Multiply.11.17:			;435 to 842 cycles
Standard.Main.Multiply.12.20:			;473 to 917 cycles
Standard.Main.Multiply.12.19:			;473 to 917 cycles
Standard.Main.Multiply.12.18:			;473 to 917 cycles
Standard.Main.Multiply.12.17:			;473 to 917 cycles
Standard.Main.Multiply.13.19:			;511 to 992 cycles
Standard.Main.Multiply.13.18:			;511 to 992 cycles
Standard.Main.Multiply.13.17:			;511 to 992 cycles
Standard.Main.Multiply.14.18:			;549 to 1076 cycles
Standard.Main.Multiply.14.17:			;549 to 1076 cycles
Standard.Main.Multiply.15.17:			;587 to 1142 cycles

Standard.Main.Multiply.8.16.24.32:
;Math A = 8 to 16 bits
;Math B = 16 to 24 bits (32 - Math A) (A + B must be between 24 and 32)
;Answer = 24 to 32 bits
;Example: Math A (9) * Math B (17) = 26 bits

	lda #$00				;2
	sta Standard.Main.Math.Answer0		;5
	sta Standard.Main.Math.Answer1		;8
	sta Standard.Main.Math.Answer2		;11
	sta Standard.Main.Math.Answer3		;14
	sta Standard.Main.Math.B3			;17

-
	lsr Standard.Main.Math.A1			;5
	ror Standard.Main.Math.A0			;10
	bcc +					;12
	clc					;14
	lda Standard.Main.Math.Answer0		;17
	adc Standard.Main.Math.B0			;20
	sta Standard.Main.Math.Answer0		;23
	lda Standard.Main.Math.Answer1		;26
	adc Standard.Main.Math.B1			;29
	sta Standard.Main.Math.Answer1		;32
	lda Standard.Main.Math.Answer2		;35
	adc Standard.Main.Math.B2			;38
	sta Standard.Main.Math.Answer2		;41
	lda Standard.Main.Math.Answer3		;44
	adc Standard.Main.Math.B3			;47
	sta Standard.Main.Math.Answer3		;50
+
	asl Standard.Main.Math.B0			;18/55
	rol Standard.Main.Math.B1			;23/60
	rol Standard.Main.Math.B2			;28/65
	rol Standard.Main.Math.B3			;33/70
	dex					;35/72
	bne -					;38/75
	rts

;359, 397, 435, 473, 511,  549,  587,  625
;692, 767, 842, 917, 992, 1076, 1142, 1217

Standard.Main.Multiply.9.24:			;422 to 836 cycles
Standard.Main.Multiply.10.24:			;465 to 925 cycles
Standard.Main.Multiply.10.23:			;465 to 925 cycles
Standard.Main.Multiply.11.24:			;508 to 1014 cycles
Standard.Main.Multiply.11.23:			;508 to 1014 cycles
Standard.Main.Multiply.11.22:			;508 to 1014 cycles
Standard.Main.Multiply.12.24:			;551 to 1103 cycles
Standard.Main.Multiply.12.23:			;551 to 1103 cycles
Standard.Main.Multiply.12.22:			;551 to 1103 cycles
Standard.Main.Multiply.12.21:			;551 to 1103 cycles
Standard.Main.Multiply.13.24:			;594 to 1192 cycles
Standard.Main.Multiply.13.23:			;594 to 1192 cycles
Standard.Main.Multiply.13.22:			;594 to 1192 cycles
Standard.Main.Multiply.13.21:			;594 to 1192 cycles
Standard.Main.Multiply.13.20:			;594 to 1192 cycles
Standard.Main.Multiply.14.24:			;628 to 1281 cycles
Standard.Main.Multiply.14.23:			;628 to 1281 cycles
Standard.Main.Multiply.14.22:			;628 to 1281 cycles
Standard.Main.Multiply.14.21:			;628 to 1281 cycles
Standard.Main.Multiply.14.20:			;628 to 1281 cycles
Standard.Main.Multiply.14.19:			;628 to 1281 cycles
Standard.Main.Multiply.15.24:			;680 to 1370 cycles
Standard.Main.Multiply.15.23:			;680 to 1370 cycles
Standard.Main.Multiply.15.22:			;680 to 1370 cycles
Standard.Main.Multiply.15.21:			;680 to 1370 cycles
Standard.Main.Multiply.15.20:			;680 to 1370 cycles
Standard.Main.Multiply.15.19:			;680 to 1370 cycles
Standard.Main.Multiply.15.18:			;680 to 1370 cycles
Standard.Main.Multiply.16.24:			;723 to 1459 cycles
Standard.Main.Multiply.16.23:			;723 to 1459 cycles
Standard.Main.Multiply.16.22:			;723 to 1459 cycles
Standard.Main.Multiply.16.21:			;723 to 1459 cycles
Standard.Main.Multiply.16.20:			;723 to 1459 cycles
Standard.Main.Multiply.16.19:			;723 to 1459 cycles
Standard.Main.Multiply.16.18:			;723 to 1459 cycles
Standard.Main.Multiply.16.17:			;723 to 1459 cycles
	lda #$00
	sta Standard.Main.Math.B2

Standard.Main.Multiply.9.31:			;417 to 831 cycles
Standard.Main.Multiply.9.30:			;417 to 831 cycles
Standard.Main.Multiply.9.29:			;417 to 831 cycles
Standard.Main.Multiply.9.28:			;417 to 831 cycles
Standard.Main.Multiply.9.27:			;417 to 831 cycles
Standard.Main.Multiply.9.26:			;417 to 831 cycles
Standard.Main.Multiply.9.25:			;417 to 831 cycles
Standard.Main.Multiply.10.30:			;460 to 920 cycles
Standard.Main.Multiply.10.29:			;460 to 920 cycles
Standard.Main.Multiply.10.28:			;460 to 920 cycles
Standard.Main.Multiply.10.27:			;460 to 920 cycles
Standard.Main.Multiply.10.26:			;460 to 920 cycles
Standard.Main.Multiply.10.25:			;460 to 920 cycles
Standard.Main.Multiply.11.29:			;503 to 1009 cycles
Standard.Main.Multiply.11.28:			;503 to 1009 cycles
Standard.Main.Multiply.11.27:			;503 to 1009 cycles
Standard.Main.Multiply.11.26:			;503 to 1009 cycles
Standard.Main.Multiply.11.25:			;503 to 1009 cycles
Standard.Main.Multiply.12.28:			;546 to 1098 cycles
Standard.Main.Multiply.12.27:			;546 to 1098 cycles
Standard.Main.Multiply.12.26:			;546 to 1098 cycles
Standard.Main.Multiply.12.25:			;546 to 1098 cycles
Standard.Main.Multiply.13.27:			;589 to 1187 cycles
Standard.Main.Multiply.13.26:			;589 to 1187 cycles
Standard.Main.Multiply.13.25:			;589 to 1187 cycles
Standard.Main.Multiply.14.26:			;623 to 1276 cycles
Standard.Main.Multiply.14.25:			;623 to 1276 cycles
Standard.Main.Multiply.15.25:			;675 to 1365 cycles

Standard.Main.Multiply.8.16.32.40:
;Math A = 8 to 16 bits
;Math B = 24 to 32 bits (40 - Math A) (A + B must be between 32 and 40)
;Answer = 32 to 40 bits
;Example: Math A (15) * Math B (25) = 40

	lda Standard.Main.ZTempVar1		;3
	pha					;6

	lda #$00				;8
	sta Standard.Main.Math.Answer0		;11
	sta Standard.Main.Math.Answer1		;14
	sta Standard.Main.Math.Answer2		;17
	sta Standard.Main.Math.Answer3		;20
	sta Standard.Main.ZTempVar1		;23


-
	lsr Standard.Main.Math.A1			;5
	ror Standard.Main.Math.A0			;10
	bcc +					;12
	clc					;14
	lda Standard.Main.Math.Answer0		;17
	adc Standard.Main.Math.B0			;20
	sta Standard.Main.Math.Answer0		;23
	lda Standard.Main.Math.Answer1		;26
	adc Standard.Main.Math.B1			;29
	sta Standard.Main.Math.Answer1		;32
	lda Standard.Main.Math.Answer2		;35
	adc Standard.Main.Math.B2			;38
	sta Standard.Main.Math.Answer2		;41
	lda Standard.Main.Math.Answer3		;44
	adc Standard.Main.Math.B3			;47
	sta Standard.Main.Math.Answer3		;50
	lda Standard.Main.Math.Answer4		;53
	adc Standard.Main.ZTempVar1		;56
	sta Standard.Main.Math.Answer4		;59
+
	asl Standard.Main.Math.B0			;18/64
	rol Standard.Main.Math.B1			;23/69
	rol Standard.Main.Math.B2			;28/74
	rol Standard.Main.Math.B3			;33/79
	rol Standard.Main.ZTempVar1		;38/84
	dex					;40/86
	bne -					;43/89

	pla					;27
	sta Standard.Main.ZTempVar1		;30

;417, 460,  503,  546,  589,  632,  675,  718
;831, 920, 1009, 1098, 1187, 1276, 1365, 1454
	rts

;
Standard.Main.Multiply.9.32:			;478 to 973 cycles
Standard.Main.Multiply.10.32:			;526 to 1076 cycles
Standard.Main.Multiply.10.31:			;526 to 1076 cycles
Standard.Main.Multiply.11.32:			;574 to 1179 cycles
Standard.Main.Multiply.11.31:			;574 to 1179 cycles
Standard.Main.Multiply.11.30:			;574 to 1179 cycles
Standard.Main.Multiply.12.32:			;622 to 1282 cycles
Standard.Main.Multiply.12.31:			;622 to 1282 cycles
Standard.Main.Multiply.12.30:			;622 to 1282 cycles
Standard.Main.Multiply.12.29:			;622 to 1282 cycles
Standard.Main.Multiply.13.32:			;670 to 1385 cycles
Standard.Main.Multiply.13.31:			;670 to 1385 cycles
Standard.Main.Multiply.13.30:			;670 to 1385 cycles
Standard.Main.Multiply.13.29:			;670 to 1385 cycles
Standard.Main.Multiply.13.28:			;670 to 1385 cycles
Standard.Main.Multiply.14.32:			;718 to 1488 cycles
Standard.Main.Multiply.14.31:			;718 to 1488 cycles
Standard.Main.Multiply.14.30:			;718 to 1488 cycles
Standard.Main.Multiply.14.29:			;718 to 1488 cycles
Standard.Main.Multiply.14.28:			;718 to 1488 cycles
Standard.Main.Multiply.14.27:			;718 to 1488 cycles
Standard.Main.Multiply.15.32:			;766 to 1591 cycles
Standard.Main.Multiply.15.31:			;766 to 1591 cycles
Standard.Main.Multiply.15.30:			;766 to 1591 cycles
Standard.Main.Multiply.15.29:			;766 to 1591 cycles
Standard.Main.Multiply.15.28:			;766 to 1591 cycles
Standard.Main.Multiply.15.27:			;766 to 1591 cycles
Standard.Main.Multiply.15.26:			;766 to 1591 cycles
Standard.Main.Multiply.16.32:			;814 to 1694 cycles
Standard.Main.Multiply.16.31:			;814 to 1694 cycles
Standard.Main.Multiply.16.30:			;814 to 1694 cycles
Standard.Main.Multiply.16.29:			;814 to 1694 cycles
Standard.Main.Multiply.16.28:			;814 to 1694 cycles
Standard.Main.Multiply.16.27:			;814 to 1694 cycles
Standard.Main.Multiply.16.26:			;814 to 1694 cycles
Standard.Main.Multiply.16.25:			;814 to 1694 cycles

Standard.Main.Multiply.8.16.40.48:

	lda Standard.Main.ZTempVar1			;3
	pha						;6
	lda Standard.Main.ZTempVar2			;9
	pha						;12

	lda #$00					;14
	sta Standard.Main.Math.Answer0			;17
	sta Standard.Main.Math.Answer1			;20
	sta Standard.Main.Math.Answer2			;23
	sta Standard.Main.Math.Answer3			;26
	sta Standard.Main.ZTempVar1			;29
	sta Standard.Main.ZTempVar2			;32

-
	lsr Standard.Main.Math.A1				;5
	ror Standard.Main.Math.A0				;10
	bcc +						;12
	clc						;14
	lda Standard.Main.Math.Answer0			;17
	adc Standard.Main.Math.B0				;20
	sta Standard.Main.Math.Answer0			;23
	lda Standard.Main.Math.Answer1			;26
	adc Standard.Main.Math.B1				;29
	sta Standard.Main.Math.Answer1			;32
	lda Standard.Main.Math.Answer2			;35
	adc Standard.Main.Math.B2				;38
	sta Standard.Main.Math.Answer2			;41
	lda Standard.Main.Math.Answer3			;44
	adc Standard.Main.Math.B3				;47
	sta Standard.Main.Math.Answer3			;50
	lda Standard.Main.Math.Answer4			;53
	adc Standard.Main.ZTempVar1			;56
	sta Standard.Main.Math.Answer4			;59
	lda Standard.Main.Math.Answer5			;62
	adc Standard.Main.ZTempVar2			;65
	sta Standard.Main.Math.Answer5			;68
+
	asl Standard.Main.Math.B0				;18/73
	rol Standard.Main.Math.B1				;23/78
	rol Standard.Main.Math.B2				;28/83
	rol Standard.Main.Math.B3				;33/88
	rol Standard.Main.ZTempVar1			;38/93
	rol Standard.Main.ZTempVar2			;43/98
	dex						;45/100
	bne -						;48/103

	pla						;36
	sta Standard.Main.ZTempVar2			;39
	pla						;43
	sta Standard.Main.ZTempVar1			;46

;478,  526,  574,  622,  670,  718,  766,  814
;973, 1076, 1179, 1282, 1385, 1488, 1591, 1694
	rts
;*****************
;SECTION_001:

;Calculates slope of two 8 bit numbers

;To quickly divide two 8 bit numbers into a nice 24 bit precision variable, use the following tables
;to do reciprical multiplication. So instead of dividing $FF by $20, multiply $FF by 1/$20. These tables
;contain all 1/x values with 16 bits of precision. The first table contains all left-of-decimal-point values
;while the second contains the other 8 bits of precision.

;Divides Math.A by Math.B, both of which are 8 bits

Standard.Main.QuickDivide.24:

	lda Standard.Main.QuickDivide.LowBytes.w,x	;4
	sta Standard.Main.Math.B0				;7

	lda Standard.Main.QuickDivide.HighBytes.w,x	;11
	sta Standard.Main.Math.B1				;14

	ldx #8						;16
	jsr Standard.Main.Multiply.8.16			;240 to 460 cycles
							
							;256 to 476 cycles
	rts

Standard.Main.QuickDivide.16:
;Returns Math.A(8bits)/$XX in Math.Answer
;Expected: $XX loaded in X

	lda Standard.Main.QuickDivide.HighBytes.w,x	;4
	sta Standard.Main.Math.B0				;7

	ldx #8						;9
	jsr Standard.Main.Multiply.8.8			;206 to 349 cycles

							;215 to 358 cycles
	rts

Standard.Main.QuickDivide.HighBytes:
	.db $00,$FF,$80,$55,$40,$33,$2A,$24,$20,$1C,$19,$17,$15,$13,$12,$11,
	.db $10,$0F,$0E,$0D,$0C,$0C,$0B,$0B,$0A,$0A,$09,$09,$09,$08,$08,$08,
	.db $08,$07,$07,$07,$07,$06,$06,$06,$06,$06,$06,$05,$05,$05,$05,$05,
	.db $05,$05,$05,$05,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,
	.db $04,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,
	.db $03,$03,$03,$03,$03,$03,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,
	.db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,
	.db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,
	.db $02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,

Standard.Main.QuickDivide.LowBytes:
	.db $00,$00,$00,$55,$00,$33,$AB,$92,$00,$72,$9A,$46,$55,$B1,$49,$11,
	.db $00,$0F,$39,$79,$CD,$31,$A3,$21,$AB,$3D,$D9,$7B,$25,$D4,$89,$42,
	.db $00,$C2,$88,$50,$1C,$EB,$BD,$90,$66,$3E,$18,$F4,$D1,$B0,$91,$72,
	.db $55,$39,$1F,$05,$EC,$D5,$BE,$A8,$92,$7E,$6A,$57,$44,$32,$21,$10,
	.db $00,$F0,$E1,$D2,$C4,$B6,$A8,$9B,$8E,$82,$76,$6A,$5E,$53,$48,$3E,
	.db $33,$29,$1F,$16,$0C,$03,$FA,$F1,$E9,$E0,$D8,$D0,$C8,$C1,$B9,$B2,
	.db $AB,$A4,$9D,$96,$8F,$89,$83,$7C,$76,$70,$6A,$64,$5F,$59,$54,$4E,
	.db $49,$44,$3F,$3A,$35,$30,$2B,$27,$22,$1E,$19,$15,$11,$0C,$08,$04,
	.db $00,$FC,$F8,$F4,$F0,$ED,$E9,$E5,$E2,$DE,$DB,$D7,$D4,$D1,$CE,$CA,
	.db $C7,$C4,$C1,$BE,$BB,$B8,$B5,$B2,$AF,$AC,$AA,$A7,$A4,$A1,$9F,$9C,
	.db $9A,$97,$95,$92,$90,$8D,$8B,$88,$86,$84,$82,$7F,$7D,$7B,$79,$76,
	.db $74,$72,$70,$6E,$6C,$6A,$68,$66,$64,$62,$60,$5E,$5D,$5B,$59,$57,
	.db $55,$54,$52,$50,$4E,$4D,$4B,$49,$48,$46,$44,$43,$41,$40,$3E,$3D,
	.db $3B,$3A,$38,$37,$35,$34,$32,$31,$2F,$2E,$2D,$2B,$2A,$29,$27,$26,
	.db $25,$23,$22,$21,$1F,$1E,$1D,$1C,$1A,$19,$18,$17,$16,$15,$13,$12,
	.db $11,$10,$0F,$0E,$0D,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02,$01,

;*****************
;SECTION_002:

;The following routines divide Math.A by Math.B and store the result in Math.Answer.
;The answer can only be as many bits wide as Math.A, thus making the maximum result
;32 bits. If one desires more presicion than simply integer and remainder, they must
;increase the bit width of Math.A and multiply the answer by a power of 2. See the following example:
;Math.A = 10
;Math.B = 3
;Answer = 3
;Remainder = 1

;Math.A = 20
;Math.B = 3
;Answer = 6
;Remainder = 2

;Math.A = 40
;Math.B = 3
;Answer = 13
;Remainder = 1

;The last will return precision bits in the low 2 bits. Keep shifting left for more precision. So
;shift left for however many precision bits are desired. Just remember, Math.A can only be 32 bits
;So if you have a 24 bit number you can only get 8 precision bits out of shifting it left.

;Very important: Any value for Math.A must be left-aligned! If Math.A is only 3 bits, all 3 bits must
;be the upper 3 bits of Math.A. So if one specifies Math.A as 3 bits, and makes the value 7, they cannot
;make Math.A = 00000111, they must make Math.A = 11100000. This is for speed's sake. Although, if one
;truly desires, they can specify Math.A as 8 bits wide and make it 00000111, because it would still be left
;aligned that way. Math.B values are right-aligned and normal.

;The remainder of the division can be found in Math.Remainder. Math.Remainder is 32 bits wide, so
;it is split up into Math.Remainder0, Math.Remainder1, Math.Remainder2, and Math.Remainder3. Note
;that Math.Remainder0 and Math.Remainder1 are -synonmyms- for Math.Answer4 and Math.Answer5. So
;Math.Answer4 and Math.Answer5 will be destroyed in the routine. The Answer can only be the same amount of bits
;as Math.A.

;Unlike multiplication routines, there are only 4 names. Divide.8.8 specifies the max bit width of A and B (both 8).
;Very importantly, one must take the bitwidth of A, round it down to the previous multiple of 8, subtract it from
;The bitwidth of A, and load that value in Y before going to these routines. So if A is 13 bits wide, one must find
;the previous multiple of 8 (8), subtract that from 13 (13 - 8 = 5), and load that in Y (So Y must = 5). One would
;then jump to Divide.16.16. Unfortunately, due to how binary division works, it proves to take MORE time to divide
;by smaller numbers, so Divide.16.8 proved to be a useless routine. The minor differences between it and Divide.16.16
;proved to be a collossul waste of space. On average, the entire routine only proved to be 12 cycles faster.

;In order to divide by an 8 bit number efficiently/effectively, one should consider seeing the QuickDivide routines. They ;offer high precision; much higher than the following routines.

Standard.Main.Divide.8.8:

;Cycle counts
;Loaded in Y:  1   2   3   4   5   6   7   8
;Min:	      37  60  83  106 129 152 172 198
;Max:         39  64  89  114 139 164 189 214

;Math.A / Math.B = Math.Answer


	lda #$00				;2
	sta Standard.Main.Math.Answer0		;5
	sta Standard.Main.Math.Remainder0		;8

	lda Standard.Main.Math.Remainder0		;11
-
	asl Standard.Main.Math.A0			;5
	rol a					;7

	cmp Standard.Main.Math.B0			;10
	bcc +					;12

	sbc Standard.Main.Math.B0			;15
+
	rol Standard.Main.Math.Answer0		;18/23
	dey					;20/25
	bne -					;23/25

						
	sta Standard.Main.Math.Remainder0		;14

	rts


Standard.Main.Divide.16.16:

;Loaded in Y: 1    2    3    4    5    6    7    8
;$100< Mn:   308  352  396  440  484  528  572  616 
;$100< Mx:   353  426  499  572  645  718  791  864
;$100> Mn:    84  128  172  216  260  304  348  392
;$100> Mn:   113  186  259  332  405  478  551  624

	lda #$00				;2
	sta Standard.Main.Math.Answer0		;5
	sta Standard.Main.Math.Answer1		;8
	sta Standard.Main.Math.Remainder0		;17
	sta Standard.Main.Math.Remainder1		;20

	lda Standard.Main.Math.B1			;23
	beq +					;25
	lda Standard.Main.Math.A0			;28
	ldx Standard.Main.Math.A1			;31
	sta Standard.Main.Math.A1			;34
	stx Standard.Main.Math.Remainder0		;37
	jmp +++					;40
+
	lda Standard.Main.Math.B0			;29
	bne +					;31
	ldy #$FF				;33
	rts
+

	lda Standard.Main.Math.Remainder0		;35
	ldx #8					;37
-
	asl Standard.Main.Math.A0			;5
	rol Standard.Main.Math.A1			;10
	rol a					;12

	cmp Standard.Main.Math.B0			;15
	bcc ++					;17
+

	sbc Standard.Main.Math.B0			;20
++
	rol Standard.Main.Math.Answer0		;23/25
	dex					;25/27
	bne -					;28/30

						;224 to 240 cycles

	sta Standard.Main.Math.Remainder0		;40
+++
						;40/40
-
	asl Standard.Main.Math.A0			;5
	rol Standard.Main.Math.A1			;10

	rol Standard.Main.Math.Remainder0		;15
	rol Standard.Main.Math.Remainder1		;20

	lda Standard.Main.Math.Remainder1		;23
	cmp Standard.Main.Math.B1			;26
	bcc ++					;28
	bne +					;30
	lda Standard.Main.Math.Remainder0		;33
	cmp Standard.Main.Math.B0			;36
	bcc ++					;38
+
	lda Standard.Main.Math.Remainder0		;34/41
	sbc Standard.Main.Math.B0			;37/44
	sta Standard.Main.Math.Remainder0		;40/47
	lda Standard.Main.Math.Remainder1		;43/50
	sbc Standard.Main.Math.B1			;46/53
	sta Standard.Main.Math.Remainder1		;49/56
	sec					;51/58
++
	rol Standard.Main.Math.Answer0		;34/44/55/63
	rol Standard.Main.Math.Answer1		;39/49/60/68
	dey					;41/51/62/70
	bne -					;44/54/65/73
						;352 to 594 cycles

	rts
;*********************
;SECTION_003:

Standard.Main.Random.16:
;Generates random 16 bit number in Random.Random0 and Random.Random1.
;Before using, initialize these values with any number, preferably base it off of time it takes
;for user interaction at some location. Then initialize Random.Index0 and Random.Index1 with any
;4-bit value (It's a good idea to use Random0 AND #$0F and Random1 AND #$0F as initialization values).
;In order to generate a random number between 2 specified values X and Y, where Z = Y - X, Generate
;a random number without bounds, divide it by Z, and either subtract the remainder from Y or add it to X.
;For example, if one needs a random value between 2 and 6, one may generate the 16 bit random value $E351.
;Take this value divided by 4 ($38D4 remainder 1), and add the remainder (1) to 2, or subtract it from 6, either
;making the final result either 3 or 5.

	ldx Standard.Main.Random.Index1		;3
	clc					;5
	lda Standard.Main.Random.Random0		;8
	adc Standard.Main.Random.Random1		;11
	eor Standard.Main.Random.TableB.w,x	;15
	sta Standard.Main.Random.Random1		;18
	lsr Standard.Main.Random.Random0		;23
	inx					;25
	txa					;27
	and #$0F				;29
	sta Standard.Main.Random.Index1		;32

	ldx Standard.Main.Random.Index0		;35
	lda Standard.Main.Random.Random0		;38
	eor Standard.Main.Random.TableA.w,x	;42
	clc					;44
	adc Standard.VBLCount			;47
	sta Standard.Main.Random.Random0		;50
	lda Standard.Main.Random.Random1		;53
	adc #0					;55
	sta Standard.Main.Random.Random1		;58
	inx					;60
	txa					;62
	and #$0F				;64
	sta Standard.Main.Random.Index0		;67
	rts

Standard.Main.Random.8:
;Generates random 8 bit number Random.Random0.
;Before using, initialize this value with any number, preferably based off of time it takes for
;user interaction. Initialize Random.Index0 with any 4-bit value (it works well to use the low 4
;bits of the initialized Random.Random0 value). Read more info in Random.16 information.

	ldx Standard.Main.Random.Index0		;3
	lda Standard.Main.Random.Random0		;6
	rol a					;8
	eor Standard.Main.Random.TableB.w,x	;12
	clc					;14
	adc Standard.VBLCount			;17
	sta Standard.Main.Random.Random0		;20
	inx					;22
	txa					;24
	and #$0F				;26
	sta Standard.Main.Random.Index0		;29
	rts

Standard.Main.Random.TableA:
	.db $4A,$C3,$E4,$BD,$11,$07,$F5,$26,$D2,$30,$58,$69,$7B,$AF,$9E,$7C

Standard.Main.Random.TableB:
	.db $38,$A2,$AF,$C9,$20,$F3,$67,$23,$59,$10,$50,$4D,$85,$BA,$41,$E7

;SECTION_004:

Standard.Main.HexToDecimal.8:
;Given: Hex value in Convert.Hex0
;Returns decimal value in Convert.: Ones, Tens, and Hundreds.

	lda #$00						;2
	sta Standard.Main.Convert.DecOnes				;5
	sta Standard.Main.Convert.DecTens				;8
	sta Standard.Main.Convert.DecHundreds			;11

	lda Standard.Main.Convert.Hex0				;14
	and #$0F						;16
	tax							;18
	lda Standard.Main.HexToDecimal.HexDigit00Table.w,x	;22
	sta Standard.Main.Convert.DecOnes				;25
	lda Standard.Main.HexToDecimal.HexDigit01Table.w,x	;29
	sta Standard.Main.Convert.DecTens				;32

	lda Standard.Main.Convert.Hex0				;35
	lsr a							;37
	lsr a							;39
	lsr a							;41
	lsr a							;43
	tax							;45
	lda Standard.Main.HexToDecimal.HexDigit10Table.w,x	;49
	clc							;51
	adc Standard.Main.Convert.DecOnes				;54
	sta Standard.Main.Convert.DecOnes				;57
	lda Standard.Main.HexToDecimal.HexDigit11Table.w,x	;61
	adc Standard.Main.Convert.DecTens				;64
	sta Standard.Main.Convert.DecTens				;67
	lda Standard.Main.HexToDecimal.HexDigit12Table.w,x	;71
	sta Standard.Main.Convert.DecHundreds			;74

	clc							;76
	ldx Standard.Main.Convert.DecOnes				;79
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x		;83
	sta Standard.Main.Convert.DecOnes				;86
	

	lda Standard.Main.HexToDecimal.DecimalSumsHigh.w,x	;90
	adc Standard.Main.Convert.DecTens				;93
	tax							;95
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x		;99
	sta Standard.Main.Convert.DecTens				;102

	lda Standard.Main.HexToDecimal.DecimalSumsHigh.w,x	;106
	adc Standard.Main.Convert.DecHundreds			;109
	tax							;111
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x		;115
	sta Standard.Main.Convert.DecHundreds			;118

	rts

Standard.Main.HexToDecimal.16:
;Given: Hex value in Convert.Hex0 and Convert.Hex1
;Returns decimal value in Convert.: Ones, Tens, Hundreds, Thousands, TenThousands.
;Takes values from pre-converted hex to decimal table and simulates pen-and-paper addition
;to return decimal value.

	lda #$00						;2
	sta Standard.Main.Convert.DecOnes				;5
	sta Standard.Main.Convert.DecTens				;8
	sta Standard.Main.Convert.DecHundreds			;11
	sta Standard.Main.Convert.DecThousands			;14
	sta Standard.Main.Convert.DecTenThousands			;17

	lda Standard.Main.Convert.Hex0				;20
	and #$0F						;22
	tax							;24
	lda Standard.Main.HexToDecimal.HexDigit00Table.w,x	;28
	sta Standard.Main.Convert.DecOnes				;31
	lda Standard.Main.HexToDecimal.HexDigit01Table.w,x	;35
	sta Standard.Main.Convert.DecTens				;38

	lda Standard.Main.Convert.Hex0				;41
	lsr a							;43
	lsr a							;45
	lsr a							;47
	lsr a							;49
	tax							;51
	lda Standard.Main.HexToDecimal.HexDigit10Table.w,x	;54
	clc							;56
	adc Standard.Main.Convert.DecOnes				;59
	sta Standard.Main.Convert.DecOnes				;62
	lda Standard.Main.HexToDecimal.HexDigit11Table.w,x	;66
	adc Standard.Main.Convert.DecTens				;69
	sta Standard.Main.Convert.DecTens				;72
	lda Standard.Main.HexToDecimal.HexDigit12Table.w,x	;76
	sta Standard.Main.Convert.DecHundreds			;79

	lda Standard.Main.Convert.Hex1				;82
	and #$0F						;84
	tax							;86
	lda Standard.Main.HexToDecimal.HexDigit20Table.w,x	;90
	clc							;92
	adc Standard.Main.Convert.DecOnes				;95
	sta Standard.Main.Convert.DecOnes				;98
	lda Standard.Main.HexToDecimal.HexDigit21Table.w,x	;102
	adc Standard.Main.Convert.DecTens				;105
	sta Standard.Main.Convert.DecTens				;108
	lda Standard.Main.HexToDecimal.HexDigit22Table.w,x	;112
	adc Standard.Main.Convert.DecHundreds			;115
	sta Standard.Main.Convert.DecHundreds			;118
	lda Standard.Main.HexToDecimal.HexDigit23Table.w,x	;122
	sta Standard.Main.Convert.DecThousands			;125

	lda Standard.Main.Convert.Hex1				;128
	lsr a							;130
	lsr a							;132
	lsr a							;134
	lsr a							;136
	tax							;138
	clc							;140
	lda Standard.Main.HexToDecimal.HexDigit30Table.w,x	;144
	adc Standard.Main.Convert.DecOnes				;147
	sta Standard.Main.Convert.DecOnes				;150
	lda Standard.Main.HexToDecimal.HexDigit31Table.w,x	;154
	adc Standard.Main.Convert.DecTens				;157
	sta Standard.Main.Convert.DecTens				;160
	lda Standard.Main.HexToDecimal.HexDigit32Table.w,x	;164
	adc Standard.Main.Convert.DecHundreds			;167
	sta Standard.Main.Convert.DecHundreds			;170
	lda Standard.Main.HexToDecimal.HexDigit33Table.w,x	;174
	adc Standard.Main.Convert.DecThousands			;177
	sta Standard.Main.Convert.DecThousands			;180
	lda Standard.Main.HexToDecimal.HexDigit34Table.w,x	;184
	sta Standard.Main.Convert.DecTenThousands			;187

	clc							;189
	ldx Standard.Main.Convert.DecOnes				;192
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x		;196
	sta Standard.Main.Convert.DecOnes				;199
	

	lda Standard.Main.HexToDecimal.DecimalSumsHigh.w,x	;203
	adc Standard.Main.Convert.DecTens				;206
	tax							;208
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x		;212
	sta Standard.Main.Convert.DecTens				;215

	lda Standard.Main.HexToDecimal.DecimalSumsHigh.w,x
	adc Standard.Main.Convert.DecHundreds
	tax
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x
	sta Standard.Main.Convert.DecHundreds			;231

	lda Standard.Main.HexToDecimal.DecimalSumsHigh.w,x
	adc Standard.Main.Convert.DecThousands
	tax
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x
	sta Standard.Main.Convert.DecThousands			;247

	lda Standard.Main.HexToDecimal.DecimalSumsHigh.w,x
	adc Standard.Main.Convert.DecTenThousands
	tax
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x
	sta Standard.Main.Convert.DecTenThousands			;263

	rts



Game.Main.Player.ConvertInfoToDecimal.Score:
	lda #$00						;2
	sta Standard.Main.Convert.DecOnes				;5
	sta Standard.Main.Convert.DecTens				;8
	sta Standard.Main.Convert.DecHundreds			;11
	sta Standard.Main.Convert.DecThousands			;14
	sta Standard.Main.Convert.DecTenThousands			;17
	sta Standard.Main.Convert.DecHundredThousands		;20
	

	lda Game.Player.ScoreL				;3
	and #$0F						;5
	tax							;7
	lda Standard.Main.HexToDecimal.HexDigit00Table.w,x	;11
	sta Standard.Main.Convert.DecOnes				;14
	lda Standard.Main.HexToDecimal.HexDigit01Table.w,x	;18
	sta Standard.Main.Convert.DecTens				;21

								;47

	lda Game.Player.ScoreL				;3
	lsr a							;5
	lsr a							;7
	lsr a							;9
	lsr a							;11
	tax							;13
	lda Standard.Main.HexToDecimal.HexDigit10Table.w,x	;17
	clc							;19
	adc Standard.Main.Convert.DecOnes				;22
	sta Standard.Main.Convert.DecOnes				;25
	lda Standard.Main.HexToDecimal.HexDigit11Table.w,x	;29
	adc Standard.Main.Convert.DecTens				;32
	sta Standard.Main.Convert.DecTens				;35
	lda Standard.Main.HexToDecimal.HexDigit12Table.w,x	;39
	sta Standard.Main.Convert.DecHundreds			;42

								;89

	lda Game.Player.ScoreM				;3
	and #$0F						;5
	tax							;7
	lda Standard.Main.HexToDecimal.HexDigit20Table.w,x	;11
	clc							;13
	adc Standard.Main.Convert.DecOnes				;16
	sta Standard.Main.Convert.DecOnes				;19
	lda Standard.Main.HexToDecimal.HexDigit21Table.w,x	;23
	adc Standard.Main.Convert.DecTens				;26
	sta Standard.Main.Convert.DecTens				;29
	lda Standard.Main.HexToDecimal.HexDigit22Table.w,x	;33
	adc Standard.Main.Convert.DecHundreds			;36
	sta Standard.Main.Convert.DecHundreds			;39
	lda Standard.Main.HexToDecimal.HexDigit23Table.w,x	;43
	sta Standard.Main.Convert.DecThousands			;46

								;135

	lda Game.Player.ScoreM				;128
	lsr a							;130
	lsr a							;132
	lsr a							;134
	lsr a							;136
	tax							;138
	clc							;140
	lda Standard.Main.HexToDecimal.HexDigit30Table.w,x	;144
	adc Standard.Main.Convert.DecOnes				;147
	sta Standard.Main.Convert.DecOnes				;150
	lda Standard.Main.HexToDecimal.HexDigit31Table.w,x	;154
	adc Standard.Main.Convert.DecTens				;157
	sta Standard.Main.Convert.DecTens				;160
	lda Standard.Main.HexToDecimal.HexDigit32Table.w,x	;164
	adc Standard.Main.Convert.DecHundreds			;167
	sta Standard.Main.Convert.DecHundreds			;170
	lda Standard.Main.HexToDecimal.HexDigit33Table.w,x	;174
	adc Standard.Main.Convert.DecThousands			;177
	sta Standard.Main.Convert.DecThousands			;180
	lda Standard.Main.HexToDecimal.HexDigit34Table.w,x	;184
	sta Standard.Main.Convert.DecTenThousands			;187

								;196

	lda Game.Player.ScoreH				;3
	and #$0F						;5
	tax							;7
	clc							;9
	lda Standard.Main.HexToDecimal.HexDigit40Table.w,x	;13
	adc Standard.Main.Convert.DecOnes				;16
	sta Standard.Main.Convert.DecOnes				;19
	lda Standard.Main.HexToDecimal.HexDigit41Table.w,x	;23
	adc Standard.Main.Convert.DecTens				;26
	sta Standard.Main.Convert.DecTens				;29
	lda Standard.Main.HexToDecimal.HexDigit42Table.w,x	;33
	adc Standard.Main.Convert.DecHundreds			;36
	sta Standard.Main.Convert.DecHundreds			;39
	lda Standard.Main.HexToDecimal.HexDigit43Table.w,x	;43
	adc Standard.Main.Convert.DecThousands			;
	sta Standard.Main.Convert.DecThousands			;
	lda Standard.Main.HexToDecimal.HexDigit44Table.w,x	;53
	adc Standard.Main.Convert.DecTenThousands			;
	sta Standard.Main.Convert.DecTenThousands			;
	lda Standard.Main.HexToDecimal.HexDigit45Table.w,x	;63
	sta Standard.Main.Convert.DecHundredThousands		;66

								;262

								;351

	clc							;2
	ldx Standard.Main.Convert.DecOnes				;5
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x		;9
	sta Standard.Main.Convert.DecOnes				;12
	

	lda Standard.Main.HexToDecimal.DecimalSumsHigh.w,x	;4
	adc Standard.Main.Convert.DecTens				;7
	tax							;9
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x		;13
	sta Standard.Main.Convert.DecTens				;16

	lda Standard.Main.HexToDecimal.DecimalSumsHigh.w,x
	adc Standard.Main.Convert.DecHundreds
	tax
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x
	sta Standard.Main.Convert.DecHundreds			;32

	lda Standard.Main.HexToDecimal.DecimalSumsHigh.w,x
	adc Standard.Main.Convert.DecThousands
	tax
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x
	sta Standard.Main.Convert.DecThousands			;48

	lda Standard.Main.HexToDecimal.DecimalSumsHigh.w,x
	adc Standard.Main.Convert.DecTenThousands
	tax
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x
	sta Standard.Main.Convert.DecTenThousands			;64

	lda Standard.Main.HexToDecimal.DecimalSumsHigh.w,x
	adc Standard.Main.Convert.DecHundredThousands
	tax
	lda Standard.Main.HexToDecimal.DecimalSumsLow.w,x
	sta Standard.Main.Convert.DecHundredThousands		;80


								;112 + 12
								;124 + 351

								;475

	rts
;************ Pre-Converted Hex to Decimal Tables *************

;******

;1 byte
Standard.Main.HexToDecimal.HexDigit32Table:
	.db $0

Standard.Main.HexToDecimal.HexDigit00Table:
Standard.Main.HexToDecimal.HexDigit56Table:
Standard.Main.HexToDecimal.DecimalSumsLow:
;55 bytes
	.db $0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$0,$1,$2,$3,$4,$5
	.db $6,$7,$8,$9,$0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$0,$1
	.db $2,$3,$4,$5,$6,$7,$8,$9,$0,$1,$2,$3,$4,$5,$6,$7
	.db $8,$9,$0,$1,$2,$3,$4

Standard.Main.HexToDecimal.HexDigit01Table:
Standard.Main.HexToDecimal.HexDigit57Table:
Standard.Main.HexToDecimal.DecimalSumsHigh:
;55 bytes
	.db $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1,$1,$1,$1,$1,$1
	.db $1,$1,$1,$1,$2,$2,$2,$2,$2,$2,$2,$2,$2,$2,$3,$3
	.db $3,$3,$3,$3,$3,$3,$3,$3,$4,$4,$4,$4,$4,$4,$4,$4
	.db $4,$4,$5,$5,$5,$5,$5

;111 bytes
;******
Standard.Main.HexToDecimal.HexDigit50Table:
Standard.Main.HexToDecimal.HexDigit40Table:
Standard.Main.HexToDecimal.HexDigit30Table:
Standard.Main.HexToDecimal.HexDigit20Table:
Standard.Main.HexToDecimal.HexDigit10Table:
	.db $0,$6,$2,$8,$4,$0,$6,$2,$8,$4,$0,$6,$2,$8,$4,$0

Standard.Main.HexToDecimal.HexDigit11Table:
	.db $0,$1,$3,$4,$6,$8,$9,$1,$2,$4,$6,$7,$9,$0,$2,$4

Standard.Main.HexToDecimal.HexDigit12Table:
	.db $0,$0,$0,$0,$0,$0,$0,$1,$1,$1,$1,$1,$1,$2,$2,$2
;******
Standard.Main.HexToDecimal.HexDigit21Table:
	.db $0,$5,$1,$6,$2,$8,$3,$9,$4,$0,$6,$1,$7,$2,$8,$4

Standard.Main.HexToDecimal.HexDigit22Table:
	.db $0,$2,$5,$7,$0,$2,$5,$7,$0,$3,$5,$8,$0,$3,$5,$8

Standard.Main.HexToDecimal.HexDigit23Table:
	.db $0,$0,$0,$0,$1,$1,$1,$1,$2,$2,$2,$2,$3,$3,$3,$3
;******
Standard.Main.HexToDecimal.HexDigit31Table:
	.db $0,$9,$9,$8,$8,$8,$7,$7,$6,$6,$6,$5,$5,$4,$4,$4

Standard.Main.HexToDecimal.HexDigit33Table:
	.db $0,$4,$8,$2,$6,$0,$4,$8,$2,$6,$0,$5,$9,$3,$7,$1

Standard.Main.HexToDecimal.HexDigit34Table:
	.db $0,$0,$0,$1,$1,$2,$2,$2,$3,$3,$4,$4,$4,$5,$5,$6

;******
Standard.Main.HexToDecimal.HexDigit41Table:
	.db $0,$3,$7,$0,$4,$8,$1,$5,$8,$2,$6,$9,$3,$6,$0,$4

Standard.Main.HexToDecimal.HexDigit42Table:
	.db $0,$5,$0,$6,$1,$6,$2,$7,$2,$8,$3,$8,$4,$9,$5,$0

Standard.Main.HexToDecimal.HexDigit43Table:
	.db $0,$5,$1,$6,$2,$7,$3,$8,$4,$9,$5,$0,$6,$1,$7,$3

Standard.Main.HexToDecimal.HexDigit44Table:
	.db $0,$6,$3,$9,$6,$2,$9,$5,$2,$8,$5,$2,$8,$5,$1,$8

Standard.Main.HexToDecimal.HexDigit45Table:
	.db $0,$0,$1,$1,$2,$3,$3,$4,$5,$5,$6,$7,$7,$8,$9,$9
;******
Standard.Main.HexToDecimal.HexDigit51Table:
	.db $0,$7,$5,$2,$0,$8,$5,$3,$0,$8,$6,$3,$1,$8,$6,$4

Standard.Main.HexToDecimal.HexDigit52Table:
	.db $0,$5,$1,$7,$3,$8,$4,$0,$6,$1,$7,$3,$9,$4,$0,$6

Standard.Main.HexToDecimal.HexDigit53Table:
	.db $0,$8,$7,$5,$4,$2,$1,$0,$8,$7,$5,$4,$2,$1,$0,$8

Standard.Main.HexToDecimal.HexDigit54Table:
	.db $0,$4,$9,$4,$9,$4,$9,$4,$8,$3,$8,$3,$8,$3,$8,$2

Standard.Main.HexToDecimal.HexDigit55Table:
	.db $0,$0,$0,$1,$1,$2,$2,$3,$3,$4,$4,$5,$5,$6,$6,$7

;$19F bytes total of table space
;1000 bytes of code/data
;***********************************

Standard.Main.JSRIndirect.TempAdd0:
	jmp (Standard.Main.TempAdd0L)

Standard.Main.JSRIndirect.TempAdd1:
	jmp (Standard.Main.TempAdd1L)

Standard.Main.JSRIndirect.TempAdd2:
	jmp (Standard.Main.TempAdd2L)

Standard.Main.JSRIndirect.TempAdd3:
	jmp (Standard.Main.TempAdd3L)



Standard.NMI.JSRIndirect.TempAdd0:
	jmp (Standard.NMI.TempAdd0L)

Standard.NMI.JSRIndirect.TempAdd1:
	jmp (Standard.NMI.TempAdd1L)

Standard.NMI.JSRIndirect.TempAdd2:
	jmp (Standard.NMI.TempAdd2L)

Standard.NMI.JSRIndirect.TempAdd3:
	jmp (Standard.NMI.TempAdd3L)