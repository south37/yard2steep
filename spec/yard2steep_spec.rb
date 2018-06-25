require 'yard2steep'

describe Yard2steep do
  it "should generate steep type definition" do
    expected = File.read('example/sig/example1.rbi')
    src = 'example/lib/example1.rb'
    expect(Yard2steep::Engine.execute(src, File.read(src))).to eq (expected)
  end
end
