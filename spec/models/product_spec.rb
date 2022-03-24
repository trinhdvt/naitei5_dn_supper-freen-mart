require "rails_helper"

RSpec.describe Product, type: :model do
  subject {FactoryBot.create :product}
  it {is_expected.to be_valid}

  describe "associations" do
    it {is_expected.to belong_to(:category).class_name(Category.name)}
    it {is_expected.to have_many(:order_items).dependent(:destroy).class_name(OrderItem.name)}
    it {is_expected.to have_many(:orders).through(:order_items).class_name(Order.name)}
  end

  describe "instance method" do
    context "#final_price" do
      let(:product) {FactoryBot.create :product, price: 10}
      let(:quantity) {2}
      it "should return expected final_price" do
        expect(product.final_price(quantity)).to eq 20
      end
    end

    context "#sold_count" do
      let!(:order) {FactoryBot.create :order}
      let!(:order_item) {FactoryBot.create :order_item, order: order, product: subject, quantity: 2}
      before {order.status_received!}

      it "should return expected sold_count" do
        expect(subject.sold_count).to eq 2
      end
    end

    context "scope trending" do
      let!(:p1) {FactoryBot.create :product}
      let!(:p2) {FactoryBot.create :product}
      let!(:p3) {FactoryBot.create :product}
      before do
        o1 = FactoryBot.create :order
        [p1, p2].each {|p| FactoryBot.create :order_item, order: o1, product: p, quantity: 1}

        o2 = FactoryBot.create :order
        [p1].each {|p| FactoryBot.create :order_item, order: o2, product: p, quantity: 1}

        o3 = FactoryBot.create :order
        [p2].each {|p| FactoryBot.create :order_item, order: o3, product: p, quantity: 1}

        [o1, o2].map(&:status_received!)
      end

      it "should return expected trending products" do
        expect(Product.trending).to eq [p1, p2]
      end

    end

    context "#create_slug" do
      it "should create slug before save" do
        expect(subject.slug.present?).to be(true)
      end
    end
  end
end
