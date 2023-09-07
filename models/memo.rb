# frozen_string_literal: true

require 'pg'

class Memo
  DB_NAME = 'sinatra-db'
  private_constant :DB_NAME
  attr_reader :id, :title, :content

  def initialize(**params)
    @title = params[:title]
    @content = params[:content]
  end

  def save
    conn = PG.connect(dbname: DB_NAME)
    conn.exec_params("INSERT INTO memotable VALUES (nextval('id'), $1, $2)", [@title, @content])
    memo_data = conn.exec('SELECT lastval()')
    @id = memo_data.first['lastval'].to_i
  end

  class << self
    def all
      conn = PG.connect(dbname: DB_NAME)
      conn.exec('SELECT * FROM memotable ORDER BY id')
    end

    def find(id)
      conn = PG.connect(dbname: DB_NAME)
      memo_data = conn.exec_params('SELECT * FROM memotable WHERE id = $1', [id])
      memo_data.first
    end

    def update(**params)
      conn = PG.connect(dbname: DB_NAME)
      conn.exec_params('UPDATE memotable SET title = $1, content = $2 WHERE id = $3', [params['title'], params['content'], params['id']])
    end

    def delete(id)
      conn = PG.connect(dbname: DB_NAME)
      conn.exec("DELETE FROM memotable WHERE id = #{id}")
    end
  end

  private

  def to_h
    { id: @id, title: @title, content: @content }
  end
end
