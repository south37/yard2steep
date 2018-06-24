require 'yard2steep/cli/option'

module Yard2steep
  class CLI
    class << self
      def run!(argv)
        CLI.new(argv).run!
      end
    end

    def initialize(argv)
      @option = Option.new
      @option.parse!(argv)
    end

    def run!
      traverse_dir!(src_dir)
    end

  private

    def src_dir
      @src_dir ||= File.expand_path(@option.src)
    end

    def dst_dir
      @dst_dir ||= File.expand_path(@option.dst)
    end

    def traverse_dir!(dir)
      Dir.glob(File.join(dir, '*')).each do |f|
        if File.file?(f)
          if File.extname(f) == '.rb'
            translate!(f)
          end
        elsif File.directory?(f)
          traverse_dir!(f)
        else
          # Do nothing
        end
      end
    end

    def translate!(f)
      text = File.read(f)

      dst_file = File.join(dst_dir, f.gsub(/^#{Regexp.escape(src_dir)}/, ''))
      dst_dir  = File.dirname(dst_file)
      FileUtils.mkdir_p(dst_dir)
      File.write(dst_file, Engine.execute(text))
    end
  end
end
