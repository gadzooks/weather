class Weather

  attr_reader :details
  Details = Struct.new(:location, :current, :forecast)

  def initialize(city)
    client = ApixuClient.new

    @details = setup_details(client.current(city))
    self
  end

  def setup_details(res)
    Details.new(res[:location], res[:current], res[:forecast])
  end

end

