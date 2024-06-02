require 'rspec'
require './lib/card'
require './lib/deck'
require './lib/player'
require './lib/turn'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Turn do
  let(:card1) { Card.new(:heart, 'Jack', 11) }
  let(:card2) { Card.new(:heart, '10', 10) }
  let(:card3) { Card.new(:heart, '9', 9) }
  let(:card4) { Card.new(:diamond, 'Jack', 11) }
  let(:card5) { Card.new(:heart, '8', 8) }
  let(:card6) { Card.new(:diamond, 'Queen', 12) }
  let(:card7) { Card.new(:heart, '3', 3) }
  let(:card8) { Card.new(:diamond, '2', 2) }

  it 'exists' do
    deck1 = Deck.new([card1, card2, card5, card8])
    deck2 = Deck.new([card3, card4, card6, card7])
    player1 = Player.new('Megan', deck1)
    player2 = Player.new('Aurora', deck2)
    turn = Turn.new(player1, player2)

    expect(turn).to be_a(Turn)
  end

  it 'has 2 players' do
    deck1 = Deck.new([card1, card2, card5, card8])
    deck2 = Deck.new([card3, card4, card6, card7])
    player1 = Player.new('Megan', deck1)
    player2 = Player.new('Aurora', deck2)
    turn = Turn.new(player1, player2)

    expect(turn.player1).to eq(player1)
    expect(turn.player2).to eq(player2)
  end

  context ':basic type turn' do
    let(:deck1) { Deck.new([card1, card2, card5, card8]) }
    let(:deck2) { Deck.new([card3, card4, card6, card7]) }
    let(:player1) { Player.new('Megan', deck1) }
    let(:player2) { Player.new('Aurora', deck2) }
    let(:turn) { Turn.new(player1, player2) }

    it 'is of type :basic' do
      expect(turn.player1.deck.rank_of_card_at(0)).not_to eq(turn.player2.deck.rank_of_card_at(0))
      expect(turn.type).to eq(:basic)
      expect(turn.spoils_of_war).to eq([])
    end

    it 'can determine the turn winner by the player with the higher ranked top card' do
      expect(turn.player1.deck.rank_of_card_at(0)).to eq(11)
      expect(turn.player2.deck.rank_of_card_at(0)).to eq(9)

      winner = turn.winner
      expect(winner).to eq(player1)
    end

    it 'sends the top card from each player to the spoils_of_war pile' do
      turn.pile_cards

      expect(turn.spoils_of_war).to eq([card1, card3])
    end

    it 'awards the spoils_of_war to the winner' do
      winner = turn.winner
      turn.pile_cards
      turn.award_spoils(winner)

      expect(turn.player1.deck.cards).to eq([card2, card5, card8, card1, card3])
      expect(turn.player2.deck.cards).to eq([card4, card6, card7])
    end
  end

  context ':war type turn' do
    let(:deck1) { Deck.new([card1, card2, card5, card8]) }
    let(:deck2) { Deck.new([card4, card3, card6, card7]) }
    let(:player1) { Player.new('Megan', deck1) }
    let(:player2) { Player.new('Aurora', deck2) }
    let(:turn) { Turn.new(player1, player2) }

    it 'is of type :war' do
      expect(turn.player1.deck.rank_of_card_at(0)).to eq(turn.player2.deck.rank_of_card_at(0))
      expect(turn.type).to eq(:war)
      expect(turn.spoils_of_war).to eq([])
    end

    it 'can determine the turn winner by the player with the higher ranked card at index 2' do
      expect(turn.player1.deck.rank_of_card_at(2)).to eq(8)
      expect(turn.player2.deck.rank_of_card_at(2)).to eq(12)

      winner = turn.winner
      expect(winner).to eq(player2)
    end

    it 'sends the top 3 cards from each player to the spoils_of_war pile' do
      turn.pile_cards

      expect(turn.spoils_of_war).to eq([card1, card2, card5, card4, card3, card6])
    end

    it 'awards the spoils_of_war to the winner' do
      winner = turn.winner
      turn.pile_cards
      turn.award_spoils(winner)

      expect(turn.player1.deck.cards).to eq([card8])
      expect(turn.player2.deck.cards).to eq([card7, card1, card2, card5, card4, card3, card6])
    end
  end

  fcontext ':mutually_assured_destruction type turn' do
    let(:card6) { Card.new(:diamond, '8', 8) }
    let(:deck1) { Deck.new([card1, card2, card5, card8]) }
    let(:deck2) { Deck.new([card4, card3, card6, card7]) }
    let(:player1) { Player.new('Megan', deck1) }
    let(:player2) { Player.new('Aurora', deck2) }
    let(:turn) { Turn.new(player1, player2) }

    it 'is of type :mutually_assured_destruction' do
      expect(turn.player1.deck.rank_of_card_at(0)).to eq(turn.player2.deck.rank_of_card_at(0))
      expect(turn.player1.deck.rank_of_card_at(2)).to eq(turn.player2.deck.rank_of_card_at(2))
      expect(turn.type).to eq(:mutually_assured_destruction)
      expect(turn.spoils_of_war).to eq([])
    end

    it 'can determine that there is no turn winner' do
      winner = turn.winner
      expect(winner).to eq('No Winner')
    end

    it 'has no cards in spoils_of_war pile' do
      turn.pile_cards

      expect(turn.spoils_of_war).to eq([])
    end

    it 'removes all played cards from players decks' do
      turn.pile_cards

      expect(turn.player1.deck.cards).to eq([card8])
      expect(turn.player2.deck.cards).to eq([card7])
    end
  end
end
