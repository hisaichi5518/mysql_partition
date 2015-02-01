require 'spec_helper'

describe MysqlPartition::SqlMaker do
  context "when type is :list" do
    let :sql_maker do
      MysqlPartition::SqlMaker.new(
        type: :list,
        table: "test",
        expression: "event_id"
      )
    end

    describe "#build_create_partitions_sql" do
      subject do
        sql_maker.build_create_partitions_sql("p1" => 1)
      end

      it "returns ALTER TABLE" do
        is_expected.to eq "ALTER TABLE test PARTITION BY LIST (event_id) (PARTITION p1 VALUES IN (1))"
      end
    end

    describe "#build_add_partitions_sql" do
      subject do
        sql_maker.build_add_partitions_sql("p2" => "2, 3")
      end

      it "returns ALTER TABLE" do
        is_expected.to eq "ALTER TABLE test ADD PARTITION (PARTITION p2 VALUES IN (2, 3))"
      end
    end

    describe "#build_drop_partitions_sql" do
      subject do
        sql_maker.build_drop_partitions_sql("p1")
      end

      it "returns ALTER TABLE" do
        is_expected.to eq "ALTER TABLE test DROP PARTITION p1"
      end
    end
  end


  context "when type is :range" do
    let :sql_maker do
      MysqlPartition::SqlMaker.new(
        type: :range,
        table: "test2",
        expression: "created_at"
      )
    end

    describe "#build_create_partitions_sql" do
      subject do
        sql_maker.build_create_partitions_sql('p20100101' => '2010-01-01')
      end

      it "returns ALTER TABLE" do
        is_expected.to eq "ALTER TABLE test2 PARTITION BY RANGE (created_at) (PARTITION p20100101 VALUES LESS THAN ('2010-01-01'))"
      end
    end

    describe "#build_add_partitions_sql" do
      subject do
        sql_maker.build_add_partitions_sql(
          'p20110101' => '2011-01-01',
          'p20120101' => '2012-01-01',
        )
      end

      it "returns ALTER TABLE" do
        is_expected.to eq "ALTER TABLE test2 ADD PARTITION (PARTITION p20110101 VALUES LESS THAN ('2011-01-01'), PARTITION p20120101 VALUES LESS THAN ('2012-01-01'))"
      end
    end

    describe "#build_drop_partitions_sql" do
      subject do
        sql_maker.build_drop_partitions_sql("p20100101")
      end

      it "returns ALTER TABLE" do
        is_expected.to eq "ALTER TABLE test2 DROP PARTITION p20100101"
      end
    end
  end


  context "when type is :range and catch-all" do
    let :sql_maker do
      MysqlPartition::SqlMaker.new(
        type: :range,
        table: "test3",
        expression: "TO_DAYS(created_at)",
        catch_all_partition_name: "pmax",
      )
    end

    describe "#build_create_partitions_sql" do
      subject do
        sql_maker.build_create_partitions_sql('p20100101' => "TO_DAYS('2010-01-01')")
      end

      it "returns ALTER TABLE" do
        is_expected.to eq "ALTER TABLE test3 PARTITION BY RANGE (TO_DAYS(created_at)) (PARTITION p20100101 VALUES LESS THAN (TO_DAYS('2010-01-01')), PARTITION pmax VALUES LESS THAN (MAXVALUE))"
      end
    end

    describe "#build_add_catch_all_partition_sql" do
      subject do
        sql_maker.build_add_catch_all_partition_sql
      end

      it "returns ALTER TABLE" do
        is_expected.to eq "ALTER TABLE test3 ADD PARTITION (PARTITION pmax VALUES LESS THAN (MAXVALUE))"
      end
    end

    describe "#build_reorganize_catch_all_partition_sql" do
      subject do
        sql_maker.build_reorganize_catch_all_partition_sql('p20110101' => "TO_DAYS('2011-01-01')")
      end

      it "returns ALTER TABLE" do
        is_expected.to eq "ALTER TABLE test3 REORGANIZE PARTITION pmax INTO (PARTITION p20110101 VALUES LESS THAN (TO_DAYS('2011-01-01')), PARTITION pmax VALUES LESS THAN (MAXVALUE))"
      end
    end
  end
end
