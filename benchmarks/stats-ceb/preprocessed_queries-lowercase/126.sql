select count(*) from ph, v, u, b where u.id = b.userid and u.id = ph.userid and u.id = v.userid and u.views>=0;
