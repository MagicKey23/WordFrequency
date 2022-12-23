			AREA Lab12, CODE, READONLY
			ENTRY
			
	
main	    LDR R4, =table

GetFrequency

			MOV R6, #12 ;access
			MOV R3, #14
			MOV R5, #2;i
			CMP R5, #0
			BGT increment14
			
			LDRH    R6, [R4, R6]; grab first one
			MOV 	R0, R6
			
increment14
			
			MUL 	R7, R5, R3 
			ADD 	R6, R6, R7		;grab freq bigger than 1	
			LDRH    R6, [R4, R6]     
			MOV 	R0, R6
			
        
				


GetWordAtI	
			LDR R10,=0x40000000
			MOV R8, #14
			MOV R6, #0;NullPtr
			MOV R3, #1 ; this is i
			MOV R7, #0
			CMP R3, #1
			BGE Greater
			MOV R3, #0;
strcopy
		
			LDRB R5, [R4, R7]
			STRB R5, [R10, R3]
			CMP R5, #0
			ADD R7, R7, #1
			ADD R3, R3, #1
			BNE strcopy
			b done
			
Greater		
			MUL R7, R3, R8
			MOV R3, #0
strcopy2			
			
			LDRB R5, [R4, R7]
			STRB R5, [R10,R3]
			CMP R5, #0
			ADD R7, R7, #1
			ADD R3, R3, #1
			CMP R5, #0
			BNE strcopy2
			b done
done
			STRB R6, [R0],#1
			

CountItem	

			MOV R3, #0 ;count
			MOV R5,	#0
			
			
LOOP2		LDRB R6, [R4,R5]
			CMP R6, #0
			BEQ LEAVE
			ADD R3, R3, #1
			ADD R5, R5, #14
			B LOOP2
			
LEAVE	


SumFrequencies 
		
			MOV R3, #0 ;count
            MOV R7, #0 ; total
            MOV R6, #12 ;access data
           
            ;GET FIRST ITEM AT Address 12
            LDRH R5, [R4,R6]
            ADD R7, R7, R5
            ADD R3, R3, #1
loop        
            CMP R3, #4
            BEQ EXIT    
            ;Go through other frequency
            ADD R6, R6, #14
            LDRH R5, [R4,R6]
            ADD R7, R7, R5
            ADD R3, R3, #1
        
            b loop 
					
				
EXIT           



			ALIGN               ; Force word alignment of data table
table       DCB "Toyota",0
            SPACE 5            ; BYTES added to for 14-byte table rows
            DCW 8               ; Frequency always at 12 byte offset
            DCB "Honda",0
            SPACE 6
            DCW 18
            DCB "Mercedes",0
            SPACE 3
            DCW 30
            DCB "Audi",0
            SPACE 7
            DCW 12
            DCB 0               ; marker to indi
            END
    