require 'optparse'
require_relative 'load'
require_relative 'state'
require_relative 'logger'

options = {}

OptionParser.new do |opts|
  opts.banner = 'Usage: init.rb [options]'
  opts.on('-f', '--file FILE', 'Input file') { |v| options[:file] = v }
end.parse!


# Init is the entry class which manages the State Machine and
# creates all of it's states and transitions
# @see StateMachine
class Init
  # @attr [StateMachineBuilder] builder
  # The builder which will return a custom implementation of {StateMachine}
  attr_accessor :builder

  def initialize(builder)
    self.builder = builder
  end

  # Executes the State Machine
  # @param [String] file_name the file name which contains the code
  # @return [nil]
  def parse_file(file_name)
    state_machine = builder.build
    File.foreach(file_name).with_index do |line, _line_num|
      builder.reset
      state_machine.line = clean_line(line)
      state_machine.execute
    end
  end

  protected

  def clean_line(line)
    line.strip
  end
end

logger = Logger.new
init = Init.new(ParserBuilder.new(logger: logger))
init.parse_file(options[:file])
