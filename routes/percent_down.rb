get '/percent_down' do
  percent_down, percent_gain = "50",100
  slim :percent_down, :locals => {'percent_down' => percent_down, 'percent_gain' => percent_gain}
end

post '/percent_down' do
  percent_down = params[:percent_down] || 0.0
  percent_gain = calc_percent_gain(percent_down.to_f)
  slim :percent_down, :locals => {'percent_down' => percent_down, 'percent_gain' => percent_gain}
end

def calc_percent_gain percent_down
  u = percent_down / ( 1.0 - (0.01 * percent_down))
  return u.round(2)
end
