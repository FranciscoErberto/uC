;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		AD_CON
		CONT
		CONT1
		AUX
		RCONT	;VARIAVEL DE CONTAGEM 
		ADDR	;VARIAVEL PARA DATA RECEBIDO
		
		;NOVAS VARIÁVEIS

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
#DEFINE ENDERECO H'03'	;ENDEREÇO DO SLAVE
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)
	
#DEFINE SCL GPIO,GP0	;PORTA DO SCL
#DEFINE SCL_IO TRISIO,0 ;BIT DE CONTROLE I/O DO SCL
#DEFINE SDA GPIO,GP1	;PORTA DO SDA
#DEFINE SDA_IO TRISIO,1	;BIT DE CONTROLE I/O DO SDA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

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

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES
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

;CALCULA MÉDIA DO VALORES LIDOS /// SOMA(VALORES)/32
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
	BCF	SDA_IO	    ;MUDA PORTA DO SDA PARA SAÍDA
	BANK0
	BCF	SDA	    ;MANDA ACK, I.E SDA EM LOW
	
	BTFSC	SCL	    
	GOTO	$-1
	BTFSS	SCL	    ;ESPERA CLOCK IR PARA 1, I.E MASTER IRÁ LER ACK BIT
	GOTO	$-1
	
	BTFSC	SCL	    ;ESPERA CLOCK IR PARA ZERO
	GOTO	$-1
	
	BCF	SCL
	BANK1		
	BCF	SCL_IO	    ;MUDA PORTA DO SCL PARA SAÍDA
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
	MOVWF	TRISIO		;COMO SAÍDAS, MAS GP2 COMO ENTRADA
	MOVLW	B'00100100'
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'01000000'
	MOVWF	INTCON		;HABILITA INTERRUPÇÃO E INT DE PERTIFERICOS
	MOVLW	B'00000001'
	MOVWF	PIE1		;HABILITA INTERRUPÇÃO DO TMR1
	
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00100000'	;TMR1 PRESCALE 1:4
	MOVWF	T1CON
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW	B'00001001'
	MOVWF	ADCON0 

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
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
MAIN_INNER			    ;REPETIÇÃO DE LEITURA DO CANAL DE CONVERSÃO			    
	CALL	DELAY_100US
	BTFSC	ADCON0, 1	    ;CHECA SE CONVERSÃO ACABOU
	GOTO	$-1
	BSF	ADCON0, 1 
	MOVFW	ADRESH	    ;SE ACABOU, MOVERÁ PARA A POSIÇÃO DE MEMORIA
	MOVWF	INDF	    ;INDIRETA ATUAL E PASSARÁ PARA O PROX ADDR
	INCF	FSR
	INCF	CONT1
	BTFSS	CONT1,5	    ;CASO A CONTAGEM DE 32 AMOSTRA ACABAR
	GOTO	MAIN_INNER  ;ELE COMPUTA A MÉDIA
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
	MOVLW	ENDERECO	;TESTA SE ENDEREÇO ENVIADO É O DESIGNADO
	SUBWF	ADDR, W
	BTFSC	STATUS, Z
	
	GOTO	START_BIT   

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
