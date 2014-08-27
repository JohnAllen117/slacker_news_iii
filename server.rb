require "sinatra"
require "sinatra/reloader"
require "pg"
require "pry"
def db_connection
  begin
    connection = PG.connect(dbname: 'slacker_news')
    yield(connection)
  ensure
    connection.close
  end
end

def checker(thing)
  check_results = thing.split.grep(/[;()'"]/)


  if check_results
    return true
  else
    false
end

end



def validate_url(url)

  unless url.start_with?(("www.") || ("http://") || ("https://"))
    url = url.prepend("www.")
  end

  unless url.start_with?(("http://") || ("https://"))
    url = url.prepend("http://")
  end

  url_check = ""
  url_check = db_connection do |conn|
    conn.exec_params('SELECT * FROM articles
      WHERE url = $1;',[url])
  end

  url_check = url_check.ntuples


   if url_check == 0 && checker(url)
    url
  else
    redirect '/'
  end

end





get '/' do
  @articles = db_connection do |conn|
    conn.exec('SELECT * FROM articles;')
  end
  @articles
  erb :index
end

get '/comments/:articleid' do
  @article_id = params[:articleid]
  @comments = db_connection do |conn|
    conn.exec_params('SELECT * FROM comments WHERE article_id = $1;', [@article_id])
  end

  @articles = db_connection do |conn|
    conn.exec_params('SELECT title, url, id FROM articles WHERE id = $1;', [@article_id])
  end
  erb :comments
end

get '/submit' do
  erb :submit
end

post '/submit' do
  title = params["title_form"]
  url = params["url_form"]
  url = validate_url(url)

  db_connection do |conn|
    conn.exec_params('INSERT INTO articles(title,url,time)
               VALUES ($1,$2,now());',[title,url])
  end
  redirect '/'
end

post '/comments' do
  comment = params["comment_body"]
  article_id = params["article_id"].to_i

  db_connection do |conn|
    conn.exec_params('INSERT INTO comments(article_id,body,time)
               VALUES ($1,$2,now());',[article_id, comment])
  end


  redirect "/comments/#{article_id}"
end
