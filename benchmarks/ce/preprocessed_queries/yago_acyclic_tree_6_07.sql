select count(*) from yago2_0, yago2_1, yago2_2, yago63, yago2_4, yago2_5 where yago2_0.s = yago2_1.s and yago2_1.s = yago2_2.s and yago2_0.d = yago2_4.d and yago2_1.d = yago63.s and yago2_2.d = yago2_5.d;