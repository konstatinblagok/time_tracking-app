-- phpMyAdmin SQL Dump
-- version 4.9.7
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 02, 2021 at 08:25 AM
-- Server version: 10.3.31-MariaDB-log-cll-lve
-- PHP Version: 7.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `insycmei_time_tracking`
--

-- --------------------------------------------------------

--
-- Table structure for table `checkouts`
--

CREATE TABLE `checkouts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `_cvc` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expiryMonth` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `_last4Digits` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expiryYear` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `method` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verify` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `tracking_codes` double DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2016_06_01_000001_create_oauth_auth_codes_table', 1),
(4, '2016_06_01_000002_create_oauth_access_tokens_table', 1),
(5, '2016_06_01_000003_create_oauth_refresh_tokens_table', 1),
(6, '2016_06_01_000004_create_oauth_clients_table', 1),
(7, '2016_06_01_000005_create_oauth_personal_access_clients_table', 1),
(8, '2019_08_19_000000_create_failed_jobs_table', 1),
(9, '2021_06_07_173959_create_shipping_details_table', 1),
(10, '2021_06_15_034520_create_payments_table', 1),
(11, '2021_06_19_152009_create_profiles_table', 1),
(12, '2021_06_25_075821_create_checkouts_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `oauth_access_tokens`
--

CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `oauth_access_tokens`
--

INSERT INTO `oauth_access_tokens` (`id`, `user_id`, `client_id`, `name`, `scopes`, `revoked`, `created_at`, `updated_at`, `expires_at`) VALUES
('27011ae5e60c5fc813fced6983e01b02fe50a6c891d36f8dd9f9fd2cbbebc966860fac8dc895678c', 49, 1, 'Laravel Password Grant Client', '[]', 0, '2021-08-31 12:01:16', '2021-08-31 12:01:16', '2022-08-31 08:01:16'),
('2e71b2dc2c40fe27ac1a320ff67115b0f3234cef14b691dea776e59f35451dcd55e5c0e0f1e20299', 46, 1, 'Laravel Password Grant Client', '[]', 1, '2021-08-31 12:34:44', '2021-08-31 12:34:44', '2022-08-31 08:34:44'),
('0f38dc7cdae504d0e2e84db53f7d19db7b8e198f3598a01d05742c39e86e72be91b344fde84a4c53', 46, 1, 'Laravel Password Grant Client', '[]', 1, '2021-08-31 12:56:07', '2021-08-31 12:56:07', '2022-08-31 08:56:07'),
('40e166553190ef6cddf71f72078f11e27e86ca9b9cf3a0245c85659438ebcecf570182b136e7b407', 53, 1, 'Laravel Password Grant Client', '[]', 0, '2021-08-31 13:09:02', '2021-08-31 13:09:02', '2022-08-31 09:09:02'),
('5f7a707d00719307ff689cedf90e0ba91af48e6ddeea8b7a3b251bfc705cd6d846562e825a8aedd3', 51, 1, 'Laravel Password Grant Client', '[]', 0, '2021-08-31 13:23:30', '2021-08-31 13:23:30', '2022-08-31 09:23:30'),
('d7f7361db3be4728a682f62ee307ffb8009cd0cbf52448783ec6e6c49a006146d438eefad05d40cc', 4, 1, 'Laravel Password Grant Client', '[]', 1, '2021-08-31 16:40:20', '2021-08-31 16:40:20', '2022-08-31 12:40:20'),
('f6a33785597e7aa08007454d3c63239f1589e27a316028587bf684598565510b6abe69b544ec2b27', 55, 1, 'Laravel Password Grant Client', '[]', 1, '2021-08-31 20:04:08', '2021-08-31 20:04:08', '2022-08-31 16:04:08'),
('b7c63451900e16f14ee38254fccbf00685abe4bd6e84af64155a392652241bb3aa49d90bf05e0a35', 4, 1, 'Laravel Password Grant Client', '[]', 0, '2021-08-31 20:47:18', '2021-08-31 20:47:18', '2022-08-31 16:47:18'),
('e232d295bf47a289e46b8aac461b2138e088b7b9534e0471e9b4042148bead993ffceb1b83d2fcfc', 56, 1, 'Laravel Password Grant Client', '[]', 1, '2021-09-01 14:44:16', '2021-09-01 14:44:16', '2022-09-01 10:44:16'),
('803e12c722233c142b498a6aba989631298253332f37840ef5aa91e892cfe8848969fce73de58906', 58, 1, 'Laravel Password Grant Client', '[]', 1, '2021-09-01 15:55:19', '2021-09-01 15:55:19', '2022-09-01 11:55:19'),
('230f3668e0d22cdacb4fd34f197f0e31a4ee28c175b6131fa75d51de00dd697e1e21643009afd0ad', 56, 1, 'Laravel Password Grant Client', '[]', 1, '2021-09-01 16:22:29', '2021-09-01 16:22:29', '2022-09-01 12:22:29'),
('f24d735858406109bd545a213850abcf7f9bb738092576f904d076e48a413f3212064a61f1a033af', 56, 1, 'Laravel Password Grant Client', '[]', 1, '2021-09-02 08:49:08', '2021-09-02 08:49:08', '2022-09-02 04:49:08'),
('6489e929b16a005e9effce3efc443fa04a1e780275681a3cf238a5661eb98412f92448c6c7857798', 56, 1, 'Laravel Password Grant Client', '[]', 1, '2021-09-02 09:51:36', '2021-09-02 09:51:36', '2022-09-02 05:51:36'),
('68a8f63e8089e4b092217e67d065ae6ceaaf1872a6d73adc9710edf9cf4c8f17e84477c120f5a9b9', 4, 1, 'Laravel Password Grant Client', '[]', 0, '2021-09-02 13:31:27', '2021-09-02 13:31:27', '2022-09-02 09:31:27'),
('dfaed6397df1e854ddc23a2e63dd1435e54d1dfe9d3a35ce749343a0bca114d1160847be9012541b', 60, 1, 'Laravel Password Grant Client', '[]', 0, '2021-09-02 15:01:06', '2021-09-02 15:01:06', '2022-09-02 11:01:06'),
('c3a85ca85228bbd65feec0e9c26dce4c06ae11c3b959aebecfd88286bff155e1b2d688ca3f34538c', 60, 1, 'Laravel Password Grant Client', '[]', 0, '2021-09-02 15:01:23', '2021-09-02 15:01:23', '2022-09-02 11:01:23'),
('bf7df4d7027edb412d5063912cddd283c2d655fc2803225c04e1ada2be8e39b938df9e4850147c35', 56, 1, 'Laravel Password Grant Client', '[]', 0, '2021-09-02 15:11:45', '2021-09-02 15:11:45', '2022-09-02 11:11:45'),
('038812b4f16351f323a786a9048bb29a364eb15918b034d590dc96a441a4f9acfb1571d6a9651e95', 56, 1, 'Laravel Password Grant Client', '[]', 0, '2021-09-02 15:12:04', '2021-09-02 15:12:04', '2022-09-02 11:12:04');

-- --------------------------------------------------------

--
-- Table structure for table `oauth_auth_codes`
--

CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_clients`
--

CREATE TABLE `oauth_clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `redirect` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `oauth_clients`
--

INSERT INTO `oauth_clients` (`id`, `user_id`, `name`, `secret`, `provider`, `redirect`, `personal_access_client`, `password_client`, `revoked`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Laravel Password Grant Client', 'RjVSGfcQpZ2H0FoM6Yv6G2krzC8U3ciwmSJ63Tcy', NULL, 'http://localhost', 1, 0, 0, '2021-08-31 12:01:04', '2021-08-31 12:01:04');

-- --------------------------------------------------------

--
-- Table structure for table `oauth_personal_access_clients`
--

CREATE TABLE `oauth_personal_access_clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `oauth_personal_access_clients`
--

INSERT INTO `oauth_personal_access_clients` (`id`, `client_id`, `created_at`, `updated_at`) VALUES
(1, 1, '2021-08-31 12:01:04', '2021-08-31 12:01:04');

-- --------------------------------------------------------

--
-- Table structure for table `oauth_refresh_tokens`
--

CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `card_no` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiry_month` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiry_year` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cvv` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `user_id`, `card_no`, `expiry_month`, `expiry_year`, `cvv`, `created_at`, `updated_at`) VALUES
(10, 56, '5683 8', '22', '22', '6835', '2021-09-02 15:16:02', '2021-09-02 15:16:02'),
(2, 55, '4685 8811 0734 1874', '8', '24', '933', '2021-08-31 20:06:33', '2021-08-31 20:32:43');

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `card_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shipping_details`
--

CREATE TABLE `shipping_details` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `receiver_id` int(11) DEFAULT NULL,
  `receiver_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tracking_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ETA` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tracking_codes` int(11) DEFAULT NULL,
  `otp_verified` tinyint(1) DEFAULT NULL,
  `is_notification` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notification_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payasyougo` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `phone_number`, `location`, `avatar`, `avatar_name`, `tracking_codes`, `otp_verified`, `is_notification`, `email_verified_at`, `password`, `notification_token`, `payasyougo`, `is_admin`, `remember_token`, `otp`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '$2y$10$A6jmyOs4qCHh9wGMuFI4c.Tc/BrbmYLgib7./zUcclI5mrFiwezoC', NULL, NULL, 1, NULL, NULL, '2021-08-26 11:25:28', '2021-08-26 11:25:28'),
