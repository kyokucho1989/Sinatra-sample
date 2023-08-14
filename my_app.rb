require 'sinatra'
require 'pry'
require_relative './models/memo'
require 'sinatra/base'

require 'erb'

class MyApp < Sinatra::Base
  enable :method_override
  helpers do
    include ERB::Util

    def escape_html(content)
      html_escape(content)
    end
  end
  # helpers Sinatra::HTMLEscapeHelper
  get '/' do
    @memos = Memo.all
    erb :index,layout: :layout
  end

  get '/memos' do
    @memos = Memo.all
    erb :index , layout: :layout
  end

  get '/memos/new' do
    erb :new , layout: :layout
  end

  post '/memos' do
    memo_param = params.slice(:title, :content)
    memo = Memo.new(**memo_param)
    memo.save
    erb :create
  end

  get '/memos/:id' do
    @memo = Memo.find(params[:id])
    erb :show , layout: :layout
  end

  get '/memos/:id/edit' do
    @memo = Memo.find(params[:id])
    erb :edit
  end

  patch '/memos/:id' do
    @memo = Memo.find(params[:id])
    @memo.update(**{title: params[:title], content: params[:content]})
    erb :update

  end

  delete '/memos/:id' do
    @memo = Memo.find(params[:id])
    @memo.delete
    erb :delete
  end
end

MyApp.run!
