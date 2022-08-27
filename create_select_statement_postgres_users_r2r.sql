use r2r_portal
select 
	'insert into public.users (
	_id
	,accountname
	,createdate
	,firstname
	,isadmin
	,lastname
	,passwordhash
	,phonenumber
	,r2r_source_id
	,username
	,userstatus
	,accessfailedcount
	,lockoutenabled
	,concurrencystamp
	,emailconfirmed
	,lockoutend
	,normalizedemail
	,normalizedusername
	,phonenumberconfirmed
	,securitystamp
	,twofactorenabled
	,email
	,accountid
	,normalized_password
	) values ('''
	+ cast(newid() as varchar(50)) + ''','''
	+ 'R2R_user' + ''','''
	+ cast(convert(date,getdate()) as varchar(50)) + ''','''
	+ isnull(FirstName,'') +''','''
	+ cast(isnull(UserType,'') as varchar(10))+''','''	---
	+ isnull(LastName,'')+''','''
	+ isnull(PasswordHash,'')+''','''
	+ isnull(PhoneNumber,'')+''','''
	+ cast(isnull(UserId,'') as varchar(20)) +''','''
	+ isnull(UserName,'')+''','''
	+ cast(iif(isnull(is_active,'')=1,'active','disabled') as varchar(10)) +''','''
	+ cast(isnull(AccessFailedCount,'') as varchar(20))+''','''
	+ cast (isnull(LockoutEnabled,'') as varchar(5))+''','''
	+ cast(isnull(ConcurrencyStamp,'') as varchar(50)) +''','''
	+ cast(isnull(EmailConfirmed,'') as varchar(10)) +''','''
	+ cast(isnull(LockoutEnd,'') as varchar(50))+''','''
	+ isnull(NormalizedEmail,'')+''','''
	+ isnull(NormalizedUserName,'')+''','''
	+ cast(isnull(PhoneNumberConfirmed,'') as varchar(5))+''','''
	+ isnull(SecurityStamp,'')+''','''
	+ cast(isnull(TwoFactorEnabled,'') as varchar(5)) +''','''
	+ isnull(Email,'')+''','''
	+ isnull(UserGuid,'')+''','''
	+ isnull(ForgotPasswordOtp,'')+''')'

from r2r_portal.dbo.users

--select distinct usertype from r2r_portal.dbo.users (nolock)
--select convert(char(20),convert(date,getdate()))
--insert into public.users (   _id   ,accountname   ,createdate   ,firstname   ,isadmin   ,lastname   ,passwordhash   ,phonenumber   ,r2r_source_id   ,username   ,userstatus   ,accessfailedcount   ,lockoutenabled   ,concurrencystamp   ,emailconfirmed   ,lockoutend   ,normalizedemail   ,normalizedusername   ,phonenumberconfirmed   ,securitystamp   ,twofactorenabled   ,email   ,accountid   ,normalized_password   ) values ('5B4CF9F2-FFD3-4027-8A2B-6F53A9CC35C3','R2R_user','2021-09-30','','0','','AQAAAAEAACcQAAAAEPlGyVV28bh3l7Uxe/agavfyJmYD/7miburI+wETAcFuBj49TPHuh2oQSXmcwD6H/A==','','47','generalmanager@warrous.com','active','0','1','db365f00-bb4b-4235-805a-508645b0ba12','0','1900-01-01 00:00:00.0000000 +00:00','GENERALMANAGER@WARROUS.COM','GENERALMANAGER@WARROUS.COM','0','d118d4da-cade-4d05-9058-e1ada416c423','0','generalmanager@warrous.com','1076b771-042d-486d-bf40-b7b86e3ccb44','')