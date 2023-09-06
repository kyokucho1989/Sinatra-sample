# frozen_string_literal: true

require 'pg'


class Memo
  MEMO_SAVE_FILE = '.memo_data'
  private_constant :MEMO_SAVE_FILE
  attr_reader :id, :title, :content

  def initialize(**params)
    @title = params[:title]
    @content = params[:content]
  end

  def save
    conn = PG.connect( dbname: 'sinatra-db' )
    conn.exec_params( "INSERT INTO memotable VALUES (nextval('id'), '#{@title}', '#{@content}')" )
    memo_data = conn.exec('SELECT lastval()')
    @id = memo_data.first['lastval'].to_i
  end

  class << self
    def all
      conn = PG.connect( dbname: 'sinatra-db' )
      memo_data = conn.exec( "SELECT * FROM memotable" )
    end

    def find(id)
      conn = PG.connect( dbname: 'sinatra-db' )
      memo_data = conn.exec( "SELECT * FROM memotable WHERE id = #{id}" )
      memo_data.first
    end

    def update(**params)
      conn = PG.connect( dbname: 'sinatra-db' )
      conn.exec( "UPDATE memotable SET title = '#{params['title']}', content = '#{params['content']}' WHERE id = #{params['id']}" )
    end

    def delete(id)
      conn = PG.connect( dbname: 'sinatra-db' )
      conn.exec( "DELETE FROM memotable WHERE id = #{id}" )
    end
  end

  private

  def to_h
    { id: @id, title: @title, content: @content }
  end
end
