USE [master]
GO

/****** Object:  Database [clictell_auto_master]    Script Date: 3/1/2021 7:25:46 PM ******/
CREATE DATABASE [clictell_auto_master]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'clictell_auto_master', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\clictell_auto_master.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'clictell_auto_master_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\clictell_auto_master_log.ldf' , SIZE = 204800KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [clictell_auto_master].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [clictell_auto_master] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [clictell_auto_master] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [clictell_auto_master] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [clictell_auto_master] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [clictell_auto_master] SET ARITHABORT OFF 
GO

ALTER DATABASE [clictell_auto_master] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [clictell_auto_master] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [clictell_auto_master] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [clictell_auto_master] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [clictell_auto_master] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [clictell_auto_master] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [clictell_auto_master] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [clictell_auto_master] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [clictell_auto_master] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [clictell_auto_master] SET  DISABLE_BROKER 
GO

ALTER DATABASE [clictell_auto_master] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [clictell_auto_master] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [clictell_auto_master] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [clictell_auto_master] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [clictell_auto_master] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [clictell_auto_master] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [clictell_auto_master] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [clictell_auto_master] SET RECOVERY FULL 
GO

ALTER DATABASE [clictell_auto_master] SET  MULTI_USER 
GO

ALTER DATABASE [clictell_auto_master] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [clictell_auto_master] SET DB_CHAINING OFF 
GO

ALTER DATABASE [clictell_auto_master] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [clictell_auto_master] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [clictell_auto_master] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [clictell_auto_master] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [clictell_auto_master] SET QUERY_STORE = OFF
GO

ALTER DATABASE [clictell_auto_master] SET  READ_WRITE 
GO

