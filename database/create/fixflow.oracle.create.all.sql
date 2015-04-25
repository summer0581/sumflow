﻿CREATE TABLE FIXFLOW_AGENT_AGENTDETAILS (
	AGENT_ID VARCHAR2(64) NOT NULL, 
	PROCESS_ID VARCHAR2(256) NOT NULL, 
	PROCESS_NAME VARCHAR2(512), 
	NODE_ID VARCHAR2(1024), 
	NODE_NAME VARCHAR2(1024), 
	AUSER VARCHAR2(64), 
	AUSERNAME VARCHAR2(64), 
	GUID VARCHAR2(64) NOT NULL
)
;
ALTER TABLE FIXFLOW_AGENT_AGENTDETAILS
  ADD CONSTRAINT PK_FIXFLOW_AGENT_AGENTDETAILS PRIMARY KEY (GUID)
;

CREATE TABLE FIXFLOW_AGENT_AGENTINFO (
	AGENT_ID VARCHAR2(64) NOT NULL ENABLE, 
	ODATE DATE, 
	OPERATOR VARCHAR2(64), 
	SDATE DATE, 
	EDATE DATE, 
	VIEW_TYPE VARCHAR2(64), 
	STATUS VARCHAR2(20), 
	RESERVER1 VARCHAR2(64), 
	RESERVER2 VARCHAR2(64)
) 
;
ALTER TABLE FIXFLOW_AGENT_AGENTINFO
  ADD CONSTRAINT PK_FIXFLOW_AGENT_AGENTINFO PRIMARY KEY (AGENT_ID)
;

CREATE TABLE FIXFLOW_DEF_BYTEARRAY
(
  ID            VARCHAR2(64) NOT NULL,
  REV           NUMBER(12),
  NAME          VARCHAR2(512),
  BYTES         BLOB,
  DEPLOYMENT_ID VARCHAR2(256)
)
;

CREATE TABLE FIXFLOW_DEF_DEPLOYMENT
(
  ID          VARCHAR2(64) NOT NULL,
  NAME        VARCHAR2(512),
  DEPLOY_TIME TIMESTAMP(6)
)
;
ALTER TABLE FIXFLOW_DEF_DEPLOYMENT
  ADD CONSTRAINT FIXFLOW_DEF_DEPLOYMENT_PK PRIMARY KEY (ID)
  ;

CREATE TABLE FIXFLOW_DEF_PROCESSDEFINITION
(
  DIFINITIONS_KEY       VARCHAR2(512),
  DIFINITIONS_ID        VARCHAR2(512),
  PROCESS_KEY           VARCHAR2(512),
  PROCESS_ID            VARCHAR2(512) NOT NULL,
  CATEGORY              VARCHAR2(255),
  PROCESS_NAME          VARCHAR2(255),
  VERSION               INTEGER,
  RESOURCE_NAME         VARCHAR2(4000),
  DEPLOYMENT_ID         VARCHAR2(64),
  DIAGRAM_RESOURCE_NAME VARCHAR2(512),
  START_FORM_KEY        VARCHAR2(1024),
  RESOURCE_ID           VARCHAR2(64),
  SUB_TASK_ID           VARCHAR2(128)
)
;
COMMENT ON TABLE FIXFLOW_DEF_PROCESSDEFINITION
  IS '流程定义信息'
  ;
COMMENT ON COLUMN FIXFLOW_DEF_PROCESSDEFINITION.DIFINITIONS_KEY
  IS 'DIFINITIONSID:VERSION:自增长ID组成'
  ;
COMMENT ON COLUMN FIXFLOW_DEF_PROCESSDEFINITION.DIFINITIONS_ID
  IS '流程文件DEFINITIONS元素的ID属性值'
  ;
COMMENT ON COLUMN FIXFLOW_DEF_PROCESSDEFINITION.PROCESS_KEY
  IS 'PROCESSID:VERSION:自增长ID组成'
  ;
COMMENT ON COLUMN FIXFLOW_DEF_PROCESSDEFINITION.PROCESS_ID
  IS '流程文件PROCESS元素的ID属性值'
  ;
COMMENT ON COLUMN FIXFLOW_DEF_PROCESSDEFINITION.CATEGORY
  IS '该编号就是流程文件TARGETNAMESPACE的属性值'
  ;
COMMENT ON COLUMN FIXFLOW_DEF_PROCESSDEFINITION.PROCESS_NAME
  IS '流程文件PROCESS元素的NAME属性值'
  ;
COMMENT ON COLUMN FIXFLOW_DEF_PROCESSDEFINITION.VERSION
  IS '流程版本号 发布时加1'
  ;
COMMENT ON COLUMN FIXFLOW_DEF_PROCESSDEFINITION.RESOURCE_NAME
  IS '资源文件名称 一个XML文件名'
  ;
COMMENT ON COLUMN FIXFLOW_DEF_PROCESSDEFINITION.DEPLOYMENT_ID
  IS '发布编号GUID'
  ;
COMMENT ON COLUMN FIXFLOW_DEF_PROCESSDEFINITION.SUB_TASK_ID
  IS '提交节点编号'
  ;
ALTER TABLE FIXFLOW_DEF_PROCESSDEFINITION
  ADD CONSTRAINT FIXFLOW_DEF_PROCESSDEFINI_PK PRIMARY KEY (PROCESS_ID)
  ;

CREATE TABLE FIXFLOW_MAIL
(
  MAIL_ID        VARCHAR2(128) NOT NULL,
  MAIL_NAME      VARCHAR2(4000),
  MAIL_TO        VARCHAR2(4000),
  MAIL_SUBJECT   VARCHAR2(4000),
  MAIL_BODY      BLOB,
  BIZ_TYPE       VARCHAR2(128),
  BIZ_VALUE      VARCHAR2(512),
  MAIL_STATUS    VARCHAR2(64),
  CREATE_TIME    TIMESTAMP(6),
  SEND_TIME      TIMESTAMP(6),
  MAIL_CC        VARCHAR2(4000),
  CREATE_USER    VARCHAR2(64),
  FAILURE_REASON VARCHAR2(4000)
)
;

ALTER TABLE FIXFLOW_MAIL
  ADD CONSTRAINT FIXFLOW_MAIL_PK PRIMARY KEY (MAIL_ID)
;

