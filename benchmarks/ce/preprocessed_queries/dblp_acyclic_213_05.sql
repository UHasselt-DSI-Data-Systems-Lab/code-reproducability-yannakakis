select count(*) from dblp18, dblp9, dblp23, dblp20, dblp22, dblp24, dblp21, dblp25 where dblp18.s = dblp9.s and dblp9.s = dblp23.s and dblp23.s = dblp20.s and dblp20.s = dblp22.s and dblp22.s = dblp24.s and dblp24.s = dblp21.s and dblp21.d = dblp25.s;