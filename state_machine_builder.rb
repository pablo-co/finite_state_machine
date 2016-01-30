# A wrapper around a State Machine Builder.
# @see {ParserBuilder} for reference implementation
# @abstract - subclass and implement #build and #reset,
#             ensuring that BuildException and ResetException
#             are raised when building or reseting is exceptional.
class StateMachineBuilder
  # An exception raised when the builder can't create the StateMachine
  class BuildException < StandardError;
  end

  # An exception raised when the builder can't reset the StateMachine
  class ResetException < StandardError;
  end

  # Returns an instance of {StateMachine} which includes a custom
  # implementation
  # @return [StateMachine]
  # @raise [BuildException] if {StateMachine} couldn't be built
  def build
    raise BuildException
  end

  # Resets the state machine
  # @return [nil]
  # @raise [ResetException] if {StateMachine} couldn't be reset
  def reset
    raise ResetException
  end
end