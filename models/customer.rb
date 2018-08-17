require_relative("../db/sql_runner")

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(details)
    @id = details['id'].to_i if details['id']
    @name = details['name']
    @funds = details['funds']
  end

  def save()
    sql = "INSERT INTO customers
    (name, funds)
    VALUES
    ($1, $2)
    RETURNING id"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values).first
    @id = result['id'].to_i
  end

  def self.map_items(data)
    data.map{|item| Customer.new(item)}
  end

  def self.all()
    sql = "SELECT * FROM customers"
    result = SqlRunner.run(sql)
    Customer.map_items(result)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE customers
    SET (name, funds)
    = ($1, $2)
    WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  # def films
  #   sql = "SELECT movies.*
  #   FROM movies
  #   INNER JOIN castings
  #   ON castings.star_id = movies.id
  #   WHERE castings.star_id = $1;"
  #   values = [@id]
  #   movies = SqlRunner.run(sql, values)
  #   return Movie.map_items(movies)
  # end


end
