select count(*) from c, p, ph where p.id = c.postid and p.id = ph.postid and p.commentcount>=0 and p.commentcount<=25;
