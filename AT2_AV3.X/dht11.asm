;ADAPTA��O DO ARQUIVO 12F675 PARA O P�C 16F628A

	
;ALUNO: FRANCISCO ERBERTO DE SOUSA
;PROFESSOR: MARDSON 
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	#include <p16F628a.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675
	
	
	__CONFIG _XT_OSC & _WDT_ON & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_OFF
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA
	CBLOCK 0x0C	    ;ENDERE�O INICIAL DA MEM�RIA DE USU�RIO
	    W_TEMP	    ;REGISTRADORES TEMPOR�RIOS PARA USO 
	    STATUS_TEMP	    ;JUNTO �S INTERRUP��ES
	    
	    ;NOVAS V�RIAVEIS
	    
		D1		;VARIAVEL PARA ENVIO
		D2
		DHTBITCOUNT
		DHTBYCOUNT
		DHTBYTE
		
		
		;VARIVEL PARA TESTE
		TIMER
		

	    
	ENDC		    ;FIM DO BLOCO DE MEM�RIA 
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

	;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)


	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)
#DEFINE DHT11	PORTA, 0	    ;DEFININDO A PORTA DO SENSOR DE TEMPERATURA E UMIDADE 
#DEFINE DHT11_T	TRISA, 0	    ;DEFININDO A PORTA DO SENSOR DE TEMPERATURA E UMIDADE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO

	;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04		;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER� ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.
	
DISPLAY
	

;ROTINA PARA CONVERTER DE BIN�RIO PARA DECIMAL 
CONVERTE
	
	MOVF	TIMER, W ;NESTE CASO � O VALOR RECEBIDO PELO DHT11
	ANDLW	D'9'	 ;NIVEL MAIS SIGNIFICATIVO 
	
	
	ADDWF		PCL,F	  ;PCL = PCL + W (BITS MENOS SIGNIFICATIVOS)
	RETLW		B'11101110'	;RETORNA S�MBOLO '0'
	RETLW		B'00101000'	;RETORNA S�MBOLO '1'
	RETLW		B'11001101'	;RETORNA S�MBOLO '2'
	RETLW		B'01101101'	;RETORNA S�MBOLO '3'
	RETLW		B'00101011'	;RETORNA S�MBOLO '4'
	RETLW		B'01100111'	;RETORNA S�MBOLO '5'
	RETLW		B'11100111'	;RETORNA S�MBOLO '6'
	RETLW		B'00101100'	;RETORNA S�MBOLO '7'
	RETLW		B'11101111'	;RETORNA S�MBOLO '8'
	RETLW		B'01101111'	;RETORNA S�MBOLO '9'
	
	
	
	
MODULO_DHT11
	NOP
	;CALL	DELAY1SEC		  	
	;CALL	DELAY1SEC

	MOVLW	0x04			; CONTADOR DE TIMER 
	MOVWF	DHTBYCOUNT
	
	
		BCF	INTCON, GIE     ; DESABILITA INTERRUP��O 

		BCF 	DHT11_T	
		BCF	DHT11		; off por 18ms, ao fim dos 18MS inicia o sinal    
		CALL	DELAY18MS	; SW = 18.02ms 
		BSF	DHT11		; liga a porta 
		NOP			
		NOP			    
		
		BSF	DHT11_T		;transforma em entrada
		BCF	DHT11
		
		MOVLW	0x08		; Delay de 40us - PROCURE RESPOSTA DHT LOW DENTRO DE 40US
		MOVWF	D1		; SW = 49us
DHT40	
		BTFSS	DHT11		; linha deve ir LOW dentro de 40us	
		GOTO	DHT80L
		DECFSZ	D1, F
		GOTO	DHT40
		GOTO	DHTERROR	; tempo estourado
		
		
DHT80L	
		CALL	DELAY40US	; delay para 40us - DHT HIGH depois 80us
		MOVLW	0x08
		MOVWF	D1		; SW = 49us   - Verifica
