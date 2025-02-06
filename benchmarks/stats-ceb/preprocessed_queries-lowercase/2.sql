select count(*) from c, b where c.userid = b.userid and c.score=0 and b.date<='2014-09-11 14:33:06'::timestamp;
