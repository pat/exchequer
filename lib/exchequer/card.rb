class Exchequer::Card
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :full_number, :cvv,
    :expiration_month, :expiration_year, :billing_address, :billing_city,
    :billing_state, :billing_zip, :billing_country

  validates_presence_of :first_name, :last_name, :full_number, :cvv,
    :expiration_month, :expiration_year

  def initialize(params = {})
    params ||= {}
    params.keys.each do |key|
      send "#{key}=", params[key]
    end
  end

  def errors
    @errors ||= ActiveModel::Errors.new(self)
  end

  def to_hash
    {
      'first_name'       => first_name,
      'last_name'        => last_name,
      'full_number'      => full_number,
      'cvv'              => cvv,
      'expiration_month' => expiration_month,
      'expiration_year'  => expiration_year,
      'billing_address'  => billing_address,
      'billing_city'     => billing_city,
      'billing_state'    => billing_state,
      'billing_zip'      => billing_zip,
      'billing_country'  => billing_country
    }
  end
end
