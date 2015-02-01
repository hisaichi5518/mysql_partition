module MysqlPartition
  module Type
    module List

      private
      def build_partition_part(partition_name, partition_description)
        # TODO: support comment, description
        sprintf 'PARTITION %s VALUES IN (%s)',
          partition_name, partition_description;
      end
    end
  end
end
