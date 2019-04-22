;ADAPTAÇÃO DO ARQUIVO 12F675 PARA O PÍC 16F628A

	
;ALUNO: FRANCISCO ERBERTO DE SOUSA
;PROFESSOR: MARDSON 
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	#include <p16F628a.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675
	
	
	__CONFIG _XT_OSC & _WDT_ON & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_OFF
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA
	CBLOCK 0x0C	    ;ENDEREÇO INICIAL DA MEMÓRIA DE USUÁRIO
	    W_TEMP	    ;REGISTRADORES TEMPORÁRIOS PARA USO 
	    STATUS_TEMP	    ;JUNTO ÀS INTERRUPÇÕES
	    
	    ;NOVAS VÁRIAVEIS
	    
		D1		;VARIAVEL PARA ENVIO
		D2
		DHTBITCOUNT
		DHTBYCOUNT
		DHTBYTE
		
		
		;VARIVEL PARA TESTE
		TIMER
		

	    
	ENDC		    ;FIM DO BLOCO DE MEMÓRIA 
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

	;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)


	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)
#DEFINE DHT11	PORTA, 0	    ;DEFININDO A PORTA DO SENSOR DE TEMPERATURA E UMIDADE 
#DEFINE DHT11_T	TRISA, 0	    ;DEFININDO A PORTA DO SENSOR DE TEMPERATURA E UMIDADE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO

	;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04		;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.
	
DISPLAY
	

;ROTINA PARA CONVERTER DE BINÁRIO PARA DECIMAL 
CONVERTE
	
	MOVF	TIMER, W ;NESTE CASO É O VALOR RECEBIDO PELO DHT11
	ANDLW	D'9'	 ;NIVEL MAIS SIGNIFICATIVO 
	
	
	ADDWF		PCL,F	  ;PCL = PCL + W (BITS MENOS SIGNIFICATIVOS)
	RETLW		B'11101110'	;RETORNA SÍMBOLO '0'
	RETLW		B'00101000'	;RETORNA SÍMBOLO '1'
	RETLW		B'11001101'	;RETORNA SÍMBOLO '2'
	RETLW		B'01101101'	;RETORNA SÍMBOLO '3'
	RETLW		B'00101011'	;RETORNA SÍMBOLO '4'
	RETLW		B'01100111'	;RETORNA SÍMBOLO '5'
	RETLW		B'11100111'	;RETORNA SÍMBOLO '6'
	RETLW		B'00101100'	;RETORNA SÍMBOLO '7'
	RETLW		B'11101111'	;RETORNA SÍMBOLO '8'
	RETLW		B'01101111'	;RETORNA SÍMBOLO '9'
	
	
	
	
MODULO_DHT11
	NOP
	;CALL	DELAY1SEC		  	
	;CALL	DELAY1SEC

	MOVLW	0x04			; CONTADOR DE TIMER 
	MOVWF	DHTBYCOUNT
	
	
		BCF	INTCON, GIE     ; DESABILITA INTERRUPÇÃO 

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
		BTFSC	DHT11		; ENTÃO TENSTA A SUBIDA high NOS 40us	
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
	MOVWF	TRISA	    ;DEFINE ENTRADAS E SAÍDAS DA PORTA 
	MOVLW	B'00000000'
	MOVWF	TRISB	    ;DEFINE ENTRADAS E SAÍDAS DA PORTB
	MOVLW	B'00000000'
	MOVWF	OPTION_REG  ;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON	    ;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0		    ;ALTERA PARA O BANCO 0
	MOVLW	B'00000111' 
	MOVWF	CMCON	    ;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
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