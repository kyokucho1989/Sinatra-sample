require 'sinatra'

get '/' do
  erb :index
end

get '/memos' do
  erb :index
end

get '/memos/new' do
  erb :new
  'メモ新規作成ページ'
end

post '/memos' do
  erb :create
  'メモを作成しました'
end

get '/memos/:id' do
  erb :show
  'メモ詳細'
end

get '/memos/:id/edit' do
  erb :edit
  'メモ編集'
end

patch '/memos/:id' do
  erb :update

end

delete '/memos/:id' do
  erb :delete

end