CREATE TABLE FIXFLOW_RUN_PROCESSINSTANCE
(
  PROCESSINSTANCE_ID       VARCHAR2(64) NOT NULL,
  PROCESSDEFINITION_ID     VARCHAR2(512),
  SUBJECT                  VARCHAR2(4000),
  START_TIME               TIMESTAMP(6),
  END_TIME                 TIMESTAMP(6),
  DEFINITION_ID            VARCHAR2(64),
  ROOTTOKEN_ID             VARCHAR2(64),
  BIZ_KEY                  VARCHAR2(64),
  INITIATOR                VARCHAR2(64),
  ISSUSPENDED              VARCHAR2(20),
  PROCESSDEFINITION_KEY    VARCHAR2(512),
  PARENT_INSTANCE_ID       VARCHAR2(64),
  PARENT_INSTANCE_TOKEN_ID VARCHAR2(64),
  UPDATE_TIME              TIMESTAMP(6),
  START_AUTHOR             VARCHAR2(64),
  PROCESSLOCATION          VARCHAR2(2048),
  ISPIGEONHOLE	           VARCHAR2(1),
  INSTANCE_STATUS          VARCHAR(45),
  ARCHIVE_TIME          TIMESTAMP(6)
)
;
COMMENT ON TABLE FIXFLOW_RUN_PROCESSINSTANCE
  IS '运行时流程实例'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.PROCESSINSTANCE_ID
  IS '流程实例编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.PROCESSDEFINITION_ID
  IS '流程定义唯一编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.SUBJECT
  IS '流程实例主题'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.START_TIME
  IS '开始时间'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.END_TIME
  IS '结束时间'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.DEFINITION_ID
  IS '业务定义编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.ROOTTOKEN_ID
  IS '根令牌编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.BIZ_KEY
  IS '业务数据主键值'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.INITIATOR
  IS '提交人'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.ISSUSPENDED
  IS '是否暂停'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.PROCESSDEFINITION_KEY
  IS '流程定义ID'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.PARENT_INSTANCE_ID
  IS '父流程实例唯一编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_PROCESSINSTANCE.PARENT_INSTANCE_TOKEN_ID
  IS '父流程令牌编号'
  ;
ALTER TABLE FIXFLOW_RUN_PROCESSINSTANCE
  ADD CONSTRAINT FIXFLOW_RUN_PROCESSINSTAN_PK PRIMARY KEY (PROCESSINSTANCE_ID)
  ;

CREATE TABLE FIXFLOW_RUN_TASKINSTANCE
(
  TASKINSTANCE_ID       VARCHAR2(64) NOT NULL,
  PROCESSINSTANCE_ID    VARCHAR2(64),
  PROCESSDEFINITION_ID  VARCHAR2(512),
  VERSION               INTEGER,
  TOKEN_ID              VARCHAR2(64),
  NODE_ID               VARCHAR2(64),
  DESCRIPTION           VARCHAR2(4000),
  PARENTTASK_ID         VARCHAR2(64),
  ASSIGNEE              VARCHAR2(64),
  CLAIM_TIME            TIMESTAMP(6),
  NAME                  VARCHAR2(255),
  CREATE_TIME           TIMESTAMP(6),
  START_TIME            TIMESTAMP(6),
  ISBLOCKING            VARCHAR2(20),
  END_TIME              TIMESTAMP(6),
  DUEDATE               TIMESTAMP(6),
  PRIORITY              NUMBER(6),
  CATEGORY              VARCHAR2(64),
  OWNER                 VARCHAR2(64),
  DELEGATIONSTATESTRING VARCHAR2(64),
  BIZKEY                VARCHAR2(64),
  COMMAND_TYPE          VARCHAR2(256),
  COMMAND_MESSAGE       VARCHAR2(256),
  TASK_COMMENT          VARCHAR2(4000),
  NODE_NAME             VARCHAR2(512),
  PROCESSDEFINITION_KEY VARCHAR2(512),
  FORMURI               VARCHAR2(256),
  TASKGROUP             VARCHAR2(64),
  TASKTYPE              VARCHAR2(64),
  PROCESSDEFINITION_NAME VARCHAR2(512),
  ISCANCELLED VARCHAR2(64),
  ISSUSPENDED VARCHAR2(64),
  ISOPEN VARCHAR2(64),
  ISDRAFT VARCHAR2(64),
  EXPECTED_EXECUTIONTIME NUMBER(12,0),
  AGENT VARCHAR2(64),
  ADMIN VARCHAR(64),
  FORMURIVIEW VARCHAR2(512),
  CALLACTIVITY_INSTANCE_ID VARCHAR2(256),
  COMMAND_ID VARCHAR2(64),
  PENDINGTASKID VARCHAR2(64),
  ARCHIVE_TIME          TIMESTAMP(6)
)
;
COMMENT ON TABLE FIXFLOW_RUN_TASKINSTANCE
  IS '运行时任务实例'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.TASKINSTANCE_ID
  IS '任务实例编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.PROCESSINSTANCE_ID
  IS '流程实例编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.PROCESSDEFINITION_ID
  IS '流程定义编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.VERSION
  IS '流程定义版本号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.TOKEN_ID
  IS '令牌编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.NODE_ID
  IS '节点编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.DESCRIPTION
  IS '任务主题'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.PARENTTASK_ID
  IS '父任务编号，不为空说明是会签（多实例）任务'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.ASSIGNEE
  IS '任务代理人'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.CLAIM_TIME
  IS '领取时间'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.NAME
  IS '任务名称  FLOWNODE的NAME属性'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.CREATE_TIME
  IS '任务到达（创建）时间'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.START_TIME
  IS '开始时间'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.ISBLOCKING
  IS '是否阻塞'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.END_TIME
  IS '结束时间'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.DUEDATE
  IS '处理期限'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.PRIORITY
  IS '优先级别'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.CATEGORY
  IS '任务分类(最终用户决定分类的意义)'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.OWNER
  IS '任务所有者'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.DELEGATIONSTATESTRING
  IS '任务代理状态'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TASKINSTANCE.FORMURI
  IS '表单地址'
  ;
ALTER TABLE FIXFLOW_RUN_TASKINSTANCE
  ADD CONSTRAINT FIXFLOW_RUN_TASKINSTANCE_PK PRIMARY KEY (TASKINSTANCE_ID)
  ;
