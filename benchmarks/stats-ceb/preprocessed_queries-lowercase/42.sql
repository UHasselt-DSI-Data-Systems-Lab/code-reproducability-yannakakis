select count(*) from ph, p, v, u where p.id = ph.postid and u.id = p.owneruserid and p.id = v.postid and p.posttypeid=1 and p.score>=-1 and p.commentcount>=0 and p.commentcount<=11;
