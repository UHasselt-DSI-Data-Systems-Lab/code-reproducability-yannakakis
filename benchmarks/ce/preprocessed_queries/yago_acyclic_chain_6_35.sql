select count(*) from yago0, yago3, yago25, yago8, yago39 where yago0.d = yago3.d and yago3.s = yago25.s and yago25.d = yago8.d and yago8.s = yago39.s;