CREATE INDEX INDEX12 ON FIXFLOW_RUN_TASKINSTANCE (ISBLOCKING)
;
CREATE INDEX INDEX19 ON FIXFLOW_RUN_TASKINSTANCE (PROCESSINSTANCE_ID)
;
CREATE INDEX INDEX2 ON FIXFLOW_RUN_TASKINSTANCE (ASSIGNEE)
;
CREATE INDEX INDEX6 ON FIXFLOW_RUN_TASKINSTANCE (CREATE_TIME)
;

CREATE TABLE FIXFLOW_RUN_TASKIDENTITYLINK
(
  ID                VARCHAR2(64) NOT NULL,
  TYPE              VARCHAR2(64),
  USER_ID           VARCHAR2(64),
  GROUP_ID          VARCHAR2(64),
  GROUP_TYPE        VARCHAR2(64),
  TASKINSTANCE_ID   VARCHAR2(64),
  INCLUDE_EXCLUSION VARCHAR2(64),
  ARCHIVE_TIME          TIMESTAMP(6)
)
;
COMMENT ON COLUMN FIXFLOW_RUN_TASKIDENTITYLINK.ID
  IS '唯一编号'
;
COMMENT ON COLUMN FIXFLOW_RUN_TASKIDENTITYLINK.TYPE
  IS '分配类型'
;
COMMENT ON COLUMN FIXFLOW_RUN_TASKIDENTITYLINK.USER_ID
  IS '用户编号'
;
COMMENT ON COLUMN FIXFLOW_RUN_TASKIDENTITYLINK.GROUP_ID
  IS '组编号'
;
COMMENT ON COLUMN FIXFLOW_RUN_TASKIDENTITYLINK.GROUP_TYPE
  IS '组的类型 (1.部门 2.角色 3.职务......)'
;
COMMENT ON COLUMN FIXFLOW_RUN_TASKIDENTITYLINK.TASKINSTANCE_ID
  IS '关联任务编号'
;
COMMENT ON COLUMN FIXFLOW_RUN_TASKIDENTITYLINK.INCLUDE_EXCLUSION
  IS 'INCLUDE EXCLUSION'
;
ALTER TABLE FIXFLOW_RUN_TASKIDENTITYLINK
  ADD CONSTRAINT FIXFLOW_RUN_TASKIDENTITYL_PK PRIMARY KEY (ID)
;

CREATE TABLE FIXFLOW_RUN_TOKEN
(
  TOKEN_ID                 VARCHAR2(64) NOT NULL,
  NAME                     VARCHAR2(128),
  START_TIME               TIMESTAMP(6),
  END_TIME                 TIMESTAMP(6),
  NODEENTER_TIME           TIMESTAMP(6),
  ISABLETOREACTIVATEPARENT VARCHAR2(64),
  ISSUSPENDED              VARCHAR2(64),
  TOKEN_LOCK               VARCHAR2(64),
  NODE_ID                  VARCHAR2(128),
  PROCESSINSTANCE_ID       VARCHAR2(64),
  PARENT_ID                VARCHAR2(64),
  ISSUBPROCESSROOTTOKEN    VARCHAR2(20),
  FREETOKEN                VARCHAR2(64),
  PARENT_FREETOKEN_ID      VARCHAR2(64),
  ARCHIVE_TIME          TIMESTAMP(6)
)
;
COMMENT ON TABLE FIXFLOW_RUN_TOKEN
  IS '运行时令牌'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TOKEN.TOKEN_ID
  IS '令牌编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TOKEN.NAME
  IS '令牌名称'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TOKEN.START_TIME
  IS '开始时间'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TOKEN.END_TIME
  IS '结束时间'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TOKEN.NODEENTER_TIME
  IS '进入节点的时间'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TOKEN.ISABLETOREACTIVATEPARENT
  IS '能否重新激活父令牌标志'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TOKEN.ISSUSPENDED
  IS '令牌是否处于暂停状态'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TOKEN.TOKEN_LOCK
  IS '锁'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TOKEN.NODE_ID
  IS '令牌所在的当前节点编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TOKEN.PROCESSINSTANCE_ID
  IS '流程实例编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_TOKEN.PARENT_ID
  IS '父级令牌编号'
  ;
ALTER TABLE FIXFLOW_RUN_TOKEN
  ADD CONSTRAINT FIXFLOW_RUN_TOKEN_PK PRIMARY KEY (TOKEN_ID)
  ;
CREATE INDEX INDEX22 ON FIXFLOW_RUN_TOKEN (PROCESSINSTANCE_ID)
;

CREATE TABLE FIXFLOW_RUN_VARIABLE
(
  PROCESSINSTANCE_ID VARCHAR2(64),
  VARIABLE_KEY       VARCHAR2(64),
  VARIABLE_VALUE     BLOB,
  VARIABLE_CLASSNAME VARCHAR2(64),
  TASKINSTANCE_ID VARCHAR2(64),
  TOKEN_ID VARCHAR2(64),
  NODE_ID  VARCHAR2(512),
  ARCHIVE_TIME       TIMESTAMP(6),
  VARIABLE_TYPE VARCHAR2(45),
  BIZ_DATA VARCHAR2(2048)
)
;
COMMENT ON TABLE FIXFLOW_RUN_VARIABLE
  IS '运行时变量'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_VARIABLE.PROCESSINSTANCE_ID
  IS '流程实例编号'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_VARIABLE.VARIABLE_KEY
  IS '变量KEY'
  ;
COMMENT ON COLUMN FIXFLOW_RUN_VARIABLE.VARIABLE_VALUE
  IS '变量VALUE'
  ;
CREATE INDEX INDEX30 ON FIXFLOW_RUN_VARIABLE (PROCESSINSTANCE_ID)
;

CREATE TABLE FIXFLOW_WORKDATE_DES
(

  RULE_ID         VARCHAR2(64) NOT NULL,
  WEEK_NUM        VARCHAR2(64),
  AM_PM          VARCHAR2(64),
  BEGIN_DATE      VARCHAR2(64),
  END_DATE        VARCHAR2(64)
)
;
ALTER TABLE FIXFLOW_WORKDATE_DES ADD CONSTRAINT PK_FIXFLOW_WORKDATE_DES PRIMARY KEY (RULE_ID,WEEK_NUM,AM_PM)
;

