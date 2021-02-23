class Movie < ActiveRecord::Base
    # @all_ratings = Movie.ratings
    
    def self.with_ratings(ratings_list)
        return Movie.all if ratings_list == nil
        return Movie.where(rating: ratings_list)
    end
end
