-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 17, 2025 at 05:49 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ebazaar`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `Cart_ID` int(10) NOT NULL,
  `Cust_ID` int(10) NOT NULL,
  `Prod_ID` int(10) NOT NULL,
  `Quantity` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`Cart_ID`, `Cust_ID`, `Prod_ID`, `Quantity`) VALUES
(4, 3, 35, 1),
(5, 3, 45, 2),
(7, 5, 65, 1),
(8, 6, 75, 2),
(9, 7, 85, 1),
(10, 8, 95, 3),
(11, 9, 10, 2),
(12, 10, 20, 1),
(15, 6, 50, 1),
(16, 8, 60, 1),
(17, 10, 70, 2),
(19, 3, 90, 3),
(20, 5, 100, 1),
(87, 4, 1, 1),
(88, 4, 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `Cust_ID` int(10) NOT NULL,
  `Cust_name` varchar(100) NOT NULL,
  `Cust_email` varchar(100) NOT NULL,
  `Cust_password` varchar(50) NOT NULL,
  `Cust_phone` varchar(20) NOT NULL,
  `CCV` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`Cust_ID`, `Cust_name`, `Cust_email`, `Cust_password`, `Cust_phone`, `CCV`) VALUES
(1, 'Ahmad bin Ismail', 'ahmad.ismail@gmail.com', 'ahmad123', '0123456789', 123),
(2, 'Siti Nurhaliza', 'siti.nurhaliza@gmail.com', 'siti456', '0112345678', NULL),
(3, 'Lim Wei Jie', 'lim.weijie@gmail.com', 'lim789', '0134567890', 789),
(4, 'Priya a/p Raju', 'priya.raju@gmail.com', 'priya101', '0145678901', 101),
(5, 'Tan Mei Ling', 'tan.meiling@gmail.com', 'tan112', '0167890123', 112),
(6, 'Mohd Faizal', 'faizal.mohd@gmail.com', 'faizal131', '0178901234', 131),
(7, 'Nurul Syafiqah', 'nurul.syafiqah@gmail.com', 'nurul415', '0189012345', NULL),
(8, 'Wong Chee Meng', 'wong.cheemeng@gmail.com', 'wong617', '0190123456', 617),
(9, 'Anand a/l Krishnan', 'anand.krishnan@gmail.com', 'anand819', '0101234567', 819),
(10, 'Nor Azlina', 'nor.azlina@gmail.com', 'nor920', '0119876543', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cust_order`
--

