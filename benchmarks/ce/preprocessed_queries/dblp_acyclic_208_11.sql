select count(*) from dblp25, dblp8, dblp7, dblp17, dblp9, dblp1, dblp23 where dblp25.s = dblp8.s and dblp8.s = dblp7.s and dblp7.s = dblp17.s and dblp17.d = dblp9.s and dblp9.d = dblp1.s and dblp1.s = dblp23.s;