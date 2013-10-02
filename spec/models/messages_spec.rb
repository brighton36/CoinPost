require 'spec_helper'

describe Message do

  describe "validations" do
    # Base validation
    it 'should be valid on default build' do
      build(:message).should be_valid
    end
    
    it 'validates title presense' do
      build(:message, :subject => nil).should_not be_valid
    end
    
    it 'validates title format' do
      build(:message, :subject => '````````').should_not be_valid
    end
  end

  describe "sanitization" do
    it "should sanitize its message body" do
      message = build :message, 
        :body => 'Hello <script>alert("stripme");</script> World'

      message.body.should eq('Hello  World')
    end

    it "should allow recognized style tag content" do
      body_before = "<p style=\"text-align:left; padding-left: 30px; height: 40px;\">This is a good p \n<span style=\"color:#339966\">With</span><span style=\"text-decoration: underline;\n width : 40px\">a good span</span></p>"
      body_after = "<p style=\"text-align:left;padding-left:30px;height:40px\">This is a good p \n<span style=\"color:#339966\">With</span><span style=\"text-decoration:underline;width:40px\">a good span</span></p>"

      message = build :message, :body => body_before

      message.body.should eq(body_after)
    end

    it "should not allow unknown styles" do
      body_before = "<p style=\"text-align\n : left; border: 1px\">Test</p>"
      body_after  = "<p style=\"text-align:left\">Test</p>"

      message = build :message, :body => body_before

      message.body.should eq(body_after)
    end

    it "should remove empty style tags" do
      body_before = "<span style=\"font-weight: bold\">Test</p>"
      body_after  = "<span>Test</span>"

      message = build :message, :body => body_before

      message.body.should eq(body_after)
    end

    it "should not inadvertantly whitelist bad tags with good style" do
      body_before = "<button style=\"text-align: left\">Bad Tag</button>"

      message = build :message, :body => body_before

      message.body.should be_empty
    end
  end

end

