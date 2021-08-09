CREATE SEQUENCE seq_om_record_oid
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/

CREATE OR REPLACE PROCEDURE PRC_OM_RECORD_INSERT(iTipo IN NUMBER 
												,iSubTipo IN NUMBER)
AS 
	l_oid NUMBER;
	l_data_criacao DATE;
	l_natureza NUMBER;
	
BEGIN 
	l_oid := seq_om_record_oid.nextval;
	l_data_criacao := sysdate;
	
	BEGIN 
		SELECT natureza 
		  INTO l_natureza
		  FROM om_record_natureza orn
		 WHERE orn.tipo = iTipo
		   AND orn.subtipo = iSubTipo;
		   
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			l_natureza := 0;
	END;
	
	INSERT INTO om_record
	(oid 
	,tipo 
	,subtipo 
	,natureza
	,data_criacao) 
	VALUES 
	(l_oid
	,iTipo
	,iSubTipo
	,l_natureza
	,sysdate);

END;
/

CREATE OR REPLACE TRIGGER TRG_TCALL_I 
AFTER INSERT ON TCALL
REFERENCING NEW AS NEW OLD AS OLD 
FOR EACH ROW 
BEGIN
	PRC_OM_RECORD_INSERT(iTipo => :NEW.tipo 
						,iSubTipo => :NEW.subtipo);
END;
/