CREATE TABLE FIXFLOW_WORKDATE_DETAIL
(
  RULE_ID          VARCHAR2(64) NOT NULL,
  COMMOM_DATE     VARCHAR2(64),
  BEGIN_DATE      VARCHAR2(64),
  END_DATE        VARCHAR2(64),
  AM_PM          VARCHAR2(64),
  IS_WORK      INTEGER,
  MINUTES      INTEGER
)
;
ALTER TABLE FIXFLOW_WORKDATE_DETAIL ADD CONSTRAINT PK_FIXFLOW_WORKDATE_DETAIL PRIMARY KEY (COMMOM_DATE,AM_PM,RULE_ID)
;

CREATE TABLE FIXFLOW_WORKDATE_RULE
(
  RULE_ID         VARCHAR2(64) NOT NULL,
  RULE_NAME      VARCHAR2(64),
  RULE_DESC       VARCHAR(512),
  CREATE_DATE      VARCHAR(512),
  CREATE_USERID    VARCHAR(64),
  CREATE_USERNAME VARCHAR(64),
  FIELD1          VARCHAR(64),
  FIELD2          VARCHAR(64)
)
;
ALTER TABLE FIXFLOW_WORKDATE_RULE ADD CONSTRAINT PK_FIXFLOW_WORKDATE_RULE PRIMARY KEY (RULE_ID)
;

CREATE TABLE FIXFLOW_WORKDATE_SPEC
(
  RULE_ID          VARCHAR2(64) NOT NULL,
  SPEC_DATE       VARCHAR(64),
  BEGIN_DATE      VARCHAR(64),
  END_DATE        VARCHAR(64),
  AM_PM           VARCHAR(64)
)
;
ALTER TABLE FIXFLOW_WORKDATE_SPEC ADD CONSTRAINT PK_FIXFLOW_WORKDATE_SPEC PRIMARY KEY (SPEC_DATE,AM_PM)
;


CREATE TABLE FIXFLOW_WORKDATE_WEEKNUM
(
  WEEK_NUM         VARCHAR2(64) NOT NULL,
  AMPM             VARCHAR2(64) NOT NULL,
  BEGINDATE        VARCHAR2(64) NOT NULL,
  ENDDATE          VARCHAR2(64) NOT NULL
)

;
ALTER TABLE FIXFLOW_WORKDATE_WEEKNUM ADD CONSTRAINT FIXFLOW_WORKDATE_WEEKNUM PRIMARY KEY (WEEK_NUM,AMPM)
;

CREATE TABLE FIXFLOW_HIS_IDENTITYLINK
(
  ID              VARCHAR2(64) NOT NULL,
  TYPE            VARCHAR2(64),
  USER_ID         VARCHAR2(64),
  ROLE_ID         VARCHAR2(64),
  DEPT_ID         VARCHAR2(64),
  TASKINSTANCE_ID VARCHAR2(64)
)
;
ALTER TABLE FIXFLOW_HIS_IDENTITYLINK
  ADD CONSTRAINT FIXFLOW_HIS_IDENTITYLINK_PK PRIMARY KEY (ID)
;

CREATE TABLE FIXFLOW_HIS_PROCESSINSTANCE
(
  PROCESSINSTANCE_ID       VARCHAR2(64) NOT NULL,
  PROCESSDEFINITION_ID     VARCHAR2(512),
  SUBJECT                  VARCHAR2(4000),
  START_TIME               TIMESTAMP(6),
  END_TIME                 TIMESTAMP(6),
  DEFINITION_ID            VARCHAR2(64),
  ROOTTOKEN_ID             VARCHAR2(64),
  BIZ_KEY                  VARCHAR2(64),
  INITIATOR                VARCHAR2(64),
  ISSUSPENDED              VARCHAR2(20),
  PROCESSDEFINITION_KEY    VARCHAR2(512),
  PARENT_INSTANCE_ID       VARCHAR2(64),
  PARENT_INSTANCE_TOKEN_ID VARCHAR2(64),
  UPDATE_TIME              TIMESTAMP(6),
  START_AUTHOR             VARCHAR2(64),
  PROCESSLOCATION          VARCHAR2(2048),
  ISPIGEONHOLE			   VARCHAR2(1),
  INSTANCE_STATUS          VARCHAR(45),
  ARCHIVE_TIME          TIMESTAMP(6)
)
;
COMMENT ON TABLE FIXFLOW_HIS_PROCESSINSTANCE
  IS '运行时流程实例'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.PROCESSINSTANCE_ID
  IS '流程实例编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.PROCESSDEFINITION_ID
  IS '流程定义唯一编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.SUBJECT
  IS '流程实例主题'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.START_TIME
  IS '开始时间'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.END_TIME
  IS '结束时间'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.DEFINITION_ID
  IS '业务定义编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.ROOTTOKEN_ID
  IS '根令牌编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.BIZ_KEY
  IS '业务数据主键值'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.INITIATOR
  IS '提交人'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.ISSUSPENDED
  IS '是否暂停'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.PROCESSDEFINITION_KEY
  IS '流程定义ID'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.PARENT_INSTANCE_ID
  IS '父流程实例唯一编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_PROCESSINSTANCE.PARENT_INSTANCE_TOKEN_ID
  IS '父流程令牌编号'
  ;
ALTER TABLE FIXFLOW_HIS_PROCESSINSTANCE
  ADD CONSTRAINT FIXFLOW_HIS_PROCESSINSTAN_PK PRIMARY KEY (PROCESSINSTANCE_ID)
  ;

