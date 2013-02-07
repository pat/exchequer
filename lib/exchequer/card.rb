class Exchequer::Card
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :full_number, :cvv,
    :expiration_month, :expiration_year, :billing_address, :billing_city,
    :billing_state, :billing_zip, :billing_country

  validates_presence_of :first_name, :last_name, :full_number, :cvv,
    :expiration_month, :expiration_year
  validate :card_cannot_be_expired

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

  private

  def card_cannot_be_expired
    return unless expiration_month.present? && expiration_year.present?

    now = Time.zone.now
    return if expiration_year.to_i > now.year
    return if expiration_year.to_i == now.year &&
      expiration_month.to_i >= now.month

    errors.add :expiration_year, "Credit card expiry date is invalid"
  end
end
