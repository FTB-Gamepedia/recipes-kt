module RecipeParsers
  class ItemStack
    # @return [String] The ItemStack code snippet. E.g., "new ItemStack(Items.emerald, 1, 0);"
    attr_reader :itemstack

    # @return [String] The size of the ItemStack as a string.
    attr_reader :size

    # @return [String] The ItemStack's metadata as a string.
    attr_reader :meta

    # @return [String] The ItemStack's item as a string. This is typically the top-level key in the mappings.
    attr_reader :item

    def initialize(itemstack)
      @itemstack = itemstack
    end

    # Parses the ItemStack code snippet and sets the instance attributes.
    # @return [ItemStack] The ItemStack object.
    def parse
      itemstack = @itemstack.split('new ItemStack(')[1]
      itemstack.gsub!(')', '')
      itemstack.gsub!(';', '')
      itemstack_array = itemstack.split(', ')
      @item = itemstack_array[0]
      @size = itemstack_array[1]
      @meta = itemstack_array[2]
      self
    end

    # @param map [Hash] The item's mappings.
    # @return [String] The Gc template for the ItemStack.
    def gc(map)
      if map['meta']
        gc = "{{Gc|mod=#{map['mod']}|dis=false|#{map['names'][@meta.to_i]}"
        gc << "|#{@size}" if !@size.nil? && @size.to_i > 1
        gc << '}}'
      else
        gc = "{{Gc|mod=#{map['mod']}|dis=false|#{map['name']}"
        gc << "|#{@size}" if !@size.nil? && @size.to_i > 1
      end

      gc
    end
  end
end