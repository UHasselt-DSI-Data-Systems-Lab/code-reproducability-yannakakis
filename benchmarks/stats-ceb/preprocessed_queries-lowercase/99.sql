select count(*) from c, p, v, u where u.id = p.owneruserid and u.id = c.userid and u.id = v.userid and c.score=0 and p.viewcount>=0 and u.reputation<=306 and u.upvotes>=0;