CREATE TABLE FIXFLOW_HIS_TASKINSTANCE
(
  TASKINSTANCE_ID       VARCHAR2(64) NOT NULL,
  PROCESSINSTANCE_ID    VARCHAR2(64),
  PROCESSDEFINITION_ID  VARCHAR2(512),
  VERSION               INTEGER,
  TOKEN_ID              VARCHAR2(64),
  NODE_ID               VARCHAR2(64),
  DESCRIPTION           VARCHAR2(4000),
  PARENTTASK_ID         VARCHAR2(64),
  ASSIGNEE              VARCHAR2(64),
  CLAIM_TIME            TIMESTAMP(6),
  NAME                  VARCHAR2(255),
  CREATE_TIME           TIMESTAMP(6),
  START_TIME            TIMESTAMP(6),
  ISBLOCKING            VARCHAR2(20),
  END_TIME              TIMESTAMP(6),
  DUEDATE               TIMESTAMP(6),
  PRIORITY              NUMBER(6),
  CATEGORY              VARCHAR2(64),
  OWNER                 VARCHAR2(64),
  DELEGATIONSTATESTRING VARCHAR2(64),
  BIZKEY                VARCHAR2(64),
  COMMAND_TYPE          VARCHAR2(256),
  COMMAND_MESSAGE       VARCHAR2(256),
  TASK_COMMENT          VARCHAR2(4000),
  NODE_NAME             VARCHAR2(512),
  PROCESSDEFINITION_KEY VARCHAR2(512),
  FORMURI               VARCHAR2(256),
  TASKGROUP             VARCHAR2(64),
  TASKTYPE              VARCHAR2(64),
  PROCESSDEFINITION_NAME VARCHAR2(512),
  ISCANCELLED VARCHAR2(64),
  ISSUSPENDED VARCHAR2(64),
  ISOPEN VARCHAR2(64),
  ISDRAFT VARCHAR2(64),
  EXPECTED_EXECUTIONTIME NUMBER(12,0),
  AGENT VARCHAR2(64),
  ADMIN VARCHAR(64),
  FORMURIVIEW VARCHAR2(512),
  CALLACTIVITY_INSTANCE_ID VARCHAR2(256),
  COMMAND_ID VARCHAR2(64),
  PENDINGTASKID VARCHAR2(64),
  ARCHIVE_TIME          TIMESTAMP(6)
)
;
COMMENT ON TABLE FIXFLOW_HIS_TASKINSTANCE
  IS '运行时任务实例'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.TASKINSTANCE_ID
  IS '任务实例编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.PROCESSINSTANCE_ID
  IS '流程实例编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.PROCESSDEFINITION_ID
  IS '流程定义编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.VERSION
  IS '流程定义版本号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.TOKEN_ID
  IS '令牌编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.NODE_ID
  IS '节点编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.DESCRIPTION
  IS '任务主题'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.PARENTTASK_ID
  IS '父任务编号，不为空说明是会签（多实例）任务'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.ASSIGNEE
  IS '任务代理人'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.CLAIM_TIME
  IS '领取时间'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.NAME
  IS '任务名称  FLOWNODE的NAME属性'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.CREATE_TIME
  IS '任务到达（创建）时间'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.START_TIME
  IS '开始时间'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.ISBLOCKING
  IS '是否阻塞'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.END_TIME
  IS '结束时间'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.DUEDATE
  IS '处理期限'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.PRIORITY
  IS '优先级别'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.CATEGORY
  IS '任务分类(最终用户决定分类的意义)'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.OWNER
  IS '任务所有者'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.DELEGATIONSTATESTRING
  IS '任务代理状态'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TASKINSTANCE.FORMURI
  IS '表单地址'
  ;
ALTER TABLE FIXFLOW_HIS_TASKINSTANCE
  ADD CONSTRAINT FIXFLOW_HIS_TASKINSTANCE_PK PRIMARY KEY (TASKINSTANCE_ID)
  ;
CREATE INDEX HIS_TASKINSTANCE_BLOCK_IDX ON FIXFLOW_HIS_TASKINSTANCE (ISBLOCKING)
;
CREATE INDEX HIS_TASKINSTANCE_PROCESS_ID ON FIXFLOW_HIS_TASKINSTANCE (PROCESSINSTANCE_ID)
;
CREATE INDEX HIS_TASKINSTANCE_ASSIGNEE ON FIXFLOW_HIS_TASKINSTANCE (ASSIGNEE)
;
CREATE INDEX HIS_TASKINSTANCE_CREATE_TIME ON FIXFLOW_HIS_TASKINSTANCE (CREATE_TIME)
;

CREATE TABLE FIXFLOW_HIS_TASKIDENTITYLINK
(
  ID                VARCHAR2(64) NOT NULL,
  TYPE              VARCHAR2(64),
  USER_ID           VARCHAR2(64),
  GROUP_ID          VARCHAR2(64),
  GROUP_TYPE        VARCHAR2(64),
  TASKINSTANCE_ID   VARCHAR2(64),
  INCLUDE_EXCLUSION VARCHAR2(64),
  ARCHIVE_TIME          TIMESTAMP(6)
)
;
COMMENT ON COLUMN FIXFLOW_HIS_TASKIDENTITYLINK.ID
  IS '唯一编号'
;
COMMENT ON COLUMN FIXFLOW_HIS_TASKIDENTITYLINK.TYPE
  IS '分配类型'
;
COMMENT ON COLUMN FIXFLOW_HIS_TASKIDENTITYLINK.USER_ID
  IS '用户编号'
;
COMMENT ON COLUMN FIXFLOW_HIS_TASKIDENTITYLINK.GROUP_ID
  IS '组编号'
;
COMMENT ON COLUMN FIXFLOW_HIS_TASKIDENTITYLINK.GROUP_TYPE
  IS '组的类型 (1.部门 2.角色 3.职务......)'
;
COMMENT ON COLUMN FIXFLOW_HIS_TASKIDENTITYLINK.TASKINSTANCE_ID
  IS '关联任务编号'
;
COMMENT ON COLUMN FIXFLOW_HIS_TASKIDENTITYLINK.INCLUDE_EXCLUSION
  IS 'INCLUDE EXCLUSION'
;
ALTER TABLE FIXFLOW_HIS_TASKIDENTITYLINK
  ADD CONSTRAINT FIXFLOW_HIS_TASKIDENTITYL_PK PRIMARY KEY (ID)
;

CREATE TABLE FIXFLOW_HIS_TOKEN
(
  TOKEN_ID                 VARCHAR2(64) NOT NULL,
  NAME                     VARCHAR2(128),
  START_TIME               TIMESTAMP(6),
  END_TIME                 TIMESTAMP(6),
  NODEENTER_TIME           TIMESTAMP(6),
  ISABLETOREACTIVATEPARENT VARCHAR2(64),
  ISSUSPENDED              VARCHAR2(64),
  TOKEN_LOCK               VARCHAR2(64),
  NODE_ID                  VARCHAR2(128),
  PROCESSINSTANCE_ID       VARCHAR2(64),
  PARENT_ID                VARCHAR2(64),
  ISSUBPROCESSROOTTOKEN    VARCHAR2(20),
  FREETOKEN                VARCHAR2(64),
  PARENT_FREETOKEN_ID      VARCHAR2(64),
  ARCHIVE_TIME          TIMESTAMP(6)
)
;
COMMENT ON TABLE FIXFLOW_HIS_TOKEN
  IS '运行时令牌'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TOKEN.TOKEN_ID
  IS '令牌编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TOKEN.NAME
  IS '令牌名称'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TOKEN.START_TIME
  IS '开始时间'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TOKEN.END_TIME
  IS '结束时间'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TOKEN.NODEENTER_TIME
  IS '进入节点的时间'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TOKEN.ISABLETOREACTIVATEPARENT
  IS '能否重新激活父令牌标志'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TOKEN.ISSUSPENDED
  IS '令牌是否处于暂停状态'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TOKEN.TOKEN_LOCK
  IS '锁'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TOKEN.NODE_ID
  IS '令牌所在的当前节点编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TOKEN.PROCESSINSTANCE_ID
  IS '流程实例编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_TOKEN.PARENT_ID
  IS '父级令牌编号'
  ;
