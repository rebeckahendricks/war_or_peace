require './lib/card'
require './lib/deck'
require './lib/player'

class Turn
  attr_accessor :player1, :player2, :spoils_of_war

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @spoils_of_war = []
    @type = type
    @winner = winner
  end

  def type
    if @player1.deck.rank_of_card_at(0) != @player2.deck.rank_of_card_at(0)
      :basic
    elsif @player1.deck.rank_of_card_at(2) == @player2.deck.rank_of_card_at(2)
      :mutually_assured_destruction
    else
      :war
    end
  end

  def winner
    case type
    when :basic
      compare_cards_at(0)
    when :war
      compare_cards_at(2)
    else
      'No Winner'
    end
  end

  def pile_cards
    case type
    when :basic
      pile_basic_cards
    when :war
      pile_war_cards
    else
      remove_mutually_assured_destruction_cards
    end
    @spoils_of_war.flatten!
  end

  def award_spoils(winner)
    return unless @type != :mutually_assured_destruction

    winner.deck.cards.concat(@spoils_of_war)
    @spoils_of_war = []
  end

  private

  def compare_cards_at(index)
    if @player1.deck.rank_of_card_at(index) > @player2.deck.rank_of_card_at(index)
      @player1
    else
      @player2
    end
  end

  def pile_basic_cards
    @spoils_of_war.concat([@player1.deck.cards.shift, @player2.deck.cards.shift])
  end

  def pile_war_cards
    @spoils_of_war.concat(@player1.deck.cards.shift(3))
    @spoils_of_war.concat(@player2.deck.cards.shift(3))
  end

  def remove_mutually_assured_destruction_cards
    @player1.deck.cards.shift(3)
    @player2.deck.cards.shift(3)
    @spoils_of_war = []
  end
end
