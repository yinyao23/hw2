class Movie < ActiveRecord::Base
    def self.all_ratings
        Movie.select(:rating).map(&:rating).uniq
        # Movie.uniq.pluck(:rating)
    end
    
    def self.with_ratings(ratings_list)
        if ratings_list == []
            return Movie.all
        else
            return Movie.where({rating: ratings_list})
        end
    end
end