(4, 'Test User10', 'myhometreat@gmail.com', '+2349061438083', 'Lagos', NULL, 'image_picker2041134336.jpg', NULL, NULL, 'true', NULL, '$2y$10$0e9JX/hQ2UOhPY8lytbtZ.pCMSOmYRvNHuIQtv2CGblMZVYLtGVZe', 'cKw3guW5SZa_Js2mCYYlU3:APA91bEduiFePxOqq2f0JhagSBREM_W9r5GSuvix8etJIb_E7JWaVu0DAy1uaC3UlklmVUC32gBlaed2IuVmNo_b2-ZplH3B0fgFJhw3oCVa4cXoP8aLjzS-NN0kq12E5GtsQjnZ5dO4', NULL, NULL, NULL, NULL, '2021-08-27 11:35:25', '2021-08-31 20:56:28'),
(5, 'Test User11', 'toffabibi25@gmail.com', '+2348027223732', 'Lagos', NULL, NULL, NULL, NULL, 'false', NULL, '$2y$10$15Xo6ITZ5J5OsEtkJfxOz.eB7ngy/5JqiJj9qVL.G1yf/tfBRckJ.', 'cKw3guW5SZa_Js2mCYYlU3:APA91bEduiFePxOqq2f0JhagSBREM_W9r5GSuvix8etJIb_E7JWaVu0DAy1uaC3UlklmVUC32gBlaed2IuVmNo_b2-ZplH3B0fgFJhw3oCVa4cXoP8aLjzS-NN0kq12E5GtsQjnZ5dO4', NULL, NULL, NULL, NULL, '2021-08-27 11:39:50', '2021-08-27 11:39:50'),
(54, 'test user12', 'Outver.app@gmail.com', '08053517434', 'Lagos', NULL, NULL, NULL, NULL, 'false', NULL, '$2y$10$EV4ZlyfXVg0VioX7HtfPPOh5HHFh4A7JrL3.OfgV.K6SyJWg4mpKW', 'dZBtU5nXQVe0EZtKO0pWqj:APA91bGa9MNMMwP_V3vhzrYxVD-oPRbnpbApEEqco-5CxebFhowDiW3P0cSHljtjpeZMitpKSPFNy4BU8li8OUBQermcM5MKez9-3zhw8TqfGMVXrSUz8CupjckrjZGv6VrA5RMYTiMM', NULL, NULL, NULL, NULL, '2021-08-31 19:47:50', '2021-08-31 19:47:50');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `checkouts`
--
ALTER TABLE `checkouts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `checkouts__cvc_unique` (`_cvc`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `oauth_access_tokens`
--
ALTER TABLE `oauth_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_access_tokens_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_auth_codes`
--
ALTER TABLE `oauth_auth_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_auth_codes_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_clients_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `oauth_refresh_tokens`
--
ALTER TABLE `oauth_refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `profiles_email_unique` (`email`),
  ADD UNIQUE KEY `profiles_password_unique` (`password`);

--
-- Indexes for table `shipping_details`
--
ALTER TABLE `shipping_details`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `shipping_details_tracking_id_unique` (`tracking_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_phone_number_unique` (`phone_number`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `checkouts`
--
ALTER TABLE `checkouts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `profiles`
--
ALTER TABLE `profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shipping_details`
--
ALTER TABLE `shipping_details`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
