# frozen_string_literal: true

require 'sinatra/base'
require 'pry'
require_relative 'models/memo'

# アプリ本体のクラス
class MyApp < Sinatra::Base
  enable :method_override
  helpers do
    def escape_html(content)
      ERB::Util.html_escape(content)
    end
  end

  get '/' do
    redirect '/memos'
  end

  get '/memos' do
    @memos = Memo.all
    erb :index
  end

  get '/memos/new' do
    erb :new
  end

  post '/memos' do
    memo_params = params.slice(:title, :content)
    memo = Memo.new(**memo_params)
    memo.save
    redirect "/memos/#{memo.id}/create"
  end

  get '/memos/:id/create' do
    erb :create
  end

  get '/memos/:id' do
    @memo = Memo.find(params[:id])
    erb :show
  end

  get '/memos/:id/edit' do
    @memo = Memo.find(params[:id])
    erb :edit
  end

  patch '/memos/:id' do
    @memo = Memo.find(params[:id])
    @memo = Memo.update(**params)
    redirect "/memos/#{params[:id]}/update"
  end

  get '/memos/:id/update' do
    erb :update
  end

  delete '/memos/:id' do
    @memo = Memo.find(params[:id])
    Memo.delete(params[:id])
    redirect "/memos/#{params[:id]}/delete"
  end

  get '/memos/:id/delete' do
    erb :delete
  end
end

MyApp.run!
