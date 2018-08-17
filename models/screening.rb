require_relative("../db/sql_runner")

class Ticket

  attr_accessor :screen, :time, :capacity, :film_id
  attr_reader :id

  def initialize(details)
    @id = details['id'].to_i if details['id']
    @screen = details['screen']
    @time = details['time']
    @capacity = details['capacity']
    @film_id = details['film_id']
  end

  def save()
    sql = "INSERT INTO screenings
    (screen, time, capacity, film_id)
    VALUES
    ($1, $2, $3, $4)
    RETURNING id"
    values = [@screen, @time, @capacity, @film_id]
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
    SET (screen, time, capacity, film_id)
    = ($1, $2, $3, $4)
    WHERE id = $5;"
    values = [@screen, @time, @capacity, @film_id, @id]
    SqlRunner.run(sql, values)
  end

end
