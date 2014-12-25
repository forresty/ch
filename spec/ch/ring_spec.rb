require "spec_helper"

module ConsistentHashing
  describe Ring do
    it { should respond_to :add_node }
    it { should respond_to :position_for_key }
  end
end
