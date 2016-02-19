module Cg
  class CraftingTable
    attr_reader :string
    attr_accessor :a1
    attr_accessor :b1
    attr_accessor :c1
    attr_accessor :a2
    attr_accessor :b2
    attr_accessor :c2
    attr_accessor :a3
    attr_accessor :b3
    attr_accessor :c3
    attr_accessor :output

    # Creates a new CraftingTable object.
    # @param opts [String/Hash<Symbol, Key>] The full Cg/Crafting Table template call string, or a hash representation.
    # @option opts [String] :a1 The A1 parameter.
    # @option opts [String] :b1 The B1 parameter.
    # @option opts [String] :c1 The C1 parameter.
    # @option opts [String] :a2 The A2 parameter.
    # @option opts [String] :b2 The B2 parameter.
    # @option opts [String] :c2 The C2 parameter.
    # @option opts [String] :a3 The A3 parameter.
    # @option opts [String] :b3 The B3 parameter.
    # @option opts [String] :c3 The C3 parameter.
    # @option opts [String] :o The O parameter.
    def initialize(opts)
      if opts.is_a?(String)
        @string = opts
        @a1 = get_param('A1')
        @b1 = get_param('B1')
        @c1 = get_param('C1')
        @a2 = get_param('A2')
        @b2 = get_param('B2')
        @c2 = get_param('C2')
        @a3 = get_param('A3')
        @b3 = get_param('B3')
        @c3 = get_param('C3')
        @output = string[/\|O=(.*?)\n\}\}/m, 1]
      elsif opts.is_a?(Hash)
        @a1 = opts[:a1]
        @b1 = opts[:b1]
        @c1 = opts[:c1]
        @a2 = opts[:a2]
        @b2 = opts[:b2]
        @c2 = opts[:c2]
        @a3 = opts[:a3]
        @b3 = opts[:b3]
        @c3 = opts[:c3]
        @output = opts[:o]
      end
    end

    # Converts the input data to the crafting grid template call string. This will also re-set the #string
    # attribute to the new formatted Cg.
    # @return [String] Essentially the same thing as @string.
    def to_s
      str = "{{Cg/Crafting Table\n"
      str << "|A1=#{@a1}\n" unless @a1.nil?
      str << "|B1=#{@b1}\n" unless @b1.nil?
      str << "|C1=#{@c1}\n" unless @c1.nil?
      str << "|A2=#{@a2}\n" unless @a2.nil?
      str << "|B2=#{@b2}\n" unless @b2.nil?
      str << "|C2=#{@c2}\n" unless @c2.nil?
      str << "|A3=#{@a3}\n" unless @a3.nil?
      str << "|B3=#{@b3}\n" unless @b3.nil?
      str << "|C3=#{@c3}\n" unless @c3.nil?
      str << "|O=#{@output}\n" unless @output.nil?
      str << '}}'
      @string = str
      str
    end

    # Merges this crafting table with the other one.
    # @param other [Cg::CraftingTable] The other crafting table to merge with.
    # @return [String] The merged crafting grids.
    def merge(other)
      str = "{{Cg/Crafting Table\n"
      str << merge_params('A1', @a1, other.a1)
      str << merge_params('B1', @b1, other.b1)
      str << merge_params('C1', @c1, other.c1)
      str << merge_params('A2', @a2, other.a2)
      str << merge_params('B2', @b2, other.b2)
      str << merge_params('C2', @c2, other.c2)
      str << merge_params('A3', @a3, other.a3)
      str << merge_params('B3', @b3, other.b3)
      str << merge_params('C3', @c3, other.c3)
      str << merge_params('O', @output, other.output)
      str << '}}'
      str
    end

    # Merges two crafting grids together.
    # @param one [Cg::CraftingTable] The first crafting table object.
    # @param two [Cg::CraftingTable] The second crafting table object.
    # @return See #{merge}.
    def self.merge(one, two)
      one.merge(two)
    end

    private

    # Merges two parameter calls together.
    # @param param [String] The parameter name.
    # @param one [String] The first parameter call.
    # @param two [String] The second parameter call.
    # @return [String] The merged parameter calls.
    def merge_params(param, one, two)
      if one.nil? && !two.nil?
        return "|#{param}={{Gc}}#{two}\n"
      end
      if !one.nil? && two.nil?
        return "|#{param}=#{one}{{Gc}}\n"
      end
      if one.nil? && two.nil?
        return ''
      end
      if !one.nil? && !two.nil?
        return "|#{param}=#{one}#{two}\n"
      end
    end

    # Gets the given parameter (A1, B1, etc) for the Cg/Crafting Table string.
    # This assumes that the Cg follows the proper format of having a new parameter on a newline (see #to_s).
    # @param param [String] The template parameter to obtain.
    # @return [String] Everything between param= and the newline.
    def get_param(param)
      @string[/\|#{param}=(.*?)\n/m, 1]
    end
  end
end