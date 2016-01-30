# A Transition represents a transition between two {State States} in a
# {StateMachine}. It stores all valid characters for the transition
# and it's target state.
class Transition
  # List of valid types a transition can be
  TYPES = %w{initial final}.freeze

  # @return [Regex, String] valid_characters
  # The collection of characters for which this transition is valid
  attr_accessor :valid_characters

  # @return [State] to_state
  # The state this transition leads to
  attr_accessor :to_state

  # @return [Symbol] type
  # The transition's type (see {TYPES})
  attr_accessor :type

  def initialize(args = {})
    self.to_state = args.fetch(:to_state)
    self.valid_characters = args.fetch(:valid_characters)
    self.type = args.fetch(:type)
  end

  # Checks whether this character is valid for this transition
  # @param [String] character the character that needs to be checked for validity
  # @return [Boolean] is this a valid transition for this character?
  def valid?(character)
    case character.class
      when String then
        valid_characters.any?(character)
      else
        valid_characters =~ character
    end
  end

  # Checks if this transition comes from the starting node
  # @return [Boolean] is the transition initial
  def initial?
    type == :initial
  end

  # Checks if this transition ends in the starting node
  # @return [Boolean] is the transition final
  def final?
    type == :final
  end
end