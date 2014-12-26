require "spec_helper"

module ConsistentHashing
  describe Ring do
    it { should respond_to :add_node }
    it { should respond_to :nodes }
    it { should respond_to :hash_for_key }
    it { should respond_to :node_for_key }
    it { should respond_to :delete_node_at_position }
    it { should respond_to :delete_node }

    describe '#add_node' do
      it 'adds' do
        subject.add_node('127.0.0.1:6379')

        subject.nodes.should == %w{ 127.0.0.1:6379 }

        subject.add_node('127.0.0.1:6379')
        subject.add_node('127.0.0.1:6380')

        subject.nodes.should == %w{ 127.0.0.1:6379 127.0.0.1:6380 }
      end
    end

    describe '#node_for_key' do
      it 'finds' do
        # show hash keys
        subject.hash_for_key('127.0.0.1:6379').should == 102336333644841978549106395032298540172546507605
        subject.hash_for_key('127.0.0.1:6380').should == 455838294994277962587720662485947692006035699684

        subject.hash_for_key(1).should                == 304942582444936629325699363757435820077590259883
        subject.hash_for_key(2).should                == 1246245281287062843477446394631337292330716631216
        subject.hash_for_key(3).should                == 684329801336223661356952546078269889038938702779
        subject.hash_for_key(4).should                == 156380102318965990264666286018191900590658905210


        # add nodes
        subject.add_node('127.0.0.1:6379')
        subject.add_node('127.0.0.1:6380')

        # between nodes
        subject.node_for_key(1).should == '127.0.0.1:6380'

        # larger than both nodes
        subject.node_for_key(2).should == '127.0.0.1:6379'

        # pin point!
        subject.add_node('127.0.0.1:6381', 304942582444936629325699363757435820077590259883 + 1)
        subject.node_for_key(1).should == '127.0.0.1:6381'

        # same point works as well
        subject.add_node('127.0.0.1:6382', 1246245281287062843477446394631337292330716631216)
        subject.node_for_key(2).should == '127.0.0.1:6382'

        # same point can be inserted into multiple positions
        subject.node_for_key(4).should == '127.0.0.1:6381'
        subject.add_node('127.0.0.1:6379', 156380102318965990264666286018191900590658905210)
        subject.node_for_key(4).should == '127.0.0.1:6379'
        # remove pinned point
        subject.delete_node_at_position(1246245281287062843477446394631337292330716631216)
        subject.node_for_key(2).should == '127.0.0.1:6379'
      end
    end

    describe '#delete_node' do
      it 'deletes all positions' do
        subject.add_node('127.0.0.1:6379', 1)
        subject.add_node('127.0.0.1:6379', 2)

        subject.positions.should == [1, 2]
        subject.nodes.count.should == 1

        subject.delete_node('127.0.0.1:6379')

        subject.positions.should == []
        subject.nodes.count.should == 0
      end
    end

    describe '#hash_for_key' do
      it 'generates different hash' do
        subject.hash_for_key(1).should_not == subject.hash_for_key(2)
      end
    end
  end
end
