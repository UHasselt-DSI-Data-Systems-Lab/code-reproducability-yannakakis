select count(*) from yago17_0, yago17_1, yago2_2, yago2_3, yago0_4, yago0_5, yago1, yago0_7, yago36 where yago17_0.d = yago17_1.d and yago17_1.s = yago2_2.d and yago2_2.s = yago2_3.s and yago2_3.d = yago0_4.s and yago0_4.d = yago0_5.d and yago0_5.s = yago1.s and yago1.d = yago0_7.d and yago0_7.s = yago36.s;