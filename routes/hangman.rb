get '/hangman' do
  @session = session
  @guess = session.delete(:guess)
  if @session[:guesses]
    if @session[:guesses].length < 6
      @session[:guesses] << @guess unless @guess == nil
    else
      session.delete(:guesses)
      @session[:guesses] = []
    end
  else
    @session[:guesses] = []
    session[:guesses] << @guess unless @guess == nil
  end
  slim :hangman
end

post '/hangman' do
  session[:guess] = params["guess"] 
  redirect '/hangman'
end