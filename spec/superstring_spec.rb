# encoding: UTF-8

require File.expand_path('../lib/superstring', File.dirname(__FILE__))

describe ::String do

  describe "#sha1" do
    it { "".sha1.should ==             'da39a3ee5e6b4b0d3255bfef95601890afd80709' }
    it { "".sha1(:base16).should ==    'da39a3ee5e6b4b0d3255bfef95601890afd80709' }
    it { "".sha1(:base64).should ==    '2jmj7l5rSw0yVb/vlWAYkK/YBwk=' }
    it { "".sha1(:base64url).should == '2jmj7l5rSw0yVb_vlWAYkK_YBwk=' }
  end

  describe "#sha256" do      
    it { "".sha256.should ==             'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' }
    it { "".sha256(:base16).should ==    'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' }
    it { "".sha256(:base64).should ==    '47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=' }
    it { "".sha256(:base64url).should == '47DEQpj8HBSa-_TImW-5JCeuQeRkm5NMpJWZG3hSuFU=' }
  end  
    
  describe "#sha384" do      
    it { "".sha384.should ==             '38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b' }
    it { "".sha384(:base16).should ==    '38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b' }
    it { "".sha384(:base64).should ==    'OLBgp1GsljhM2TJ+sbHjaiH9txEUvgdDTAzHv2P24donTt6/529l+9Ua0vFImLlb' }
    it { "".sha384(:base64url).should == 'OLBgp1GsljhM2TJ-sbHjaiH9txEUvgdDTAzHv2P24donTt6_529l-9Ua0vFImLlb' }
  end

  describe "#sha512" do
    it { "".sha512.should ==             'cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e' }
    it { "".sha512(:base16).should ==    'cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e' }
    it { "".sha512(:base64).should ==    'z4PhNX7vuL3xVChQ1m2AB9Yg5AULVxXcg/SpIdNs6c5H0NE8XYXysP+DGNKHfuwvY7kxvUdBeoGlODJ6+SfaPg==' }
    it { "".sha512(:base64url).should == 'z4PhNX7vuL3xVChQ1m2AB9Yg5AULVxXcg_SpIdNs6c5H0NE8XYXysP-DGNKHfuwvY7kxvUdBeoGlODJ6-SfaPg==' }
  end

  describe "#sha1, #sha256, #sha384, #sha512" do
    context "unsupported base passed in as argument" do
      %w[ sha1 sha256 sha384 sha512 ].each do |sha_method|
        it { lambda { "".send(sha_method, nil) }.should raise_error(ArgumentError, "Unexpected encoding: nil") }
        it { lambda { "".send(sha_method, :foo) }.should raise_error(ArgumentError, "Unexpected encoding: :foo") }
      end                                 
    end                                 
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

  describe "#compact_whitespace" do
    it { "  foo   bar  ".compact_whitespace.should == "foo bar" }
    it { "  foo \n  bar  ".compact_whitespace.should == "foo bar" }
    it { "  foo \r  bar  ".compact_whitespace.should == "foo bar" }
    it { "  foo \r\n  bar  ".compact_whitespace.should == "foo bar" }
    it { "\n\nfoo\nbar\n\n".compact_whitespace.should == "foo bar" }
  end

  describe "#host" do
    it { "http://mediawiki.org".host.should == "mediawiki.org"}
    it { "http://mediawiki.org/".host.should == "mediawiki.org"}
    it { "http://mediawiki.org/foo.html".host.should == "mediawiki.org"}
    it { "https://mediawiki.org/".host.should == "mediawiki.org"}
    it { "gopher://mediawiki.org/".host.should == "mediawiki.org"}
    it { "anyprotocol://mediawiki.org/".host.should == "mediawiki.org"}
    it { "//mediawiki.org/".host.should == "mediawiki.org"}
    context "subdomains" do
      it { "http://www.mediawiki.org/".host.should == "www.mediawiki.org"}
      it { "http://dance.dance.mediawiki.org/".host.should == "dance.dance.mediawiki.org"}
      it { "http://dance-dance-.mediawiki.org/".host.should == "dance-dance-.mediawiki.org"}
      it { "http://www.dance.dance.mediawiki.org/".host.should == "www.dance.dance.mediawiki.org"}
    end
    context "invalid URIs" do
      it { "".host.should == nil }
      it { "/mediawiki.org".host.should == nil }
      it { "http:/mediawiki.org".host.should == nil }
    end
  end

  describe "#host_without_www, #domain" do
    it { "http://www.mediawiki.org/".host_without_www.should == "mediawiki.org"}
    it { "http://www.mediawiki.org/".domain.should == "mediawiki.org"}
  end

  describe "#slug" do
    context "slugs safe for file names, and (arguably) URLs" do
      it { "".slug(:page).should == "" }
      it { "Welcome Visitors".slug(:page).should == "Welcome-Visitors" }
      it { "  Welcome  Visitors  ".slug(:page).should == "--Welcome--Visitors--" }

      it { "2012 Report".slug(:page).should == "2012-Report" }
      it { "Ward's Wiki".slug(:page).should == "Ward's-Wiki" }
      it { "holy cats !!! you don't say".slug(:page).should == "holy-cats-!!!-you-don't-say" }

      it { "ø'malley".slug(:page).should == "ø'malley" }
      it { "Les Misérables".slug(:page).should == "Les-Misérables" }

      context "it should URL-decode characters in clear cases" do
       it { "https://www.logilab.org/view?rql=WHERE%20X%20is%20IN%28MicroBlogEntry%2C%20BlogEntry%29%2C%20X%20title%20T".slug(:page).should ==
          "https:--www.logilab.org-view-rql-WHERE-X-is-IN(MicroBlogEntry,-BlogEntry),-X-title-T" }
      end

      context "it should not URL-decode characters when the string is not a URL" do
        it { "Pride? Yes, & that = prejudice. Sometimes %20 is just %20.".slug(:page).should ==
          "Pride?-Yes,-&-that-=-prejudice.-Sometimes-%20-is-just-%20." }
      end

    end

    context "slugs safe for subdomains" do
      it { "".slug(:subdomain).should =~ /^\d$/ }

      it { ("1234567890"*10).slug(:subdomain).should == "1234567890"*6 + "123" }  # 63 is the largest legal subdomain length

      it { "Welcome Visitors".slug(:subdomain).should == "welcome-visitors" }
      it { "  Welcome  Visitors  ".slug(:subdomain).should == "welcome--visitors--" }

      it { "2012 Report".slug(:subdomain).should == "2012-report" }
      it { "Ward's Wiki".slug(:subdomain).should == "ward-s-wiki" }
      it { "holy cats !!! you don't say".slug(:subdomain).should == "holy-cats-----you-don-t-say" }

      it { "ø'målley".slug(:subdomain).should == "o-malley" }
      it { "Les Misérables".slug(:subdomain).should == "les-miserables" }

      it { "https://www.logilab.org/view?rql=WHERE%20X%20is%20IN%28MicroBlogEntry".slug(:subdomain).should ==
          "https---www-logilab-org-view-rql-where-x-is-in-microblogentry" }

      it { "Pride? Yes, & that = prejudice. Sometimes %20 is just %20.".slug(:subdomain).should ==
        "pride--yes----that---prejudice--sometimes--20-is-just--20-" }
    end

    context "padded to meet a given minimum length" do
      it { "".slug(:padded_subdomain, 0).should == '' }
      it { "".slug(:padded_subdomain, 10).should =~ /^\d{10}$/ }
      it { "foo".slug(:padded_subdomain, 3).should =~ /^foo$/ }
      it { "foo".slug(:padded_subdomain, 4).should =~ /^foo-$/ }
      it { "foo".slug(:padded_subdomain, 5).should =~ /^foo-\d$/ }
      it { "foo".slug(:padded_subdomain, 63).should =~ /^foo-\d{59}$/ }
      it { lambda { "foo".slug(:padded_subdomain, 64) }.should raise_error(ArgumentError) }
    end

  end

  describe "#in?" do
    it { "foo".in?(["foo", "bar"]).should == true }
    it { "f00".in?(["foo", "bar"]).should == false }
    it { "foo".in?([]).should == false }
    it { "foo".in?(nil).should == false }
    it { "".in?([]).should == false }
    it { "".in?(nil).should == false }
  end

  # Note: we don't define this method; it's from the shellescape standard ruby library
  describe "#shellescape" do
    it {"Nahko-Bear-(Medicine-for-the-People)-ღ-Aloha-Ke-Akua-ღ".shellescape.should ==
      "Nahko-Bear-\\(Medicine-for-the-People\\)-\\ღ-Aloha-Ke-Akua-\\ღ" }
  end


end
