USE [master]
GO

/****** Object:  Database [clictell_auto_stg]    Script Date: 3/1/2021 7:25:18 PM ******/
CREATE DATABASE [clictell_auto_stg]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'clictell_auto_stg', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\clictell_auto_stg.mdf' , SIZE = 466944KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'clictell_auto_stg_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\clictell_auto_stg_log.ldf' , SIZE = 1318912KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [clictell_auto_stg].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [clictell_auto_stg] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET ARITHABORT OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [clictell_auto_stg] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [clictell_auto_stg] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET  DISABLE_BROKER 
GO

ALTER DATABASE [clictell_auto_stg] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [clictell_auto_stg] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET RECOVERY FULL 
GO

ALTER DATABASE [clictell_auto_stg] SET  MULTI_USER 
GO

ALTER DATABASE [clictell_auto_stg] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [clictell_auto_stg] SET DB_CHAINING OFF 
GO

ALTER DATABASE [clictell_auto_stg] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [clictell_auto_stg] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [clictell_auto_stg] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [clictell_auto_stg] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [clictell_auto_stg] SET QUERY_STORE = OFF
GO

ALTER DATABASE [clictell_auto_stg] SET  READ_WRITE 
GO

