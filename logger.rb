# An entity which logs the actions of a {StateMachine}.
# @see ParserLogger for reference implementation
# @abstract - subclass and implement {#log}.
class Logger
  # Logs the data into some output device
  # @return [nil]
  # @raise [StandardError] if {#log} is not implemented
  def log(data = {})
    raise StandardError.new('Logger#log is not implemented')
  end
end