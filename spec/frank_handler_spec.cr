require "./spec_helper"

describe "Frank::Handler" do
  it "routes" do
    frank = Frank::Handler.new
    frank.add_route "GET", "/" do
      "hello"
    end
    request = HTTP::Request.new("GET", "/")
    response = frank.call(request)
    response.body.should eq("hello")
  end

  it "routes request with query string" do
    frank = Frank::Handler.new
    frank.add_route "GET", "/" do |ctx|
      "hello #{ctx.params["message"]}"
    end
    request = HTTP::Request.new("GET", "/?message=world")
    response = frank.call(request)
    response.body.should eq("hello world")
  end

  it "routes request with post data (body)" do
    frank = Frank::Handler.new
    frank.add_route "POST", "/" do |ctx|
      "hello #{ctx.params["message"]}"
    end
    request = HTTP::Request.new("POST", "/", body: "message=world")
    response = frank.call(request)
    response.body.should eq("hello world")
  end

  it "route parameter has more precedence than query string arguments" do
    frank = Frank::Handler.new
    frank.add_route "GET", "/:message" do |ctx|
      "hello #{ctx.params["message"]}"
    end
    request = HTTP::Request.new("GET", "/world?message=coco")
    response = frank.call(request)
    response.body.should eq("hello world")
  end

  it "sets content type" do
    frank = Frank::Handler.new
    frank.add_route "GET", "/" do |env|
      env.response.content_type = "application/json"
    end
    request = HTTP::Request.new("GET", "/")
    response = frank.call(request)
    response.headers["Content-Type"].should eq("application/json")
  end
end
