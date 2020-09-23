RSpec.describe DiscogsData::Dump do
  let(:array_handler) { ArrayHandler.new }
  let(:artists_file) { "spec/files/artists_sample.xml.gz" }
  let(:labels_file) { "spec/files/labels_sample.xml.gz" }
  let(:releases_file) { "spec/files/releases_sample.xml.gz" }

  it "passes parsed entities to the block" do
    releases = []

    described_class.new(releases_file).each { |release| releases << release }

    expect(releases.length).to eq(50)
    expect(releases.first).to be_a(DiscogsData::Model::Release)
  end

  it "passes parsed entities to the handler object's call method" do
    described_class.new(releases_file).each(array_handler)

    expect(array_handler.entities.length).to eq(50)
    expect(array_handler.entities.first).to be_a(DiscogsData::Model::Release)
  end

  it "allows to limit the number of entities to read" do
    described_class.new(releases_file).each(array_handler, limit: 10)

    expect(array_handler.entities.length).to eq(10)
  end

  it "automatically detects Artists dump file" do
    described_class.new(artists_file).each(array_handler)

    expect(array_handler.entities.first).to be_a(DiscogsData::Model::Artist)
  end

  it "automatically detects Labels dump file" do
    described_class.new(labels_file).each(array_handler)

    expect(array_handler.entities.first).to be_a(DiscogsData::Model::Label)
  end

  it "automatically detects Releases dump file" do
    described_class.new(releases_file).each(array_handler)

    expect(array_handler.entities.first).to be_a(DiscogsData::Model::Release)
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
