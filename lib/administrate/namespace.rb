module Administrate
  class Namespace
    def initialize(namespace)
      @namespace = namespace
    end

    def resources
      @resources ||= route_actions.map do |path, actions|
        Resource.new(path, actions)
      end
    end

    def routes
      @routes ||= all_routes.select do |controller, _action|
        controller.starts_with?(namespace.to_s)
      end.map do |controller, action|
        [controller.gsub(/^#{namespace}\//, ""), action]
      end
    end

    private

    attr_reader :namespace

    def all_routes
      Rails.application.routes.routes.map do |route|
        route.defaults.values_at(:controller, :action).map(&:to_s)
      end
    end

    def route_actions
      routes.group_by(&:first).transform_values! do |routes_for_resource|
        routes_for_resource.map { |route| route.second }.uniq
      end
    end
  end
end
