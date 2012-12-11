require 'cgi'
require 'digest/sha1'
require 'active_support'
require 'active_support/core_ext/string'
require "superstring/version"
require "superstring/ext/gollum"

# Add functionality to basic String class:

class ::String

  LINE_ENDING = "\n"

  def sha1
    Digest::SHA1.hexdigest( self )
  end

  def sha256
    Digest::SHA256.hexdigest( self )
  end

  def sha384
    Digest::SHA384.hexdigest( self )
  end

  def sha512
    Digest::SHA512.hexdigest( self )
  end

  def sentences
    self.scan(
      %r{
        (?:
          [^.!?\s]     # first char of sentence
          [^\r\n]+?    # body of sentence
          [.!?]+       # end of sentence
          (?=\s|\z)    # followed by whitespace, or end of string
        )
      }x
    )
  end

  def poem
    poetry.join
  end

  def poetry
    chunks = self.scan(
      %r{
        (?:
          (?:\r?\n)(?![\r\n])
          |
          \S[^.!?\r\n]+[.!?]+(?=[[:space:]])
          |
          \S[^.\r\n]+
          |
          [.!?]+
        )
      }x
    )
    chunks.map do |chunk|
      "#{chunk.chomp}#{$/}"
    end
  end

  def slug(type = :page)
    case type
      when :page
        page_name_safe
      when :subdomain
        subdomain_safe
      when :padded_subdomain
        padded_subdomain_safe
      else
        raise ArgumentError, "Unknown slug type #{type.inspect}"
    end
  end

  def page_name_safe(char_white_sub = '-', char_other_sub = '-')
    safer = self
    safer = CGI.unescape safer # convert %3D to '=', %20 to space, etc
    safer = safer.gsub(/[?&=]/, char_other_sub) # slug out standard query string chars
    safer = Gollum::Page.cname(safer, char_white_sub, char_other_sub)
    safer
  end

  def padded_subdomain_safe
    massaged = subdomain_safe
    if massaged.size < MINIMUM_SUBDOMAIN_LENGTH
      massaged << '-' unless massaged.empty?
      massaged << ( MINIMUM_SUBDOMAIN_LENGTH - massaged.size ).times.map{ (rand*10).floor.to_s }.join
    end
    massaged
  end

  def subdomain_safe
    gsub(/[^[[:alnum:]]-]/, '-').gsub(/^-+/, '')
  end

  def domain
    match = self.match(%r{^\s*https?://(?:www\.)?([^/]+)})
    (match && match[1]) ? match[1] : ''
  end

  def strip_lines!
    line_ending = match(/\r?\n/).to_a[0] || match(/\r/).to_a[0]
    lines = line_ending ? split( line_ending ) : [ self ]
    lines.map!{|line| line.strip }
    processed = lines.join( line_ending )
    processed.strip!
    replace( processed )
  end

  def in?( collection )
    collection.nil? ? false : collection.include?( self )
  end

  def compact_whitespace
    self.gsub( /\s+/, ' ' ).strip!
  end

  #def break_long_lines!
  #  lines = split( LINE_ENDING )
  #  lines.map!( &:break_if_long )
  #  processed = lines.join( LINE_ENDING )
  #  replace( processed )
  #end
  #
  #def break_if_long( max_length=100 )
  #  lines = scan( chunk_pattern( max_length ) )
  #  lines.map!( &:strip )
  #  lines.join( LINE_ENDING )
  #end
  #
  #def chunk_pattern( max_length )
  #  %r{
  #    (?:
  #      (?:\b|^)
  #      .{1,#{max_length}}        # lines shorter than max_length
  #      (?:\s|$)
  #      |
  #      [^\s]{#{max_length+1},}   # lines longer than max_length, but with no whitespace, so they should not be broken
  #    )
  #  }x
  #end
  #
  #ELLIPSES = '...'
  #
  #def truncate( max_length )
  #  max_length -= ELLIPSES.size
  #  result = match( chunk_pattern( max_length ) ) && $1
  #  result ||= self[ 0...max_length ]
  #  result.strip!
  #  result << ELLIPSES if result.size < self.size
  #  result
  #end

end
