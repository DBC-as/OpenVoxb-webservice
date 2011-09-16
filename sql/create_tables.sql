drop table voxb_complaints;
drop table voxb_locals;
drop table voxb_reviews;
drop table voxb_tags;
drop table voxb_items;
drop table voxb_objects;
drop table voxb_users;
drop table voxb_institutions;
drop table voxb_logs;

purge recyclebin;

drop sequence voxb_users_seq;
drop sequence voxb_objects_seq;
drop sequence voxb_reviews_seq;
drop sequence voxb_locals_seq;
drop sequence voxb_tags_seq;
drop sequence voxb_items_seq;
drop sequence voxb_complaints_seq;
drop sequence voxb_logs_seq;

CREATE SEQUENCE voxb_users_seq MINVALUE 1 START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE voxb_objects_seq MINVALUE 1 START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE voxb_reviews_seq MINVALUE 1 START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE voxb_locals_seq MINVALUE 1 START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE voxb_tags_seq MINVALUE 1 START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE voxb_items_seq MINVALUE 1 START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE voxb_complaints_seq MINVALUE 1 START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE voxb_logs_seq MINVALUE 1 START WITH 1 INCREMENT BY 1 NOCACHE;

create table voxb_institutions (
  institutionId number NOT NULL,
  institutionName varchar2(128) DEFAULT NULL,
  contactperson_name varchar2(64) DEFAULT NULL,
  contactperson_email varchar2(128) DEFAULT NULL,
  contactperson_phone number(8) DEFAULT NULL,
  moderator_name varchar2(64) DEFAULT NULL,
  moderator_email varchar2(128) DEFAULT NULL,
  creation_date date default sysdate NOT NULL,
	CONSTRAINT voxb_ins_pk PRIMARY KEY (institutionId);
);
create table voxb_users (
	userId number NOT NULL,
	institutionId number,
	alias_name varchar2(64) NOT NULL,
	profileurl varchar2(4000) DEFAULT NULL,
	userIdentifierValue varchar2(64) DEFAULT NULL,
	userIdentifierType varchar2(16) DEFAULT NULL,
	identityProvider varchar2(64) DEFAULT NULL,
	institutionName varchar2(128) DEFAULT NULL,
	creation_date TIMESTAMP default sysdate NOT NULL,
	modification_date TIMESTAMP default sysdate NOT NULL,
	disabled number(1) default NULL,
	CONSTRAINT ref_users_id FOREIGN KEY (institutionId) references voxb_institutions(institutionId),
	CONSTRAINT voxb_users_uniq UNIQUE (alias_name, profileurl),
	CONSTRAINT voxb_users_pk PRIMARY KEY (userId)
);
create table voxb_objects (
  objectId number NOT NULL,
  objectIdentifierValue varchar2(32) NOT NULL,
  objectIdentifierType varchar2(8) NOT NULL,
  objectTitle varchar2(200) DEFAULT NULL,
  objectContributors varchar2(32) DEFAULT NULL,
  objectPublicationYear varchar2(4) DEFAULT NULL,
  objectMaterialType varchar2(32) DEFAULT NULL,
  creation_date date default sysdate NOT NULL,
  modification_date date default sysdate NOT NULL,
  CONSTRAINT voxb_objects_pk PRIMARY KEY (objectId)
);
create table voxb_items (
	itemIdentifierValue varchar2(32) NOT NULL,
	userId number NOT NULL,
	objectId number NOT NULL,
	rating number DEFAULT NULL,
	creation_date date default sysdate NOT NULL,
	modification_date date default sysdate NOT NULL,
	disabled number(1) default NULL,
	CONSTRAINT voxb_items_uniq UNIQUE (userId, objectId),
	CONSTRAINT ref_items_id FOREIGN KEY (objectId) references voxb_objects(objectId),
	CONSTRAINT ref_user_id FOREIGN KEY (userId) references voxb_users(userId) ON DELETE CASCADE,
	CONSTRAINT voxb_items_pk PRIMARY KEY (itemIdentifierValue)
);
create table voxb_tags (
	tagId number NOT NULL,
  itemId varchar2(32) NOT NULL,
	tag varchar2(32) NOT NULL,
	CONSTRAINT ref_tag_id FOREIGN KEY (itemId) references voxb_items(itemIdentifierValue) ON DELETE CASCADE,
	CONSTRAINT voxb_tags_pk PRIMARY KEY (tagId)
);
create table voxb_reviews (
  reviewId number NOT NULL,
  itemId varchar2(32) NOT NULL,
	title varchar2(32) DEFAULT NULL,
	type varchar2(10) DEFAULT NULL,
	data varchar2(4000) DEFAULT NULL,
	CONSTRAINT ref_reviews_items_id FOREIGN KEY (itemId) references voxb_items(itemIdentifierValue) ON DELETE CASCADE,
  CONSTRAINT voxb_reviews_pk PRIMARY KEY (reviewId)
);
create table voxb_locals (
  localId number NOT NULL,
  itemId varchar2(32) NOT NULL,
	data varchar2(4000) DEFAULT NULL,
	type varchar2(10) DEFAULT NULL,
	itemType varchar2(64) DEFAULT NULL,
	CONSTRAINT ref_locals_items_id FOREIGN KEY (itemId) references voxb_items(itemIdentifierValue) ON DELETE CASCADE,
  CONSTRAINT voxb_locals_pk PRIMARY KEY (localId)
);
create table voxb_complaints (
  complaintId number NOT NULL,
	offender_institutionId number,
	offender_institutionName varchar2(128) DEFAULT NULL,
  offender_userId number NOT NULL,
	offending_itemId varchar(32) NOT NULL,
  complainant_userId number NOT NULL,
  status varchar2(16) NOT NULL,
  creation_date date default sysdate NOT NULL,
	CONSTRAINT ref_off_institutionName FOREIGN KEY (offender_institutionId) references voxb_institutions(institutionId),
  CONSTRAINT ref_off_userId FOREIGN KEY (offender_userId) references voxb_users(userId),
  CONSTRAINT ref_com_itemId FOREIGN KEY (offending_itemId) references voxb_items(itemIdentifierValue),
  CONSTRAINT ref_com_userId FOREIGN KEY (complainant_userId) references voxb_users(userId),
  CONSTRAINT voxb_com_pk PRIMARY KEY (complaintId)
);
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

