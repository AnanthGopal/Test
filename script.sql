USE [HMS]
GO
/****** Object:  StoredProcedure [dbo].[AH_AH_READER_BUSINESS]    Script Date: 05-11-2017 13:04:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[AH_AH_READER_BUSINESS] 
(
@P_PROC_NAME VARCHAR(100)
)
AS
BEGIN
declare @TableName sysname = @P_PROC_NAME;
declare @Result varchar(max) = ''
select @Result = @Result +
'public async Task<IList<T>> Post<T>(string objConnString, PatientSearchRequest request)
        {
            SqlParameter[] objCmdParameters =
               {'
			    + t3.t2  +
				'};
            return await iRepository.FunForExecuteDataReaderMapToList<T>(
            objConString: objConnString,
            objProcName: ProcedureName.AH_GET_PATIENT.ToString(),
            objCmdParameters: objCmdParameters);
        }'
from
(
	SELECT STUFF((
    SELECT CHAR(13)+CHAR(10)  +char(9) + char(9) + char(9)+char(9)+char(9)+ Value
    FROM(Select 'new SqlParameter("'+ 
			REPLACE(col.PARAMETER_NAME,'@','')+'", request.'+ 
			REPLACE(col.PARAMETER_NAME,'@','')+'),'  as Value
	from information_schema.parameters col 
    where specific_name = @TableName) t 
	FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
	t2
) t3

PRINT @Result;
END;



GO
/****** Object:  StoredProcedure [dbo].[AH_AH_READER_PROC]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AH_AH_READER_PROC] 
(
@P_TABLE_NAME VARCHAR(100),
@P_CLASS_NAME VARCHAR(100)

)
AS
BEGIN
 declare @P_FILENAME VARCHAR(100)='C:\';
declare @P_NAMESPACE varchar(100)='Hms.CommonLayer.Model';
declare @TableName sysname = @P_TABLE_NAME;
declare @Result varchar(max) = '
// ------------------------------------------------------------------------------//
// <copyright file="'+@P_CLASS_NAME+'.cs" company="Enterprises">
// Copyright (c) Enterprises. All rights reserved.
// </copyright>
// <author>AnantH.g</author>
// ------------------------------------------------------------------------------//
namespace '+@P_NAMESPACE+'
{
/// <summary>
/// initialize class '+@P_CLASS_NAME+'
/// </summary>
public class ' + @P_CLASS_NAME + '
{'


select @Result = @Result +
(CASE WHEN ColumnType='bool' then '
	/// <summary>
	/// Gets or sets a value indicating whether the item is '+ColumnName+'.  
	/// </summary>
	/// <value> Name Value. </value>
'
else '
	/// <summary>
	/// Gets or sets the value for '+ColumnName+'.
	/// </summary>
	/// <value> Name Value. </value>
'end)+
'	public ' + ColumnType  + ' ' + ColumnName + ' { get; set; }
'
from
(
    select 
        replace((col.PARAMETER_NAME), '@', '') ColumnName,
		col.ORDINAL_POSITION,
        case LOWER( COL.DATA_TYPE )
            when 'bigint' then 'long'
            when 'binary' then 'byte[]'
            when 'bit' then 'bool'
            when 'char' then 'string'
            when 'date' then 'DateTime'
            when 'datetime' then 'DateTime'
            when 'datetime2' then 'DateTime'
            when 'datetimeoffset' then 'DateTimeOffset'
            when 'decimal' then 'decimal'
            when 'float' then 'float'
            when 'image' then 'byte[]'
            when 'int' then 'int'
            when 'money' then 'decimal'
            when 'nchar' then 'string'
            when 'ntext' then 'string'
            when 'numeric' then 'decimal'
            when 'nvarchar' then 'string'
            when 'real' then 'double'
            when 'smalldatetime' then 'DateTime'
            when 'smallint' then 'short'
            when 'smallmoney' then 'decimal'
            when 'text' then 'string'
            when 'time' then 'TimeSpan'
            when 'timestamp' then 'DateTime'
            when 'tinyint' then 'byte'
            when 'uniqueidentifier' then 'Guid'
            when 'varbinary' then 'byte[]'
            when 'varchar' then 'string'
            else 'UNKNOWN_' + col.DATA_TYPE
        end ColumnType
         from information_schema.parameters col
        where specific_name = @TableName
) t


set @Result = @Result  + '
}'+
'}'
PRINT @Result;
END;


GO
/****** Object:  StoredProcedure [dbo].[AH_AH_READER_TABLE]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC AH_AH_READER_TABLE 'Patient','Patient'
CREATE PROCEDURE [dbo].[AH_AH_READER_TABLE] 
(
@P_TABLE_NAME VARCHAR(100),
@P_CLASS_NAME VARCHAR(100)
)
AS
BEGIN
declare @P_FILENAME VARCHAR(100)='C:\';
declare @P_NAMESPACE varchar(100)='Hms.CommonLayer.Model';
declare @TableName sysname = @P_TABLE_NAME;
declare @Result varchar(max) = '
// ------------------------------------------------------------------------------//
// <copyright file="'+@P_CLASS_NAME+'.cs" company="anantH Enterprises">
// Copyright (c) anantH Enterprises. All rights reserved.
// </copyright>
// <author>AnantH.g</author>
// ------------------------------------------------------------------------------//
namespace '+@P_NAMESPACE+'
{
using System;

/// <summary>
/// initialize class '+@P_CLASS_NAME+'
/// </summary>
public class ' + @P_CLASS_NAME + '
{'

select @Result = @Result +
(CASE WHEN ColumnType='bool' then '
	/// <summary>
	/// Gets or sets a value indicating whether the item is '+ColumnName+'.  
	/// </summary>
	/// <value> The Value. </value>
'
else '
	/// <summary>
	/// Gets or sets the value for '+ColumnName+'.
	/// </summary>
	/// <value> The Value. </value>
'end)+
'	public ' + ColumnType + NullableSign + ' ' + ColumnName + ' { get; set; }
'
from
(
    select 
        replace((col.name), ' ', '_') ColumnName,
        column_id ColumnId,
        case typ.name 
            when 'bigint' then 'long'
            when 'binary' then 'byte[]'
            when 'bit' then 'bool'
            when 'char' then 'string'
            when 'date' then 'DateTime'
            when 'datetime' then 'DateTime'
            when 'datetime2' then 'DateTime'
            when 'datetimeoffset' then 'DateTimeOffset'
            when 'decimal' then 'decimal'
            when 'float' then 'float'
            when 'image' then 'byte[]'
            when 'int' then 'int'
            when 'money' then 'decimal'
            when 'nchar' then 'string'
            when 'ntext' then 'string'
            when 'numeric' then 'decimal'
            when 'nvarchar' then 'string'
            when 'real' then 'double'
            when 'smalldatetime' then 'DateTime'
            when 'smallint' then 'short'
            when 'smallmoney' then 'decimal'
            when 'text' then 'string'
            when 'time' then 'TimeSpan'
            when 'timestamp' then 'DateTime'
            when 'tinyint' then 'byte'
            when 'uniqueidentifier' then 'Guid'
            when 'varbinary' then 'byte[]'
            when 'varchar' then 'string'
            else 'UNKNOWN_' + typ.name
        end ColumnType,
        case 
            when col.is_nullable =1 and typ.name in ('bigint', 'bit', 'date', 'datetime', 'datetime2', 'datetimeoffset', 'decimal', 'float', 'int', 'money', 'numeric', 'real', 'smalldatetime', 'smallint', 'smallmoney', 'time', 'tinyint', 'uniqueidentifier') 
            then '?' 
            else '' 
        end NullableSign
    from sys.columns col
        join sys.types typ on
            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
    where object_id = object_id(@TableName)
) t
order by ColumnId

set @Result = @Result  + '
}
}'
print  @Result;
END;


GO
/****** Object:  StoredProcedure [dbo].[AH_AH_READER_VIEWMODEL_GET_SET]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Exec AH_AH_READER_VIEWMODEL_GET_SET 'Patient'
CREATE PROCEDURE [dbo].[AH_AH_READER_VIEWMODEL_GET_SET] 
(
@P_TABLE_NAME VARCHAR(100)
)
AS
BEGIN
declare @TableName sysname = @P_TABLE_NAME;
declare @Result varchar(max) = ''
select @Result = @Result +
--(CASE WHEN ColumnType='bool' then '
--	/// <summary>
--	/// The '+ColumnName+'.  
--	/// </summary>
--'
--else '
--	/// <summary>
--	/// The '+ColumnName+'.
--	/// </summary>
--'end)+
'	private ' + ColumnType + NullableSign + ' ' + LOWER(LEFT(ColumnName,1))+(SUBSTRING(ColumnName,2,LEN(ColumnName))) + ';
'
from
(
    select 
        replace((col.name), ' ', '_') ColumnName,
        column_id ColumnId,
        case typ.name 
            when 'bigint' then 'long'
            when 'binary' then 'byte[]'
            when 'bit' then 'bool'
            when 'char' then 'string'
            when 'date' then 'DateTime'
            when 'datetime' then 'DateTime'
            when 'datetime2' then 'DateTime'
            when 'datetimeoffset' then 'DateTimeOffset'
            when 'decimal' then 'decimal'
            when 'float' then 'float'
            when 'image' then 'byte[]'
            when 'int' then 'int'
            when 'money' then 'decimal'
            when 'nchar' then 'string'
            when 'ntext' then 'string'
            when 'numeric' then 'decimal'
            when 'nvarchar' then 'string'
            when 'real' then 'double'
            when 'smalldatetime' then 'DateTime'
            when 'smallint' then 'short'
            when 'smallmoney' then 'decimal'
            when 'text' then 'string'
            when 'time' then 'TimeSpan'
            when 'timestamp' then 'DateTime'
            when 'tinyint' then 'byte'
            when 'uniqueidentifier' then 'Guid'
            when 'varbinary' then 'byte[]'
            when 'varchar' then 'string'
            else 'UNKNOWN_' + typ.name
        end ColumnType,
        case 
            when col.is_nullable = 1 and typ.name in ('bigint', 'bit', 'date', 'datetime', 'datetime2', 'datetimeoffset', 'decimal', 'float', 'int', 'money', 'numeric', 'real', 'smalldatetime', 'smallint', 'smallmoney', 'time', 'tinyint', 'uniqueidentifier') 
            then '?' 
            else '' 
        end NullableSign
    from sys.columns col
        join sys.types typ on
            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
    where object_id = object_id(@TableName)
) t
order by ColumnId;
select @Result = @Result +
--(CASE WHEN ColumnType='bool' then '
--	/// <summary>
--	/// Gets or sets a value indicating whether the item is '+ColumnName+'.  
--	/// </summary>
--	/// <value> The Value. </value>
--'
--else '/// <summary>
--      /// Gets or sets the '+ColumnName+'.
--      /// </summary>
--      /// <value>
--	  /// The Value.
--      /// </value>
--'end)
--+
'public ' + ColumnType + NullableSign + ' ' + ColumnName + 
'{get{return '+LOWER(LEFT(ColumnName,1))+(SUBSTRING(ColumnName,2,LEN(ColumnName)))+';}
set{if (value != '+LOWER(LEFT(ColumnName,1))+(SUBSTRING(ColumnName,2,LEN(ColumnName)))+')
{'+LOWER(LEFT(ColumnName,1))+(SUBSTRING(ColumnName,2,LEN(ColumnName)))+' = value;
OnPropertyChanged("' + ColumnName +'");}}}

'
from
(
    select 
        replace((col.name), ' ', '_') ColumnName,
        column_id ColumnId,
        case typ.name 
            when 'bigint' then 'long'
            when 'binary' then 'byte[]'
            when 'bit' then 'bool'
            when 'char' then 'string'
            when 'date' then 'DateTime'
            when 'datetime' then 'DateTime'
            when 'datetime2' then 'DateTime'
            when 'datetimeoffset' then 'DateTimeOffset'
            when 'decimal' then 'decimal'
            when 'float' then 'float'
            when 'image' then 'byte[]'
            when 'int' then 'int'
            when 'money' then 'decimal'
            when 'nchar' then 'string'
            when 'ntext' then 'string'
            when 'numeric' then 'decimal'
            when 'nvarchar' then 'string'
            when 'real' then 'double'
            when 'smalldatetime' then 'DateTime'
            when 'smallint' then 'short'
            when 'smallmoney' then 'decimal'
            when 'text' then 'string'
            when 'time' then 'TimeSpan'
            when 'timestamp' then 'DateTime'
            when 'tinyint' then 'byte'
            when 'uniqueidentifier' then 'Guid'
            when 'varbinary' then 'byte[]'
            when 'varchar' then 'string'
            else 'UNKNOWN_' + typ.name
        end ColumnType,
        case 
            when col.is_nullable = 1 and typ.name in ('bigint', 'bit', 'date', 'datetime', 'datetime2', 'datetimeoffset', 'decimal', 'float', 'int', 'money', 'numeric', 'real', 'smalldatetime', 'smallint', 'smallmoney', 'time', 'tinyint', 'uniqueidentifier') 
            then '?' 
            else '' 
        end NullableSign
    from sys.columns col
        join sys.types typ on
            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
    where object_id = object_id(@TableName)
) t
order by ColumnId

set @Result = @Result  
select  @Result;
END;


GO
/****** Object:  StoredProcedure [dbo].[AH_GET_DRUG]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[AH_GET_DRUG]
(
	@key varchar(10),
	@FromDate DATETIME=NULL,
	@ToDate DATETIME=NULL,
	@Id bigint=NULL,
	@Name varchar(100)=NULL
)
AS
	BEGIN
		if @key='Id'
			BEGIN
				SELECT
						DrugID,
						ClientID,
						YearCode,
						DrugTypeID,
						GenericID,
						ManufacturerID,
						DrugName,
						ReOrderLevel,
						Location,
						Scheduled,
						Description,
						Activeflag,
						CreatedBy,
						CreatedDate,
						ModifiedBy,
						ModifiedDate	
				FROM Drug  WHERE  DrugID = @Id order by DrugID desc;
			END;
		ELSE IF @key ='ALL'
			BEGIN
				SELECT
						DrugID,
						ClientID,
						YearCode,
						DrugTypeID,
						GenericID,
						ManufacturerID,
						DrugName,
						ReOrderLevel,
						Location,
						Scheduled,
						Description,
						Activeflag,
						CreatedBy,
						CreatedDate,
						ModifiedBy,
						ModifiedDate		
				FROM Drug WHERE DrugID = @Id and  DrugName like '%' +@Name+'%'
				AND ( CONVERT(datetime,( CONVERT(VARCHAR(10),
				 (CONVERT(DATETIME,CreatedDate,103)),103)),103) 
				 BETWEEN (CONVERT(DATETIME,@FromDate,103))  
				 AND (CONVERT(DATETIME,@ToDate,103))) order by DrugID desc;
			END;			
		ELSE IF @key ='DateWithName'
			BEGIN
				SELECT
						DrugID,
						ClientID,
						YearCode,
						DrugTypeID,
						GenericID,
						ManufacturerID,
						DrugName,
						ReOrderLevel,
						Location,
						Scheduled,
						Description,
						Activeflag,
						CreatedBy,
						CreatedDate,
						ModifiedBy,
						ModifiedDate		
				FROM Drug WHERE  DrugName like '%' +@Name+'%'
				AND ( CONVERT(datetime,( CONVERT(VARCHAR(10),
				 (CONVERT(DATETIME,CreatedDate,103)),103)),103) 
				 BETWEEN (CONVERT(DATETIME,@FromDate,103))  
				 AND (CONVERT(DATETIME,@ToDate,103))) order by DrugID desc;
			END;	
		ELSE IF @key ='DateWithId'
			BEGIN
				SELECT
						DrugID,
						ClientID,
						YearCode,
						DrugTypeID,
						GenericID,
						ManufacturerID,
						DrugName,
						ReOrderLevel,
						Location,
						Scheduled,
						Description,
						Activeflag,
						CreatedBy,
						CreatedDate,
						ModifiedBy,
						ModifiedDate		
				FROM Drug WHERE DrugID = @Id and ( CONVERT(datetime,( CONVERT(VARCHAR(10),
				 (CONVERT(DATETIME,CreatedDate,103)),103)),103) 
				 BETWEEN (CONVERT(DATETIME,@FromDate,103))  
				 AND (CONVERT(DATETIME,@ToDate,103))) order by DrugID desc;
			END;			
		ELSE IF @key ='NameWithId'
			BEGIN
				SELECT
						DrugID,
						ClientID,
						YearCode,
						DrugTypeID,
						GenericID,
						ManufacturerID,
						DrugName,
						ReOrderLevel,
						Location,
						Scheduled,
						Description,
						Activeflag,
						CreatedBy,
						CreatedDate,
						ModifiedBy,
						ModifiedDate	
				FROM Drug WHERE DrugID = @Id and  DrugName like '%' +@Name+'%' order by DrugID desc;
			END;		
		ELSE IF @key ='Date'
			BEGIN
					SELECT
						DrugID,
						ClientID,
						YearCode,
						DrugTypeID,
						GenericID,
						ManufacturerID,
						DrugName,
						ReOrderLevel,
						Location,
						Scheduled,
						Description,
						Activeflag,
						CreatedBy,
						CreatedDate,
						ModifiedBy,
						ModifiedDate							
				FROM Drug WHERE ( CONVERT(datetime,( CONVERT(VARCHAR(10),
				 (CONVERT(DATETIME,CreatedDate,103)),103)),103) 
				 BETWEEN (CONVERT(DATETIME,@FromDate,103))  
				 AND (CONVERT(DATETIME,@ToDate,103)));
			END;
		ELSE IF @key ='Name'
			BEGIN
					SELECT
						DrugID,
						ClientID,
						YearCode,
						DrugTypeID,
						GenericID,
						ManufacturerID,
						DrugName,
						ReOrderLevel,
						Location,
						Scheduled,
						Description,
						Activeflag,
						CreatedBy,
						CreatedDate,
						ModifiedBy,
						ModifiedDate		
				FROM Drug WHERE DrugName like '%' +@Name+'%' order by DrugID desc;
			END;
		ELSE IF @key ='EDIT'
			BEGIN
			SELECT DrugID,
						ClientID,
						YearCode,
						DrugTypeID,
						GenericID,
						ManufacturerID,
						DrugName,
						ReOrderLevel,
						Location,
						Scheduled,
						Description,
						Activeflag,
						CreatedBy,
						CreatedDate,
						ModifiedBy,
						ModifiedDate	
			FROM Drug   WHERE DrugID = @Id order by DrugID desc;
			END;
		ELSE 
			BEGIN
				SELECT
						DrugID,
						ClientID,
						YearCode,
						DrugTypeID,
						GenericID,
						ManufacturerID,
						DrugName,
						ReOrderLevel,
						Location,
						Scheduled,
						Description,
						Activeflag,
						CreatedBy,
						CreatedDate,
						ModifiedBy,
						ModifiedDate	
				FROM Drug order by DrugID desc;
			END;
		----exec AH_GET_PATIENT 'SS'
		--DECLARE @FILTER_QUERY NVARCHAR(MAX)='';
		----(
		----	CASE @key 
		----		WHEN 'ID' THEN 'WHERE  DrugID = '+@Id+''
		----		--WHEN 'ALL' THEN 'WHERE DrugID = '+@Id+' and  DrugName like ''%' + @PatintName + '%''
		----		--AND ( CONVERT(datetime,( CONVERT(VARCHAR(10),
		----		-- (CONVERT(DATETIME,CreatedDate,103)),103)),103) 
		----		-- BETWEEN (CONVERT(DATETIME,'''+@FromDate+''',103))  
		----		-- AND (CONVERT(DATETIME,'''+@ToDate+''',103)))'
		----		--WHEN 'DATE' THEN 'WHERE ( CONVERT(datetime,( CONVERT(VARCHAR(10),
		----		-- (CONVERT(DATETIME,CreatedDate,103)),103)),103) 
		----		-- BETWEEN (CONVERT(DATETIME,'''+@FromDate+''',103))  
		----		-- AND (CONVERT(DATETIME,'''+@ToDate+''',103))) '
		----		--WHEN 'NAME' THEN 'WHERE DrugName like ''%' + @PatintName + '%'' '
		----		--WHEN 'EDIT' THEN ' WHERE  DrugID = '+@Id+''
		----		ELSE ' FGDFGDF'
		----	END
		----);

		--DECLARE @BASIC_QUERY NVARCHAR(MAX)=
		--		'SELECT
		--				ROW_NUMBER() OVER(ORDER BY  CreatedDate ) AS SNO, 
		--				PatientID,
		--				DrugName,
		--				MiddleName,
		--				LastName,
		--				Age,
		--				DateofBirth,
		--				Sex,
		--				Address,
		--				Religion,
		--				Pincode,
		--				Phone,
		--				Mobile,
		--				FatherSpouseName,
		--				MotherName,
		--				MaritialStatus,
		--				EmailId,
		--				Description,
		--				CreatedBy,
		--				CreatedDate,
		--				ModifiedBy,
		--				ModifiedDate,
		--				RelationShip,
		--				ReferanceAddress,
		--				Language,
		--				City,
		--				State,
		--				Country
		--		FROM Drug  '+ @FILTER_QUERY+'';
		--	DECLARE @RESULT NVARCHAR(MAX)=@BASIC_QUERY;
		--	EXEC sp_executesql @BASIC_QUERY;
	END;


GO
/****** Object:  StoredProcedure [dbo].[AH_GET_PATIENT]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AH_GET_PATIENT]
(
	@key varchar(10),
	@FromDate DATETIME=NULL,
	@ToDate DATETIME=NULL,
	@PatientId bigint=NULL,
	@PatientName varchar(100)=NULL
)
AS
	BEGIN
		if @key='Id'
			BEGIN
				SELECT
						A.Id, 
						A.PatientID,
						(A.FirstName +' '+A.MiddleName+' '+A.LastName) as Name,
						A.Age,
						A.DateofBirth,
						A.Sex,						
						A.Phone,
						A.Mobile,					
						A.MaritialStatus,
						A.EmailId,
						A.ActiveFlag,
						A.Description,
						A.CreatedBy,
						A.CreatedDate	
				FROM patient  A WHERE  A.PatientID = @PatientId order by A.id desc;
			END;
		ELSE IF @key ='ALL'
			BEGIN
				SELECT
						A.Id, 
						A.PatientID,
						A.FirstName ,
						A.Age,
						A.DateofBirth,
						A.Sex,						
						A.Phone,
						A.Mobile,					
						A.MaritialStatus,
						A.EmailId,
						A.ActiveFlag,
						A.Description,
						A.CreatedBy,
						A.CreatedDate	
				FROM patient  A WHERE A.PatientID = @PatientId and  A.FirstName like '%' +@PatientName+'%'
				AND ( CONVERT(datetime,( CONVERT(VARCHAR(10),
				 (CONVERT(DATETIME,A.CreatedDate,103)),103)),103) 
				 BETWEEN (CONVERT(DATETIME,@FromDate,103))  
				 AND (CONVERT(DATETIME,@ToDate,103))) order by A.id desc;
			END;			
		ELSE IF @key ='DateWithName'
			BEGIN
				SELECT
						A.Id,  
						A.PatientID,
						A.FirstName ,
						A.Age,
						A.DateofBirth,
						A.Sex,						
						A.Phone,
						A.Mobile,	
						A.ActiveFlag,				
						A.MaritialStatus,
						A.EmailId,
						A.Description,
						A.CreatedBy,
						A.CreatedDate	
				FROM patient  A WHERE  A.FirstName like '%' +@PatientName+'%'
				AND ( CONVERT(datetime,( CONVERT(VARCHAR(10),
				 (CONVERT(DATETIME,A.CreatedDate,103)),103)),103) 
				 BETWEEN (CONVERT(DATETIME,@FromDate,103))  
				 AND (CONVERT(DATETIME,@ToDate,103))) order by A.id desc;
			END;	
		ELSE IF @key ='DateWithId'
			BEGIN
				SELECT
						A.Id, 
						A.PatientID,
						A.FirstName ,
						A.Age,
						A.DateofBirth,
						A.Sex,
						A.ActiveFlag,						
						A.Phone,
						A.Mobile,					
						A.MaritialStatus,
						A.EmailId,
						A.Description,
						A.CreatedBy,
						A.CreatedDate	
				FROM patient  A WHERE A.PatientID = @PatientId and ( CONVERT(datetime,( CONVERT(VARCHAR(10),
				 (CONVERT(DATETIME,A.CreatedDate,103)),103)),103) 
				 BETWEEN (CONVERT(DATETIME,@FromDate,103))  
				 AND (CONVERT(DATETIME,@ToDate,103))) order by A.id desc;
			END;			
		ELSE IF @key ='NameWithId'
			BEGIN
				SELECT
						ROW_NUMBER() OVER(ORDER BY  A.CreatedDate ) AS SNO, 
						A.PatientID,
						A.FirstName,
						A.Age,
						A.DateofBirth,
						A.Sex,						
						A.Phone,
						A.Mobile,					
						A.MaritialStatus,
						A.EmailId,
						A.ActiveFlag,
						A.Description,
						A.CreatedBy,
						A.CreatedDate	
				FROM patient  A WHERE A.PatientID = @PatientId and  A.FirstName like '%' +@PatientName+'%' order by A.id desc;
			END;		
		ELSE IF @key ='Date'
			BEGIN
					SELECT
						A.Id, 
						A.PatientID,
						A.FirstName ,
						A.Age,
						A.DateofBirth,
						A.Sex,						
						A.Phone,
						A.Mobile,					
						A.MaritialStatus,
						A.EmailId,
						A.ActiveFlag,
						A.Description,
						A.CreatedBy,
						A.CreatedDate						
				FROM patient  A WHERE ( CONVERT(datetime,( CONVERT(VARCHAR(10),
				 (CONVERT(DATETIME,A.CreatedDate,103)),103)),103) 
				 BETWEEN (CONVERT(DATETIME,@FromDate,103))  
				 AND (CONVERT(DATETIME,@ToDate,103)));
			END;
		ELSE IF @key ='Name'
			BEGIN
					SELECT
						A.Id,  
						A.PatientID,
						A.FirstName ,
						A.Age,
						A.DateofBirth,
						A.Sex,						
						A.Phone,
						A.Mobile,					
						A.MaritialStatus,
						A.EmailId,
						A.ActiveFlag,
						A.Description,
						A.CreatedBy,
						A.CreatedDate	
				FROM patient  A WHERE A.FirstName like '%' +@PatientName+'%' order by A.id desc;
			END;
		ELSE IF @key ='EDIT'
			BEGIN
			SELECT Id
			  ,PatientID
			  ,ClientID
			  ,YearCode
			  ,AreaID
			  ,BloodID
			  ,PatientOccupationID
			  ,FatherOccupationID
			  ,MotherOccupationID
			  ,DoctorID
			  ,NRICno
			  ,CategoryID
			  ,CPatientID
			  ,Salutation
			  ,FirstName
			  ,MiddleName
			  ,LastName
			  ,Age
			  ,DateofBirth
			  ,Sex
			  ,Address
			  ,Religion
			  ,Pincode
			  ,Phone
			  ,Mobile
			  ,FatherSpouseName
			  ,MotherName
			  ,MaritialStatus
			  ,EmailId
			  ,IsReports
			  ,Description
			  ,ActiveFlag
			  ,CreatedBy
			  ,CreatedDate
			  ,ModifiedBy
			  ,ModifiedDate
			  ,PersonToNotify
			  ,RelationShip
			  ,ReferanceAddress
			  ,Race
			  ,Language
			  ,City
			  ,State
			  ,Country
			  ,StartDate
			  ,enddate
			FROM Patient   WHERE PatientID = @PatientId order by id desc;
			END;
		ELSE 
			BEGIN
				SELECT
						A.Id,  
						A.PatientID,
						A.FirstName ,
						A.Age,
						A.DateofBirth,
						A.Sex,						
						A.Phone,
						A.ActiveFlag,
						A.Mobile,					
						A.MaritialStatus,
						A.EmailId,
						A.Description,
						A.CreatedBy,
						A.CreatedDate	
				FROM patient  A order by A.id desc;
			END;
		----exec AH_GET_PATIENT 'SS'
		--DECLARE @FILTER_QUERY NVARCHAR(MAX)='';
		----(
		----	CASE @key 
		----		WHEN 'ID' THEN 'WHERE  A.PatientID = '+@PatientId+''
		----		--WHEN 'ALL' THEN 'WHERE A.PatientID = '+@PatientId+' and  A.FirstName like ''%' + @PatintName + '%''
		----		--AND ( CONVERT(datetime,( CONVERT(VARCHAR(10),
		----		-- (CONVERT(DATETIME,A.CreatedDate,103)),103)),103) 
		----		-- BETWEEN (CONVERT(DATETIME,'''+@FromDate+''',103))  
		----		-- AND (CONVERT(DATETIME,'''+@ToDate+''',103)))'
		----		--WHEN 'DATE' THEN 'WHERE ( CONVERT(datetime,( CONVERT(VARCHAR(10),
		----		-- (CONVERT(DATETIME,A.CreatedDate,103)),103)),103) 
		----		-- BETWEEN (CONVERT(DATETIME,'''+@FromDate+''',103))  
		----		-- AND (CONVERT(DATETIME,'''+@ToDate+''',103))) '
		----		--WHEN 'NAME' THEN 'WHERE A.FirstName like ''%' + @PatintName + '%'' '
		----		--WHEN 'EDIT' THEN ' WHERE  A.PatientID = '+@PatientId+''
		----		ELSE ' FGDFGDF'
		----	END
		----);

		--DECLARE @BASIC_QUERY NVARCHAR(MAX)=
		--		'SELECT
		--				ROW_NUMBER() OVER(ORDER BY  A.CreatedDate ) AS SNO, 
		--				A.PatientID,
		--				A.FirstName,
		--				A.MiddleName,
		--				A.LastName,
		--				A.Age,
		--				A.DateofBirth,
		--				A.Sex,
		--				A.Address,
		--				A.Religion,
		--				A.Pincode,
		--				A.Phone,
		--				A.Mobile,
		--				A.FatherSpouseName,
		--				A.MotherName,
		--				A.MaritialStatus,
		--				A.EmailId,
		--				A.Description,
		--				A.CreatedBy,
		--				A.CreatedDate,
		--				A.ModifiedBy,
		--				A.ModifiedDate,
		--				A.RelationShip,
		--				A.ReferanceAddress,
		--				A.Language,
		--				A.City,
		--				A.State,
		--				A.Country
		--		FROM patient  A  '+ @FILTER_QUERY+'';
		--	DECLARE @RESULT NVARCHAR(MAX)=@BASIC_QUERY;
		--	EXEC sp_executesql @BASIC_QUERY;
	END;


GO
/****** Object:  StoredProcedure [dbo].[HMS_MENUFORMAT_SELECTION]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[HMS_MENUFORMAT_SELECTION]
(
	@Key VARCHAR(10),
	@MenuId VARCHAR(10)=null
)
AS
BEGIN
	IF @Key ='MAIN_MENU'
		BEGIN
			SELECT 
				A.MainMenuId as Id, 
				A.MainMenuName as Name,
				A.MenuIcon as Icon,
				A.ViewModel as ViewModel 
			FROM HMS_MAINMENU A WHERE A.Flag=1;
		END;
	ELSE IF @Key ='SUB_MENU'
		BEGIN
			SELECT 
				A.MainMenuId as Id, 
				A.SubMenuName as Name,
				A.MenuIcon as Icon,
				A.ViewModel as ViewModel 
			FROM HMS_SUBMENU A WHERE A.Flag=1;
		END;
END;


GO
/****** Object:  StoredProcedure [dbo].[Sp_CreateDrug]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE ProcEDURE [dbo].[Sp_CreateDrug]
(
	@IsSave			BIT,
	@DrugID			bigint,
	@ClientID       bigint,
	@YearCode		INT,
	@DrugTypeID		bigint,
	@GenericID		bigint,
	@ManufacturerID	bigint,
	@DrugName		varchar(50),
	@ReOrderLevel	INT,
	@Location		VARCHAR(15),
	@Scheduled		VARCHAR(3),
	@Description	VARCHAR(250),
	@Activeflag		TINYINT,
	@CreatedBy		bigint,
	@OUTPUT AS varchar(100) output
)
AS

BEGIN
	IF(@IsSave=1)
		BEGIN TRY
			Declare @AutoId varchar(200)=(	Select  MAX(id)+1 from patient	);	
				INSERT INTO DRUG 
					(
						ClientID,
						YearCode,
						DrugTypeID,
						GenericID,
						ManufacturerID,
						DrugName,
						ReOrderLevel,
						Location,
						Scheduled,
						Description,
						Activeflag,
						CreatedBy,
						CreatedDate
					) VALUES 
					(
						@ClientID,
						@YearCode,
						@DrugTypeID,
						@GenericID,
						@ManufacturerID,
						@DrugName,
						@ReOrderLevel,
						@Location,
						@Scheduled,
						@Description,
						1,
						@CreatedBy,
						getdate()
					)
				SET @OUTPUT = @AutoId;	
		END TRY
		BEGIN CATCH   		
			SET @OUTPUT='ERROR';	
		END CATCH;	
	else
		BEGIN TRY
			UPDATE DRUG  
				SET ClientID=@ClientID,
					YearCode=@YearCode,
					DrugTypeID=@DrugTypeID,
					GenericID=@GenericID,
					ManufacturerID=@ManufacturerID,
					DrugName=@DrugName,
					ReOrderLevel=@ReOrderLevel,
					Location=@Location,
					Scheduled=@Scheduled,
					Description=@Description,
					Activeflag=1,
					ModifiedBy=@CreatedBy,
				ModifiedDate=getdate() WHERE DrugID=@DrugID
		END TRY
		BEGIN CATCH   		
			SET @OUTPUT='ERROR';	
		END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[Sp_CreatePatient]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sp_CreatePatient] 
	  (
	  @IsSave BIT,
	  @Id BIGINT,
	  @PatientID BIGINT,
	  @YearCode INT,
	  @ClientID BIGINT,
	  @AreaID BIGINT = NULL,
	  @City VARCHAR(max),
	  @State VARCHAR(max),
	  @Country VARCHAR(max),
	  @BloodID BIGINT= NULL,
	  @CpatientID BIGINT,
	  @DoctorID BIGINT,
	  @Salutation CHAR(10) = NULL,
	  @FirstName VARCHAR(50) = NULL,
	  @MiddleName VARCHAR(50) = NULL,
	  @LastName VARCHAR(50) = NULL,
	  @Age VARCHAR(30),
	  @DateofBirth DATETIME = NULL,
	  @Sex VARCHAR(10),
	  @Address VARCHAR(100) = NULL,
	  @PatientOccupationID BIGINT= NULL,
	  @FatherOccupationID BIGINT= NULL,
	  @MotherOccupationID BIGINT= NULL,
	  @MotherName VARCHAR(50)= NULL,
	  @Religion VARCHAR(20),
	  @PinCode VARCHAR(10) = NULL,
	  @Phone VARCHAR(15) = NULL,
	  @Mobile VARCHAR(15) = NULL,
	  @FatherSpouseName VARCHAR(25) = NULL,
	  @MaritialStatus VARCHAR(10) = NULL,
	  @EmailId NVARCHAR(50) = NULL,
	  @CategoryID BIGINT= NULL, 		
	  --  @IsReports bit,              
      @Description varchar(250)= NULL,              
      @CreatedBy VARCHAR(40),
	  @PersonToNotify VARCHAR(50) = NULL,
	  @RelationShip VARCHAR(50) = NULL,
	  @ReferanceAddress VARCHAR(50) = NULL,
	  @Race INT = NULL,
	  @Language VARCHAR(50) = NULL,
	  @startdate DATETIME = NULL,
	  @NRICNo VARCHAR(50) = NULL, 
	  @OUTPUT AS varchar(100) output) AS 
BEGIN             
	IF (@IsSave = 1 ) 
		BEGIN TRY
		Declare @AutoId varchar(200)=(	Select  MAX(id)+1 from patient	);	
				INSERT INTO	patient 
				(
					patientid, 
					clientid, 
					yearcode, 
					areaid, 
					bloodid, 
					cpatientid, 
					doctorid, 
					salutation, 
					categoryid, 
					firstname, 
					middlename, 
					lastname, 
					age, 
					dateofbirth, 
					sex, 
					address, 
					patientoccupationid, 
					fatheroccupationid, 
					motheroccupationid, 
					mothername, 
					religion, 
					pincode, 
					phone, 
					mobile, 
					fatherspousename, 
					maritialstatus, 
					emailid, 			
					--      IsReports,              
					 Description,              
					activeflag, 
					createdby, 
					createddate, 
					persontonotify, 
					relationship, 
					referanceaddress, 
					race, 
					language, 
					city, 
					state, 
					country, 
					startdate, 
					enddate, 
					nricno
				) 
				VALUES
				(
					@AutoId,
					@ClientID,
					@YearCode,
					@AreaID,
					@BloodID,
					@CpatientID,
					@DoctorID,
					@Salutation,
					@CategoryID,
					@FirstName,
					@MiddleName,
					@LastName,
					@Age,
					@DateofBirth,
					@Sex,
					@Address,
					@PatientOccupationID,
					@FatherOccupationID,
					@MotherOccupationID,
					@MotherName,
					@Religion,
					@PinCode,
					@Phone,
					@Mobile,
					@FatherSpouseName,
					@MaritialStatus,
					@EmailId,
					--      @IsReports,              
					@Description,              
					1,
					@CreatedBy,
					Getdate(),
					@PersonToNotify,
					@RelationShip,
					@ReferanceAddress,
					@Race,
					@Language,
					@City,
					@State,
					@Country,
					@startdate,
					Getdate(),
					@NRICNo 
				);
				SET @OUTPUT = @AutoId;	
		END TRY
		BEGIN CATCH   		
			SET @OUTPUT='ERROR';	
		END CATCH;	
	ELSE
		BEGIN TRY
			BEGIN TRAN
				 UPDATE
					patient 
				 SET
					clientid =@ClientID,
					areaid =@AreaID,
					yearcode =@YearCode,
					bloodid =@BloodID,
					cpatientid =@CpatientID,
					categoryid =@CategoryID,
					doctorid =@DoctorID,
					salutation =@Salutation,
					firstname =@FirstName,
					middlename =@MiddleName,
					lastname =@LastName,
					age =@Age,
					dateofbirth =@DateofBirth,
					sex =@Sex,
					address =@Address,
					patientoccupationid =@PatientOccupationID,
					fatheroccupationid =@FatherOccupationID,
					motheroccupationid =@MotherOccupationID,
					mothername =@MotherName,
					religion =@Religion,
					pincode =@PinCode,
					phone =@Phone,
					mobile =@Mobile,
					fatherspousename =@FatherSpouseName,
					maritialstatus =@MaritialStatus,
					emailid =@EmailId,
					--      IsReports=@IsReports,              
					Description=@Description,            
					activeflag = 1,
					modifiedby =@CreatedBy,
					modifieddate = Getdate(),
					persontonotify =@PersonToNotify,
					relationship =@RelationShip,
					referanceaddress =@ReferanceAddress,
					race =@Race,
					language =@Language,
					city =@City,
					state =@State,
					country =@Country,
					nricno =@NRICNo 
				 WHERE id=@id;
			COMMIT TRAN;
				SET @OUTPUT=@PatientID;				
		END TRY
			BEGIN CATCH   
				ROLLBACK  TRAN;
				SET @OUTPUT='ERROR';	
			END CATCH;
END;



GO
/****** Object:  UserDefinedFunction [dbo].[AH_CAMELCASE]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[AH_CAMELCASE](@str as varchar(1000))
returns varchar(1000)
as
begin
declare @bitval bit;
declare @result varchar(1000);
declare @i int;
declare @j char(1);
select @bitval = 1, @i=1, @result = '';
while (@i <= len(@str))
select @j= substring(@str,@i,1),
@result = @result + case when @bitval=1 then UPPER(@j) else LOWER(@j) end,
@bitval = case when @j like '[a-zA-Z]' then 0 else 1 end,
@i = @i +1
return @result
end


GO
/****** Object:  UserDefinedFunction [dbo].[AH_SEQUENCE_ID]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CREATE SEQUENCE SQ_PATINET_ID  
--    START WITH 1  
--    INCREMENT BY 1  
--    MINVALUE 1  
--    MAXVALUE 10000000000  
--    CYCLE  
--    NO CACHE  
--;  SELECT NEXT VALUE FOR SQ_PATINET_ID; 
CREATE FUNCTION [dbo].[AH_SEQUENCE_ID]
(
	@TABLE_NAME  as varchar(50),
	@PREFIX_TEXT as varchar(1000)
)
returns varchar(1000)
as
BEGIN
	declare @result varchar(1000);
	SET @result=@result +  (SELECT isnull(IDENT_CURRENT(@TABLE_NAME) + IDENT_INCR(@TABLE_NAME),1));
	return @result
END;


GO
/****** Object:  Table [dbo].[Drug]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Drug](
	[DrugId] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientId] [bigint] NOT NULL,
	[YearCode] [int] NOT NULL,
	[DrugTypeId] [bigint] NOT NULL,
	[GenericId] [bigint] NOT NULL,
	[ManufacturerId] [bigint] NOT NULL,
	[DrugName] [varchar](50) NOT NULL,
	[ReOrderLevel] [int] NULL,
	[Location] [varchar](15) NULL,
	[Scheduled] [varchar](3) NULL,
	[Description] [varchar](250) NULL,
	[Activeflag] [tinyint] NOT NULL,
	[CreatedBy] [bigint] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Drug] PRIMARY KEY CLUSTERED 
(
	[DrugId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HMS_MAINMENU]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HMS_MAINMENU](
	[MainMenuId] [int] IDENTITY(1,1) NOT NULL,
	[MainMenuName] [varchar](50) NOT NULL,
	[MenuIcon] [varchar](50) NOT NULL CONSTRAINT [DF_HMS_MAINMENU_MenuIcon]  DEFAULT ('Information'),
	[ViewModel] [varchar](50) NULL,
	[Flag] [bit] NOT NULL CONSTRAINT [DF_HMS_MAINMENU_Flag]  DEFAULT ((1)),
 CONSTRAINT [PK_HMS_MAINMENU] PRIMARY KEY CLUSTERED 
(
	[MainMenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Hms_MenuFormat]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Hms_MenuFormat](
	[MenuId] [int] IDENTITY(1,1) NOT NULL,
	[MainMenu] [varchar](50) NOT NULL,
	[SubMenu] [varchar](50) NULL,
	[ViewModel] [varchar](50) NOT NULL,
	[Flag] [bit] NOT NULL CONSTRAINT [DF_Hms_MenuFormat_Flag]  DEFAULT ((1)),
	[Icon] [varchar](50) NOT NULL CONSTRAINT [DF_Hms_MenuFormat_Icon]  DEFAULT ('Information')
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HMS_SUBMENU]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HMS_SUBMENU](
	[SubMenuId] [int] IDENTITY(1,1) NOT NULL,
	[MainMenuId] [int] NOT NULL,
	[SubMenuName] [varchar](50) NOT NULL,
	[MenuIcon] [varchar](50) NOT NULL CONSTRAINT [DF_HMS_SUBMENU_MenuIcon]  DEFAULT ('Information'),
	[ViewModel] [varchar](50) NOT NULL,
	[Flag] [bit] NOT NULL CONSTRAINT [DF_HMS_SUBMENU_Flag]  DEFAULT ((1)),
 CONSTRAINT [PK_HMS_SUBMENU] PRIMARY KEY CLUSTERED 
(
	[SubMenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 05-11-2017 13:05:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Patient](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PatientID] [bigint] NOT NULL,
	[ClientID] [bigint] NOT NULL,
	[YearCode] [int] NOT NULL,
	[AreaID] [bigint] NOT NULL,
	[BloodID] [bigint] NULL,
	[PatientOccupationID] [bigint] NULL,
	[FatherOccupationID] [bigint] NULL,
	[MotherOccupationID] [bigint] NULL,
	[DoctorID] [bigint] NOT NULL,
	[NRICno] [varchar](50) NULL,
	[CategoryID] [bigint] NULL,
	[CPatientID] [bigint] NOT NULL,
	[Salutation] [char](10) NULL,
	[FirstName] [varchar](250) NULL,
	[MiddleName] [varchar](250) NULL,
	[LastName] [varchar](250) NULL,
	[Age] [varchar](30) NOT NULL,
	[DateofBirth] [datetime] NULL,
	[Sex] [varchar](10) NOT NULL,
	[Address] [varchar](500) NULL,
	[Religion] [varchar](20) NOT NULL,
	[Pincode] [varchar](10) NULL,
	[Phone] [varchar](15) NULL,
	[Mobile] [varchar](15) NULL,
	[FatherSpouseName] [varchar](max) NULL,
	[MotherName] [varchar](50) NULL,
	[MaritialStatus] [varchar](10) NULL,
	[EmailId] [varchar](50) NULL,
	[IsReports] [bit] NULL,
	[Description] [varchar](250) NULL,
	[ActiveFlag] [bit] NOT NULL,
	[CreatedBy] [bigint] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[PersonToNotify] [varchar](50) NULL,
	[RelationShip] [varchar](50) NULL,
	[ReferanceAddress] [varchar](50) NULL,
	[Race] [int] NULL,
	[Language] [varchar](50) NULL,
	[City] [varchar](max) NULL,
	[State] [varchar](max) NULL,
	[Country] [varchar](max) NULL,
	[StartDate] [datetime] NULL,
	[enddate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Drug] ON 

INSERT [dbo].[Drug] ([DrugId], [ClientId], [YearCode], [DrugTypeId], [GenericId], [ManufacturerId], [DrugName], [ReOrderLevel], [Location], [Scheduled], [Description], [Activeflag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (1, 1, 1, 1, 1, 1, N'rwer', 1, N'ewr', N'TST', N'ewrewr', 1, 1, CAST(N'2017-07-16 22:41:17.647' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Drug] OFF
SET IDENTITY_INSERT [dbo].[HMS_MAINMENU] ON 

INSERT [dbo].[HMS_MAINMENU] ([MainMenuId], [MainMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (1, N'HOME', N'Home', N'Home', 1)
INSERT [dbo].[HMS_MAINMENU] ([MainMenuId], [MainMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (2, N'MASTER', N'Windows', NULL, 1)
INSERT [dbo].[HMS_MAINMENU] ([MainMenuId], [MainMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (3, N'TRANSATION', N'LibraryBooks', NULL, 1)
SET IDENTITY_INSERT [dbo].[HMS_MAINMENU] OFF
SET IDENTITY_INSERT [dbo].[Hms_MenuFormat] ON 

INSERT [dbo].[Hms_MenuFormat] ([MenuId], [MainMenu], [SubMenu], [ViewModel], [Flag], [Icon]) VALUES (1, N'Home', NULL, N'Home', 1, N'Information')
SET IDENTITY_INSERT [dbo].[Hms_MenuFormat] OFF
SET IDENTITY_INSERT [dbo].[HMS_SUBMENU] ON 

INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (1, 2, N'PATIENT MASTER', N'AccountPlus', N'PatientMaster', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (2, 2, N'Buttons', N'BookmarkCheck', N'Buttons', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (3, 3, N'TextFields', N'Grid', N'TextFields', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (4, 3, N'Cards', N'Grid', N'Cards', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (5, 3, N'Chips', N'Information', N'Chips', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (6, 3, N'ColorZones', N'Information', N'ColorZones', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (7, 3, N'Grids', N'Information', N'Grids', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (8, 3, N'Drawers', N'Information', N'Drawers', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (9, 3, N'Dialogs', N'Information', N'Dialogs', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (10, 3, N'GroupBoxes', N'Information', N'GroupBoxes', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (11, 3, N'IconPack', N'Information', N'IconPack', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (12, 3, N'Lists', N'Information', N'Lists', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (13, 3, N'MenusAndToolBars', N'Information', N'MenusAndToolBars', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (14, 3, N'Palette', N'', N'Palette', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (15, 3, N'PaletteSelector', N'Information', N'PaletteSelector', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (16, 3, N'Pickers', N'Information', N'Pickers', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (17, 3, N'Shadows', N'Information', N'Shadows', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (18, 3, N'ProvingGround', N'Information', N'ProvingGround', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (19, 3, N'Progress', N'Information', N'Progress', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (20, 3, N'Snackbars', N'Information', N'Snackbars', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (22, 3, N'Transitions', N'Information', N'Transitions', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (23, 3, N'Typography', N'Information', N'Typography', 1)
INSERT [dbo].[HMS_SUBMENU] ([SubMenuId], [MainMenuId], [SubMenuName], [MenuIcon], [ViewModel], [Flag]) VALUES (25, 2, N'DRUG MASTER', N'Grid', N'Durg', 1)
SET IDENTITY_INSERT [dbo].[HMS_SUBMENU] OFF
SET IDENTITY_INSERT [dbo].[Patient] ON 

INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (1, 1, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'182', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'rerw', N'Test', N'Test', N'500032', N'3324234', N'76767676', N'ds', N'dssdf', N'Single', N'ananth.g1992@gmail.com', NULL, N'4334324ggg', 1, 1, CAST(N'1992-05-05 00:00:00.000' AS DateTime), 1, CAST(N'2017-05-14 17:42:50.730' AS DateTime), NULL, NULL, NULL, NULL, N'ewrwe', N'fgdfgdfgf', N'wewe', N'efewwe', NULL, NULL)
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (2, 2, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'18', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'12', N'Test', N'Test', N'500032', N'', N'8973653655', NULL, NULL, N'Singlefdfd', N'ananth.g1992@gmail.com', NULL, NULL, 1, 1, CAST(N'1992-05-05 00:00:00.000' AS DateTime), 1, CAST(N'2017-05-14 11:41:41.283' AS DateTime), NULL, NULL, NULL, NULL, N'fdgd', N'dfgjjj', N'dfg', N'dfg', NULL, NULL)
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (3, 3, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'18', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'Female', N'Test', N'Test', N'500032', N'333', N'8973653655', N'werwer', N'ewrwer', N'Single', N'ananth.g1992@gmail.com', NULL, N'wwewe', 1, 1, CAST(N'1992-05-05 00:00:00.000' AS DateTime), 1, CAST(N'2017-05-14 22:42:21.823' AS DateTime), NULL, NULL, NULL, NULL, N'werwer', N'werwer', N'werwer', N'ewewrew', NULL, NULL)
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (4, 4, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'18', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'12', N'Test', N'Test', N'500032', N'', N'8973653655', NULL, NULL, N'Single', N'ananth.g1992@gmail.com', NULL, NULL, 1, 1, CAST(N'1992-05-05 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (5, 5, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'18', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'12', N'Test', N'Test', N'500032', N'', N'8973653655', NULL, NULL, N'Single', N'ananth.g1992@gmail.com', NULL, NULL, 1, 1, CAST(N'1992-05-05 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (6, 6, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'18', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'12', N'Test', N'Test', N'500032', N'', N'8973653655', NULL, NULL, N'Single', N'ananth.g1992@gmail.com', NULL, NULL, 1, 1, CAST(N'1992-05-05 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (7, 7, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'18', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'12', N'Test', N'Test', N'500032', N'', N'8973653655', NULL, NULL, N'Single', N'ananth.g1992@gmail.com', NULL, NULL, 1, 1, CAST(N'1992-05-05 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (8, 8, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'18', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'12', N'Test', N'Test', N'500032', N'', N'8973653655', NULL, NULL, N'Single', N'ananth.g1992@gmail.com', NULL, NULL, 1, 1, CAST(N'1992-05-05 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (9, 9, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'18', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'12', N'Test', N'Test', N'500032', N'', N'8973653655', NULL, NULL, N'Single', N'ananth.g1992@gmail.com', NULL, NULL, 1, 1, CAST(N'1992-05-05 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (10, 10, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'18', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'12', N'Test', N'Test', N'500032', N'', N'8973653655', NULL, NULL, N'Single', N'ananth.g1992@gmail.com', NULL, NULL, 1, 1, CAST(N'1992-05-05 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (11, 12, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'sdwe', N'we', NULL, N'44', CAST(N'2017-05-13 00:00:00.000' AS DateTime), N'ewe', NULL, N'werwer', N'3232', N'43', NULL, NULL, NULL, N'wer', NULL, NULL, NULL, 1, 1, CAST(N'2017-05-13 21:27:37.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'wer', N'wer', N'werwer', N'wer', NULL, CAST(N'2017-05-13 21:27:37.000' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (12, 13, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'wqw', N'qwe', NULL, N'32', CAST(N'2017-05-04 00:00:00.000' AS DateTime), N'waad', NULL, N'asdas', N'231231', NULL, NULL, NULL, NULL, N'sad', NULL, NULL, NULL, 1, 1, CAST(N'2017-05-13 21:30:37.880' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'asdsad', N'sad', N'sadas', N'sad', NULL, CAST(N'2017-05-13 21:30:37.880' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (13, 14, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'gffhg', N'trytrtr', NULL, N'554', CAST(N'2017-05-04 00:00:00.000' AS DateTime), N'tryrt', NULL, N'trtrt', N'454354', N'5464565', N'56546', NULL, NULL, N'rtre', N'45435', NULL, NULL, 1, 1, CAST(N'2017-05-13 22:28:27.107' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'ererer', N'erer', N'erer', N'erer', NULL, CAST(N'2017-05-13 22:28:27.107' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (14, 15, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'gffhg', N'trytrtr', NULL, N'554', CAST(N'2017-05-04 00:00:00.000' AS DateTime), N'tryrt', NULL, N'trtrt', N'454354', N'5464565', N'56546', NULL, NULL, N'rtre', N'45435', NULL, NULL, 1, 1, CAST(N'2017-05-13 22:30:35.413' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'ererer', N'erer', N'erer', N'erer', NULL, CAST(N'2017-05-13 22:30:35.413' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (20, 20, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'dfsdfsd', N'dsfsdf', NULL, N'332', CAST(N'2017-05-04 00:00:00.000' AS DateTime), N'wwerwe', NULL, N'werwer', N'323432', NULL, NULL, NULL, NULL, N'wer', NULL, NULL, NULL, 1, 1, CAST(N'2017-05-13 23:38:47.730' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'wer', N'ewr', N'werwe', N'wer', NULL, CAST(N'2017-05-13 23:38:47.730' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (15, 15, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'gffhg', N'trytrtr', NULL, N'554', CAST(N'2017-05-04 00:00:00.000' AS DateTime), N'tryrt', NULL, N'trtrt', N'454354', N'5464565', N'56546', NULL, NULL, N'rtre', N'45435', NULL, NULL, 1, 1, CAST(N'2017-05-13 22:33:51.100' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'ererer', N'erer', N'erer', N'erer', NULL, CAST(N'2017-05-13 22:33:51.100' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (16, 16, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'gffhg', N'trytrtr', NULL, N'554', CAST(N'2017-05-04 00:00:00.000' AS DateTime), N'tryrt', NULL, N'trtrt', N'454354', N'5464565', N'56546', NULL, NULL, N'rtre', N'45435', NULL, NULL, 1, 1, CAST(N'2017-05-13 22:36:57.350' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'ererer', N'erer', N'erer', N'erer', NULL, CAST(N'2017-05-13 22:36:57.350' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (17, 17, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'gffhg', N'trytrtr', NULL, N'554', CAST(N'2017-05-04 00:00:00.000' AS DateTime), N'tryrt', NULL, N'trtrt', N'454354', N'5464565', N'56546', NULL, NULL, N'rtre', N'45435', NULL, NULL, 1, 1, CAST(N'2017-05-13 22:38:37.340' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'ererer', N'erer', N'erer', N'erer', NULL, CAST(N'2017-05-13 22:38:37.340' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (18, 18, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'gffhg', N'trytrtr', NULL, N'554', CAST(N'2017-05-04 00:00:00.000' AS DateTime), N'tryrt', NULL, N'trtrt', N'454354', N'5464565', N'56546', NULL, NULL, N'rtre', N'45435', NULL, NULL, 1, 1, CAST(N'2017-05-13 22:39:24.937' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'ererer', N'erer', N'erer', N'erer', NULL, CAST(N'2017-05-13 22:39:24.937' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (19, 19, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'qw', N'qwq', NULL, N'2', CAST(N'2017-05-04 00:00:00.000' AS DateTime), N'asdasd', NULL, N'asdad', N'212312', NULL, NULL, NULL, NULL, N'asdasdas', N'2112', NULL, NULL, 1, 1, CAST(N'2017-05-13 23:25:01.160' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'aasad', N'asda', N'asdasd', N'asdasd', NULL, CAST(N'2017-05-13 23:25:01.160' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (21, 21, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'18', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'12', N'Test', N'Test', N'500032', N'', N'8973653655', NULL, NULL, N'Single', N'ananth.g1992@gmail.com', NULL, NULL, 1, 1, CAST(N'2017-05-14 05:11:28.943' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'cvbd', N'dfgdfg', N'dfgdf', N'dfgdfg', NULL, CAST(N'2017-05-14 05:11:28.943' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (22, 22, 1, 1, 1, 1, 1, NULL, NULL, 1, N'1', 1, 1, NULL, N'Ananth', N'Ananth', N'Ananth', N'18', CAST(N'1992-05-05 00:00:00.000' AS DateTime), N'Others', N'Test', N'Test', N'500032', N'', N'8973653655', NULL, NULL, N'Single', N'ananth.g1992@gmail.com', NULL, NULL, 1, 1, CAST(N'2017-05-14 05:11:52.803' AS DateTime), 1, CAST(N'2017-05-14 20:06:52.993' AS DateTime), NULL, NULL, NULL, NULL, N'cvbd', N'dfgdfg', N'dfgdf', N'dfgdfg', NULL, CAST(N'2017-05-14 05:11:52.803' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (23, 23, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'qwqwe', N'qweqwe', NULL, N'33', CAST(N'2017-07-13 00:00:00.000' AS DateTime), N'Others', NULL, N'qweqwe', N'123132', NULL, NULL, NULL, N'ddsd', NULL, NULL, NULL, NULL, 1, 1, CAST(N'2017-07-02 12:13:35.723' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'qweqwe', N'wqeqwe', N'qeqwe', N'qweqwe', NULL, CAST(N'2017-07-02 12:13:35.723' AS DateTime))
INSERT [dbo].[Patient] ([Id], [PatientID], [ClientID], [YearCode], [AreaID], [BloodID], [PatientOccupationID], [FatherOccupationID], [MotherOccupationID], [DoctorID], [NRICno], [CategoryID], [CPatientID], [Salutation], [FirstName], [MiddleName], [LastName], [Age], [DateofBirth], [Sex], [Address], [Religion], [Pincode], [Phone], [Mobile], [FatherSpouseName], [MotherName], [MaritialStatus], [EmailId], [IsReports], [Description], [ActiveFlag], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [PersonToNotify], [RelationShip], [ReferanceAddress], [Race], [Language], [City], [State], [Country], [StartDate], [enddate]) VALUES (24, 24, 1, 1, 1, 1, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, N'w', N'w', N'w', N'2', CAST(N'2017-07-06 00:00:00.000' AS DateTime), N'Male', NULL, N'qw', N'12121', N'2222222', N'2222222222', N'wqwqw', N'qwqw', NULL, N'1212', NULL, N'WQWQW', 1, 1, CAST(N'2017-07-02 18:52:57.207' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'QWQW', N'WQ', N'QWQ', N'WQW', NULL, CAST(N'2017-07-02 18:52:57.207' AS DateTime))
SET IDENTITY_INSERT [dbo].[Patient] OFF
ALTER TABLE [dbo].[HMS_SUBMENU]  WITH CHECK ADD  CONSTRAINT [FK_MainMenu_SubMenu_MainMenuId] FOREIGN KEY([MainMenuId])
REFERENCES [dbo].[HMS_MAINMENU] ([MainMenuId])
GO
ALTER TABLE [dbo].[HMS_SUBMENU] CHECK CONSTRAINT [FK_MainMenu_SubMenu_MainMenuId]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'MAIN MENU HAVE SUBMENU MEANS ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HMS_MAINMENU', @level2type=N'COLUMN',@level2name=N'ViewModel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Hms_MenuFormat', @level2type=N'COLUMN',@level2name=N'Flag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Material Icon Only' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Hms_MenuFormat', @level2type=N'COLUMN',@level2name=N'Icon'
GO
