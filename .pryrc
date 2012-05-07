require "readline"
require "irb/completion" rescue nil
if ENV['rvm_ruby_string'] =~ /[A-Za-z0-9]jruby+/
  require 'java'
end
  
# vim FTW - you can use 'mate' or whichever your prefer
Pry.config.editor = 'vim'

Pry.config.hooks.add_hook :after_session, :say_bye do
  puts "bye-bye" if Pry.active_sessions == 1
end
ENV['HOME'] ||= ENV['UERPROFILE'] || File.dirname(__FILE__)

Pry.config.history.file = if defined?(Bundler)
                            Bundler.tmp.parent.join('history.rb')
                          else
                            File.expand_path('~/.history.rb')
                          end


# Toys methods
# See https://gist.github.com/807492
class Array
  def self.toy(n=10, &block)
    block_given? ? Array.new(n,&block) : Array.new(n) {|i| i+1}
  end
end

class Hash
  def self.toy(n=10)
    Hash[Array.toy(n).zip(Array.toy(n){|c| (96+(c+1)).chr})]
  end
end

if defined?(Rails) && Rails.env
  require 'logger'

  ActiveRecord::Base.logger = Logger.new(STDOUT)
  ActiveRecord::Base.clear_active_connections!

  class Class
    def core_ext
      self.instance_methods.map {|m| [m, self.instance_method(m).source_location] }.select {|m| m[1] && m[1][0] =~/activesupport/}.map {|m| m[0]}.sort
    end
  end
end
