module MysqlPartition
  module Type
    module Range

      def build_create_partitions_sql(hash)
        if catch_all_partition_name
          hash.merge!(catch_all_partition_name => "MAXVALUE")
        end
        super(hash)
      end

      def build_add_catch_all_partition_sql
        unless catch_all_partition_name
          raise "catch_all_partition_name isn't specified"
        end

        sprintf 'ALTER TABLE %s ADD PARTITION (%s)',
          table, build_partition_part(catch_all_partition_name, 'MAXVALUE');
      end

      def build_reorganize_catch_all_partition_sql(hash)
        unless catch_all_partition_name
          raise "catch_all_partition_name isn't specified"
        end

        sprintf 'ALTER TABLE %s REORGANIZE PARTITION %s INTO (%s, PARTITION %s VALUES LESS THAN (MAXVALUE))',
          table, catch_all_partition_name, build_partition_parts(hash), catch_all_partition_name
      end

      private
      def catch_all_partition_name
        args[:catch_all_partition_name]
      end

      def build_partition_part(partition_name, partition_description)
        # TODO: support comment, description
        if string?(partition_description)
          partition_description = "'#{partition_description}'"
        end

        sprintf 'PARTITION %s VALUES LESS THAN (%s)',
          partition_name, partition_description;
      end

      def string?(v)
        !(integer?(v) || maxvalue?(v) || function?(v))
      end

      def integer?(v)
        v =~ /^[0-9]+$/
      end

      def maxvalue?(v)
        v == 'MAXVALUE'
      end

      def function?(v)
        v =~ /\(/
      end
    end
  end
end
