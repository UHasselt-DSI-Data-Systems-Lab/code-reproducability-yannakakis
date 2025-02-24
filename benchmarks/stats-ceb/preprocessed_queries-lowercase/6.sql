select count(*) from b, p where b.userid = p.owneruserid and b.date<='2014-09-11 08:55:52'::timestamp and p.answercount>=0 and p.answercount<=4 and p.commentcount>=0 and p.commentcount<=17;
