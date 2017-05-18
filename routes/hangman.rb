get '/hangman' do
  @session = session
  @session["session_id"]
  #slim :hangman
end

