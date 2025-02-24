select count(*) from c, ph where c.userid = ph.userid and c.score=0 and ph.posthistorytypeid=1;
