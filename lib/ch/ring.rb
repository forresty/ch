require "digest/sha1"

module ConsistentHashing
  class Ring
    def initialize
    end

    # a node can be inserted into multiple positions
    def add_node(node, position=nil)
      raise 'not implemented yet'
    end

    def hash_for_key(key)
      Digest::SHA1.hexdigest(key.to_s).hex
    end
  end
end
