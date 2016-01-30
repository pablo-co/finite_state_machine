# A {Logger} implementation for {ParserBuilder} which outputs
# all states and transitions of a {StateMachine} to the
# standard output
class ParserLogger < Logger
  # @see Logger#log
  def log(data = {})
    state = data.fetch(:state)
    puts "#{data.fetch(:character).strip} #{state.name}"
  end
end