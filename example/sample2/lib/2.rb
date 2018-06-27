class Person
  # `@dynamic` annotation is to tell steep that
  # the `name` and `contacts` methods are defined without def syntax.
  # (Steep can skip checking if the methods are implemented.)

  # @dynamic name, contacts
  attr_reader :name
  attr_reader :contacts

  def initialize(name:)
    @name = name
    @contacts = []
  end

  def guess_country()
    contacts.map do |contact|
      # With case expression, simple type-case is implemented.
      # `contact` has type of `Phone | Email` but in the `when` clause, contact has type of `Phone`.
      case contact
      when Phone
        contact.country
      end
    end.compact.first
  end
end

class Email
  # @dynamic address
  attr_reader :address

  def initialize(address:)
    @address = address
  end

  def ==(other)
    # `other` has type of `any`, which means type checking is skipped.
    # No type errors can be detected in this method.
    other.is_a?(self.class) && other.address == address
  end

  def hash
    self.class.hash ^ address.hash
  end
end

class Phone
  # @dynamic country, number
  attr_reader :country, :number

  def initialize(country:, number:)
    @country = country
    @number = number
  end

  def ==(other)
    # You cannot use `case` for type case because `other` has type of `any`, not a union type.
    # You have to explicitly declare the type of `other` in `if` expression.

    if other.is_a?(Phone)
      # @type var other: Phone
      other.country == country && other.number == number
    end
  end

  def hash
    self.class.hash ^ country.hash ^ number.hash
  end
end
