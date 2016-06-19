require 'ffi'
require 'ffi-compiler/loader'

class BitVector
  extend FFI::Library
  ffi_lib FFI::Compiler::Loader.find("bitvector")
  attr_accessor :data, :bits

  class BitVectorStruct < FFI::Struct
    layout(
      :bits, :long,
      :num_container, :uint,
      :container, :pointer,
    )
  end

  def initialize(n)
    if n.class == Fixnum
      @bits = n
      @data = BitVector.alloc(n)
    elsif n.class == String
      @bits = n.length
      @data = BitVector.from_string(n)
    end
  end

  def delete
    BitVector.dealloc(@data)
  end

  def set(n)
    if @bits <= n
      raise Exception, "bit range is exceeding: size is #{@bits}"
    end
    BitVector.set_bit(@data, n)
  end

  def clear(n)
    if @bits <= n
      raise Exception, "bit range is exceeding: size is #{@bits}"
    end
    BitVector.clear_bit(@data, n)
  end

  def get(n)
    if @bits <= n
      raise Exception, "bit range is exceeding: size is #{@bits}"
    end
    BitVector.get_bit(@data, n)
  end

  def [](n)
    self.get(n)
  end

  def set_all
    BitVector.set_all_bits(@data)
  end

  def clear_all
    BitVector.clear_all_bits(@data)
  end

  def to_s
    BitVector.to_string(@data)
  end

  def concat(other)
    unless other.class == self.class
      raise Exception, "concat require BitArray object"
    end
    vector = BitVector.c_concat(@data, other.data)
    new = BitVector.new(vector[:bits])
    new.data = vector
    new
  end

  def []=(index, value)
    if value == 0
      BitVector.clear_bit(@data, index)
    elsif value == 1
      BitVector.set_bit(@data, index)
    else
      raise Exception, "BitVector value must be binary"
    end
  end

  def &(other)
    unless other.class == self.class
      raise Exception, "intersect require BitArray object"
    end
    vector = BitVector.c_intersect(@data, other.data)
    new = BitVector.new(vector[:bits])
    new.data = vector
    new
  end

  def |(other)
    unless other.class == self.class
      raise Exception, "union require BitVector object"
    end
    vector = BitVector.c_union(@data, other.data)
    new = BitVector.new(vector[:bits])
    new.data = vector
    new
  end

  def conjunction(other)
    unless other.class == self.class
      raise Exception, "conjunction require BitVector object"
    end
    vector = BitVector.c_conjunction(@data, other.data)
    new = BitVector.new(vector[:bits])
    new.data = vector
    new
  end

  def exclusive(other)
    unless other.class == self.class
      raise Exception, "exclusive require BitVector object"
    end
    vector = BitVector.c_exclusive(@data, other.data)
    new = BitVector.new(vector[:bits])
    new.data = vector
    new
  end

  def slice(from, to)
    unless from < to and to <= @bits
      raise Exception, "bit range is exceeding"
    end
    vector = BitVector.c_slice(@data, from, to)
    new = BitVector.new(vector[:bits])
    new.data = vector
    new
  end

  def to_decimal
    BitVector.c_to_decimal(@data)
  end

  def count
    BitVector.c_count(@data)
  end

  protected

  attach_function :alloc, [:long], BitVectorStruct.ptr
  attach_function :dealloc, [BitVectorStruct.ptr], :void
  attach_function :c_concat, [BitVectorStruct.ptr, BitVectorStruct.ptr], BitVectorStruct.ptr
  attach_function :set_bit, [BitVectorStruct.ptr, :long], :void
  attach_function :set_all_bits, [BitVectorStruct.ptr], :void
  attach_function :clear_bit, [BitVectorStruct.ptr, :long], :void
  attach_function :clear_all_bits, [BitVectorStruct.ptr], :void
  attach_function :get_bit, [BitVectorStruct.ptr, :long], :bool
  attach_function :to_string, [BitVectorStruct.ptr], :string
  attach_function :from_string, [:string], BitVectorStruct.ptr
  attach_function :c_intersect, [BitVectorStruct.ptr, BitVectorStruct.ptr], BitVectorStruct.ptr
  attach_function :c_union, [BitVectorStruct.ptr, BitVectorStruct.ptr], BitVectorStruct.ptr
  attach_function :c_conjunction, [BitVectorStruct.ptr, BitVectorStruct.ptr], BitVectorStruct.ptr
  attach_function :c_exclusive, [BitVectorStruct.ptr, BitVectorStruct.ptr], BitVectorStruct.ptr
  attach_function :c_to_decimal, [BitVectorStruct.ptr], :uint64
  attach_function :c_slice, [BitVectorStruct.ptr, :long, :long], BitVectorStruct.ptr
  attach_function :c_slice, [BitVectorStruct.ptr, :long, :long], BitVectorStruct.ptr
  attach_function :c_count, [BitVectorStruct.ptr], :uint64
  
end
