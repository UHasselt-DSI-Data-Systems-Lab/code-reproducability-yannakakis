select count(*) from c, v, u where u.id = c.userid and u.id = v.userid and c.creationdate>='2010-08-10 17:55:45'::timestamp and u.reputation>=1 and u.reputation<=691;
