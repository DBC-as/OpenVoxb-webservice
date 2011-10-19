--------------------------------------------------------
--  File created - Wednesday-October-19-2011   
--------------------------------------------------------
  DROP TABLE "VOXB_COMPLAINTS";
  DROP TABLE "VOXB_INSTITUTIONS";
  DROP TABLE "VOXB_ITEMS";
  DROP TABLE "VOXB_LOCALS";
  DROP TABLE "VOXB_LOGS";
  DROP TABLE "VOXB_OBJECTS";
  DROP TABLE "VOXB_REVIEWS";
  DROP TABLE "VOXB_TAGS";
  DROP TABLE "VOXB_USERS";
  DROP SEQUENCE "VOXB_COMPLAINTS_SEQ";
  DROP SEQUENCE "VOXB_ITEMS_SEQ";
  DROP SEQUENCE "VOXB_LOCALS_SEQ";
  DROP SEQUENCE "VOXB_LOGS_SEQ";
  DROP SEQUENCE "VOXB_OBJECTS_SEQ";
  DROP SEQUENCE "VOXB_REVIEWS_SEQ";
  DROP SEQUENCE "VOXB_TAGS_SEQ";
  DROP SEQUENCE "VOXB_USERS_SEQ";
--------------------------------------------------------
--  DDL for Sequence VOXB_COMPLAINTS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "VOXB_COMPLAINTS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 41 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence VOXB_ITEMS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "VOXB_ITEMS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 6947 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence VOXB_LOCALS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "VOXB_LOCALS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 240 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence VOXB_LOGS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "VOXB_LOGS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 452749 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence VOXB_OBJECTS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "VOXB_OBJECTS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1653 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence VOXB_REVIEWS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "VOXB_REVIEWS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 4062 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence VOXB_TAGS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "VOXB_TAGS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 5300 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence VOXB_USERS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "VOXB_USERS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 3535 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Table VOXB_COMPLAINTS
--------------------------------------------------------

  CREATE TABLE "VOXB_COMPLAINTS" 
   (	"COMPLAINTID" NUMBER, 
	"OFFENDER_INSTITUTIONNAME" VARCHAR2(128) DEFAULT NULL, 
	"OFFENDER_USERID" NUMBER, 
	"OFFENDING_ITEMID" VARCHAR2(32), 
	"COMPLAINANT_USERID" NUMBER, 
	"STATUS" VARCHAR2(16), 
	"CREATION_DATE" DATE DEFAULT sysdate, 
	"OFFENDER_INSTITUTIONID" NUMBER(6,0)
   ) ;
--------------------------------------------------------
--  DDL for Table VOXB_INSTITUTIONS
--------------------------------------------------------

  CREATE TABLE "VOXB_INSTITUTIONS" 
   (	"INSTITUTIONNAME" VARCHAR2(128) DEFAULT NULL, 
	"CONTACTPERSON_NAME" VARCHAR2(64) DEFAULT NULL, 
	"CONTACTPERSON_EMAIL" VARCHAR2(128) DEFAULT NULL, 
	"CONTACTPERSON_PHONE" NUMBER(8,0) DEFAULT NULL, 
	"MODERATOR_NAME" VARCHAR2(64) DEFAULT NULL, 
	"MODERATOR_EMAIL" VARCHAR2(128) DEFAULT NULL, 
	"CREATION_DATE" DATE DEFAULT sysdate, 
	"INSTITUTIONID" NUMBER(6,0)
   ) ;
