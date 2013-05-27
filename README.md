#### WHY I EXIST

I exist so that you can make api calls for multiple services without ever breaking their rate limits


#### HOW TO INSTALL ME LOCALLY

    * use ruby 1.9.3
    * you must have a redis server running locally on the default port - 6379
    * be aware that the specs & the rake task will connect using redis db 9. The specs will flush db 9

    git clone git://github.com/jamesshipton/api_throttler.git
    cd api_throttler
    bundle


#### HOW TO RUN MY TESTS
    
    rspec


#### HOW TO RUN THROW A SELECTION OF RANDOMLY TIMED API CALLS AT ME

    rake
