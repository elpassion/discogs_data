RSpec.describe DiscogsData::Dump do
  let(:array_handler) { ArrayHandler.new }
  let(:artists_file) { "spec/files/artists_sample.xml.gz" }
  let(:labels_file) { "spec/files/labels_sample.xml.gz" }
  let(:releases_file) { "spec/files/releases_sample.xml.gz" }

  it "parses gzipped XML file containing Artists" do
    described_class.new(artists_file).parse(array_handler)

    expect(array_handler.entities.length).to eq(50)
    expect(array_handler.entities.first).to be_a(DiscogsData::Model::Artist)
  end

  it "parses gzipped XML file containing Labels" do
    described_class.new(labels_file).parse(array_handler)

    expect(array_handler.entities.length).to eq(50)
    expect(array_handler.entities.first).to be_a(DiscogsData::Model::Label)
  end

  it "parses gzipped XML file containing Releases" do
    described_class.new(releases_file).parse(array_handler)

    expect(array_handler.entities.length).to eq(50)
    expect(array_handler.entities.first).to be_a(DiscogsData::Model::Release)
  end

  it "allows to limit the number of entities to read" do
    described_class.new(artists_file).parse(array_handler, limit: 10)

    expect(array_handler.entities.length).to eq(10)
  end

  private

  class ArrayHandler
    attr_reader :entities

    def initialize
      @entities = []
    end

    def call(entity)
      @entities << entity
    end
  end
end
