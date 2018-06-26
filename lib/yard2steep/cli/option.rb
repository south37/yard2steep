require 'optparse'

module Yard2steep
  class CLI
    class Option
      attr_reader :src, :dst, :debug

      def initialize
        @src   = '.' # NOTE: Current directory is used as default
        @dst   = 'sig'
        @debug = false
      end

      def parse!(argv)
        opt = OptionParser.new
        opt.on('--debug') { |v| @debug = true }
        opt.parse!(argv)

        @src = argv[0] if argv[0]
        @dst = argv[1] if argv[1]
      end
    end
  end
end
