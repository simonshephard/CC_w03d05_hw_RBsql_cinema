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

  def films
    sql = "SELECT films.*
    FROM films
    INNER JOIN screenings
    ON screenings.film_id = films.id
    INNER JOIN tickets
    ON tickets.screening_id = screenings.id
    WHERE tickets.customer_id = $1;"
    values = [@id]
    items = SqlRunner.run(sql, values)
    return Film.map_items(items)
  end

  def tickets
    sql = "SELECT tickets.*
    FROM tickets
    INNER JOIN customers
    ON tickets.customer_id = customers.id
    WHERE tickets.customer_id = $1;"
    values = [@id]
    items = SqlRunner.run(sql, values)
    return Ticket.map_items(items)
  end

  def count_tickets
    results = tickets
    results.length
  end

  def buy_ticket(screening)
    sql = "SELECT films.*
    FROM films
    INNER JOIN screenings
    ON screenings.film_id = films.id
    WHERE film_id = $1;"
    values = [screening.film_id]
    items = SqlRunner.run(sql, values)
    film = Film.map_items(items).first
    @funds -= film.price
    # should also add code to generate a new ticket for film / screening / customer
    # and update database
  end


end
