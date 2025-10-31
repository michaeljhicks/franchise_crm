require "rails_helper"

RSpec.describe ProspectsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/prospects").to route_to("prospects#index")
    end

    it "routes to #new" do
      expect(get: "/prospects/new").to route_to("prospects#new")
    end

    it "routes to #show" do
      expect(get: "/prospects/1").to route_to("prospects#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/prospects/1/edit").to route_to("prospects#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/prospects").to route_to("prospects#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/prospects/1").to route_to("prospects#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/prospects/1").to route_to("prospects#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/prospects/1").to route_to("prospects#destroy", id: "1")
    end
  end
end
