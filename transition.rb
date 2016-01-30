# A Transition represents a transition between two States in a
# StateMachine. It stores all valid characters for the transition
# and it's target state.
class Transition
  # List of valid types a transition can be
  TYPES = %w{initial final}.freeze

  # @attr [Regex, String] valid_characters
  # The collection of characters for which this transition is valid
  attr_accessor :valid_characters

  # @attr [State] to_state
  # The state this transition leads to
  attr_accessor :to_state

  # @attr [Symbol] type
  # The state this transition leads to
  # @return [:initial, :final]
  attr_accessor :type

  def initialize(args = {})
    self.to_state = args.fetch(:to_state)
    self.valid_characters = args.fetch(:valid_characters)
    self.type = args.fetch(:type)
  end

  def valid?(character)
    case character.class
      when String then
        valid_characters.any?(character)
      else
        valid_characters =~ character
    end
  end

  def initial?
    type == :initial
  end

  def final?
    type == :final
  end
end