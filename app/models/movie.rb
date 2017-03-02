class Movie < ActiveRecord::Base
    def self.ratings
    %w(G PG PG-13 R)
end

def self.conditions_orders(ratings, order_by_column)
movies = Movie.all
movies = movies.where(:rating => ratings)
movies = movies.order(order_by_column) if order_by_column.present?
movies
end

end
