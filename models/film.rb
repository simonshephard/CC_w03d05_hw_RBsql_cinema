require_relative("../db/sql_runner")

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(details)
    @id = details['id'].to_i if details['id']
    @title = details['title']
    @price = details['price'].to_i
  end

  def save()
    sql = "INSERT INTO films
    (title, price)
    VALUES
    ($1, $2)
    RETURNING id"
    values = [@title, @price]
    result = SqlRunner.run(sql, values).first
    @id = result['id'].to_i
  end

  def self.map_items(data)
    data.map{|item| Film.new(item)}
  end

  def self.all()
    sql = "SELECT * FROM films"
    result = SqlRunner.run(sql)
    Film.map_items(result)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE films
    SET (title, price)
    = ($1, $2)
    WHERE id = $3;"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def customers
    sql = "SELECT customers.*
    FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    INNER JOIN screenings
    ON tickets.screening_id = screenings.id
    WHERE screenings.film_id = $1;"
    values = [@id]
    items = SqlRunner.run(sql, values)
    return Customer.map_items(items)
  end

  def customer_count
    results = customers
    results.length
  end

  def screenings
    sql = "SELECT screenings.*
    FROM screenings
    WHERE screenings.film_id = $1;"
    values = [@id]
    items = SqlRunner.run(sql, values)
    Screening.map_items(items)
  end

  def most_popular_screening
    most_popular = screenings.max_by {|screening| screening.count_tickets}
  end




end
