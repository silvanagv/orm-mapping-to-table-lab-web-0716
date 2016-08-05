class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS
      students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    sql2 = <<-SQL
      SELECT id FROM students
      ORDER BY id DESC
      LIMIT 1
    SQL

    results = DB[:conn].execute(sql2)
    @id = results[0][0]
    self

  end

  def self.create(attributes)
    new_student = Student.new(attributes[:name], attributes[:grade])
    new_student.save
  end

end
