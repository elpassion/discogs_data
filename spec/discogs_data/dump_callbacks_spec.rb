RSpec.describe DiscogsData::Dump, "callbacks" do
  subject { described_class.new(releases_file) }

  let(:releases_file) { "spec/files/releases_sample.xml.gz" }

  it "fires file_size callback as soon as the file size is known" do
    bytes = nil

    subject.on(:file_size) { |file_size| bytes = file_size }.each

    expect(bytes).to eq(37706)
  end

  it "fires file_progress callback on each file chunk read" do
    chunk_sizes     = []
    file_progresses = []
    file_sizes      = []

    subject.on(:file_progress) do |chunk_size, file_progress, file_size|
      chunk_sizes << chunk_size
      file_progresses << file_progress
      file_sizes << file_size
    end.each

    expect(chunk_sizes).to eq([4096, 4096, 4096, 4096, 4096, 4096, 4096, 4096, 4096, 842])
    expect(file_progresses).to eq([4096, 8192, 12288, 16384, 20480, 24576, 28672, 32768, 36864, 37706])
    expect(file_sizes).to eq([37706, 37706, 37706, 37706, 37706, 37706, 37706, 37706, 37706, 37706])
  end

  it "fires dump_type callback as soon as the dump type is known" do
    type = nil

    subject.on(:dump_type) { |dump_type| type = dump_type }.each

    expect(type).to eq(:releases)
  end
end
