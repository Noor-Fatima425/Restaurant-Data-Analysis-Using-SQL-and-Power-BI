use tempdb
go
if object_id('project') is not null
drop table project
go

create table project(id int identity, item varchar(3000))

declare @sql nvarchar(max),@path nvarchar(max)='C:\Users\HP\Desktop\Restaurant.csv'
set @sql='INSERT Project( Item ) SELECT value FROM OPENROWSET
 ( BULK '''+@path+''', 
   FORMATFILE = ''C:\Users\HP\Desktop\Pad_bulk_import.fmt'') a'

exec sys.sp_executesql @sql

select * from project

declare @i int=1

while @i<=(select count(*) from project)
  begin
  Declare @p int, @string varchar(200) 
  select @string = item from project where id=@i
  Select @p = PATINDEX ('%[^0-9a-zA-Z@,]%',@string)
 print @p
 While @p > 0
 Begin
		Select @string = replace(@string,substring(@string,@p,1),'')
		Select @p = PATINDEX ('%[^0-9a-zA-Z@,]%',@string)
		print @string
 End
  update project set item=@string where id=@i
  set @i=@i+1
  End
 -----------------------------------------------------------------------
 select * from project

declare @item nvarchar(max), 
        @colNames nvarchar(max),
        @sql1 nvarchar(max),
        @tname nvarchar(100)
declare @slash int,@dot int
SELECT @slash= LEN(@path) - CHARINDEX('\', REVERSE(@path))+1
print @slash
set @dot=charindex('.',@path)
set @tname=substring(@path,@slash+1,@dot-@slash-1)
print @tname

SELECT @item=item FROM project WHERE id=1;

WITH ColumnList AS (
    SELECT value AS column_name
    FROM STRING_SPLIT(@item, ',')
)

SELECT @colNames = STRING_AGG(column_name + ' varchar(100)', ', ') from ColumnList
print @colNames

SET @sql1 = 'CREATE TABLE ' + @tname + ' (' + @colNames + ')'

PRINT @sql1

EXEC sp_executesql @sql1
-------------------------------------------------------------------------
--insertion
declare @item_value nvarchar(max), 
        @values nvarchar(max),
        @sql2 nvarchar(max),
		@x int=3

while @x<=(select count(*) from project)
begin
 select @item_value=item from project where id=@x;
 With valuesList as(
   select value AS val
    from STRING_SPLIT(@item_value, ',')
	)

SELECT @values = STRING_AGG(''''+val+'''', ', ') from valuesList
print @values
SET @sql2 = 'Insert '+@tname+' values (' + @values + ')'

PRINT @sql2

EXEC sp_executesql @sql2

 set @x=@x+1
end

select * from restaurant
update restaurant set transactiontype='Other' where transactiontype=' '
-----------------------------------------------------------------------------------------------------

