class Movie < ActiveRecord::Base
    def self.all_ratings
        Movie.select(:rating).map(&:rating).uniq
        # Movie.uniq.pluck(:rating)
    end
    
    def self.with_ratings(ratings_list)
        Movie.where({rating: ratings_list})
    end
end
