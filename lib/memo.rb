# frozen_string_literal: true

class Memo
  attr_reader :id, :text

  def initialize(id, text)
    @id, @text = id, text
  end

  class << self
    def index
      data_files.map do |fp|
        {
          id: to_id(fp),
          title: File.open(fp) { |f| f.gets },
          created_at: File.birthtime(fp),
          updated_at: File.mtime(fp)
        }
      end
    end
    def create(text)
      latest_id = data_files.map { |fp| to_id(fp) }.max || 0
      File.open(to_fp(latest_id + 1), "w") { |f| f.puts(text) }
    end
    def show(id)
      Memo.new(id, File.open(to_fp(id), "r") { |f| f.read }) if File.exist?(to_fp(id))
    end
    def update(id, text)
      File.open(to_fp(id), "w") { |f| f.puts(text) }
    end
    def destroy(id)
      File.delete(to_fp(id))
    end

    private
    def data_files
      Dir.glob("data/[0-9]*.txt")
    end
    def to_fp(id)
      "data/#{id}.txt"
    end
    def to_id(path)
      path.slice(/\d+/).to_i
    end
  end
end
