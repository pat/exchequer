require 'active_resource/exceptions'
require './lib/exchequer'

describe Exchequer::Biller do
  let(:biller)       { Exchequer::Biller.new card,
    :reference => 'my-unique-key', :email => 'me@domain.com',
    :product_handle => 'standard-product' }
  let(:card)         { double(:first_name => 'John', :last_name => 'Smith',
    :to_hash => double) }
  let(:customer)     { double(:id => 5234) }
  let(:subscription) { double(:save => true) }

  describe '#charge' do
    before :each do
      stub_const 'Chargify::Customer', double(:find_by_reference => customer)
      stub_const 'Chargify::Subscription', double(:new => subscription)
      stub_const 'Exchequer::ErrorMapper', double(:map => true)
    end

    it "uses an existing company for the given reference" do
      Chargify::Customer.should_receive(:find_by_reference).
        with('my-unique-key').and_return(customer)

      biller.charge
    end

    it "creates a new company with the reference if necessary" do
      Chargify::Customer.stub(:find_by_reference).
        and_raise(ActiveResource::ResourceNotFound.new(''))

      Chargify::Customer.should_receive(:create).with(
        :first_name => 'John',
        :last_name  => 'Smith',
        :email      => 'me@domain.com',
        :reference  => 'my-unique-key'
      ).and_return(customer)

      biller.charge
    end

    it "creates a new subscription" do
      Chargify::Subscription.should_receive(:new).with(
        :customer_id            => 5234,
        :product_handle         => 'standard-product',
        :credit_card_attributes => card.to_hash
      ).and_return(subscription)
      subscription.should_receive(:save)

      biller.charge
    end

    it "returns true" do
      biller.charge.should be_true
    end

    context 'customer cannot be saved' do
      before :each do
        customer.stub :id => nil
      end

      it "maps customer errors to the card" do
        Exchequer::ErrorMapper.should_receive(:map).
          with(customer, :to => card).and_return(true)

        biller.charge
      end

      it "does not save a subscription" do
        subscription.should_not_receive(:save)

        biller.charge
      end

      it "returns false" do
        biller.charge.should be_false
      end
    end

    context 'subscription cannot be saved' do
      before :each do
        subscription.stub :save => false
      end

      it "maps the subscription errors to the card" do
        Exchequer::ErrorMapper.should_receive(:map).
          with(subscription, :to => card).and_return(true)

        biller.charge
      end

      it "returns false" do
        biller.charge.should be_false
      end
    end
  end
end
