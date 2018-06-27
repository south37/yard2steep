class Person
  @name: String
  @contacts: Array<Email | Phone>

  def initialize: (name: String) -> any
  def name: -> String
  def contacts: -> Array<Email | Phone>
  def guess_country: -> (String | nil)
end

class Email
  @address: String

  def initialize: (address: String) -> any
  def address: -> String
end

class Phone
  @country: String
  @number: String

  def initialize: (country: String, number: String) -> any
  def country: -> String
  def number: -> String
end
