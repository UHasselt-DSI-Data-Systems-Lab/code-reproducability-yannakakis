SELECT COUNT(*) FROM ph, p, v, u WHERE p.Id = ph.PostId AND u.Id = p.OwnerUserId AND p.Id = v.PostId AND p.PostTypeId=1 AND p.Score>=-1 AND p.CommentCount>=0 AND p.CommentCount<=11;
