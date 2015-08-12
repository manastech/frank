require "./spec_helper"

describe "Frank::Request" do
  it "parses params in query string" do
    frank = Frank::Handler.new
    frank.add_route "GET", "/" do |ctx|
      "hello #{ctx.params["message"]}"
    end
    request = HTTP::Request.new("GET", "/?message=world")
    response = frank.call(request)
    response.body.should eq("hello world")
  end

  it "parses params in application/x-www-form-urlencoded post data" do
    frank = Frank::Handler.new
    frank.add_route "POST", "/" do |ctx|
      "hello #{ctx.params["message"]}"
    end
    response = frank.call(post_urlencoded("/", {message: "world", abc: "xyz"}))
    response.body.should eq("hello world")
  end

  it "parses params from post data, path and query string simultaneously" do
    frank = Frank::Handler.new
    frank.add_route "POST", "/:username" do |ctx|
      "hello #{ctx.params["username"]}, your age is #{ctx.params["age"]} and password is #{ctx.params["passw"]}"
    end
    response = frank.call(post_urlencoded("/crystal/?age=18", {passw: "password123"}))
    response.body.should eq("hello crystal, your age is 18 and password is password123")
  end

  it "parses params in json-formatted post data" do
    frank = Frank::Handler.new
    frank.add_route "POST", "/" do |ctx|
      "hello #{ctx.params["message"]}"
    end
    response = frank.call(post_json("/", {message: "world", abc: "xyz"}))
    response.body.should eq("hello world")
  end

  it "parses params in path which have more precedence than query string arguments" do
    frank = Frank::Handler.new
    frank.add_route "GET", "/:message" do |ctx|
      "hello #{ctx.params["message"]}"
    end
    request = HTTP::Request.new("GET", "/world?message=coco")
    response = frank.call(request)
    response.body.should eq("hello world")
  end
end
