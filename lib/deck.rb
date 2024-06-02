class Deck
  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def rank_of_cards_at(index)
    @cards[index].rank
  end

  def high_ranking_cards
    @cards.filter do |card|
      card.rank >= 11
    end
  end

  def percent_high_ranking
    (high_ranking_cards.length.to_f / @cards.length) * 100
  end

  def remove_card
    @cards.shift
    @cards.map(&:to_s)
  end

  def add_card(card)
    @cards.push(card)
  end
end
