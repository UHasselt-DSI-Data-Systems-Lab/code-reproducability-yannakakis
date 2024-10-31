-- 1) Drop all tables if they exist
-- 2) Create all tables
-- 3) Load data from csv files into tables

DROP TABLE IF EXISTS an;
DROP TABLE IF EXISTS a1;
DROP TABLE IF EXISTS an1;
DROP TABLE IF EXISTS at;
DROP TABLE IF EXISTS ci;
DROP TABLE IF EXISTS chn;
DROP TABLE IF EXISTS cct1;
DROP TABLE IF EXISTS cct2;
DROP TABLE IF EXISTS cn;
DROP TABLE IF EXISTS cn1;
DROP TABLE IF EXISTS cn2;
DROP TABLE IF EXISTS ct;
DROP TABLE IF EXISTS cc;
DROP TABLE IF EXISTS it1;
DROP TABLE IF EXISTS it2;
DROP TABLE IF EXISTS it;
DROP TABLE IF EXISTS it3;
DROP TABLE IF EXISTS k;
DROP TABLE IF EXISTS kt;
DROP TABLE IF EXISTS kt1;
DROP TABLE IF EXISTS kt2;
DROP TABLE IF EXISTS lt;
DROP TABLE IF EXISTS mc;
DROP TABLE IF EXISTS mc1;
DROP TABLE IF EXISTS mc2;
DROP TABLE IF EXISTS mi_idx;
DROP TABLE IF EXISTS miidx;
DROP TABLE IF EXISTS mi_idx1;
DROP TABLE IF EXISTS mi_idx2;
DROP TABLE IF EXISTS mi;
DROP TABLE IF EXISTS mk;
DROP TABLE IF EXISTS ml;
DROP TABLE IF EXISTS n;
DROP TABLE IF EXISTS n1;
DROP TABLE IF EXISTS pi;
DROP TABLE IF EXISTS rt;
DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;


CREATE TABLE an (
    id integer NOT NULL ,
    person_id integer NOT NULL,
    name character varying,
    imdb_index character varying(3),
    name_pcode_cf character varying(11),
    name_pcode_nf character varying(11),
    surname_pcode character varying(11),
    md5sum character varying(65)
);
CREATE TABLE a1 (
    id integer NOT NULL ,
    person_id integer NOT NULL,
    name character varying,
    imdb_index character varying(3),
    name_pcode_cf character varying(11),
    name_pcode_nf character varying(11),
    surname_pcode character varying(11),
    md5sum character varying(65)
);
CREATE TABLE an1 (
    id integer NOT NULL ,
    person_id integer NOT NULL,
    name character varying,
    imdb_index character varying(3),
    name_pcode_cf character varying(11),
    name_pcode_nf character varying(11),
    surname_pcode character varying(11),
    md5sum character varying(65)
);

CREATE TABLE at (
    id integer NOT NULL ,
    movie_id integer NOT NULL,
    title character varying,
    imdb_index character varying(4),
    kind_id integer NOT NULL,
    production_year integer,
    phonetic_code character varying(5),
    episode_of_id integer,
    season_nr integer,
    episode_nr integer,
    note character varying(72),
    md5sum character varying(32)
);

CREATE TABLE ci (
    id integer NOT NULL ,
    person_id integer NOT NULL,
    movie_id integer NOT NULL,
    person_role_id integer,
    note character varying,
    nr_order integer,
    role_id integer NOT NULL
);

CREATE TABLE chn (
    id integer NOT NULL ,
    name character varying NOT NULL,
    imdb_index character varying(2),
    imdb_id integer,
    name_pcode_nf character varying(5),
    surname_pcode character varying(5),
    md5sum character varying(32)
);

CREATE TABLE cct1 (
    id integer NOT NULL ,
    kind character varying(32) NOT NULL
);
CREATE TABLE cct2 (
    id integer NOT NULL ,
    kind character varying(32) NOT NULL
);

