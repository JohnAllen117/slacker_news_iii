require "sinatra"
require "sinatra/reloader"
require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: 'slacker_news')
    yield(connection)
  ensure
    connection.close
  end
end

def find_articles
  serialized_articles = redis.lrange("slacker:articles", 0, -1)

  articles = []

  serialized_articles.each do |article|
    articles << JSON.parse(article, symbolize_names: true)
  end

  articles
end

get '/' do
  @submission = find_articles
  erb :index
end

get '/submit' do
  erb :submit
end

post '/submit' do
  title = params["title_form"]
  url = params["url_form"]
  description = params["description_form"]

  redirect '/'
end
