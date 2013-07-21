require 'spec_helper'

describe Spree::Calculator::RelatedProductDiscount do
  let(:user) { create(:user) }
  let(:related_product_discount) { Spree::Calculator::RelatedProductDiscount.new }

  describe "instance" do
    context ".description" do
      it "output relation product discount" do
        related_product_discount.description.should eq Spree.t(:related_product_discount)
      end
    end
  end

  describe "class" do
    before do
      @order = stub_model(Spree::Order)
      product = stub_model(Spree::Product, :name => %Q{The "BEST" product})
      variant = stub_model(Spree::Variant, :product => product)
      price = stub_model(Spree::Price, :variant => variant, :amount => 5.00)
      line_item = stub_model(Spree::LineItem, :variant => variant, :order => @order, :quantity => 1, :price => 4.99)
      variant.stub(:default_price => price)
      @order.stub(:line_items => [line_item])

      related_product = create(:product)
      
      @relation_type = Spree::RelationType.create(name: "Related Products", applies_to: "Spree::Product")
      @relation      = Spree::Relation.create!(relatable: product, related_to: related_product, relation_type: @relation_type, discount_amount: 1.0)
    end

    context ".compute" do
      it "should return void" do
        objects = Array.new
        related_product_discount.compute(objects).should be_nil
      end

      it "should return unless order is eligible" do
        empty_order = stub_model(Spree::Order)
        related_product_discount.compute(empty_order).should be_nil
      end

      it "should return total count of array" do
        objects = Array.new { @order }
        related_product_discount.compute(objects).should be_nil
      end

      it "should return total count" do
        related_product_discount.compute(@order).should be_nil
      end
    end
  end
end
