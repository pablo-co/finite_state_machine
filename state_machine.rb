class StateMachine
  attr_accessor :last_state
  attr_accessor :line
  attr_accessor :logger
  attr_reader :current_state

  def initialize(args = {})
    self.current_state = args.fetch(:state, nil)
    self.line = args.fetch(:line, nil)
    self.logger = args.fetch(:logger, self)
    self.token = ''
  end

  def reset
    reset_token
  end

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

  def process_character(character)
    transition = get_next_transition(character)
    get_next_transition(character) if transition.initial?
    transition
  end

  def get_next_transition(character)
    transition = get_transition(character)
    self.current_state = transition.to_state
    transition
  end

  def get_transition(character)
    current_state.get_next_state(character)
  end

  def current_state=(value)
    self.last_state = current_state
    @current_state = value
  end

  protected

  attr_accessor :token

  def reset_token
    self.token = ''
  end

  def log_initial_transition(transition, state)
    if transition.initial?
      logger.log(state: state, transition: transition, character: token)
      reset_token
    end
  end

  def log(args = {})

  end
end