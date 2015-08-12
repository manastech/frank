require "spec"
require "../src/frank/*"

include Frank

def post_urlencoded(path, data)
  headers = HTTP::Headers.new
  headers["Content-Type"] = "application/x-www-form-urlencoded"

  params = CGI.build_form do |form|
    data.each do |k,v|
      form.add k.to_s , v.to_s
    end
  end

  HTTP::Request.new("POST", path, headers: headers, body: params)
end

def post_json(path, data)
  headers = HTTP::Headers.new
  headers["Content-Type"] = "application/json"
  HTTP::Request.new("POST", path, headers: headers, body: data.to_json)
end
