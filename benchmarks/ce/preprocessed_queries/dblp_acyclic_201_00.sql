select count(*) from dblp20, dblp17, dblp25, dblp5, dblp8, dblp1 where dblp20.s = dblp17.s and dblp17.s = dblp25.s and dblp25.s = dblp5.s and dblp5.s = dblp8.s and dblp8.s = dblp1.s;