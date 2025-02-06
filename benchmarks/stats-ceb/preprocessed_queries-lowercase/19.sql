select count(*) from p, pl, u where p.id = pl.postid and p.owneruserid = u.id and p.commentcount<=17 and u.creationdate<='2014-09-12 07:12:16'::timestamp;
