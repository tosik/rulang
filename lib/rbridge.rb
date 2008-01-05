# RBridge - A Ruby to Erlang bridge allowing the use of Erlang commands within 
# normal Ruby code.
# Copyright (C) 2008 Chuck Vose <vosechu@gmail.com>
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

require "socket"
require "erlang_adapter"

#
# Erlang サーバの関数を Ruby のメソッドのように扱えるようにするクラス
#
class RBridge
  VERSION = "0.1"
  
  # [Mod]
  # Erlang module to use when using ruby-style access (the default is "erlang")
	# [Host]
  # Erlang host server name (the default is "localhost")
  # [Port]
  # Erlang server port number (the default is "9900")
  # [Async]
  # Whether asynchronous communication (defaults to "false")
	def initialize(mod, host="localhost", port=9900, async=false)
    # Which module should we call by default? If nothing is specified try the
    # erlang module.
		@mod = mod
    @mod = "erlang" if @mod.nil?
    
		@erlang = ErlangAdapter.new(host, port)
		@async = async
	end

	# Ruby-style method calling. 
	def method_missing(symbol, *args)

		# Pop off the block used for asynchronous access.
		block = args.pop if @async == true

		# Try to create a command that Erlang knows what to do with from the ruby
    # style syntax we're given.
		command = @erlang.make_command(@mod, symbol, args)
		
		erl(command, block)
	end
	
  # Send commands to Erlang to be processed.
	def erl(command, block=nil)
		begin
			if @async == true then
				# If we're asynchronous generate a thread around the call then pass 
        # the results back to a block to display.
				Thread.new do
					res = @erlang.eval(command)
					raise res if @erlang.is_error(res)
					block.call(eval(res))
				end
			elsif @async == false then
				# Blocking mode should just eval and wait for data to come back.
				res = @erlang.eval(command)
				raise res if @erlang.is_error(res)
				eval res
			end
		rescue => res
			raise "[Error]=>#{res}"
		end
  end
end