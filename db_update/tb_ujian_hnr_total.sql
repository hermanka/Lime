-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               5.5.32 - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             8.3.0.4694
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table simakad.tb_ujian_hnr_total
CREATE TABLE IF NOT EXISTS `tb_ujian_hnr_total` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `th_akdm` char(15) DEFAULT NULL,
  `tipe` char(1) DEFAULT NULL COMMENT 'J:JAGA, S:PEMBUATAN SOAL',
  `ujian` char(1) DEFAULT NULL,
  `nik` char(3) DEFAULT NULL,
  `honor` char(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=latin1;

-- Dumping data for table simakad.tb_ujian_hnr_total: ~0 rows (approximately)
/*!40000 ALTER TABLE `tb_ujian_hnr_total` DISABLE KEYS */;
INSERT INTO `tb_ujian_hnr_total` (`id`, `th_akdm`, `tipe`, `ujian`, `nik`, `honor`) VALUES
	(91, '12013/2014', 'J', 'A', '20', '6000'),
	(92, '12013/2014', 'J', 'A', '24', '40000'),
	(93, '12013/2014', 'J', 'A', '26', '6000'),
	(94, '12013/2014', 'J', 'A', '28', '6000'),
	(95, '12013/2014', 'J', 'A', '9', '82000'),
	(96, '12013/2014', 'S', 'A', '11', '344000'),
	(97, '12013/2014', 'S', 'A', '13', '178000'),
	(98, '12013/2014', 'S', 'A', '17', '77000'),
	(99, '12013/2014', 'S', 'A', '18', '68000'),
	(100, '12013/2014', 'S', 'A', '20', '308000'),
	(101, '12013/2014', 'S', 'A', '21', '336000'),
	(102, '12013/2014', 'S', 'A', '22', '46000'),
	(103, '12013/2014', 'S', 'A', '23', '52000'),
	(104, '12013/2014', 'S', 'A', '24', '134000'),
	(105, '12013/2014', 'S', 'A', '35', '72000'),
	(106, '12013/2014', 'S', 'A', '4', '65000'),
	(107, '12013/2014', 'S', 'A', '45', '36000'),
	(108, '12013/2014', 'S', 'A', '49', '150000'),
	(109, '12013/2014', 'S', 'A', '5', '429000'),
	(110, '12013/2014', 'S', 'A', '50', '116000'),
	(111, '12013/2014', 'S', 'A', '51', '63000'),
	(112, '12013/2014', 'S', 'A', '52', '181000'),
	(113, '12013/2014', 'S', 'A', '6', '202000'),
	(114, '12013/2014', 'S', 'A', '7', '116000'),
	(115, '12013/2014', 'S', 'A', '9', '144000');
/*!40000 ALTER TABLE `tb_ujian_hnr_total` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
