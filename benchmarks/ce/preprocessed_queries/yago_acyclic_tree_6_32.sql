select count(*) from yago2_0, yago2_1, yago2_2, yago2_3, yago2_4, yago25 where yago2_0.s = yago2_1.s and yago2_1.s = yago2_2.s and yago2_0.d = yago2_3.d and yago2_3.s = yago2_4.s and yago2_4.d = yago25.s;