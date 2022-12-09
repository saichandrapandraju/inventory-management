-- MySQL dump 10.13  Distrib 8.0.30, for macos12 (x86_64)
--
-- Host: localhost    Database: inventory_management
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `brand`
--

DROP TABLE IF EXISTS `brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brand` (
  `name` varchar(64) NOT NULL,
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brand`
--

LOCK TABLES `brand` WRITE;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
INSERT INTO `brand` VALUES ('Apple'),('Bantia'),('Chewy'),('Columbia'),('Drools'),('Google'),('Ikea'),('Lakme'),('LG'),('Nivia'),('Patagonia'),('SONY');
/*!40000 ALTER TABLE `brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `description` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Electronics','All the electronic gadgets'),(2,'beauty','smartphones'),(3,'pet_supplies','All the items related to the pet care'),(4,'furniture','All the items related to the furniture'),(5,'outdoors','All the items related to the outdoor activity like swiming, hiking,etc.');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(128) NOT NULL,
  `last_name` varchar(128) NOT NULL,
  `full_name` varchar(256) GENERATED ALWAYS AS (concat_ws(_utf8mb4' ',`first_name`,`last_name`)) VIRTUAL,
  `address` varchar(300) NOT NULL,
  `emp_type` enum('Manager','Worker') DEFAULT 'Worker',
  `phone` varchar(15) DEFAULT NULL,
  `ssn` varchar(15) NOT NULL,
  `email_address` varchar(500) NOT NULL,
  PRIMARY KEY (`email_address`),
  UNIQUE KEY `ssn` (`ssn`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` (`id`, `first_name`, `last_name`, `address`, `emp_type`, `phone`, `ssn`, `email_address`) VALUES (1,'SaiChandra','Pandraju','sujatha nagar 3rd lane','Worker','+919063506674','1236554789','saic@mail.com'),(11,'demo','user','test','Manager','12121212','212121','test@mail.com');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loginDetails`
--

DROP TABLE IF EXISTS `loginDetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loginDetails` (
  `email_address` varchar(500) NOT NULL,
  `pass` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`email_address`),
  CONSTRAINT `login_fk_employee` FOREIGN KEY (`email_address`) REFERENCES `employee` (`email_address`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loginDetails`
--

LOCK TABLES `loginDetails` WRITE;
/*!40000 ALTER TABLE `loginDetails` DISABLE KEYS */;
INSERT INTO `loginDetails` VALUES ('saic@mail.com','Sai123'),('test@mail.com','test');
/*!40000 ALTER TABLE `loginDetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `emp_id` int NOT NULL,
  `sup_id` int NOT NULL,
  `purchase_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` float NOT NULL,
  `status` enum('Pending','Settled','Cancelled') DEFAULT 'Pending',
  PRIMARY KEY (`emp_id`,`sup_id`,`purchase_id`),
  KEY `order_details_fk_supplier` (`sup_id`),
  KEY `order_details_fk_purchase` (`purchase_id`),
  KEY `order_details_fk_product` (`product_id`),
  CONSTRAINT `order_details_fk_employee` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `order_details_fk_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `order_details_fk_purchase` FOREIGN KEY (`purchase_id`) REFERENCES `purchase_order` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `order_details_fk_supplier` FOREIGN KEY (`sup_id`) REFERENCES `supplier` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES (1,1,3,2,50,5000,'Settled'),(1,1,4,2,700,35000,'Pending'),(1,1,6,2,2,1000,'Settled'),(1,1,7,5,3,1200,'Settled'),(1,1,8,5,10,4000,'Settled'),(1,1,9,2,20,10000,'Cancelled'),(1,1,10,2,4,2000,'Settled'),(1,1,14,5,33,13200,'Pending'),(1,2,11,4,2,40,'Settled'),(1,2,12,3,3,120,'Settled'),(1,2,17,3,1,40,'Settled'),(1,3,1,1,500,50000,'Settled'),(1,3,2,1,300,30000,'Pending'),(1,3,13,6,3,12,'Settled'),(1,4,15,8,3,600,'Settled'),(1,4,16,7,5,1500,'Cancelled'),(11,5,18,10,32,1600,'Pending');
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_settle` AFTER UPDATE ON `order_details` FOR EACH ROW BEGIN
	
   IF NEW.status="Settled" THEN
      update product set quantity=quantity+old.quantity where id=old.product_id;
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `price` float NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `manufacture_date` date NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `location` varchar(64) NOT NULL,
  `brand` varchar(64) NOT NULL,
  `category` int NOT NULL,
  `supplier` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_fk_brand` (`brand`),
  KEY `product_fk_category` (`category`),
  KEY `product_fk_supplier` (`supplier`),
  CONSTRAINT `product_fk_brand` FOREIGN KEY (`brand`) REFERENCES `brand` (`name`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `product_fk_category` FOREIGN KEY (`category`) REFERENCES `category` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `product_fk_supplier` FOREIGN KEY (`supplier`) REFERENCES `supplier` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'CatFoodCan',2,'Great Cat food',426,'2018-11-11','2024-06-06','Mexico','Chewy',3,3),(2,'iPhone 12 RED',500,'Touchscreen latest version with latest features',1671,'2016-08-08','2030-09-08','USA','Apple',1,1),(3,'perfume',40,'Lipstick',34,'2014-08-08','2023-06-05','India','Lakme',2,2),(4,'moisturizer',20,'Deeply moisturizes skin',2667,'2016-06-08','2023-06-05','USA','Nivia',2,2),(5,'LG 41\'\' TV',400,'Updated description',13,'2016-08-08','2030-09-08','korea','LG',1,1),(6,'DogFoodCan',4,'Great Dog food',1155,'2017-11-06','2022-06-06','Canada','Drools',3,3),(7,'Sofa',300,'Leather covered cushioning',97,'2017-11-06','2040-06-06','India','Bantia',4,4),(8,'Dining Table',200,'Original Teak Wood',886,'2015-11-06','2043-06-06','Sweden','Ikea',4,4),(9,'Swimsuit',30,'High quality Nylon',68,'2015-11-06','2027-07-06','Thailand','Patagonia',5,5),(10,'Fleece Jacket',50,'High quality Sherpa',551,'2018-11-06','2025-07-06','Bangladesh','Columbia',5,5);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_sale`
--

DROP TABLE IF EXISTS `product_sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_sale` (
  `sale_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`sale_id`,`product_id`),
  KEY `product_sale_fk_product` (`product_id`),
  CONSTRAINT `product_sale_fk_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `product_sale_fk_sale` FOREIGN KEY (`sale_id`) REFERENCES `sale` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_sale`
--

LOCK TABLES `product_sale` WRITE;
/*!40000 ALTER TABLE `product_sale` DISABLE KEYS */;
INSERT INTO `product_sale` VALUES (1,5,3),(2,5,4),(3,5,11),(4,5,14),(5,5,13),(6,5,13),(7,5,16),(8,5,10),(9,1,18),(10,1,13),(11,1,14),(12,1,17),(13,1,22),(14,1,22),(15,1,19),(16,1,26),(17,1,26),(18,1,24),(19,1,20),(20,1,22),(21,1,26),(22,1,28),(23,1,23),(24,1,33),(25,1,26),(26,1,27),(27,1,31),(28,1,33),(29,1,36),(30,1,33),(31,1,35),(32,2,7),(33,2,5),(34,2,9),(35,2,4),(36,2,20),(37,2,8),(38,2,17),(39,2,9),(40,2,17),(41,2,4),(42,2,11),(43,2,11),(44,2,15),(45,2,2),(46,2,14),(47,2,12),(48,2,13),(49,2,8),(50,2,1),(51,2,10),(52,2,13),(53,2,3),(54,2,14),(55,2,20),(56,2,9),(57,2,6),(58,2,17),(59,2,6),(60,2,12),(61,2,18),(62,2,18),(63,3,5),(64,3,8),(65,3,7),(66,3,20),(67,3,9),(68,3,19),(69,3,13),(70,3,5),(71,3,16),(72,3,2),(73,3,11),(74,3,11),(75,3,6),(76,3,2),(77,3,2),(78,3,10),(79,3,1),(80,3,11),(81,3,12),(82,3,16),(83,3,12),(84,3,14),(85,3,14),(86,3,2),(87,3,15),(88,3,13),(89,3,2),(90,3,4),(91,3,16),(92,3,5),(93,3,19),(94,4,16),(95,4,9),(96,4,11),(97,4,17),(98,4,7),(99,4,3),(100,4,7),(101,4,14),(102,4,9),(103,4,15),(104,4,18),(105,4,13),(106,4,11),(107,4,14),(108,4,5),(109,4,13),(110,4,7),(111,4,19),(112,4,7),(113,4,10),(114,4,7),(115,4,18),(116,4,10),(117,4,15),(118,4,15),(119,4,10),(120,4,7),(121,4,4),(122,4,7),(123,4,3),(124,4,12),(125,5,20),(126,5,9),(127,5,9),(128,5,18),(129,5,13),(130,5,14),(131,5,5),(132,5,9),(133,5,14),(134,5,1),(135,5,18),(136,5,12),(137,5,20),(138,5,13),(139,5,19),(140,5,15),(141,5,12),(142,5,19),(143,5,9),(144,5,2),(145,5,20),(146,5,10),(147,5,10),(148,5,12),(149,5,4),(150,5,18),(151,5,18),(152,5,12),(153,5,8),(154,5,6),(155,5,2),(156,6,16),(157,6,14),(158,6,12),(159,6,8),(160,6,3),(161,6,15),(162,6,3),(163,6,13),(164,6,17),(165,6,13),(166,6,20),(167,6,10),(168,6,2),(169,6,15),(170,6,18),(171,6,5),(172,6,7),(173,6,12),(174,6,7),(175,6,5),(176,6,19),(177,6,13),(178,6,1),(179,6,13),(180,6,11),(181,6,7),(182,6,7),(183,6,19),(184,6,20),(185,6,4),(186,6,19),(187,7,13),(188,7,12),(189,7,20),(190,7,6),(191,7,1),(192,7,19),(193,7,15),(194,7,15),(195,7,15),(196,7,6),(197,7,19),(198,7,7),(199,7,8),(200,7,8),(201,7,20),(202,7,14),(203,7,5),(204,7,19),(205,7,7),(206,7,11),(207,7,16),(208,7,20),(209,7,13),(210,7,9),(211,7,14),(212,7,12),(213,7,14),(214,7,15),(215,7,9),(216,7,14),(217,7,18),(218,8,16),(219,8,12),(220,8,18),(221,8,16),(222,8,15),(223,8,17),(224,8,18),(225,8,6),(226,8,3),(227,8,20),(228,8,7),(229,8,15),(230,8,20),(231,8,9),(232,8,1),(233,8,5),(234,8,15),(235,8,3),(236,8,6),(237,8,6),(238,8,14),(239,8,2),(240,8,19),(241,8,11),(242,8,7),(243,8,5),(244,8,1),(245,8,9),(246,8,2),(247,8,16),(248,8,3),(249,9,14),(250,9,16),(251,9,5),(252,9,1),(253,9,16),(254,9,3),(255,9,14),(256,9,12),(257,9,20),(258,9,11),(259,9,15),(260,9,18),(261,9,8),(262,9,6),(263,9,16),(264,9,15),(265,9,14),(266,9,5),(267,9,8),(268,9,13),(269,9,17),(270,9,4),(271,9,9),(272,9,3),(273,9,5),(274,9,18),(275,9,9),(276,9,15),(277,9,16),(278,9,11),(279,9,8),(280,10,3),(281,10,8),(282,10,17),(283,10,6),(284,10,1),(285,10,4),(286,10,4),(287,10,13),(288,10,8),(289,10,5),(290,10,1),(291,10,17),(292,10,6),(293,10,15),(294,10,19),(295,10,3),(296,10,5),(297,10,16),(298,10,6),(299,10,7),(300,10,7),(301,10,5),(302,10,18),(303,10,8),(304,10,2),(305,10,12),(306,10,3),(307,10,7),(308,10,17),(309,10,2),(310,10,4);
/*!40000 ALTER TABLE `product_sale` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `product_sale_sold` AFTER INSERT ON `product_sale` FOR EACH ROW begin 
	declare tq int;
    declare tid int;
    declare cur_q int;
   --  declare tq int;
    select product_id into tid from  product_sale where sale_id=new.sale_id;
    select quantity into tq from  product_sale where sale_id=new.sale_id;
    select quantity into cur_q from product where id=tid;
    
    
    -- select product.quantity into temp from product  join product_sale where product.id=new.product_sale.product_id;
--     
	-- UPDATE product SET quantity = quantity - tq WHERE id = tid;
     if cur_q-tq>0 then -- check this condition once
		update product set quantity=quantity - tq where id= tid;
     else
		update product set quantity=0 where id=tid;
	 end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `purchase_order`
--

DROP TABLE IF EXISTS `purchase_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_date` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order`
--

LOCK TABLES `purchase_order` WRITE;
/*!40000 ALTER TABLE `purchase_order` DISABLE KEYS */;
INSERT INTO `purchase_order` VALUES (1,'2021-05-01'),(2,'2021-05-10'),(3,'2021-02-10'),(4,'2021-05-03'),(5,'2021-09-10'),(6,'2022-12-07'),(7,'2022-12-07'),(8,'2022-12-07'),(9,'2022-12-07'),(10,'2022-12-07'),(11,'2022-12-07'),(12,'2022-12-07'),(13,'2022-12-07'),(14,'2022-12-07'),(15,'2022-12-08'),(16,'2022-12-08'),(17,'2022-12-08'),(18,'2022-12-09');
/*!40000 ALTER TABLE `purchase_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale`
--

DROP TABLE IF EXISTS `sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sale_date` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=311 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale`
--

LOCK TABLES `sale` WRITE;
/*!40000 ALTER TABLE `sale` DISABLE KEYS */;
INSERT INTO `sale` VALUES (1,'2021-05-31'),(2,'2021-05-30'),(3,'2021-05-30'),(4,'2021-05-30'),(5,'2021-05-30'),(6,'2021-05-30'),(7,'2021-05-29'),(8,'2021-05-28'),(9,'2021-05-09'),(10,'2021-05-10'),(11,'2021-05-11'),(12,'2021-05-12'),(13,'2021-05-13'),(14,'2021-05-14'),(15,'2021-05-15'),(16,'2021-05-16'),(17,'2021-05-17'),(18,'2021-05-18'),(19,'2021-05-19'),(20,'2021-05-20'),(21,'2021-05-21'),(22,'2021-05-22'),(23,'2021-05-23'),(24,'2021-05-24'),(25,'2021-05-25'),(26,'2021-05-26'),(27,'2021-05-27'),(28,'2021-05-28'),(29,'2021-05-29'),(30,'2021-05-30'),(31,'2021-05-31'),(32,'2021-05-01'),(33,'2021-05-02'),(34,'2021-05-03'),(35,'2021-05-04'),(36,'2021-05-05'),(37,'2021-05-06'),(38,'2021-05-07'),(39,'2021-05-08'),(40,'2021-05-09'),(41,'2021-05-10'),(42,'2021-05-11'),(43,'2021-05-12'),(44,'2021-05-13'),(45,'2021-05-14'),(46,'2021-05-15'),(47,'2021-05-16'),(48,'2021-05-17'),(49,'2021-05-18'),(50,'2021-05-19'),(51,'2021-05-20'),(52,'2021-05-21'),(53,'2021-05-22'),(54,'2021-05-23'),(55,'2021-05-24'),(56,'2021-05-25'),(57,'2021-05-26'),(58,'2021-05-27'),(59,'2021-05-28'),(60,'2021-05-29'),(61,'2021-05-30'),(62,'2021-05-31'),(63,'2021-05-01'),(64,'2021-05-02'),(65,'2021-05-03'),(66,'2021-05-04'),(67,'2021-05-05'),(68,'2021-05-06'),(69,'2021-05-07'),(70,'2021-05-08'),(71,'2021-05-09'),(72,'2021-05-10'),(73,'2021-05-11'),(74,'2021-05-12'),(75,'2021-05-13'),(76,'2021-05-14'),(77,'2021-05-15'),(78,'2021-05-16'),(79,'2021-05-17'),(80,'2021-05-18'),(81,'2021-05-19'),(82,'2021-05-20'),(83,'2021-05-21'),(84,'2021-05-22'),(85,'2021-05-23'),(86,'2021-05-24'),(87,'2021-05-25'),(88,'2021-05-26'),(89,'2021-05-27'),(90,'2021-05-28'),(91,'2021-05-29'),(92,'2021-05-30'),(93,'2021-05-31'),(94,'2021-05-01'),(95,'2021-05-02'),(96,'2021-05-03'),(97,'2021-05-04'),(98,'2021-05-05'),(99,'2021-05-06'),(100,'2021-05-07'),(101,'2021-05-08'),(102,'2021-05-09'),(103,'2021-05-10'),(104,'2021-05-11'),(105,'2021-05-12'),(106,'2021-05-13'),(107,'2021-05-14'),(108,'2021-05-15'),(109,'2021-05-16'),(110,'2021-05-17'),(111,'2021-05-18'),(112,'2021-05-19'),(113,'2021-05-20'),(114,'2021-05-21'),(115,'2021-05-22'),(116,'2021-05-23'),(117,'2021-05-24'),(118,'2021-05-25'),(119,'2021-05-26'),(120,'2021-05-27'),(121,'2021-05-28'),(122,'2021-05-29'),(123,'2021-05-30'),(124,'2021-05-31'),(125,'2021-05-01'),(126,'2021-05-02'),(127,'2021-05-03'),(128,'2021-05-04'),(129,'2021-05-05'),(130,'2021-05-06'),(131,'2021-05-07'),(132,'2021-05-08'),(133,'2021-05-09'),(134,'2021-05-10'),(135,'2021-05-11'),(136,'2021-05-12'),(137,'2021-05-13'),(138,'2021-05-14'),(139,'2021-05-15'),(140,'2021-05-16'),(141,'2021-05-17'),(142,'2021-05-18'),(143,'2021-05-19'),(144,'2021-05-20'),(145,'2021-05-21'),(146,'2021-05-22'),(147,'2021-05-23'),(148,'2021-05-24'),(149,'2021-05-25'),(150,'2021-05-26'),(151,'2021-05-27'),(152,'2021-05-28'),(153,'2021-05-29'),(154,'2021-05-30'),(155,'2021-05-31'),(156,'2021-05-01'),(157,'2021-05-02'),(158,'2021-05-03'),(159,'2021-05-04'),(160,'2021-05-05'),(161,'2021-05-06'),(162,'2021-05-07'),(163,'2021-05-08'),(164,'2021-05-09'),(165,'2021-05-10'),(166,'2021-05-11'),(167,'2021-05-12'),(168,'2021-05-13'),(169,'2021-05-14'),(170,'2021-05-15'),(171,'2021-05-16'),(172,'2021-05-17'),(173,'2021-05-18'),(174,'2021-05-19'),(175,'2021-05-20'),(176,'2021-05-21'),(177,'2021-05-22'),(178,'2021-05-23'),(179,'2021-05-24'),(180,'2021-05-25'),(181,'2021-05-26'),(182,'2021-05-27'),(183,'2021-05-28'),(184,'2021-05-29'),(185,'2021-05-30'),(186,'2021-05-31'),(187,'2021-05-01'),(188,'2021-05-02'),(189,'2021-05-03'),(190,'2021-05-04'),(191,'2021-05-05'),(192,'2021-05-06'),(193,'2021-05-07'),(194,'2021-05-08'),(195,'2021-05-09'),(196,'2021-05-10'),(197,'2021-05-11'),(198,'2021-05-12'),(199,'2021-05-13'),(200,'2021-05-14'),(201,'2021-05-15'),(202,'2021-05-16'),(203,'2021-05-17'),(204,'2021-05-18'),(205,'2021-05-19'),(206,'2021-05-20'),(207,'2021-05-21'),(208,'2021-05-22'),(209,'2021-05-23'),(210,'2021-05-24'),(211,'2021-05-25'),(212,'2021-05-26'),(213,'2021-05-27'),(214,'2021-05-28'),(215,'2021-05-29'),(216,'2021-05-30'),(217,'2021-05-31'),(218,'2021-05-01'),(219,'2021-05-02'),(220,'2021-05-03'),(221,'2021-05-04'),(222,'2021-05-05'),(223,'2021-05-06'),(224,'2021-05-07'),(225,'2021-05-08'),(226,'2021-05-09'),(227,'2021-05-10'),(228,'2021-05-11'),(229,'2021-05-12'),(230,'2021-05-13'),(231,'2021-05-14'),(232,'2021-05-15'),(233,'2021-05-16'),(234,'2021-05-17'),(235,'2021-05-18'),(236,'2021-05-19'),(237,'2021-05-20'),(238,'2021-05-21'),(239,'2021-05-22'),(240,'2021-05-23'),(241,'2021-05-24'),(242,'2021-05-25'),(243,'2021-05-26'),(244,'2021-05-27'),(245,'2021-05-28'),(246,'2021-05-29'),(247,'2021-05-30'),(248,'2021-05-31'),(249,'2021-05-01'),(250,'2021-05-02'),(251,'2021-05-03'),(252,'2021-05-04'),(253,'2021-05-05'),(254,'2021-05-06'),(255,'2021-05-07'),(256,'2021-05-08'),(257,'2021-05-09'),(258,'2021-05-10'),(259,'2021-05-11'),(260,'2021-05-12'),(261,'2021-05-13'),(262,'2021-05-14'),(263,'2021-05-15'),(264,'2021-05-16'),(265,'2021-05-17'),(266,'2021-05-18'),(267,'2021-05-19'),(268,'2021-05-20'),(269,'2021-05-21'),(270,'2021-05-22'),(271,'2021-05-23'),(272,'2021-05-24'),(273,'2021-05-25'),(274,'2021-05-26'),(275,'2021-05-27'),(276,'2021-05-28'),(277,'2021-05-29'),(278,'2021-05-30'),(279,'2021-05-31'),(280,'2021-05-01'),(281,'2021-05-02'),(282,'2021-05-03'),(283,'2021-05-04'),(284,'2021-05-05'),(285,'2021-05-06'),(286,'2021-05-07'),(287,'2021-05-08'),(288,'2021-05-09'),(289,'2021-05-10'),(290,'2021-05-11'),(291,'2021-05-12'),(292,'2021-05-13'),(293,'2021-05-14'),(294,'2021-05-15'),(295,'2021-05-16'),(296,'2021-05-17'),(297,'2021-05-18'),(298,'2021-05-19'),(299,'2021-05-20'),(300,'2021-05-21'),(301,'2021-05-22'),(302,'2021-05-23'),(303,'2021-05-24'),(304,'2021-05-25'),(305,'2021-05-26'),(306,'2021-05-27'),(307,'2021-05-28'),(308,'2021-05-29'),(309,'2021-05-30'),(310,'2021-05-31');
/*!40000 ALTER TABLE `sale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'cloudtail','1234567899','99 park street'),(2,'Zappos','9087998688','25 East road street,Boston,MA'),(3,'Spreetail','8976897589','55 heath street,Houston,TX'),(4,'Fintie','5790878949','92 Locust Street,San Francisco,CA'),(5,'AlinUS','3459494949','84 Spruce Street,Woodstock,MD');
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'inventory_management'
--

--
-- Dumping routines for database 'inventory_management'
--
/*!50003 DROP PROCEDURE IF EXISTS `all_brands` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_brands`()
begin
	select * from brand;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `all_categories` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_categories`()
begin
	select * from category order by id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `all_employees` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_employees`()
begin
	select * from employee order by id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `all_products` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_products`()
begin
	select p.id, p.name, p.price, p.description, p.quantity, p.manufacture_date manufacture, p.expiry_date expiry, p.location, p.brand, c.name category, s.name supplier from product p join category c on p.category=c.id join supplier s on p.supplier=s.id order by p.id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `all_suppliers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_suppliers`()
begin
	select * from supplier;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `all_supplier_products` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_supplier_products`(id_in int)
begin
	select id, name, price, brand from product where supplier=id_in order by id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cancel_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cancel_order`(purchase_id_in int)
begin
	update order_details set status="Cancelled" where purchase_id=purchase_id_in;
    select "Order cancelled successfully" response;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_user`(in email varchar(500),in pw varchar(255))
begin
	declare t varchar(500) default null;
	select pass into t   from loginDetails where email_address=email ;
    if (select pass from loginDetails where email_address=email) <=> pw then
		select "yes" response;
	else 
		select "no" response;
	end if;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_brand` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_brand`(name_in varchar(64))
begin
	if not exists (select * from brand where LOWER(name)=LOWER(name_in)) then
		insert into brand(name) values(name_in);
        select "Brand added succesfully" as response;
	else
		select "Brand already exists" as response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_category` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_category`(name_in varchar(64), description_in varchar(128) )
begin
	if not exists (select * from category where lower(name)=lower(name_in)) then
		insert into category(name, description) values(name_in, description_in);
        select "Category created successfully" as response;
	else
		select "Category already exists" as response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_employee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_employee`(first_name_in varchar(128), last_name_in varchar(128), address_in varchar(300), emp_type_in enum("Manager", "Worker"), phone_in varchar(15), ssn_in varchar(15), email_in varchar(500))
begin
	if not exists (select * from employee where lower(email_address)=lower(email_in)) then 
		insert into employee(first_name, last_name, address, emp_type, phone, ssn, email_address) values(first_name_in, last_name_in, address_in, emp_type_in, phone_in, ssn_in, email_in);
        select "Employee added successfully" response;
	else 
		select "Employee already exists" response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_product`(name_in varchar(300), price_in float, description_in varchar(500), quantity_in int, manufacture_date_in date, expiry_date_in date, location_in varchar(64), brand_in varchar(64), category_in varchar(64), supplier_in varchar(128) )
begin
	declare cat_id int default null;
    declare sup_id int default null;
    select id into cat_id from category where name=category_in;
    select id into sup_id from supplier where name=supplier_in;
	if not exists (select * from product where lower(name)=lower(name_in) and lower(brand)=lower(brand_in) and supplier=sup_id ) then 
		insert into product(name, price, description, quantity, manufacture_date, expiry_date, location, brand, category, supplier) values(name_in, price_in, description_in, quantity_in, manufacture_date_in, expiry_date_in, location_in, brand_in, cat_id, sup_id);
        select "Product added successfully" response;
	else 
		select "Product already exists" response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_supplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_supplier`(name_in varchar(64), phone varchar(15), address varchar(300) )
begin
	if not exists (select * from supplier where lower(name)=lower(name_in)) then
		insert into supplier(name, phone, address) values(name_in, phone, address);
        select "Supplier created successfully" as response;
	else
		select "Supplier already exists" as response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_user`(in first varchar(500),in last varchar(500),in address varchar(500),in ph varchar(15),in ssn varchar(15), in em varchar(300), in  passcode varchar(15))
begin
	declare temp1 varchar(500);
    declare temp2 varchar(500);
	select email_address into temp1 from loginDetails where email_address=em;
    select email_address into temp2 from employee where email_address=em;
    
	if temp1<=>null and  temp2<=>null then
		
		insert into employee(first_name,last_name,address,emp_type,phone,ssn,email_address) values(first,last,address,'Manager',ph,ssn,em);
        insert into loginDetails(email_address,pass) values(em,passcode);
        if exists(select email_address from loginDetails) then
			select 1 response;
		else
			select 0 response;
		end if;
	else
		select 0 response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_brand` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_brand`(name_in varchar(64))
begin
	if exists (select * from brand where name=name_in) then
		delete from brand where name=name_in;
        select "Deleted brand successfully" response;
	else
		select "Requested brand doesn't exist to delete." response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_category` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_category`(id_in int)
begin
	if exists (select * from category where id=id_in) then
		delete from category where id=id_in;
        select "Deleted category successfully" response;
	else
		select "Requested category doesn't exist to delete." response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_employee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_employee`(id_in int)
begin
	if exists (select * from employee where id=id_in) then
		delete from employee where id=id_in;
        select "Employee deleted successfully" response;
	else
		select "Employee doesn't exist to delete" response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_product`(id_in int)
begin
	if exists (select * from product where id=id_in) then
		delete from product where id=id_in;
        select "Product deleted successfully" response;
	else
		select "Product doesn't exist to delete" response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_supplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_supplier`(id_in int)
begin
	if exists (select * from supplier where id=id_in) then
		delete from supplier where id=id_in;
        select "Deleted supplier successfully" response;
	else
		select "Requested supplier doesn't exist to delete." response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_brand` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_brand`(name_in varchar(64))
begin
	select * from brand where lower(name)=lower(name_in);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_category` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_category`(name_in varchar(64))
begin
	select * from category where lower(name)=lower(name_in);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_category_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_category_by_id`(id_in int)
begin
	select * from category where id=id_in;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_employee_by_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_employee_by_email`(email_in varchar(500))
begin
	select * from employee where email_address=email_in;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_employee_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_employee_by_id`(id_in int)
begin
	select * from employee where id=id_in;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_product_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_product_by_id`(id_in int)
begin
	select * from product where id=id_in;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_supplier_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_supplier_by_id`(id_in int)
begin
	select * from supplier where id=id_in;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_supplier_by_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_supplier_by_name`(name_in varchar(64))
begin
	select * from supplier where lower(name)=lower(name_in);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `high_sale_products` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `high_sale_products`()
begin
	select p.name, SUM(ps.quantity) sales from product_sale ps join product p on p.id=ps.product_id group by ps.product_id order by sales desc limit 5;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `high_sale_product_trend` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `high_sale_product_trend`()
begin
	select sale_date,quantity from product_sale ps join sale s on ps.sale_id=s.id where ps.product_id=(select p.id id from product_sale ps join product p on p.id=ps.product_id group by ps.product_id order by SUM(ps.quantity) desc limit 1);

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `low_sale_products` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `low_sale_products`()
begin
	select p.name, SUM(ps.quantity) sales from product_sale ps join product p on p.id=ps.product_id group by ps.product_id order by sales limit 5;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `low_stock_products` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `low_stock_products`()
begin
	select name, quantity from product where quantity<100 order by quantity desc;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `order_new_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `order_new_product`(emp_id_in int,sup_id_in int,p_id_in int, qty_in int)
begin
	declare cur_price float default null;
    declare cur_id int default null;
	insert into purchase_order(order_date) values(current_date());
    select id into cur_id from purchase_order order by id desc limit 1;
	select price into cur_price from product where id=p_id_in;
    insert into order_details(emp_id, sup_id, purchase_id, product_id, quantity, price) values(emp_id_in, sup_id_in, cur_id, p_id_in, qty_in, cur_price*qty_in);
    
    select "Order placed successfully" response;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rename_brand` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rename_brand`(old_name varchar(64), new_name varchar(64))
begin
	if exists (select * from brand where lower(name)=lower(old_name)) then
		update brand set name=new_name where name=old_name;
        select "renamed brand successfully" response;
	else
		select "Requested brand doesn't exist to rename." response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `settle_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `settle_order`(purchase_id_in int)
begin
	update order_details set status="Settled" where purchase_id=purchase_id_in;
    select "Settled order successfully" response;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplier_orders_active` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `supplier_orders_active`(id_in int)
begin
	select p.id, p.order_date, o.emp_id, pr.name product, o.quantity, o.price price_$ from purchase_order p join order_details o on p.id=o.purchase_id join product pr on o.product_id=pr.id where o.sup_id=id_in and o.status="Pending";

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplier_orders_settled` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `supplier_orders_settled`(id_in int)
begin
	select p.id, p.order_date, o.emp_id, pr.name product, o.quantity, o.price price_$ from purchase_order p join order_details o on p.id=o.purchase_id join product pr on o.product_id=pr.id where o.sup_id=id_in and o.status="Settled";

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supplier_past_orders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `supplier_past_orders`(id_in int)
begin
	select p.id, p.order_date, o.emp_id, pr.name product, o.quantity, o.price price_$, o.status from purchase_order p join order_details o on p.id=o.purchase_id join product pr on o.product_id=pr.id where o.sup_id=id_in and o.status="Settled" or o.status="Cancelled";

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_category` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_category`(id_in int, new_name varchar(64), new_description varchar(64))
begin
	if exists (select * from category where id=id_in) then
		update category set name=new_name, description=new_description where id=id_in;
		select "Category updated successfully" as response;
	else
		select "Category doesn't exists to update" as response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_employee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_employee`(id_in int, new_address varchar(300), new_emp_type enum("Manager", "Worker"), new_phone varchar(15) )
begin
	if exists (select * from employee where id=id_in) then
		update employee set address=new_address, emp_type=new_emp_type, phone=new_phone where id=id_in;
        select "Employee details updated successfully" response;
	else
		select "Employee doesn't exist to update" response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_product`(id_in int, new_name varchar(300), new_price float, new_description varchar(500), new_quantity int, new_manufacture_date date, new_expiry_date date, new_location varchar(64), new_brand varchar(64), new_category varchar(64), new_supplier varchar(128) )
begin
	declare cat_id int default null;
    declare sup_id int default null;
    select id into cat_id from category where name=new_category;
    select id into sup_id from supplier where name=new_supplier;
	if exists (select * from product where id=id_in) then
		update product set name=new_name, price=new_price, description=new_description, quantity=new_quantity , manufacture_date=new_manufacture_date , expiry_date=new_expiry_date , location=new_location , brand=new_brand, category=cat_id , supplier=sup_id where id=id_in;
        select "Product details updated successfully" response;
	else
		select "Product doesn't exist to update" response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_supplier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_supplier`(id_in int, new_name varchar(64), new_phone varchar(15), new_address varchar(300))
begin
	if exists (select * from supplier where id=id_in) then
		update supplier set name=new_name, phone=new_phone, address=new_address where id=id_in;
		select "Supplier updated successfully" as response;
	else
		select "Supplier doesn't exists to update" as response;
	end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-12-09 14:56:21
