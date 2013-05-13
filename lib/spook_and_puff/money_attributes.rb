require 'spook_and_puff/money'

module SpookAndPuff
  # A module for extending ActiveRecord::Base subclasses. It provides a macro
  # for defining money accessors; it produces writers which coerce the input
  # into SpookAndPuff::Money instances.
  module MoneyAttributes
    # A class macro which defines serialization and attribute writers for the
    # specified attributes. This ensures that the specified attributes will
    # always be instances of SpookAndPuff::Money.
    #
    # @param Array<Symbol>
    #
    # @return nil
    def attr_money(*attrs)
      attrs.each do |attr|
        class_eval %{
          def #{attr}
            if self[:#{attr}]
              @#{attr} ||= SpookAndPuff::Money.new(self[:#{attr}]) 
            end
          end

          def #{attr}=(value)
            if value.nil?
              @#{attr}, self[:#{attr}] = nil
            else
              @#{attr} = case value
              when SpookAndPuff::Money then value
              else SpookAndPuff::Money.new(value)
              end

              self[:#{attr}] = @#{attr}.raw
            end

            @#{attr}
          end
        }
      end

      nil
    end  
  end
end
