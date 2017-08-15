module Administrate
  class Namespace
    def initialize(namespace)
      @namespace = namespace
    end

    def indexable_resources
      @indexable_resources ||= routes.select { |route|
        route[:top_level] && route[:action] == "index"
      }.map { |route|
        Resource.new(route)
      }
    end

    def routes
      @routes ||= all_routes.select do |route|
        route[:controller].starts_with?(namespace.to_s)
      end.map do |route|
        controller = route[:controller].gsub(/^#{namespace}\//, "")
        model = calculate_model(route[:spec], route[:required_names])

        {
          controller: controller,
          action: route[:action],
          top_level: !model,
          model: model || controller
        }
      end
    end

    private

    attr_reader :namespace

    def all_routes
      Rails.application.routes.routes.map do |route|
        controller, action = route.defaults.values_at(:controller, :action).map(&:to_s)
        {
          controller: controller,
          action: action,
          spec: route.path.spec.to_s,
          required_names: route.path.required_names
        }
      end
    end

    def calculate_model(spec, required_names)
      parent_id_param = required_names&.first

      return if parent_id_param.blank?
      return if parent_id_param == "id"

      regex = /^\/#{namespace}\/[^\/]+\/:#{parent_id_param}\/([^\/\(]+)/
      match_data = regex.match(spec)

      return if match_data.blank?

      match_data[1]
    end
  end
end
