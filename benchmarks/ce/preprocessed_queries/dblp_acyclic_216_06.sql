select count(*) from dblp1, dblp12, dblp2, dblp21, dblp5, dblp25, dblp19, dblp8 where dblp1.d = dblp12.d and dblp12.s = dblp2.s and dblp2.d = dblp21.s and dblp21.d = dblp5.d and dblp5.s = dblp25.s and dblp25.s = dblp19.s and dblp19.s = dblp8.s;