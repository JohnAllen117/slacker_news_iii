CREATE TABLE articles (
  id serial PRIMARY KEY,
  title varchar(255) NOT NULL,
  url varchar(255) NOT NULL,
  description varchar(255) NOT NULL,
);

CREATE TABLE comments (
  id serial PRIMARY KEY,
  body varchar(1000) NOT NULL,
  username varchar(255) NOT NULL,
  time datetime NOT NULL,
);
