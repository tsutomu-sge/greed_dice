require './greed_game_events.rb'

class Player
  attr_reader :score, :name, :turn_score
  def initialize(name, dice, num_dice_to_roll)
    @score = 0
    @name = name
    @dice = dice
    @num_dice_to_roll = num_dice_to_roll
  end

  def do_turn
    @in_progress = true
    @turn_score = 0
    while @in_progress
      command = nil
      while command.nil?
        #display commands
        @@reactor.push_event(PlayerChoiceEvent.new)
        input = $stdin.gets
        input_sym = input.strip.to_sym if input.respond_to?('to_sym')
        command = Game::Commands[input_sym] unless input_sym.nil?
        @@reactor.push_event(InvalidCommandEvent.new) if command.nil?
      end
      self.send(command)
    end
  end

  #roll dice, add score, and dispatch to next step
  def roll
    @dice.roll(@num_dice_to_roll)
    roll_score = @dice.score
    @turn_score += roll_score
    @@reactor.push_event(DieRollEvent.new(self, @dice.values, roll_score))
    if roll_score == 0
      stop(false)
    end
    #else option to go again
  end

  #End turn with optional case
  def stop(add_score_to_total=true)
    if add_score_to_total
      if @turn_score >= Game::ScoreForPointsEachTurn
        @score += @turn_score
      else
        @turn_score = 0
      end
    end
    turn_score_final = @turn_score
    @in_progress = false
    @@reactor.push_event(StopTurnEvent.new(self, @turn_score, turn_score_final))
  end
end
