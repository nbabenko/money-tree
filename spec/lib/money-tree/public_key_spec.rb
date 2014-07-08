require 'spec_helper'

describe MoneyTree::PublicKey do
  
  describe "with a private key" do
    before do
      @private_key = MoneyTree::PrivateKey.new key: "5eae5375fb5f7a0ea650566363befa2830ef441bdcb19198adf318faee86d64b"
      @key = MoneyTree::PublicKey.new @private_key
    end
  
    describe "to_hex(compressed: false)" do
      it "has 65 bytes" do
        @key.uncompressed.to_hex.length.should == 130
      end
    
      it "is a valid hex" do
        @key.uncompressed.to_hex.should == '042dfc2557a007c93092c2915f11e8aa70c4f399a6753e2e908330014091580e4b11203096f1a1c5276a73f91b9465357004c2103cc42c63d6d330df589080d2e4'      
      end
    end
  
    describe "to_hex" do
      it "has 33 bytes" do
        @key.to_hex.length.should == 66
      end
  
      it "is a valid compressed hex" do
        @key.to_hex.should == '022dfc2557a007c93092c2915f11e8aa70c4f399a6753e2e908330014091580e4b'      
      end
    end
  
    describe "to_fingerprint" do
      it "returns a valid fingerprint" do
        @key.to_fingerprint.should == "1fddf42e"
      end
    end
  
    describe "to_address(compressed: false)" do
      it "has 34 characters" do
        @key.uncompressed.to_address.length.should == 34
      end
    
      it "is a valid bitcoin address" do
        @key.uncompressed.to_address.should == '133bJA2xoVqBUsiR3uSkciMo5r15fLAaZg'      
      end
    end
  
    describe "to_compressed_address" do
      it "has 34 characters" do
        @key.to_address.length.should == 34
      end
    
      it "is a valid compressed bitcoin address" do
        @key.to_address.should == '13uVqa35BMo4mYq9LiZrXVzoz9EFZ6aoXe'      
      end
    end
  end
  
  describe "without a private key" do
    before do
      @key = MoneyTree::PublicKey.new '042dfc2557a007c93092c2915f11e8aa70c4f399a6753e2e908330014091580e4b11203096f1a1c5276a73f91b9465357004c2103cc42c63d6d330df589080d2e4'
    end
    
    describe "to_hex(compressed: false)" do
      it "has 65 bytes" do
        @key.uncompressed.to_hex.length.should == 130
      end
    
      it "is a valid hex" do
        @key.uncompressed.to_hex.should == '042dfc2557a007c93092c2915f11e8aa70c4f399a6753e2e908330014091580e4b11203096f1a1c5276a73f91b9465357004c2103cc42c63d6d330df589080d2e4'      
      end
    end
  
    describe "to_hex" do
      it "has 33 bytes" do
        @key.compressed.to_hex.length.should == 66
      end
  
      it "is a valid compressed hex" do
        @key.compressed.to_hex.should == '022dfc2557a007c93092c2915f11e8aa70c4f399a6753e2e908330014091580e4b'      
      end
    end
  
    describe "to_fingerprint" do
      it "returns a valid fingerprint" do
        @key.compressed.to_fingerprint.should == "1fddf42e"
      end
    end
  
    describe "to_address(compressed: false)" do
      it "has 34 characters" do
        @key.uncompressed.to_address.length.should == 34
      end
    
      it "is a valid bitcoin address" do
        @key.uncompressed.to_address.should == '133bJA2xoVqBUsiR3uSkciMo5r15fLAaZg'      
      end
    end
  
    describe "to_compressed_address" do
      it "has 34 characters" do
        @key.compressed.to_address.length.should == 34
      end
    
      it "is a valid compressed bitcoin address" do
        @key.compressed.to_address.should == '13uVqa35BMo4mYq9LiZrXVzoz9EFZ6aoXe'      
      end
    end
    
    describe "#compression" do
      it "returns current compression setting" do
        @key.compression = :uncompressed
        @key.compression.should == :uncompressed
        @key.compression = :compressed
        @key.compression.should == :compressed
      end
    end
  end
  
  describe "with a bad key" do
    it "raises KeyFormatNotFound" do
      lambda { @key = MoneyTree::PublicKey.new 'THISISNOTAVALIDKEY' }.should raise_error(MoneyTree::Key::KeyFormatNotFound)
    end
  end

  describe "recalcuating public key" do
    it "produces same results" do
      results = []
      100.times do 
        results << MoneyTree::PublicKey.new('042dfc2557a007c93092c2915f11e8aa70c4f399a6753e2e908330014091580e4b11203096f1a1c5276a73f91b9465357004c2103cc42c63d6d330df589080d2e4').to_s
      end
      results.uniq.length.should == 1
    end
  end

  describe "#uncompressed" do
    before do
      @key = MoneyTree::PublicKey.new('022dfc2557a007c93092c2915f11e8aa70c4f399a6753e2e908330014091580e4b')
    end

    it "does not mutate key" do
      before_str = @key.to_s
      @key.uncompressed
      after_str = @key.to_s
      before_str.should == after_str
    end
  end

  describe "#compressed" do
    before do
      @key = MoneyTree::PublicKey.new('042dfc2557a007c93092c2915f11e8aa70c4f399a6753e2e908330014091580e4b11203096f1a1c5276a73f91b9465357004c2103cc42c63d6d330df589080d2e4')
    end

    it "does not mutate key" do
      before_str = @key.to_s
      @key.compressed
      after_str = @key.to_s
      before_str.should == after_str
    end
  end

  context "testnet" do
    context 'with private key' do
      before do
        @private_key = MoneyTree::PrivateKey.new network: :bitcoin_testnet
        @key = MoneyTree::PublicKey.new(@private_key)
      end

      it "should have an address starting with m or n" do
        %w(m n).should include(@key.to_s[0])
      end
    end

    context 'without private key' do
      before do
        @key = MoneyTree::PublicKey.new('0297b033ba894611345a0e777861237ef1632370fbd58ebe644eb9f3714e8fe2bc', network: :bitcoin_testnet)
      end

      it "should have an address starting with m or n" do
        %w(m n).should include(@key.to_s[0])
      end
    end
  end

  context "dogecoin" do
    context 'with private key' do
      before do
        @private_key = MoneyTree::PrivateKey.new network: :dogecoin
        @key = MoneyTree::PublicKey.new(@private_key)
      end

      it "should have an address starting with D" do
        %w(D).should include(@key.to_s[0])
      end
    end

    context 'without private key' do
      before do
        @key = MoneyTree::PublicKey.new('02fcba7ecf41bc7e1be4ee122d9d22e3333671eb0a3a87b5cdf099d59874e1940f', network: :dogecoin)
      end

      it "should have an address starting with D" do
        %w(D).should include(@key.to_s[0])
      end
    end
  end

  context "dogecoin testnet" do
    context 'with private key' do
      before do
        @private_key = MoneyTree::PrivateKey.new network: :dogecoin_testnet
        @key = MoneyTree::PublicKey.new(@private_key)
      end

      it "should have an address starting with n" do
        %w(n).should include(@key.to_s[0])
      end
    end

    context 'without private key' do
      before do
        @key = MoneyTree::PublicKey.new('02fcba7ecf41bc7e1be4ee122d9d22e3333671eb0a3a87b5cdf099d59874e1940f', network: :dogecoin_testnet)
      end

      it "should have an address starting with n" do
        %w(n).should include(@key.to_s[0])
      end
    end
  end

end
