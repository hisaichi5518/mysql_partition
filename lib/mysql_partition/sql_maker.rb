require "mysql_partition/type"

module MysqlPartition
  class SqlMaker

    attr_accessor :type, :table, :expression, :args
    def initialize(hash)
      if !(hash[:type] and hash[:table] and hash[:expression])
        raise ArgumentError, "need type, table and expression"
      end
      @type = hash[:type].to_s.upcase
      @table = hash[:table]
      @expression = hash[:expression]
      @args = hash

      klass = Object.const_get "::MysqlPartition::Type::#{type.capitalize}"
      self.class.prepend klass
    end

    def build_create_partitions_sql(hash)
      sprintf 'ALTER TABLE %s PARTITION BY %s (%s) (%s)',
        table, type, expression, build_partition_parts(hash)
    end

    def build_add_partitions_sql(hash)
      sprintf 'ALTER TABLE %s ADD PARTITION (%s)',
        table, build_partition_parts(hash)
    end

    def build_drop_partitions_sql(*partition_names)
      sprintf 'ALTER TABLE %s DROP PARTITION %s',
        table, partition_names.join(', ')
    end

    private
    # build_partition_parts("p1" => 1, ...)
    def build_partition_parts(hash)
      parts = []
      hash.each do |partition_name, partition_description|
        part = build_partition_part(partition_name, partition_description)
        parts.push(part)
      end
      parts.join(", ")
    end
  end
end
