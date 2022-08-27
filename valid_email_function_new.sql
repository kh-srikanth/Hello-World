--https://en.wikipedia.org/wiki/Email_address

declare @email varchar(350) = 'kh.srikanth@gmail.co/m'
declare @local_part varchar(300)
declare @domain_part varchar(300)
declare @is_valid bit = 0

if ((len(@email) - len(replace(@email,'@','')) > 1) )
BEGIN
	print @is_valid
	return;
END

set @local_part = (select substring(@email,1,charindex('@',@email)-1))
set @domain_part = (select substring(@email,charindex('@',@email)+1,len(@email)))

if (@domain_part not like '%__.__%' or PATINDEX('%[(),:;<>@#[\]/]%', @domain_part) > 0)
BEGIN
	print @is_valid
	return;
END

if ( (@local_part like '%..%' and (left(@local_part,1) <> '"' or right(@local_part,1) <> '"')) or @local_part like '.%' or @local_part like '%.' )
BEGIN
	print @is_valid
	return;
END
if (  (left(@local_part,1) <> '"' or right(@local_part,1) <> '"')) and len(@local_part) <> len(replace(@local_part,' ',''))
BEGIN
	print @is_valid
	return;
END
if ( (left(@local_part,1) = '.' or right(@local_part,1) = '.')
		or
	 (left(@local_part,1) = '"' and right(@local_part,1) = '"' and (left(@local_part,2) = '.' or right(@local_part,2) = '.') ) )
BEGIN
	print @is_valid
	return;
END
select  @local_part, @domain_part


--print @is_valid
