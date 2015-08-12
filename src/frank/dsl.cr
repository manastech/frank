{% for method in %w(get post put patch delete) %}
  def {{method.id}}(path, &block : Frank::Context -> _)
    Frank::Handler::INSTANCE.add_route({{method}}.upcase, path, &block)
  end
{% end %}
