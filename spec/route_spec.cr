require "./spec_helper"

describe "Route" do
  describe "match" do
    it "doesn't match because of route" do
      route = Route.new("GET", "/foo/bar") { "" }
      route.match("GET", "/foo/baz".split("/")).should be_nil
    end

    it "doesn't match because of method" do
      route = Route.new("GET", "/foo/bar") { "" }
      route.match("POST", "/foo/bar".split("/")).should be_nil
    end

    it "matches" do
      route = Route.new("GET", "/foo/:one/path/:two") { "" }
      route_components = route.match("GET", "/foo/uno/path/dos".split("/"))
      route_components.should eq(["", "foo", ":one", "path", ":two"])
    end
  end
end
