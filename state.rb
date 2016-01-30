# A State represents a state in a {StateMachine}, it may contain many
# {Transition transitions} to other states and may have many transitions
# pointing to itself.
class State
  # @return [String] the state's name or identifier
  attr_accessor :name

  # @return [Array<Transition>] transitions
  # The collection of transitions going out of this state
  attr_accessor :transitions

  def initialize(args = {})
    self.name = args.fetch(:name)
    self.transitions = []
  end

  # Adds a transition to this state
  # @param [Transition] transition the transition that is going to be added
  # @return [Array<Transition>] this state's transitions
  def push_transition(transition)
    transitions.push(transition)
  end

  # Gets the next state this character leads to. If there is no next state returns `nil`
  # @param [String] character the character that is going to be processed
  # @return [Transition, nil] the transition this character leads to
  def get_next_state(character)
    transitions.each do |transition|
      is_valid = valid_transition?(transition, character)
      return transition if is_valid
    end
    nil
  end

  protected

  # Checks whether a given character is valid for a given transition
  # @param [Transition] transition the transition that is going to be checked
  # @param [String] character the character that will be processed
  # @return [Boolean] is this transition valid for this character
  def valid_transition?(transition, character)
    transition.valid?(character)
  end
end