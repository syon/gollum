# ~*~ encoding: utf-8 ~*~
# stdlib
require 'digest/md5'
require 'digest/sha1'
require 'ostruct'

# external
require 'github/markup'
require 'sanitize'

# internal
require File.expand_path('../gollum/uri_encode_component', __FILE__)

# Set ruby to UTF-8 mode
# This is required for Ruby 1.8.7 which gollum still supports.
$KCODE = 'U' if RUBY_VERSION[0, 3] == '1.8'

module Gollum
  VERSION = '3.0.0'

  def self.assets_path
    ::File.expand_path('gollum/public', ::File.dirname(__FILE__))
  end

  class Error < StandardError;
  end

  class DuplicatePageError < Error
    attr_accessor :dir
    attr_accessor :existing_path
    attr_accessor :attempted_path

    def initialize(dir, existing, attempted, message = nil)
      @dir            = dir
      @existing_path  = existing
      @attempted_path = attempted
      super(message || "Cannot write #{@dir}/#{@attempted_path}, found #{@dir}/#{@existing_path}.")
    end
  end

  # Override gollum-lib/page.rb for Subdirectory-Mode
  class Page
    def url_path
      path = if self.path.include?('/')
               self.path.sub(/\/[^\/]+$/, '/')
             else
               ''
             end

      path << Page.cname(self.name, '-', '-')
      path.sub!(/^source\//, '')
      path
    end
  end

  # Override gollum-lib/file.rb for Subdirectory-Mode
  class File
    def url_path
      path = self.path
      path = path.sub(/\/[^\/]+$/, '/') if path.include?('/')
      path.sub!(/^source\//, '')
      path
    end
  end

end

