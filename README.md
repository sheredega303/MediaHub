##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [3.2.0](https://github.com/sheredega303/MediaHub/blob/main/.ruby-version)
- Rails [7.2.1](https://github.com/sheredega303/MediaHub/blob/main/Gemfile)

##### 1. Check out the repository

```bash
git clone git@github.com:sheredega303/MediaHub.git
```

##### 2. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rails db:create
bundle exec rails db:setup
```

##### 3. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000

##### 4. GraphQL Documentation and Playground for API

The GraphQL API documentation is available at http://localhost:3000/graphiql.

You can also use this interface to test and run queries or mutations against the API. It provides an interactive playground where you can explore the available queries, mutations, and data structure of the API.
