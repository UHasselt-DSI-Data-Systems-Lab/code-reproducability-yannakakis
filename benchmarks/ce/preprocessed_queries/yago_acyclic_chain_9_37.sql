select count(*) from yago0, yago1, yago17, yago46, yago53, yago36, yago2_6, yago2_7, yago25 where yago0.d = yago1.d and yago1.s = yago17.d and yago17.s = yago46.d and yago46.s = yago53.s and yago53.d = yago36.d and yago36.s = yago2_6.d and yago2_6.s = yago2_7.s and yago2_7.d = yago25.s;