DROP DATABASE IF EXISTS staffevaluation;

CREATE DATABASE staffevaluation;

USE staffevaluation;

CREATE TABLE user(
    username VARCHAR(12) NOT NULL,
    password VARCHAR(5) NOT NULL,
    name VARCHAR(25),
    surname VARCHAR(35),
    email VARCHAR(30),
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                               /* AYTOMATH XRHSH HMEROMHNIAS EGGRAFHS */
    userkind ENUM('MANAGER','EVALUTOR','EMPLOYEE','ADMINISTRATOR'),
    INDEX UK(userkind),
    PRIMARY KEY (username)
);

CREATE TABLE company(
    AFM CHAR(9) NOT NULL,
    DOY VARCHAR(15),
    compname VARCHAR(35),
    phone BIGINT(16),

    country VARCHAR(15),
    street VARCHAR(15),
    num TINYINT(4),
    city VARCHAR (15),

/*  edra VARCHAR(45) GENERATED ALWAYS AS (CONCAT(country,street,num,city)),*/
    PRIMARY KEY(AFM)
);

CREATE TABLE manager(
    manager_username VARCHAR(12) NOT NULL,
    exp_years TINYINT(4),
    AFM CHAR(9) NOT NULL,
    PRIMARY KEY (manager_username),
    CONSTRAINT const1
    FOREIGN KEY(manager_username) 
    REFERENCES user(username)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT const2
    FOREIGN KEY(AFM)
    REFERENCES company(AFM)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE evaluator(
    evaluator_username VARCHAR(12) NOT NULL,
    AFM CHAR(9) NOT NULL,
    exp_years TINYINT(4) NOT NULL,
    average_grade FLOAT(4,1),
    PRIMARY KEY (evaluator_username),
    CONSTRAINT const3
    FOREIGN KEY(evaluator_username)
    REFERENCES user(username)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT const4
    FOREIGN KEY(AFM)
    REFERENCES company(AFM)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE employee(
    empl_username VARCHAR(12) NOT NULL,
    AFM CHAR(9) NOT NULL,
    bio TEXT,
    sistatikes VARCHAR(35),
    certificates VARCHAR(35),
    awards VARCHAR(35),
    PRIMARY KEY(empl_username),
    CONSTRAINT const5
    FOREIGN KEY(AFM)
    REFERENCES company(AFM)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT const6
    FOREIGN KEY(empl_username)
    REFERENCES user(username)
    ON DELETE CASCADE ON UPDATE CASCADE    
);

CREATE TABLE languages(
    employee VARCHAR(12) NOT NULL,
    lang set('EN','FR','SP','GR'),
    PRIMARY KEY(employee,lang),
    CONSTRAINT const17
    FOREIGN KEY(employee)
    REFERENCES employee(empl_username)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE job(
    job_id INT(4) NOT NULL AUTO_INCREMENT,
    AFM CHAR(9) NOT NULL,
    evaluator_username VARCHAR(12) NOT NULL,
    salary FLOAT(6,1),
    position VARCHAR(40),
    edra VARCHAR(45), 
    announce_date DATETIME DEFAULT NOW(),
    SubmissionDate DATE NOT NULL,
    PRIMARY KEY(job_id,AFM),
    INDEX SUB(SubmissionDate),
    CONSTRAINT const7
    FOREIGN KEY(AFM)
    REFERENCES company(AFM)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT const8
    FOREIGN KEY(evaluator_username)
    REFERENCES evaluator(evaluator_username)
    ON DELETE CASCADE ON UPDATE CASCADE
/*  CONSTRAINT const9
    FOREIGN KEY(edra)
    REFERENCES user(edra)
    ON DELETE CASCADE ON UPDATE CASCADE
*/    
);

CREATE TABLE antikeim(
    title VARCHAR(36) NOT NULL,
    descr TINYTEXT,
    belongs_to VARCHAR(36) NOT NULL,
    PRIMARY KEY(title),
    CONSTRAINT const10
    FOREIGN KEY(belongs_to)
    REFERENCES antikeim(title)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE needs(
    job_id INT(4) NOT NULL,
    antikeim_title VARCHAR(36),
    PRIMARY KEY(job_id,antikeim_title),
    CONSTRAINT const11
    FOREIGN KEY(antikeim_title)
    REFERENCES antikeim(title)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT const12
    FOREIGN KEY(job_id)
    REFERENCES job(job_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE project(
    num TINYINT(4) AUTO_INCREMENT NOT NULL,
    empl_username VARCHAR(12) NOT NULL,
    descr TEXT,
    url VARCHAR(60),
    PRIMARY KEY(num,empl_username),
    UNIQUE (url),
    CONSTRAINT const13
    FOREIGN KEY(empl_username)
    REFERENCES employee(empl_username)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE availablejob(
    empl_username VARCHAR(15) NOT NULL,
    job_id INT(4) NOT NULL,
    PRIMARY KEY(empl_username,job_id), 
    CONSTRAINT const23
    FOREIGN KEY(empl_username)
    REFERENCES employee(empl_username)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT const24
    FOREIGN KEY(job_id)
    REFERENCES job(job_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE requestevaluation(
    empl_username VARCHAR(12) NOT NULL,
    job_id INT(4) NOT NULL,
    SubmissionDate DATE NOT NULL,
    empl_interest BOOL DEFAULT FALSE,
    PRIMARY KEY(empl_username,job_id),
    CONSTRAINT const14
    FOREIGN KEY(empl_username)
    REFERENCES availablejob(empl_username)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT const15
    FOREIGN KEY(job_id)
    REFERENCES job(job_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT const16
    FOREIGN KEY(SubmissionDate)
    REFERENCES job(SubmissionDate)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE degree(
    titlos VARCHAR(50) NOT NULL,
    idryma VARCHAR(40) NOT NULL,
    numgraduates INT(4),
    bathmida ENUM('LYKEIO','UNIV','MASTER','PHD'),
    PRIMARY KEY(titlos,idryma)
);

CREATE TABLE has_degree(
    empl_username VARCHAR(12) NOT NULL,
    degr_title VARCHAR(50) NOT NULL,
    degr_idryma VARCHAR(40) NOT NULL,
    etos YEAR(4),
    grade FLOAT(3,1),
    PRIMARY KEY(degr_title,degr_idryma,empl_username),
    CONSTRAINT const20
    FOREIGN KEY(empl_username)
    REFERENCES employee(empl_username)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT const18
    FOREIGN KEY(degr_title)
    REFERENCES degree(titlos)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT const19
    FOREIGN KEY(degr_idryma)
    REFERENCES degree(idryma)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE evaluationresult(
    Evld INT(4) NOT NULL,
    empl_username VARCHAR(12) NOT NULL,
    evaluator_username VARCHAR(12) NOT NULL,
    job_id INT(4),
    F1 INT(4),
    F2 INT(4),
    F3 INT(4),
    grade INT(4),
    comments VARCHAR(255),
    PRIMARY KEY(Evld,empl_username),
    CONSTRAINT const21
    FOREIGN KEY(empl_username)
    REFERENCES requestevaluation(empl_username)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT const22
    FOREIGN KEY(job_id)
    REFERENCES requestevaluation(job_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE logs(
    order_of_action int(8) auto_increment not null,
    username VARCHAR(12) NOT NULL,
    userkind ENUM('MANAGER','EVALUTOR','EMPLOYEE','ADMINISTRATOR') NOT NULL,
    table_of_incident ENUM('job','employee','evaluationresult') NOT NULL,
    time_of_incident DATETIME,
    type_of_incident ENUM('INSERT','UPDATE','DELETE') not null,
    success enum('YES','NO'),
    PRIMARY KEY(order_of_action,username),
    CONSTRAINT const26    
    FOREIGN KEY(username)
    REFERENCES user(username)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT const25
    FOREIGN KEY(userkind)
    REFERENCES user(userkind)
    ON DELETE CASCADE ON UPDATE CASCADE
);






/*
--edw vale polloys kai meta xwrise toys ana kathgoria
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','saillok@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');
INSERT INTO user VALUES('Saillok','1saillok1','IOANNIS','KOLLIAS','2000-01-07','@gmail.com');

INSERT INTO manager VALUES('Saillok','2000','143792558');
INSERT INTO manager VALUES('Aleksioy','1997','268926487');
INSERT INTO manager VALUES('Petselis','2002','197832746');
INSERT INTO manager VALUES('Tsintsinis','2012','964852314');
INSERT INTO manager VALUES('Karpas','2006','364875613');
INSERT INTO manager VALUES('Xoulis','2015','628731549');

INSERT INTO evaluator VALUES('Kerkidoy','143792558');
INSERT INTO evaluator VALUES('Papagiannhs','143792558');
INSERT INTO evaluator VALUES('Papanikolaoy','268926487');
INSERT INTO evaluator VALUES('Sigoyroy','268926487');
INSERT INTO evaluator VALUES('Afentakh','268926487');
INSERT INTO evaluator VALUES('','197832746');
INSERT INTO evaluator VALUES('','197832746');
INSERT INTO evaluator VALUES('','964852314');
INSERT INTO evaluator VALUES('','964852314');
INSERT INTO evaluator VALUES('','964852314');
INSERT INTO evaluator VALUES('','364875613');
INSERT INTO evaluator VALUES('','364875613');
INSERT INTO evaluator VALUES('','364875613');
INSERT INTO evaluator VALUES('','364875613');
INSERT INTO evaluator VALUES('','628731549');
INSERT INTO evaluator VALUES('','628731549');

INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();
INSERT INTO employee VALUES();

INSERT INTO company VALUES('143792558','NAYFPLIO','SaillokStudio','2752017613','Omiroy','26','Nafplio','Greece');
INSERT INTO company VALUES('268926487','AMAROYSIOY','Oikomat','2103558645','Eyripidi','1','A8hna','Greece');
INSERT INTO company VALUES('197832746','LIBADEIAS','ArgoFarm','2261085946','Konstantinoy','102','Livadeia','Greece');
INSERT INTO company VALUES('964852314','VOLOY','TechItSerious','2421354333','Georgioy','84','Volos','Greece');
INSERT INTO company VALUES('364875613','EDESSAS','Unboxholics','2381058645','Papaflessa','15','Aridaia','Greece');
INSERT INTO company VALUES('628731549','TRIPOLHS','Volt','2710246975','Aigioy','67','A8hna','Greece');
*/


SET @current_username='';
SET @current_userkind='';


/* ERWTHMA 4c */

DELIMITER $
CREATE TRIGGER UsernameChange
BEFORE UPDATE ON user
FOR EACH ROW
BEGIN
	IF (@current_userkind<>'ADMINISTRATOR') THEN
		IF (OLD.username<>NEW.username OR OLD.userkind<>NEW.userkind OR OLD.reg_date<>NEW.reg_date OR OLD.name<>NEW.name OR OLD.surname<>NEW.surname) THEN
			SIGNAL SQLSTATE VALUE '45000' SET message_text = 'DEN EXEIS DIKAIWMATA NA ALLA3EIS AYTHN TIMH';
		END IF;
    END IF;
END$
DELIMITER ;
/* userkind den 3erei ti einai */

/*
CREATE TRIGGER InsertDate
AFTER INSERT ON user
FOR EACH ROW
SET reg_date=CURDATE();
vgazei sfalma reg_date 
*/

/* ERWTHMA 4b */
DELIMITER $
CREATE TRIGGER UnchangeableColumns
BEFORE UPDATE ON company
FOR EACH ROW
BEGIN
	IF (NEW.AFM<>OLD.AFM) THEN
		SIGNAL SQLSTATE VALUE '45000' SET message_text =  'You cannot change this value.';
		Set NEW.AFM=OLD.AFM;
    END IF;
    IF (NEW.DOY<>OLD.DOY) THEN
		SIGNAL SQLSTATE VALUE '45000' SET message_text =  'You cannot change this value.';
        Set NEW.AFM=OLD.AFM;
    END IF;
    IF (NEW.compname <> OLD.compname) THEN
		SIGNAL SQLSTATE VALUE '45000' SET message_text =  'You cannot change this value.';
		Set NEW.compname=OLD.compname;
     END IF;
END$
DELIMITER ;

/* ERWTHMA 4a */

/* INSERT UPDATE DELETE EMPLOYEE */
DELIMITER $
CREATE TRIGGER EmplInsertLog
AFTER INSERT ON employee
FOR EACH ROW
BEGIN
    CALL SuccessLog(@current_userkind,'employee',@current_username,'INSERT');
END$
DELIMITER ;

DELIMITER $
CREATE TRIGGER EmplUpdateLog
AFTER UPDATE ON employee
FOR EACH ROW
BEGIN
    CALL SuccessLog(@current_userkind,'employee',@current_username,'UPDATE');
END$
DELIMITER ;

DELIMITER $
CREATE TRIGGER EmplDeleteLog
AFTER DELETE ON employee
FOR EACH ROW
BEGIN
    CALL SuccessLog(@current_userkind,'employee',@current_username,'DELETE');
END$
DELIMITER ;

/* INSERT UPDATE DELETE DEGREES exw 8ema degr_idryma */

DELIMITER $
CREATE TRIGGER InsertDegree
AFTER INSERT ON has_degree
FOR EACH ROW
BEGIN
    INSERT INTO degree(titlos,idryma,numgraduates) VALUES (NEW.titlos,NEW.idryma,1)
        ON DUPLICATE KEY UPDATE numgraduates=numgraduates+1;
END$
DELIMITER ;

DELIMITER $
CREATE TRIGGER DeleteDegree
AFTER DELETE ON has_degree
FOR EACH ROW
BEGIN
    DECLARE deleted_numgraduates int(4);
    SELECT numgraduates INTO deleted_numgraduates FROM  degree WHERE degree.titlos=OLD.titlos AND degree.idryma=OLD.idryma;
    SET deleted_numgraduates=deleted_numgraduates-1;

    IF (deleted_numgraduates = 0) THEN
        DELETE FROM degree WHERE has_degree.degr_title=OLD.degr_title AND has_degree.degr_idryma=OLD.degr_idryma;
    ELSE
        UPDATE degree SET numgraduates=deleted_numgraduates WHERE degree.titlos=OLD.titlos AND degree.idryma=OLD.idryma;
    END IF;
END$
DELIMITER ;

DELIMITER $
CREATE TRIGGER UpdateDegree
AFTER DELETE ON has_degree
FOR EACH ROW
BEGIN
    DECLARE deleted_numgraduates int(4);
    IF (OLD.titlos <> NEW.titlos or OLD.idryma<>NEW.idryma) THEN
        SELECT numgraduates INTO deleted_numgraduates FROM degree WHERE degree.titlos=OLD.titlos AND degree.idryma=OLD.idryma;
        SET deleted_numgraduates=deleted_numgraduates-1;
        IF (deleted_numgraduates = 0) THEN
	        DELETE FROM degree WHERE has_degree.degr_title=Old.degr_title and  has_degree.degr_idryma=OLD.degr_idryma;
        ELSE
            UPDATE degree set numgraduates=deleted_numgraduates WHERE degree.titlos=OLD.titlos and degree.idryma=OLD.idryma;
        END IF;
        INSERT INTO degree(titlos,idryma,numgraduates) VALUES (NEW.titlos,NEW.idryma,1)
        ON DUPLICATE KEY UPDATE numgraduates=numgraduates+1;
    END IF;
END$
DELIMITER ;

/* APARAITHTES DHLWSEIS GIA JOB */

DELIMITER $
CREATE TRIGGER SendAvailability
AFTER INSERT ON job
FOR EACH ROW
BEGIN
    DECLARE finished bool;
    DECLARE endex_requester VARCHAR(12);

    DECLARE SendCursor CURSOR FOR SELECT empl_username FROM employee WHERE AFM=NEW.AFM;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=FALSE;

    OPEN SendCursor;
    SET finished=TRUE;
    FETCH SendCursor INTO endex_requester;

    WHILE (finished=TRUE) DO
	    INSERT INTO requestevaluation(empl_username,job_id,SubmissionDate) VALUES (endex_requester,NEW.job_id,NEW.SubmissionDate);
	    FETCH SendCursor INTO endex_requester;
    END WHILE;

    CLOSE SendCursor;
END$
DELIMITER ;

DELIMITER $
CREATE TRIGGER SAUpdatedDate
AFTER UPDATE ON job
FOR EACH ROW
BEGIN
    DECLARE finished bool;
    DECLARE endex_requester VARCHAR(12);
    DECLARE SendCursor CURSOR FOR SELECT empl_username FROM employee WHERE AFM=NEW.AFM;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=FALSE;

    IF (OLD.SubmissionDate<>NEW.SubmissionDate) THEN
        OPEN SendCursor;
        SET finished=TRUE;
        FETCH SendCursor INTO endex_requester;
        WHILE (finished=TRUE) do
	        UPDATE requestevaluation SET SubmissionDate=NEW.SubmissionDate
            WHERE requestevaluation.empl_username=endex_requester AND requestevaluation.job_id=NEW.job_id;

            FETCH SendCursor INTO endex_requester;
        END WHILE;
    END IF;
    CLOSE SendCursor;
END $
DELIMITER ;

/* INSERT UPDATE DELETE JOB */
DELIMITER $
CREATE TRIGGER JobInsertLog
AFTER INSERT ON job
FOR EACH ROW
BEGIN
    CALL SuccessLog('job','INSERT');
END$

CREATE TRIGGER JobUpdateLog
AFTER UPDATE ON job
FOR EACH ROW
BEGIN
    CALL SuccessLog('job','UPDATE');
END$

CREATE TRIGGER JobDeleteLog 
AFTER DELETE ON job
FOR EACH ROW
BEGIN
    CALL SuccessLog('job','DELETE');
END$
DELIMITER ;

/* APARAITHTES DHLWSEIS GIA EVALUATION RESULT */
DELIMITER $
CREATE TRIGGER UnchangeableGrade
BEFORE UPDATE ON evaluationresult
FOR EACH ROW
BEGIN
    IF (OLD.grade <> NEW.grade AND OLD.grade IS NOT NULL AND @current_userkind<>'ADMINISTRATOR') THEN
        CALL FailureLog('evaluationresult','UPDATE');
        SIGNAL SQLSTATE VALUE '45000' SET message_text = 'You cannot change the grade result,if it had already been finalized.';
    END IF;
END$
DELIMITER ;

/* INSERT UPDATE DELETE EVALUATION RESULT */
DELIMITER $
CREATE TRIGGER evaluationresultInsertLog
AFTER INSERT ON evaluationresult
FOR EACH ROW
BEGIN
    CALL SuccessLog('evaluationresult','INSERT');
END$

CREATE TRIGGER evaluationresulteUpdateLog
AFTER UPDATE ON evaluationresult
FOR EACH ROW
BEGIN
    CALL SuccessLog('evaluationresult','UPDATE');
END$

CREATE TRIGGER evaluationresultDeleteLog
AFTER DELETE ON evaluationresult
FOR EACH ROW
BEGIN
    CALL SuccessLog('evaluationresult','DELETE');
END$
DELIMITER ;

/* SUCCESS / FAILURE LOG */
DELIMITER $
CREATE PROCEDURE SuccessLog(IN table_of_incident ENUM('job','employee','evaluationresult'), IN type_of_incident ENUM('INSERT','UPDATE','DELETE'))
BEGIN
    INSERT INTO  Log(userkind,table_of_incident,username,time_of_incident,type_of_incident,success) VALUES (@current_userkind,table_of_incident,@current_username,now(),type_of_incident,'Yes');
 
END$

CREATE PROCEDURE FailureLog(IN table_of_incident ENUM('job','employee','evaluationresult'), IN type_of_incident ENUM('INSERT','UPDATE','DELETE')) 
BEGIN
	INSERT INTO Log(userkind,table_of_incident,username,time_of_incident,type_of_incident,success) VALUES (@current_userkind,table_of_incident,@current_username,now(),type_of_incident,'No');
END$
DELIMITER ;





/* Stored Procedures */

/* ERWTHMA A */
DELIMITER $
CREATE PROCEDURE LoginAccount(IN endex_username VARCHAR(12),in endex_password VARCHAR(5))
BEGIN
/*KA8ARISMOS DEDOMENWN*/
	SELECT "Disconnecting from previous user...";
	SET @current_username=NULL;
	SET @current_password=NULL;
	SET @current_userkind=NULL;
	
	SET @current_username=endex_username;
	SET @current_password=endex_password;
	/*PSAXNW STO user.ADMINISTRATOR YPAREXEI.*/
	SELECT userkind INTO @current_userkind FROM user WHERE username=@current_username AND password=@current_password;
    /* IF userkind=NULL => DE BRE8HKE*/
   	 IF (@current_userkind IS NULL) THEN
		SELECT 'DE BRE8HKE TO SYGKEKRIMENO ACCOUNT.PLHKTROLOGEISTE "CALL LoginAccount(your Username,your Password);"';
    	ELSE
		SELECT 'SYNDE8HKATE EPITYXWS ',@current_username,',H IDIOTHTA SAS EIANI:',@current_userkind;
	END IF;
 END$
 DELIMITER ;


/* ERWTHMA B */
CREATE PROCEDURE Average (in specific_evaluator_username VARCHAR(12))
BEGIN
DECLARE specific_grade INT(4);
DECLARE finished bool;
DECLARE loops_amount_finalization int(4);
DECLARE specific_avg FLOAT(4,1);

DECLARE EvalCursor CURSOR FOR SELECT grade  FROM  evaluationresult WHERE evaluationresult.evaluator_username= specific_evaluator_username AND evaluationresult.grade IS NOT NULL;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=false;

SET specific_avg=0;
SET loops_amount_finalization=0;
OPEN EvalCursor;
SET finished=true;
FETCH EvalCursor INTO specific_grade;

WHILE (finished=true) DO
   SET loops_amount_finalization=loops_amount_finalization+1;
   SET specific_avg=specific_avg+specific_grade;
   FETCH EvalCursor INTO specific_grade;
END WHILE;

CLOSE EvalCursor;
SET specific_avg=specific_avg/loops_amount_finalization;
UPDATE evaluator SET evaluator.average_grade=specific_avg WHERE evaluator.evaluator_username=specific_evaluator_username;
END$
DELIMITER ;


/* ERWTHMA C */
DELIMITER $
CREATE PROCEDURE RequestEvaluation(IN req_empl_username VARCHAR(12),IN req_job_id INT(8))
BEGIN
DECLARE req_SubmissionDate DATE;
DECLARE req_evaluator_username VARCHAR(12);
SELECT SubmissionDate INTO req_SubmissionDate FROM requestevaluation WHERE requestevaluation.empl_username=req_empl_username AND requestevaluation.job_id=req_job_id;

IF  (CURDATE()<=req_SubmissionDate) THEN
    SELECT evaluator_username into req_evaluator_username FROM evaluator WHERE job.job_id=req_job_id;
    INSERT INTO evaluationresult (empl_username,job_id,evaluator_username) VALUES (req_empl_username,req_job_id,req_evaluator_username);

    UPDATE requestevaluation
    SET empl_interest=TRUE WHERE requestevaluation.empl_username=req_empl_username AND requestevaluation.job_id=req_job_id;
ELSE
	SELECT 'ELH3E TO XRONIKO DIASTHMA YPOBOLHS GIA AYTHN TH DOYLEIA.';
END IF;
END$
DELIMITER ;


/* ERWTHMA D */
DELIMITER $
CREATE PROCEDURE FinalizeEvaluations (IN Particular_job_id INT) BEGIN
DECLARE Particular_empl_username VARCHAR(12);
DECLARE Particular_evaluator_username VARCHAR(12);
DECLARE Particular_F1 INT(4);
DECLARE Particular_F2 INT(4);
DECLARE Particular_F3 INT(4);
DECLARE Particular_grade INT(4);
DECLARE finished bool;

DECLARE FinCursor CURSOR FOR SELECT username_employee,username_evaluator,phase1,phase2,phase3,Grade FROM evaluationresult WHERE evaluationresult.job_id=Particular_job_id ;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=false;
  
OPEN FinCursor;
SET finished=true;
FETCH FinCursor INTO Particular_empl_username,Particular_evaluator_username,Particular_F1,Particular_F2,Particular_F3,Particular_grade;

WHILE (finished=true) DO
    IF (Particular_F1 IS NOT NULL AND Particular_F2 IS NOT NULL AND Particular_F3 IS NOT NULL AND Particular_grade IS  NULL) THEN
        SET Particular_grade=Particular_F1+Particular_F2+Particular_F3 ;
        SELECT Particular_grade;
        UPDATE evaluationresult 
        SET grade=Particular_grade WHERE empl_username=Particular_empl_username AND job_id=Particular_job_id;
        SELECT Particular_evaluator_username AS 'EMPLOYEE', Particular_grade as 'grade'; 
    END IF;

    FETCH FinCursor INTO Particular_empl_username,Particular_evaluator_username,Particular_F1,Particular_F2,Particular_F3,Particular_grade;
END WHILE;
CLOSE FinCursor;
END$
DELIMITER ;


/* ERWTHMA E */
DELIMITER $
CREATE PROCEDURE FinishedEvaluations (in Demanded_job_id int )
 BEGIN
   DECLARE NumRequests INT(8);
   DECLARE NumUnansweredRequests INT(8);
   Select COUNT(job_id) INTO NumRequests FROM evaluationresult WHERE job_id=Demanded_job_id;
   SELECT COUNT(job_id) INTO NumUnansweredRequests FROM evaluationresult WHERE job_id=Demanded_job_id AND grade IS NULL;
   
   IF  (NumRequests>0) then               /*Diladi uparxoun request pou exonu ginei ews tora gia na proxorisoume*/
      IF (NumUnansweredRequests=0) then Select 'All Requests for this job have been fully evaluated.';
	  END IF;
      SELECT empl_username AS 'Candidate',grade FROM evaluationresult WHERE job_id=Demanded_job_id AND grade IS NOT NULL ORDER BY grade Desc;     /*Dinoume sto username eidiko onoma kai oxi sto grade,giati to grade einai column eidiko
      gia to table auto eno to empl_username einai genika opou uparxei username ypallilou*/
	  IF (NumUnansweredRequests>0) THEN SELECT NumUnansweredRequests;
	  END IF;
   ELSE SELECT 'DEN EXEI ZHTHSEI KANEIS AYTH TH 8ESH.';
   END IF ;   
END $
DELIMITER ;


/* ERWTHMA ST */
DELIMITER $
CREATE PROCEDURE Particular_Employee_Requests (in particular_name varchar(25),in particular_surname varchar(35)) BEGIN
    DECLARE particular_job_id INT(8);
    DECLARE particular_grade INT(4);
    DECLARE finished TINYINT(2);
    DECLARE particular_evaluator_username VARCHAR(12);
    DECLARE particular_empl_username VARCHAR(12);

    DECLARE ReqCursor CURSOR FOR SELECT job_id,grade,evaluator_username FROM evaluationresult WHERE evaluationresult.empl_username=particular_empl_username;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=1;       
    SELECT username INTO particular_empl_username FROM user WHERE user.name=Particular_name and user.surname=Particular_surname AND userkind='EMPLOYEE';

    OPEN ReqCursor;
    SET finished=0;

    FETCH ReqCursor INTO particular_job_id,particular_grade,particular_evaluator_username;
    WHILE (finished=0) DO	
       SELECT particular_job_id AS 'Job requested from employee.',particular_grade AS 'Grade,IF the request have been evalueated fully';
       SELECT name,surname AS 'Evaluator of the job' FROM user WHERE particular_evaluator_username=user.username and userkind='EVALUATOR';
       FETCH ReqCursor INTO particular_job_id,particular_grade,particular_evaluator_username;
	END WHILE;
    CLOSE ReqCursor;
END$
DELIMITER ;
