require('minitest/autorun')
require('minitest/rg')
require_relative('../models/customer')

require_relative('../models/customer')
require_relative('../models/film')
require_relative('../models/screening')
require_relative('../models/ticket')


class CustomerTest < Minitest::Test

  def setup

    Ticket.delete_all
    Screening.delete_all
    Film.delete_all
    Customer.delete_all

    num_customers = 2
    num_films = 2
    num_screenings = 2
    num_tickets = 2

    @customers = (1..num_customers).map do |i|
      Customer.new({'name' => 'Cname'+i.to_s, 'funds' => 100*i})
    end
    (1..num_customers).each {|i| @customers[i-1].save}

    @films = (1..num_films).map do |i|
      Film.new({'title' => 'Ftitle'+i.to_s, 'price' => 1*i})
    end
    (1..num_films).each {|i| @films[i-1].save}

    @screenings = (1..num_screenings).map do |i|
      Screening.new({'screen' => i, 'start_time' => (12+i).to_s + ":00", 'capacity' => 10*i, 'film_id' => @films[i-1].id})
    end
    (1..num_screenings).each {|i| @screenings[i-1].save}

    @tickets = (1..num_tickets).map do |i|
      Ticket.new({'customer_id' => @customers[i-1].id, 'screening_id' => @screenings[i-1].id})
    end
    (1..num_tickets).each {|i| @tickets[i-1].save}

    @screening100 = Screening.new({'screen' => 1, 'start_time' => (12).to_s + ":00", 'capacity' => 5, 'film_id' => @films[0].id})
    @screening100.save
    @screening101 = Screening.new({'screen' => 1, 'start_time' => (14).to_s + ":00", 'capacity' => 5, 'film_id' => @films[0].id})
    @screening101.save
    # 5 tickets to s100
    Ticket.new({'customer_id' => @customers[0].id, 'screening_id' => @screening100.id}).save
    Ticket.new({'customer_id' => @customers[0].id, 'screening_id' => @screening100.id}).save
    Ticket.new({'customer_id' => @customers[0].id, 'screening_id' => @screening100.id}).save
    Ticket.new({'customer_id' => @customers[0].id, 'screening_id' => @screening100.id}).save
    Ticket.new({'customer_id' => @customers[0].id, 'screening_id' => @screening100.id}).save
    # 3 tickets to s101
    Ticket.new({'customer_id' => @customers[0].id, 'screening_id' => @screening101.id}).save
    Ticket.new({'customer_id' => @customers[0].id, 'screening_id' => @screening101.id}).save
    Ticket.new({'customer_id' => @customers[0].id, 'screening_id' => @screening101.id}).save


  end

  def test_buy_ticket__decrease_funds_of_customer_by_price
    @customers[0].buy_ticket(@screenings[0])
    assert_equal(99, @customers[0].funds)
  end

  def test_buy_ticket__increase_ticket_count_by_1
    count = @customers[0].ticket_count
    @customers[0].buy_ticket(@screenings[0])
    assert_equal(count+1, @customers[0].ticket_count)
  end

  def test_buy_ticket__at_capacity_no_sale_no_change_funds
    @customers[0].buy_ticket(@screening100)
    assert_equal(100, @customers[0].funds)
  end

  def test_buy_ticket__at_capacity_no_sale_no_change_ticket_count
    count = @customers[0].ticket_count
    @customers[0].buy_ticket(@screening100)
    assert_equal(count, @customers[0].ticket_count)
  end

  def test_buy_ticket__try_to_buy_3_only_get_2
    count = @customers[0].ticket_count
    @customers[0].buy_ticket(@screening101)
    @customers[0].buy_ticket(@screening101)
    @customers[0].buy_ticket(@screening101)
    assert_equal(98, @customers[0].funds)
    assert_equal(count+2, @customers[0].ticket_count)
  end

end
