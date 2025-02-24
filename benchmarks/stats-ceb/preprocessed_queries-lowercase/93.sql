select count(*) from v, p, u where v.userid = u.id and p.owneruserid = u.id and p.posttypeid=2 and p.creationdate<='2014-08-26 22:40:26'::timestamp and u.views>=0;
