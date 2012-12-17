require_relative '../lib/superstring'

describe ::String do

  describe "#sha1" do
    it { "x".sha1.should =~ /^[0-9a-f]{40}$/ }
  end

  describe "#sha384" do
    it { "x".sha384.should =~ /^[0-9a-f]{96}$/ }
  end

  describe "#sha512" do
    it { "x".sha512.should =~ /^[0-9a-f]{128}$/ }
  end

  describe "#sentences" do
    it {  "That that is, is.  That that is not, is not.\n\nThat is it...is it not?".sentences.should ==
      ["That that is, is.", "That that is not, is not.", "That is it...is it not?"] }
    it { "Foo. Bar fight! Baz? Yo!!!".sentences.should ==
      ["Foo.", "Bar fight!", "Baz?", "Yo!!!"] }
    it { "This file is called _Heart of the sun.wav Nov., 2012_.".sentences.should ==
      ["This file is called _Heart of the sun.wav Nov., 2012_."] }
  end

  describe "#sentence_poem" do
    it {  "That that is, is.  That that is not, is not.\n\nThat is it...is it not?".sentence_poem.should ==
      "That that is, is.\nThat that is not, is not.\nThat is it...is it not?" }
  end

  describe "#strip_lines!" do
    it { "  foo   bar  ".strip_lines!.should == "foo   bar" }
    it { "  foo \n  bar  ".strip_lines!.should == "foo\nbar" }
    it { "  foo \r  bar  ".strip_lines!.should == "foo\rbar" }
    it { "  foo \r\n  bar  ".strip_lines!.should == "foo\r\nbar" }
    it { "\n\nfoo\nbar\n\n".strip_lines!.should == "foo\nbar" }
  end

end