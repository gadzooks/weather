require "rails_helper"

RSpec.describe "routes for Weather", type: :routing do
  it "routes / to the weather controller" do
    expect(:get => "/").to route_to(:controller => "weather", :action => "index")
  end

  it "routes /prod to the weather controller" do
    expect( :get => "/prod" ).to route_to(
      :controller => "weather",
      :action => "index",
      :test => 'false',
    )
  end

  it "routes /test to the weather controller" do
    expect( :get => "/test" ).to route_to(
      :controller => "weather",
      :action => "index",
      :test => 'true',
    )
  end

  it "routes /ping to the weather controller" do
    expect( :get => "/deep-ping" ).to route_to(
      :controller => "weather",
      :action => "deep_ping",
    )
  end

end
