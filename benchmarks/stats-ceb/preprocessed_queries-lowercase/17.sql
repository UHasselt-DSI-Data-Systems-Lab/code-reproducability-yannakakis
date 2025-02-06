select count(*) from p, t, v where p.id = t.excerptpostid and p.owneruserid = v.userid and p.creationdate>='2010-07-20 02:01:05'::timestamp;
