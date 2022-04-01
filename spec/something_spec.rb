require "something"

describe RutieExample do
  describe "something?" do
    context "something inside here" do
      it "should return '1'" do
        expect(RutieExample.iterate 1).to eql(0)
      end
    end
  end
end