CREATE OR REPLACE TRIGGER voxb_seq_users BEFORE INSERT ON voxb_users FOR EACH ROW BEGIN SELECT voxb_users_seq.NEXTVAL INTO :NEW.userId FROM DUAL; END; 
/
CREATE OR REPLACE TRIGGER voxb_seq_objects BEFORE INSERT ON voxb_objects FOR EACH ROW BEGIN SELECT voxb_objects_seq.NEXTVAL INTO :NEW.objectId FROM DUAL; END; 
/
CREATE OR REPLACE TRIGGER voxb_seq_reviews BEFORE INSERT ON voxb_reviews FOR EACH ROW BEGIN SELECT voxb_reviews_seq.NEXTVAL INTO :NEW.reviewId FROM DUAL; END; 
/
CREATE OR REPLACE TRIGGER voxb_seq_locals BEFORE INSERT ON voxb_locals FOR EACH ROW BEGIN SELECT voxb_locals_seq.NEXTVAL INTO :NEW.localId FROM DUAL; END; 
/
CREATE OR REPLACE TRIGGER voxb_seq_tags BEFORE INSERT ON voxb_tags FOR EACH ROW BEGIN SELECT voxb_tags_seq.NEXTVAL INTO :NEW.tagId FROM DUAL; END; 
/
CREATE OR REPLACE TRIGGER voxb_seq_items BEFORE INSERT ON voxb_items FOR EACH ROW BEGIN SELECT voxb_items_seq.NEXTVAL INTO :NEW.itemIdentifierValue FROM DUAL; END; 
/
CREATE OR REPLACE TRIGGER voxb_seq_complaints BEFORE INSERT ON voxb_complaints FOR EACH ROW BEGIN SELECT voxb_complaints_seq.NEXTVAL INTO :NEW.complaintId FROM DUAL; END;
/
CREATE OR REPLACE TRIGGER voxb_seq_logs BEFORE INSERT ON voxb_logs FOR EACH ROW BEGIN SELECT voxb_logs_seq.NEXTVAL INTO :NEW.logId FROM DUAL; END;
/

create index voxb_users_idx on voxb_users (userIdentifierValue,userIdentifierType,identityProvider,institutionName,disabled);
create index voxb_objects_idx on voxb_objects (objectIdentifierValue,objectIdentifierType,objectTitle,objectContributors);
create index voxb_reviews_idx on voxb_reviews (reviewId, title, type, data);
create index voxb_locals_idx on voxb_locals (localId, data, type, itemType);
create index voxb_tags_idx on voxb_tags (tagId, itemId, tag);
create index voxb_items_idx on voxb_items (objectId,disabled);
create index voxb_logs_idx on voxb_logs (logId,method);
