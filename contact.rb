require 'pg'
require 'pry'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  class NonExistentRecordError < StandardError
  end

  class ExistingContactError < StandardError
  end

  attr_accessor :name, :email
  attr_reader :id
  
  def initialize(id, name, email)
    @id = id
    @name = name
    @email = email
  end

  class << self
    def conn
      PG.connect(
        host: 'localhost',
        dbname: 'contactlist',
        user: 'development',
        password: 'development'
      )
    end

    # displays all the contacts
    def all
      result = conn.exec('select * from contacts;')
      
      result.map { |contact| instance_from_row(contact) }
    end

    # creates a new contact
    def create(name, email)
      result = self.search(email)

      raise ExistingContactError, "Email is already used!" unless result == []
      
      save(name,email)
    end

    # saves the new created contact into the database
    def save(name, email)
      conn.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2) returning id;',[name, email])
    end
  
    # search id
    def find(id)
      result = conn.exec_params('SELECT * FROM contacts WHERE id = $1::int;', [id])
      
      contact = result.map { |contact| instance_from_row(contact) }

      raise NonExistentRecordError, 'No Contact by that ID' if contact == []

      contact
    end
    
    # search by name or email
    def search(contact_detail)
      result = conn.exec_params('SELECT * FROM contacts WHERE name ILIKE $1 OR email ILIKE $1;', ["%#{contact_detail}%"])
      
      contact = result.map { |contact| instance_from_row(contact) }

      raise NonExistentRecordError, 'No Contact found' if contact == []

      contact
    end

    # updates contact
    def update(id, name, email)
      contact = self.find(id)
      contact.each do |person|
        person.name = name
        person.email = email
      end

      conn.exec_params('UPDATE contacts SET name = $1, email = $2 WHERE id = $3::int;', [name, email, id])
    end

    # deletes the record
    def destroy(id)
      conn.exec_params('DELETE FROM contacts WHERE id = $1::int;', [id])
    end

    private

    def instance_from_row(row)
      Contact.new(row['id'], row['name'], row['email'])
    end
  end
end







