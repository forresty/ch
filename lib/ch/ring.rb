require "digest/sha1"
require_relative 'avl_tree'

module ConsistentHashing
  class Ring
    def initialize
      @tree = AVLTree.new
    end

    # a node can be inserted into multiple positions
    def add_node(node, position=nil)
      position ||= hash_for_key(node)

      @tree[position] = node
    end

    def delete_node_at_position(position)
      @tree.delete(position)
    end

    def delete_node(node)
      @tree.each_key { |key| @tree.delete(key) if @tree[key] == node }
    end

    def node_for_key(key)
      return nil if @tree.empty?
      key = hash_for_key(key)
      _, value = @tree.next_gte_pair(key)
      _, value = @tree.minimum_pair unless value
      value
    end

    def nodes
      @tree.values.uniq
    end

    def positions
      @tree.keys
    end

    def hash_for_key(key)
      Digest::SHA1.hexdigest(key.to_s).hex
    end
  end
end
