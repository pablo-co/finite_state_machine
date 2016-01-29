class Transition
  TYPES = %w{initial final}.freeze

  attr_accessor :valid_characters
  attr_accessor :to_state
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