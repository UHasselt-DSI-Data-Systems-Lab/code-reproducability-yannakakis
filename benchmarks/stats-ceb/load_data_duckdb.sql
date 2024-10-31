-- 1) Drop all tables if they exist
-- 2) Create all tables
-- 3) Load data from csv files into tables


DROP TABLE IF EXISTS u;
DROP TABLE IF EXISTS p;
DROP TABLE IF EXISTS pl;
DROP TABLE IF EXISTS ph;
DROP TABLE IF EXISTS c;
DROP TABLE IF EXISTS v;
DROP TABLE IF EXISTS b;
DROP TABLE IF EXISTS t;

-- in the original repository, the type of all id columns is SERIAL
-- since DuckDB does not support SERIAL, and the data already has an id assigned to every row, 
-- we replace SERIAL with INTEGER (both types take 4 bytes)

-- Users
CREATE TABLE u (
Id INTEGER,
Reputation INTEGER ,
CreationDate TIMESTAMP ,
Views INTEGER ,
UpVotes INTEGER ,
DownVotes INTEGER
);

-- Posts
CREATE TABLE p (
	Id INTEGER,
	PostTypeId SMALLINT ,
	CreationDate TIMESTAMP ,
	Score INTEGER ,
	ViewCount INTEGER,
	OwnerUserId INTEGER,
  AnswerCount INTEGER ,
  CommentCount INTEGER ,
  FavoriteCount INTEGER,
  LastEditorUserId INTEGER
);

-- PostLinks
CREATE TABLE pl (
	Id INTEGER,
	CreationDate TIMESTAMP ,
	PostId INTEGER ,
	RelatedPostId INTEGER ,
	LinkTypeId SMALLINT
);

-- PostHistory
CREATE TABLE ph (
	Id INTEGER,
	PostHistoryTypeId SMALLINT ,
	PostId INTEGER ,
	CreationDate TIMESTAMP ,
	UserId INTEGER
);

-- Comments
CREATE TABLE c (
	Id INTEGER,
	PostId INTEGER ,
	Score SMALLINT ,
  CreationDate TIMESTAMP ,
	UserId INTEGER
);

-- Votes
CREATE TABLE v (
	Id INTEGER,
	PostId INTEGER,
	VoteTypeId SMALLINT ,
	CreationDate TIMESTAMP ,
	UserId INTEGER,
	BountyAmount SMALLINT
);

-- Badges
CREATE TABLE b (
	Id INTEGER,
	UserId INTEGER ,
	Date TIMESTAMP
);

-- Tags
CREATE TABLE t (
	Id INTEGER,
	Count INTEGER ,
	ExcerptPostId INTEGER
);

COPY u FROM 'data/users.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY p FROM 'data/posts.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY pl FROM 'data/postLinks.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY ph FROM 'data/postHistory.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY c FROM 'data/comments.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY v FROM 'data/votes.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY b FROM 'data/badges.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY t FROM 'data/tags.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
