class Logger
  def log(data = {})
    state = data.fetch(:state)
    transition = data.fetch(:transition, nil)
    puts "#{data.fetch(:character).strip} #{state.name}"
  end
end