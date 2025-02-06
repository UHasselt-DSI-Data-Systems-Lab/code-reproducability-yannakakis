select count(*) from ph, p, u where p.owneruserid = u.id and ph.userid = u.id and p.score>=-1 and p.commentcount>=0 and p.commentcount<=23 and u.downvotes=0 and u.upvotes>=0 and u.upvotes<=244;
