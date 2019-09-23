 
-- Dumping structure for table orchestration.active_executing_flows
DROP TABLE IF EXISTS `active_executing_flows`;
CREATE TABLE IF NOT EXISTS `active_executing_flows` (
  `exec_id` int(11) NOT NULL,
  `update_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`exec_id`)
);

 
-- Dumping structure for table orchestration.active_sla
DROP TABLE IF EXISTS `active_sla`;
CREATE TABLE IF NOT EXISTS `active_sla` (
  `exec_id` int(11) NOT NULL,
  `job_name` varchar(128) NOT NULL,
  `check_time` bigint(20) NOT NULL,
  `rule` tinyint(4) NOT NULL,
  `enc_type` tinyint(4) DEFAULT NULL,
  `options` longblob NOT NULL,
  PRIMARY KEY (`exec_id`,`job_name`)
);

 
-- Dumping structure for table orchestration.execution_dependencies
DROP TABLE IF EXISTS `execution_dependencies`;
CREATE TABLE IF NOT EXISTS `execution_dependencies` (
  `trigger_instance_id` varchar(64) NOT NULL,
  `dep_name` varchar(128) NOT NULL,
  `starttime` bigint(20) NOT NULL,
  `endtime` bigint(20) DEFAULT NULL,
  `dep_status` tinyint(4) NOT NULL,
  `cancelleation_cause` tinyint(4) NOT NULL,
  `project_id` int(11) NOT NULL,
  `project_version` int(11) NOT NULL,
  `flow_id` varchar(128) NOT NULL,
  `flow_version` int(11) NOT NULL,
  `flow_exec_id` int(11) NOT NULL,
  PRIMARY KEY (`trigger_instance_id`,`dep_name`),
  KEY `ex_end_time` (`endtime`)
);

 
-- Dumping structure for table orchestration.execution_flows
DROP TABLE IF EXISTS `execution_flows`;
CREATE TABLE IF NOT EXISTS `execution_flows` (
  `exec_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `flow_id` varchar(128) NOT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `submit_user` varchar(64) DEFAULT NULL,
  `submit_time` bigint(20) DEFAULT NULL,
  `update_time` bigint(20) DEFAULT NULL,
  `start_time` bigint(20) DEFAULT NULL,
  `end_time` bigint(20) DEFAULT NULL,
  `enc_type` tinyint(4) DEFAULT NULL,
  `flow_data` longblob DEFAULT NULL,
  `executor_id` int(11) DEFAULT NULL,
  `use_executor` int(11) DEFAULT NULL,
  `flow_priority` tinyint(4) NOT NULL DEFAULT 5,
  PRIMARY KEY (`exec_id`),
  KEY `ex_flows_start_time` (`start_time`),
  KEY `ex_flows_end_time` (`end_time`),
  KEY `ex_flows_time_range` (`start_time`,`end_time`),
  KEY `ex_flows_flows` (`project_id`,`flow_id`),
  KEY `executor_id` (`executor_id`),
  KEY `ex_flows_staus` (`status`)
);

 
-- Dumping structure for table orchestration.execution_jobs
DROP TABLE IF EXISTS `execution_jobs`;
CREATE TABLE IF NOT EXISTS `execution_jobs` (
  `exec_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `flow_id` varchar(128) NOT NULL,
  `job_id` varchar(512) NOT NULL,
  `attempt` int(11) NOT NULL,
  `start_time` bigint(20) DEFAULT NULL,
  `end_time` bigint(20) DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `input_params` longblob DEFAULT NULL,
  `output_params` longblob DEFAULT NULL,
  `attachments` longblob DEFAULT NULL,
  PRIMARY KEY (`exec_id`,`job_id`,`flow_id`,`attempt`),
  KEY `ex_job_id` (`project_id`,`job_id`)
);

 
-- Dumping structure for table orchestration.execution_logs
DROP TABLE IF EXISTS `execution_logs`;
CREATE TABLE IF NOT EXISTS `execution_logs` (
  `exec_id` int(11) NOT NULL,
  `name` varchar(640) NOT NULL,
  `attempt` int(11) NOT NULL,
  `enc_type` tinyint(4) DEFAULT NULL,
  `start_byte` int(11) NOT NULL,
  `end_byte` int(11) DEFAULT NULL,
  `log` longblob DEFAULT NULL,
  `upload_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`exec_id`,`name`,`attempt`,`start_byte`),
  KEY `ex_log_attempt` (`exec_id`,`name`,`attempt`),
  KEY `ex_log_index` (`exec_id`,`name`),
  KEY `ex_log_upload_time` (`upload_time`)
);

 
-- Dumping structure for table orchestration.executors
DROP TABLE IF EXISTS `executors`;
CREATE TABLE IF NOT EXISTS `executors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host` varchar(64) NOT NULL,
  `port` int(11) NOT NULL,
  `active` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `host` (`host`,`port`),
  KEY `executor_connection` (`host`,`port`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

 
-- Dumping structure for table orchestration.executor_events
DROP TABLE IF EXISTS `executor_events`;
CREATE TABLE IF NOT EXISTS `executor_events` (
  `executor_id` int(11) NOT NULL,
  `event_type` tinyint(4) NOT NULL,
  `event_time` datetime NOT NULL,
  `username` varchar(64) DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL,
  KEY `executor_log` (`executor_id`,`event_time`)
);

 
-- Dumping structure for table orchestration.projects
DROP TABLE IF EXISTS `projects`;
CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `modified_time` bigint(20) NOT NULL,
  `create_time` bigint(20) NOT NULL,
  `version` int(11) DEFAULT NULL,
  `last_modified_by` varchar(64) NOT NULL,
  `description` varchar(2048) DEFAULT NULL,
  `enc_type` tinyint(4) DEFAULT NULL,
  `settings_blob` longblob DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_name` (`name`)
);

 
-- Dumping structure for table orchestration.project_events
DROP TABLE IF EXISTS `project_events`;
CREATE TABLE IF NOT EXISTS `project_events` (
  `project_id` int(11) NOT NULL,
  `event_type` tinyint(4) NOT NULL,
  `event_time` bigint(20) NOT NULL,
  `username` varchar(64) DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL,
  KEY `log` (`project_id`,`event_time`)
);

 
-- Dumping structure for table orchestration.project_files
DROP TABLE IF EXISTS `project_files`;
CREATE TABLE IF NOT EXISTS `project_files` (
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `chunk` int(11) NOT NULL,
  `size` int(11) DEFAULT NULL,
  `file` longblob DEFAULT NULL,
  PRIMARY KEY (`project_id`,`version`,`chunk`),
  KEY `file_version` (`project_id`,`version`)
);

 
-- Dumping structure for table orchestration.project_flows
DROP TABLE IF EXISTS `project_flows`;
CREATE TABLE IF NOT EXISTS `project_flows` (
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `flow_id` varchar(128) NOT NULL,
  `modified_time` bigint(20) NOT NULL,
  `encoding_type` tinyint(4) DEFAULT NULL,
  `json` blob DEFAULT NULL,
  PRIMARY KEY (`project_id`,`version`,`flow_id`),
  KEY `flow_index` (`project_id`,`version`)
);

 
-- Dumping structure for table orchestration.project_flow_files
DROP TABLE IF EXISTS `project_flow_files`;
CREATE TABLE IF NOT EXISTS `project_flow_files` (
  `project_id` int(11) NOT NULL,
  `project_version` int(11) NOT NULL,
  `flow_name` varchar(128) NOT NULL,
  `flow_version` int(11) NOT NULL,
  `modified_time` bigint(20) NOT NULL,
  `flow_file` longblob DEFAULT NULL,
  PRIMARY KEY (`project_id`,`project_version`,`flow_name`,`flow_version`)
);

 
-- Dumping structure for table orchestration.project_flow_status
DROP TABLE IF EXISTS `project_flow_status`;
CREATE TABLE IF NOT EXISTS `project_flow_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lob` varchar(10) NOT NULL,
  `source` text NOT NULL,
  `target` varchar(100) NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'READY',
  `error_message` varchar(4000) DEFAULT NULL,
  `begin_date` bigint(20) DEFAULT NULL,
  `end_date` bigint(20) DEFAULT NULL,
  `latest_execution_time` bigint(20) DEFAULT NULL,
  `execution_options` text DEFAULT NULL,
  PRIMARY KEY (`id`)
);

 
-- Dumping structure for table orchestration.project_permissions
DROP TABLE IF EXISTS `project_permissions`;
CREATE TABLE IF NOT EXISTS `project_permissions` (
  `project_id` varchar(64) NOT NULL,
  `modified_time` bigint(20) NOT NULL,
  `name` varchar(64) NOT NULL,
  `permissions` int(11) NOT NULL,
  `isGroup` tinyint(1) NOT NULL,
  PRIMARY KEY (`project_id`,`name`),
  KEY `permission_index` (`project_id`)
);

 
-- Dumping structure for table orchestration.project_properties
DROP TABLE IF EXISTS `project_properties`;
CREATE TABLE IF NOT EXISTS `project_properties` (
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `modified_time` bigint(20) NOT NULL,
  `encoding_type` tinyint(4) DEFAULT NULL,
  `property` blob DEFAULT NULL,
  PRIMARY KEY (`project_id`,`version`,`name`),
  KEY `properties_index` (`project_id`,`version`)
);

 
-- Dumping structure for table orchestration.project_versions
DROP TABLE IF EXISTS `project_versions`;
CREATE TABLE IF NOT EXISTS `project_versions` (
  `project_id` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `upload_time` bigint(20) NOT NULL,
  `uploader` varchar(64) NOT NULL,
  `file_type` varchar(16) DEFAULT NULL,
  `file_name` varchar(128) DEFAULT NULL,
  `md5` binary(16) DEFAULT NULL,
  `num_chunks` int(11) DEFAULT NULL,
  `resource_id` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`project_id`,`version`),
  KEY `version_index` (`project_id`)
);

 
-- Dumping structure for table orchestration.properties
DROP TABLE IF EXISTS `properties`;
CREATE TABLE IF NOT EXISTS `properties` (
  `name` varchar(64) NOT NULL,
  `type` int(11) NOT NULL,
  `modified_time` bigint(20) NOT NULL,
  `value` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`name`,`type`)
);

-- Dumping data for table orchestration.properties: ~18 rows (approximately) 
INSERT INTO `properties` (`name`, `type`, `modified_time`, `value`) VALUES
	('active_executing_flows.version', 1, 1569215465490, '3.10.1'),
	('active_sla.version', 1, 1569215465469, '3.10.1'),
	('execution_dependencies.version', 1, 1569215465349, '3.10.1'),
	('execution_flows.version', 1, 1569215465596, '3.10.1'),
	('execution_jobs.version', 1, 1569215465252, '3.10.1'),
	('execution_logs.version', 1, 1569215465002, '3.10.1'),
	('executors.version', 1, 1569215465641, '3.10.1'),
	('executor_events.version', 1, 1569215465210, '3.10.1'),
	('projects.version', 1, 1569215465103, '3.10.1'),
	('project_events.version', 1, 1569215465444, '3.10.1'),
	('project_files.version', 1, 1569215465145, '3.10.1'),
	('project_flows.version', 1, 1569215465292, '3.10.1'),
	('project_flow_files.version', 1, 1569215465171, '3.10.1'),
	('project_permissions.version', 1, 1569215465678, '3.10.1'),
	('project_properties.version', 1, 1569215465718, '3.10.1'),
	('project_versions.version', 1, 1569215465388, '3.10.1'),
	('properties.version', 1, 1569215464918, '3.10.1'),
	('triggers.version', 1, 1569215465312, '3.10.1');
 
DROP TABLE IF EXISTS `triggers`;
CREATE TABLE IF NOT EXISTS `triggers` (
  `trigger_id` int(11) NOT NULL AUTO_INCREMENT,
  `trigger_source` varchar(128) DEFAULT NULL,
  `modify_time` bigint(20) NOT NULL,
  `enc_type` tinyint(4) DEFAULT NULL,
  `data` longblob DEFAULT NULL,
  PRIMARY KEY (`trigger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;


CREATE TABLE QRTZ_JOB_DETAILS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    JOB_CLASS_NAME   VARCHAR(250) NOT NULL,
    IS_DURABLE VARCHAR(1) NOT NULL,
    IS_NONCONCURRENT VARCHAR(1) NOT NULL,
    IS_UPDATE_DATA VARCHAR(1) NOT NULL,
    REQUESTS_RECOVERY VARCHAR(1) NOT NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
);

