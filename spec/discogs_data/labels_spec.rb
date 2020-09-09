RSpec.describe DiscogsData::Labels do
  subject { described_class.new(labels_file) }
  let(:labels_file) { "spec/files/labels_sample.xml.gz" }

  it "parses gzipped XML document containing Labels" do
    labels = []

    subject.parse(->(label) { labels << label })

    expect(labels.length).to eq(50)
  end
end
