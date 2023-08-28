# frozen_string_literal: true

FILE_NAME_FOR_SAVE = '.memo_data'
File.new(FILE_NAME_FOR_SAVE, 'w') unless File.exist?(FILE_NAME_FOR_SAVE)

# Memoのモデルクラス
class Memo
  attr_reader :id, :title, :content

  def initialize(**params)
    @title = params[:title]
    @content = params[:content]
  end

  def save
    memo_data = if File.size?(FILE_NAME_FOR_SAVE)
                  JSON.parse(File.read(FILE_NAME_FOR_SAVE), symbolize_names: true)
                else
                  { last_id: 0, memo_data: [] }
                end
    @id = memo_data[:last_id] + 1
    memo_data[:last_id] = id
    memo_data[:memo_data] << to_h
    File.open(FILE_NAME_FOR_SAVE, 'w') { |file| file.write(JSON.dump(memo_data)) }
  end

  class << self
    def all
      if File.size?(FILE_NAME_FOR_SAVE)
        memo_data = JSON.parse(File.read(FILE_NAME_FOR_SAVE), symbolize_names: true)
        memo_data[:memo_data]
      else
        []
      end
    end

    def find(id)
      memo_data = JSON.parse(File.read(FILE_NAME_FOR_SAVE), symbolize_names: true)
      memo_data[:memo_data].find { |memo| memo[:id] == id.to_i }
    end

    def update(**params)
      memo_data = JSON.parse(File.read(FILE_NAME_FOR_SAVE), symbolize_names: true)
      index = memo_data[:memo_data].index do |memo|
        memo[:id] == params['id'].to_i
      end
      data_to_update = memo_data[:memo_data][index]
      data_to_update[:title] = params['title']
      data_to_update[:content] = params['content']
      File.open(FILE_NAME_FOR_SAVE, 'w') { |file| file.write(JSON.dump(memo_data)) }
    end

    def delete(id)
      memo_data = JSON.parse(File.read(FILE_NAME_FOR_SAVE), symbolize_names: true)
      memo_data[:memo_data].delete_if { |memo| memo[:id] == id.to_i }
      File.open(FILE_NAME_FOR_SAVE, 'w') { |file| file.write(JSON.dump(memo_data)) }
    end
  end

  private

  def to_h
    { id: @id, title: @title, content: @content }
  end
end
