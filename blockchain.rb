require "digest"
require "pp"

class Block
  attr_reader :index, :timestamp, :data, :previous_hash, :nonce, :hash

  def initialize(index, data, previous_hash)
    @index = index
    @timestamp = Time.now
    @data = data
    @previous_hash = previous_hash
    @nonce, @hash = compute_hash_with_proof_of_work
  end

  def compute_hash_with_proof_of_work(difficulty="00")
    nonce = 0
    loop do
      hash = calc_hash_with_nonce(nonce)
      if hash.start_with?(difficulty)
        return[nonce, hash]
      else
        nonce += 1
      end
    end
  end

  def calc_hash_with_nonce(nonce = 0)
    sha = Digest::SHA256.new
    sha.update(nonce.to_s + @index.to_s + @data.to_s + @timestamp.to_s)
    sha.hexdigest
  end

  def self.first(data = "Genesis")
    Block.new(0, data, "0")
  end

  def self.next(previous, data="Transaction or something")
    Block.new(previous.index + 1, data, previous.hash)
  end
end


b0 = Block.first("It's first block")
b1 = Block.next(b0, "It's second block")
b2 = Block.next(b1, "It's third block")
b3 = Block.next(b2, "It's fourth block")
b4 = Block.next(b3, "It's fifth block")

blockchain = [b0, b1, b2, b3, b4]
pp blockchain