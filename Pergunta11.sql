/*Criação das sequences*/

CREATE SEQUENCE SEQ_EQUIPES_OID
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 /
 
 CREATE SEQUENCE SEQ_TAREFA_HEADER_OID
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 /
 
 CREATE SEQUENCE SEQ_PROCESSO_LOG_OID
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 /
 
 /*Criação das principais tabelas*/
 CREATE TABLE EQUIPES
(
	OID NUMBER,
	NOME VARCHAR2(100),
	NOME_B1 VARCHAR2(100),
	NOME_B2 VARCHAR2(100),
	NOME_B3 VARCHAR2(100),
	STATUS NUMBER,
	
	CONSTRAINT PK_EQUIPES PRIMARY KEY (OID)
);
/

CREATE TABLE TAREFA_HEADER
(
	OID NUMBER,
	NOME VARCHAR2(100),
	DATA_CRIACAO DATE,
	AREA VARCHAR2(303),
	EQUIPE_RESPONSAVEL NUMBER,
	
	CONSTRAINT PK_TAREFA_HEADER PRIMARY KEY (OID),
	CONSTRAINT FK_TAREFA_EQUIPES_OID
		FOREIGN KEY(EQUIPE_RESPONSAVEL)
		REFERENCES EQUIPES(OID)
);
/

CREATE TABLE PROCESSO_LOG
(
	OID NUMBER,
	DATA SYSDATE,
	CODIGO NUMBER,
	DESCRICAO VARCHAR2(500),
	
	CONSTRAINT PK_PROCESSO_LOG PRIMARY KEY (OID)
);
/

/*Criação da package com a lógica do sistema*/
CREATE OR REPLACE PACKAGE OM_PKG_TASK 
AS
	FNC_CRIA_TAREFA(iNome IN VARCHAR2
				   ,iArea IN VARCHAR2) RETURN NUMBER;

END;
/

CREATE OR REPLACE PACKAGE BODY OM_PKG_TASK 
AS
	FUNCTION FNC_CRIA_TAREFA(iNome IN VARCHAR2
							,iArea IN VARCHAR2) RETURN NUMBER 
	AS
		l_tarefa_oid NUMBER;
		l_equipe_oid NUMBER;
		l_log_oid NUMBER;
		l_equipe_status NUMBER;
		l_retornoFunc NUMBER;
		l_data_criacao DATE;
		
	BEGIN 
		l_tarefa_oid := SEQ_TAREFA_HEADER_OID.NEXTVAL;
		l_data_criacao := SYSDATE;
		l_log_oid := SEQ_PROCESSO_LOG_OID.NEXTVAL;
		
		BEGIN 
			SELECT e.oid, e.status
			INTO l_equipe_oid, l_equipe_status
			FROM equipes e 
			WHERE iArea = e.nome_b1 || '/' || e.nome_b2 '/' || e.nome_b3;
			
			IF l_equipe_status = 0 THEN 
				l_equipe_oid := 0;
				l_retornoFunc := -2;
			ELSE 
				l_retornoFunc := 0;
			END IF;
			
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN 
				l_retornoFunc := -1;
				l_equipe_oid := 0;
		END;
		
		INSERT INTO TAREFA_HEADER
		(OID 
		,NOME
		,DATA_CRIACAO 
		,AREA
		,EQUIPE_RESPONSAVEL)
		VALUES 
		(l_tarefa_oid
		,iNome
		,l_data_criacao
		,iArea
		,l_equipe_oid
		);
		
		INSERT INTO PROCESSO_LOG
		(OID 
		,DATA
		,CODIGO
		,DESCRICAO)
		VALUES 
		(l_log_oid
		,l_data_criacao
		,l_retornoFunc
		,'Tarefa ' || NOME || ' Criada com sucesso.');
		
		COMMIT;
		
		RETURN l_retornoFunc;
		
	EXCEPTION 
		WHEN OTHERS THEN 
			ROLLBACK;
			RAISE;
	END FNC_CRIA_TAREFA;

END;
/

/*Criação do bloco anônimo de chamada*/
DECLARE 
	l_sqlCode NUMBER;
	l_sqlErrm VARCHAR2(4000);
	
BEGIN 
	OM_PKG_TASK.FNC_CRIA_TAREFA(iNome => 'Tarefa X',
								iArea => 'MT_07019/13TRF/E08796');
	
	DBMS_OUTPUT.PUT_LINE('Registro incluído com sucesso!');
EXCEPTION 
	l_sqlCode := SQLCODE;
	l_sqlErrm := SQLERRM;
	
	WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE('Não foi possível incluir a tarefa no sistema.' || CHR(10) ||
							 'Codigo de erro: ' || l_sqlCode || CHR(10) || 
							 'Mensagem de erro: ' || l_sqlErrm);
END;
/

