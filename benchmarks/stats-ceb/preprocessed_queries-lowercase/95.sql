select count(*) from c, ph, v, p where ph.postid = p.id and c.postid = p.id and v.postid = p.id and v.creationdate<='2014-09-12 00:00:00'::timestamp;
