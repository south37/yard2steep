require 'optparse'

module Yard2steep
  class CLI
    class Option
      attr_reader :src, :dst

      def initialize
        @src = '.' # NOTE: Current directory is used as default
        @dst = 'sig'
      end

      def parse!(argv)
        opt = OptionParser.new
        opt.on('--src [src directory path]') { |v| @src = v }
        opt.on('--dst [dst directory path]') { |v| @dst = v }
        opt.parse!(argv)
      end
    end
  end
end
