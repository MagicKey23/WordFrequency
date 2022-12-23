            AREA asm_func, CODE, READONLY
         
//         R1 int32_t CountItems();
//         R2 int32_t SumAllFrequencies();
//         R3 uint8_t * GetWordAt(int32_t i);   // NOTE: returns a pointer to a string
//         R4 int16_t GetFreqAt(int32_t i);      // NOTE: return the value of the frequency count   
//         HEADER: KANEY NGUYEN
//          PROJECT LEARN IS ABOUT HOW TO GRAB DATA from the table and able manipulate the data adress
 
       
            //----------------
            GLOBAL CountItems
            ;int32_t CountItems()
    
CountItems   
            ;PUSH ON STACK 
            PUSH{R3}
            PUSH{R4}
            PUSH{R5}
            PUSH{R6}
            LDR R4,=table ;LOAD THE table
            MOV R3, #0 ;count 
            MOV R5, #0 ; data acessor
            MOV R6, #0 ; data from the memory
            
LOOP2       LDRB R6, [R4,R5]
            CMP R6, #0          ;if find nullptr leave else keep counting
            BEQ LEAVE           
            ADD R3, R3, #1
            ADD R5, R5, #14
            B LOOP2
            
LEAVE       
            MOV R0, #4
            ;REMOVE everything from the stack
            POP{R6}
            POP{R5}
            POP{R4}
            POP{R3}
            BX LR
            
          //-------------------
            GLOBAL SumFrequencies
            ;int32_t SumFrequencies()
SumFrequencies 
            PUSH{R3}
            PUSH{R7}
            PUSH{R6}
            PUSH{R4}
            PUSH{R5}
            MOV R3, #0 ;table counter 
            MOV R7, #0 ; total
            MOV R6, #12 ;access data
            MOV R5, #0 ;; Data from table
            
            LDR R4, =table
            ;GET FIRST ITEM AT Address 12
            LDRH R5, [R4,R6]    
            ADD R7, R7, R5  ;grab the first data from the table at address 12 add it
            ADD R3, R3, #1 ; add 1 counter to the table
loop        
            CMP R3, #4 ;; stop the counting when hit 4
            BEQ EXIT    
            ;Go through other frequency
            ADD R6, R6, #14 ; other freq start at #14 after #12
            LDRH R5, [R4,R6]
            ADD R7, R7, R5
            ADD R3, R3, #1
            
            b loop  
            
EXIT        MOV R0, R7  
            POP{R7}
            POP{R6}
            POP{R4} 
            POP{R5}
            POP{R3}
           
           
                 
           
            BX LR
            
            GLOBAL GetWordAt
            ;uint8_t * GetWordAt(int32_t i)     
                
GetWordAt     
            PUSH{R3}
            PUSH{R4}
            PUSH{R5}
            PUSH{R6}
            PUSH{R7}
            PUSH{R8}
            
            MOV R5, #0; Data from the table
            MOV R8, #14;location of the string
            MOV R6, #0;nullPTR
            MOV R7, #0 ; use as an acessor for higher than 0
            CMP R0, #1 ; i 
            BGE Greater
            
            
            MOV R3, #0;
            ;STRING COPY, COPY STRING FROM THE TABLE TO R0
            
strcopy
        
            LDRB R5, [R4, R7]
            STRB R5, [R0],#1
            ADD R7, R7, #1
            CMP R5, #0
            BNE strcopy
            b done
            
Greater     ;;GREATER THAN 1, start at at the address of i*14
            MUL R7, R0, R8
           
strcopy2            
            
            LDRB R5, [R4,R7]
            STRB R5, [R0],#1
            ADD R7, R7, #1
            CMP R5, #0
            BNE strcopy2 ;; Not hit null ptr? keep going
            b done
done        
            STRB R6, [R0],#1 ;; ADD NULLPTR TO R0
            
       

            POP{R8}
            POP{R7}
            POP{R6}
            POP{R5}
            POP{R4}
            POP{R5}
            POP{R3}
            
            BX LR
           
          GLOBAL GetFreqAt 
          ;int16_t GetFreqAt(int32_t i); 
GetFreqAt  
            
            LDR R4, =table        ;LOAD TABLE   
            MOV R6, #12 ;access
            MOV R7, #0; INITALIZE R7 to use as access data for value more than 1
            MOV R3, #14
            CMP R0, #0;
            BGT increment14
            
            LDRH    R6, [R4, R6]; grab first one ;; Get first
            MOV     R0, R6
            
            b stop
increment14            
            MUL     R7, R0, R3
            ADD     R6, R6, R7     ;grab freq bigger than 1    
            LDRH    R6, [R4, R6]     
            
stop        
            MOV     R0, R6 
            BX LR           
              
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
    
                
    