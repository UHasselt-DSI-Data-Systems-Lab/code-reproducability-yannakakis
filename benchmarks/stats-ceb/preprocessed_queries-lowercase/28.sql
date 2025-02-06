select count(*) from v, p, b, u where p.id = v.postid and u.id = p.owneruserid and u.id = b.userid and p.score<=22 and u.reputation>=1;