DHT40L
		BTFSC	DHT11		; ENT�O TENSTA A SUBIDA high NOS 40us	
		GOTO	DHT80H
		decfsz	D1, F
		GOTO	DHT40L
		GOTO	DHTERROR	; TEMPO ESTOURADO
		
DHT80H
		CALL	DELAY40US	; delay para 40us - DHT vai para LOW depois 80us
		MOVLW	0x08
		MOVWF	D1		; SW = 49us verifica subida
DHT40H	
		BTFSS	DHT11		; verifica a descida depois dos 40us, tempo total de 80us	
		GOTO	DHTDATA		; DTH 	primeiro dado 50us LOW detectado (coleta os stream de dados) 
		DECFSZ	D1, F
		GOTO	DHT40H
		GOTO	DHTERROR	; tempo estourado
		
DHTDATA					; Lopp do Stream de Dados
		MOVLW	0x08		
		MOVWF	DHTBITCOUNT
		
DHTDATA_BYTELOOP
		MOVLW	0x0A		; Delay de 50us
		MOVWF	D1		; SW = 62us
		
DHT50H
		BTFSC	DHT11		; verifica se subiu nos proximo 50us  
		GOTO	DHTDH
		DECFSZ	D1, F
		GOTO	DHT50H
		GOTO	DHTERROR	; tempo estourado
		
DHTDH		MOVLW	0x06		; delay 27US. Houve troca entre a subida e a decida ?			
		MOVWF	D1		; SW = 37us						
															
DHTDHZ	
		BTFSS	DHT11		; Verifica se houve descida nos 30us  
		GOTO	DHTZERO		; Espera que nos 35us venha zeros 
		DECFSZ	D1, F
		GOTO	DHTDHZ

		MOVLW	0x07		;  Outro delay 40us - Espera que nos 70us venha 1
		MOVWF	D1		; SW = 43us  tempo total em HIGH  37+43= 80us
		
DHTDH1	
		BTFSS	DHT11		    ;  Verifica se houve descida nos 30us  
		GOTO	DHTONE		    ;  DADOS DESEJADOS DENTRO DE 35US ASSIM DEVE SER ZERO
		DECFSZ	D1, F
		GOTO	DHTDH1
		GOTO	DHTERROR	    ; tempo estourado

DHTZERO
		BCF	STATUS,C	    ;  add zero to byte
		GOTO	DHTADDBIT
DHTONE	
		BSF	STATUS,C	    ; add um to byte
DHTADDBIT
		RLF	DHTBYTE,F
		DECF	DHTBITCOUNT,F
		GOTO	DHTDATA_BYTELOOP


DHTERROR	

        BSF	INTCON, GIE    	    ; habilita Global Interrupts
	
	RETURN
	

DELAY40US
		MOVLW	0x0b
		MOVWF	D1	
DLY40US		
		DECFSZ	D1, F
		GOTO	DLY40US
		NOP
		RETURN


; Delay = 0.018 seconds
; Clock frequency = 4 MHz

DELAY18MS
	MOVLW	0x0F
	MOVWF	D1
	MOVLW	0x0F
	MOVWF	D2
DELAY18L
	DECFSZ	D1, F
	GOTO	DLY182
	DECFSZ	D2, F
DLY182	
	GOTO	DELAY18L

	RETURN
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1		    ;ALTERA PARA O BANCO 1
	MOVLW	B'00000011'
	MOVWF	TRISA	    ;DEFINE ENTRADAS E SA�DAS DA PORTA 
	MOVLW	B'00000000'
	MOVWF	TRISB	    ;DEFINE ENTRADAS E SA�DAS DA PORTB
	MOVLW	B'00000000'
	MOVWF	OPTION_REG  ;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON	    ;DEFINE OP��ES DE INTERRUP��ES
	BANK0		    ;ALTERA PARA O BANCO 0
	MOVLW	B'00000111' 
	MOVWF	CMCON	    ;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	
	;CORPO DA ROTINA PRINCIPAL
	
	GOTO MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     FIM DO PROGRAMA                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END