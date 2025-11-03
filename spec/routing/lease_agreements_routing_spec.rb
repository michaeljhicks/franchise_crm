require "rails_helper"

RSpec.describe LeaseAgreementsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/lease_agreements").to route_to("lease_agreements#index")
    end

    it "routes to #new" do
      expect(get: "/lease_agreements/new").to route_to("lease_agreements#new")
    end

    it "routes to #show" do
      expect(get: "/lease_agreements/1").to route_to("lease_agreements#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/lease_agreements/1/edit").to route_to("lease_agreements#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/lease_agreements").to route_to("lease_agreements#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/lease_agreements/1").to route_to("lease_agreements#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/lease_agreements/1").to route_to("lease_agreements#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/lease_agreements/1").to route_to("lease_agreements#destroy", id: "1")
    end
  end
end
