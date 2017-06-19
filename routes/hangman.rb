get '/hangman' do
  @session = session
  if @session[:guess]
    update_board
  else
    new_game
  end
  slim :hangman
end

post '/hangman' do
  session[:guess] = params["guess"].upcase
  redirect '/hangman'
end

def new_game
  @session[:guesses] = []
  @session[:chances] = 6
  define_the_word
  set_word_display
end

def update_board
  @guess = session.delete(:guess)
  @session[:game_over?] = false
  if @session[:chances] > 1
    @session[:guesses] << @guess
    new_display_word(@guess)
    end_game("win") if @session[:word_display] == @session[:word]
    unless @session[:word].include?(@guess)
      @session[:chances] -= 1
    end
  else
    end_game("lose")
  end
end

def end_game(win_or_lose)
  session.delete(:guesses)
  @session[:game_over?] = true
  if win_or_lose == "win"
    @session[:win?] = true
  else
    @session[:win?] = false
  end
  new_game
end

def set_word_display
  @session[:word_display] = ""
  @session[:word].length.times do |x|
    @session[:word_display] << "_"
  end
end

def define_the_word
  dictionary = File.open("dictionary.txt")
  possible_word = dictionary.readlines.sample.chomp   
  if possible_word.length > 4 && possible_word.length < 13
    word = possible_word.upcase
    dictionary.close
    @session[:word] = word
  end
end

def new_display_word guess
  letter_locations = (0 ... @session[:word].length).find_all { |i| @session[:word][i,1] == @guess }  
  letter_locations.each do |x|
    @session[:word_display][x] = @guess
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


