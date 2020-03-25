# frozen_string_literal: true

class Memo
  attr_reader :id, :text

  def initialize(id, text)
    @id, @text = id, text
  end

  class << self
    def index
      Dir.glob("data/[0-9]*.txt").map do |fp|
        {
          id: to_id(fp),
          title: File.open(fp) { |f| f.gets },
          created_at: File.birthtime(fp),
          updated_at: File.mtime(fp)
        }
      end
    end
    def create(text)
      File.open(to_fp(index.max_by { |m| m[:id] } + 1), "w") { |f| f.puts(text) }
    end
    def read(id)
      Memo.new(id, File.open(to_fp(id), "r") { |f| f.read })
    end
    def update(id, text)
      File.open(to_fp(id), "w") { |f| f.puts(text) }
    end
    def destroy(id)
      File.delete(to_fp(id))
    end
    def exist?(id)
      File.exist?(to_fp(id))
    end

    private
    def to_fp(id)
      "data/#{id}.txt"
    end
    def to_id(path)
      path.slice(/\d+/).to_i
    end
  end
end
