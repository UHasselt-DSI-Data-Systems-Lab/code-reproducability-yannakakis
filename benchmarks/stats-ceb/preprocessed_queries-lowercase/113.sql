select count(*) from c, ph, b, u where u.id = b.userid and u.id = ph.userid and u.id = c.userid and c.creationdate<='2014-09-10 00:33:30'::timestamp and u.downvotes<=0 and u.upvotes<=47;
