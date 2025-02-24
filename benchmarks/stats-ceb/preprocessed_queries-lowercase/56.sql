select count(*) from t, p, u, v, b where p.id = t.excerptpostid and u.id = v.userid and u.id = b.userid and u.id = p.owneruserid and u.downvotes>=0;
