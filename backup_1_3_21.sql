USE [master]
GO

/****** Object:  Database [clictell_auto_etl]    Script Date: 3/1/2021 7:24:42 PM ******/
CREATE DATABASE [clictell_auto_etl]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'clictell_auto_etl', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\clictell_auto_etl.mdf' , SIZE = 204800KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'clictell_auto_etl_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\clictell_auto_etl_log.ldf' , SIZE = 1253376KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [clictell_auto_etl].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [clictell_auto_etl] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET ARITHABORT OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [clictell_auto_etl] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [clictell_auto_etl] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET  DISABLE_BROKER 
GO

ALTER DATABASE [clictell_auto_etl] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [clictell_auto_etl] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET RECOVERY FULL 
GO

ALTER DATABASE [clictell_auto_etl] SET  MULTI_USER 
GO

ALTER DATABASE [clictell_auto_etl] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [clictell_auto_etl] SET DB_CHAINING OFF 
GO

ALTER DATABASE [clictell_auto_etl] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [clictell_auto_etl] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [clictell_auto_etl] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [clictell_auto_etl] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [clictell_auto_etl] SET QUERY_STORE = OFF
GO

ALTER DATABASE [clictell_auto_etl] SET  READ_WRITE 
GO

