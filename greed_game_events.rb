require './greed_view.rb'

class StartTurnEvent
  attr_reader :players, :current_player
  def initialize(players, current_player)
    @players = players
    @current_player = current_player
  end

  def show
    View.show_scoreboard(@players, @current_player)
  end
end

class StopTurnEvent
  attr_reader :current_player, :turn_score_raw, :turn_score_final
  def initialize(current_player, turn_score_raw, turn_score_final)
    @current_player = current_player
    @turn_score_raw = turn_score_raw
    @turn_score_final = turn_score_final
  end

  def show
    puts "final: #{@turn_score_final}, raw: #{@turn_score_raw}"
    turn_score = if @turn_score_final == @turn_score_raw
                   @turn_score_final
                 else
                   "#{@turn_score_final}(#{@turn_score_raw})"
                 end
    puts "#{@current_player.name} has gained a total of #{turn_score}"
  end
end

class DieRollEvent
  attr_reader :current_player, :dice_rolled, :roll_score
  def initialize(current_player, dice_rolled, roll_score)
    @current_player = current_player
    @dice_rolled = dice_rolled
    @roll_score = roll_score
  end

  def show
    puts %{#{@current_player.name}: #{@dice_rolled.to_a}, Roll Value: #{@roll_score}.
Total score earned this turn: #{@current_player.turn_score}}
  end
end

class PlayerChoiceEvent
  def show
    puts Game::Commands.inspect
  end
end

class FinalRoundEvent
  attr_reader :finalist
  def initialize(finalist)
    @finalist = finalist
  end

  def show
    puts "#{@finalist.name} has started the Final Round!"
  end
end

class StartGameEvent
  attr_reader :current_player
  def initialize(current_player)
    @current_player = current_player
  end

  def show
    puts %{Welcome to GREED
#{@current_player.name} has been randomly selected to go first!}
  end
end

class EndGameEvent
  attr_reader :winner, :players
  def initialize(winner, players)
    @winner = winner
    @players = players
  end

  def show
    puts "Victory goes to #{@winner.name}!"
    View.show_scoreboard(@players.sort_by {|key, value| -value})
  end
end

class InvalidCommandEvent
  def show
    puts "Invalid command."
  end
end
