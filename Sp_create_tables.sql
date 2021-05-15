create or alter procedure sp_create_tables as
BEGIN
declare @count_loop int
declare @count_check int
declare @Country_Name varchar(10)
declare @sql_create nvarchar(max)
set @count_loop=0
set @count_check=(select count(distinct COUNTRY) from CUSTOMERS_WORLD)
set @sql_create=''

	BEGIN
	DECLARE COUNTRY CURSOR FOR SELECT distinct COUNTRY FROM  CUSTOMERS_WORLD
	OPEN COUNTRY;
	FETCH NEXT FROM COUNTRY INTO @Country_Name
	WHILE @@FETCH_STATUS =0
		BEGIN
		IF NOT EXISTS   (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='CUSTOMERS_'+@Country_Name) 
			BEGIN 
			print @Country_Name
			set @sql_create= 'create table  CUSTOMERS_'+@Country_Name +'([Name] VARCHAR(15),CUST_I INT,Open_Dt int,Consult_Dt int,VAC_ID Varchar(4),DR_Name varchar(15),State varchar(4),DOB int,Flag varchar(2))'
			exec sp_executesql  @sql_create
			FETCH NEXT FROM COUNTRY INTO @Country_Name
			end
			if @count_loop>@count_check
				begin
				break;
				end
			set @count_loop=@count_loop+1
			END
	END
	CLOSE COUNTRY
	DEALLOCATE COUNTRY;
END

CREATE TABLE [dbo].[CUSTOMERS_WORLD](
	[Name] [varchar](15) PRIMARY KEY,
	[CUST_I] [varchar](10) NOT NULL,
	[Open_Dt] [int] NOT NULL,
	[Consult_Dt] [int] NULL,
	[VAC_ID] [varchar](4) NULL,
	[DR_Name] [varchar](15) NULL,
	[State] [varchar](4) NULL,
	[Country] [varchar](4) NULL,
	[DOB] [int] NULL,
	[Flag] [varchar](2) NULL
)

SELECT * FROM [CUSTOMERS_WORLD]