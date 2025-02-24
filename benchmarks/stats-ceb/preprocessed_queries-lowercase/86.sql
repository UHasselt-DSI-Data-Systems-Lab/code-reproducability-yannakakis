select count(*) from c, v, u, p where c.postid = p.id and u.id = c.userid and v.postid = p.id and c.score=0 and u.views>=0 and u.views<=74;
