module Yard2steep
  class CLI
    class Option
      attr_reader :src, :dst

      def initialize
        @src = '.' # NOTE: Current directory is used as default
        @dst = 'sig'
      end

      def parse!(argv)
        @src = argv[0] if argv[0]
        @dst = argv[1] if argv[1]
      end
    end
  end
end
