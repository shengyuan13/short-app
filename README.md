# Intial Setup

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json
    curl -X POST -d "full_url=javascript:alert("Hello World");" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect (change abc with a valid shorted_url code generated)

    curl -I localhost:3000/abc

# URL shortener algorithm used
    The method used to solve this challenge was converting the short_urls table 'id' field which is in decimals(base-10) into base-36
    This was posible by doing "id.to_s(36)" which will always return a diferent shorted_url.
    
    Examples:
        base-10   |  base-36
          1             1
          16            G
          123           3F
          12345         9IX
    
    Note: we can see that the base-36 code length will keep incresing, the higher the base-10 code we have.
