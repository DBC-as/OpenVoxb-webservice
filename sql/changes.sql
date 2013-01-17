/* Bug #68 */
ALTER TABLE voxb_objects MODIFY (objecttitle VARCHAR2(200));

/* Bug #10759 */
ALTER TABLE voxb_objects MODIFY objeccontributors null;

/* Bug #11087 */
UPDATE voxb_users SET useridentifiervalue = ' ' WHERE useridentifiervalue IS NULL;
ALTER TABLE voxb_users MODIFY useridentifiervalue NOT NULL;
UPDATE voxb_users SET useridentifiertype = ' ' WHERE useridentifiertype IS NULL;
ALTER TABLE voxb_users MODIFY useridentifiertype NOT NULL;
UPDATE voxb_users SET identityprovider = ' ' WHERE identityprovider IS NULL;
ALTER TABLE voxb_users MODIFY identityprovider NOT NULL;

/* Efter version 0.4 - kør clean_database.php, da der er mange ændringer der osse kræver en helt ren database */

CREATE SEQUENCE voxb_logs_seq MINVALUE 1 START WITH 1 INCREMENT BY 1;
create table voxb_logs (
	logId number NOT NULL,
  method varchar2(32) NOT NULL,
	userId number DEFAULT NULL,
	p1 number DEFAULT NULL,
	p2 number DEFAULT NULL,
	p3 number DEFAULT NULL,
	p4 number DEFAULT NULL,
	p5 number DEFAULT NULL,
	p6 number DEFAULT NULL,
	p7 number DEFAULT NULL,
	text varchar2(128) DEFAULT NULL,
  error number DEFAULT NULL,
	duration float DEFAULT NULL,
  creation_date date default sysdate NOT NULL,
	CONSTRAINT voxb_logs_pk PRIMARY KEY (logId)
);
CREATE OR REPLACE TRIGGER voxb_seq_logs BEFORE INSERT ON voxb_logs FOR EACH ROW BEGIN SELECT voxb_logs_seq.NEXTVAL INTO :NEW.logId FROM DUAL; END;
/
create index voxb_logs_idx on voxb_logs (logId,method);

/* Efter version 0.51 - startende med version 1.0 */
ALTER SEQUENCE voxb_users_seq NOCACHE;
ALTER SEQUENCE voxb_objects_seq NOCACHE;
ALTER SEQUENCE voxb_reviews_seq NOCACHE;
ALTER SEQUENCE voxb_locals_seq NOCACHE;
ALTER SEQUENCE voxb_tags_seq NOCACHE;
ALTER SEQUENCE voxb_items_seq NOCACHE;
ALTER SEQUENCE voxb_complaints_seq NOCACHE;
ALTER SEQUENCE voxb_logs_seq NOCACHE;

/* v1.1 institutionid instead of institutionname as primary key */
alter table voxb_institutions add (institutionId number(6));
update voxb_institutions set institutionId=rownum;
alter table voxb_institutions modify (institutionId not null);
alter table voxb_users add (institutionId number(6));
update voxb_users u set institutionId=(select institutionId from voxb_institutions where institutionname=u.institutionName);
update voxb_users set institutionId=1 where institutionId IS NULL;
alter table voxb_users modify (institutionId number(6) not null);
alter table voxb_users drop constraint ref_users_id;
alter table voxb_complaints drop constraint ref_off_institutionName;
alter table voxb_institutions drop constraint voxb_ins_pk;
drop index voxb_ins_pk;
alter table voxb_institutions add constraint voxb_ins_pk primary key (institutionId);
alter table voxb_complaints add (offender_institutionId number(6) not null);
update voxb_complaints c set offender_institutionId=(select institutionId from voxb_institutions where institutionname=c.offender_institutionName);
alter table voxb_complaints add constraint ref_off_institutionId foreign key (offender_institutionId) references voxb_institutions(institutionId);
alter table voxb_users add constraint ref_users_id foreign key (institutionId) references voxb_institutions(institutionId);
create or replace trigger ins_complaints_instid_trg
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
create or replace trigger ins_users_trg
before insert on voxb_users
for each row
begin
        if :new.institutionId is null then
                select institutionId
                into :new.institutionId
                from voxb_institutions
                where institutionname=:new.institutionName;
        end if;
        if :new.institutionName is null then
                select institutionName
                into :new.institutionName
                from voxb_institutions
                where institutionId=:new.institutionId;
        end if;
