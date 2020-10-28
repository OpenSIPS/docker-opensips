CREATE TABLE `ocp_admin_privileges` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `first_name` varchar(64) NOT NULL default '',
  `last_name` varchar(64) NOT NULL default '',
  `username` varchar(64) NOT NULL default '',
  `password` varchar(64) NOT NULL default '',
  `ha1` varchar(256) default '',
  `available_tools` varchar(512) NOT NULL default '',
  `permissions` varchar(512) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO ocp_admin_privileges (username,password,first_name,last_name,ha1,available_tools,permissions) values ('admin','opensips','Super','Admin',md5('admin:opensips'),'all','all');

-- 
-- Table for `monitored_stats`
-- 

DROP TABLE IF EXISTS `monitored_stats`;
CREATE TABLE `monitored_stats` (
  `name` varchar(64) NOT NULL,
  `extra` varchar(64) NOT NULL,
  `box_id` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`name`,`box_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table for `monitoring_stats`
-- 

DROP TABLE IF EXISTS `monitoring_stats`;
CREATE TABLE `monitoring_stats` (
  `name` varchar(64) NOT NULL,
  `time` int(11) NOT NULL,
  `value` varchar(64) NOT NULL default '0',
  `box_id` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`name`,`time`,`box_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

