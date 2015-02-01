require 'spec_helper'

describe MysqlPartition do
  it 'has a version number' do
    expect(MysqlPartition::VERSION).not_to be nil
  end
end
