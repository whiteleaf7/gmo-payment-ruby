require "spec_helper"
describe "Gmo::JSON" do

  describe ".dump" do
    it "should work" do
      [
        [
          {:foo => {:bar => 'baz'}},
          {'foo' => {'bar' => 'baz'}},
        ],
        [
          [{:foo => {:bar => 'baz'}}],
          [{'foo' => {'bar' => 'baz'}}],
        ],
        [
          {:foo => [{:bar => 'baz'}]},
          {'foo' => [{'bar' => 'baz'}]},
        ],
        [
          {1 => {2 => {3 => 'bar'}}},
          {'1' => {'2' => {'3' => 'bar'}}}
        ]
      ].each do |example, expected|
        dumped_json = Gmo::JSON.dump(example)
        expect(MultiJson.load(dumped_json)).to eq expected
      end
    end
  end

end
