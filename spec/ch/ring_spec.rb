require "spec_helper"

module ConsistentHashing
  describe Ring do
    it { should respond_to :add_node }
    it { should respond_to :hash_for_key }

    describe '#hash_for_key' do
      it 'generates different hash' do
        subject.hash_for_key(1).should_not == subject.hash_for_key(2)
      end
    end
  end
end
