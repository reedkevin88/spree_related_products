module Spree
  module Admin
    class RelationsController < BaseController
      before_filter :load_data, only: [:create, :destroy]

      respond_to :js, :html

      def create
        @relation = Spree::Relation.new
        product = Spree::Product.find(params[:product_id])
        @relation.relatable = product
        @relation.relation_type = Spree::RelationType.find_by_id(params[:relation][:relation_type_id])
        @relation.related_to = Spree::Variant.find(params[:relation][:related_to_id]).product

        if @relation.save
          redirect_to(action: 'index', notice: "The relation is successfully created.")
        else
          redirect_to(action: 'new')
        end
      end

      def update
        @relation = Spree::Relation.find(params[:id])
        @relation.update_attribute :discount_amount, params[:relation][:discount_amount] || 0

        redirect_to(related_admin_product_url(@relation.relatable))
      end

      def destroy
        @relation = Spree::Relation.find(params[:id])
        @relation.destroy

        respond_to do |format|
          format.js  { render_js_for_destroy }
        end
      end

      private

      def load_data
        @product = Spree::Product.find_by_permalink(params[:product_id])
      end

      def model_class
        Spree::Relation
      end
    end
  end
end
