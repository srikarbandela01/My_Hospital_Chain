CREATE OR ALTER   procedure [dbo].[sp_insert] as
BEGIN
declare @count_loop int
declare @count_check int
declare @Country_Name varchar(10)
declare @sql_insert nvarchar(max)
declare @sql_truncate nvarchar(max)
set @count_loop=0
set @count_check=(select count(distinct COUNTRY) from CUSTOMERS_WORLD)
set @sql_insert=''
	BEGIN
	DECLARE COUNTRY CURSOR FOR SELECT distinct COUNTRY FROM  CUSTOMERS_WORLD
	OPEN COUNTRY;
	FETCH NEXT FROM COUNTRY INTO @Country_Name
	WHILE @@FETCH_STATUS =0
		BEGIN
		IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='CUSTOMERS_'+@Country_Name) 
			BEGIN 
			print @Country_Name
			set @sql_insert= 'insert into CUSTOMERS_'+@Country_Name +'([Name],CUST_I ,Open_Dt ,Consult_Dt ,VAC_ID ,DR_Name ,State ,DOB ,Flag)'
			set @sql_insert	= @sql_insert+'select [Name],CUST_I ,Open_Dt ,Consult_Dt ,VAC_ID ,DR_Name ,State ,DOB ,Flag from CUSTOMERS_WORLD WHERE COUNTRY='+''''+@Country_Name+''''
			set @sql_truncate='Truncate table CUSTOMERS_'+@Country_Name
			exec sp_executesql @sql_truncate
			exec sp_executesql  @sql_insert
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

-------------------------------------EXEC [sp_insert]