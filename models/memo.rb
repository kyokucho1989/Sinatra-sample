require 'pstore'
DB = PStore.new(".db_file")

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
    data.delete("lastid")
    data.values
  end

  def self.find(id)
    DB.transaction do
      DB["#{id}"]
    end
  end

  def save
    DB.transaction do
      if DB.instance_variable_get(:@table).size < 1
        DB["lastid"] = 1
      else
        DB["lastid"] = DB["lastid"] + 1
      end
    end
    DB.transaction do
      new_id = DB["lastid"]
      DB["#{new_id}"] = self
      DB["#{new_id}"].id = new_id
      DB["lastid"] = new_id
    end
  end

  def update(**params)
    DB.transaction do
      DB["#{self.id}"].title = params[:title]
      DB["#{self.id}"].content = params[:content]

    end
  end

  def delete
    DB.transaction do
      DB.delete("#{self.id}")
    end
  end

end

# memo = Memo.new(title: "タイトル", content: "内容")
# memo.save

# memo.update(**{title: "aaa", content: "bbb"})

# memo.delete(memo)
# memo.all
# DB.transaction do
#   binding.irb
# end
