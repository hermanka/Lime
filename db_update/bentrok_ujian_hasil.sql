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

-- Dumping structure for table simakad._tb_cek_bentrok_ujian
CREATE TABLE IF NOT EXISTS `_tb_cek_bentrok_ujian` (
  `tgl` char(50) NOT NULL,
  `jam` varchar(2) NOT NULL,
  `cek` varchar(1) NOT NULL,
  `id_jadwal` char(3) NOT NULL,
  `kd_mk` varchar(15) NOT NULL,
  `tipe` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table simakad._tb_cek_bentrok_ujian_hasil
CREATE TABLE IF NOT EXISTS `_tb_cek_bentrok_ujian_hasil` (
  `NIM` varchar(15) NOT NULL,
  `id_jadwal1` varchar(5) NOT NULL,
  `mk1` varchar(15) NOT NULL,
  `tipe1` varchar(1) NOT NULL,
  `id_jadwal2` varchar(5) NOT NULL,
  `mk2` varchar(15) NOT NULL,
  `tipe2` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
