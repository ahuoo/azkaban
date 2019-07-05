CREATE TABLE IF NOT EXISTS `project_flow_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lob` varchar(10) NOT NULL,
  `source` varchar(100) NOT NULL,
  `target` varchar(100) NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'READY',
  `error_message` varchar(4000) DEFAULT NULL,
  `begin_date` bigint(20) DEFAULT NULL,
  `end_date` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
)