module Administrate
  class Namespace
    class Resource
      def initialize(route)
        @route = route
      end

      def name
        route[:controller].to_s
      end

      def action
        route[:action]
      end

      def model_class
        route[:model].classify.constantize
      end

      private

      attr_reader :route
    end
  end
end
