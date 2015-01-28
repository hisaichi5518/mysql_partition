# MysqlPartition

Ruby port of Perl's MySQL::Partition

## Usage

```ruby
require 'mysql2'
require 'mysql_partition'

client = Mysql2::Client.new(:host => "localhost", :username => "root")
partition = MysqlPartition.new(type: :list, table: "tablename", expression: "created_at", client: client)
partition.partitioned?

partition.create(...)
partition.add(...)
partition.drop(...)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mysql_partition'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mysql_partition

## Contributing

1. Fork it ( https://github.com/hisaichi5518/mysql_partition/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
