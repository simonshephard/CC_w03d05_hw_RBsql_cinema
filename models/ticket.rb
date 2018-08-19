require_relative("../db/sql_runner")

class Ticket

  attr_accessor :customer_id, :screening_id
  attr_reader :id

  def initialize(details)
    @id = details['id'].to_i if details['id']
    @customer_id = details['customer_id'].to_i
    @screening_id = details['screening_id'].to_i
  end

  def save
    sql = "INSERT INTO tickets
    (customer_id, screening_id)
    VALUES
    ($1, $2)
    RETURNING id"
    values = [@customer_id, @screening_id]
    result = SqlRunner.run(sql, values).first
    @id = result['id'].to_i
  end

  def self.map_items(data)
    data.map{|item| Ticket.new(item)}
  end

  def self.all
    sql = "SELECT * FROM tickets"
    result = SqlRunner.run(sql)
    Ticket.map_items(result)
  end

  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE tickets
    SET (customer_id, screening_id)
    = ($1, $2)
    WHERE id = $3;"
    values = [@customer_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

end