CREATE TABLE `cust_order` (
  `Order_ID` int(10) NOT NULL,
  `Cust_ID` int(10) NOT NULL,
  `Order_date` date DEFAULT NULL,
  `Status` enum('Pending','Rejected','Preparing','Delivering','Completed') DEFAULT 'Pending',
  `Total_amount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cust_order`
--

INSERT INTO `cust_order` (`Order_ID`, `Cust_ID`, `Order_date`, `Status`, `Total_amount`) VALUES
(1, 1, '2023-11-01', 'Preparing', 31.54),
(2, 2, '2023-11-02', 'Preparing', 32.00),
(3, 3, '2023-11-03', 'Delivering', 18.75),
(4, 4, '2023-11-04', 'Completed', 42.50),
(5, 5, '2023-11-05', 'Pending', 15.25),
(6, 6, '2023-11-06', 'Rejected', 28.00),
(7, 7, '2023-11-07', 'Preparing', 36.50),
(8, 8, '2023-11-08', 'Delivering', 22.75),
(9, 9, '2023-11-09', 'Pending', 19.00),
(10, 10, '2023-11-10', 'Preparing', 34.38),
(11, 1, '2025-07-17', 'Pending', 5.50),
(12, 2, '2025-07-17', 'Pending', 64.50),
(13, 4, '2025-07-17', 'Pending', 17.60),
(14, 4, '2025-07-17', 'Pending', 9.22),
(15, 1, '2025-07-17', 'Pending', 6.15),
(16, 2, '2025-07-17', 'Pending', 41.22),
(17, 1, '2025-07-17', 'Rejected', 15.42),
(18, 1, '2025-07-17', 'Rejected', 3.95),
(19, 1, '2025-07-17', 'Completed', 39.72),
(20, 1, '2025-07-17', 'Pending', 39.72),
(21, 2, '2025-07-17', 'Pending', 14.75),
(22, 2, '2025-07-17', 'Preparing', 30.22),
(23, 4, '2025-07-17', 'Pending', 18.75),
(24, 4, '2025-07-17', 'Pending', 14.60),
(25, 4, '2025-07-17', 'Pending', 32.25),
(26, 1, '2025-07-17', 'Pending', 19.22),
(27, 2, '2025-07-17', 'Pending', 24.25),
(28, 1, '2025-07-17', 'Pending', 17.28),
(29, 1, '2025-07-17', 'Pending', 21.75),
(30, 4, '2025-07-17', 'Completed', 92.05),
(31, 1, '2025-07-17', 'Pending', 49.25);

-- --------------------------------------------------------

--
-- Table structure for table `delivery`
--

CREATE TABLE `delivery` (
  `Delivery_ID` int(10) NOT NULL,
  `Order_ID` int(10) DEFAULT NULL,
  `Rider_ID` int(11) DEFAULT NULL,
  `Delivery_status` enum('Pending','Transit','Delivered') DEFAULT 'Pending',
  `Distance_km` decimal(5,2) DEFAULT NULL,
  `Delivery_type` enum('Standard','Express') DEFAULT 'Standard',
  `Delivery_fee` decimal(6,2) DEFAULT NULL,
  `Address` varchar(200) DEFAULT NULL,
  `Payment_method` enum('Cash','Card') DEFAULT 'Cash'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `delivery`
--

INSERT INTO `delivery` (`Delivery_ID`, `Order_ID`, `Rider_ID`, `Delivery_status`, `Distance_km`, `Delivery_type`, `Delivery_fee`, `Address`, `Payment_method`) VALUES
(1, 19, 1, 'Delivered', 2.06, 'Standard', 0.72, 'Mydin MITC Melaka', 'Cash'),
(2, 20, NULL, 'Pending', 2.06, 'Standard', 0.72, 'Mydin MITC Melaka', 'Cash'),
(3, 21, NULL, 'Pending', 3.57, 'Standard', 1.25, 'Zoo Melaka', 'Cash'),
(4, 22, NULL, 'Pending', 2.06, 'Standard', 0.72, 'Mydin MITC Melaka', 'Cash'),
(5, 23, NULL, 'Pending', 3.57, 'Standard', 1.25, 'Zoo Melaka', 'Card'),
(6, 24, NULL, 'Pending', 3.57, 'Express', 1.60, 'Zoo Melaka', 'Cash'),
(7, 25, NULL, 'Pending', 3.57, 'Standard', 1.25, 'Zoo Melaka', 'Cash'),
(8, 26, NULL, 'Pending', 2.06, 'Standard', 0.72, 'Mydin MITC Melaka', 'Cash'),
(9, 27, NULL, 'Pending', 3.57, 'Standard', 1.25, 'Zoo Melaka', 'Cash'),
(10, 28, NULL, 'Pending', 16.52, 'Standard', 5.78, 'No. 12, Jalan Bukit Beruang Lightning, Bukit Beruang, 75450 Melaka', 'Cash'),
(11, 29, NULL, 'Pending', 3.57, 'Standard', 1.25, 'Zoo Melaka', 'Card'),
(12, NULL, NULL, 'Pending', 16.52, 'Standard', 5.78, 'No. 12, Jalan Bukit Beruang Lightning, Bukit Beruang, 75450 Melaka', 'Cash'),
(13, 30, 1, 'Delivered', 15.67, 'Express', 7.05, 'No. 29, Jalan MITC 2, Taman MITC, 75450 Melaka', 'Cash'),
(14, 31, NULL, 'Pending', 3.57, 'Standard', 1.25, 'Zoo Melaka', 'Cash');

-- --------------------------------------------------------

--
-- Table structure for table `order_item`
--

CREATE TABLE `order_item` (
  `Order_item_ID` int(10) NOT NULL,
  `Order_ID` int(10) NOT NULL,
  `Product_ID` int(10) NOT NULL,
  `Vend_ID` int(10) NOT NULL,
  `Quantity` int(200) NOT NULL,
  `Subtotal` decimal(10,2) NOT NULL,
  `Item_status` enum('Pending','Rejected','Preparing','Ready For Pickup') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_item`
--

INSERT INTO `order_item` (`Order_item_ID`, `Order_ID`, `Product_ID`, `Vend_ID`, `Quantity`, `Subtotal`, `Item_status`) VALUES
(1, 1, 1, 1, 2, 17.00, 'Pending'),
(2, 1, 11, 3, 1, 3.50, 'Pending'),
(3, 1, 16, 4, 3, 3.60, 'Ready For Pickup'),
(4, 2, 6, 2, 1, 12.00, 'Pending'),
(5, 2, 9, 2, 2, 5.00, 'Pending'),
(6, 2, 26, 6, 1, 3.00, 'Pending'),
(7, 3, 21, 5, 1, 5.00, 'Pending'),
(8, 3, 31, 7, 2, 8.00, 'Pending'),
(9, 3, 46, 10, 1, 3.50, 'Pending'),
(10, 4, 56, 12, 2, 6.00, 'Pending'),
(11, 4, 61, 13, 1, 3.50, 'Pending'),
(12, 5, 66, 14, 1, 5.00, 'Pending'),
(13, 5, 71, 15, 1, 3.00, 'Pending'),
(14, 6, 76, 16, 1, 7.00, 'Pending'),
(15, 6, 81, 17, 2, 3.00, 'Pending'),
(16, 7, 86, 18, 1, 4.00, 'Pending'),
(17, 7, 91, 19, 1, 8.00, 'Pending'),
(18, 8, 96, 20, 2, 5.00, 'Pending'),
(19, 9, 2, 1, 1, 15.00, 'Pending'),
(20, 10, 7, 2, 1, 15.00, 'Pending'),
(21, 10, 12, 3, 1, 3.50, 'Pending'),
(22, 10, 17, 4, 2, 3.00, 'Ready For Pickup'),
(23, 10, 22, 5, 1, 5.50, 'Pending'),
(24, 10, 27, 6, 1, 4.00, 'Pending'),
(25, 17, 16, 4, 6, 7.20, 'Rejected'),
(26, 17, 82, 17, 2, 3.00, 'Pending'),
(27, 17, 81, 17, 3, 4.50, 'Pending'),
(28, 18, 16, 4, 1, 1.20, 'Ready For Pickup'),
(29, 18, 17, 4, 1, 1.50, 'Pending'),
(30, 19, 6, 2, 1, 12.00, 'Ready For Pickup'),
(31, 19, 7, 2, 1, 15.00, 'Pending'),
(32, 19, 8, 2, 1, 12.00, 'Pending'),
(33, 20, 6, 2, 1, 12.00, 'Pending'),
(34, 20, 7, 2, 1, 15.00, 'Pending'),
(35, 20, 8, 2, 1, 12.00, 'Pending'),
(36, 21, 51, 11, 1, 4.00, 'Pending'),
(37, 21, 52, 11, 1, 4.50, 'Pending'),
(38, 21, 53, 11, 1, 5.00, 'Pending'),
(39, 22, 1, 1, 1, 8.50, 'Pending'),
(40, 22, 2, 1, 1, 15.00, 'Pending'),
(41, 22, 3, 1, 1, 6.00, 'Preparing'),
(42, 23, 76, 16, 1, 7.00, 'Pending'),
(43, 23, 77, 16, 1, 8.50, 'Pending'),
(44, 23, 78, 16, 1, 2.00, 'Pending'),
(45, 24, 46, 10, 1, 3.50, 'Pending'),
(46, 24, 47, 10, 1, 5.00, 'Pending'),
(47, 24, 48, 10, 1, 4.50, 'Pending'),
(48, 25, 2, 1, 1, 15.00, 'Pending'),
(49, 25, 3, 1, 1, 6.00, 'Pending'),
(50, 25, 4, 1, 1, 10.00, 'Pending'),
(51, 26, 26, 6, 1, 3.00, 'Pending'),
(52, 26, 27, 6, 1, 4.00, 'Pending'),
(53, 26, 28, 6, 2, 7.00, 'Pending'),
(54, 26, 29, 6, 1, 4.50, 'Pending'),
(55, 27, 7, 2, 1, 15.00, 'Pending'),
(56, 27, 9, 2, 2, 5.00, 'Pending'),
(57, 27, 10, 2, 1, 3.00, 'Pending'),
(58, 28, 71, 15, 1, 3.00, 'Pending'),
(59, 28, 72, 15, 1, 4.00, 'Pending'),
(60, 28, 73, 15, 1, 4.50, 'Pending'),
(61, 29, 14, 3, 1, 4.50, 'Pending'),
(62, 29, 15, 3, 4, 16.00, 'Pending'),
(63, 30, 1, 1, 1, 8.50, 'Ready For Pickup'),
(64, 30, 2, 1, 3, 45.00, 'Ready For Pickup'),
(65, 30, 3, 1, 1, 6.00, 'Ready For Pickup'),
(66, 30, 4, 1, 1, 10.00, 'Ready For Pickup'),
(67, 30, 6, 2, 1, 12.00, 'Pending'),
(68, 30, 11, 3, 1, 3.50, 'Pending'),
(69, 31, 2, 1, 2, 30.00, 'Pending'),
(70, 31, 3, 1, 3, 18.00, 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `Prod_ID` int(10) NOT NULL,
  `Vend_ID` int(10) NOT NULL,
  `Prod_name` varchar(100) NOT NULL,
  `Prod_desc` text NOT NULL,
  `Prod_price` decimal(7,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`Prod_ID`, `Vend_ID`, `Prod_name`, `Prod_desc`, `Prod_price`) VALUES
(1, 1, 'Minyak Wangi Melati', 'Traditional jasmine scented oil', 8.50),
(2, 1, 'Attar Kayu Gaharu', 'Premium agarwood perfume oil', 15.00),
(3, 1, 'Minyak Dauk', 'Classic Malay herbal scented oil', 6.00),
(4, 1, 'Minyak Kasturi', 'Musk scented perfume oil', 10.00),
(5, 1, 'Minyak Ros', 'Rose fragrance oil', 7.50),
(6, 2, 'Sate Ayam (10 sticks)', 'Chicken satay with peanut sauce', 12.00),
(7, 2, 'Sate Daging (10 sticks)', 'Beef satay with peanut sauce', 15.00),
(8, 2, 'Sate Kambing (5 sticks)', 'Lamb satay with peanut sauce', 12.00),
(9, 2, 'Nasi Impit', 'Compressed rice cakes', 2.50),
(10, 2, 'Kuah Kacang Extra', 'Extra peanut sauce', 3.00),
(11, 3, 'Teh Tarik Regular', 'Classic pulled milk tea', 3.50),
(12, 3, 'Teh Tarik Kurang Manis', 'Less sweet milk tea', 3.50),
(13, 3, 'Teh O Ais', 'Iced tea without milk', 2.50),
(14, 3, 'Teh Tarik Special', 'Extra thick milk tea', 4.50),
(15, 3, 'Teh Halia', 'Ginger milk tea', 4.00),
(16, 4, 'Kuih Lapis', 'Layered colorful cake', 1.20),
(17, 4, 'Kuih Seri Muka', 'Pandan custard on glutinous rice', 1.50),
(18, 4, 'Kuih Koci', 'Coconut filled glutinous rice cake', 1.00),
(19, 4, 'Kuih Talam', 'Two-layer steamed cake', 1.20),
(20, 4, 'Kuih Cara Berlauk', 'Savory spiced cake', 1.50),
(21, 5, 'Serbuk Kari Ayam', 'Chicken curry powder 100g', 5.00),
(22, 5, 'Serbuk Kari Daging', 'Beef curry powder 100g', 5.50),
(23, 5, 'Serbuk Rempah Sup', 'Soup spice mix 100g', 4.50),
(24, 5, 'Serbuk Kunyit', 'Turmeric powder 100g', 3.50),
(25, 5, 'Serbuk Cili Boh', 'Chili paste powder 100g', 6.00),
(26, 6, 'Sirap Bandung Regular', 'Rose syrup with milk', 3.00),
(27, 6, 'Sirap Bandung Special', 'With grass jelly', 4.00),
(28, 6, 'Sirap Cincau', 'Rose syrup with cincau', 3.50),
(29, 6, 'Air Soda Gembira', 'Soda with syrup and milk', 4.50),
(30, 6, 'Air Sirap Kosong', 'Plain rose syrup drink', 2.00),
(31, 7, 'Cucur Udang (3pcs)', 'Prawn fritters', 4.00),
(32, 7, 'Cucur Bawang (5pcs)', 'Onion fritters', 3.00),
(33, 7, 'Cucur Jagung (3pcs)', 'Corn fritters', 3.50),
(34, 7, 'Kuah Kicap Special', 'Special sweet soy sauce', 1.00),
(35, 7, 'Cucur Campur (5pcs)', 'Mixed vegetable fritters', 4.50),
(36, 8, 'Kacang Putih Original', 'Traditional white nuts', 3.00),
(37, 8, 'Kacang Telur', 'Egg-shaped crispy nuts', 3.50),
(38, 8, 'Kacang Pedas', 'Spicy roasted nuts', 4.00),
(39, 8, 'Kacang Berlada', 'Chili coated nuts', 4.00),
(40, 8, 'Kacang Campur', 'Mixed nuts combo', 5.00),
(41, 9, 'Rojak Buah Regular', 'Mixed fruit rojak', 5.00),
(42, 9, 'Rojak Buah Special', 'With extra ingredients', 7.00),
(43, 9, 'Kuah Rojak Extra', 'Extra rojak sauce', 2.00),
(44, 9, 'Rojak Jambu', 'Guava special rojak', 6.00),
(45, 9, 'Rojak Mangga', 'Mango special rojak', 6.00),
(46, 10, 'Pisang Goreng (3pcs)', 'Classic banana fritters', 3.50),
(47, 10, 'Pisang Goreng Cheese', 'With cheese topping', 5.00),
(48, 10, 'Pisang Goreng Madu', 'With honey drizzle', 4.50),
(49, 10, 'Pisang Goreng Coklat', 'With chocolate sauce', 5.00),
(50, 10, 'Pisang Goreng Special', 'Combo of all toppings', 6.00),
(51, 11, 'Keropok Lekor (5pcs)', 'Traditional fish crackers', 4.00),
(52, 11, 'Keropok Lekor Pedas', 'Spicy fish crackers', 4.50),
(53, 11, 'Keropok Keping', 'Sliced fish crackers', 5.00),
(54, 11, 'Sambal Kicap', 'Special dipping sauce', 1.50),
(55, 11, 'Keropok Campur', 'Mixed fish crackers', 6.00),
(56, 12, 'Apam Balik Biasa', 'Classic turnover pancake', 3.00),
(57, 12, 'Apam Balik Special', 'With extra peanuts & corn', 4.00),
(58, 12, 'Apam Balik Cheese', 'With cheese filling', 5.00),
(59, 12, 'Apam Balik Coklat', 'With chocolate spread', 4.50),
(60, 12, 'Apam Balik Durian', 'With durian filling', 6.00),
(61, 13, 'Cendol Biasa', 'Classic cendol', 3.50),
(62, 13, 'Cendol Durian', 'With durian pulp', 6.00),
(63, 13, 'Cendol Pulut', 'With glutinous rice', 4.50),
(64, 13, 'Cendol Kacang', 'With red beans', 4.00),
(65, 13, 'Cendol Special', 'All toppings included', 7.00),
(66, 14, 'Roti John Biasa', 'Classic egg & minced meat', 5.00),
(67, 14, 'Roti John Special', 'With chicken floss', 6.50),
(68, 14, 'Roti John Cheese', 'With melted cheese', 6.00),
(69, 14, 'Roti John Double', 'Extra meat portion', 7.00),
(70, 14, 'Roti John Sambal', 'With spicy sambal', 5.50),
(71, 15, 'Popia Basah Biasa', 'Classic fresh spring roll', 3.00),
(72, 15, 'Popia Basah Special', 'With extra ingredients', 4.00),
(73, 15, 'Popia Basah Udang', 'With prawn filling', 4.50),
(74, 15, 'Popia Basah Vegetarian', 'Vegetable only', 3.50),
(75, 15, 'Popia Goreng', 'Fried version', 4.00),
(76, 16, 'Ayam Percik (1 piece)', 'Grilled coconut chicken', 7.00),
(77, 16, 'Nasi Percik Set', 'With rice and ulam', 8.50),
(78, 16, 'Sambal Percik Extra', 'Extra coconut gravy', 2.00),
(79, 16, 'Ayam Bakar', 'Grilled chicken', 6.50),
(80, 16, 'Nasi Lemak Ayam Percik', 'With coconut rice', 9.00),
(81, 17, 'Kuih Lapis Pandan', 'Pandan flavored layers', 1.50),
(82, 17, 'Kuih Lapis Gula Melaka', 'Palm sugar flavor', 1.50),
(83, 17, 'Kuih Lapis Coklat', 'Chocolate layers', 1.80),
(84, 17, 'Kuih Lapis Special', 'Rainbow colored', 2.00),
(85, 17, 'Kuih Talam Pandan', 'Pandan custard cake', 1.50),
(86, 18, 'Kelapa Muda Biasa', 'Fresh young coconut', 4.00),
(87, 18, 'Kelapa Muda Special', 'With coconut flesh', 5.00),
(88, 18, 'Air Nira', 'Fresh palm juice', 3.50),
(89, 18, 'Kelapa Muda Campur', 'With jelly and syrup', 6.00),
(90, 18, 'Air Kelapa Pandan', 'With pandan flavor', 4.50),
(91, 19, 'Kebab Ayam', 'Chicken kebab wrap', 8.00),
(92, 19, 'Kebab Daging', 'Beef kebab wrap', 9.00),
(93, 19, 'Kebab Campur', 'Mixed meat kebab', 10.00),
(94, 19, 'Extra Sauce', 'Garlic or chili sauce', 1.50),
(95, 19, 'Kebab Plate', 'With fries and salad', 12.00),
(96, 20, 'Putu Bambu Biasa', 'Classic bamboo rice cake', 2.50),
(97, 20, 'Putu Bambu Gula Melaka', 'With palm sugar', 3.00),
(98, 20, 'Putu Bambu Pandan', 'Pandan flavored', 3.00),
(99, 20, 'Putu Bambu Cheese', 'With cheese filling', 4.00),
(100, 20, 'Putu Bambu Special', 'All flavors combo', 5.00);

-- --------------------------------------------------------

--
-- Table structure for table `rider`
--

CREATE TABLE `rider` (
  `Rider_ID` int(10) NOT NULL,
  `Rider_name` varchar(50) NOT NULL,
  `Rider_email` varchar(50) NOT NULL,
  `Rider_password` varchar(50) NOT NULL,
  `Rider_phone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rider`
--

INSERT INTO `rider` (`Rider_ID`, `Rider_name`, `Rider_email`, `Rider_password`, `Rider_phone`) VALUES
(1, 'Ali bin Abu', 'ali.rider@gmail.com', 'ali123', '0123456701'),
(2, 'Rajesh a/l Kumar', 'rajesh.rider@gmail.com', 'raj456', '0112345602'),
(3, 'Chen Wei Loong', 'chen.rider@gmail.com', 'che789', '0134567803'),
(4, 'Muthu a/p Samy', 'muthu.rider@gmail.com', 'mut101', '0145678904'),
(5, 'Fatimah binti Omar', 'fatimah.rider@gmail.com', 'fat112', '0167890105'),
(6, 'Kumar a/l Maniam', 'kumar.rider@gmail.com', 'kum131', '0178901206'),
(7, 'Lee Sin Yee', 'lee.rider@gmail.com', 'lee415', '0189012307'),
(8, 'Ahmad Faisal', 'ahmad.rider@gmail.com', 'ahm617', '0190123408'),
(9, 'Siti Aisyah', 'siti.rider@gmail.com', 'sit819', '0101234509'),
(10, 'Tan Kok Wai', 'tan.rider@gmail.com', 'tan949', '0119876510');

-- --------------------------------------------------------

--
-- Table structure for table `vendor`
--

CREATE TABLE `vendor` (
  `Vend_ID` int(10) NOT NULL,
  `Vend_name` varchar(100) NOT NULL,
  `Vend_email` varchar(50) NOT NULL,
  `Vend_password` varchar(50) NOT NULL,
  `Vend_phone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vendor`
--

INSERT INTO `vendor` (`Vend_ID`, `Vend_name`, `Vend_email`, `Vend_password`, `Vend_phone`) VALUES
(1, 'Aroma Wangi', 'aromawangi.perfume@gmail.com', 'wangipassword123', '01123456789'),
(2, 'Sate Kajang Asli', 'satekajang.asli@gmail.com', 'satepassword456', '01234567890'),
(3, 'Teh Tarik Legend', 'tehtarik.legend@gmail.com', 'tehpassword789', '01345678901'),
(4, 'Kuih Mak Wan', 'kuih.makwan@gmail.com', 'kuihpassword101', '01456789012'),
(5, 'Rempah Dapur', 'rempah.dapur@gmail.com', 'rempahpassword112', '01567890123'),
(6, 'Air Sirap Bandung', 'airsirap.bandung@gmail.com', 'airpassword131', '01678901234'),
(7, 'Cucur Udang Pak Ali', 'cucur.pakali@gmail.com', 'cucurpassword415', '01789012345'),
(8, 'Kacang Putih Abang', 'kacangputih.abang@gmail.com', 'kacangpassword617', '01890123456'),
(9, 'Rojak Buah Mak Cik', 'rojakbuah.makcik@gmail.com', 'rojakpassword819', '01901234567'),
(10, 'Pisang Goreng Madu', 'pisanggoreng.madu@gmail.com', 'pisangpassword920', '01012345678'),
(11, 'Keropok Lekor Special', 'keropok.lekor@gmail.com', 'keropok123', '01198765432'),
(12, 'Apam Balik Abang', 'apam.balik@gmail.com', 'apampassword', '01287654321'),
(13, 'Cendol Durian', 'cendol.durian@gmail.com', 'cendolpass', '01376543210'),
(14, 'Roti John Original', 'rotijohn.original@gmail.com', 'rotipassword', '01465432109'),
(15, 'Popia Basah Mak Su', 'popia.basah@gmail.com', 'popiapass123', '01554321098'),
(16, 'Ayam Percik Pak Din', 'ayam.percik@gmail.com', 'ayampass456', '01643210987'),
(17, 'Kuih Lapis Nyonya', 'kuihlapis.nyonya@gmail.com', 'nyonyapass', '01732109876'),
(18, 'Air Kelapa Muda', 'airkelapa.muda@gmail.com', 'kelapapass', '01821098765'),
(19, 'Kebab Turki Halal', 'kebab.turki@gmail.com', 'kebabpass', '01910987654'),
(20, 'Putu Bambu Tradisional', 'putu.bambu@gmail.com', 'putupass123', '01098765432');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`Cart_ID`),
  ADD KEY `cart_cust` (`Cust_ID`),
  ADD KEY `cart_prod` (`Prod_ID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`Cust_ID`),
  ADD UNIQUE KEY `Cust_email` (`Cust_email`);

--
-- Indexes for table `cust_order`
--
ALTER TABLE `cust_order`
  ADD PRIMARY KEY (`Order_ID`),
  ADD KEY `order_customer` (`Cust_ID`);

--
-- Indexes for table `delivery`
--
ALTER TABLE `delivery`
  ADD PRIMARY KEY (`Delivery_ID`),
  ADD KEY `delivery_order` (`Order_ID`),
  ADD KEY `delivery_rider` (`Rider_ID`);

--
-- Indexes for table `order_item`
--
ALTER TABLE `order_item`
  ADD PRIMARY KEY (`Order_item_ID`),
  ADD KEY `order_item_order` (`Order_ID`),
  ADD KEY `order_item_prod` (`Product_ID`),
  ADD KEY `order_item_vend` (`Vend_ID`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`Prod_ID`),
  ADD KEY `prod_vend` (`Vend_ID`);

--
-- Indexes for table `rider`
--
ALTER TABLE `rider`
  ADD PRIMARY KEY (`Rider_ID`),
  ADD UNIQUE KEY `Rider_email` (`Rider_email`);

--
-- Indexes for table `vendor`
--
ALTER TABLE `vendor`
  ADD PRIMARY KEY (`Vend_ID`),
  ADD UNIQUE KEY `Vend_email` (`Vend_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `Cart_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `Cust_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `cust_order`
--
ALTER TABLE `cust_order`
  MODIFY `Order_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `delivery`
--
ALTER TABLE `delivery`
  MODIFY `Delivery_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `order_item`
--
ALTER TABLE `order_item`
  MODIFY `Order_item_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `Prod_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `rider`
--
ALTER TABLE `rider`
  MODIFY `Rider_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `vendor`
--
ALTER TABLE `vendor`
  MODIFY `Vend_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_cust` FOREIGN KEY (`Cust_ID`) REFERENCES `customer` (`Cust_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cart_prod` FOREIGN KEY (`Prod_ID`) REFERENCES `products` (`Prod_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cust_order`
--
ALTER TABLE `cust_order`
  ADD CONSTRAINT `order_customer` FOREIGN KEY (`Cust_ID`) REFERENCES `customer` (`Cust_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `delivery`
--
ALTER TABLE `delivery`
  ADD CONSTRAINT `delivery_order` FOREIGN KEY (`Order_ID`) REFERENCES `cust_order` (`Order_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `delivery_rider` FOREIGN KEY (`Rider_ID`) REFERENCES `rider` (`Rider_ID`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `order_item`
--
ALTER TABLE `order_item`
  ADD CONSTRAINT `order_item_order` FOREIGN KEY (`Order_ID`) REFERENCES `cust_order` (`Order_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_item_prod` FOREIGN KEY (`Product_ID`) REFERENCES `products` (`Prod_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_item_vend` FOREIGN KEY (`Vend_ID`) REFERENCES `vendor` (`Vend_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `prod_vend` FOREIGN KEY (`Vend_ID`) REFERENCES `vendor` (`Vend_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
