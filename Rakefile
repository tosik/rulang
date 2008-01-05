# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/rbridge.rb'

Hoe.new('rbridge', RBridge::VERSION) do |p|
  p.rubyforge_name = 'ruby-mnesia'
  p.author = 'Chuck Vose'
  p.email = 'vosechu@gmail.com'
  p.summary = 'RBridge allows the use of Erlang code within the Ruby environment'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

# vim: syntax=Ruby
