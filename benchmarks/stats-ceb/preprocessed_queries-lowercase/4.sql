select count(*) from c, ph where c.userid = ph.userid and ph.posthistorytypeid=1 and ph.creationdate>='2010-09-14 11:59:07'::timestamp;