CREATE TABLE QRTZ_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    NEXT_FIRE_TIME BIGINT(13) NULL,
    PREV_FIRE_TIME BIGINT(13) NULL,
    PRIORITY INTEGER NULL,
    TRIGGER_STATE VARCHAR(16) NOT NULL,
    TRIGGER_TYPE VARCHAR(8) NOT NULL,
    START_TIME BIGINT(13) NOT NULL,
    END_TIME BIGINT(13) NULL,
    CALENDAR_NAME VARCHAR(200) NULL,
    MISFIRE_INSTR SMALLINT(2) NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
        REFERENCES QRTZ_JOB_DETAILS(SCHED_NAME,JOB_NAME,JOB_GROUP)
);

CREATE TABLE QRTZ_SIMPLE_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    REPEAT_COUNT BIGINT(7) NOT NULL,
    REPEAT_INTERVAL BIGINT(12) NOT NULL,
    TIMES_TRIGGERED BIGINT(10) NOT NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_CRON_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    CRON_EXPRESSION VARCHAR(200) NOT NULL,
    TIME_ZONE_ID VARCHAR(80),
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_SIMPROP_TRIGGERS
  (          
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    STR_PROP_1 VARCHAR(512) NULL,
    STR_PROP_2 VARCHAR(512) NULL,
    STR_PROP_3 VARCHAR(512) NULL,
    INT_PROP_1 INT NULL,
    INT_PROP_2 INT NULL,
    LONG_PROP_1 BIGINT NULL,
    LONG_PROP_2 BIGINT NULL,
    DEC_PROP_1 NUMERIC(13,4) NULL,
    DEC_PROP_2 NUMERIC(13,4) NULL,
    BOOL_PROP_1 VARCHAR(1) NULL,
    BOOL_PROP_2 VARCHAR(1) NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) 
    REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_BLOB_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    BLOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_CALENDARS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    CALENDAR_NAME  VARCHAR(200) NOT NULL,
    CALENDAR BLOB NOT NULL,
    PRIMARY KEY (SCHED_NAME,CALENDAR_NAME)
);

CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_GROUP  VARCHAR(200) NOT NULL, 
    PRIMARY KEY (SCHED_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_FIRED_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    ENTRY_ID VARCHAR(95) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    FIRED_TIME BIGINT(13) NOT NULL,
    SCHED_TIME BIGINT(13) NOT NULL,
    PRIORITY INTEGER NOT NULL,
    STATE VARCHAR(16) NOT NULL,
    JOB_NAME VARCHAR(200) NULL,
    JOB_GROUP VARCHAR(200) NULL,
    IS_NONCONCURRENT VARCHAR(1) NULL,
    REQUESTS_RECOVERY VARCHAR(1) NULL,
    PRIMARY KEY (SCHED_NAME,ENTRY_ID)
);

CREATE TABLE QRTZ_SCHEDULER_STATE
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    LAST_CHECKIN_TIME BIGINT(13) NOT NULL,
    CHECKIN_INTERVAL BIGINT(13) NOT NULL,
    PRIMARY KEY (SCHED_NAME,INSTANCE_NAME)
);

CREATE TABLE QRTZ_LOCKS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    LOCK_NAME  VARCHAR(40) NOT NULL, 
    PRIMARY KEY (SCHED_NAME,LOCK_NAME)
);


COMMIT;