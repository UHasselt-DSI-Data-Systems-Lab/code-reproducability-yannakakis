select count(*) from dblp7, dblp1, dblp24, dblp20, dblp2, dblp23, dblp5 where dblp7.s = dblp1.s and dblp1.s = dblp24.s and dblp24.s = dblp20.s and dblp20.s = dblp2.s and dblp2.s = dblp23.s and dblp23.s = dblp5.s;