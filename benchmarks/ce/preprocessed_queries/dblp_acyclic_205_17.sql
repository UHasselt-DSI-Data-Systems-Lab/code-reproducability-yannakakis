select count(*) from dblp23, dblp1, dblp25, dblp9, dblp5, dblp8 where dblp23.s = dblp1.s and dblp1.d = dblp25.d and dblp25.s = dblp9.s and dblp9.d = dblp5.s and dblp5.d = dblp8.s;