Pagy::DEFAULT[:items] = 15 # items per page
Pagy::DEFAULT[:size] = [2, 0, 0, 2] # nav bar links

require "pagy/extras/overflow"
Pagy::DEFAULT[:overflow] = :last_page
