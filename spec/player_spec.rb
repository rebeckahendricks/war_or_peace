require 'rspec'
require './lib/card'
require './lib/deck'
require './lib/player'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Player do
  let(:card1) { Card.new(:diamond, 'Queen', 12) }
  let(:card2) { Card.new(:spade, '3', 3) }
  let(:card3) { Card.new(:heart, 'Ace', 14) }
  let(:deck) { Deck.new([card1, card2, card3]) }
  let(:player) { Player.new('Clarisa', deck) }

  it 'exists' do
    expect(player).to be_a(Player)
  end

  it 'has a name' do
    expect(player.name).to eq('Clarisa')
  end

  it 'has a deck' do
    expect(player.deck).to eq(deck)
  end

  context 'when determining if a player has lost' do
    it 'returns false if the deck is not empty' do
      expect(player.has_lost?).to be(false)
    end

    it 'returns true if the deck is empty' do
      player.deck.remove_card
      player.deck.remove_card
      player.deck.remove_card

      expect(player.has_lost?).to be(true)
      expect(player.deck.cards.empty?).to be(true)
    end

    it 'updates the lost status after each card is removed' do
      player.deck.remove_card
      expect(player.has_lost?).to be(false)

      player.deck.remove_card
      expect(player.has_lost?).to be(false)

      player.deck.remove_card
      expect(player.has_lost?).to be(true)
    end
  end
end
