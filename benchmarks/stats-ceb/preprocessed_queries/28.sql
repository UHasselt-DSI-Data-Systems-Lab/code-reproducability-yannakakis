SELECT COUNT(*) FROM v, p, b, u WHERE p.Id = v.PostId AND u.Id = p.OwnerUserId AND u.Id = b.UserId AND p.Score<=22 AND u.Reputation>=1;
