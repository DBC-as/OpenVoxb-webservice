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
