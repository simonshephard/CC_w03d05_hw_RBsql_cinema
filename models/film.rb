require_relative("../db/sql_runner")

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(details)
    @id = details['id'].to_i if details['id']
    @title = details['title']
    @price = details['price']
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
    sql = "DELETE FROM movies WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE movies
    SET (title, genre, budget)
    = ($1, $2, $3)
    WHERE id = $4;"
    values = [@title, @genre, @budget, @id]
    SqlRunner.run(sql, values)
  end

  def stars
    sql = "SELECT stars.*
    FROM stars
    INNER JOIN castings
    ON castings.movie_id = stars.id
    WHERE castings.movie_id = $1;"
    values = [@id]
    stars = SqlRunner.run(sql, values)
    return Star.map_items(stars)
  end

# preferable to convert to ruby objects and then use the objects to get data
# avoids fiddling with sql and also provides objects for further use
  def net_budget
    sql = "SELECT castings.fee
    FROM stars
    INNER JOIN castings
    ON castings.movie_id = stars.id
    WHERE castings.movie_id = $1;"
    values = [@id]
    fees = SqlRunner.run(sql, values)
    total = @budget
    for fee in fees
      total -= fee["fee"].to_i
    end
    return total
  end

end
