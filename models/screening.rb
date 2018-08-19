require_relative("../db/sql_runner")

class Screening

  attr_accessor :screen, :start_time, :capacity, :film_id
  attr_reader :id

  def initialize(details)
    @id = details['id'].to_i if details['id']
    @screen = details['screen'].to_i
    @start_time = details['start_time']
    @capacity = details['capacity'].to_i
    @film_id = details['film_id'].to_i
  end

  def save()
    sql = "INSERT INTO screenings
    (screen, start_time, capacity, film_id)
    VALUES
    ($1, $2, $3, $4)
    RETURNING id"
    values = [@screen, @start_time, @capacity, @film_id]
    result = SqlRunner.run(sql, values).first
    @id = result['id'].to_i
  end

  def self.map_items(data)
    data.map{|item| Screening.new(item)}
  end

  def self.all
    sql = "SELECT * FROM screenings"
    result = SqlRunner.run(sql)
    Screening.map_items(result)
  end

  def self.delete_all
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE screenings
    SET (screen, start_time, capacity, film_id)
    = ($1, $2, $3, $4)
    WHERE id = $5;"
    values = [@screen, @start_time, @capacity, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def tickets
    sql = "SELECT tickets.*
    FROM tickets
    WHERE tickets.screening_id = $1;"
    values = [@id]
    items = SqlRunner.run(sql, values)
    return Ticket.map_items(items)
  end

  def ticket_count
    tickets.length
  end


end
