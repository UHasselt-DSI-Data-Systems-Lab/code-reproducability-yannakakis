select count(*) from yago8_0, yago1, yago8_2, yago25, yago2_4, yago2_5 where yago8_0.s = yago1.s and yago1.s = yago8_2.s and yago8_2.s = yago25.s and yago25.s = yago2_4.d and yago2_4.d = yago2_5.d;