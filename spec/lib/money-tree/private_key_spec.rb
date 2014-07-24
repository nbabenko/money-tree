require 'spec_helper'

describe MoneyTree::PrivateKey do
  before do
    @key = MoneyTree::PrivateKey.new key: "5eae5375fb5f7a0ea650566363befa2830ef441bdcb19198adf318faee86d64b"
  end
  
  describe "to_hex" do
    it "has 64 characters" do
      # must always be 64 characters - leading zeroes need to be preserved!
      @key.to_hex.length.should == 64
    end

    it "preserves leading zeros" do
      master = MoneyTree::Master.new seed_hex: "9cf6b6e8451c7d551cb402e2997566e5c7c258543eadb184f9f39322b2e6959b"
      master.node_for_path("m/427").private_key.to_hex.length.should == 64
    end
    
    it "is a valid hex" do
      @key.to_hex.should == '5eae5375fb5f7a0ea650566363befa2830ef441bdcb19198adf318faee86d64b'      
    end
  end
  
  describe "to_wif" do
    it "is a 52 character base58 key" do
      @key.to_wif.length.should == 52
    end
    
    it "starts with K or L" do
      %w(K L).should include(@key.to_wif[0])
    end
    
    it "is a valid compressed wif" do
      @key.to_wif.should == 'KzPkwAXJ4wtXHnbamTaJqoMrzwCUUJaqhUxnqYhnZvZH6KhgmDPK'      
    end
  end
  
  describe "to_wif(compressed: false)" do
    it "is a 51 character base58 key" do
      @key.to_wif(compressed: false).length.should == 51
    end
    
    it "starts with 5" do
      @key.to_wif(compressed: false)[0].should == '5'
    end
    
    it "is valid" do
      @key.to_wif(compressed: false).should == '5JXz5ZyFk31oHVTQxqce7yitCmTAPxBqeGQ4b7H3Aj3L45wUhoa'      
    end
  end
  
  describe "from_wif(wif)" do
    it "returns the key from a wif" do
      @key.from_wif("5HueCGU8rMjxEXxiPuD5BDku4MkFqeZyd4dZ1jvhTVqvbTLvyTJ").should == '0c28fca386c7a227600b2fe50b7cae11ec86d3bf1fbe471be89827e19d72aa1d'
    end
    
    it "raises an error on bad checksum" do
      lambda { @key.from_wif("5HueCGU8rMjxEXxiPuD5BDku4MkFqeZyd4dZ1jvhTVqvbTBADTJ") }.should raise_error(MoneyTree::Key::InvalidWIFFormat)
    end
  end
  
  describe "to_base64" do
    it "has 44 characters" do
      @key.to_base64.length.should == 44
    end
  
    it "is a valid base64" do
      @key.to_base64.should == 'Xq5Tdftfeg6mUFZjY776KDDvRBvcsZGYrfMY+u6G1ks='      
    end
  end
  
  describe "from_base64(base64_key)" do
    it "parses base64 key" do
      @key = MoneyTree::PrivateKey.new(key: "Xq5Tdftfeg6mUFZjY776KDDvRBvcsZGYrfMY+u6G1ks=")
      @key.to_hex.should == "5eae5375fb5f7a0ea650566363befa2830ef441bdcb19198adf318faee86d64b"
    end
    
    it "returns the key from base64 encoding" do
      @key.from_base64("Xq5Tdftfeg6mUFZjY776KDDvRBvcsZGYrfMY+u6G1ks=").should == '5eae5375fb5f7a0ea650566363befa2830ef441bdcb19198adf318faee86d64b'
    end
    
    it "raises an error on bad encoding" do
      lambda { @key.from_base64("Xq5Tdftfeg6mUFZjY776KD&%#BbadBADrfMY+u6G1ks=") }.should raise_error(MoneyTree::Key::InvalidBase64Format)
    end
  end
  
  describe "valid?(eckey)" do
    it "checks for a valid key" do
      @key.valid?.should == true
    end
  end
  
  describe "parse_raw_key" do
    it "returns error if key is not Bignum, hex, base64, or wif formatted" do
      lambda { @key = MoneyTree::PrivateKey.new(key: "Thisisnotakey") }.should raise_error(MoneyTree::Key::KeyFormatNotFound)
      
    end
  end

  context "testnet" do
    before do
      @key = MoneyTree::PrivateKey.new key: 'cRhes8SBnsF6WizphaRKQKZZfDniDa9Bxcw31yKeEC1KDExhxFgD'
    end

    describe "to_wif" do
      it "returns same wif" do
        @key.to_wif.should == 'cRhes8SBnsF6WizphaRKQKZZfDniDa9Bxcw31yKeEC1KDExhxFgD'
      end
    end
  end
  context "dogecoin" do
    before do
      @key = MoneyTree::PrivateKey.new key: 'QVBqSDTSLjKdjsWY5wjwqBYuVmkYYnNwgmifAVig74CkPfQtAFht'
    end

    describe "to_wif" do
      it "returns same wif" do
        @key.to_wif.should == 'QVBqSDTSLjKdjsWY5wjwqBYuVmkYYnNwgmifAVig74CkPfQtAFht'
      end
    end
  end
  context "dogecoin testnet" do
    before do
      @key = MoneyTree::PrivateKey.new key: 'ciD9iG4hCoyoKDPdry2cuStQuJXSHAQ5iyo3e4CkAsv4e8VE4WE6'
    end

    describe "to_wif" do
      it "returns same wif" do
        @key.to_wif.should == 'ciD9iG4hCoyoKDPdry2cuStQuJXSHAQ5iyo3e4CkAsv4e8VE4WE6'
      end
    end
  end
end
