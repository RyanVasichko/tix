Pagy::DEFAULT[:items] = 10 # items per page
Pagy::DEFAULT[:size] = [1, 2, 2, 1] # nav bar links

require "pagy/extras/overflow"
Pagy::DEFAULT[:overflow] = :last_page
