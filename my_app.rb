# myapp.rb
require 'sinatra'

get '/' do
  'Hello world!'
end

get '/memos' do
  'メモ一覧ページ'
end

get '/memos/new' do
  'メモ新規作成ページ'
end

post '/memos' do
  'メモを作成しました'
end

get '/memos/:id' do
  'メモ詳細'
end

get '/memos/:id/edit' do
  'メモ編集'
end

patch '/memos/:id' do
  'メモ更新'
end

delete '/memos/:id' do
  'メモ削除'
end

