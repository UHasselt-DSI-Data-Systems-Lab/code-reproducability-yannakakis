select count(*) from dblp21, dblp5, dblp24, dblp8, dblp22, dblp25, dblp1, dblp23 where dblp21.d = dblp5.d and dblp5.d = dblp24.s and dblp24.s = dblp8.s and dblp8.s = dblp22.s and dblp22.s = dblp25.s and dblp25.s = dblp1.s and dblp1.s = dblp23.s;