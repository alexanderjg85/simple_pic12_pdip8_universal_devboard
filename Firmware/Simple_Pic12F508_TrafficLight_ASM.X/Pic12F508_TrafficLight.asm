; **************************************************
; Project: Traffic Light for PIC12F508
; Goal: Let a green, yellow and red LED blink like
;       a traffic light. LED are at Pin GP0,GP1,GP4
; Runs at 4 Mhz, 1 Mhz per instruction cycle
; **************************************************

#include <xc.inc>
    
#define LED_RED	    GPIO,0
#define LED_YELLOW  GPIO,1
#define LED_GREEN   GPIO,4
    
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
delay4_var:    ds 1    ; variable for the inner 4 ms loop
delay1000_var:  ds 1    ; variable for the outer 1000 ms loop
    
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
    CALL    LIGHT_RED	    ;Red LED lights for 3 seconds
    CALL    DELAY_1000      ;wait 1000 ms
    CALL    DELAY_1000      ;wait 1000 ms
    CALL    DELAY_1000      ;wait 1000 ms
    CALL    LIGHT_YELLOW_RED  ;wait for one second before turning green
    CALL    DELAY_1000      ;wait 1000 ms
    CALL    LIGHT_GREEN	    ;Red LED lights for 3 seconds
    CALL    DELAY_1000      ;wait 1000 ms
    CALL    DELAY_1000      ;wait 1000 ms
    CALL    DELAY_1000      ;wait 1000 ms
    CALL    LIGHT_YELLOW    ;wait for one second before turning red
    CALL    DELAY_1000      ;wait 1000 ms
 
    GOTO    MAIN
    
;delay loops *******************************************************
PSECT entryCode,class=ENTRY,delta=2
;loop duration 2ms
DELAY_4:
    MOVF delay_val, W	;write value 250 from delay_val to W
    MOVWF delay4_var	;write W to Register delay4_var
DELAY_4_START:		;duration 8 cycles => 16 * 250 = 4 ms delay
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    DECFSZ delay4_var, F ;delay4_var -= 1
    GOTO DELAY_4_START
    RETLW   0

; delay 1000 ms
DELAY_1000:
    MOVF delay_val, W	;write value 250 from delay_val to W
    MOVWF delay1000_var	; write W to Register delay1000_var
DELAY1000_START:
    Call DELAY_4
    DECFSZ delay1000_var, F ;delay1000_var -= 1
    GOTO DELAY1000_START
    RETLW   0 
    
;functions for the lighting patterns **********************************
;Function LIGHT_GREEN only green LED lights up
LIGHT_GREEN:
    BSF LED_GREEN   ;on
    BCF LED_YELLOW  ;off
    BCF LED_RED	    ;off
    RETLW   0

;Function LIGHT_YELLOW only yellow LED lights up
LIGHT_YELLOW:
    BCF LED_GREEN   ;off
    BSF LED_YELLOW  ;on
    BCF LED_RED	    ;on
    RETLW   0

;Function LIGHT_RED only red LED lights up
LIGHT_RED:
    BCF LED_GREEN   ;off
    BCF LED_YELLOW  ;off
    BSF LED_RED	    ;on
    RETLW   0

;Function LIGHT_YELLOW_RED red and yellow LED lights up
LIGHT_YELLOW_RED:
    BCF LED_GREEN   ;off
    BSF LED_YELLOW  ;on
    BSF LED_RED	    ;on
    RETLW   0