dir = File.dirname(__FILE__)
Dir.chdir("#{dir}/..") do
  Dir["#{File.dirname(__FILE__)}/**/*_spec.rb"].each do |file|
    require file
  end
end