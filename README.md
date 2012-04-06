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
  config.timestamp  = ''                  # default (YYYY-MM-DD HH:MM:SS)
  
  # by default Headcount will use the underlying table name for the key
  count User                          # :users key implied
  count User.where(:active => true)   # will also use implied :users key
  
  # you can specify the key yourself if you'd like to override the default
  count User.active, :as => :active_members
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

## Scheduling

Your options are open as far as scheduling goes.  If you like [crontab](http://crontab.org/), use crontab. If you prefer [clockwork](https://github.com/tomykaira/clockwork), use clockwork. 

You have two options for triggering a headcount.

1. Call `Headcount.count!` directly
2. Use `rake headcount`

In the future I may write a daemon to simplify the scheduling process with an upstart script to boot, but for now you're on your own.

# Credit

Headcount was created for use at Kumu (http://kumupowered.com)