RSpec.describe GreekLit do
  it "has a version number" do
    expect(GreekLit::VERSION).not_to be nil
  end
  it "indexes homer correctly" do
    GreekLit::Omiros::Indexer.new("odyssey")::index_book 1, @es_create
  end
end
