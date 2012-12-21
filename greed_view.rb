#Updates ui based on events passed to handle_event
class View
  def handle_event(event)
    event.show
  end

  def self.show_scoreboard(players, current_player=nil)
    player_text = players.collect do |player|
      "#{player.name} => #{player.score}"
    end
    print player_text.to_s + "\n"
    puts ">> #{current_player.name}" unless current_player.nil?
  end
end
