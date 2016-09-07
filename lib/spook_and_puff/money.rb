require 'bigdecimal'

# The main Spook and Puff module which namespaces our projects. Yay?
module SpookAndPuff
  # The money class represents monetary values with a precision of up to seven
  # digits. When used as part of a comparison or mathmatical operation it
  # always ensures the other operand is coerced into a BigDecimal. This ensures
  # the precision is maintained.
  class Money
    include Comparable

    # Stores the raw BigDecimal instance that a Money instance wraps.
    attr_reader :raw

    # Initializes the money class from a BigDecimal instance.
    #
    # @param [BigDecimal, String, SpookAndPuff::Money] value
    #
    # @return self
    #
    # @raise TypeError
    def initialize(value)
      @raw = case value
      when SpookAndPuff::Money then value.raw
      when BigDecimal then value
      when String     then BigDecimal.new(value.gsub(/\$/, ''))
      else raise TypeError.new("Money can only be initalized with a BigDecimal or String not #{value.class}.")
      end
    end

    # A convenience method which returns an instance initalized to zero.
    #
    # @return SpookAndPuff::Money
    def self.zero
      new("0")
    end

    # Value comparison.
    #
    # @param [Money, Numeric, String] other
    #
    # @return Money
    def ==(other)
      case other
      when Money then @raw == other.raw
      else false
      end
    end

    # @param [Money, Numeric, String] other
    #
    # @return Money
    #
    # @raise ArgumentError
    def <=>(other)
      @raw <=> for_comparison(other)
    end

    # Multiplication. Numerics and strings only.
    #
    # @param [Integer, Fixnum, String] other
    #
    # @return Money
    #
    # @raise ArgumentError
    def *(other)
      Money.new(@raw * coerce(other))
    end

    # Division. Numerics and strings only.
    #
    # @param [Integer, Fixnum, String] other
    #
    # @return Money
    #
    # @raise ArgumentError
    def /(other)
      Money.new(@raw / coerce(other))
    end

    # Minus.
    #
    # @param [Money, Numeric, String] other
    #
    # @return Money
    #
    # @raise ArgumentError
    def -(other)
      Money.new(@raw - for_operation(other, 'subtraction'))
    end

    # Add.
    #
    # @param [Money, Numeric, String] other
    #
    # @return Money
    #
    # @raise ArgumentError
    def +(other)
      Money.new(@raw + for_operation(other, 'addition'))
    end

    # Unary minus. This negates the money value
    #
    # @return Money
    def -@
      Money.new(-@raw)
    end

    # Unary plus. Just returns the reciever.
    #
    # @return Money
    def +@
      self
    end

    # Returns a new Money instance with the absolute value.
    #
    # @return Money
    def abs
      Money.new(@raw.abs)
    end

    # Returns a BigDecimal representation of the value in cents.
    #
    # @return BigDecimal
    def cents
      @raw * BigDecimal.new('100')
    end

    # Returns the raw BigDecimal value.
    #
    # @return BigDecimal
    def to_big_decimal
      @raw
    end

    # Checks for zero value.
    #
    # @return [true, false]
    def zero?
      @raw == 0
    end

    # Checks to see if the value is positive i.e. non-negative, non-zero.
    #
    # @return [true, false]
    def positive?
      @raw > 0
    end

    # Checks to see if the value is positive.
    #
    # @return [true, false]
    def non_negative?
      @raw > -1
    end

    # Checks to see if the value is less than zero.
    #
    # @return [true, false]
    def negative?
      @raw < 0
    end

    # Calculates an amount based on the provided percentage.
    #
    # @param [Numeric, String] percentage
    #
    # @return Money
    #
    # @raise TypeError
    def percent(percentage)
      Money.new(@raw * (coerce(percentage) / BigDecimal.new('100')))
    end

    # Calculates the proportion of the provided amount as a percentage.
    #
    # @param SpookAndPuff::Money amount
    #
    # @return BigDecimal
    #
    # @raise TypeError
    def proportion(amount)
      amount.raw / @raw * BigDecimal('100')
    end

    # Rounds to the specified places; defaults to two.
    #
    # @param Integer places
    #
    # @return Money
    def round(places = 2)
      Money.new(@raw.round(places))
    end

    # Returns a currency formatted string, set to two decimal places.
    #
    # @param Hash opts
    # @option opts [true, false] :prefix
    # @return String
    def to_s(opts = {})
      rounded = @raw.round(2)
      prefix = opts[:prefix] == false ? '' : '$'
      format = (opts[:drop_cents] and rounded == @raw.round) ? "%i" : "%.2f"

      "#{prefix}#{format}" % rounded
    end

    private

    # Grabs the raw value of a Money instance, erroring with a message
    # about comparison if it's the wrong type.
    #
    # @param SpookAndPuff::Money other
    #
    # @return BigDecimal
    #
    # @raise ArgumentError
    def for_comparison(other)
      unless other.is_a?(Money)
        raise ArgumentError.new("#{other.class} cannot be compared with SpookAndPuff::Money")
      end

      other.raw
    end

    # Grabs the raw value of a Money instance, erroring with a message
    # about comparison if it's the wrong type.
    #
    # @param SpookAndPuff::Money other
    # @param String op
    #
    # @return BigDecimal
    #
    # @raise ArgumentError
    def for_operation(other, op)
      unless other.is_a?(Money)
        raise ArgumentError.new("Cannot perform #{op} on SpookAndPuff::Money with #{other.class}")
      end

      other.raw
    end

    # Coerces the provided value into a BigDecimal. It will handle any
    # Numeric or string.
    #
    # @param [Numeric, String] other
    #
    # @return BigDecimal
    #
    # @raise TypeError
    def coerce(other)
      case other
      when BigDecimal then other
      when String then BigDecimal.new(other)
      when Integer, Fixnum, Bignum then BigDecimal.new(other.to_s)
      else raise TypeError
      end
    end
  end # Money
end # SpookAndPuff
