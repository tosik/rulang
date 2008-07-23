# RBridge - A Ruby to Erlang bridge allowing the use of Erlang commands within 
# normal Ruby code.
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

# require 'rubygems'
# require 'rbridge'
require "#{File.dirname(__FILE__)}/spec_helper"

describe ErlangAdapter do
  attr_reader :adapter
  before do
    @adapter = ErlangAdapter.new
  end

  describe "#to_erlang_literal" do
    it "converts Symbols to atoms" do
      adapter.to_erlang_literal(:an_atom).should == "an_atom"
    end
  end
end