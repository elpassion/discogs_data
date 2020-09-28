RSpec.describe DiscogsData::Dump do
  let(:array_handler) { ArrayHandler.new }
  let(:artists_file)  { "spec/files/artists_sample.xml.gz" }
  let(:labels_file)   { "spec/files/labels_sample.xml.gz" }
  let(:releases_file) { "spec/files/releases_sample.xml.gz" }
  let(:masters_file)  { "spec/files/masters_sample.xml.gz" }

  let(:sample_label_with_all_fields) { {
      id:           15,
      name:         "20:20 Vision",
      images:       [
                        {type: "primary", uri: "", uri150: "", width: 600, height: 600},
                        {type: "secondary", uri: "", uri150: "", width: 300, height: 300},
                        {type: "secondary", uri: "", uri150: "", width: 150, height: 150},
                        {type: "secondary", uri: "", uri150: "", width: 250, height: 44}
                    ],
      contact_info: "General enquiries: info@2020recordings.com\r\nLicensing enquiries: info@2020recordings.com\r\n\r\n\r\n",
      profile:      "20/20 Vision \r\n\r\nAn eclectic selection of electronic music \r\n\r\nfounder - Ralph Lawson\r\nlocation - Leeds, UK\r\n\r\nOn some releases the label appears as 2020Vision or 20:20 Vision or 2020 Vision Recordings ",
      parent_label: {id: 396938, name: "2020Vision Recordings Ltd."},
      data_quality: "Needs Vote",
      urls:         ["http://www.2020recordings.com", "http://2020recordings.bandcamp.com", "http://www.facebook.com/2020VisionRecordings", "http://www.instagram.com/2020vision_recordings", "http://www.myspace.com/2020soundsystem", "http://soundcloud.com/2020visionrecordings", "http://2020visiontour.tumblr.com", "http://twitter.com/2020Visionlabel", "http://www.youtube.com/user/2020recordings"],
      sublabels:    [
                        {id: 34355, name: ".dotbleep"},
                        {id: 877, name: "20:20 D Vision"},
                        {id: 42848, name: "20:20 Vintage Visions"},
                        {id: 1554782, name: "20:20 Vision Limited Series"},
                        {id: 416207, name: "2020 Midnight Visions"},
                        {id: 30709, name: "Doublevision (2)"},
                        {id: 44463, name: "Infant Records"},
                        {id: 29641, name: "Nono Records (2)"}
                    ]
  } }

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

  it "allows to process the entities in batches" do
    described_class.new(releases_file).each_slice(array_handler, batch_limit: 7)

    expect(array_handler.entities.length).to eq(8)
    expect(array_handler.entities.map(&:size)).to eq([7, 7, 7, 7, 7, 7, 7, 1])
    expect(array_handler.entities.first.first).to be_a(DiscogsData::Model::Release)
  end

  it "allows to process the entities in batches with limit" do
    described_class.new(releases_file).each_slice(array_handler, batch_limit: 7, limit: 20)

    expect(array_handler.entities.length).to eq(3)
    expect(array_handler.entities.map(&:size)).to eq([7, 7, 6])
    expect(array_handler.entities.first.first).to be_a(DiscogsData::Model::Release)
  end

  it "automatically detects Artists dump file" do
    described_class.new(artists_file).each(array_handler)

    expect(array_handler.entities.first).to be_a(DiscogsData::Model::Artist)
  end

  it "automatically detects Labels dump file" do
    described_class.new(labels_file).each(array_handler)

    expect(array_handler.entities.find { |label| label[:id] == 15 }).to eq(sample_label_with_all_fields)
  end

  it "automatically detects Releases dump file" do
    described_class.new(releases_file).each(array_handler)

    expect(array_handler.entities.first).to be_a(DiscogsData::Model::Release)
  end

  it "automatically detects Masters dump file" do
    described_class.new(masters_file).each(array_handler)

    expect(array_handler.entities.first).to be_a(DiscogsData::Model::Master)
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
