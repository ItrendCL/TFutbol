-- futbol.contestants definition

CREATE TABLE `contestants` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `name` varchar(255) NOT NULL COMMENT 'name of the team',
  `short_name` varchar(255) DEFAULT NULL COMMENT 'short name of the team',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;


-- futbol.players definition

CREATE TABLE `players` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `first_name` varchar(255) NOT NULL COMMENT 'first name of the player',
  `last_name` varchar(100) DEFAULT NULL COMMENT 'last name of the player',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=550 DEFAULT CHARSET=utf8mb4;


-- futbol.positions definition

CREATE TABLE `positions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `label` varchar(100) NOT NULL COMMENT 'label of the position: Defender/Goalkeept, etc',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;


-- futbol.venues definition

CREATE TABLE `venues` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `name` varchar(255) NOT NULL COMMENT 'name of the venue',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;


-- futbol.goal_types definition

CREATE TABLE `goal_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `label` varchar(100) NOT NULL COMMENT 'label for the type of goal',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;


-- futbol.matches definition

CREATE TABLE `matches` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contestant0_id` bigint(20) unsigned NOT NULL COMMENT 'FK to contestants table (first team)',
  `contestant1_id` bigint(20) unsigned NOT NULL COMMENT 'FK to contestants table (first team)',
  `date` date NOT NULL COMMENT 'date schedule for the match',
  `time` datetime NOT NULL COMMENT 'start time for the match',
  `description` varchar(255) DEFAULT NULL COMMENT 'text label for the match',
  `venue_id` bigint(20) unsigned NOT NULL COMMENT 'FK to the venues table',
  `score_away` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'number of scored goals of away team',
  `score_home` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'number of scored goals of home team',
  `winner_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to winning team, null if draw',
  `match_length_min` int(10) unsigned NOT NULL COMMENT 'number of minutes that the match lasted',
  `match_length_sec` int(10) unsigned NOT NULL COMMENT 'number of seconds that the match lasted',
  `contestant0_position` varchar(100) DEFAULT NULL COMMENT 'home/away',
  `contestant1_position` varchar(100) DEFAULT NULL COMMENT 'home/away',
  PRIMARY KEY (`id`),
  KEY `matches_FK` (`contestant0_id`),
  KEY `matches_FK_1` (`contestant1_id`),
  KEY `matches_FK_2` (`winner_id`),
  KEY `matches_FK_3` (`venue_id`),
  CONSTRAINT `matches_FK` FOREIGN KEY (`contestant0_id`) REFERENCES `contestants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `matches_FK_1` FOREIGN KEY (`contestant1_id`) REFERENCES `contestants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `matches_FK_2` FOREIGN KEY (`winner_id`) REFERENCES `contestants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `matches_FK_3` FOREIGN KEY (`venue_id`) REFERENCES `venues` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4;


-- futbol.contestant_player definition

CREATE TABLE `contestant_player` (
  `contestant_id` bigint(20) unsigned NOT NULL COMMENT 'FK to contestants table',
  `player_id` bigint(20) unsigned NOT NULL COMMENT 'FK to players table',
  `season_year` int(11) NOT NULL COMMENT 'season year for the association player-team',
  `season_semester` int(11) NOT NULL COMMENT 'season semester for the association player-team',
  PRIMARY KEY (`contestant_id`,`player_id`,`season_year`,`season_semester`),
  KEY `contestant_player_FK_1` (`player_id`),
  CONSTRAINT `contestant_player_FK` FOREIGN KEY (`contestant_id`) REFERENCES `contestants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contestant_player_FK_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- futbol.lineups definition

CREATE TABLE `lineups` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `match_id` bigint(20) unsigned NOT NULL COMMENT 'FK to matches table',
  `player_id` bigint(20) unsigned NOT NULL COMMENT 'FK to players table',
  `shirt_number` int(11) NOT NULL COMMENT 'shirt number used by a player in a match',
  `position_id` bigint(20) unsigned NOT NULL COMMENT 'FK to positions table',
  `side` varchar(100) DEFAULT NULL COMMENT 'left/centre/right',
  PRIMARY KEY (`id`),
  KEY `lineups_FK` (`match_id`),
  KEY `lineups_FK_1` (`player_id`),
  KEY `lineups_FK_2` (`position_id`),
  CONSTRAINT `lineups_FK` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lineups_FK_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lineups_FK_2` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7174 DEFAULT CHARSET=utf8mb4;


-- futbol.goals definition

CREATE TABLE `goals` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `match_id` bigint(20) unsigned NOT NULL COMMENT 'FK to matches table (match where the goal was scored)',
  `player_id` bigint(20) unsigned NOT NULL COMMENT 'FK to players table (scorer)',
  `goal_type_id` bigint(20) unsigned NOT NULL COMMENT 'FK to goal_types (own goal/penalty/etc)',
  `time_min` int(10) unsigned DEFAULT NULL COMMENT 'minute when the goal was scored (1-based)',
  `time_sec` int(11) DEFAULT NULL COMMENT 'second when the goal was scored (0-based)',
  `time_string` varchar(100) DEFAULT NULL COMMENT 'time representation for the goal (M)M:SS',
  PRIMARY KEY (`id`),
  KEY `goals_FK` (`match_id`),
  KEY `goals_FK_1` (`player_id`),
  KEY `goals_FK_2` (`goal_type_id`),
  CONSTRAINT `goals_FK` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goals_FK_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goals_FK_2` FOREIGN KEY (`goal_type_id`) REFERENCES `goal_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=535 DEFAULT CHARSET=utf8mb4;
