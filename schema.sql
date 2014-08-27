CREATE TABLE articles (
  id serial PRIMARY KEY,
  title varchar(255) NOT NULL,
  url varchar(255) NOT NULL,
  time timestamp NOT NULL
);

CREATE TABLE comments (
  id serial PRIMARY KEY,
  body varchar(1000) NOT NULL,
  username varchar(255),
  time timestamp NOT NULL,
  article_id int NOT NULL
);
