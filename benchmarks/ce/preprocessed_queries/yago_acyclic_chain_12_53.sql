select count(*) from yago0_0, yago3, yago46, yago5, yago1, yago0_5, yago0_6, yago2_7, yago2_8, yago2_9, yago2_10, yago0_11 where yago0_0.d = yago1.d and yago3.s = yago46.d and yago3.d = yago0_11.d and yago46.s = yago5.s and yago1.s = yago0_5.s and yago0_5.d = yago0_6.d and yago0_6.s = yago2_7.d and yago2_7.s = yago2_8.s and yago2_8.d = yago2_9.d and yago2_9.s = yago2_10.s and yago2_10.d = yago0_11.s;