# encoding: UTF-8

require 'cgi'
require 'digest/sha1'
require 'active_support'
require 'active_support/core_ext/string'
require "superstring/version"
require "superstring/ext/gollum"

# Add functionality to basic String class:

class ::String

  include ActiveSupport::Inflector

  MAXIMUM_SUBDOMAIN_LENGTH = 63  # This is a hard limit set by internet standards

  def sha1
    Digest::SHA1.hexdigest( self )
  end

  def sha256
    Digest::SHA256.hexdigest( self )
  end

  def sha384(encoding = :base16)
    case encoding
    when :base16
      Digest::SHA384.hexdigest( self )
    when :base64
      Digest::SHA384.base64digest( self )
    when :base64url
      Digest::SHA384.base64digest( self ).tr("+/", "-_")   # URL safe base 64 encoding, as in http://tools.ietf.org/html/rfc4648#section-5
    else
      raise ArgumentError, "Unexpected encoding: #{encoding.inspect}"
    end    
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

  def sentence_poem
    sentences.join($/)
  end

  def slug(type = :page, minimum_subdomain_length = 8)
    case type
      when :page
        page_name_safe
      when :subdomain
        padded_subdomain_safe(1)
      when :padded_subdomain
        padded_subdomain_safe(minimum_subdomain_length)
      else
        raise ArgumentError, "Unknown slug type #{type.inspect}"
    end
  end

  def page_name_safe(char_white_sub = '-', char_other_sub = '-')
    safer = self
    if domain.present?
      safer = CGI.unescape safer                    # convert %3D to '=', %20 to space, etc
      safer = safer.gsub(/[?&=]/, char_other_sub)   # slug out standard query string chars
    end
    safer = Gollum::Page.cname(safer, char_white_sub, char_other_sub)
    safer
  end

  def padded_subdomain_safe(minimum_subdomain_length)
    if minimum_subdomain_length > MAXIMUM_SUBDOMAIN_LENGTH
      raise ArgumentError.new("minimum_subdomain_length must not be greater than #{MAXIMUM_SUBDOMAIN_LENGTH} (was: #{minimum_subdomain_length}")
    end

    massaged = subdomain_safe
    if massaged.size < minimum_subdomain_length
      massaged << '-' unless massaged.empty?
      massaged << ( minimum_subdomain_length - massaged.size ).times.map{ (rand*10).floor.to_s }.join
    end
    massaged
  end

  def subdomain_safe
    safer = page_name_safe
    safer = transliterate(safer)   # convert ø to o, å to a, etc
    safer.downcase!
    safer.gsub!(/[^a-z0-9\-]/, '-')
    safer.gsub!(/^-+/, '')
    safer = safer.slice(0, MAXIMUM_SUBDOMAIN_LENGTH)
    safer
  end

  def domain
    host_without_www
  end

  def host_without_www
    host.gsub(/^www./, '') if host
  end

  def host
    uri.host if uri
  end

  def uri
    URI.parse self rescue nil
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
    gsub( /\s+/, ' ' ).strip
  end

  #LINE_ENDING = "\n"
  #
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
