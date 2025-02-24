COPY Users FROM 'users.csv' csv escape '\' header;
COPY Posts FROM 'posts.csv' csv escape '\' header;
COPY PostLinks FROM 'postLinks.csv' csv escape '\' header;
COPY PostHistory FROM 'postHistory.csv' csv escape '\' header;
COPY Comments FROM 'comments.csv' csv escape '\' header;
COPY Votes FROM 'votes.csv' csv escape '\' header;
COPY Badges FROM 'badges.csv' csv escape '\' header;
COPY Tags FROM 'tags.csv' csv escape '\' header;
