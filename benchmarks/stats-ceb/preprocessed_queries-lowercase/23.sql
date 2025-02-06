select count(*) from v, b, u where u.id = v.userid and v.userid = b.userid and u.downvotes>=0 and u.downvotes<=0;
