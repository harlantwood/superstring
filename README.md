SuperString   [![Build Status](https://travis-ci.org/harlantwood/superstring.png?branch=master)](https://travis-ci.org/harlantwood/superstring)
===========

Grant superpowers to instances of the Ruby String class.

Split stings into sentences, convert to URL-friendly slugs, generate hashcodes, and more...

Basic Usage
-----------

Install or bundle gem.  Then, simply:

    require 'superstring'

This will add new methods to the basic Ruby String class, which are described below.

Slug generation
---------------

**Slugs safe for file names, and (arguably) URLs**

    "Les Misérables".slug(:page)
     => "Les-Misérables"

`:page` is the default style, so this argument can be omitted:

    "Les Misérables".slug
     => "Les-Misérables"

**Slugs safe for subdomains**

    "Les Misérables".slug(:subdomain)
    => "les-miserables"

**Slugs safe for subdomains, padded with random digits to meet a given minimum length**

    "Les Misérables".slug(:padded_subdomain, 20)
     => "les-miserables-62858"

Extract domain name from URI
----------------------------

    "http://www.mediawiki.org/wiki/Manual:$wgUrlProtocols".domain
     => "mediawiki.org"

Sentences
---------

    paragraph = "That that is, is. That that is not, is not. That is it, is it not?"
    paragraph.sentences
     => ["That that is, is.", "That that is not, is not.", "That is it, is it not?"]

    poem = paragraph.sentence_poem
     => "That that is, is.\nThat that is not, is not.\nThat is it, is it not?"
    puts poem
    That that is, is.
    That that is not, is not.
    That is it, is it not?

SHA1 - SHA512 methods
---------------------

    "The quick brown fox jumps over the lazy dog".sha1
     => "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12"
    "The quick brown fox jumps over the lazy dog".sha256
     => "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592"
    "The quick brown fox jumps over the lazy dog".sha384
     => "ca737f1014a48f4c0b6dd43cb177b0afd9e5169367544c494011e3317dbf9a509cb1e5dc1e85a941bbee3d7f2afbc9b1"
    "The quick brown fox jumps over the lazy dog".sha512
     => "07e547d9586f6a73f73fbac0435ed76951218fb7d0c8d788a309d785436bbb642e93a252a954f23912547d1e8a3b5ed6e1bfd7097821233fa0538f3db854fee6"

Whitespace
----------

    "  foo \r\n  bar  ".compact_whitespace
     => "foo bar"
    "  foo \r\n  bar  ".strip_lines!
     => "foo\r\nbar"

Check for inclusion in a given collection
-----------------------------------------

    collection = ["foo", "bar"]
      => ["foo", "bar"]
    "foo".in? collection
      => true
    "food".in? collection
      => false