end;
/
alter table voxb_items add (newpk number);
update voxb_items set newpk=to_number(itemidentifiervalue);
alter table voxb_complaints drop constraint ref_com_itemid;
alter table voxb_locals drop constraint ref_locals_items_id;
alter table voxb_reviews drop constraint ref_reviews_items_id;
alter table voxb_tags drop constraint ref_tag_id;
alter table voxb_items drop constraint voxb_items_pk;
alter table voxb_items drop column itemidentifiervalue;
alter table voxb_items add (itemidentifiervalue number);
update voxb_items set itemidentifiervalue=newpk;
alter table voxb_items drop column newpk;
alter table voxb_items modify (itemidentifiervalue not null);
alter table voxb_items add constraint voxb_items_pk primary key (itemidentifiervalue);

alter table voxb_complaints add (offitemidnumber number);
update voxb_complaints set offitemidnumber=to_number(offending_itemid);
alter table voxb_complaints drop column offending_itemid;
alter table voxb_complaints add (offending_itemid number);
update voxb_complaints set offending_itemid=offitemidnumber;
alter table voxb_complaints modify (offending_itemid not null);
alter table voxb_complaints drop column offitemidnumber;
alter table voxb_complaints add constraint ref_com_itemid foreign key (offending_itemid) references voxb_items (itemidentifiervalue);

alter table voxb_locals add (tmpnr number);
update voxb_locals set tmpnr=itemid;
alter table voxb_locals drop column itemid;
alter table voxb_locals add (itemid number);
update voxb_locals set itemid=tmpnr;
alter table voxb_locals modify (itemid not null);
alter table voxb_locals drop column tmpnr;
alter table voxb_locals add constraint ref_locals_items_id foreign key (itemid) references voxb_items (itemidentifiervalue) on delete cascade;

alter table voxb_reviews add (tmpnr number);
update voxb_reviews set tmpnr=itemid;
alter table voxb_reviews drop column itemid;
alter table voxb_reviews add (itemid number);
update voxb_reviews set itemid=tmpnr;
alter table voxb_reviews modify (itemid not null);
alter table voxb_reviews drop column tmpnr;
alter table voxb_reviews add constraint ref_reviews_items_id foreign key (itemid) references voxb_items (itemidentifiervalue) on delete cascade;

alter table voxb_tags add (tmpnr number);
update voxb_tags set tmpnr=itemid;
alter table voxb_tags drop column itemid;
alter table voxb_tags add (itemid number);
update voxb_tags set itemid=tmpnr;
alter table voxb_tags modify (itemid not null);
alter table voxb_tags drop column tmpnr;
alter table voxb_tags add constraint ref_tag_id foreign key (itemid) references voxb_items (itemidentifiervalue) on delete cascade;

/* v1.2 */
/* fix too small contributors */
alter table voxb_objects modify(OBJECTCONTRIBUTORS varchar(255));

/* change constraint on voxb_users */
alter table voxb_users drop constraint "REF_USERS_ID"
ALTER TABLE VOXB_USERS ADD CONSTRAINT "REF_USERS_ID" FOREIGN KEY ("INSTITUTIONID") REFERENCES "VOXB_INSTITUTIONS" ("INSTITUTIONID") ON DELETE CASCADE ENABLE;

/* change constraints on voxb_complaints */
alter table voxb_complaints drop constraint "REF_COM_ITEMID"

ALTER TABLE "VOXB_COMPLAINTS" ADD CONSTRAINT "REF_COM_ITEMID" FOREIGN KEY ("OFFENDING_ITEMID")
          REFERENCES "VOXB_ITEMS" ("ITEMIDENTIFIERVALUE") ON DELETE CASCADE ENABLE;

alter table voxb_complaints drop constraint "REF_COM_USERID"

ALTER TABLE "VOXB_COMPLAINTS" ADD CONSTRAINT "REF_COM_USERID" FOREIGN KEY ("COMPLAINANT_USERID")
          REFERENCES "VOXB_USERS" ("USERID") ON DELETE CASCADE ENABLE;

alter table voxb_complaints drop constraint "REF_OFF_INSTITUTIONID"

ALTER TABLE "VOXB_COMPLAINTS" ADD CONSTRAINT "REF_OFF_INSTITUTIONID" FOREIGN KEY ("OFFENDER_INSTITUTIONID")
          REFERENCES "VOXB_INSTITUTIONS" ("INSTITUTIONID") ON DELETE CASCADE ENABLE;
          
alter table voxb_complaints drop constraint "REF_OFF_USERID"

ALTER TABLE "VOXB_COMPLAINTS" ADD CONSTRAINT "REF_OFF_USERID" FOREIGN KEY ("OFFENDER_USERID")
          REFERENCES "VOXB_USERS" ("USERID") ON DELETE CASCADE ENABLE;
