require "spec_helper"

describe Kernel do
	describe "#pd" do
		it "prints message to stdout" do
			message = capture :stdout do
				pd "foo", "bar"
			end
			message.should == %~"foo" "bar"\n~
		end
	end

	describe "#phr" do
		it "print a horizonal line" do
			message = capture :stdout do
				phr "foo"
			end
			message.should =~ /======.*foo/
		end
	end
end
