RSpec.describe DiscogsData::Labels do
  subject { described_class.new(dump_file) }
  let(:dump_file) { "spec/files/labels.xml" }

  it "parses raw XML document containing Labels" do
    labels = []

    subject.each { |label| labels << label }

    expect(labels.length).to be(389)
  end
end
