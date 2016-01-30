# User Manual
This user manual is for the Parser State Machine that comes built into this project.

## Usage

To run the standard example:
```
ruby init.rb -f examples/example.txt 
```

The file that is going to be interpreted by the parser is defined by the ``-f --file=`` command line arguments.

## Tokens
The Parser identifies the following group of tokens. Along each type a Regex is included,
this regex describes all valid values for each token type.

* Integers ``/[0-9]/``
* Floating Point numbers ``/[0-9].{E}{-}[0-9]/``
* Operators:
    * Assignment ``/=/``
    * Sum ``/\+/``
    * Substraction ``/\-/``
    * Multiplication ``/*/``
    * Division ``/\//`` 
    * Power``/\^/``
* Identifiers:
    * Variables ``/[a-zA-Z]/``
* Symbols:
    * ( ``/[(]/``
    * ) ``/[)]/``
* Comments ``/\/\/./``

## Restrictions

__Variables:__ They are composed of capital and lowercase letters a to z and A to Z. They can't include any other type of symbols.
```ruby
# Valid variable:
avariable = 5

# Not valid variable:
notvalidv3ri4bl3 = 3-5
```


__Substraction:__ If the operator is directly followed by a number it's assumed it is a unary operator and thus should be part of an Integer.
```ruby
# Interpreted as -5:
a = -5

# Interpreted as 3 and -5:
a = 3-5

# Interpreted as 3 minus 5:
a = 3 - 5
```

__Sum:__ All instances of this token are interpreted as the sum operator. To represent a positive number leave it without a sign.
```ruby
# Interpreted as +5:
a = 5

# Interpreted as -3 plus +5:
a = -3 + 5
```
