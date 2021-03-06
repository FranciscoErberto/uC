;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		AD_CON
		CONT
		CONT1
		AUX
		RCONT	;VARIAVEL DE CONTAGEM 
		ADDR	;VARIAVEL PARA DATA RECEBIDO
		
		;NOVAS VARI�VEIS

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
#DEFINE ENDERECO H'03'	;ENDERE�O DO SLAVE
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)
	
#DEFINE SCL GPIO,GP0	;PORTA DO SCL
#DEFINE SCL_IO TRISIO,0 ;BIT DE CONTROLE I/O DO SCL
#DEFINE SDA GPIO,GP1	;PORTA DO SDA
#DEFINE SDA_IO TRISIO,1	;BIT DE CONTROLE I/O DO SDA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

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

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER� ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES
	BTFSS	PIR1, TMR1IF
	GOTO	SAI_INT
	
	MOVFW	AD_CON	;MOSTRAR PORCENTAGEM NO DISPLAY
	;CALL	SHOW_PRECENTAGE_DISPLAY
		
    	MOVLW	.80	;RESETA TIMER
	MOVWF	TMR1H
	MOVLW	.56
	MOVWF	TMR1L
	BCF	PIR1, TMR1IF
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

;CALCULA M�DIA DO VALORES LIDOS /// SOMA(VALORES)/32
MEAN
	CLRF	CONT1
	BSF	CONT1,0
	CLRF	AUX
	MOVLW	B'00110110'	 
	MOVWF	FSR
	MOVFW	INDF	
	
MEAN_INNER
	INCF	FSR
	ADDWF	INDF,W
	BTFSC	STATUS,C
	INCF	AUX
	INCF	CONT1	    ;ADCIONA OS VALORES LIDOS AO WORK
	BTFSS	CONT1,5	    ;USANDO A VARIAVEL AUX COMO PARTE ALTA
	GOTO	MEAN_INNER  
	INCF	FSR	    
	MOVWF	INDF
	
	RRF	AUX	    ;DIVIDINDO SOMA POR 32 (5 ROTATES PARA DIREITA)
	RRF	INDF	    ;COMO TEM BITS MAIS SIGNIFICATIVOS NA VAR AUX
			    ;USO O VALOR DO ROTATE RIGHT PARA PASSAR O BIT
	RRF	AUX	    ;MENOS SIGNIFICATIVO DA PARTE ALTA PARA O C
	RRF	INDF	    ;E PASSA ESSE BIT PARA A PARTE MAIS SIGNIFICATIVA
			    ;DA PARTE BAIXA
	RRF	AUX
	RRF	INDF
	
	RRF	AUX
	RRF	INDF
	
	RRF	AUX
	RRF	INDF
	
	MOVFW	INDF
	RETURN
	
	DELAY_100US
	MOVLW	.40
	MOVWF	CONT

	NOP
	NOP
	DECFSZ	CONT,F
	GOTO	$-3
				
	RETURN
SEND_BYTE
	CLRF	ADDR
	MOVLW	.8	
	MOVWF	RCONT
R_LOOP
	BTFSC	SDA	    ;ESPERA BORDA DE SUBIDA DO SCL
	GOTO	$-1
	BTFSS	SDA
	GOTO	$-1
	BSF	STATUS,C    ;LIMPA CARRY
	BTFSC	SCL	    ;SE SDA ESTIVER ATIVO
	BSF	STATUS,C    ;SETA CARRY
	RLF	ADDR	    ;ROTACIONA CARRY PARA REGISTRADOR ADDR
	DECFSZ	RCONT	    ;REPERE POR 8 VEZES
	GOTO	R_LOOP
	
	RETURN
	
ACK
	BTFSC	SCL	    ;ESPERA CLOCK ESTAR EM LOW  
	GOTO	$-1
	BANK1
	BCF	SDA_IO	    ;MUDA PORTA DO SDA PARA SA�DA
	BANK0
	BCF	SDA	    ;MANDA ACK, I.E SDA EM LOW
	
	BTFSC	SCL	    
	GOTO	$-1
	BTFSS	SCL	    ;ESPERA CLOCK IR PARA 1, I.E MASTER IR� LER ACK BIT
	GOTO	$-1
	
	BTFSC	SCL	    ;ESPERA CLOCK IR PARA ZERO
	GOTO	$-1
	
	BCF	SCL
	BANK1		
	BCF	SCL_IO	    ;MUDA PORTA DO SCL PARA SA�DA
	BSF	SDA_IO	    ;LIBERA SDA
	BANK0
	BCF	SCL	    ;JOGA CLOCK PARA LOW, MASTER ESPERAR

	
	RETURN
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000111'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS, MAS GP2 COMO ENTRADA
	MOVLW	B'00100100'
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'01000000'
	MOVWF	INTCON		;HABILITA INTERRUP��O E INT DE PERTIFERICOS
	MOVLW	B'00000001'
	MOVWF	PIE1		;HABILITA INTERRUP��O DO TMR1
	
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00100000'	;TMR1 PRESCALE 1:4
	MOVWF	T1CON
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	MOVLW	B'00001001'
	MOVWF	ADCON0 

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	BCF	PIR1, TMR1IF	    ;INICIALIZA TIMER
	BSF	INTCON, GIE
	MOVLW	B'00111100'
	MOVWF	TMR1H
	MOVLW	B'10110000'
	MOVWF	TMR1L
	BSF	T1CON, TMR1ON
	CLRF	GPIO
	
	
	CLRF	CONT1
	MOVLW	B'00111100'	    ;VALORES PARA MEDIA ARMAZENADOS
	MOVWF	FSR		    ;NOS ADDRS 0X36 - 0X56
	BSF	ADCON0, 1 
MAIN_INNER			    ;REPETI��O DE LEITURA DO CANAL DE CONVERS�O			    
	CALL	DELAY_100US
	BTFSC	ADCON0, 1	    ;CHECA SE CONVERS�O ACABOU
	GOTO	$-1
	BSF	ADCON0, 1 
	MOVFW	ADRESH	    ;SE ACABOU, MOVER� PARA A POSI��O DE MEMORIA
	MOVWF	INDF	    ;INDIRETA ATUAL E PASSAR� PARA O PROX ADDR
	INCF	FSR
	INCF	CONT1
	BTFSS	CONT1,5	    ;CASO A CONTAGEM DE 32 AMOSTRA ACABAR
	GOTO	MAIN_INNER  ;ELE COMPUTA A M�DIA
	CALL	MEAN	    
	MOVWF	AD_CON
	
START_BIT
	BTFSS	SDA
	GOTO	START_BIT	;ESPERA START BIT
	BTFSC	SDA
	GOTO	$-1
	BTFSS	SCL
	GOTO	START_BIT
				;START BIT ACHADO
	CALL	SEND_BYTE	;ENVIA BYTE MANDADO PELO MASTER
	BCF	STATUS,C	
	RRF	ADDR
	MOVLW	ENDERECO	;TESTA SE ENDERE�O ENVIADO � O DESIGNADO
	SUBWF	ADDR, W
	BTFSC	STATUS, Z
	
	GOTO	START_BIT   

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
