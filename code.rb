#YOUR CODE GOES HERE
require 'pg'
require 'csv'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: "ingredients")
    yield(connection)
  ensure
    connection.close
  end
end

CSV.foreach('ingredients.csv', headers: true) do |row|
  db_connection do |conn|
    conn.exec_params("INSERT INTO ingredients (step, name) VALUES ($1, $2)", [row["step"], row["name"]])
  end
end

db_connection do |conn|
  results = conn.exec('SELECT * FROM ingredients;')
  results.each do |output|
    puts "#{output['step']}.#{output['name']}"
  end
end
