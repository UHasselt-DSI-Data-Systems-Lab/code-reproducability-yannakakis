select count(*) from yago2_0, yago2_1, yago1, yago0, yago2_4, yago2_5, yago22_6, yago22_7, yago54 where yago2_0.s = yago2_1.s and yago2_1.d = yago1.s and yago1.d = yago0.d and yago0.s = yago2_4.d and yago2_4.s = yago2_5.s and yago2_5.d = yago22_6.s and yago22_6.d = yago22_7.d and yago22_7.s = yago54.d;