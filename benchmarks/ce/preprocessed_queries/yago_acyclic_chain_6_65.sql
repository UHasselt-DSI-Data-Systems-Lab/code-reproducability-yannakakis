select count(*) from yago2_0, yago2_1, yago2_2, yago2_3, yago13, yago39 where yago2_0.s = yago2_1.s and yago2_1.d = yago2_2.d and yago2_2.s = yago2_3.s and yago2_3.d = yago13.d and yago13.s = yago39.s;