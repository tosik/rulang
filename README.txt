rbridge
    by Chuck Vose (adapted from tosik's RulangBridge)
    ruby-mnesia.rubyforge.com (originally http://code.google.com/p/rulangbridge/)

== DESCRIPTION:
  
RBridge allows the use of Erlang code within a Ruby program. Optionally allowing
asynchronous access and ruby-like syntax or by using Erlang code directly when
more expressive or complex code is needed.

== FEATURES/PROBLEMS:
  
* Allows use of Erlang code within Ruby
* Doesn't yet allow Ruby code within Erlang
* Can't be started headless. Sockets are always closed.

== SYNOPSIS:

  1. Open an Erlang shell from the command line
  $ erl

  2. Start the RBridge server on some port (9900 is what the examples use)
  1> rulang:start_server(9900).

  3. Execute your ruby code by connecting (as shown below) to either the RBridge class if you want
  asynchronous access and ruby style code access, or by connecting to the Erlang
  class if you need more complicated code evaluation.

  # load the library
  require 'rbridge'

  # Connect to localhost on port 9900 and using only the erlang module。
  r_erlang = RBridge.new("erlang", "localhost", 9900)

  # This is equivalent to erlang:length([1,2,3,4,5,6,7,8,9]).
  p r_erlang.length([1,2,3,4,5,6,7,8,9])
  # => 9

  # Run Erlang code directly
  a = RBridge.new(nil, "localhost", 9900)
  p a.erl("10*10.")
  # => 100

== REQUIREMENTS:

* Erlang (erlang.org) -
  There are current windows binaries as well as source for other oses. Installing
  on OS X should just need: ./configure --prefix=/opt/local && make && sudo make install.
  
* Ruby (ruby-lang.org) -
  On the downloads page if you skip past the source downloads there are a lot
  of one-click installers for various oses. If you go with source you at least
  need to install rubygems from rubygems.org.

== INSTALL:

* sudo gem install rulang

== LICENSE:

RBridge - A Ruby to Erlang bridge allowing the use of Erlang commands within 
normal Ruby code.
Copyright (C) 2007 Toshi Hirooka
Copyright (C) 2008 tosik <toshi.hirooka@gmail.com>, Chuck Vose <vosechu@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.