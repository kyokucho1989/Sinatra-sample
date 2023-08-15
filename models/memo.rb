# frozen_string_literal: true

require 'pstore'

DB = PStore.new('.db_file')

# Memoのモデルクラス
class Memo
  attr_accessor :id, :title, :content

  def initialize(**params)
    @title = params[:title]
    @content = params[:content]
  end

  def self.all
    data = nil
    DB.transaction do
      data = DB.instance_variable_get(:@table)
    end
    data.delete('lastid'.to_s)
    data.values
  end

  def self.find(id)
    DB.transaction do
      DB[id.to_s]
    end
  end

  def save
    DB.transaction do
      DB['lastid'] = DB.instance_variable_get(:@table).empty? ? 1 : DB['lastid'] + 1
    end
    DB.transaction do
      new_id = DB['lastid']
      DB[new_id.to_s] = self
      DB[new_id.to_s].id = new_id
    end
  end

  def update(**params)
    DB.transaction do
      DB[id.to_s].title = params[:title]
      DB[id.to_s].content = params[:content]
    end
  end

  def delete
    DB.transaction do
      DB.delete(id.to_s)
    end
  end
end
