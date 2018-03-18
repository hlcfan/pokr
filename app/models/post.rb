class Post
  attr_accessor :file_path

  def initialize post_path
    self.file_path = post_path
  end

  def title
    meta_info["title"]
  end

  def date
    meta_info["date"]
  end

  def defacto_file_name
    find_post_regex = /posts\/pages\/(.+).html.erb\z/
    file_path.match(find_post_regex).captures[0]
  end

  def meta_info
    @meta_info ||= begin
      File.open(file_path) do |io|
        lines = nil
        2.times { lines = io.gets }
        post_meta_exists = lines == "---\n".freeze
        while post_meta_exists
          line = io.gets
          lines += line

          break if line == "---\n".freeze
        end

        YAML.load lines
      end
    end
  end
end