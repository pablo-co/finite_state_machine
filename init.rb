require 'optparse'
require_relative 'load'
require_relative 'state'
require_relative 'logger'

options = {}

OptionParser.new do |opts|
  opts.banner = 'Usage: init.rb [options]'
  opts.on('-f', '--file FILE', 'Input file') { |v| options[:file] = v }
end.parse!

class Init
  attr_accessor :states
  attr_accessor :options
  attr_accessor :state_machine

  def initialize(options = {}, state_machine)
    self.options = options
    self.state_machine = state_machine
    self.states = {}
  end

  def start
    create_states
    state_machine.current_state = get_state(:initial)
    state_machine.line = 'a=-56.123+22.2//34.4 * 12.12'
    state_machine.execute
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
    create_state_add(:initial)
    create_state_minus(:initial)
    create_state_multiply(:initial)
    create_state_divide(:initial)

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

  def create_state_comment(initial)
    create_state(:comment)
    add_transition :comment, create_transition(:comment, /./)
    add_transition :comment, back_to_start
  end

  def create_transition(key, exp, type = :final)
    Transition.new(to_state: states[key], valid_characters: exp, type: type)
  end

  def add_transition(key, transition)
    self.states[key].push_transition(transition)
  end

  def create_state(key)
    self.states[key] = State.new(name: key)
  end
end

logger = Logger.new
init = Init.new(options, StateMachine.new(logger: logger))
init.start
