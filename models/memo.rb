# frozen_string_literal: true

require 'pg'
DB_NAME = 'sinatra-db'
CONN = PG.connect(dbname: DB_NAME)

class Memo
  attr_reader :id, :title, :content

  def initialize(**params)
    @title = params[:title]
    @content = params[:content]
  end

  def save
    save_memo = { title: @title, content: @content }
    CONN.exec_params("INSERT INTO memotable VALUES (nextval('id'), $1, $2)", [save_memo[:title], save_memo[:content]])
    memo_data = CONN.exec('SELECT lastval()')
    @id = memo_data.first['lastval'].to_i
  end

  class << self
    def all
      all_memo_data = CONN.exec('SELECT * FROM memotable ORDER BY id')
      all_memo_data.map do |memo_data|
        convert_keys_to_symbol(memo_data)
      end
    end

    def find(id)
      memo_data = CONN.exec_params('SELECT * FROM memotable WHERE id = $1', [id])
      convert_keys_to_symbol(memo_data.first)
    end

    def update(**params)
      CONN.exec_params('UPDATE memotable SET title = $1, content = $2 WHERE id = $3', [params['title'], params['content'], params['id']])
    end

    def delete(id)
      CONN.exec('DELETE FROM memotable WHERE id = $1', [id])
    end

    def convert_keys_to_symbol(memo_data)
      memo_data.transform_keys!(&:to_sym)
      memo_data[:id] = memo_data[:id].to_i
      memo_data
    end
  end

  private

  def to_h
    { id: @id, title: @title, content: @content }
  end
end
