require_relative "../config/environment.rb"

class Student
  include Helper
  def initialize(*args, **hash)
    vars = %w(name grade id)
    super(vars, args, hash)
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def self.create_table
    sql = <<-SQL
      CREATE TABLE
        students (
          id INTEGER PRIMARY KEY,
          name TEXT,
          grade TEXT
        )
    SQL
    sql.sql_exec
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE
        students
    SQL
    sql.sql_exec
  end

  def save
    if @id.nil?
      puts "new save " + @name

      sql = <<-SQL
        INSERT INTO
          students
          (name, grade)
        VALUES
          (?, ?)
      SQL

      sql.sql_exec(@name, @grade)

      sql = <<-SQL
        SELECT
          MAX(id)
        FROM
          students
      SQL
      @id = sql.sql_exec[0][0]
    else
      sql = <<-SQL
        UPDATE
          students
        SET
          name = ?,
          grade = ?
        WHERE
          id = ?
      SQL

      sql.sql_exec(@name, @grade, @id)
    end

    self
  end

  def self.create(*args, **hash)
    new(*args, **hash).save
  end

  def self.new_from_db(row)
    id, *rest = row
    new(*rest, id)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT
        *
      FROM
        students
      WHERE
        name = ?
    SQL
    new_from_db(sql.sql_exec(name)[0])
  end

  def update
    sql = <<-SQL
      UPDATE
        students
      SET
        name = ?,
        grade = ?
      WHERE
        id = ?
    SQL

    sql.sql_exec(@name, @grade, @id)
  end
end
