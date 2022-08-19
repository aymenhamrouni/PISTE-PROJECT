-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 23, 2018 at 11:57 PM
-- Server version: 5.7.22-0ubuntu0.16.04.1
-- PHP Version: 7.0.30-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `PISTE01A_2018`
--

-- --------------------------------------------------------

--
-- Table structure for table `Agro_Environmental_Parameters`
--

CREATE TABLE `Agro_Environmental_Parameters` (
  `Row_ID` int(11) NOT NULL,
  `Sensor_ID` int(11) DEFAULT NULL,
  `Luminosity` int(11) DEFAULT NULL,
  `Humidity` int(11) DEFAULT NULL,
  `Temperature` varchar(10) DEFAULT NULL,
  `Delay` double DEFAULT NULL,
  `Flow_Rate` double DEFAULT NULL,
  `Time` time DEFAULT NULL,
  `Date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Agro_Environmental_Parameters`
--
ALTER TABLE `Agro_Environmental_Parameters`
  ADD PRIMARY KEY (`Row_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Agro_Environmental_Parameters`
--
ALTER TABLE `Agro_Environmental_Parameters`
  MODIFY `Row_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
