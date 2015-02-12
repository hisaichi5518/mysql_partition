# MysqlPartition

Ruby port of Perl's MySQL::Partition

## Usage

```ruby
require 'mysql_partition'

# List Partition
partition = MysqlPartition::SqlMaker.new(type: :list, table: "test", expression: "event_id")

partition.create_partitions("p1" => 1)
    #=> ALTER TABLE test PARTITION BY LIST (event_id) (PARTITION p1 VALUES IN (1))

partition.add_partitions("p2" => "2, 3")
    #=> ALTER TABLE test ADD PARTITION (PARTITION p2 VALUES IN (2, 3))

partition.drop_partitions("p1")
    #=> ALTER TABLE test DROP PARTITION p1

# Range Partition
partition = MysqlPartition::SqlMaker.new(type: :range, table: "test2", expression: "created_at")

partition.create_partitions('p20100101' => '2010-01-01')
    #=> ALTER TABLE test2 PARTITION BY RANGE (created_at) (PARTITION p20100101 VALUES LESS THAN ('2010-01-01'))

partition.add_partitions(
  'p20110101' => '2011-01-01',
  'p20120101' => '2012-01-01',
)
#=> ALTER TABLE test2 ADD PARTITION (PARTITION p20110101 VALUES LESS THAN ('2011-01-01'), PARTITION p20120101 VALUES LESS THAN ('2012-01-01'))

partition.drop_partitions('p20100101')
    #=> ALTER TABLE test2 DROP PARTITION p20100101
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
