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

-- Dumping structure for table simakad.forlap_trakm
CREATE TABLE IF NOT EXISTS `forlap_trakm` (
  `smt` char(10) DEFAULT NULL,
  `kd_pts` char(6) DEFAULT '063020',
  `kd_jen` char(1) DEFAULT NULL,
  `kd_prodi` char(5) DEFAULT NULL,
  `nim` char(15) DEFAULT NULL,
  `sks_sem` char(3) DEFAULT NULL,
  `ips` char(4) DEFAULT NULL,
  `sks_tot` char(3) DEFAULT NULL,
  `ipk` char(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- Data exporting was unselected.


-- Dumping structure for table simakad.forlap_trnlm
CREATE TABLE IF NOT EXISTS `forlap_trnlm` (
  `smt` char(10) DEFAULT NULL,
  `kd_pts` char(6) DEFAULT '063020',
  `kd_jen` char(1) DEFAULT NULL,
  `kd_prodi` char(5) DEFAULT NULL,
  `nim` char(15) DEFAULT NULL,
  `kd_mk` char(15) DEFAULT NULL,
  `nilai` char(1) DEFAULT NULL,
  `bobot` char(1) DEFAULT NULL,
  `kelas` char(2) DEFAULT '01'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