CREATE TABLE cn (
    id integer NOT NULL ,
    name character varying NOT NULL,
    country_code character varying(6),
    imdb_id integer,
    name_pcode_nf character varying(5),
    name_pcode_sf character varying(5),
    md5sum character varying(32)
);
CREATE TABLE cn1 (
    id integer NOT NULL ,
    name character varying NOT NULL,
    country_code character varying(6),
    imdb_id integer,
    name_pcode_nf character varying(5),
    name_pcode_sf character varying(5),
    md5sum character varying(32)
);
CREATE TABLE cn2 (
    id integer NOT NULL ,
    name character varying NOT NULL,
    country_code character varying(6),
    imdb_id integer,
    name_pcode_nf character varying(5),
    name_pcode_sf character varying(5),
    md5sum character varying(32)
);

CREATE TABLE ct (
    id integer NOT NULL ,
    kind character varying(32)
);

CREATE TABLE cc (
    id integer NOT NULL ,
    movie_id integer,
    subject_id integer NOT NULL,
    status_id integer NOT NULL
);

CREATE TABLE it1 (
    id integer NOT NULL ,
    info character varying(32) NOT NULL
);
CREATE TABLE it2 (
    id integer NOT NULL ,
    info character varying(32) NOT NULL
);
CREATE TABLE it (
    id integer NOT NULL ,
    info character varying(32) NOT NULL
);
CREATE TABLE it3 (
    id integer NOT NULL ,
    info character varying(32) NOT NULL
);

CREATE TABLE k (
    id integer NOT NULL ,
    keyword character varying NOT NULL,
    phonetic_code character varying(5)
);

CREATE TABLE kt (
    id integer NOT NULL ,
    kind character varying(15)
);
CREATE TABLE kt1 (
    id integer NOT NULL ,
    kind character varying(15)
);
CREATE TABLE kt2 (
    id integer NOT NULL ,
    kind character varying(15)
);

CREATE TABLE lt (
    id integer NOT NULL ,
    link character varying(32) NOT NULL
);

CREATE TABLE mc (
    id integer NOT NULL ,
    movie_id integer NOT NULL,
    company_id integer NOT NULL,
    company_type_id integer NOT NULL,
    note character varying
);
CREATE TABLE mc1 (
    id integer NOT NULL ,
    movie_id integer NOT NULL,
    company_id integer NOT NULL,
    company_type_id integer NOT NULL,
    note character varying
);
CREATE TABLE mc2 (
    id integer NOT NULL ,
    movie_id integer NOT NULL,
    company_id integer NOT NULL,
    company_type_id integer NOT NULL,
    note character varying
);

CREATE TABLE mi_idx (
    id integer NOT NULL ,
    movie_id integer NOT NULL,
    info_type_id integer NOT NULL,
    info character varying NOT NULL,
    note character varying(1)
);
CREATE TABLE miidx (
    id integer NOT NULL ,
    movie_id integer NOT NULL,
    info_type_id integer NOT NULL,
    info character varying NOT NULL,
    note character varying(1)
);
CREATE TABLE mi_idx1 (
    id integer NOT NULL ,
    movie_id integer NOT NULL,
    info_type_id integer NOT NULL,
    info character varying NOT NULL,
    note character varying(1)
);
CREATE TABLE mi_idx2 (
    id integer NOT NULL ,
    movie_id integer NOT NULL,
    info_type_id integer NOT NULL,
    info character varying NOT NULL,
    note character varying(1)
);

CREATE TABLE mk (
    id integer NOT NULL ,
    movie_id integer NOT NULL,
    keyword_id integer NOT NULL
);

CREATE TABLE ml (
    id integer NOT NULL ,
    movie_id integer NOT NULL,
    linked_movie_id integer NOT NULL,
    link_type_id integer NOT NULL
);

