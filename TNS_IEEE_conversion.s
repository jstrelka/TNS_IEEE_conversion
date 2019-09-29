;-----------------------------------------------
;Name: Justin Strelka
;Date: ??/??/19
;Professor: Ranjidha Rajan
;Course: CS_2400 Section 2
;Program: In-class?
;-----------------------------------------------      
                   AREA    RESET, DATA, READONLY

          EXPORT  __Vectors

__Vectors

              DCD  0x20001000

              DCD  Reset_Handler  ; reset vector

              ALIGN

                               

                                AREA   CS2400_Fall2019, CODE, READONLY

                ENTRY

                      EXPORT Reset_Handler

Reset_Handler
;------------------------------------------------------------

main
								; start TNS to IEEE
		ldr		r0,=TNS 		; r0 = address TNS
		ldr		r1,[r0]			; r1 = valule at address r0
		bl		signBit			; branch and link to signBit
		bl		TNSmant			; branch and link to TNSmant
		bl		TNSexp			; branch and link to TNSexp
		bl		TNSexpCnv		; branch and link to TNSexpCnv
		bl		TNSmantCnv		; branch and link to TNSmantCnv
		bl		buildIEEE		; branch and link to buildIEEE
								; start IEEE to TNS
		ldr		r0,=IEEE		; r0 = address IEEE
		ldr 	r1,[r0]			; r1 = value at address r0
		bl		signBit			; branch and link to signBit
		bl		IEEEmant		; branch and link to IEEEmant

		b		st				; branch to ending loop
		
signBit
		ldr		r0,=signM		; r0 = address signMask
		ldr		r12,[r0]		; r12 = signMask value
		and		r2,r1,r12		; r2 = TNS sign bit
		mov		pc,r14			; return to caller

TNSmant
		ldr		r0,=TNSmantM	; r0 = address TNSfracM
		ldr		r12,[r0]		; r12 = TNSfracM value
		and		r3,r1,r12		; r3 = TNS fraction
		mov		pc,r14			; return to caller
		
TNSexp
		ldr		r0,=TNSexpM		; r0 = address TNSexpM
		ldr		r12,[r0]		; r12 = TNSexpM value
		and		r4,r1,r12		; r4 = TNS exponent
		mov		pc,r14			; return to caller

TNSexpCnv						; TNS BIAS = 256 convert to IEEE BIAS 127
		sub		r4,r4,#256		; r3 = TNS exponent - 256 
		add		r4,r4,#127		; r3 = converted to IEEE exponent
		lsl		r4,r4,#23		; position converted IEEE exponent
		mov		pc,r14			; return to caller
		
TNSmantCnv						; IEEE = TNS mantissa + 1 bit
		lsr		r3,r3,#8		; TNS mantissa gains single bit
		mov		pc,r14			; return to caller
		
buildIEEE
		orr		r11,r3,r4		; r11 = combined exponent and mantissa
		orr		r11,r11,r2		; r11 = combined sign bit
		mov 	pc,r14			; return to caller
		
IEEEmant
		ldr		r0,=IEEEmantM
		ldr		r12,[r0]
		and		r2,r12,r1
		mov		pc,r14
		
		
		
		



st		b		st

TNS			dcd		0x64000103
IEEE		dcd		0x41640000
signM		dcd		0x80000000
TNSmantM	dcd		0x7FFFFE00
TNSexpM		dcd		0x000001FF
IEEEmantM	dcd		0x007FFFFF
	
		END