select count(*) from dblp4, dblp2, dblp6, dblp21, dblp23, dblp24 where dblp4.s = dblp2.s and dblp2.s = dblp6.s and dblp6.s = dblp21.s and dblp21.s = dblp23.s and dblp23.s = dblp24.s;