ALTER TABLE FIXFLOW_HIS_TOKEN
  ADD CONSTRAINT FIXFLOW_HIS_TOKEN_PK PRIMARY KEY (TOKEN_ID)
  ;
CREATE INDEX HIS_TOKEN_PROCESSINSTANCE_ID ON FIXFLOW_HIS_TOKEN (PROCESSINSTANCE_ID)
;

CREATE TABLE FIXFLOW_HIS_VARIABLE
(
  PROCESSINSTANCE_ID VARCHAR2(64),
  VARIABLE_KEY       VARCHAR2(64),
  VARIABLE_VALUE     BLOB,
  VARIABLE_CLASSNAME VARCHAR2(64),
  TASKINSTANCE_ID VARCHAR2(64),
  TOKEN_ID VARCHAR2(64),
  NODE_ID  VARCHAR2(512),
  ARCHIVE_TIME          TIMESTAMP(6),
  VARIABLE_TYPE VARCHAR2(45),
  BIZ_DATA VARCHAR2(2048)
)
;
COMMENT ON TABLE FIXFLOW_HIS_VARIABLE
  IS '运行时变量'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_VARIABLE.PROCESSINSTANCE_ID
  IS '流程实例编号'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_VARIABLE.VARIABLE_KEY
  IS '变量KEY'
  ;
COMMENT ON COLUMN FIXFLOW_HIS_VARIABLE.VARIABLE_VALUE
  IS '变量VALUE'
  ;
CREATE INDEX HIS_VARIABLE_PROCESS_ID ON FIXFLOW_HIS_VARIABLE (PROCESSINSTANCE_ID)
;


CREATE TABLE AU_ROLEINFO
(
  ROLEID       VARCHAR2(50) NOT NULL,
  NAME         VARCHAR2(50),
  BIZTYPE      VARCHAR2(50),
  PRUGROUP     VARCHAR2(50),
  PLATFORM     VARCHAR2(50),
  MEMO         VARCHAR2(500),
  UPDATE_BY    VARCHAR2(50),
  CREATE_BY    VARCHAR2(50),
  CREATE_DT    DATE,
  UPDATE_DT    DATE,
  STATUS    VARCHAR2(10),
  CREATE_ORGID VARCHAR2(50),
  LEVELNUM  NUMBER(6,0) DEFAULT 0,
  ENAME VARCHAR2(128)
)
;
COMMENT ON TABLE AU_ROLEINFO
  IS '角色信息表'
  ;
COMMENT ON COLUMN AU_ROLEINFO.ROLEID
  IS '角色编号'
  ;
COMMENT ON COLUMN AU_ROLEINFO.NAME
  IS '角色名称'
  ;
COMMENT ON COLUMN AU_ROLEINFO.BIZTYPE
  IS '所属业务类别(1营销、2服务、3投顾)'
  ;
COMMENT ON COLUMN AU_ROLEINFO.PRUGROUP
  IS '权限分组(1功能角色、2数据角色、3赋权角色)'
  ;
COMMENT ON COLUMN AU_ROLEINFO.PLATFORM
  IS '所属平台'
  ;
COMMENT ON COLUMN AU_ROLEINFO.MEMO
  IS '描述'
  ;
ALTER TABLE AU_ROLEINFO
  ADD CONSTRAINT PK_AU_ROLEINFO PRIMARY KEY (ROLEID)
  ;

CREATE TABLE AU_USERINFO
(
  USERID        VARCHAR2(50) NOT NULL,
  USERNAME      VARCHAR2(50),
  LOGINID       VARCHAR2(50),
  JOBID         VARCHAR2(50),
  PASSWORD      VARCHAR2(50),
  CONF_PASSWORD VARCHAR2(50),
  ISADMIN       INTEGER DEFAULT 0,
  EMAIL         VARCHAR2(50),
  TELEPHONE     VARCHAR2(30),
  MOBILEPHONE   VARCHAR2(30),
  FAX           VARCHAR2(30),
  TITLEOFPOST   VARCHAR2(30),
  WORKED_TIME   DATE,
  ISENABLE      INTEGER DEFAULT 1,
  MEMO          NVARCHAR2(1000),
  CREATE_BY     VARCHAR2(50),
  CREATE_DT     DATE,
  UPDATE_BY     VARCHAR2(50),
  UPDATE_DT     DATE,
  SSOID         VARCHAR2(50),
  POSITION		VARCHAR2(64),
  LOCATION_NAME VARCHAR2(64),
  IMG VARCHAR2(64),
  SUPERLEADER  VARCHAR2(64)
)
;
COMMENT ON TABLE AU_USERINFO
  IS '用户表'
  ;
COMMENT ON COLUMN AU_USERINFO.USERID
  IS '用户编号'
  ;
COMMENT ON COLUMN AU_USERINFO.USERNAME
  IS '用户姓名'
  ;
COMMENT ON COLUMN AU_USERINFO.LOGINID
  IS '登录帐号'
  ;
COMMENT ON COLUMN AU_USERINFO.JOBID
  IS '工号'
  ;
COMMENT ON COLUMN AU_USERINFO.PASSWORD
  IS '密码'
  ;
COMMENT ON COLUMN AU_USERINFO.CONF_PASSWORD
  IS '用于流程处理 密码确认'
  ;
COMMENT ON COLUMN AU_USERINFO.EMAIL
  IS '电子邮件'
  ;
COMMENT ON COLUMN AU_USERINFO.TELEPHONE
  IS '电话'
  ;
COMMENT ON COLUMN AU_USERINFO.MOBILEPHONE
  IS '移动电话'
  ;
COMMENT ON COLUMN AU_USERINFO.FAX
  IS '传真'
  ;
