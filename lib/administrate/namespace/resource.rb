module Administrate
  class Namespace
    class Resource
      attr_reader :name

      def initialize(resource)
        @name = resource
      end

      def to_s
        name.to_s
      end
    end
  end
end
