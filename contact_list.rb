require_relative 'contact'
require 'pry'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def initialize
    self.display_menu if ARGV.size == 0
    # binding.pry
    self.add_contact if ARGV[0] == 'new'
    self.display_list if ARGV[0] == 'list'
    self.show if ARGV[0] == 'show' && ARGV[1].size != 0
  end

  def add_contact
    puts "Add a Name"
    name = STDIN.gets.chomp
    puts "Add an email Address"
    email = STDIN.gets.chomp
    Contact.create(name, email)
  end

  def display_list
    output_array = Contact.all
    output_array.each_with_index do |row, index|
      puts "#{index+1}: #{row[0]} (#{row[1]})"
    end
    puts "-----------------------------"
    puts "#{output_array.size} records total"
  end

  def show
    id = ARGV[1]
    p Contact.find(id)
  end
 
  def display_menu
    puts "Here is a list of available commands"
    puts "   new - Create a new contact"
    puts "   list - List all contacts"
    puts "   show - Show a contact"
    puts "   search - Search contacts"
  end

end

ContactList.new