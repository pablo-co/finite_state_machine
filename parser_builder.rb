require_relative 'state_machine_builder'
require_relative 'state_machine'
require_relative 'state'
require_relative 'transition'

# A {StateMachineBuilder} implementation which processes a set of tokens
# as defined in the {file:doc/MANUAL.md User Manual}
class ParserBuilder < StateMachineBuilder
  # @return [Hash<Symbol, State>] the states on the state machine
  attr_accessor :states

  # @return [StateMachine] the state machine to which all states and transitions are going to be added.
  attr_accessor :state_machine

  # @return [Logger] the logger to which all state machine actions will be sent
  attr_accessor :logger

  def initialize(args = {})
    self.logger = args.fetch(:logger)
    self.states = {}
  end

  # @see StateMachineBuilder#build
  def build
    self.state_machine = StateMachine.new(logger: logger)
    create_states
    state_machine.current_state = get_state(:initial)
    state_machine
  end

  # @see StateMachineBuilder#reset
  def reset
    state_machine.reset
    state_machine.current_state = get_state(:initial)
  end

  protected

  def get_state(key)
    states[key]
  end

  def create_states
    create_state(:initial)

    create_state_variable(:initial)
    create_state_operators(:initial)
    create_state_symbols(:initial)
    create_state_comment(:initial)
    create_state_float(:initial)
    create_state_int(:initial)
    create_state_minus(:initial)
    create_state_add(:initial)
    create_state_multiply(:initial)
    create_state_divide(:initial)
    create_state_power(:initial)

    add_transition :initial, create_transition(:initial, /./)
  end

  def back_to_start
    @back_to_start ||= create_transition(:initial, /./, :initial)
  end

  def create_state_variable(initial)
    create_state(:variable)
    add_transition initial, create_transition(:variable, /[a-zA-Z]/)
    add_transition :variable, create_transition(:variable, /[a-zA-Z]/)
    add_transition :variable, back_to_start
  end

  def create_state_symbols(initial)
    create_state(:symbols)
    add_transition initial, create_transition(:symbols, /[()]/)
    add_transition :symbols, create_transition(:symbols, /[()]/)
    add_transition :symbols, back_to_start
  end

  def create_state_operators(initial)
    create_state(:operators)
    add_transition initial, create_transition(:operators, /=/)
    add_transition :operators, back_to_start
  end

  def create_state_int(initial)
    create_state(:int)
    add_transition initial, create_transition(:int, /[0-9]/)
    add_transition :int, create_transition(:int, /[0-9]/)
    add_transition :int, create_transition(:float, /\./)
    add_transition :int, back_to_start
  end

  def create_state_float(_initial)
    create_state(:float)
    add_transition :float, create_transition(:float, /[0-9]/)
    add_transition :float, create_transition(:float, /E/)
    add_transition :float, create_transition(:float, /\./)
    add_transition :float, create_transition(:float, /\-/)
    add_transition :float, back_to_start
  end

  def create_state_add(initial)
    create_state(:add)
    add_transition initial, create_transition(:add, /\+/)
    add_transition :add, back_to_start
  end

  def create_state_minus(initial)
    create_state(:minus)
    add_transition initial, create_transition(:minus, /\-/)
    add_transition :minus, create_transition(:int, /[0-9]/)
    add_transition :minus, back_to_start
  end

  def create_state_multiply(initial)
    create_state(:multiply)
    add_transition initial, create_transition(:multiply, /\*/)
    add_transition :multiply, back_to_start
  end

  def create_state_divide(initial)
    create_state(:divide)
    add_transition initial, create_transition(:divide, /\//)
    add_transition :divide, create_transition(:comment, /\//)
    add_transition :divide, back_to_start
  end

  def create_state_power(initial)
    create_state(:power)
    add_transition initial, create_transition(:power, /\^/)
    add_transition :power, back_to_start
  end

  def create_state_comment(_initial)
    create_state(:comment)
    add_transition :comment, create_transition(:comment, /./)
  end

  # Adds a transition to a state given an identifier
  # @param [String] key the target state's identifier
  # @param [String, Regexp] exp
  # the expression or characters for which the transition
  # is valid
  # @param [Symbol] type the type of transition, Defaults to `:final` (see {Transition::TYPES})
  # @return [Transition] the newly created transition
  def create_transition(key, exp, type = :final)
    Transition.new(to_state: states[key], valid_characters: exp, type: type)
  end

  # Adds a transition to a state given an identifier
  # @param [String] key the state's identifier
  # @param [Transition] transition the transition that is going to be added.
  # @return [nil]
  def add_transition(key, transition)
    self.states[key].push_transition(transition)
  end

  # Creates a new {State} with the given identifier
  # @param [String] key the state's identifier
  # @return [State] the newly created state
  def create_state(key)
    self.states[key] = State.new(name: key)
  end
end