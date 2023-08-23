# frozen_string_literal: true

require 'pstore'
File.new('.db_file', 'w') unless File.exist?('.db_file')

# Memoのモデルクラス
class Memo
  attr_accessor :id, :title, :content

  def initialize(**params)
    @title = params[:title]
    @content = params[:content]
  end

  def marshal_dump
    { id: @id, title: @title, content: @content }
  end

  def marshal_load(data)
    @id = data[:id]
    @title = data[:title]
    @content = data[:content]
  end

  def to_h
    { id: self.id, title: @title, content: @content }
  end

  def self.all
    if File.size?('.db_file')
      loaded_file = JSON.parse(File.read('.db_file'), symbolize_names: true)
      loaded_file[:value]
    else
      []
    end
  end

  def self.find(id)
    loaded_data = JSON.parse(File.read('.db_file'), symbolize_names: true)
    selected_record = loaded_data[:value].select { |hash| hash[:id] == id.to_i }
    selected_record.first
  end

  def save
    if File.size?('.db_file')
      loaded_data = JSON.parse(File.read('.db_file'), symbolize_names: true)
    else
      loaded_data = {last_id: 0, value: []}
    end
    self.id = loaded_data[:last_id] + 1
    loaded_data[:last_id] = id
    loaded_data[:value] << self.to_h
    File.open('.db_file', 'w') do |file|
      file.write(JSON.dump(loaded_data))
    end
  end

  def self.update(**params)
    loaded_data = JSON.parse(File.read('.db_file'), symbolize_names: true)
    index = loaded_data[:value].index { |hash| hash[:id] == params['id'].to_i }
    loaded_data[:value][index]['title'] = params['title']
    loaded_data[:value][index]['content'] = params['content']
    File.open('.db_file', 'w') do |file|
      file.write(JSON.dump(loaded_data))
    end
  end

  def self.delete(id)
    loaded_data = JSON.parse(File.read('.db_file'), symbolize_names: true)
    loaded_data[:value].delete_if { |hash| hash[:id] == id.to_i }
    File.open('.db_file', 'w') do |file|
      file.write(JSON.dump(loaded_data))
    end
  end
end
