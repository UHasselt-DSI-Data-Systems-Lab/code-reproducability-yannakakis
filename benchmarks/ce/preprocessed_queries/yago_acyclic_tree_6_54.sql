select count(*) from yago2_0, yago2_1, yago48_2, yago36, yago5, yago48_5 where yago2_0.s = yago2_1.s and yago2_1.d = yago48_2.s and yago48_2.s = yago36.s and yago48_2.d = yago5.d and yago5.d = yago48_5.d;