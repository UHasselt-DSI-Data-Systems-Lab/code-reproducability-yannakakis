SELECT COUNT(*) FROM c, v, u, p WHERE c.PostId = p.Id AND u.Id = c.UserId AND v.PostId = p.Id AND c.Score=0 AND u.Views>=0 AND u.Views<=74;
