select count(*) from yago6_0, yago11, yago6_2, yago6_3, yago2_4, yago2_5 where yago6_0.s = yago11.s and yago11.s = yago6_2.s and yago6_2.s = yago6_3.s and yago6_3.s = yago2_4.d and yago2_4.d = yago2_5.d;