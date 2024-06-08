require './lib/card'
require './lib/deck'
require './lib/player'
require './lib/turn'

class Game
  def initialize
    @player1 = nil
    @player2 = nil
  end

  def start
    display_welcome_message
    player1_name = get_player_name(1)
    player2_name = get_player_name(2)
    setup_game(player1_name, player2_name)
    play_game
  end

  private

  def display_welcome_message
    puts 'Welcome to War! (or Peace)'
    puts 'This game will be played with 52 cards.'
    puts '------------------------------------------------------------------'
  end

  def get_player_name(player_number)
    puts "What is Player #{player_number}'s name?"
    gets.chomp
  end

  def setup_game(player1_name, player2_name)
    cards = create_cards
    deck1, deck2 = create_decks(cards)
    @player1, @player2 = create_players(player1_name, deck1, player2_name, deck2)
    puts "The players today are #{player1_name} and #{player2_name}."
    prompt_start_game
  end

  def prompt_start_game
    puts "Type 'GO' to start the game!"
    player_input = gets.chomp.upcase
    return if player_input == 'GO'

    puts 'Goodbye!'
    exit
  end

  def create_cards
    suits = %i[heart diamond club spade]
    ranks = [
      { value: '2', rank: 2 }, { value: '3', rank: 3 }, { value: '4', rank: 4 }, { value: '5', rank: 5 },
      { value: '6', rank: 6 }, { value: '7', rank: 7 }, { value: '8', rank: 8 }, { value: '9', rank: 9 },
      { value: '10', rank: 10 }, { value: 'Jack', rank: 11 }, { value: 'Queen', rank: 12 },
      { value: 'King', rank: 13 }, { value: 'Ace', rank: 14 }
    ]

    suits.flat_map do |suit|
      ranks.map { |rank| Card.new(suit, rank[:value], rank[:rank]) }
    end.shuffle
  end

  def create_decks(cards)
    half_deck_size = cards.size / 2
    deck1 = Deck.new(cards.slice(0, half_deck_size))
    deck2 = Deck.new(cards.slice(half_deck_size, half_deck_size))
    [deck1, deck2]
  end

  def create_players(player1_name, deck1, player2_name, deck2)
    player1 = Player.new(player1_name, deck1)
    player2 = Player.new(player2_name, deck2)
    [player1, player2]
  end

  def play_game
    turn_count = 0
    until game_over || turn_count == 1_000_000
      turn_count += 1
      take_turn(turn_count)
    end
    announce_game_result(turn_count)
  end

  def game_over
    @player1.deck.cards.size < 3 || @player2.deck.cards.size < 3
  end

  def take_turn(turn_count)
    turn = Turn.new(@player1, @player2)
    write_result_message(turn_count)
    turn.pile_cards
    turn.award_spoils(turn.winner) if turn.type != :mutually_assured_destruction && turn.winner
  end

  def write_result_message(turn_count)
    case turn.type
    when :basic
      "#{turn.winner.name} won 2 cards"
    when :war
      "WAR - #{turn.winner.name} won 6 cards"
    when :mutually_assured_destruction
      '*mutually assured destruction* 6 cards removed from play'
    else
      'Invalid turn (not enough cards).'
    end

    puts "Turn #{turn_count}: #{result_message}"
  end

  def announce_game_result(turn_count)
    puts '---- DRAW ----' if turn_count == 1_000_000

    game_winner = @player1.deck.cards.empty? ? @player2.name : @player1.name
    puts "*~*~*~* #{game_winner} has won the game! *~*~*~*"
  end
end
