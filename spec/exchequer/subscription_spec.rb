require 'active_resource/exceptions'
require './lib/exchequer'

describe Exchequer::Subscription do
  let(:card)         { double(:first_name => 'John', :last_name => 'Smith',
    :to_hash => double) }
  let(:subscription) { double(:update_attributes => true) }

  describe '#update' do
    before :each do
      stub_const 'Chargify::Subscription', double(:find => subscription)
      stub_const 'Exchequer::ErrorMapper', double(:map => true)
    end

    it "finds the subscription with the given id" do
      Chargify::Subscription.should_receive(:find).with(4853).
        and_return(subscription)

      Exchequer::Subscription.update 4853, :card => card
    end

    it "updates the subscription with the new card details" do
      subscription.should_receive(:update_attributes).with(
        :credit_card_attributes => card.to_hash
      ).and_return(true)

      Exchequer::Subscription.update 4853, :card => card
    end

    it "returns true" do
      Exchequer::Subscription.update(4853, :card => card).should be_true
    end

    context 'subscription cannot be saved' do
      before :each do
        subscription.stub :update_attributes => false
      end

      it "maps the subscription errors to the card" do
        Exchequer::ErrorMapper.should_receive(:map).
          with(subscription, :to => card).and_return(true)

        Exchequer::Subscription.update 4853, :card => card
      end

      it "returns false" do
        Exchequer::Subscription.update(4853, :card => card).should be_false
      end
    end
  end
end
