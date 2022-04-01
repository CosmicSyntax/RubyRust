# frozen_string_literal: true
require 'rutie'

Rutie.new(:rubygogo).init 'Init_rutie_ruby_example', __dir__

# Make the announcement
system "clear"

puts "Provide me with a number 10_000_000 or greater."
puts "Try a billion for fun."
big_num = gets.to_i

if big_num < 10_000_000
  abort "Number is too low"
end

puts "Starting #{big_num} iteration(s) for Ruby and Rust.\n\n"

# Iterating a billion time using C FFI with Rust
@s = 0
handle = Thread.new do
  timestart = Time.now
  @s = RutieExample.iterate big_num
  timeend = Time.now
  puts "Rust finished in #{1000 * (timeend.to_f - timestart.to_f)} millisecond(s)."
  puts "Let's now go back to Ruby, and then compare the answers."
  puts "This may take awhile... please do hold on.\n\n"
end

# Iterating a billion time natively in Ruby
@x = 0
handle_ruby = Thread.new do
  timestart = Time.now
  @x = 0
  for i in 0...big_num do
    @x += i
  end
  timeend = Time.now
  puts "Ruby finished in #{1000 * (timeend.to_f - timestart.to_f)} millisecond(s).\n\n"
end

handle_ruby.join
handle.join
puts "Rust answer: #{@s}"
puts "Ruby answer: #{@x}"

if @s.eql? @x
  puts "\nHOORAY. they match!"
else
  puts "\nHoly crap, they don't match. Well this demo is a bust! :`("
end
