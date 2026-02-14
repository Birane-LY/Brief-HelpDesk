-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: GESTION_TICKETS
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

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
-- Table structure for table `Comptes`
--

DROP TABLE IF EXISTS `Comptes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Comptes` (
  `id_compte` int NOT NULL AUTO_INCREMENT,
  `mot_de_passe` varchar(255) NOT NULL,
  `date_creation` datetime DEFAULT NULL,
  `date_connexion` datetime DEFAULT NULL,
  `date_deconnexion` datetime DEFAULT NULL,
  `id_utilisateur` int DEFAULT NULL,
  PRIMARY KEY (`id_compte`),
  UNIQUE KEY `id_compte` (`id_compte`),
  UNIQUE KEY `mot_de_passe` (`mot_de_passe`),
  KEY `id_utilisateur` (`id_utilisateur`),
  CONSTRAINT `Comptes_ibfk_1` FOREIGN KEY (`id_utilisateur`) REFERENCES `Utilisateurs` (`id_utilisateur`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Comptes`
--

LOCK TABLES `Comptes` WRITE;
/*!40000 ALTER TABLE `Comptes` DISABLE KEYS */;
INSERT INTO `Comptes` VALUES (1,'$2b$12$penda1234','2026-02-12 16:51:53',NULL,NULL,1),(2,'9ab891da45d1d2b796b4f17d2f6e4ca3e94210e506141a10002b92116de8985411a5b8c84bb66f42b2e075fbf6bed2db990bbe7e9b0ba465fe969d26695d81ba','2026-02-12 16:54:53',NULL,NULL,2),(3,'$2b$12$QtRTXPQ351gRtsTCGcp1XOqfVF9VNjrmt8GK3f/7eVgsXC6J/kWQy','2026-02-12 17:03:21','2026-02-12 22:47:07','2026-02-12 22:36:09',3),(4,'$2b$12$QKfBZ0RdoM6stxy3kJsm/eP/SmF1AgByNMhA4qUm5Kx3CoptZOE2e','2026-02-12 22:39:35','2026-02-13 12:52:49','2026-02-13 10:34:40',4),(5,'$2b$12$lsugHALdYwh3wdZBMo46Ze614riYLGxi4kWHrNrpcOzCDIuSBv7Yy','2026-02-12 22:49:56','2026-02-13 10:13:08','2026-02-13 10:20:05',5),(6,'$2b$12$8SfEojwVH8hQqfZm6T/le.rxNAwzPBuq96uN8dawL05.CbH3VkzRa','2026-02-12 23:29:53','2026-02-13 10:08:05','2026-02-13 10:12:02',6),(7,'$2b$12$pMGqg7isASXHFnQdiOqIk.cJX5kmiL25RcDNjTsAb9SQCaMJAANOK','2026-02-13 10:37:18','2026-02-13 11:19:05',NULL,7),(8,'$2b$12$HWAHaOzUfXdimZxJgEOgSej30iHi2JTZKYmED0kjbnUtTcqXs4Laa','2026-02-13 12:44:52','2026-02-13 12:45:13','2026-02-13 12:51:46',8);
/*!40000 ALTER TABLE `Comptes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tickets`
--

DROP TABLE IF EXISTS `Tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tickets` (
  `id_ticket` int NOT NULL AUTO_INCREMENT,
  `titre` varchar(25) NOT NULL,
  `description` text NOT NULL,
  `niveau_urgence` varchar(255) DEFAULT NULL,
  `date_demande` datetime DEFAULT NULL,
  `statut_demande` enum('En attente','En cours','Résolu','Rejeté') DEFAULT 'En attente',
  `id_utilisateur` int DEFAULT NULL,
  PRIMARY KEY (`id_ticket`),
  UNIQUE KEY `id_ticket` (`id_ticket`),
  KEY `id_utilisateur` (`id_utilisateur`),
  CONSTRAINT `Tickets_ibfk_1` FOREIGN KEY (`id_utilisateur`) REFERENCES `Utilisateurs` (`id_utilisateur`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tickets`
--

LOCK TABLES `Tickets` WRITE;
/*!40000 ALTER TABLE `Tickets` DISABLE KEYS */;
INSERT INTO `Tickets` VALUES (1,'Panne','Mon ordinateur s\'est éteint brusquement en plein codage.','Niveau 3 | Ordinateur en panne','2026-02-12 22:11:28','Résolu',3),(2,'Oubli','J\'ai oublié ma carte d\'étudiant à l\'accuiel au moment du pointage en quittant l\'Eno.','Niveau 1 | Chargeur perdu','2026-02-13 10:10:08','En attente',6),(3,'Connectivité','Bonjour, cela fait quelques jours que je n\'arrive pas à accéder à la plateforme et je rate actuellement des cours et j\'ai besoin d\'une solution.','Niveau 2 | Modem/SIM non fonctionnel','2026-02-13 10:14:26','En attente',5),(4,'Examen','Bonjour, je souhaiterai savoir s\'il est possible que je puisse faire les examens en ligne car je suis actuellement en dépalacement dans la région et je ne pourrai pas assurer ma présence physique pour cette date.','Niveau 3 | Manque d\'assiduité prof','2026-02-13 10:49:40','En attente',7),(5,'Absence répétée','Bonjour, j\'ai constaté que notre coach en Langage C n\'a jamais fait de cours et nous en sommes pénalisés.','Niveau 3 | Manque d\'assiduité des profs','2026-02-13 12:46:23','En attente',8);
/*!40000 ALTER TABLE `Tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Utilisateurs`
--

DROP TABLE IF EXISTS `Utilisateurs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Utilisateurs` (
  `id_utilisateur` int NOT NULL AUTO_INCREMENT,
  `prenom` varchar(255) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` enum('Admin','Etudiant') DEFAULT 'Etudiant',
  PRIMARY KEY (`id_utilisateur`),
  UNIQUE KEY `id_utilisateur` (`id_utilisateur`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Utilisateurs`
--

LOCK TABLES `Utilisateurs` WRITE;
/*!40000 ALTER TABLE `Utilisateurs` DISABLE KEYS */;
INSERT INTO `Utilisateurs` VALUES (1,'Penda','DIOP','penda.diop@unchk.edu.sn','Etudiant'),(2,'Mariama','DIALLO','mariama.diallo@unchk.edu.sn','Etudiant'),(3,'Arame','DIENG','arame.dieng@unchk.edu.sn','Etudiant'),(4,'Birane','LY','lybirane@unchk.edu.sn','Admin'),(5,'Ibrahima','SAMB','ibrahima.samb@unchk.edu.sn','Etudiant'),(6,'Aissatou','CAMARA','aissatou@unchk.edu.sn','Etudiant'),(7,'Abdou','FALL','abdou@unchk.edu.sn','Etudiant'),(8,'Mariama','DIALLO','mariama@unchk.edu.sn','Etudiant');
/*!40000 ALTER TABLE `Utilisateurs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-13 15:50:49
