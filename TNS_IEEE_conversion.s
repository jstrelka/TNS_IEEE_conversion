;-----------------------------------------------
;Name: Justin Strelka
;Date: 09/30/19
;Professor: Ranjidha Rajan
;Course: CS_2400 Section 2
;Program: Homework 04 (Convert TNS and IEEE)
;Hours:	8 Hours with design
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

main							; start conversions
		bl		TNStoIEEE		; branch and link to TNStoIEEE
		bl		IEEEtoTNS		; branch and link to IEEEtoTNS
		
								; compare converted numbers to source
		bl		compareTNS		; branch and link to compareTNS
		bl		compareIEEE		; branch and link to compareIEEE

		b		st				; branch to ending loop
		
TNStoIEEE						; convert TNS to IEEE
		mov		r9,lr  			; r9 = store lr for return to main
		ldr		r0,=TNS 		; r0 = address TNS
		ldr		r1,[r0]			; r1 = valule at address r0
		bl		signBit			; branch and link to signBit
		bl		TNSmant			; branch and link to TNSmant
		bl		TNSexp			; branch and link to TNSexp
		bl		TNSmantCnv		; branch and link to TNSmantCnv
		bl		TNSexpCnv		; branch and link to TNSexpCnv
		bl		buildIEEE		; branch and link to buildIEEE
		mov		pc,r9			; return to caller
		
IEEEtoTNS						; convert IEEE to TNS
		mov		r9,lr			; r9 = store lr for return to main
		ldr		r0,=IEEE		; r0 = address IEEE
		ldr 	r1,[r0]			; r1 = value at address r0
		bl		signBit			; branch and link to signBit
		bl		IEEEmant		; branch and link to IEEEmant
		bl		IEEEexp			; branch and link to IEEEexp
		bl		IEEEmantCnv		; branch and link to IEEEmantCnv
		bl		IEEEexpCnv		; branch and link to IEEEexpCnv
		bl		buildTNS		; branch and link to buildTNS
		mov		pc,r9			; return to caller
		
signBit
		ldr		r0,=signM		; r0 = address signMask
		ldr		r12,[r0]		; r12 = signMask value
		and		r2,r1,r12		; r2 = TNS sign bit
		mov		pc,r14			; return to caller

TNSmant
		ldr		r0,=TNSmantM	; r0 = address TNSmantM
		ldr		r12,[r0]		; r12 = TNSmantM value
		and		r3,r1,r12		; r3 = TNS mantissa
		mov		pc,r14			; return to caller
		
TNSexp
		ldr		r0,=TNSexpM		; r0 = address TNSexpM
		ldr		r12,[r0]		; r12 = TNSexpM value
		and		r4,r1,r12		; r4 = TNS exponent
		mov		pc,r14			; return to caller

TNSmantCnv						; IEEE = TNS mantissa + 1 bit
		lsr		r3,r3,#8		; TNS mantissa gains single bit
		mov		pc,r14			; return to caller

TNSexpCnv						; TNS BIAS 256 convert to IEEE BIAS 127
		sub		r4,r4,#129		; r4 = TNS exponent - 129 
								; r4 = converted IEEE exponent
		lsl		r4,r4,#23		; position IEEE exponent
		mov		pc,r14			; return to caller
		
buildIEEE						; combine IEEE components
		orr		r11,r3,r4		; r11 = combined exponent and mantissa
		orr		r11,r11,r2		; r11 = combined sign bit
		mov 	pc,r14			; return to caller
		
IEEEmant
		ldr		r0,=IEEEmantM	; r0 = address IEEEmantM
		ldr		r12,[r0]		; r12 = IEEEmantM value
		and		r3,r12,r1		; r3 = IEEE mantissa
		mov		pc,r14			; return to caller
		
IEEEexp
		ldr		r0,=IEEEexpM	; r0 = address IEEEexpM
		ldr		r12,[r0]		; r12 = IEEEexpM value
		and		r4,r1,r12		; r4 = IEEE exponent
		mov 	pc,r14			; return to caller
		
IEEEmantCnv
		lsl		r3,r3,#8		; remove most significant bit
		mov		pc,r14			; return to caller
		
IEEEexpCnv
		lsr		r4,r4,#23		; position mantissa
		add		r4,r4,#129		; IEEE BIAs 127 convert to TNS BIAS 256
		mov		pc,r14			; return to caller
	
buildTNS						; combine TNS components
		orr		r10,r3,r4		; r10 = combined exponent and mantissa
		lsl		r10,r10,#1		; clear signbit
		lsr		r10,r10,#1		; retain bit position
		orr		r10,r10,r2		; r10 = combined sign bit
		mov		pc,r14			; return to caller
		
compareTNS
		ldr		r0,=TNS 		; r0 = address TNS
		ldr		r1,[r0]			; r1 = valule at address r0
		teq		r10,r1			; set zero flag if equal
		mov 	pc,r14			; return to caller
		
compareIEEE
		ldr		r0,=IEEE		; r0 = address IEEE
		ldr 	r1,[r0]			; r1 = value at address r0	
		teq		r11,r1			; set zero flag if equal
		mov 	pc,r14			; return to caller		

st		b		st				; continuous loop

TNS			dcd		0x7E000104	; TNS number input
IEEE		dcd		0x41FE0000	; IEEE number input
	
signM		dcd		0x80000000	; universal signmask
TNSmantM	dcd		0x7FFFFE00	; TNS mantissa mask
TNSexpM		dcd		0x000001FF	; TNS exponent mask
IEEEmantM	dcd		0x007FFFFF	; IEEE mantissa mask
IEEEexpM	dcd		0x7F800000	; IEEE exponent mask
	
		END