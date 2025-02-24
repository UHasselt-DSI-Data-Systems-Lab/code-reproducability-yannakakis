select count(*) from v, p, u where v.userid = u.id and p.owneruserid = u.id and p.commentcount>=0 and u.creationdate>='2010-12-15 06:00:24'::timestamp;