--------------------------------------------------------
--  DDL for Table VOXB_ITEMS
--------------------------------------------------------

  CREATE TABLE "VOXB_ITEMS" 
   (	"ITEMIDENTIFIERVALUE" VARCHAR2(32), 
	"USERID" NUMBER, 
	"OBJECTID" NUMBER, 
	"RATING" NUMBER DEFAULT NULL, 
	"CREATION_DATE" DATE DEFAULT sysdate, 
	"MODIFICATION_DATE" DATE DEFAULT sysdate, 
	"DISABLED" NUMBER(1,0) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table VOXB_LOCALS
--------------------------------------------------------

  CREATE TABLE "VOXB_LOCALS" 
   (	"LOCALID" NUMBER, 
	"ITEMID" VARCHAR2(32), 
	"DATA" VARCHAR2(4000) DEFAULT NULL, 
	"TYPE" VARCHAR2(10) DEFAULT NULL, 
	"ITEMTYPE" VARCHAR2(64) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table VOXB_LOGS
--------------------------------------------------------

  CREATE TABLE "VOXB_LOGS" 
   (	"LOGID" NUMBER, 
	"METHOD" VARCHAR2(32), 
	"USERID" NUMBER DEFAULT NULL, 
	"P1" NUMBER DEFAULT NULL, 
	"P2" NUMBER DEFAULT NULL, 
	"P3" NUMBER DEFAULT NULL, 
	"P4" NUMBER DEFAULT NULL, 
	"P5" NUMBER DEFAULT NULL, 
	"P6" NUMBER DEFAULT NULL, 
	"P7" NUMBER DEFAULT NULL, 
	"TEXT" VARCHAR2(128) DEFAULT NULL, 
	"ERROR" NUMBER DEFAULT NULL, 
	"DURATION" FLOAT(126) DEFAULT NULL, 
	"CREATION_DATE" DATE DEFAULT sysdate
   ) ;
--------------------------------------------------------
--  DDL for Table VOXB_OBJECTS
--------------------------------------------------------

  CREATE TABLE "VOXB_OBJECTS" 
   (	"OBJECTID" NUMBER, 
	"OBJECTIDENTIFIERVALUE" VARCHAR2(32), 
	"OBJECTIDENTIFIERTYPE" VARCHAR2(8), 
	"OBJECTTITLE" VARCHAR2(200) DEFAULT NULL, 
	"OBJECTCONTRIBUTORS" VARCHAR2(32) DEFAULT NULL, 
	"OBJECTPUBLICATIONYEAR" VARCHAR2(4) DEFAULT NULL, 
	"OBJECTMATERIALTYPE" VARCHAR2(32) DEFAULT NULL, 
	"CREATION_DATE" DATE DEFAULT sysdate, 
	"MODIFICATION_DATE" DATE DEFAULT sysdate
   ) ;
--------------------------------------------------------
--  DDL for Table VOXB_REVIEWS
--------------------------------------------------------

  CREATE TABLE "VOXB_REVIEWS" 
   (	"REVIEWID" NUMBER, 
	"ITEMID" VARCHAR2(32), 
	"TITLE" VARCHAR2(32) DEFAULT NULL, 
	"TYPE" VARCHAR2(10) DEFAULT NULL, 
	"DATA" VARCHAR2(4000) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table VOXB_TAGS
--------------------------------------------------------

  CREATE TABLE "VOXB_TAGS" 
   (	"TAGID" NUMBER, 
	"ITEMID" VARCHAR2(32), 
	"TAG" VARCHAR2(32)
   ) ;
--------------------------------------------------------
--  DDL for Table VOXB_USERS
--------------------------------------------------------

  CREATE TABLE "VOXB_USERS" 
   (	"USERID" NUMBER, 
	"ALIAS_NAME" VARCHAR2(64), 
	"PROFILEURL" VARCHAR2(4000) DEFAULT NULL, 
	"USERIDENTIFIERVALUE" VARCHAR2(64) DEFAULT NULL, 
	"USERIDENTIFIERTYPE" VARCHAR2(16) DEFAULT NULL, 
	"IDENTITYPROVIDER" VARCHAR2(64) DEFAULT NULL, 
	"INSTITUTIONNAME" VARCHAR2(128) DEFAULT NULL, 
	"CREATION_DATE" TIMESTAMP (6) DEFAULT sysdate, 
	"MODIFICATION_DATE" TIMESTAMP (6) DEFAULT sysdate, 
	"DISABLED" NUMBER(1,0) DEFAULT NULL, 
	"INSTITUTIONID" NUMBER(6,0)
   ) ;
--------------------------------------------------------
--  DDL for Index VOXB_ITEMS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "VOXB_ITEMS_PK" ON "VOXB_ITEMS" ("ITEMIDENTIFIERVALUE") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_TAGS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "VOXB_TAGS_PK" ON "VOXB_TAGS" ("TAGID") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_LOCALS_IDX
--------------------------------------------------------

  CREATE INDEX "VOXB_LOCALS_IDX" ON "VOXB_LOCALS" ("LOCALID", "DATA", "TYPE", "ITEMTYPE") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_USERS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "VOXB_USERS_PK" ON "VOXB_USERS" ("USERID") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_OBJECTS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "VOXB_OBJECTS_PK" ON "VOXB_OBJECTS" ("OBJECTID") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_OBJECTS_IDX
--------------------------------------------------------

  CREATE INDEX "VOXB_OBJECTS_IDX" ON "VOXB_OBJECTS" ("OBJECTIDENTIFIERVALUE", "OBJECTIDENTIFIERTYPE", "OBJECTTITLE", "OBJECTCONTRIBUTORS") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_REVIEWS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "VOXB_REVIEWS_PK" ON "VOXB_REVIEWS" ("REVIEWID") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_INS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "VOXB_INS_PK" ON "VOXB_INSTITUTIONS" ("INSTITUTIONID") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_USERS_UNIQ
--------------------------------------------------------

  CREATE UNIQUE INDEX "VOXB_USERS_UNIQ" ON "VOXB_USERS" ("ALIAS_NAME", "PROFILEURL") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_COM_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "VOXB_COM_PK" ON "VOXB_COMPLAINTS" ("COMPLAINTID") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_LOGS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "VOXB_LOGS_PK" ON "VOXB_LOGS" ("LOGID") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_LOGS_IDX
--------------------------------------------------------

  CREATE INDEX "VOXB_LOGS_IDX" ON "VOXB_LOGS" ("LOGID", "METHOD") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_ITEMS_IDX
--------------------------------------------------------

  CREATE INDEX "VOXB_ITEMS_IDX" ON "VOXB_ITEMS" ("OBJECTID", "DISABLED") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_LOCALS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "VOXB_LOCALS_PK" ON "VOXB_LOCALS" ("LOCALID") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_USERS_IDX
--------------------------------------------------------

  CREATE INDEX "VOXB_USERS_IDX" ON "VOXB_USERS" ("USERIDENTIFIERVALUE", "USERIDENTIFIERTYPE", "IDENTITYPROVIDER", "INSTITUTIONNAME", "DISABLED") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_REVIEWS_IDX
--------------------------------------------------------

  CREATE INDEX "VOXB_REVIEWS_IDX" ON "VOXB_REVIEWS" ("REVIEWID", "TITLE", "TYPE", "DATA") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_ITEMS_UNIQ
--------------------------------------------------------

  CREATE UNIQUE INDEX "VOXB_ITEMS_UNIQ" ON "VOXB_ITEMS" ("USERID", "OBJECTID") 
  ;
--------------------------------------------------------
--  DDL for Index VOXB_TAGS_IDX
--------------------------------------------------------

  CREATE INDEX "VOXB_TAGS_IDX" ON "VOXB_TAGS" ("TAGID", "ITEMID", "TAG") 
  ;
--------------------------------------------------------
--  Constraints for Table VOXB_COMPLAINTS
--------------------------------------------------------

  ALTER TABLE "VOXB_COMPLAINTS" ADD CONSTRAINT "VOXB_COM_PK" PRIMARY KEY ("COMPLAINTID") ENABLE;
  ALTER TABLE "VOXB_COMPLAINTS" MODIFY ("OFFENDER_INSTITUTIONID" NOT NULL ENABLE);
  ALTER TABLE "VOXB_COMPLAINTS" MODIFY ("CREATION_DATE" NOT NULL ENABLE);
  ALTER TABLE "VOXB_COMPLAINTS" MODIFY ("STATUS" NOT NULL ENABLE);
  ALTER TABLE "VOXB_COMPLAINTS" MODIFY ("COMPLAINANT_USERID" NOT NULL ENABLE);
  ALTER TABLE "VOXB_COMPLAINTS" MODIFY ("OFFENDING_ITEMID" NOT NULL ENABLE);
  ALTER TABLE "VOXB_COMPLAINTS" MODIFY ("OFFENDER_USERID" NOT NULL ENABLE);
  ALTER TABLE "VOXB_COMPLAINTS" MODIFY ("COMPLAINTID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table VOXB_INSTITUTIONS
--------------------------------------------------------

  ALTER TABLE "VOXB_INSTITUTIONS" ADD CONSTRAINT "VOXB_INS_PK" PRIMARY KEY ("INSTITUTIONID") ENABLE;
  ALTER TABLE "VOXB_INSTITUTIONS" MODIFY ("INSTITUTIONID" NOT NULL ENABLE);
  ALTER TABLE "VOXB_INSTITUTIONS" MODIFY ("CREATION_DATE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table VOXB_ITEMS
--------------------------------------------------------

  ALTER TABLE "VOXB_ITEMS" ADD CONSTRAINT "VOXB_ITEMS_UNIQ" UNIQUE ("USERID", "OBJECTID") ENABLE;
  ALTER TABLE "VOXB_ITEMS" ADD CONSTRAINT "VOXB_ITEMS_PK" PRIMARY KEY ("ITEMIDENTIFIERVALUE") ENABLE;
  ALTER TABLE "VOXB_ITEMS" MODIFY ("MODIFICATION_DATE" NOT NULL ENABLE);
  ALTER TABLE "VOXB_ITEMS" MODIFY ("CREATION_DATE" NOT NULL ENABLE);
  ALTER TABLE "VOXB_ITEMS" MODIFY ("OBJECTID" NOT NULL ENABLE);
  ALTER TABLE "VOXB_ITEMS" MODIFY ("USERID" NOT NULL ENABLE);
  ALTER TABLE "VOXB_ITEMS" MODIFY ("ITEMIDENTIFIERVALUE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table VOXB_USERS
--------------------------------------------------------

  ALTER TABLE "VOXB_USERS" ADD CONSTRAINT "VOXB_USERS_UNIQ" UNIQUE ("ALIAS_NAME", "PROFILEURL") ENABLE;
  ALTER TABLE "VOXB_USERS" ADD CONSTRAINT "VOXB_USERS_PK" PRIMARY KEY ("USERID") ENABLE;
  ALTER TABLE "VOXB_USERS" MODIFY ("MODIFICATION_DATE" NOT NULL ENABLE);
  ALTER TABLE "VOXB_USERS" MODIFY ("CREATION_DATE" NOT NULL ENABLE);
  ALTER TABLE "VOXB_USERS" MODIFY ("ALIAS_NAME" NOT NULL ENABLE);
  ALTER TABLE "VOXB_USERS" MODIFY ("USERID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table VOXB_LOGS
--------------------------------------------------------

  ALTER TABLE "VOXB_LOGS" ADD CONSTRAINT "VOXB_LOGS_PK" PRIMARY KEY ("LOGID") ENABLE;
  ALTER TABLE "VOXB_LOGS" MODIFY ("CREATION_DATE" NOT NULL ENABLE);
  ALTER TABLE "VOXB_LOGS" MODIFY ("METHOD" NOT NULL ENABLE);
  ALTER TABLE "VOXB_LOGS" MODIFY ("LOGID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table VOXB_TAGS
--------------------------------------------------------

  ALTER TABLE "VOXB_TAGS" ADD CONSTRAINT "VOXB_TAGS_PK" PRIMARY KEY ("TAGID") ENABLE;
  ALTER TABLE "VOXB_TAGS" MODIFY ("TAG" NOT NULL ENABLE);
  ALTER TABLE "VOXB_TAGS" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "VOXB_TAGS" MODIFY ("TAGID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table VOXB_LOCALS
--------------------------------------------------------

  ALTER TABLE "VOXB_LOCALS" ADD CONSTRAINT "VOXB_LOCALS_PK" PRIMARY KEY ("LOCALID") ENABLE;
  ALTER TABLE "VOXB_LOCALS" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "VOXB_LOCALS" MODIFY ("LOCALID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table VOXB_OBJECTS
--------------------------------------------------------

  ALTER TABLE "VOXB_OBJECTS" ADD CONSTRAINT "VOXB_OBJECTS_PK" PRIMARY KEY ("OBJECTID") ENABLE;
  ALTER TABLE "VOXB_OBJECTS" MODIFY ("MODIFICATION_DATE" NOT NULL ENABLE);
  ALTER TABLE "VOXB_OBJECTS" MODIFY ("CREATION_DATE" NOT NULL ENABLE);
  ALTER TABLE "VOXB_OBJECTS" MODIFY ("OBJECTIDENTIFIERTYPE" NOT NULL ENABLE);
  ALTER TABLE "VOXB_OBJECTS" MODIFY ("OBJECTIDENTIFIERVALUE" NOT NULL ENABLE);
  ALTER TABLE "VOXB_OBJECTS" MODIFY ("OBJECTID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table VOXB_REVIEWS
--------------------------------------------------------

  ALTER TABLE "VOXB_REVIEWS" ADD CONSTRAINT "VOXB_REVIEWS_PK" PRIMARY KEY ("REVIEWID") ENABLE;
  ALTER TABLE "VOXB_REVIEWS" MODIFY ("ITEMID" NOT NULL ENABLE);
  ALTER TABLE "VOXB_REVIEWS" MODIFY ("REVIEWID" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table VOXB_COMPLAINTS
--------------------------------------------------------

  ALTER TABLE "VOXB_COMPLAINTS" ADD CONSTRAINT "REF_COM_ITEMID" FOREIGN KEY ("OFFENDING_ITEMID")
	  REFERENCES "VOXB_ITEMS" ("ITEMIDENTIFIERVALUE") ENABLE;
  ALTER TABLE "VOXB_COMPLAINTS" ADD CONSTRAINT "REF_COM_USERID" FOREIGN KEY ("COMPLAINANT_USERID")
	  REFERENCES "VOXB_USERS" ("USERID") ENABLE;
  ALTER TABLE "VOXB_COMPLAINTS" ADD CONSTRAINT "REF_OFF_INSTITUTIONID" FOREIGN KEY ("OFFENDER_INSTITUTIONID")
	  REFERENCES "VOXB_INSTITUTIONS" ("INSTITUTIONID") ENABLE;
  ALTER TABLE "VOXB_COMPLAINTS" ADD CONSTRAINT "REF_OFF_USERID" FOREIGN KEY ("OFFENDER_USERID")
	  REFERENCES "VOXB_USERS" ("USERID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table VOXB_ITEMS
--------------------------------------------------------

  ALTER TABLE "VOXB_ITEMS" ADD CONSTRAINT "REF_ITEMS_ID" FOREIGN KEY ("OBJECTID")
	  REFERENCES "VOXB_OBJECTS" ("OBJECTID") ENABLE;
  ALTER TABLE "VOXB_ITEMS" ADD CONSTRAINT "REF_USER_ID" FOREIGN KEY ("USERID")
	  REFERENCES "VOXB_USERS" ("USERID") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table VOXB_LOCALS
--------------------------------------------------------

  ALTER TABLE "VOXB_LOCALS" ADD CONSTRAINT "REF_LOCALS_ITEMS_ID" FOREIGN KEY ("ITEMID")
	  REFERENCES "VOXB_ITEMS" ("ITEMIDENTIFIERVALUE") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table VOXB_REVIEWS
--------------------------------------------------------

  ALTER TABLE "VOXB_REVIEWS" ADD CONSTRAINT "REF_REVIEWS_ITEMS_ID" FOREIGN KEY ("ITEMID")
	  REFERENCES "VOXB_ITEMS" ("ITEMIDENTIFIERVALUE") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table VOXB_TAGS
--------------------------------------------------------

  ALTER TABLE "VOXB_TAGS" ADD CONSTRAINT "REF_TAG_ID" FOREIGN KEY ("ITEMID")
	  REFERENCES "VOXB_ITEMS" ("ITEMIDENTIFIERVALUE") ON DELETE CASCADE ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table VOXB_USERS
--------------------------------------------------------

  ALTER TABLE "VOXB_USERS" ADD CONSTRAINT "REF_USERS_ID" FOREIGN KEY ("INSTITUTIONID")
	  REFERENCES "VOXB_INSTITUTIONS" ("INSTITUTIONID") ENABLE;
--------------------------------------------------------
--  DDL for Trigger INS_COMPLAINTS_INSTID_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INS_COMPLAINTS_INSTID_TRG" 
before insert on voxb_complaints
for each row
begin
	if :new.offender_institutionId is null then
		select institutionId
		into :new.offender_institutionId
		from voxb_institutions
		where institutionname=:new.offender_institutionName;
	end if;
	if :new.offender_institutionName is null then
		select institutionName
		into :new.offender_institutionName
		from voxb_institutions
		where institutionId=:new.offender_institutionId;
	end if;
end;
/
ALTER TRIGGER "INS_COMPLAINTS_INSTID_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger INS_USERS_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "INS_USERS_TRG" 
before insert on voxb_users
for each row
begin
        if :new.institutionId is null then
                select institutionId
                into :new.institutionId
                from voxb_institutions
                where institutionname=:new.institutionName;
        end if;
end;
/
ALTER TRIGGER "INS_USERS_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger VOXB_SEQ_COMPLAINTS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "VOXB_SEQ_COMPLAINTS" BEFORE INSERT ON voxb_complaints FOR EACH ROW BEGIN SELECT voxb_complaints_seq.NEXTVAL INTO :NEW.complaintId FROM DUAL; END;
/
ALTER TRIGGER "VOXB_SEQ_COMPLAINTS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger VOXB_SEQ_ITEMS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "VOXB_SEQ_ITEMS" BEFORE INSERT ON voxb_items FOR EACH ROW BEGIN SELECT voxb_items_seq.NEXTVAL INTO :NEW.itemIdentifierValue FROM DUAL; END;
/
ALTER TRIGGER "VOXB_SEQ_ITEMS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger VOXB_SEQ_LOCALS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "VOXB_SEQ_LOCALS" BEFORE INSERT ON voxb_locals FOR EACH ROW BEGIN SELECT voxb_locals_seq.NEXTVAL INTO :NEW.localId FROM DUAL; END;
/
ALTER TRIGGER "VOXB_SEQ_LOCALS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger VOXB_SEQ_LOGS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "VOXB_SEQ_LOGS" BEFORE INSERT ON voxb_logs FOR EACH ROW BEGIN SELECT voxb_logs_seq.NEXTVAL INTO :NEW.logId FROM DUAL; END;
/
ALTER TRIGGER "VOXB_SEQ_LOGS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger VOXB_SEQ_OBJECTS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "VOXB_SEQ_OBJECTS" BEFORE INSERT ON voxb_objects FOR EACH ROW BEGIN SELECT voxb_objects_seq.NEXTVAL INTO :NEW.objectId FROM DUAL; END;
/
ALTER TRIGGER "VOXB_SEQ_OBJECTS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger VOXB_SEQ_REVIEWS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "VOXB_SEQ_REVIEWS" BEFORE INSERT ON voxb_reviews FOR EACH ROW BEGIN SELECT voxb_reviews_seq.NEXTVAL INTO :NEW.reviewId FROM DUAL; END;
/
ALTER TRIGGER "VOXB_SEQ_REVIEWS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger VOXB_SEQ_TAGS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "VOXB_SEQ_TAGS" BEFORE INSERT ON voxb_tags FOR EACH ROW BEGIN SELECT voxb_tags_seq.NEXTVAL INTO :NEW.tagId FROM DUAL; END;
/
ALTER TRIGGER "VOXB_SEQ_TAGS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger VOXB_SEQ_USERS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "VOXB_SEQ_USERS" BEFORE INSERT ON voxb_users FOR EACH ROW BEGIN SELECT voxb_users_seq.NEXTVAL INTO :NEW.userId FROM DUAL; END;
/
ALTER TRIGGER "VOXB_SEQ_USERS" ENABLE;
