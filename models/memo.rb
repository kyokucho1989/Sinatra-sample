# frozen_string_literal: true

FILE_NAME = '.memo_data'
File.new(FILE_NAME, 'w') unless File.exist?(FILE_NAME)

# Memoのモデルクラス
class Memo
  attr_reader :id, :title, :content

  def initialize(**params)
    @title = params[:title]
    @content = params[:content]
  end

  def to_h
    { id: @id, title: @title, content: @content }
  end

  def self.all
    if File.size?(FILE_NAME)
      loaded_data = JSON.parse(File.read(FILE_NAME), symbolize_names: true)
      loaded_data[:memo_data]
    else
      []
    end
  end

  def self.find(id)
    loaded_data = JSON.parse(File.read(FILE_NAME), symbolize_names: true)
    loaded_data[:memo_data].find { |record| record[:id] == id.to_i }
  end

  def save
    loaded_data = if File.size?(FILE_NAME)
                    JSON.parse(File.read(FILE_NAME), symbolize_names: true)
                  else
                    { last_id: 0, memo_data: [] }
                  end
    @id = loaded_data[:last_id] + 1
    loaded_data[:last_id] = id
    loaded_data[:memo_data] << to_h
    File.open(FILE_NAME, 'w') { |file| file.write(JSON.dump(loaded_data)) }
  end

  def self.update(**params)
    loaded_data = JSON.parse(File.read(FILE_NAME), symbolize_names: true)
    index = loaded_data[:memo_data].index do |hash|
      hash[:id] == params['id'].to_i
    end
    data_to_update = loaded_data[:memo_data][index]
    data_to_update[:title] = params['title']
    data_to_update[:content] = params['content']
    File.open(FILE_NAME, 'w') { |file| file.write(JSON.dump(loaded_data)) }
  end

  def self.delete(id)
    loaded_data = JSON.parse(File.read(FILE_NAME), symbolize_names: true)
    loaded_data[:memo_data].delete_if { |hash| hash[:id] == id.to_i }
    File.open(FILE_NAME, 'w') { |file| file.write(JSON.dump(loaded_data)) }
  end
end
