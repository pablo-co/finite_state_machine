class State

  attr_accessor :name
  attr_accessor :transitions
  attr_accessor :type

  def initialize(args = {})
    self.name = args.fetch(:name)
    self.transitions = []
  end

  def push_transition(transition)
    transitions.push(transition)
  end

  def get_next_state(character)
    transitions.each do |transition|
      is_valid = valid_transition?(transition, character)
      return transition if is_valid
    end
    nil
  end

  protected

  def valid_transition?(transition, character)
    transition.valid?(character)
  end
end