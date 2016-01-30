# An implementation of a state machine. It's states are
# represented with the {State} class while it's transitions
# are instances of {Transition}. It logs all movements to a
# {Logger logger} and moves between states according to {StateMachine#line line}.
class StateMachine
  # @return [String] the line the state machine is processing
  attr_accessor :line

  # @return [Logger] the logger to which all state machine actions will be sent
  attr_accessor :logger

  # @return [State] the state machine's current state
  attr_reader :current_state

  # @return [State] the state that lead to current state
  attr_accessor :last_state

  def initialize(args = {})
    self.current_state = args.fetch(:state, nil)
    self.line = args.fetch(:line, nil)
    self.logger = args.fetch(:logger, self)
    self.token = ''
  end

  # Resets the State Machine's state.
  # @return [nil]
  def reset
    reset_token
  end

  # Starts the execution of the state machine
  # @return [nil]
  def execute
    state = current_state
    line.each_char do |character|
      state = current_state
      transition = process_character(character)
      log_initial_transition(transition, state)
      self.token += character
    end
    logger.log(state: state, character: token)
  end

  # Gets the next transition after processing a character.
  # Won't return a transition that responds `true` for transition#initial?
  #
  # @param character [String] the character that will be processed
  # @return [Transition] the next transition to a final state
  def process_character(character)
    transition = get_next_transition(character)
    get_and_set_next_transition(character) if transition.initial?
    transition
  end

  # Gets the next transition that is valid for the character.
  # And sets the state machine's current state.
  # Will set {#current_state} to {Transition#to_state}.
  #
  # @param character [String] the character that will be evaluated
  # @return [Transition] the first transition that finds
  def get_and_set_next_transition(character)
    transition = get_transition(character)
    self.current_state = transition.to_state
    transition
  end

  # Sets the state the state machine is moving into.
  # Stores the {#current_state} in {#last_state}
  #
  # @param [State] value the state the state machine is moving into
  # @return [nil]
  def current_state=(value)
    self.last_state = current_state
    @current_state = value
  end

  protected

  # @return [String]
  # the whole token the state machine has processed until now.
  attr_accessor :token

  # Gets the next transition that is valid for the character.
  # Will set {#current_state} to {Transition#to_state}.
  #
  # @param character [String] the character that will be evaluated
  # @return [Transition] the first transition that finds
  def get_transition(character)
    current_state.get_next_state(character)
  end

  # Calls {Logger#log} if the transition is initial.
  # It will also reset the state machine's token.
  # @return [nil]
  def log_initial_transition(transition, state)
    if transition.initial?
      logger.log(state: state, transition: transition, character: token)
      reset_token
    end
  end

  # Resets the state machine's token
  # @return [nil]
  def reset_token
    self.token = ''
  end
end