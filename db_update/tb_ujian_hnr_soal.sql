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

-- Dumping structure for table simakad.tb_ujian_hnr_soal
CREATE TABLE IF NOT EXISTS `tb_ujian_hnr_soal` (
  `th_akdm` char(15) NOT NULL,
  `ujian` char(1) NOT NULL,
  `id_jadwal` int(3) NOT NULL,
  `jenis` char(3) NOT NULL,
  `kd_mk` char(12) NOT NULL,
  `nik` char(50) NOT NULL,
  `honor` char(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tabel hitung honor pembuatan soal ujian';

-- Dumping data for table simakad.tb_ujian_hnr_soal: ~183 rows (approximately)
/*!40000 ALTER TABLE `tb_ujian_hnr_soal` DISABLE KEYS */;
INSERT INTO `tb_ujian_hnr_soal` (`th_akdm`, `ujian`, `id_jadwal`, `jenis`, `kd_mk`, `nik`, `honor`) VALUES
	('12013/2014', 'A', 1, 'T1', 'STI103007', '50', '37000'),
	('12013/2014', 'A', 2, 'P1', 'DTI103002', '5', '26000'),
	('12013/2014', 'A', 2, 'T1', 'DTI103002', '5', '26000'),
	('12013/2014', 'A', 3, 'P1', 'SSI103002', '5', '25000'),
	('12013/2014', 'A', 3, 'T1', 'SSI103002', '5', '25000'),
	('12013/2014', 'A', 4, 'T1', 'STI103004', '17', '36000'),
	('12013/2014', 'A', 5, 'T1', 'DKA101006', '7', '34000'),
	('12013/2014', 'A', 5, 'T2', 'DKA101006', '7', '34000'),
	('12013/2014', 'A', 6, 'P1', 'STI103006', '20', '27000'),
	('12013/2014', 'A', 6, 'T1', 'STI103006', '20', '27000'),
	('12013/2014', 'A', 7, 'P1', 'DTI103006', '20', '34000'),
	('12013/2014', 'A', 7, 'T1', 'DTI103006', '20', '34000'),
	('12013/2014', 'A', 8, 'P1', 'DTI103001', '11', '26000'),
	('12013/2014', 'A', 8, 'T1', 'DTI103001', '11', '26000'),
	('12013/2014', 'A', 9, 'P1', 'SSI103001', '11', '24000'),
	('12013/2014', 'A', 9, 'T1', 'SSI103001', '11', '24000'),
	('12013/2014', 'A', 10, 'P1', 'DTI103003', '21', '26000'),
	('12013/2014', 'A', 10, 'T1', 'DTI103003', '21', '26000'),
	('12013/2014', 'A', 11, 'P1', 'SSI103003', '21', '25000'),
	('12013/2014', 'A', 11, 'T1', 'SSI103003', '21', '25000'),
	('12013/2014', 'A', 12, 'T1', 'DTI103005', '24', '41000'),
	('12013/2014', 'A', 13, 'T1', 'SSI303K11', '7', '12000'),
	('12013/2014', 'A', 13, 'T2', 'SSI303K11', '7', '12000'),
	('12013/2014', 'A', 15, 'T1', 'DTI303007', '52', '51000'),
	('12013/2014', 'A', 16, 'T1', 'SSI303003', '23', '28000'),
	('12013/2014', 'A', 17, 'T1', 'DTI303006', '49', '28000'),
	('12013/2014', 'A', 18, 'T1', 'SSI303001', '18', '29000'),
	('12013/2014', 'A', 19, 'P1', 'STI303005', '13', '24000'),
	('12013/2014', 'A', 19, 'T1', 'STI303005', '13', '24000'),
	('12013/2014', 'A', 20, 'P1', 'SSI303002', '9', '27000'),
	('12013/2014', 'A', 20, 'T1', 'SSI303002', '9', '27000'),
	('12013/2014', 'A', 21, 'T1', 'SSI303004', '9', '30000'),
	('12013/2014', 'A', 22, 'T1', 'SSI503K13', '7', '12000'),
	('12013/2014', 'A', 22, 'T2', 'SSI503K13', '7', '12000'),
	('12013/2014', 'A', 23, 'P1', 'SSI503003', '13', '35000'),
	('12013/2014', 'A', 23, 'T1', 'SSI503003', '13', '35000'),
	('12013/2014', 'A', 25, 'T1', 'DTI503001', '4', '34000'),
	('12013/2014', 'A', 27, 'T1', 'DTI503006', '35', '37000'),
	('12013/2014', 'A', 28, 'P1', 'SSI503002', '13', '30000'),
	('12013/2014', 'A', 28, 'T1', 'SSI503002', '13', '30000'),
	('12013/2014', 'A', 29, 'T1', 'SSI503005', '22', '21000'),
	('12013/2014', 'A', 30, 'P1', 'DTI503K13', '45', '18000'),
	('12013/2014', 'A', 30, 'T1', 'DTI503K13', '45', '18000'),
	('12013/2014', 'A', 31, 'T1', 'STI503007', '49', '27000'),
	('12013/2014', 'A', 32, 'T1', 'SSI703001', '6', '14000'),
	('12013/2014', 'A', 33, 'T1', 'STI703K13', '5', '24000'),
	('12013/2014', 'A', 34, 'P1', 'SSI703002', '20', '26000'),
	('12013/2014', 'A', 34, 'T1', 'STI703003', '20', '26000'),
	('12013/2014', 'A', 35, 'P1', 'STI703K14', '5', '23000'),
	('12013/2014', 'A', 35, 'T1', 'STI703K14', '5', '23000'),
	('12013/2014', 'A', 37, 'T1', 'STI103007', '50', '38000'),
	('12013/2014', 'A', 38, 'P1', 'STI103002', '6', '33000'),
	('12013/2014', 'A', 38, 'T1', 'STI103002', '6', '33000'),
	('12013/2014', 'A', 39, 'P1', 'STI103002', '6', '30000'),
	('12013/2014', 'A', 39, 'T1', 'STI103002', '6', '30000'),
	('12013/2014', 'A', 40, 'T1', 'STI103004', '51', '63000'),
	('12013/2014', 'A', 41, 'P1', 'STI103006', '20', '33000'),
	('12013/2014', 'A', 41, 'T1', 'STI103006', '20', '33000'),
	('12013/2014', 'A', 42, 'P1', 'STI103006', '20', '34000'),
	('12013/2014', 'A', 42, 'T1', 'STI103006', '20', '34000'),
	('12013/2014', 'A', 43, 'P1', 'STI103001', '11', '41000'),
	('12013/2014', 'A', 43, 'T1', 'STI103001', '11', '41000'),
	('12013/2014', 'A', 44, 'P1', 'STI103001', '11', '33000'),
	('12013/2014', 'A', 44, 'T1', 'STI103001', '11', '33000'),
	('12013/2014', 'A', 45, 'P1', 'STI103003', '21', '40000'),
	('12013/2014', 'A', 45, 'T1', 'STI103003', '21', '40000'),
	('12013/2014', 'A', 46, 'P1', 'STI103003', '21', '30000'),
	('12013/2014', 'A', 46, 'T1', 'STI103003', '21', '30000'),
	('12013/2014', 'A', 47, 'T1', 'STI103005', '24', '50000'),
	('12013/2014', 'A', 48, 'T1', 'STI203002', '49', '35000'),
	('12013/2014', 'A', 49, 'T1', 'STI303007', '52', '30000'),
	('12013/2014', 'A', 50, 'T1', 'STI303003', '23', '24000'),
	('12013/2014', 'A', 51, 'T1', 'STI303006', '49', '24000'),
	('12013/2014', 'A', 52, 'T1', 'STI303001', '18', '39000'),
	('12013/2014', 'A', 54, 'P1', 'STI303002', '9', '20000'),
	('12013/2014', 'A', 54, 'T1', 'STI303002', '9', '20000'),
	('12013/2014', 'A', 55, 'T1', 'STI303004', '9', '20000'),
	('12013/2014', 'A', 56, 'P1', 'STI503003', '5', '37000'),
	('12013/2014', 'A', 56, 'T1', 'STI503003', '5', '37000'),
	('12013/2014', 'A', 57, 'T1', 'SSI503004', '6', '50000'),
	('12013/2014', 'A', 58, 'T1', 'STI503001', '4', '31000'),
	('12013/2014', 'A', 59, 'T1', 'STI503006', '35', '35000'),
	('12013/2014', 'A', 60, 'T1', 'STI503005', '22', '25000'),
	('12013/2014', 'A', 61, 'T1', 'STI503007', '49', '36000'),
	('12013/2014', 'A', 62, 'T1', 'STI403006', '52', '47000'),
	('12013/2014', 'A', 63, 'T1', 'STI703K13', '5', '53000'),
	('12013/2014', 'A', 64, 'T1', 'SSI803001', '52', '53000'),
	('12013/2014', 'A', 65, 'T1', 'SSI303006', '6', '12000'),
	('12013/2014', 'A', 69, 'T1', 'DTI103004', '17', '41000'),
	('12013/2014', 'A', 70, 'T1', 'STI103005', '24', '43000'),
	('12013/2014', 'A', 71, 'T1', 'DTI103007', '50', '41000'),
	('12013/2014', 'A', 72, 'P1', 'STI103002', '5', '24000'),
	('12013/2014', 'A', 72, 'T1', 'STI103002', '5', '24000'),
	('12013/2014', 'A', 73, 'P1', 'DKA101002', '5', '24000'),
	('12013/2014', 'A', 73, 'T1', 'DKA101002', '5', '24000'),
	('12013/2014', 'A', 74, 'P1', 'DTI103001', '11', '24000'),
	('12013/2014', 'A', 74, 'T1', 'DTI103001', '11', '24000'),
	('12013/2014', 'A', 75, 'P1', 'DKA101001', '11', '24000'),
	('12013/2014', 'A', 75, 'T1', 'DKA101001', '11', '24000'),
	('12013/2014', 'A', 76, 'P1', 'STI103003', '21', '23000'),
	('12013/2014', 'A', 76, 'T1', 'STI103003', '21', '23000'),
	('12013/2014', 'A', 77, 'P1', 'DKA101003', '21', '24000'),
	('12013/2014', 'A', 77, 'T1', 'DKA101003', '21', '24000'),
	('12013/2014', 'A', 79, 'P1', 'STI103002', '5', '17000'),
	('12013/2014', 'A', 79, 'T1', 'STI103002', '5', '17000');
/*!40000 ALTER TABLE `tb_ujian_hnr_soal` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
