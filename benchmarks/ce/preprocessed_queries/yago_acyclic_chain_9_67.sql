select count(*) from yago5_0, yago29_1, yago29_2, yago36, yago55, yago50, yago8, yago25, yago5_8 where yago5_0.s = yago29_1.s and yago29_1.d = yago29_2.d and yago29_2.s = yago36.d and yago36.s = yago55.s and yago55.d = yago50.d and yago50.s = yago8.s and yago8.d = yago25.d and yago25.s = yago5_8.s;