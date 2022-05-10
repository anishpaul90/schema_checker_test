SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;
SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

/*!40000 DROP DATABASE IF EXISTS `crypto`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `crypto` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `crypto`;
DROP TABLE IF EXISTS `account_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_orders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(45) NOT NULL,
  `updated_by` varchar(45) NOT NULL,
  `user_id` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `order_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `account_id` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `currency` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `asset` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `amount` decimal(60,10) NOT NULL,
  `settled_amount` decimal(60,10) NOT NULL,
  `status` varchar(50) NOT NULL,
  `order_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  `execution_type` varchar(500) NOT NULL,
  `meta_data` json DEFAULT NULL,
  `expiry` timestamp NOT NULL,
  `quote_id` varchar(50) NOT NULL,
  `initiation_type` varchar(32) NOT NULL,
  `rate` decimal(60,10) NOT NULL,
  `security_type` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(45) NOT NULL,
  `updated_by` varchar(45) NOT NULL,
  `external_id` varchar(128) NOT NULL,
  `parent_account_id` varchar(128) NOT NULL,
  `user_id` varchar(45) NOT NULL,
  `provider` varchar(64) NOT NULL,
  `provider_account_reference_id` varchar(45) DEFAULT NULL,
  `status` varchar(45) NOT NULL,
  `meta_data` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `external_id_idx` (`external_id`),
  KEY `parent_account_id_idx` (`parent_account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `order_source_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_source_account` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(45) NOT NULL,
  `updated_by` varchar(45) NOT NULL,
  `order_id` varchar(50) NOT NULL,
  `instrument_type` varchar(50) NOT NULL,
  `instrument_reference_id` varchar(100) NOT NULL,
  `payment_type` varchar(30) NOT NULL,
  `amount` decimal(60,10) NOT NULL,
  `payment_status` varchar(50) NOT NULL,
  `meta_data` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `instrument_reference_id_order_id_payment_type_unique_constraint` (`instrument_reference_id`,`order_id`,`payment_type`),
  KEY `order_id_idx` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `transaction_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_details` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(45) NOT NULL,
  `updated_by` varchar(45) NOT NULL,
  `order_id` varchar(45) NOT NULL,
  `transaction_id` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `settled` tinyint NOT NULL DEFAULT '0',
  `settlement_id` varchar(45) DEFAULT NULL,
  `meta_data` json DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_id_unique_constraint` (`transaction_id`),
  KEY `order_id_idx` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 DROP DATABASE IF EXISTS `identity_db`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `identity_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `identity_db`;
DROP TABLE IF EXISTS `user_identities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_identities` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `identity_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `value` varchar(100) NOT NULL,
  `metadata` json NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) GENERATED ALWAYS AS (if((`deleted` = 0),1,NULL)) VIRTUAL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_identity_id` (`identity_id`),
  UNIQUE KEY `idx_type_value_active` (`type`,`value`,`is_active`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 DROP DATABASE IF EXISTS `investment_service_db`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `investment_service_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `investment_service_db`;
DROP TABLE IF EXISTS `account_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_documents` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(64) NOT NULL,
  `updated_by` varchar(64) NOT NULL,
  `account_id` bigint NOT NULL,
  `type` varchar(45) NOT NULL,
  `document_reference_id` varchar(45) NOT NULL,
  `version` int NOT NULL,
  `meta_data` json DEFAULT NULL,
  `deleted` bit(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id_idx` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `investment_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `investment_accounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(64) NOT NULL,
  `updated_by` varchar(64) NOT NULL,
  `account_id` varchar(45) DEFAULT NULL,
  `user_id` varchar(45) NOT NULL,
  `type` varchar(45) NOT NULL,
  `status` varchar(45) NOT NULL,
  `meta_data` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_id_idx` (`account_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `investment_waiting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `investment_waiting` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(64) NOT NULL,
  `updated_by` varchar(64) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `account_type` varchar(50) NOT NULL,
  `meta_data` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_account_type_idx` (`user_id`,`account_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 DROP DATABASE IF EXISTS `us_ethereal_db`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `us_ethereal_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `us_ethereal_db`;
DROP TABLE IF EXISTS `ACT_DMN_DATABASECHANGELOG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ACT_DMN_DATABASECHANGELOG` (
  `ID` varchar(255) NOT NULL,
  `AUTHOR` varchar(255) NOT NULL,
  `FILENAME` varchar(255) NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) NOT NULL,
  `MD5SUM` varchar(35) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `COMMENTS` varchar(255) DEFAULT NULL,
  `TAG` varchar(255) DEFAULT NULL,
  `LIQUIBASE` varchar(20) DEFAULT NULL,
  `CONTEXTS` varchar(255) DEFAULT NULL,
  `LABELS` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ACT_DMN_DATABASECHANGELOGLOCK`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ACT_DMN_DATABASECHANGELOGLOCK` (
  `ID` int NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ACT_DMN_DECISION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ACT_DMN_DECISION` (
  `ID_` varchar(255) NOT NULL,
  `NAME_` varchar(255) DEFAULT NULL,
  `VERSION_` int DEFAULT NULL,
  `KEY_` varchar(255) DEFAULT NULL,
  `CATEGORY_` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(255) DEFAULT NULL,
  `TENANT_ID_` varchar(255) DEFAULT NULL,
  `RESOURCE_NAME_` varchar(255) DEFAULT NULL,
  `DESCRIPTION_` varchar(255) DEFAULT NULL,
  `DECISION_TYPE_` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID_`),
  UNIQUE KEY `ACT_IDX_DMN_DEC_UNIQ` (`KEY_`,`VERSION_`,`TENANT_ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ACT_DMN_DEPLOYMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ACT_DMN_DEPLOYMENT` (
  `ID_` varchar(255) NOT NULL,
  `NAME_` varchar(255) DEFAULT NULL,
  `CATEGORY_` varchar(255) DEFAULT NULL,
  `DEPLOY_TIME_` datetime(3) DEFAULT NULL,
  `TENANT_ID_` varchar(255) DEFAULT NULL,
  `PARENT_DEPLOYMENT_ID_` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ACT_DMN_DEPLOYMENT_RESOURCE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ACT_DMN_DEPLOYMENT_RESOURCE` (
  `ID_` varchar(255) NOT NULL,
  `NAME_` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(255) DEFAULT NULL,
  `RESOURCE_BYTES_` longblob,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ACT_DMN_HI_DECISION_EXECUTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ACT_DMN_HI_DECISION_EXECUTION` (
  `ID_` varchar(255) NOT NULL,
  `DECISION_DEFINITION_ID_` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(255) DEFAULT NULL,
  `START_TIME_` datetime(3) DEFAULT NULL,
  `END_TIME_` datetime(3) DEFAULT NULL,
  `INSTANCE_ID_` varchar(255) DEFAULT NULL,
  `EXECUTION_ID_` varchar(255) DEFAULT NULL,
  `ACTIVITY_ID_` varchar(255) DEFAULT NULL,
  `FAILED_` bit(1) DEFAULT b'0',
  `TENANT_ID_` varchar(255) DEFAULT NULL,
  `EXECUTION_JSON_` longtext,
  `SCOPE_TYPE_` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ACT_GE_BYTEARRAY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ACT_GE_BYTEARRAY` (
  `ID_` varchar(64) COLLATE utf8_bin NOT NULL,
  `REV_` int DEFAULT NULL,
  `NAME_` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DEPLOYMENT_ID_` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `BYTES_` longblob,
  `GENERATED_` tinyint DEFAULT NULL,
  PRIMARY KEY (`ID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ACT_GE_PROPERTY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ACT_GE_PROPERTY` (
  `NAME_` varchar(64) COLLATE utf8_bin NOT NULL,
  `VALUE_` varchar(300) COLLATE utf8_bin DEFAULT NULL,
  `REV_` int DEFAULT NULL,
  PRIMARY KEY (`NAME_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `all_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `all_accounts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `zolve_user_id` varchar(36) NOT NULL,
  `account_provider` varchar(30) NOT NULL,
  `account_provider_id` varchar(72) NOT NULL,
  `status` varchar(30) NOT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  `display_attributes` text NOT NULL,
  `all_data` text NOT NULL,
  `parent_account_provider_id` varchar(72) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_provider_pid` (`zolve_user_id`,`account_provider`,`account_provider_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22615 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ethereal_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ethereal_audit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `event_published_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `event_id` varchar(36) NOT NULL,
  `zolve_user_id` varchar(36) NOT NULL,
  `external_service` varchar(72) NOT NULL,
  `api_name` varchar(72) NOT NULL,
  `request_data` text NOT NULL,
  `response_data` text NOT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `http_status` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_event_id` (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1429142 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `i2c_payee_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `i2c_payee_accounts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `parent_owner_id` bigint NOT NULL,
  `account_number` varchar(40) NOT NULL,
  `routing_number` varchar(40) NOT NULL,
  `status` varchar(45) NOT NULL,
  `attributes` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_1` (`parent_owner_id`,`account_number`,`routing_number`)
) ENGINE=InnoDB AUTO_INCREMENT=8478 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `i2c_payees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `i2c_payees` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `all_account_id` bigint NOT NULL,
  `parent_account_id` bigint NOT NULL,
  `i2c_flow` varchar(45) NOT NULL,
  `parent_account_owner` varchar(45) NOT NULL,
  `attributes` text NOT NULL,
  `status` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `key_1` (`all_account_id`,`parent_account_id`,`i2c_flow`,`parent_account_owner`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `link_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `link_requests` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `zolve_user_id` varchar(36) NOT NULL,
  `request_id` varchar(36) NOT NULL,
  `token` varchar(1024) DEFAULT NULL,
  `provider_name` varchar(45) NOT NULL,
  `status` varchar(30) NOT NULL,
  `external_provider_id` varchar(72) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_provider_request_id` (`zolve_user_id`,`provider_name`,`request_id`),
  KEY `idx_request_id` (`request_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39471 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `methodfi_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `methodfi_accounts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `zolve_user_id` varchar(36) NOT NULL,
  `methodfi_user_id` varchar(72) DEFAULT NULL,
  `account_source` varchar(45) NOT NULL,
  `account_source_id` varchar(45) NOT NULL,
  `methodfi_acc_id` varchar(72) NOT NULL,
  `status` varchar(45) DEFAULT NULL,
  `metadata` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_muid` (`methodfi_acc_id`),
  UNIQUE KEY `UK_zuid` (`zolve_user_id`,`account_source`,`account_source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6317 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `methodfi_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `methodfi_entities` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` varchar(36) NOT NULL,
  `methodfi_user_id` varchar(72) DEFAULT NULL,
  `methodfi_status` varchar(45) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `metadata` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_zuid` (`user_id`),
  UNIQUE KEY `UK_muid` (`methodfi_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3155 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mx_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mx_accounts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `mx_acc_guid` varchar(72) NOT NULL,
  `zolve_user_id` varchar(72) NOT NULL,
  `mx_user_id` varchar(72) NOT NULL,
  `member_guid` varchar(72) NOT NULL,
  `display_attributes` text,
  `all_attributes` text,
  `status` varchar(45) NOT NULL,
  `acc_type` varchar(50) NOT NULL,
  `currency_code` varchar(20) NOT NULL,
  `available_credit_limit` double(11,2) DEFAULT NULL,
  `balance` double(11,2) DEFAULT NULL,
  `parent_product_id` varchar(72) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_acc_guid` (`mx_acc_guid`),
  KEY `idx_member_guid` (`member_guid`),
  KEY `idx_zolve_user_id` (`zolve_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23439 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mx_beats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mx_beats` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `template` varchar(256) NOT NULL,
  `beat_id` varchar(72) NOT NULL,
  `mx_created_at` timestamp NULL DEFAULT NULL,
  `mx_updated_at` timestamp NULL DEFAULT NULL,
  `mx_deleted_at` timestamp NULL DEFAULT NULL,
  `zolve_user_id` varchar(36) NOT NULL,
  `mx_user_id` varchar(72) NOT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `is_dismissed` tinyint(1) DEFAULT '0',
  `is_relevant` tinyint(1) DEFAULT '0',
  `primary_account_guid` varchar(256) DEFAULT NULL,
  `primary_transaction_guid` varchar(256) DEFAULT NULL,
  `metadata` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_zolve_mx_beat` (`zolve_user_id`,`mx_user_id`,`beat_id`),
  KEY `mx_user_id` (`mx_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mx_institutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mx_institutions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `code` varchar(72) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `metadata` text NOT NULL,
  `status` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=12143 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mx_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mx_members` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `mx_member_id` varchar(72) NOT NULL,
  `institution_code` varchar(36) NOT NULL,
  `name` varchar(256) NOT NULL,
  `connection_status` varchar(36) NOT NULL,
  `zolve_user_id` varchar(36) NOT NULL,
  `mx_user_id` varchar(72) NOT NULL,
  `status` varchar(45) NOT NULL,
  `metadata` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mx_member_id` (`mx_member_id`),
  KEY `idx_mx_user_id` (`mx_user_id`),
  KEY `idx_zolve_user_id` (`zolve_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16211 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mx_merchant_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mx_merchant_locations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `guid` varchar(72) NOT NULL,
  `merchant_guid` varchar(72) NOT NULL,
  `metadata` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_guid` (`guid`)
) ENGINE=InnoDB AUTO_INCREMENT=6445 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mx_merchants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mx_merchants` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `guid` varchar(72) NOT NULL,
  `name` varchar(256) NOT NULL,
  `metadata` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_guid` (`guid`)
) ENGINE=InnoDB AUTO_INCREMENT=1163 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mx_raw_beats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mx_raw_beats` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `event_hash` varchar(45) NOT NULL,
  `event` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_hash` (`event_hash`)
) ENGINE=InnoDB AUTO_INCREMENT=426948 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mx_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mx_transactions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `guid` varchar(72) NOT NULL,
  `mx_acc_guid` varchar(72) NOT NULL,
  `amount` double(11,2) NOT NULL,
  `category` varchar(72) DEFAULT NULL,
  `currency_code` varchar(20) DEFAULT NULL,
  `search_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `member_guid` varchar(72) NOT NULL,
  `merchant_guid` varchar(72) DEFAULT NULL,
  `merchant_location_guid` varchar(72) DEFAULT NULL,
  `posted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(45) NOT NULL,
  `transaction_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` varchar(20) NOT NULL,
  `mx_updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mx_user_id` varchar(72) NOT NULL,
  `zolve_user_id` varchar(36) NOT NULL,
  `metadata` text,
  `auth_code` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_guid` (`guid`),
  UNIQUE KEY `uk_auth_code_zolve_user_id` (`auth_code`,`zolve_user_id`),
  KEY `idx_zuid_mi_ai` (`zolve_user_id`,`member_guid`,`mx_acc_guid`),
  KEY `idx_auth_code` (`auth_code`)
) ENGINE=InnoDB AUTO_INCREMENT=755287 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mx_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mx_users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `zolve_user_id` varchar(36) NOT NULL,
  `email_id` varchar(200) DEFAULT NULL,
  `mx_user_id` varchar(72) NOT NULL,
  `status` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_zolve_mx_user_id` (`zolve_user_id`,`mx_user_id`),
  KEY `mx_user_id` (`mx_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14890 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `payee_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payee_attributes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `payee_id` bigint NOT NULL,
  `attribute_key` varchar(45) NOT NULL,
  `attribute_value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_payee_attribute_key_id` (`payee_id`,`attribute_key`),
  KEY `attribute_key_id` (`attribute_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `plaid_institutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plaid_institutions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `institution_id` varchar(36) NOT NULL,
  `name` varchar(200) NOT NULL,
  `url` varchar(200) DEFAULT NULL,
  `logo` text,
  `metadata` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pk_institution_id` (`institution_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10846 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `plaid_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plaid_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `item_id` varchar(72) NOT NULL,
  `access_token` text,
  `zolve_status` varchar(30) NOT NULL,
  `plaid_status` varchar(30) NOT NULL,
  `zolve_user_id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_provider_request_id` (`zolve_user_id`,`item_id`),
  KEY `idx_item` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4655 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `plaid_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plaid_transactions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `transaction_id` varchar(72) NOT NULL,
  `account_id` varchar(72) NOT NULL,
  `item_id` varchar(72) NOT NULL,
  `amount` double(11,2) NOT NULL,
  `category` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `currency_code` varchar(20) DEFAULT NULL,
  `zolve_user_id` varchar(36) NOT NULL,
  `metadata` text,
  `date` timestamp NULL DEFAULT NULL,
  `authorized_date` timestamp NULL DEFAULT NULL,
  `type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `payment_channel` varchar(20) DEFAULT NULL,
  `deleted` tinyint NOT NULL,
  `status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_txnId` (`transaction_id`),
  KEY `idx_txnId_accountId_itemId_zuId` (`transaction_id`,`account_id`,`item_id`,`zolve_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=487187 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `plaid_transactions_need_to_be_deleted`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plaid_transactions_need_to_be_deleted` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `transaction_id` varchar(72) NOT NULL,
  `account_id` varchar(72) NOT NULL,
  `item_id` varchar(72) NOT NULL,
  `amount` double(11,2) NOT NULL,
  `category` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `currency_code` varchar(20) DEFAULT NULL,
  `zolve_user_id` varchar(36) NOT NULL,
  `date` timestamp NULL DEFAULT NULL,
  `authorized_date` timestamp NULL DEFAULT NULL,
  `type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `payment_channel` varchar(20) DEFAULT NULL,
  `deleted` tinyint NOT NULL,
  `status` varchar(45) DEFAULT NULL,
  `metadata` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_txnId` (`transaction_id`),
  KEY `idx_txnId_accountId_itemId_zuId` (`transaction_id`,`account_id`,`item_id`,`zolve_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `teller_enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teller_enrollments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `enrollment_id` varchar(72) NOT NULL DEFAULT '',
  `access_token` varchar(72) DEFAULT NULL,
  `zolve_status` varchar(30) NOT NULL,
  `teller_status` varchar(30) NOT NULL,
  `zolve_user_id` varchar(36) NOT NULL DEFAULT '',
  `teller_user_id` varchar(36) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_user_provider_request_id` (`zolve_user_id`,`enrollment_id`,`access_token`),
  KEY `idx_enrollment` (`enrollment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6310 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_payee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_payee` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `zolve_user_id` varchar(36) DEFAULT NULL,
  `status` varchar(72) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_zolve_user_id` (`zolve_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 DROP DATABASE IF EXISTS `verifier_db`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `verifier_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `verifier_db`;
DROP TABLE IF EXISTS `ssn_verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ssn_verifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) DEFAULT '0',
  `user_id` varchar(45) NOT NULL,
  `request_id` varchar(45) DEFAULT NULL,
  `user_consent_id` varchar(45) DEFAULT NULL,
  `verification_id` varchar(45) DEFAULT NULL,
  `external_transaction_id` varchar(45) DEFAULT NULL,
  `source` varchar(45) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  `request_data` text,
  `response_data` text,
  `user_consent_time` varchar(45) DEFAULT NULL,
  `purpose` text,
  `ssn_number` text,
  PRIMARY KEY (`id`),
  KEY `idx_ui` (`user_id`),
  KEY `consent_id_idx` (`user_consent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1969 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