CREATE TABLE n (
    id integer NOT NULL ,
    name character varying NOT NULL,
    imdb_index character varying(9),
    imdb_id integer,
    gender character varying(1),
    name_pcode_cf character varying(5),
    name_pcode_nf character varying(5),
    surname_pcode character varying(5),
    md5sum character varying(32)
);
CREATE TABLE n1 (
    id integer NOT NULL ,
    name character varying NOT NULL,
    imdb_index character varying(9),
    imdb_id integer,
    gender character varying(1),
    name_pcode_cf character varying(5),
    name_pcode_nf character varying(5),
    surname_pcode character varying(5),
    md5sum character varying(32)
);

CREATE TABLE rt (
    id integer NOT NULL ,
    role character varying(32) NOT NULL
);

CREATE TABLE t (
    id integer NOT NULL ,
    title character varying NOT NULL,
    imdb_index character varying(5),
    kind_id integer NOT NULL,
    production_year integer,
    imdb_id integer,
    phonetic_code character varying(5),
    episode_of_id integer,
    season_nr integer,
    episode_nr integer,
    series_years character varying(49),
    md5sum character varying(32)
);
CREATE TABLE t1 (
    id integer NOT NULL ,
    title character varying NOT NULL,
    imdb_index character varying(5),
    kind_id integer NOT NULL,
    production_year integer,
    imdb_id integer,
    phonetic_code character varying(5),
    episode_of_id integer,
    season_nr integer,
    episode_nr integer,
    series_years character varying(49),
    md5sum character varying(32)
);
CREATE TABLE t2 (
    id integer NOT NULL ,
    title character varying NOT NULL,
    imdb_index character varying(5),
    kind_id integer NOT NULL,
    production_year integer,
    imdb_id integer,
    phonetic_code character varying(5),
    episode_of_id integer,
    season_nr integer,
    episode_nr integer,
    series_years character varying(49),
    md5sum character varying(32)
);

CREATE TABLE mi (
    id integer NOT NULL ,
    movie_id integer NOT NULL,
    info_type_id integer NOT NULL,
    info character varying NOT NULL,
    note character varying
);

CREATE TABLE pi (
    id integer NOT NULL ,
    person_id integer NOT NULL,
    info_type_id integer NOT NULL,
    info character varying NOT NULL,
    note character varying
);

COPY an FROM 'data/aka_name.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY a1 FROM 'data/aka_name.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY an1 FROM 'data/aka_name.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY at FROM 'data/aka_title.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY ci FROM 'data/cast_info.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY chn FROM 'data/char_name.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY cn FROM 'data/company_name.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY cn1 FROM 'data/company_name.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY cn2 FROM 'data/company_name.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY ct FROM 'data/company_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY cct1 FROM 'data/comp_cast_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY cct2 FROM 'data/comp_cast_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY cc FROM 'data/complete_cast.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY it1 FROM 'data/info_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY it2 FROM 'data/info_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY it FROM 'data/info_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY it3 FROM 'data/info_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY k FROM 'data/keyword.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY kt FROM 'data/kind_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY kt1 FROM 'data/kind_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY kt2 FROM 'data/kind_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY lt FROM 'data/link_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY mc FROM 'data/movie_companies.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY mc1 FROM 'data/movie_companies.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY mc2 FROM 'data/movie_companies.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY mi FROM 'data/movie_info.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY mi_idx FROM 'data/movie_info_idx.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY miidx FROM 'data/movie_info_idx.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY mi_idx1 FROM 'data/movie_info_idx.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY mi_idx2 FROM 'data/movie_info_idx.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY mk FROM 'data/movie_keyword.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY ml FROM 'data/movie_link.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY n FROM 'data/name.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY n1 FROM 'data/name.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY pi FROM 'data/person_info.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY rt FROM 'data/role_type.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY t FROM 'data/title.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY t1 FROM 'data/title.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
COPY t2 FROM 'data/title.csv' (DELIMITER ',', QUOTE '"', ESCAPE '\');
