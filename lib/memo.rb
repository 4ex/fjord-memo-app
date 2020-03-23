class Memo
  attr_reader :id
  
  def initialize(id)
    @id = id
  end
  def text
    self.class.read(id)
  end
  def html
    text.gsub(/\n/, "<br>")
  end

  class << self
    def index
      index = {}
      data_files.each do |f|
        index[to_id(f)] = File.open(f){|f| f.gets}
      end
      index
    end
    def create(text)
      File.open(to_path(latest_id + 1), "w") {|f| f.puts(text)}
    end
    def read(id)
      File.open(to_path(id), "r") {|f| f.read}
    end
    def update(id, text)
      File.open(to_path(id), "w") {|f| f.puts(text)}
    end
    def delete(id)
      File.delete(to_path(id))
    end

    private
    def data_files
      Dir.glob("data/[0-9]*.txt")
    end
    def latest_id
      data_files.map{|f| to_id(f)}.max || 0
    end
    def to_path(id)
      "data/#{id}.txt"
    end
    def to_id(path)
      path.slice(/[0-9]+/).to_i
    end
  end
end