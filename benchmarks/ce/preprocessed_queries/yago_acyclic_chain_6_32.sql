select count(*) from yago2_0, yago2_1, yago0_2, yago0_3, yago31, yago29 where yago2_0.s = yago2_1.s and yago2_1.d = yago0_2.s and yago0_2.d = yago0_3.d and yago0_3.s = yago31.s and yago31.d = yago29.s;