require_relative("../db/sql_runner")

class Ticket

  attr_accessor :customer_id, :screening_id
  attr_reader :id

  def initialize(details)
    @id = details['id'].to_i if details['id']
    @customer_id = details['customer_id']
    @screening_id = details['screening_id']
  end

  def save()
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
    data.map{|item| Casting.new(item)}
  end

  def self.all
    sql = "SELECT * FROM castings"
    result = SqlRunner.run(sql)
    Casting.map_items(result)
  end

  def self.delete_all
    sql = "DELETE FROM castings"
    SqlRunner.run(sql)
  end

  def delete
    sql = "DELETE FROM castings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE castings
    SET (movie_id, star_id, fee)
    = ($1, $2, $3)
    WHERE id = $4;"
    values = [@movie_id, @star_id, @fee, @id]
    SqlRunner.run(sql, values)
  end

end
