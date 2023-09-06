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
    memo_data = JSON.parse(File.read(MEMO_SAVE_FILE), symbolize_names: true)
    @id = memo_data[:last_id] + 1
    memo_data[:last_id] = id
    memo_data[:memo_list] << to_h
    File.open(MEMO_SAVE_FILE, 'w') { |file| file.write(JSON.dump(memo_data)) }
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
      memo_data = JSON.parse(File.read(MEMO_SAVE_FILE), symbolize_names: true)
      memo_data[:memo_list].delete_if { |memo| memo[:id] == id.to_i }
      File.open(MEMO_SAVE_FILE, 'w') { |file| file.write(JSON.dump(memo_data)) }
    end
  end

  private

  def to_h
    { id: @id, title: @title, content: @content }
  end
end
