select top 100
primary_email,
case when primary_email = '' then 0
    when primary_email like '% %' then 0
    when primary_email like ('%["(),:;<>\]%') then 0
    when substring(primary_email,charindex('@',primary_email),len(primary_email)) like ('%[!#$%&*+/=?^`_{|]%') then 0
    when (left(primary_email,1) like ('[-_.+]') or right(primary_email,1) like ('[-_.+]')) then 0                                                                                    
    when (primary_email like '%[%' or primary_email like '%]%') then 0
    when primary_email LIKE '%@%@%' then 0
    when primary_email NOT LIKE '_%@_%._%' then 0
    else 1 end as valid_email

from auto_customers.customer.customers (nolock) where len(primary_email) <> 0