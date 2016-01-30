# Finite State Machine

Finite State Machine is a Ruby project that demonstrates the implementation of a Finite State Machine with a token parser.

## Installation

Download this repository

## Usage

And then execute:

    $ ruby init.rb -f `Your file`
    
Checkout the [User Manual](https://github.com/pablo-co/finite_state_machine/blob/master/doc/MANUAL.md) for further usage instructions and restrictions.

### Handling errors

There are 2 types of errors this gem can raise:

* __BuildException::StateMachineBuildException__: This error is raised when the builder can't create the StateMachine.
* __ResetException::StateMachineResetException__: This error is raised when the builder can't reset the StateMachine.

## Documentation

All documentation is available online at [RubyDoc](http://www.rubydoc.info/github/pablo-co/finite_state_machine/master)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pablo-co/finite_state_machine. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

There are also a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things. These are detailed in the [Contributing guidelines](contributor-covenant.org).


## License

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

