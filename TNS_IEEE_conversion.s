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
		ldr		r0,=TNS 		; r0 = address TNS
		ldr		r1,[r0]			; r1 = valule at address r0
		bl		signBit			; branch and link to TNStoIEEE
		bl		TNSfrac			; branch and link to TNSfrac

		b		st				; branch to ending loop
		
signBit
		ldr		r0,=signM		; r0 = address signMask
		ldr		r12,[r0]		; r12 = signMask value
		and		r2,r1,r12		; r2 = TNS sign bit
		mov		pc,r14			; return to caller

TNSfrac
		ldr		r0,=TNSfracM	; r0 = address TNSfracM
		ldr		r12,[r0]		; r12 = TNSfracM value
		and		r3,r1,r12		; r3 = TNS fraction
		mov		pc,r14			; return to caller




st		b		st

TNS			dcd		0x64000103
IEEE		dcd		0x41640000
signM		dcd		0x80000000
TNSfracM	dcd		0x7FFFFE00
	
		END