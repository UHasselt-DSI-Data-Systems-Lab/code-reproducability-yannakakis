select count(*) from dblp8, dblp5, dblp9, dblp7, dblp1, dblp25, dblp21 where dblp8.s = dblp5.s and dblp5.s = dblp9.s and dblp9.s = dblp7.s and dblp7.s = dblp1.s and dblp1.s = dblp25.s and dblp25.d = dblp21.s;