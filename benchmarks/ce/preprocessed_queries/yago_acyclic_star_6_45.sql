select count(*) from yago39_0, yago8, yago6, yago39_3, yago39_4, yago2 where yago39_0.s = yago8.s and yago8.s = yago6.s and yago6.s = yago39_3.s and yago39_3.s = yago39_4.s and yago39_4.s = yago2.d;