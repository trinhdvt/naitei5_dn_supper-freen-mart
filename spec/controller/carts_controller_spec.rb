require 'rails_helper'
include CartsHelper

RSpec.describe CartsController, type: :controller do

  before do
    init_cart
  end

  describe "GET #show" do
    before{ get :show }

    it "render show template" do
      expect(response).to render_template(:show)
    end
  end

  shared_context "before create and update" do
    let(:product) {FactoryBot.create :product}

    context "failed when quantity not positive" do
      before do
        post :create, xhr: true, params: {
          cart: {
            quantity: 0,
          }
        }
      end

      it "show flash danger" do
        expect(flash[:danger]).to eq I18n.t("carts.invalid_qtt")
      end

      it "redirect to root_url" do
        expect(response).to redirect_to root_url
      end
    end

    context "failed when valid quantity but product not found" do
      before do
        post :create, xhr: true, params: {
          cart: {
            quantity: 1,
            product_id: -1
          }
        }
      end

      it "show flash danger" do
        expect(flash[:danger]).to eq I18n.t("products.not_found")
      end

      it "redirect to root_url" do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "POST #create" do
    include_context "before create and update"

    context "failed when quantity over quotas" do
      before do
        update_cart product.id, product.quantity
        @old_qtt = quantity_in_cart product.id
        post :create, xhr: true, params: {
          cart: {
            quantity: 1,
            product_id: product.id
          }
        }
      end

      it "show flash now warning" do
        expect(flash.now[:warning]).to eq I18n.t("carts.insufficient")
      end

      it "not update quantity in cart" do
        expect(quantity_in_cart(product.id)).to eq(@old_qtt)
      end
    end

    context "success when valid quantity and product" do
      before do
        quantity = 1
        @new_qtt = quantity_in_cart(product.id) + quantity
        post :create, xhr: true, params: {
          cart: {
            quantity: quantity,
            product_id: product.id
          }
        }
      end

      it "flash success message" do
        expect(flash[:success]).to eq I18n.t("carts.create.success")
      end

      it "update quantity in cart" do
        expect(quantity_in_cart(product.id)).to eq(@new_qtt)
      end
    end
  end

  describe "PUT #update" do
    include_context "before create and update"

    context "when requested quantity over quotas" do
      let(:product_id) {product.id}
      before do
        request_qtt = product.quantity + rand(1..100)
        put :update, xhr: true, params: {
          cart: {
            product_id: product_id,
            quantity: request_qtt
          }
        }
        @expected_qtt = [request_qtt, product.quantity].min
      end

      it "should flash now warning" do
        expect(flash.now[:warning]).to eq I18n.t("carts.insufficient")
      end

      it "quantity in cart after update not over quotas" do
        expect(quantity_in_cart(product_id)).to eq(@expected_qtt)
      end
    end
  end

  describe "GET #total" do
    let(:products){FactoryBot.create_list :product, 10}

    before do
      products.each {|product| update_cart product.id, rand(1..product.quantity)}

      products_ids = products.map(&:id)
      get :total, xhr: true, params: {
        product_ids: products_ids
      }

      @total = Product.in_ids(products_ids)
                      .map {|p| p.final_price(quantity_in_cart(p.id))}
                      .sum
    end

    it "should assign total with correct value" do
      expect(assigns[:total]).to eq(@total)
    end
  end

  describe "DELETE #destroy" do
    let(:product_ids) {[1, 2, 3]}
    before do
      product_ids.each {|product_id| update_cart product_id, rand(1..10)}
    end

    context "success delete all product in cart" do
      before {delete :destroy, xhr: true, params: {}}

      it "should empty cart" do
        expect(cart_items.size).to eq 0
      end

      it "should flash success" do
        expect(flash[:success]).to eq I18n.t("carts.destroy.empty_cart")
      end

      it "should redirect to root_url" do
        expect(response).to redirect_to root_url
      end
    end

    context "success delete specific product from cart" do
      let!(:origin_cart_size) {cart_items.size}
      let!(:product_id) {product_ids.sample}

      before {delete :destroy, xhr: true, params: { pid: product_id }}

      it {expect(cart_items.size).to eq(origin_cart_size - 1)}

      it {expect(quantity_in_cart(product_id)).to eq(0)}
    end
  end

end