COMMENT ON COLUMN AU_USERINFO.ISENABLE
  IS '是否有效'
  ;
COMMENT ON COLUMN AU_USERINFO.MEMO
  IS '备注'
  ;
COMMENT ON COLUMN AU_USERINFO.CREATE_BY
  IS '创建人'
  ;
COMMENT ON COLUMN AU_USERINFO.CREATE_DT
  IS '创建时间'
  ;
COMMENT ON COLUMN AU_USERINFO.UPDATE_BY
  IS '更新人'
  ;
COMMENT ON COLUMN AU_USERINFO.UPDATE_DT
  IS '更新时间'
  ;
COMMENT ON COLUMN AU_USERINFO.SSOID
  IS '单点登录标示号'
  ;
ALTER TABLE AU_USERINFO
  ADD CONSTRAINT PK_AU_USERINFO PRIMARY KEY (USERID)
  ;

CREATE TABLE FIX_GROUP_RELATION
(
  GUID          VARCHAR2(50) NOT NULL,
  USER_ID    VARCHAR2(50) NOT NULL,
  GROUP_ID      VARCHAR2(50) NOT NULL,
  GROUP_TYPE    VARCHAR2(50) NOT NULL,
  IS_PRIDUTY VARCHAR2(50),
  IS_DEPUTE  VARCHAR2(10),
  CREATE_DT     DATE NOT NULL,
  UPDATE_DT     DATE NOT NULL,
  CREATE_BY     VARCHAR2(50) NOT NULL,
  UPDATE_BY     VARCHAR2(50) NOT NULL
)
;

ALTER TABLE FIX_GROUP_RELATION
  ADD PRIMARY KEY (GUID)
;

CREATE TABLE AU_ORGINFO
(
  ORGID      VARCHAR2(50) NOT NULL,
  SUPORGID   VARCHAR2(50),
  ORGNAME    VARCHAR2(200),
  ORGLEVELID VARCHAR2(50),
  UPDATE_BY  VARCHAR2(50),
  UPDATE_DT  DATE,
  CREATE_BY  VARCHAR2(50),
  UNIT_TYPE  VARCHAR2(50),
  CREATE_DT  DATE,
  ONSTATUS   NUMBER(12),
  SORT_ORDER NUMBER(12),
  ORGPATH VARCHAR2(800)
)
;
COMMENT ON TABLE AU_ORGINFO
  IS '组织结构表'
  ;
COMMENT ON COLUMN AU_ORGINFO.ORGID
  IS '组织编号'
  ;
COMMENT ON COLUMN AU_ORGINFO.SUPORGID
  IS '上级组织编号'
  ;
COMMENT ON COLUMN AU_ORGINFO.ORGNAME
  IS '组织名'
  ;
COMMENT ON COLUMN AU_ORGINFO.ORGLEVELID
  IS '组织级别'
  ;
COMMENT ON COLUMN AU_ORGINFO.UPDATE_BY
  IS '更新人'
  ;
COMMENT ON COLUMN AU_ORGINFO.UPDATE_DT
  IS '更新时间'
  ;
COMMENT ON COLUMN AU_ORGINFO.CREATE_BY
  IS '创建人'
  ;
COMMENT ON COLUMN AU_ORGINFO.SORT_ORDER
  IS '排序'
  ;
ALTER TABLE AU_ORGINFO
  ADD CONSTRAINT PK_AU_ORGINFO PRIMARY KEY (ORGID)
  ;



--
-- A hint submitted by a user: Oracle DB MUST be created as "shared" and the 
-- job_queue_processes parameter  must be greater than 2, otherwise a DB lock 
-- will happen.   However, these settings are pretty much standard after any
-- Oracle install, so most users need not worry about this.
--
-- Many other users (including the primary author of Quartz) have had success
-- runing in dedicated mode, so only consider the above as a hint -)
--

-- delete from qrtz_fired_triggers
-- delete from qrtz_simple_triggers
-- delete from qrtz_simprop_triggers
-- delete from qrtz_cron_triggers
-- delete from qrtz_blob_triggers
-- delete from qrtz_triggers
-- delete from qrtz_job_details
-- delete from qrtz_calendars
-- delete from qrtz_paused_trigger_grps
-- delete from qrtz_locks
-- delete from qrtz_scheduler_state

-- drop table qrtz_calendars
-- drop table qrtz_fired_triggers
-- drop table qrtz_blob_triggers
-- drop table qrtz_cron_triggers
-- drop table qrtz_simple_triggers
-- drop table qrtz_simprop_triggers
-- drop table qrtz_triggers
-- drop table qrtz_job_details
-- drop table qrtz_paused_trigger_grps
-- drop table qrtz_locks
-- drop table qrtz_scheduler_state


