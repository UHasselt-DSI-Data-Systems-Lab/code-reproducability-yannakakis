select count(*) from dblp19, dblp25, dblp1, dblp2, dblp21, dblp23 where dblp19.s = dblp25.s and dblp25.d = dblp1.d and dblp1.s = dblp2.s and dblp2.d = dblp21.s and dblp21.d = dblp23.s;