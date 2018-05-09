require "spec_helper"

describe "Gmo::Payment::API" do

  describe "#get_request" do
    it "raises" do
      lambda {
        service = Gmo::Payment::API.new()
        service.get_request("foo")
      }.should raise_error(RuntimeError)
    end
  end

  describe "#post_request" do
    it "raises" do
      lambda {
        service = Gmo::Payment::API.new()
        service.post_request("foo")
      }.should raise_error(RuntimeError)
    end
  end

  describe "#api_call" do
    it "raises" do
      lambda {
        service = Gmo::Payment::API.new()
        service.api_call
      }.should raise_error(NoMethodError)
    end
  end

end
