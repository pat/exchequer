require './lib/exchequer'

describe Exchequer::ErrorMapper do
  def errors_hash
    Hash.new { |hash, key| hash[key] = [] }
  end

  let(:map_errors)  { Exchequer::ErrorMapper.map(source, :to => destination) }
  let(:source)      { double(:errors => errors_hash) }
  let(:destination) { double(:errors => errors_hash) }

  describe '#map_errors' do
    it "transfers credit card expiration year attributes" do
      source.errors[:base] << 'Credit card expiration year: Not valid'

      map_errors

      destination.errors.should == {
        :expiration_year => ['Not valid']
      }
    end

    it "transfers credit card expiration month attributes" do
      source.errors[:base] << 'Credit card expiration month: Not valid'

      map_errors

      destination.errors.should == {
        :expiration_month => ['Not valid']
      }
    end

    it "transfers credit card number attributes" do
      source.errors[:base] << 'Credit card number: Not valid'

      map_errors

      destination.errors.should == {
        :full_number => ['Not valid']
      }
    end

    it "transfers first name attributes" do
      source.errors[:base] << 'First name: Not valid'

      map_errors

      destination.errors.should == {
        :first_name => ['Not valid']
      }
    end

    it "transfers last name attributes" do
      source.errors[:base] << 'Last name: Not valid'

      map_errors

      destination.errors.should == {
        :last_name => ['Not valid']
      }
    end

    it "transfers CVV attributes" do
      source.errors[:base] << 'CVV must be 3 or 4 characters long'

      map_errors

      destination.errors.should == {
        :cvv => ['must be 3 or 4 characters long']
      }
    end

    it "transfers other errors to base" do
      source.errors[:base] << 'Gateway error'

      map_errors

      destination.errors.should == {
        :base => ['Gateway error']
      }
    end
  end
end
