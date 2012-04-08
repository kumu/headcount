# Headcount

Headcount provides a simple way for you to track usage of your rails apps.  If you can write a query for it, headcount can track it for you.

Headcount is released under the MIT-LICENSE.

# Installation

```
gem install headcount
```

or add it to your Gemfile

```
# Gemfile
gem 'headcount'
```

# Configuration

Configure Headcount through a rails initializer.  Here's an example:

```
# config/initializers/headcount.rb
Headcount.configure do |config|
  config.path       = 'db/headcount.json' # default
  config.timestamp  = '%Y-%m-%d %H:%M:%S' # default (YYYY-MM-DD HH:MM:SS)
  
  # by default Headcount will use the underlying table name for the key
  count User                          # :users key implied
  count User.where(:active => true)   # will also use implied :users key
  
  # you can specify the key yourself if you'd like to override the default
  count User.active, :as => :active_members
  
  # if you're fine with using default keys you can pass a list of queries instead
  count User, Account
end
```

The `count` method accepts any object that responds to `count` -- could be `ActiveRecord::Base`, `ActiveRecord::Relation`, or your own homegrown query object. The second argument is an options hash that currently only supports the `:as` option, which allows you to override the default key.

If you'd like to access or reconfigure Headcount outside of the initializer you can access the configuration object via
`Headcount.settings`.

# Usage

Fire up `rails c` and run:

```
Headcount.count # will return current headcount as a hash
```

If you'd like to have the results written to disk instead just use the bang version:

```
Headcount.count! # will append the results to the output file
```

## Seeding

If you have a history of data that you'd like to generate headcounts you can give the `seed` method a try.

**Notice** For seeding to work your queries must respond to `where` and the underlying table must have a `created_at` column. If resulting historical query is invalid, the headcount will just fall back to the original query.

```
Headcount.seed(2.years.ago, 1.day) # preview the historical headcounts
```

If you're happy with the data, simply call the bang version to write it to disk:

```
Headcount.seed!(2.years.ago, 1.day) # WARNING: this will overwrite any existing data
```


## Scheduling

Your options are open as far as scheduling goes.  If you like crontab, use [crontab](http://crontab.org/) or [whenever](https://github.com/javan/whenever). If you prefer something else, give [clockwork](https://github.com/tomykaira/clockwork) a shot.

You have two options for triggering a headcount.

1. Call it directly: `Headcount.count!`
2. Use the rake task: `rake headcount` (executes headcount via `script/rails runner`)

In the future I may write a daemon to simplify the scheduling process with an upstart script to boot, but for now you're on your own.

### Crontab example

```
# run daily at midnight
0 0 * * * bash --login -c 'cd [YOUR RAILS APP DIR] && script/rails runner -e production "Headcount.count!"'
```

### Whenever example

```
# schedule.rb
every 1.day do
  runner "Headcount.count!"
end
```

### Clockwork example

TODO

# Credit

Headcount was created for use at Kumu (http://kumupowered.com)