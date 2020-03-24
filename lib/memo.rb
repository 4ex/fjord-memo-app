# frozen_string_literal: true

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
      data_files.each do |file|
        index[to_id(file)] = File.open(file) { |f| f.gets }
      end
      index
    end
    def create(text)
      File.open(to_path(latest_id + 1), "w") { |f| f.puts(text) }
    end
    def read(id)
      File.open(to_path(id), "r") { |f| f.read }
    end
    def update(id, text)
      File.open(to_path(id), "w") { |f| f.puts(text) }
    end
    def delete(id)
      File.delete(to_path(id))
    end
    def exist?(id)
      File.exist?(to_path(id))
    end

    private
    def data_files
      Dir.glob("data/[0-9]*.txt").sort_by { |f| File.mtime(f) }.reverse
    end
    def latest_id
      data_files.map { |f| to_id(f) }.max || 0
    end
    def to_path(id)
      "data/#{id}.txt"
    end
    def to_id(path)
      path.slice(/\d+/).to_i
    end
  end
end
