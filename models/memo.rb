# frozen_string_literal: true

require 'pstore'
unless File.exist?('.db_file')
  File.new('.db_file', "w")
end

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

  def self.all
    if File.size?('.db_file')
      loaded_file = Marshal.load(File.read('.db_file'))
      loaded_file[:value]
    else  
      []
    end
  end

  def self.find(id)
    loaded_file = Marshal.load(File.read('.db_file'))
    selected_record = loaded_file[:value].select {|hash| hash.id == id.to_i}
    selected_record.first
  end

  def save
    if File.size?('.db_file')
      data = Marshal.load(File.read('.db_file'))
    else
      data = {}
      data[:last_id] = 0
      data[:value] = []
    end
    self.id = data[:last_id] + 1
    data[:last_id] = self.id
    data[:value] << self
    File.open('.db_file', 'w') do |file|
      file.write(Marshal.dump(data))
    end
  end

  def update(**params)
    loaded_file = Marshal.load(File.read('.db_file'))
    index = loaded_file[:value].index {|hash| hash.id == params['id'].to_i}
    loaded_file[:value][index].title = params['title']
    loaded_file[:value][index].content = params['content']
    File.open('.db_file', 'w') do |file|
      file.write(Marshal.dump(loaded_file))
    end
  end

  def delete
    loaded_file = Marshal.load(File.read('.db_file'))
    loaded_file[:value].delete_if {|hash| hash.id == id}
    File.open('.db_file', 'w') do |file|
      file.write(Marshal.dump(loaded_file))
    end
  end
end
