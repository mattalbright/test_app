test_app
========

This is a Padrino app that works fine under 0.11, but fails under 0.12 for a variety of reasons.

It works under Ruby 1.9.3 and 2.1.1.

To test, just run:
`bundle install --local`
`bin/rspec spec`

And to run the server:
`bin/padrino start`

And then hit http://localhost:3000/v2/catalogs/abcdef/assets/123456 to see a JSON response.

