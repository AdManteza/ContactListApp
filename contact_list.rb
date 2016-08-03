require_relative 'contact'
require 'pry'
require 'pg'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def initialize
    self.display_menu if ARGV.size == 0
    self.add_contact if ARGV[0] == 'new'
    self.display_list if ARGV[0] == 'list'
    self.show if ARGV[0] == 'show' && ARGV[1].size != 0
    self.search if ARGV[0] == 'search' && ARGV[1].size != 0
    self.search_id if ARGV[0] == 'id'
    self.update if ARGV[0] == 'update' && ARGV[1].size != 0
    self.destroy if ARGV[0] == 'destroy' && ARGV[1].size != 0
  end

  def add_contact
    puts "Add a Name"
    name = STDIN.gets.chomp
    puts "Add an email Address"
    email = STDIN.gets.chomp
    system 'clear'
    Contact.create(name, email)
    display_list
  end

  def display_list
    contacts = Contact.all
    display_result(contacts)
  end

  def show
    id = ARGV[1]
    output_array = Contact.find(id)
    output_array.flatten!
    display_search_result(output_array)
  end

  def search
    contact_detail = ARGV[1]
    contact = Contact.search(contact_detail)
    system 'clear'
    display_result(contact)
  end
 
  def display_menu
    puts "Here is a list of available commands"
    puts "   new - Create a new contact"
    puts "   list - List all contacts"
    puts "   show - Show a contact"
    puts "   search - Search contacts"
    puts "   id - Search by id"
    puts "   update - Update a contact"
    puts "   destroy - Destroy a contact"
  end

  def search_id
    puts "ID number?"
    id = STDIN.gets.chomp
    contact = Contact.find(id)
    display_result(contact)
  end

  def update
    id = ARGV[1]
    contact = Contact.find(id)
    system 'clear'
    puts "UPDATE THIS CONTACT: "
    puts " "
    display_result(contact)
    puts "UPDATE NAME:"
    name = STDIN.gets.chomp
    puts "UPDATE EMAIL:"
    email = STDIN.gets.chomp
    Contact.update(id, name, email) 
    display_list
  end

  def destroy
    id = ARGV[1]
    contact = Contact.find(id)
    display_result(contact)
    puts " "
    puts "CONTACT ID##{id} IS DESTROYED: "
    puts " "
    Contact.destroy(id) 
    display_list
  end

  private

  def display_result(array)
    puts "------------------------------------------------"
    array.each do |contact|
      puts "ID##{contact.id} NAME:#{contact.name} EMAIL:#{contact.email}"
    end
    puts "------------------------------------------------"
    puts "#{array.size} records total"
  end
end

ContactList.new