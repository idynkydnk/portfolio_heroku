get '/hangman' do
  @session = session
  @session[:word] = "hello"
  @guess = session.delete(:guess)
  slim :hangman
end

post '/hangman' do
  session[:guess] = params["guess"] 
  redirect '/hangman'
end

def caesar_cipher text, offset
  text_array = text.split("")
  x = 0
  text_array.each do |letter|
    if letter =~ /[a-z]/
      new_letter = (letter.ord + offset)
      if new_letter.chr > 'z'
        new_letter -= 26
      end
      text_array[x] = new_letter.chr
    elsif letter =~ /[A-Z]/
      new_letter = (letter.ord + offset)
      if new_letter.chr > 'Z'
        new_letter -= 26
      end
    text_array[x] = new_letter.chr
    end
  x += 1
  end
  return text_array.join
end
