insert into users 
(
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
	,account_id
	,accountid

)
select 
a._id
,a.accountname
,a.createdate
,a.firstname
,a.isadmin
,a.lastname
,a.passwordhash
,a.phonenumber
,cast(a.r2r_source_id as int)
,a.username
,a.userstatus
,cast(a.accessfailedcount as int)
,a.lockoutenabled
,a.concurrencystamp
,a.emailconfirmed
,a.lockoutend
,a.normalizedemail
,a.normalizedusername
,a.phonenumberconfirmed
,a.securitystamp
,a.twofactorenabled
,a.email
,cast(b.account_id as int)
,b._id




from r2ruser_del a
inner join account b on cast(a.r2r_dealer_id as varchar)= cast(b.r2r_source_id as varchar)

select * from account where r2r_source_id = 48428
select * from r2ruser_del
48428
select * from users  where account_id = 4288
