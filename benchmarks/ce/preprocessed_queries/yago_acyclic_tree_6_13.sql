select count(*) from yago52, yago6, yago0_2, yago5, yago39, yago0_5 where yago52.s = yago6.s and yago52.d = yago0_2.d and yago0_2.d = yago0_5.d and yago0_2.s = yago5.d and yago5.s = yago39.s;