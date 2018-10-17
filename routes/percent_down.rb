get '/percent_down' do
  percent_down, percent_gain = "", ""
  slim :percent_down, :locals => {'percent_down' => percent_down, 'percent_gain' => percent_gain}
end

post '/percent_down' do
  percent_down = params[:percent_down] || " "
  percent_gain = calc_percent_gain(percent_down)
  slim :percent_down, :locals => {'percent_down' => percent_down, 'percent_gain' => percent_gain}
end

def calc_percent_gain percent_down
  x = percent_down * 3
  return x
end
