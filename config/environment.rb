require 'sqlite3'
require_relative '../lib/helper'
require_relative '../lib/student'

DB = {:conn => SQLite3::Database.new("db/students.db")}

class String
  def sql_exec(*args)
    DB[:conn].execute(self, *args)
  end
end
