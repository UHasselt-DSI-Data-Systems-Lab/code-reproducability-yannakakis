SELECT COUNT(*) FROM t, p, u, v, b WHERE p.Id = t.ExcerptPostId AND u.Id = v.UserId AND u.Id = b.UserId AND u.Id = p.OwnerUserId AND u.DownVotes>=0;
