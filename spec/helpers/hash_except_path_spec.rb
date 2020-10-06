RSpec.describe Helpers do
  describe "#hash_except_path" do
    subject { hash_except_path(hash, path) }

    context "given simple hash" do
      let(:hash) { {a: 1, b: 2} }
      let(:path) { [:b] }
      let(:res)  { {a: 1} }

      it("deletes the key-value pair with given keys path") { is_expected.to eq(res) }
    end

    context "given nested hash and one-level path" do
      let(:hash) { {a: 1, b: 2, c: {b: 3}} }
      let(:path) { [:b] }
      let(:res)  { {a: 1, c: {b: 3}} }

      it("deletes the key-value pair only according to the path depth") { is_expected.to eq(res) }
    end

    context "given nested hash and two-level path" do
      let(:hash) { {a: 1, b: 2, c: {b: 3}} }
      let(:path) { [:c, :b] }
      let(:res)  { {a: 1, b: 2, c: {}} }

      it("deletes the key-value pair only according to the path depth") { is_expected.to eq(res) }
    end

    context "given nested hash with same nested keys to delete but different root keys" do
      let(:hash) { {a: 1, b: 2, c: {b: 3}, d: {b: 4}} }
      let(:path) { [:c, :b] }
      let(:res)  { {a: 1, b: 2, c: {}, d: {b: 4}} }

      it("deletes the key-value pair only according to exact keys path") { is_expected.to eq(res) }
    end

    context "given hash with array value that contains simple hashes with the same structure" do
      let(:hash) { {a: 1, b: 2, c: [{b: 3, d: 4}, {b: 5, d: 6}]} }
      let(:path) { [:c, :b] }
      let(:res)  { {a: 1, b: 2, c: [{d: 4}, {d: 6}]} }

      it("deletes the key-value pairs from all array elements") { is_expected.to eq(res) }
    end

    context "given hash with array values with different root keys" do
      let(:hash) { {a: 1, b: 2, c: [{b: 3, d: 4}, {b: 5, d: 6}], d: [{b: 7, d: 8}, {b: 9, d: 10}]} }
      let(:path) { [:c, :b] }
      let(:res)  { {a: 1, b: 2, c: [{d: 4}, {d: 6}], d: [{b: 7, d: 8}, {b: 9, d: 10}]} }

      it("deletes the key-value pair only according to exact keys path") { is_expected.to eq(res) }
    end

    context "given hash with nested arrays of hashes that contain another arrays of hashes" do
      let(:hash) { {a: 1, b: 2, c: [{b: [{b: 5, e: 6}, {b: 7, e: 8}], d: 3}, {b: [{b: 9, e: 10}, {b: 11, e: 12}], d: 4}]} }
      let(:path) { [:c, :b, :b] }
      let(:res)  { {a: 1, b: 2, c: [{b: [{e: 6}, {e: 8}], d: 3}, {b: [{e: 10}, {e: 12}], d: 4}]} }

      it("deletes the key-value pairs from all nested array elements") { is_expected.to eq(res) }
    end
  end

  describe "#hash_except_paths" do
    subject { hash_except_paths(hash, paths) }

    let(:hash)  { {a: 1, b: 2, c: {d: 3, e: 4}} }
    let(:paths) { [[:b], [:c, :d]] }
    let(:res)   { {a: 1, c: {e: 4}} }

    it("deletes the key-value pairs with given keys paths") { is_expected.to eq(res) }
  end
end
