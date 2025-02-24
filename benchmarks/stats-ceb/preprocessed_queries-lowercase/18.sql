select count(*) from p, pl, ph where p.id = pl.postid and pl.postid = ph.postid and p.creationdate>='2010-07-19 20:08:37'::timestamp and ph.creationdate>='2010-07-20 00:30:00'::timestamp;
