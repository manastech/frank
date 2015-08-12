require "cgi"
require "json"

class Frank::Request

  def initialize(@request, @route_components)
    @parsed_params = false
    @params = {} of String => String
  end

  def params
    return @params if @parsed_params
    parse_routeparams
    if content_type = @request.headers["Content-type"]?
      case content_type
      when "application/json"
        parse_json(@request.body.not_nil!) if @request.body
      when "application/x-www-form-urlencoded"
        parse_querystring(@request.body.not_nil!) if @request.body
      when .starts_with? "multipart/form-data"
        raise Exception.new("multipart/form-data is not supported (yet)")
      else
        raise Exception.new("Unsupported content type: #{content_type}")
      end
    end
    if (query = @request.uri.query)
      parse_querystring(query)
    end

    @parsed_params = true
    return @params
  end

  private def parse_json(data)
     if json = JSON.parse(data)
         @params = json.merge!(@params) if json.is_a?(Hash)
     end
  end

  private def parse_routeparams(uri=@request.uri)
    components = uri.path.not_nil!.split "/"
    @route_components.zip(components) do |route_component, req_component|
      if route_component.starts_with? ':'
        @params[route_component[1 .. -1]] = req_component
      else
        return nil unless route_component == req_component
      end
    end
    @params
  end

  private def parse_querystring(data)
    CGI.parse(data) do |key, value|
      @params[key] ||= value
    end
    @params
  end

end
