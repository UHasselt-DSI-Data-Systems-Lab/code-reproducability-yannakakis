select count(*) from dblp25, dblp24, dblp5, dblp20, dblp2, dblp9, dblp8, dblp17 where dblp25.s = dblp24.s and dblp24.s = dblp5.s and dblp5.s = dblp20.s and dblp20.s = dblp2.s and dblp2.s = dblp9.s and dblp9.s = dblp8.s and dblp8.d = dblp17.s;