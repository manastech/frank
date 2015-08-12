class Frank::Route
  getter handler

  def initialize(@method, @path, &@handler : Frank::Context -> _)
    @components = path.split "/"
  end

  def match(method, components)
    return nil unless method == @method
    return nil unless components.length == @components.length

    @components.zip(components) do |route_component, req_component|
      return nil if (route_component != req_component) &&
                      (!route_component.starts_with? ':')
    end

    return @components
  end
end
