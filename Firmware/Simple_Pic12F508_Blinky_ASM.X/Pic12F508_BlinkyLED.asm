; **************************************************
; Project: Blinky LED for PIC12F508
; Goal: Let the onboard LED blink. LED is at Pin GP2
; Runs at 4 Mhz, 1 Mhz per instruction cycle
; **************************************************

    
#include <xc.inc>
    
#define LED_GREEN     GPIO,2
    
; Configuration:
;       no codeprotection
;       no WDT-Timer
;       no Reset-Pin
;	internal Oszillator 

config CP = OFF
config WDT = OFF
config MCLRE = ON  
config OSC = IntRC

    
;***********************************************************************
; data memory space:   07h - 1FH PIC12F08  

;define Variable names
PSECT udata, class=RAM, space=1
delay_val:     ds 1    ; reload value for the loop counters
delay2_var:    ds 1    ; variable for the inner 2 ms loop
delay500_var:  ds 1    ; variable for the outer 500 ms loop
 
   
;*******************************************************
; Begin programmcode
; GP3-In, GP0-2,GP4,GP5 OUT = 08H
    

;use custom psect to force linker to put this section at the reset vector
PSECT prog_code, abs, ovrld, class=CODE, delta=2

org     0x0000	;necessary otherwise linker puts entry_code section at this address

START: 
    MOVWF   OSCCAL          ; calibrate Oszillator
 
;Init **********************************************************************
    ;set variables
    ;Delay_Variable
    MOVLW 0xFA	;write value FAh (250dec) in W reg
    MOVWF delay_val ; write W into delay_val
 
    ;40H in W, Prescaler assigned to Timer, Prescaler set to 1/2, disable Wake_up on pin change, no Pull-Ups, Timer Transisition on internal clock
    MOVLW	0x40  
    OPTION		;W in Optionregister
 
    CLRF	GPIO	;set all output GPIO values to zero
    MOVLW	0x08	;write 08H to W-Register
    TRIS	GPIO	;write W to TRIS-Register set  GP0-2,3,4 as output
 
 ; Init End ****************************************************************

;*******************************************************
MAIN:
    BSF	    LED_GREEN	    ;turn on LED
    CALL    DELAY_500       ;wait 500 ms
    BCF	    LED_GREEN	    ;turn off LED
    CALL    DELAY_500       ;wait 500 ms
 
    GOTO    MAIN
 
;delay loops *******************************************************
PSECT entryCode,class=ENTRY,delta=2
;loop duration 2ms
DELAY_2:
    MOVF delay_val, W	;write value 250 from delay_val to W
    MOVWF delay2_var	;write W to Register delay2_var
DELAY_2_START:		;duration 8 cycles => 8 * 250 = 2 ms delay
    NOP
    NOP
    NOP
    NOP
    NOP
    DECFSZ delay2_var, F ;delay2_var -= 1
    GOTO DELAY_2_START
    RETLW   0

; delay 500 ms
DELAY_500:
    MOVF delay_val, W	;write value 250 from delay_val to W
    MOVWF delay500_var	; write W to Register delay500_var
DELAY500_START:
    Call DELAY_2 
    DECFSZ delay500_var, F ;delay500_var -= 1
    GOTO DELAY500_START
    RETLW   0  