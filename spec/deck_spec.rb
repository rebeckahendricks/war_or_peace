require 'rspec'
require './lib/deck'
require './lib/card'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Deck do
  it 'exists' do
    card1 = Card.new(:diamond, 'Queen', 12)
    card2 = Card.new(:spade, 'Jack', 11)
    deck = Deck.new([card1, card2])

    expect(deck).to be_a(Deck)
  end

  it 'has cards in it' do
    card1 = Card.new(:diamond, 'Queen', 12)
    card2 = Card.new(:spade, 'Jack', 11)
    deck = Deck.new([card1, card2])

    expect(deck.cards).to eq([card1, card2])
  end

  it 'return an array of cards in the deck that have a rank of 11 or above' do
    card1 = Card.new(:diamond, '5', 5)
    card2 = Card.new(:spade, 'Jack', 11)
    card3 = Card.new(:heart, '3', 3)
    card4 = Card.new(:club, 'King', 13)
    deck = Deck.new([card1, card2, card3, card4])

    expect(deck.high_ranking_cards).to eq([card2, card4])
  end

  it 'can determine the percentage of cards that are high ranking' do
    card1 = Card.new(:diamond, '5', 5)
    card2 = Card.new(:spade, 'Jack', 11)
    card3 = Card.new(:heart, 'Queen', 12)
    card4 = Card.new(:club, 'King', 13)
    deck = Deck.new([card1, card2, card3, card4])

    expect(deck.percent_high_ranking).to eq 75
  end

  it 'can remove the top card from the deck' do
    card1 = Card.new(:diamond, '5', 5)
    card2 = Card.new(:spade, 'Jack', 11)
    card3 = Card.new(:heart, 'Queen', 12)
    card4 = Card.new(:club, 'King', 13)
    deck = Deck.new([card1, card2, card3, card4])

    expect(deck.remove_card).to eq(card1)
    expect(deck.cards).to eq([card2, card3, card4])
  end

  it 'can add one card to the bottom (end) of the deck' do
    card1 = Card.new(:diamond, '5', 5)
    card2 = Card.new(:spade, 'Jack', 11)
    card3 = Card.new(:heart, 'Queen', 12)
    card4 = Card.new(:club, 'King', 13)
    deck = Deck.new([card1, card2, card3])

    deck.add_card(card4)
    expect(deck.cards).to eq([card1, card2, card3, card4])
  end
end
