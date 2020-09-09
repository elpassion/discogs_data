RSpec.describe DiscogsData::Releases do
  subject { described_class.new(releases_file) }
  let(:releases_file) { "spec/files/releases_sample.xml.gz" }

  it "parses gzipped XML document containing Releases" do
    releases = []

    subject.parse(->(release) { releases << release })

    expect(releases.length).to eq(50)
  end
end
