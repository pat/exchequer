class Exchequer::Subscription
  def self.update(id, options)
    new(id).update_card options[:card]
  end

  def initialize(id)
    @chargify = Chargify::Subscription.find id
  end

  def update_card(card)
    if @chargify.update_attributes :credit_card_attributes => card.to_hash
      true
    else
      Exchequer::ErrorMapper.map @chargify, :to => card
      false
    end
  end
end