CREATE TABLE qrtz_job_details
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    JOB_NAME  VARCHAR2(200) NOT NULL,
    JOB_GROUP VARCHAR2(200) NOT NULL,
    DESCRIPTION VARCHAR2(250) NULL,
    JOB_CLASS_NAME   VARCHAR2(250) NOT NULL, 
    IS_DURABLE VARCHAR2(1) NOT NULL,
    IS_NONCONCURRENT VARCHAR2(1) NOT NULL,
    IS_UPDATE_DATA VARCHAR2(1) NOT NULL,
    REQUESTS_RECOVERY VARCHAR2(1) NOT NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
)
;
CREATE TABLE qrtz_triggers
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    JOB_NAME  VARCHAR2(200) NOT NULL, 
    JOB_GROUP VARCHAR2(200) NOT NULL,
    DESCRIPTION VARCHAR2(250) NULL,
    NEXT_FIRE_TIME NUMBER(13) NULL,
    PREV_FIRE_TIME NUMBER(13) NULL,
    PRIORITY NUMBER(13) NULL,
    TRIGGER_STATE VARCHAR2(16) NOT NULL,
    TRIGGER_TYPE VARCHAR2(8) NOT NULL,
    START_TIME NUMBER(13) NOT NULL,
    END_TIME NUMBER(13) NULL,
    CALENDAR_NAME VARCHAR2(200) NULL,
    MISFIRE_INSTR NUMBER(2) NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,JOB_NAME,JOB_GROUP) 
	REFERENCES QRTZ_JOB_DETAILS(SCHED_NAME,JOB_NAME,JOB_GROUP) 
)
;
CREATE TABLE qrtz_simple_triggers
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    REPEAT_COUNT NUMBER(7) NOT NULL,
    REPEAT_INTERVAL NUMBER(12) NOT NULL,
    TIMES_TRIGGERED NUMBER(10) NOT NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) 
	REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
)
;
CREATE TABLE qrtz_cron_triggers
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    CRON_EXPRESSION VARCHAR2(120) NOT NULL,
    TIME_ZONE_ID VARCHAR2(80),
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) 
	REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
)
;
CREATE TABLE qrtz_simprop_triggers
  (          
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    STR_PROP_1 VARCHAR(512) NULL,
    STR_PROP_2 VARCHAR(512) NULL,
    STR_PROP_3 VARCHAR(512) NULL,
    INT_PROP_1 NUMBER(10) NULL,
    INT_PROP_2 NUMBER(10) NULL,
    LONG_PROP_1 NUMBER(13) NULL,
    LONG_PROP_2 NUMBER(13) NULL,
    DEC_PROP_1 NUMERIC(13,4) NULL,
    DEC_PROP_2 NUMERIC(13,4) NULL,
    BOOL_PROP_1 VARCHAR(1) NULL,
    BOOL_PROP_2 VARCHAR(1) NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) 
    REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
)
;
CREATE TABLE qrtz_blob_triggers
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    BLOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) 
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
)
;
CREATE TABLE qrtz_calendars
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    CALENDAR_NAME  VARCHAR2(200) NOT NULL, 
    CALENDAR BLOB NOT NULL,
    PRIMARY KEY (SCHED_NAME,CALENDAR_NAME)
)
;
CREATE TABLE qrtz_paused_trigger_grps
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_GROUP  VARCHAR2(200) NOT NULL, 
    PRIMARY KEY (SCHED_NAME,TRIGGER_GROUP)
)
;
CREATE TABLE qrtz_fired_triggers 
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    ENTRY_ID VARCHAR2(95) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    INSTANCE_NAME VARCHAR2(200) NOT NULL,
    FIRED_TIME NUMBER(13) NOT NULL,
    PRIORITY NUMBER(13) NOT NULL,
    STATE VARCHAR2(16) NOT NULL,
    JOB_NAME VARCHAR2(200) NULL,
    JOB_GROUP VARCHAR2(200) NULL,
    IS_NONCONCURRENT VARCHAR2(1) NULL,
    REQUESTS_RECOVERY VARCHAR2(1) NULL,
    PRIMARY KEY (SCHED_NAME,ENTRY_ID)
)
;
CREATE TABLE qrtz_scheduler_state 
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    INSTANCE_NAME VARCHAR2(200) NOT NULL,
    LAST_CHECKIN_TIME NUMBER(13) NOT NULL,
    CHECKIN_INTERVAL NUMBER(13) NOT NULL,
    PRIMARY KEY (SCHED_NAME,INSTANCE_NAME)
)
;
CREATE TABLE qrtz_locks
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    LOCK_NAME  VARCHAR2(40) NOT NULL, 
    PRIMARY KEY (SCHED_NAME,LOCK_NAME)
)
;

-- Create table
create table DEMOTABLE
(
  COL1 VARCHAR2(50),
  COL2 VARCHAR2(50)
);

create index idx_qrtz_j_req_recovery on qrtz_job_details(SCHED_NAME,REQUESTS_RECOVERY)
;
create index idx_qrtz_j_grp on qrtz_job_details(SCHED_NAME,JOB_GROUP)
;
create index idx_qrtz_t_j on qrtz_triggers(SCHED_NAME,JOB_NAME,JOB_GROUP)
;
create index idx_qrtz_t_jg on qrtz_triggers(SCHED_NAME,JOB_GROUP)
;
create index idx_qrtz_t_c on qrtz_triggers(SCHED_NAME,CALENDAR_NAME)
;
create index idx_qrtz_t_g on qrtz_triggers(SCHED_NAME,TRIGGER_GROUP)
;
create index idx_qrtz_t_state on qrtz_triggers(SCHED_NAME,TRIGGER_STATE)
;
create index idx_qrtz_t_n_state on qrtz_triggers(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP,TRIGGER_STATE)
;
create index idx_qrtz_t_n_g_state on qrtz_triggers(SCHED_NAME,TRIGGER_GROUP,TRIGGER_STATE)
;
create index idx_qrtz_t_next_fire_time on qrtz_triggers(SCHED_NAME,NEXT_FIRE_TIME)
;
create index idx_qrtz_t_nft_st on qrtz_triggers(SCHED_NAME,TRIGGER_STATE,NEXT_FIRE_TIME)
;
create index idx_qrtz_t_nft_misfire on qrtz_triggers(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME)
;
create index idx_qrtz_t_nft_st_misfire on qrtz_triggers(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_STATE)
;
create index idx_qrtz_t_nft_st_misfire_grp on qrtz_triggers(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_GROUP,TRIGGER_STATE)
;
create index idx_qrtz_ft_trig_inst_name on qrtz_fired_triggers(SCHED_NAME,INSTANCE_NAME)
;
create index idx_qrtz_ft_inst_job_req_rcvry on qrtz_fired_triggers(SCHED_NAME,INSTANCE_NAME,REQUESTS_RECOVERY)
;
create index idx_qrtz_ft_j_g on qrtz_fired_triggers(SCHED_NAME,JOB_NAME,JOB_GROUP)
;
create index idx_qrtz_ft_jg on qrtz_fired_triggers(SCHED_NAME,JOB_GROUP)
;
create index idx_qrtz_ft_t_g on qrtz_fired_triggers(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
;
create index idx_qrtz_ft_tg on qrtz_fired_triggers(SCHED_NAME,TRIGGER_GROUP)
;






delete AU_USERINFO
;
insert into AU_USERINFO (userid, username, loginid, jobid, password, conf_password, isadmin, email, telephone, mobilephone, fax, titleofpost, worked_time, isenable, memo, create_by, create_dt, update_by, update_dt, ssoid)
values ('1200119390', '管理员', 'admin', null, '21218cca77804d2ba1922c33e0151105', '21218cca77804d2ba1922c33e0151105', 1, 'test@QQ.COM', '8888888', '8888888', null, null, null, 1, '610303691230381', 'orig', to_date('06-02-2010 22:08:39', 'dd-mm-yyyy hh24:mi:ss'), '1200298057', to_date('05-11-2010 14:18:40', 'dd-mm-yyyy hh24:mi:ss'), '11138')
;