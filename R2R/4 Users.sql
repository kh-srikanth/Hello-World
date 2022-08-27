use auto_portal
Go

Insert into [PostgreSQL_Clictell].[clictell].[public].[users]
(
	  _id
	, accountname
	, createdate
	, firstname
	, fullname
	, isadmin
	, lastname
	, passwordhash
	, phonenumber
	, salt
	, updatedate
	, userid
	, usermigration
	, username
	, userstatus
	, permissionrole
	, channelcode
	, externalreferences
	, apikeys
	, account_id
	, accessfailedcount
	, lockoutenabled
	, concurrencystamp
	, emailconfirmed
	, lockoutend
	, normalizedemail
	, normalizedusername
	, phonenumberconfirmed
	, securitystamp
	, twofactorenabled
	, email
	, accountid
	, normalized_password
)
select 
	newid() as _id
	, c.accountname as accountname
	, a.UpdatedDt as createddate
	, a.FirstName
	, a.FirstName + ' ' + a.LastName
	, 0 as isadmin
	, a.LastName
	, a.passwordHash
	, a.phonenumber
	, null as salt
	, a.updateddt
	, null as userid
	, null as usermigration
	, a.username
	, 'active' as userstatus
	, null as permissionrole
	, null as channelcode
	, null as externalreferences
	, null as apikeys
	, c.account_id as accountid
	, a.accessfailedcount
	, a.lockoutenabled
	, a.concurrencystamp
	, null as emailconfirmed
	, a.lockoutend
	, a.normalizedemail
	, a.normalizedusername
	, a.phonenumberconfirmed
	, a.securitystamp
	, a.twofactorEnabled
	, a.email
	, _id as accountid
	, null as normalized_password
from [18.216.140.206].[r2r_portal].dbo.users a with (nolock)
inner join [18.216.140.206].[r2r_portal].portal.user_claims b (nolock) on a.userid = b.[user_id]
inner join auto_portal.portal.account c (nolock) on b.claim_value = c.r2r_dealer_id
where c.r2r_dealer_id in (48625, 2990, 2991) and b.claim_type_id = 1