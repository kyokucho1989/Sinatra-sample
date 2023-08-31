# frozen_string_literal: true

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
      unless File.exist?(MEMO_SAVE_FILE)
        memo_data = { last_id: 0, memo_list: [] }
        File.open(MEMO_SAVE_FILE, 'w') { |file| file.write(JSON.dump(memo_data)) }
      end
      memo_data = JSON.parse(File.read(MEMO_SAVE_FILE), symbolize_names: true)
      memo_data[:memo_list]
    end

    def find(id)
      memo_data = JSON.parse(File.read(MEMO_SAVE_FILE), symbolize_names: true)
      memo_data[:memo_list].find { |memo| memo[:id] == id.to_i }
    end

    def update(**params)
      memo_data = JSON.parse(File.read(MEMO_SAVE_FILE), symbolize_names: true)
      index = memo_data[:memo_list].index do |memo|
        memo[:id] == params['id'].to_i
      end
      data_to_update = memo_data[:memo_list][index]
      data_to_update[:title] = params['title']
      data_to_update[:content] = params['content']
      File.open(MEMO_SAVE_FILE, 'w') { |file| file.write(JSON.dump(memo_data)) }
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
