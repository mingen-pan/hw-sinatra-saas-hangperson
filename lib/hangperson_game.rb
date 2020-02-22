class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  attr_accessor :word
  attr_reader :guesses
  attr_reader :wrong_guesses

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(ch)
    if (!ch.is_a? String) || ch.size != 1 || (ch.match? /^(?![a-zA-Z])/)
      raise ArgumentError
    end
    ch.downcase!
    if @word.include? ch
      if @guesses.include? ch
        return false
      end
      @guesses << ch
    else
      if @wrong_guesses.include? ch
        return false
      end
      @wrong_guesses << ch
    end
    true
  end

  def word_with_guesses
    res = []
    @word.each_char do |ch|
      if @guesses.include? ch
        res << ch
      else
        res << '-'
      end
    end
    res.join
end

  def check_win_or_lose
    if !self.word_with_guesses.include? '-'
      :win
    elsif @wrong_guesses.size < 7
      :play
    else
      :lose
    end
  end

end
