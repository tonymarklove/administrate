module Administrate
  class Namespace
    class Resource
      attr_reader :name

      def initialize(resource, actions)
        @name = resource
        @actions = actions
      end

      def to_s
        name.to_s
      end

      def index?
        actions.include?("index")
      end

      private

      attr_reader :actions
    end
  end
end
