# # These files may not be used in this project but are merely notes collected
# # and inserted into all of Chuck Vose's projects. Please disregard them 
# # unless they help you.

# # PLUGINS:
# # Autotest with UnitRecord
# # By default, running autotest in the Rails directory will run the unit tests. 
# # To run the functional tests, do: AUTOTEST='functional' autotest
# ruby script/plugin install http://svn.soniciq.com/public/rails/plugins/iq_autotest
# # Query Analyzer to see what we're doing under the surface
# # Courtesy of Bob Silva at http://agilewebdevelopment.com/plugins/query_analyzer
# ruby script/plugin install http://svn.nfectio.us/plugins/query_analyzer
# # Dev mode performance cacher by Josh Goebel
# # Caches dev code after file changes to make refreshes happen in the background
# ruby script/plugin install http://svn.techno-weenie.net/projects/plugins/dev_mode_performance_fixes/
# # Rspec for running BDD
# ruby script/plugin install svn://rubyforge.org/var/svn/rspec/tags/CURRENT/rspec
# ruby script/plugin install svn://rubyforge.org/var/svn/rspec/tags/CURRENT/rspec_on_rails

# # GEMS:
# # UnitRecord disconnects tests from the database and restructures tests into
# # Proper unit/functional tests. (Unit == no database, no externals). Run 
# # rake vose:convert_to_unitrecord[_and_commit] after installing.
# sudo gem install unit_record
# # Zentest provides test generation and autotest for hands free testing
# # RSpec ~/.autotest file from http://reinh.com/2007/9/6/rspec-autotest-and-growl-oh-my
# # Test::Unit ~/.autotest file from 
# sudo gem install zentest
# # Dust provides some handy helper methods to testing
# sudo gem install dust
# # Mocha allows cross unit tests by mocking and stubbing functions
# sudo gem install mocha

require 'rubygems'
# require 'mocha'
# require 'stubba'
# require 'dust'

# require 'factory'

module Vosetools
  def log_p(message)
    require 'pp'
    
    p "*********************"
    pp message
    p "*********************"
    
    # if !message.is_a?(Array)
    #   `growlnotify -m "#{message}"`
    # end
  end
  
  def profile
    require 'ruby-prof'
    
    result = RubyProf.profile do
      yield
    end
    
    # Print a flat profile to text
    printer = RubyProf::FlatPrinter.new(result)
    printer.print(STDOUT, 5)
  end
  
  # def has_a(obj)
  #   class_eval do
  #     define_method(:method_missing) do |*values|
  #       if obj.methods.include?(values[0])
  #         log_p values
  #         obj.send!(:values[0], values[1..(values.length-1)])
  #       end
  #     end
  #   end
  # end
end

# # Adapted from http://sami.samhuri.net/2007/4/11/activerecord-base-find_or_create-and-find_or_initialize
# # Originally created by sjs
# module ActiveRecordExtensions
#   def self.included(base)
#     base.extend(ClassMethods)
#   end
#   
#   module ClassMethods
#     def find_or_create(params)
#       begin
#         return self.find(params[:id])
#       rescue ActiveRecord::RecordNotFound => e
#         attrs = {}
#         
#         # search for valid attributes in params
#         self.column_names.map(&:to_sym).each do |attrib|
#           # skip unknown columns, and the id field
#           next if params[attrib].nil? || attrib == :id
# 
#           attrs[attrib] = params[attrib]
#         end
# 
#         # call the appropriate ActiveRecord finder method
#         found = self.send("find_by_#{attrs.keys.join('_and_')}", *attrs.values) if !attrs.empty?
#         
#         if found && !found.nil?
#           return found
#         else
#           return self.create(params)
#         end
#       end
#     end
#     alias create_or_find find_or_create
#   end
# end
# 
# ActiveRecord::Base.send(:include, ActiveRecordExtensions)

# Copyright: Jay Philips
# jicksta.com/articles/2007/08/04/the-methodphitamine
module Kernel
  protected
  def it() It.new end
  alias its it
end

class It

  undef_method(*(instance_methods - %w*__id__ __send__*))

  def initialize
    @methods = []
  end

  def method_missing(*args, &block)
    @methods << [args, block] unless args == [:respond_to?, :to_proc]
    self
  end

  def to_proc
    lambda do |obj|
      @methods.inject(obj) do |current,(args,block)|
        current.send(*args, &block)
      end
    end
  end
end