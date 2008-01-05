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

#
# Erlang specific commands and evaluator
#
class ErlangAdapter

	# [Host]
  # Erlang host server name (the default is "localhost")
  # [Port]
  # Erlang server port number (the default is "9900")
	def initialize(host="localhost", port=9900)
		@host, @port = host, port
	end

	# Send commands to the Erlang server to be evaluated. Must have trailing 
  # whitespace to differentiate between floats and EOL.
	def eval(command)
		socket = TCPSocket.new(@host, @port)
		
    # There has to be a trailing space at the end of a command for erl_scan:tokens
    # to process the string.
		command << " " if command[-1] != " "
		socket.write(command)
		socket.read # ...?
	end

	# Create an Erlang command from the ruby-style syntax
	# [erlang_mod]
	#   Erlang module
	# [erlang_func]
	#   Erlang function
	# [args]
	#   Arguments to pass to function. Should be in a Ruby array. 
	def make_command(erlang_mod, erlang_func, args)
		"#{erlang_mod}:#{erlang_func}(#{to_erlang_args(args)})."
	end

	# Translate a Ruby array to Erlang elements.
	def to_erlang_args(args)
		args.map{ |x| to_erlang_literal x }.join(',')
	end

  # TODO: Make this handle hashes
	# Convert Ruby objects to Erlang objects. Throw an error if the object passed
  # isn't a basic argument. 
	def to_erlang_literal(x)
		if x.kind_of?(String) then
			"\"#{x}\""
		elsif x.kind_of?(Integer) then
			x
		elsif x.kind_of?(Float) then
			x
		elsif x.kind_of?(Array) then
			"[#{x.map{|y| to_erlang_literal(y)}.join(',')}]"
		else
			raise "Can't use \"#{x.type} Object\" in arguments."
		end
	end

	# Quick boolean to decide whether the data returned from Erlang was an error.
	def is_error(str)
		str[0..5] == "Error:"
	end
end
