get '/percent_down' do
  percent_down, percent_gain = "", ""
  slim :percent_down, :locals => {'percent_down' => percent_down, 'percent_gain' => percent_gain}
end

post '/percent_down' do
  percent_down = params[:percent_down] || " "
  percent_gain = calc_percent_gain(percent_down)
  slim :percent_down, :locals => {'new_message' => new_message, 'message' => message, 'offset' => offset}
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
