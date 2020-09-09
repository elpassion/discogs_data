RSpec.describe DiscogsData::Artists do
  subject { described_class.new(artists_file) }
  let(:artists_file) { "spec/files/artists_sample.xml.gz" }

  it "parses gzipped XML document containing Artists" do
    artists = []

    subject.parse(->(artist) { artists << artist })

    expect(artists.length).to eq(50)
  end
end
