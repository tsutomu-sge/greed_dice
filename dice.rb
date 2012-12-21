# Implement a DiceSet Class here:
#
class DiceSet
  attr_reader :values

  def roll(number_of_dice)
    @values = []
    (0...number_of_dice).each do |index|
      @values << rand(1..6)
    end
  end

  def score
    #store die counts in hash
    store = Hash.new(0)
    @values.each do |die|
      store[die]=store[die]+1
    end
    #calculate result
    result = 0
    store.keys.each do |key|
      count = store[key]
      if key == 1
        if count >= 3
          result += 1000
          count -= 3
        end
        result += count * 100
      else
        if count >= 3
          result += key * 100
          count -= 3
        end
        if key == 5
          result += 50 * count
        end
      end
    end
    result
  end
end
