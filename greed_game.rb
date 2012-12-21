require './dice.rb'
require './reactor.rb'
require './greed_game_events.rb'
require './greed_player.rb'
require './greed_view.rb'

@@reactor = Reactor.new

class Game
  attr_reader :players
  ScoreForFinalRound = 3000
  ScoreForPointsEachTurn = 300
  NumDiceToRoll = 5
  Commands = {:r => :roll, :s => :stop}
  def initialize(player_names)
    dice = DiceSet.new
    @players = player_names.collect do |name|
      Player.new(name, dice, NumDiceToRoll)
    end
    @current_player = @players[rand(0...@players.length)]
    @@reactor.push_event(StartGameEvent.new(@current_player))
  end

  # runs game until it ends
  def play
    until @current_player == @finalist
      #display scoreboard and current player
      @@reactor.push_event(StartTurnEvent.new(@players, @current_player))
      @current_player.do_turn
      #final round check
      if @finalist.nil? && @current_player.score >= ScoreForFinalRound
        @finalist = @current_player
        @@reactor.push_event(FinalRoundEvent.new(@finalist))
      end
      #next player turn
      next_player_index = @players.index(@current_player) + 1
      next_player_index = 0 if next_player_index >= @players.length
      @current_player = @players[next_player_index]
    end
    @@reactor.push_event(EndGameEvent.new(@players))
  end
end

#entry point when
if __FILE__ == $0
  if ARGV.length < 2
    puts "Enter the names of 2 or more players as arguments."
  else
    @@reactor.register(View.new, [StartTurnEvent, StopTurnEvent, DieRollEvent,
      PlayerChoiceEvent, FinalRoundEvent, StartGameEvent, EndGameEvent,
      InvalidCommandEvent])
    Game.new(ARGV).play
  end
end
