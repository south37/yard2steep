require 'yard2steep'

describe Yard2steep do
  it "should generate steep type definition" do
    expected = File.read('example/sig/example1.rbi')
    expect(Yard2steep::Engine.execute(File.read('example/lib/example1.rb'))).to eq (expected)
  end
end
