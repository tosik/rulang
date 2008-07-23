# Copyright (C) 2008 tosik <toshi.hirooka@gmail.com>, Chuck Vose <vosechu@gmail.com>
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'lib/vosetools'
include Vosetools

exclude = ['spec/spec_helper.rb', 'lib/rulang.erl', 'lib/rulang.beam']

Dir.glob('lib/*').each do |file|
  unless exclude.include?(file)
    require file
  end
end

# Dir.glob('spec/*').each do |file|
#   unless exclude.include?(file)
#     require file
#     # log_p "requiring #{file}"
#   end
# end

dir = File.dirname(__FILE__)
RULANG_PID_CMD = "ps ax | grep rulang | sed /grep/d | awk '{print $1}'"

def kill_rulang
  puts "killing rulang"
  system "#{RULANG_PID_CMD} | xargs kill 2>/dev/null"
#  p RBridge.new("erlang", "localhost", 9900).erl("rulang:stop_server().")
  wait_for do
    `#{RULANG_PID_CMD}`.chomp.empty?
  end
end

def wait_for(time=10)
  Timeout.timeout(time) do
    loop do
      break if yield
    end
  end
end

kill_rulang
system("#{dir}/../bin/rulang -v")

begin
  wait_for do
    begin
      TCPSocket.new('localhost', 9900).close
      true
    rescue Errno::ECONNREFUSED => e
      false
    rescue Errno::ECONNRESET => e
      false
    end
  end
rescue Exception => e
  kill_rulang
  raise e
end

Spec::Example::ExampleMethods.instance_eval do
  after(:suite) do
    kill_rulang
  end
end