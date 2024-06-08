require './lib/card'
require './lib/deck'
require './lib/player'
require './lib/turn'
require './lib/game'
require 'rspec'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Game do
  it 'exists' do
  end
end