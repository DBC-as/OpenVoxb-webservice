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
--alter table voxb_users modify (institutionId number(6) not null);
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

