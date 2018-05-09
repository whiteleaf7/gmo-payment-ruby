require 'spec_helper'

describe Gmo::Payment::Error do
  it "is a Gmo::GMOError" do
    Gmo::Payment::Error.new(nil, nil).should be_a(Gmo::GMOError)
  end
end

describe Gmo::GMOError do
  it "is a StandardError" do
    Gmo::GMOError.new.should be_a(StandardError)
  end
end

describe Gmo::Payment::APIError do
  it "is a Gmo::Payment::Error" do
    Gmo::Payment::APIError.new({}).should be_a(Gmo::Payment::Error)
  end

  context 'with error messages' do
    let(:response) { {
      "ErrCode" => "BA1|E01",
      "ErrInfo" => "BA1040001|E01170001|100"
    } }
    subject { Gmo::Payment::APIError.new(response) }
    it { expect(subject.message).to eq "ErrCode=BA1|E01&ErrInfo=BA1040001|E01170001|100&ErrMessage=Bank ID is not specified|Card Number not specified|Card number Required check error" }
  end
end

describe Gmo::Payment::ServerError do
  it "is a Gmo::Payment::Error" do
    Gmo::Payment::ServerError.new(nil, nil).should be_a(Gmo::Payment::Error)
  end
end
