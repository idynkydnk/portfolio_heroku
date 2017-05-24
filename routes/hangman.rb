get '/hangman' do
  @session = session
  define_the_word unless @session[:word]
  @guess = session.delete(:guess)
  if @session[:guesses]
    if @session[:guesses].length < 6
      @session[:guesses] << @guess unless @guess == nil
    else
      session.delete(:guesses)
      define_the_word
      @session[:guesses] = []
    end
  else
    @session[:guesses] = []
    define_the_word
    set_word_display
    session[:guesses] << @guess unless @guess == nil
  end
  slim :hangman
end

post '/hangman' do
  session[:guess] = params["guess"].downcase
  redirect '/hangman'
end

def set_word_display
  @session[:word_display] = "_ _ _ _"
end

def define_the_word
  dictionary = File.open("dictionary.txt")
  possible_word = dictionary.readlines.sample.chomp   
  if possible_word.length > 4 && possible_word.length < 13
    word = possible_word.downcase
    dictionary.close
    @session[:word] = word
  end
end

def update_state guesses, guess
  x = 0
  @chosen_letters << guess
  if guesses.empty?
    @chances -= 1
  end
  @word.length.times do |i|
    if i == guesses[x]
      @game_state[i*2] = guess
      x += 1
    end
  end
end

def set_game_state
  @word.length.times do
    @game_state << "_ "
  end
end

def winner?
  (@game_state.length / 2).times do |i|
    if @game_state[i*2] == "_"
      return false
    end
  end
  return true
end

def loser?
  if @chances == 0
    return true
  else false
  end
end

def play
  loop do
    @board.draw_board
    guess = get_guess
    if guess == "1"
      save_game_state
    end
    @board.update_state(check_guess(guess), guess)
    if @board.winner?
      puts "The word was " + @board.word
      puts "We have a winner!\n\n\n"
      if File.exist?("../games/game#{@board.game_number}.txt")
        File.delete("../games/game#{@board.game_number}.txt")
      end
      exit
    end
    if @board.loser?
      puts "\nYou're out of turns! The word was \"" + @board.word + "\"\n\n\n\n"
      if File.exist?("../games/game#{@board.game_number}.txt")
        File.delete("../games/game#{@board.game_number}.txt")
      end
      exit
    end
  end
end

def get_guess
  puts "Which letter do you guess?\nEnter \"1\" to save and exit\n\n"
  guess = gets.chomp
  guess = guess.downcase
end

def check_guess guess
  correct_guesses = (0 ... @board.word.length).find_all { |i| @board.word[i,1] == guess }  
  return correct_guesses
end
