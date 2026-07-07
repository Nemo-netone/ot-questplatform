-- WARNING:
-- This is the original MySQL course dump. It contains DROP TABLE statements
-- and is kept only for historical/local MySQL reference.
-- Do not run this file in Supabase or any shared database.
-- Use docs/database/quest-platform-postgres.sql for the online deployment.

-- MySQL dump 10.13  Distrib 8.0.41, for Linux (aarch64)
--
-- Host: localhost    Database: quest-platform
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `answer`
--

DROP TABLE IF EXISTS `answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `answer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `source_type` tinyint DEFAULT NULL COMMENT '来源类型(1：mobile，2：pc)',
  `source_ip` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '来源IP地址',
  `answer` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '问题答案',
  `survey_id` bigint DEFAULT NULL COMMENT '问卷ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answer`
--

LOCK TABLES `answer` WRITE;
/*!40000 ALTER TABLE `answer` DISABLE KEYS */;
INSERT INTO `answer` VALUES (2,1,'192.168.1.100','[{\"question\":\"您对我们的产品整体满意度如何？\",\"answer\":\"满意\"},{\"question\":\"您最常使用我们产品的哪些功能？\",\"answer\":\"功能A,功能C\"},{\"question\":\"您认为我们的产品在哪些方面需要改进？\",\"answer\":\"希望增加更多的自定义选项，界面可以更简洁一些\"},{\"question\":\"您是通过什么渠道了解到我们产品的？\",\"answer\":\"朋友推荐\"},{\"question\":\"您的年龄范围是？\",\"answer\":\"26-35岁\"}]',2,'2025-08-19 11:30:45'),(3,2,'203.156.34.12','[{\"question\":\"您对我们的产品整体满意度如何？\",\"answer\":\"非常满意\"},{\"question\":\"您最常使用我们产品的哪些功能？\",\"answer\":\"功能B,功能D\"},{\"question\":\"您认为我们的产品在哪些方面需要改进？\",\"answer\":\"暂无\"},{\"question\":\"您是通过什么渠道了解到我们产品的？\",\"answer\":\"社交媒体\"},{\"question\":\"您的年龄范围是？\",\"answer\":\"18-25岁\"}]',2,'2025-08-19 14:22:18'),(4,2,'10.0.0.45','[{\"question\":\"您对目前的工作环境满意吗？\",\"answer\":\"满意\"},{\"question\":\"您认为公司哪些福利最有价值？（可多选）\",\"answer\":\"医疗保险,年假,培训机会\"},{\"question\":\"您对公司管理有什么建议？\",\"answer\":\"希望能有更多的团队建设活动\"},{\"question\":\"您所在的部门是？\",\"answer\":\"技术部\"},{\"question\":\"您的工作年限是？\",\"answer\":\"1-3年\"}]',3,'2025-08-20 10:30:22'),(5,2,'10.0.0.78','[{\"question\":\"您对目前的工作环境满意吗？\",\"answer\":\"非常满意\"},{\"question\":\"您认为公司哪些福利最有价值？（可多选）\",\"answer\":\"弹性工作制,年终奖金\"},{\"question\":\"您对公司管理有什么建议？\",\"answer\":\"无\"},{\"question\":\"您所在的部门是？\",\"answer\":\"市场部\"},{\"question\":\"您的工作年限是？\",\"answer\":\"3-5年\"}]',3,'2025-08-20 11:45:10'),(6,2,'10.0.0.112','[{\"question\":\"您对目前的工作环境满意吗？\",\"answer\":\"一般\"},{\"question\":\"您认为公司哪些福利最有价值？（可多选）\",\"answer\":\"培训机会,弹性工作制\"},{\"question\":\"您对公司管理有什么建议？\",\"answer\":\"希望能有更清晰的晋升路径\"},{\"question\":\"您所在的部门是？\",\"answer\":\"人力资源部\"},{\"question\":\"您的工作年限是？\",\"answer\":\"5年以上\"}]',3,'2025-08-20 15:20:33'),(7,1,'172.56.23.89','[{\"question\":\"您目前使用的手机品牌是？\",\"answer\":\"Apple\"},{\"question\":\"您每天使用手机的时间大约是？\",\"answer\":\"3-5小时\"},{\"question\":\"您最常使用的手机功能有哪些？（可多选）\",\"answer\":\"社交媒体,视频/音乐,购物\"},{\"question\":\"您购买手机时最看重的因素是？\",\"answer\":\"性能\"},{\"question\":\"您对目前使用的手机有什么不满意的地方？\",\"answer\":\"电池续航时间不够长\"}]',4,'2025-08-21 14:30:45'),(8,1,'172.56.24.12','[{\"question\":\"您目前使用的手机品牌是？\",\"answer\":\"Samsung\"},{\"question\":\"您每天使用手机的时间大约是？\",\"answer\":\"5小时以上\"},{\"question\":\"您最常使用的手机功能有哪些？（可多选）\",\"answer\":\"游戏,视频/音乐\"},{\"question\":\"您购买手机时最看重的因素是？\",\"answer\":\"摄像头质量\"},{\"question\":\"您对目前使用的手机有什么不满意的地方？\",\"answer\":\"偶尔会卡顿\"}]',4,'2025-08-21 16:45:22'),(9,2,'203.45.67.89','[{\"question\":\"您目前使用的手机品牌是？\",\"answer\":\"Huawei\"},{\"question\":\"您每天使用手机的时间大约是？\",\"answer\":\"1-3小时\"},{\"question\":\"您最常使用的手机功能有哪些？（可多选）\",\"answer\":\"工作/学习\"},{\"question\":\"您购买手机时最看重的因素是？\",\"answer\":\"价格\"},{\"question\":\"您对目前使用的手机有什么不满意的地方？\",\"answer\":\"应用商店可选应用较少\"}]',4,'2025-08-21 18:20:33');
/*!40000 ALTER TABLE `answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `option`
--

DROP TABLE IF EXISTS `option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `option` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `question_id` bigint DEFAULT NULL COMMENT '问题ID',
  `survey_id` bigint DEFAULT NULL COMMENT '问卷ID',
  `content` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '选项内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `option_id` varchar(100) DEFAULT NULL COMMENT '选项ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `option`
--

LOCK TABLES `option` WRITE;
/*!40000 ALTER TABLE `option` DISABLE KEYS */;
INSERT INTO `option` VALUES (7,6,2,'非常满意','2025-08-19 10:00:00','0'),(8,6,2,'满意','2025-08-19 10:00:00','1'),(9,6,2,'一般','2025-08-19 10:00:00','2'),(10,6,2,'不满意','2025-08-19 10:00:00','3'),(11,6,2,'非常不满意','2025-08-19 10:00:00','4'),(12,7,2,'功能A','2025-08-19 10:00:00','0'),(13,7,2,'功能B','2025-08-19 10:00:00','1'),(14,7,2,'功能C','2025-08-19 10:00:00','2'),(15,7,2,'功能D','2025-08-19 10:00:00','3'),(16,9,2,'朋友推荐','2025-08-19 10:00:00','0'),(17,9,2,'社交媒体','2025-08-19 10:00:00','1'),(18,9,2,'搜索引擎','2025-08-19 10:00:00','2'),(19,9,2,'广告','2025-08-19 10:00:00','3'),(20,10,2,'18岁以下','2025-08-19 10:00:00','0'),(21,10,2,'18-25岁','2025-08-19 10:00:00','1'),(22,10,2,'26-35岁','2025-08-19 10:00:00','2'),(23,10,2,'36-45岁','2025-08-19 10:00:00','3'),(24,10,2,'46岁及以上','2025-08-19 10:00:00','4'),(25,11,3,'非常满意','2025-08-20 09:15:00','0'),(26,11,3,'满意','2025-08-20 09:15:00','1'),(27,11,3,'一般','2025-08-20 09:15:00','2'),(28,11,3,'不满意','2025-08-20 09:15:00','3'),(29,11,3,'非常不满意','2025-08-20 09:15:00','4'),(30,12,3,'医疗保险','2025-08-20 09:15:00','0'),(31,12,3,'年假','2025-08-20 09:15:00','1'),(32,12,3,'培训机会','2025-08-20 09:15:00','2'),(33,12,3,'弹性工作制','2025-08-20 09:15:00','3'),(34,12,3,'年终奖金','2025-08-20 09:15:00','4'),(35,14,3,'技术部','2025-08-20 09:15:00','0'),(36,14,3,'市场部','2025-08-20 09:15:00','1'),(37,14,3,'人力资源部','2025-08-20 09:15:00','2'),(38,14,3,'财务部','2025-08-20 09:15:00','3'),(39,14,3,'销售部','2025-08-20 09:15:00','4'),(40,15,3,'1年以下','2025-08-20 09:15:00','0'),(41,15,3,'1-3年','2025-08-20 09:15:00','1'),(42,15,3,'3-5年','2025-08-20 09:15:00','2'),(43,15,3,'5年以上','2025-08-20 09:15:00','3'),(44,17,4,'1小时以下','2025-08-21 13:00:00','0'),(45,17,4,'1-3小时','2025-08-21 13:00:00','1'),(46,17,4,'3-5小时','2025-08-21 13:00:00','2'),(47,17,4,'5小时以上','2025-08-21 13:00:00','3'),(48,18,4,'社交媒体','2025-08-21 13:00:00','0'),(49,18,4,'游戏','2025-08-21 13:00:00','1'),(50,18,4,'视频/音乐','2025-08-21 13:00:00','2'),(51,18,4,'工作/学习','2025-08-21 13:00:00','3'),(52,18,4,'购物','2025-08-21 13:00:00','4'),(53,19,4,'价格','2025-08-21 13:00:00','0'),(54,19,4,'品牌','2025-08-21 13:00:00','1'),(55,19,4,'性能','2025-08-21 13:00:00','2'),(56,19,4,'外观设计','2025-08-21 13:00:00','3'),(57,19,4,'摄像头质量','2025-08-21 13:00:00','4');
/*!40000 ALTER TABLE `option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `survey_id` bigint DEFAULT NULL COMMENT '问卷ID',
  `title` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '问卷题目',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `type` varchar(100) DEFAULT NULL COMMENT '问题类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (6,2,'您对我们的产品整体满意度如何？','2025-08-19 10:00:00','radio'),(7,2,'您最常使用我们产品的哪些功能？','2025-08-19 10:00:00','checkbox'),(8,2,'您认为我们的产品在哪些方面需要改进？','2025-08-19 10:00:00','textarea'),(9,2,'您是通过什么渠道了解到我们产品的？','2025-08-19 10:00:00','select'),(10,2,'您的年龄范围是？','2025-08-19 10:00:00','radio'),(11,3,'您对目前的工作环境满意吗？','2025-08-20 09:15:00','radio'),(12,3,'您认为公司哪些福利最有价值？（可多选）','2025-08-20 09:15:00','checkbox'),(13,3,'您对公司管理有什么建议？','2025-08-20 09:15:00','textarea'),(14,3,'您所在的部门是？','2025-08-20 09:15:00','select'),(15,3,'您的工作年限是？','2025-08-20 09:15:00','radio'),(16,4,'您目前使用的手机品牌是？','2025-08-21 13:00:00','text'),(17,4,'您每天使用手机的时间大约是？','2025-08-21 13:00:00','radio'),(18,4,'您最常使用的手机功能有哪些？（可多选）','2025-08-21 13:00:00','checkbox'),(19,4,'您购买手机时最看重的因素是？','2025-08-21 13:00:00','select'),(20,4,'您对目前使用的手机有什么不满意的地方？','2025-08-21 13:00:00','textarea');
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey`
--

DROP TABLE IF EXISTS `survey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `survey` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '问卷名称',
  `status` tinyint NOT NULL COMMENT '状态（0：待上架，1：已启用，2：已禁用）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `creator` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `is_delete` tinyint DEFAULT NULL COMMENT '是否删除，0：否，1：是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey`
--

LOCK TABLES `survey` WRITE;
/*!40000 ALTER TABLE `survey` DISABLE KEYS */;
INSERT INTO `survey` VALUES (2,'客户满意度调查',0,'2025-08-19 10:00:00','admin',0),(3,'2025年员工满意度调查',1,'2025-08-20 09:15:00','hr_admin',0),(4,'智能手机使用习惯调查',1,'2025-08-21 13:00:00','marketing',0);
/*!40000 ALTER TABLE `survey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `username` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户姓名',
  `password` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户密码',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户手机号',
  `status` tinyint DEFAULT NULL COMMENT '账号状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','123456','123456',0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-18  7:28:02
