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

require 'spec/spec_helper'

describe "RBridge (erlang module)" do
  before(:each) do
    @r_erlang = RBridge.new("erlang", "localhost", 9900)
  end
  
  it "should compute the length of an 8 slot array" do
    @r_erlang.length([1,2,3,4,5,6,7,8,9]).should eql(9)
  end
  
  it "should compute the length of a 14 character string" do
    @r_erlang.length("rulang bridge!").should eql(14)
  end
end

describe "RBridge (erl_syntax module)" do
  before(:each) do
    @r_erl_syntax = RBridge.new("erl_syntax", "localhost", 9900)
  end
  
  it "should return the syntax tree of the term \"test\"" do
    @r_erl_syntax.abstract("test").should eql(["tree", "string", ["attr", 0, [], "none"], "test"])
  end
end

describe "RBridge (asynchronous erlang module)" do
  before(:each) do
    @ar_erlang = RBridge.new("erlang", "localhost", 9900, true)
  end
  
  it "should display three messages in the order they're executed" do
    out = ""
    
    thread = @ar_erlang.length([6,3,5,2,4,1], proc { |x|
      out << "#{x}"
      out << "second"
    })
    out << "first"
    thread.join
    
    out.should eql("first6second")
  end
  
  it "should display three messages in the order they're executed" do
    out = ""
    
    thread = @ar_erlang.erl("erlang:length([6,3,5,2,4,1]).", proc { |x|
      out << "#{x}"
      out << "second"
    })
    out << "first"
    thread.join
    
    out.should eql("first6second")
  end
end

describe "Direct Erlang code" do
  before(:each) do
    @e_raw = RBridge.new(nil, "localhost", 9900)
  end
  
  it "should evaluate mathematical expressions" do
    @e_raw.erl("10*10.").should eql(100)
  end
end