class Exchequer::Biller
  def initialize(card, options = {})
    @card    = card
    @options = options
  end

  def charge
    map_errors_from(customer)     and return false if customer.id.nil?
    map_errors_from(subscription) and return false if !subscription.save

    true
  end

  def subscription_id
    subscription.id
  end

  private

  attr_reader :card, :options

  def customer
    @customer ||= begin
      Chargify::Customer.find_by_reference(options[:reference])
    rescue ActiveResource::ResourceNotFound
      Chargify::Customer.create(
        :first_name   => card.first_name,
        :last_name    => card.last_name,
        :email        => options[:email],
        :reference    => options[:reference]
      )
    end
  end

  def map_errors_from(object)
    Exchequer::ErrorMapper.map object, :to => card
  end

  def subscription
    @subscription ||= Chargify::Subscription.new(
      :customer_id            => customer.id,
      :product_handle         => options[:product_handle],
      :credit_card_attributes => card.to_hash
    )
  end
end
