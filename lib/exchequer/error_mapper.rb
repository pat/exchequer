class Exchequer::ErrorMapper
  MAPPINGS = {
    'Credit card expiration year:'  => :expiration_year,
    'Credit card expiration month:' => :expiration_month,
    'Credit card number:'           => :full_number,
    'First name:'                   => :first_name,
    'Last name:'                    => :last_name,
    'CVV'                           => :cvv
  }

  def self.map(source, arguments)
    new(source, arguments[:to]).map_errors
  end

  def initialize(source, destination)
    @source, @destination = source, destination
  end

  def map_errors
    source.errors[:base].dup.each do |error|
      label = MAPPINGS.keys.detect { |key| error[/^#{key}/] }

      if label
        destination.errors[MAPPINGS[label]] << error.gsub(/^#{label}\s+/, '')
      else
        destination.errors[:base] << error
      end
    end
  end

  private

  attr_reader :source, :destination
end
