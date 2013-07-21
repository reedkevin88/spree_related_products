require 'spec_helper'

describe Spree::Admin::ProductsController do
  stub_authorization!

  let(:user) { create(:user) }
  let(:product) { create(:product) }

  before (:each) do
    controller.stub spree_current_user: user
    @other1 = create(:product)
    @relation_type = Spree::RelationType.create(name: "Related Products", applies_to: "Spree::Product")
    @relation = Spree::Relation.create!(relatable: product, related_to: @other1, relation_type: @relation_type)
  end

  after { Spree::Admin::ProductsController.clear_overrides! }

  context :related do
    it "should not be routable" do
   	  spree_get :related
      response.status.should eq 200
   	end

    it "respond to model_class as Spree::Relation" do
      controller.send(:model_class).should eql(Spree::Product)
    end
  end
end
