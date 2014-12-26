# ch gem

yet another consistent hashing library

Implemented using AVLTree.

Allow nodes to be inserted into multiple positions.

Allow nodes to be inserted into specific positions for more granular control.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ch

## Usage

```ruby
require 'ch'
ring = ConsistentHashing::Ring.new

# add nodes
ring.add_node('127.0.0.1:6379')                 # key 102336333644841978549106395032298540172546507605
ring.add_node('127.0.0.1:6380')                 # key 455838294994277962587720662485947692006035699684

# between nodes
ring.node_for_key(1).should == '127.0.0.1:6380' # key 304942582444936629325699363757435820077590259883

# larger than both nodes
ring.node_for_key(2).should == '127.0.0.1:6379' # key 1246245281287062843477446394631337292330716631216

# pin point!
ring.add_node('127.0.0.1:6381', 304942582444936629325699363757435820077590259883 + 1)
ring.node_for_key(1).should == '127.0.0.1:6381'


# key is simply computed with:
Digest::SHA1.hexdigest(key.to_s).hex
```

## Contributing

1. Fork it ( https://github.com/forresty/ch/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
