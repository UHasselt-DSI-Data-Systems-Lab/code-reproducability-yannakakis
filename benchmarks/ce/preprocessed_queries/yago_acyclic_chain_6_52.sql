select count(*) from yago21, yago5, yago58, yago50_3, yago50_4, yago39 where yago21.d = yago5.d and yago5.s = yago58.d and yago58.s = yago50_3.s and yago50_3.d = yago50_4.d and yago50_4.s = yago39.s;