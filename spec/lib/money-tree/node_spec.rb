require 'spec_helper'

describe MoneyTree::Master do
  describe "initialize" do
    describe "without a seed" do
      before do
        @master = MoneyTree::Master.new
      end

      it "generates a random seed 32 bytes long" do
        @master.seed.bytesize.should == 32
      end
    end

    context "testnet" do
      before do
        @master = MoneyTree::Master.new network: :bitcoin_testnet
      end

      it "generates testnet address" do
        %w(m n).should include(@master.to_address[0])
      end

      it "generates testnet compressed wif" do
        @master.private_key.to_wif[0].should == 'c'
      end

      it "generates testnet uncompressed wif" do
        @master.private_key.to_wif(compressed: false)[0].should == '9'
      end

      it "generates testnet serialized private address" do
        @master.to_serialized_address(:private).slice(0, 4).should == "tprv"
      end

      it "generates testnet serialized public address" do
        @master.to_serialized_address.slice(0, 4).should == "tpub"
      end

      it "imports from testnet serialized private address" do
        node = MoneyTree::Node.from_serialized_address 'tprv8ZgxMBicQKsPcuN7bfUZqq78UEYapr3Tzmc9NcDXw8BnBJ47dZYr6SusnfYj7vbAYP9CP8ZiD5aVBTUo1yU5QP56mepKVvuEbu8KZQXMKNE'
        node.to_serialized_address(:private).should == 'tprv8ZgxMBicQKsPcuN7bfUZqq78UEYapr3Tzmc9NcDXw8BnBJ47dZYr6SusnfYj7vbAYP9CP8ZiD5aVBTUo1yU5QP56mepKVvuEbu8KZQXMKNE'
      end

      it "imports from testnet serialized public address" do
        node = MoneyTree::Node.from_serialized_address 'tpubD6NzVbkrYhZ4YA8aUE9bBZTSyHJibBqwDny5urfwDdJc4W8od3y3Ebzy6CqsYn9CCC5P5VQ7CeZYpnT1kX3RPVPysU2rFRvYSj8BCoYYNqT'
        %w(m n).should include(node.public_key.to_s[0])
        node.to_serialized_address.should == 'tpubD6NzVbkrYhZ4YA8aUE9bBZTSyHJibBqwDny5urfwDdJc4W8od3y3Ebzy6CqsYn9CCC5P5VQ7CeZYpnT1kX3RPVPysU2rFRvYSj8BCoYYNqT'
      end

      it "generates testnet subnodes from serialized private address" do
        node = MoneyTree::Node.from_serialized_address 'tprv8ZgxMBicQKsPcuN7bfUZqq78UEYapr3Tzmc9NcDXw8BnBJ47dZYr6SusnfYj7vbAYP9CP8ZiD5aVBTUo1yU5QP56mepKVvuEbu8KZQXMKNE'
        subnode = node.node_for_path('1/1/1')
        %w(m n).should include(subnode.public_key.to_s[0])
        subnode.to_serialized_address(:private).slice(0,4).should == 'tprv'
        subnode.to_serialized_address.slice(0,4).should == 'tpub'
      end

      it "generates testnet subnodes from serialized public address" do
        node = MoneyTree::Node.from_serialized_address 'tpubD6NzVbkrYhZ4YA8aUE9bBZTSyHJibBqwDny5urfwDdJc4W8od3y3Ebzy6CqsYn9CCC5P5VQ7CeZYpnT1kX3RPVPysU2rFRvYSj8BCoYYNqT'
        subnode = node.node_for_path('1/1/1')
        %w(m n).should include(subnode.public_key.to_s[0])
        subnode.to_serialized_address.slice(0,4).should == 'tpub'
      end
    end
    context "dogecoin" do
      before do
        @master = MoneyTree::Master.new network: :dogecoin
      end

      it "generates dogecoin address" do
        %w(D).should include(@master.to_address[0])
      end

      it "generates dogecoin compressed wif" do
        @master.private_key.to_wif[0].should == 'Q'
      end

      it "generates dogecoin uncompressed wif" do
        @master.private_key.to_wif(compressed: false)[0].should == '6'
      end

      it "generates dogecoin serialized private address" do
        @master.to_serialized_address(:private).slice(0, 4).should == "dgpv"
      end

      it "generates dogecoin serialized public address" do
        @master.to_serialized_address.slice(0, 4).should == "dgub"
      end

      it "imports from dogecoin serialized private address" do
        node = MoneyTree::Node.from_serialized_address 'dgpv51eADS3spNJh8AXonfPpXG1moNUxDs5JbehhastdAENe5SfuDQjorcUUtc3WdHrb8caZzUn1g2naE8TfGVzE6zTnyxeghV9qKHvEdPxaiNn'
        node.to_serialized_address(:private).should == 'dgpv51eADS3spNJh8AXonfPpXG1moNUxDs5JbehhastdAENe5SfuDQjorcUUtc3WdHrb8caZzUn1g2naE8TfGVzE6zTnyxeghV9qKHvEdPxaiNn'
      end

      it "imports from dogecoin serialized public address" do
        node = MoneyTree::Node.from_serialized_address 'dgub8kXBZ7ymNWy2R2Bxpu1ne7ZNFvrb3z71tFUujzHbxMRedVnbdBHaVut8TpkGgkk2ckZmxYd1EnGrrzc89kjoDVJpMYYWG3KL6ZW5ReWUUPa'
        %w(D).should include(node.public_key.to_s[0])
        node.to_serialized_address.should == 'dgub8kXBZ7ymNWy2R2Bxpu1ne7ZNFvrb3z71tFUujzHbxMRedVnbdBHaVut8TpkGgkk2ckZmxYd1EnGrrzc89kjoDVJpMYYWG3KL6ZW5ReWUUPa'
      end

      it "generates dogecoin subnodes from serialized private address" do
        node = MoneyTree::Node.from_serialized_address 'dgpv51eADS3spNJh8AXonfPpXG1moNUxDs5JbehhastdAENe5SfuDQjorcUUtc3WdHrb8caZzUn1g2naE8TfGVzE6zTnyxeghV9qKHvEdPxaiNn'
        subnode = node.node_for_path('1/1/1')
        %w(D).should include(subnode.public_key.to_s[0])
        subnode.to_serialized_address(:private).slice(0,4).should == 'dgpv'
        subnode.to_serialized_address.slice(0,4).should == 'dgub'
      end

      it "generates dogecoin subnodes from serialized public address" do
        node = MoneyTree::Node.from_serialized_address 'dgub8kXBZ7ymNWy2R2Bxpu1ne7ZNFvrb3z71tFUujzHbxMRedVnbdBHaVut8TpkGgkk2ckZmxYd1EnGrrzc89kjoDVJpMYYWG3KL6ZW5ReWUUPa'
        subnode = node.node_for_path('1/1/1')
        %w(D).should include(subnode.public_key.to_s[0])
        subnode.to_serialized_address.slice(0,4).should == 'dgub'
      end
    end
    context "dogecoin testnet" do
      before do
        @master = MoneyTree::Master.new network: :dogecoin_testnet
      end

      it "generates dogecoin testnet address" do
        %w(n).should include(@master.to_address[0])
      end

      it "generates dogecoin testnet compressed wif" do
        @master.private_key.to_wif[0].should == 'c'
      end

      it "generates dogecoin testnet uncompressed wif" do
        @master.private_key.to_wif(compressed: false)[0].should == '9'
      end

      it "generates dogecoin testnet serialized private address" do
        @master.to_serialized_address(:private).slice(0, 4).should == "tgpv"
      end

      it "generates dogecoin testnet serialized public address" do
        @master.to_serialized_address.slice(0, 4).should == "tgub"
      end

      it "imports from dogecoin testnet serialized private address" do
        node = MoneyTree::Node.from_serialized_address 'tgpv1aRS3XcGkbKXCdTFWR4bcJiwMtzDbJUj8FqpqfgDzPmRvFxhvRhuYs3AsqWB5n6UpkLXd8pJCCraG6iFnJh8z9X7U6a3SyVxiK1v9ibRKPJ'
        node.to_serialized_address(:private).should == 'tgpv1aRS3XcGkbKXCdTFWR4bcJiwMtzDbJUj8FqpqfgDzPmRvFxhvRhuYs3AsqWB5n6UpkLXd8pJCCraG6iFnJh8z9X7U6a3SyVxiK1v9ibRKPJ'
      end

      it "imports from dogecoin testnet serialized public address" do
        node = MoneyTree::Node.from_serialized_address 'tgub5KJTPDYAJjyrVV7QYegZjAGXpTMrRRWSQrd2zn5CnWpSUK5QLCFgCASpT4Cw9EyvJtKjbCfHkxLrtxrifZSi6eN8qgTs1XfTVabkx37JCZR'
        %w(n).should include(node.public_key.to_s[0])
        node.to_serialized_address.should == 'tgub5KJTPDYAJjyrVV7QYegZjAGXpTMrRRWSQrd2zn5CnWpSUK5QLCFgCASpT4Cw9EyvJtKjbCfHkxLrtxrifZSi6eN8qgTs1XfTVabkx37JCZR'
      end

      it "generates dogecoin testnet subnodes from serialized private address" do
        node = MoneyTree::Node.from_serialized_address 'tgpv1aRS3XcGkbKXCdTFWR4bcJiwMtzDbJUj8FqpqfgDzPmRvFxhvRhuYs3AsqWB5n6UpkLXd8pJCCraG6iFnJh8z9X7U6a3SyVxiK1v9ibRKPJ'
        subnode = node.node_for_path('1/1/1')
        %w(n).should include(subnode.public_key.to_s[0])
        subnode.to_serialized_address(:private).slice(0,4).should == 'tgpv'
        subnode.to_serialized_address.slice(0,4).should == 'tgub'
      end

      it "generates dogecoin testnet subnodes from serialized public address" do
        node = MoneyTree::Node.from_serialized_address 'tgub5KJTPDYAJjyrVV7QYegZjAGXpTMrRRWSQrd2zn5CnWpSUK5QLCFgCASpT4Cw9EyvJtKjbCfHkxLrtxrifZSi6eN8qgTs1XfTVabkx37JCZR'
        subnode = node.node_for_path('1/1/1')
        %w(n).should include(subnode.public_key.to_s[0])
        subnode.to_serialized_address.slice(0,4).should == 'tgub'
      end
    end

    TEST_VECTORS.each do |network, v|
      context network do

        describe "Test vector 1" do
          describe "from a seed" do
            before do
              @master = MoneyTree::Master.new seed_hex: v[:vector1_master], network: network
            end

            describe "m" do
              it "has an index of 0" do
                @master.index.should == 0
              end

              it "is private" do
                @master.is_private?.should == true
              end

              it "has a depth of 0" do
                @master.depth.should == 0
              end

              it "generates master node (Master)" do
                @master.to_identifier.should == v[:vector1_m_hex]
                @master.to_fingerprint.should == v[:vector1_m_fingerprint]
                @master.to_address.should == v[:vector1_m_address]
              end

              it "generates a secret key" do
                @master.private_key.to_hex.should == v[:vector1_m_secret_hex]
                @master.private_key.to_wif.should == v[:vector1_m_secret_wif]
              end

              it "generates a public key" do
                @master.public_key.to_hex.should == v[:vector1_m_public_key]
              end

              it "generates a chain code" do
                @master.chain_code_hex.should == v[:vector1_m_chain_code]
              end

              it "generates a serialized private key" do
                @master.to_serialized_hex(:private).should == v[:vector1_m_private_hex]
                @master.to_serialized_address(:private).should == v[:vector1_m_private]
              end

              it "generates a serialized public_key" do
                @master.to_serialized_hex.should == v[:vector1_m_public_hex]
                @master.to_serialized_address.should == v[:vector1_m_public]
              end
            end

            describe "m/0p" do
              before do
                @node = @master.node_for_path "m/0p"
              end

              it "has an index of 2147483648" do
                @node.index.should == 2147483648
              end

              it "is private" do
                @node.is_private?.should == true
              end

              it "has a depth of 1" do
                @node.depth.should == 1
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector1_m0h_hex]
                @node.to_fingerprint.should == v[:vector1_m0h_fingerprint]
                @node.to_address.should == v[:vector1_m0h_address]
              end

              it "generates a private key" do
                @node.private_key.to_hex.should == v[:vector1_m0h_secret_hex]
                @node.private_key.to_wif.should == v[:vector1_m0h_secret_wif]
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector1_m0h_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector1_m0h_chain_code]
              end

              it "generates a serialized private key" do
                @node.to_serialized_hex(:private).should == v[:vector1_m0h_private_hex]
                @node.to_serialized_address(:private).should == v[:vector1_m0h_private]
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector1_m0h_public_hex]
                @node.to_serialized_address.should == v[:vector1_m0h_public]
              end
            end

            describe "m/0p.pub" do
              before do
                @node = @master.node_for_path "m/0p.pub"
              end

              it "has an index of 2147483648" do
                @node.index.should == 2147483648
              end

              it "is private" do
                @node.is_private?.should == true
              end

              it "has a depth of 1" do
                @node.depth.should == 1
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector1_m0h_hex]
                @node.to_fingerprint.should == v[:vector1_m0h_fingerprint]
                @node.to_address.should == v[:vector1_m0h_address]
              end

              it "does not generate a private key" do
                @node.private_key.should be_nil
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector1_m0h_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector1_m0h_chain_code]
              end

              it "does not generate a serialized private key" do
                lambda { @node.to_serialized_hex(:private) }.should raise_error(MoneyTree::Node::PrivatePublicMismatch)
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector1_m0h_public_hex]
                @node.to_serialized_address.should == v[:vector1_m0h_public]
              end
            end

            describe "m/0'/1" do
              before do
                @node = @master.node_for_path "m/0'/1"
              end

              it "has an index of 1" do
                @node.index.should == 1
              end

              it "is public" do
                @node.is_private?.should == false
              end

              it "has a depth of 2" do
                @node.depth.should == 2
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector1_m0h1_hex]
                @node.to_fingerprint.should == v[:vector1_m0h1_fingerprint]
                @node.to_address.should == v[:vector1_m0h1_address]
              end

              it "generates a private key" do
                @node.private_key.to_hex.should == v[:vector1_m0h1_secret_hex]
                @node.private_key.to_wif.should == v[:vector1_m0h1_secret_wif]
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector1_m0h1_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector1_m0h1_chain_code]
              end

              it "generates a serialized private key" do
                @node.to_serialized_hex(:private).should == v[:vector1_m0h1_private_hex]
                @node.to_serialized_address(:private).should == v[:vector1_m0h1_private]
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector1_m0h1_public_hex]
                @node.to_serialized_address.should == v[:vector1_m0h1_public]
              end
            end

            describe "M/0'/1" do
              before do
                @node = @master.node_for_path "M/0'/1"
              end

              it "has an index of 1" do
                @node.index.should == 1
              end

              it "is public" do
                @node.is_private?.should == false
              end

              it "has a depth of 2" do
                @node.depth.should == 2
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector1_m0h1_hex]
                @node.to_fingerprint.should == v[:vector1_m0h1_fingerprint]
                @node.to_address.should == v[:vector1_m0h1_address]
              end

              it "does not generate a private key" do
                @node.private_key.should be_nil
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector1_m0h1_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector1_m0h1_chain_code]
              end

              it "generates a serialized private key" do
                lambda { @node.to_serialized_hex(:private) }.should raise_error(MoneyTree::Node::PrivatePublicMismatch)
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector1_m0h1_public_hex]
                @node.to_serialized_address.should == v[:vector1_m0h1_public]
              end
            end

            describe "m/0'/1/2p/2" do
              before do
                @node = @master.node_for_path "m/0'/1/2p/2"
              end

              it "has an index of 2" do
                @node.index.should == 2
              end

              it "is public" do
                @node.is_private?.should == false
              end

              it "has a depth of 4" do
                @node.depth.should == 4
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector1_m0h12h2_hex]
                @node.to_fingerprint.should == v[:vector1_m0h12h2_fingerprint]
                @node.to_address.should == v[:vector1_m0h12h2_address]
              end

              it "generates a private key" do
                @node.private_key.to_hex.should == v[:vector1_m0h12h2_secret_hex]
                @node.private_key.to_wif.should == v[:vector1_m0h12h2_secret_wif]
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector1_m0h12h2_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector1_m0h12h2_chain_code]
              end

              it "generates a serialized private key" do
                @node.to_serialized_hex(:private).should == v[:vector1_m0h12h2_private_hex]
                @node.to_serialized_address(:private).should == v[:vector1_m0h12h2_private]
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector1_m0h12h2_public_hex]
                @node.to_serialized_address.should == v[:vector1_m0h12h2_public]
              end
            end

            describe "m/0'/1/2'/2/1000000000" do
              before do
                @node = @master.node_for_path "m/0'/1/2'/2/1000000000"
              end

              it "has an index of 1000000000" do
                @node.index.should == 1000000000
              end

              it "is public" do
                @node.is_private?.should == false
              end

              it "has a depth of 2" do
                @node.depth.should == 5
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector1_m0h12h21000000000_hex]
                @node.to_fingerprint.should == v[:vector1_m0h12h21000000000_fingerprint]
                @node.to_address.should == v[:vector1_m0h12h21000000000_address]
              end

              it "generates a private key" do
                @node.private_key.to_hex.should == v[:vector1_m0h12h21000000000_secret_hex]
                @node.private_key.to_wif.should == v[:vector1_m0h12h21000000000_secret_wif]
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector1_m0h12h21000000000_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector1_m0h12h21000000000_chain_code]
              end

              it "generates a serialized private key" do
                @node.to_serialized_hex(:private).should == v[:vector1_m0h12h21000000000_private_hex]
                @node.to_serialized_address(:private).should == v[:vector1_m0h12h21000000000_private]
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector1_m0h12h21000000000_public_hex]
                @node.to_serialized_address.should == v[:vector1_m0h12h21000000000_public]
              end
            end
          end
        end

        describe "Test vector 2" do
          describe "from a seed" do
            before do
              @master = MoneyTree::Master.new seed_hex: v[:vector2_master], network: network
            end

            describe "m" do
              it "has an index of 0" do
                @master.index.should == 0
              end

              it "has a depth of 0" do
                @master.depth.should == 0
              end

              it "is private" do
                @master.is_private?.should == true
              end

              it "generates master node (Master)" do
                @master.to_identifier.should == v[:vector2_m_hex]
                @master.to_fingerprint.should == v[:vector2_m_fingerprint]
                @master.to_address.should == v[:vector2_m_address]
              end

              it "generates a secret key" do
                @master.private_key.to_hex.should == v[:vector2_m_secret_hex]
                @master.private_key.to_wif.should == v[:vector2_m_secret_wif]
              end

              it "generates a public key" do
                @master.public_key.to_hex.should == v[:vector2_m_public_key]
              end

              it "generates a chain code" do
                @master.chain_code_hex.should == v[:vector2_m_chain_code]
              end

              it "generates a serialized private key" do
                @master.to_serialized_hex(:private).should == v[:vector2_m_private_hex]
                @master.to_serialized_address(:private).should == v[:vector2_m_private]
              end

              it "generates a serialized public_key" do
                @master.to_serialized_hex.should == v[:vector2_m_public_hex]
                @master.to_serialized_address.should == v[:vector2_m_public]
              end
            end

            describe "m/0 (testing imported private key)" do
              before do
                @master = MoneyTree::Master.new private_key: @master.private_key, chain_code: @master.chain_code
                @node = @master.node_for_path "m/0"
              end

              it "has an index of 0" do
                @node.index.should == 0
              end

              it "has a depth of 1" do
                @node.depth.should == 1
              end

              it "is public" do
                @node.is_private?.should == false
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector2_m0_hex]
                @node.to_fingerprint.should == v[:vector2_m0_fingerprint]
                @node.to_address.should == v[:vector2_m0_address]
              end

              it "generates a private key" do
                @node.private_key.to_hex.should == v[:vector2_m0_secret_hex]
                @node.private_key.to_wif.should == v[:vector2_m0_secret_wif]
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector2_m0_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector2_m0_chain_code]
              end

              it "generates a serialized private key" do
                @node.to_serialized_hex(:private).should == v[:vector2_m0_private_hex]
                @node.to_serialized_address(:private).should == v[:vector2_m0_private]
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector2_m0_public_hex]
                @node.to_serialized_address.should == v[:vector2_m0_public]
              end
            end

            describe "M/0 (testing import of public key)" do
              before do
                @master = MoneyTree::Master.new public_key: v[:vector2_m_public_key], chain_code: @master.chain_code, network: network
                @node = @master.node_for_path "M/0"
              end

              it "has an index of 0" do
                @node.index.should == 0
              end

              it "has a depth of 1" do
                @node.depth.should == 1
              end

              it "is public" do
                @node.is_private?.should == false
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector2_m0_hex]
                @node.to_fingerprint.should == v[:vector2_m0_fingerprint]
                @node.to_address.should == v[:vector2_m0_address]
              end

              it "does not generate a private key" do
                @node.private_key.should be_nil
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector2_m0_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector2_m0_chain_code]
              end

              it "does not generate a serialized private key" do
                lambda { @node.to_serialized_hex(:private) }.should raise_error(MoneyTree::Node::PrivatePublicMismatch)
                lambda { @node.to_serialized_address(:private) }.should raise_error(MoneyTree::Node::PrivatePublicMismatch)
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector2_m0_public_hex]
                @node.to_serialized_address.should == v[:vector2_m0_public]
              end
            end

            describe "m/0/2147483647'" do
              before do
                @node = @master.node_for_path "m/0/2147483647'"
              end

              it "has an index of 2147483647" do
                @node.index.should == 4294967295
              end 
              it "has a depth of 2" do
                @node.depth.should == 2
              end

              it "is private" do
                @node.is_private?.should == true
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector2_m02147483647h_hex]
                @node.to_fingerprint.should == v[:vector2_m02147483647h_fingerprint]
                @node.to_address.should == v[:vector2_m02147483647h_address]
              end

              it "generates a private key" do
                @node.private_key.to_hex.should == v[:vector2_m02147483647h_secret_hex]
                @node.private_key.to_wif.should == v[:vector2_m02147483647h_secret_wif]
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector2_m02147483647h_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector2_m02147483647h_chain_code]
              end

              it "generates a serialized private key" do
                @node.to_serialized_hex(:private).should == v[:vector2_m02147483647h_private_hex]
                @node.to_serialized_address(:private).should == v[:vector2_m02147483647h_private]
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector2_m02147483647h_public_hex]
                @node.to_serialized_address.should == v[:vector2_m02147483647h_public]
              end
            end

            describe "m/0/2147483647'/1" do
              before do
                @node = @master.node_for_path "m/0/2147483647'/1"
              end

              it "has an index of 1" do
                @node.index.should == 1
              end

              it "has a depth of 3" do
                @node.depth.should == 3
              end

              it "is private" do
                @node.is_private?.should == false
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector2_m02147483647h1_hex]
                @node.to_fingerprint.should == v[:vector2_m02147483647h1_fingerprint]
                @node.to_address.should == v[:vector2_m02147483647h1_address]
              end

              it "generates a private key" do
                @node.private_key.to_hex.should == v[:vector2_m02147483647h1_secret_hex]
                @node.private_key.to_wif.should == v[:vector2_m02147483647h1_secret_wif]
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector2_m02147483647h1_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector2_m02147483647h1_chain_code]
              end

              it "generates a serialized private key" do
                @node.to_serialized_hex(:private).should == v[:vector2_m02147483647h1_private_hex]
                @node.to_serialized_address(:private).should == v[:vector2_m02147483647h1_private]
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector2_m02147483647h1_public_hex]
                @node.to_serialized_address.should == v[:vector2_m02147483647h1_public]
              end
            end

            describe "m/0/2147483647p/1/2147483646p" do
              before do
                @node = @master.node_for_path "m/0/2147483647p/1/2147483646p"
              end

              it "has an index of 4294967294" do
                @node.index.should == 4294967294
              end

              it "has a depth of 4" do
                @node.depth.should == 4
              end

              it "is private" do
                @node.is_private?.should == true
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector2_m02147483647h12147483646h_hex]
                @node.to_fingerprint.should == v[:vector2_m02147483647h12147483646h_fingerprint]
                @node.to_address.should == v[:vector2_m02147483647h12147483646h_address]
              end

              it "generates a private key" do
                @node.private_key.to_hex.should == v[:vector2_m02147483647h12147483646h_secret_hex]
                @node.private_key.to_wif.should == v[:vector2_m02147483647h12147483646h_secret_wif]
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector2_m02147483647h12147483646h_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector2_m02147483647h12147483646h_chain_code]
              end

              it "generates a serialized private key" do
                @node.to_serialized_hex(:private).should == v[:vector2_m02147483647h12147483646h_private_hex]
                @node.to_serialized_address(:private).should == v[:vector2_m02147483647h12147483646h_private]
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector2_m02147483647h12147483646h_public_hex]
                @node.to_serialized_address.should == v[:vector2_m02147483647h12147483646h_public]
              end
            end

            describe "m/0/2147483647p/1/2147483646p/2" do
              before do
                @node = @master.node_for_path "m/0/2147483647p/1/2147483646p/2"
              end

              it "has an index of 2" do
                @node.index.should == 2
              end

              it "has a depth of 4" do
                @node.depth.should == 5
              end

              it "is public" do
                @node.is_private?.should == false
              end

              it "generates subnode" do
                @node.to_identifier.should == v[:vector2_m02147483647h12147483646h2_hex]
                @node.to_fingerprint.should == v[:vector2_m02147483647h12147483646h2_fingerprint]
                @node.to_address.should == v[:vector2_m02147483647h12147483646h2_address]
              end

              it "generates a private key" do
                @node.private_key.to_hex.should == v[:vector2_m02147483647h12147483646h2_secret_hex]
                @node.private_key.to_wif.should == v[:vector2_m02147483647h12147483646h2_secret_wif]
              end

              it "generates a public key" do
                @node.public_key.to_hex.should == v[:vector2_m02147483647h12147483646h2_public_key]
              end

              it "generates a chain code" do
                @node.chain_code_hex.should == v[:vector2_m02147483647h12147483646h2_chain_code]
              end

              it "generates a serialized private key" do
                @node.to_serialized_hex(:private).should == v[:vector2_m02147483647h12147483646h2_private_hex]
                @node.to_serialized_address(:private).should == v[:vector2_m02147483647h12147483646h2_private]
              end

              it "generates a serialized public_key" do
                @node.to_serialized_hex.should == v[:vector2_m02147483647h12147483646h2_public_hex]
                @node.to_serialized_address.should == v[:vector2_m02147483647h12147483646h2_public]
              end
            end
          end
        end

      end
    end # per-network test vectors

    describe "negative index" do
      before do
        @master = MoneyTree::Master.new seed_hex: "000102030405060708090a0b0c0d0e0f"
        @node = @master.node_for_path "m/0'/-1"
      end

      it "has an index of 1" do
        @node.index.should == -1
      end

      it "is public" do
        @node.is_private?.should == true
      end

      it "has a depth of 2" do
        @node.depth.should == 2
      end

      it "generates a serialized private key" do
        @node.to_serialized_hex(:private).should == "0488ade4025c1bd648ffffffff0f9ca680ee23c81a305d96b86f811947e65590200b6f74d66ecf83936313a9c900235893db08ad0efc6ae4a1eac5b31a90a7d0906403d139d4d7f3c6796fb42c4e"
        @node.to_serialized_address(:private).should == "xprv9wTYmMFvAM7JHf3RuUidc24a4y2t4gN7aNP5ABreWAqt6BUBcf6xE8RNQxj2vUssYWM8iAZiZi5H1fmKkkpXjtwDCDv1pg8fSfQMk9rhHYt"
      end

      it "generates a serialized public_key" do
        @node.to_serialized_hex.should == "0488b21e025c1bd648ffffffff0f9ca680ee23c81a305d96b86f811947e65590200b6f74d66ecf83936313a9c902adb7979a5e99bf8acdfec3680bf482feac9898b28808c22d47db62e98de5d3fa"
        @node.to_serialized_address.should == "xpub6ASuArnozifbW97u1WFdyA1JczsNU95xwbJfxaGG4WNrxyoLACRCmvjrGEojsRsoZULf5FyZXv6AWAtce2UErsshvkpjNaT1fP6sMgTZdc1"
      end
    end

    describe "importing node" do
      describe ".from_serialized_address(address)" do
        it "imports a valid private node address" do
          @node = MoneyTree::Node.from_serialized_address "xprv9uHRZZhk6KAJC1avXpDAp4MDc3sQKNxDiPvvkX8Br5ngLNv1TxvUxt4cV1rGL5hj6KCesnDYUhd7oWgT11eZG7XnxHrnYeSvkzY7d2bhkJ7"
          @node.private_key.to_hex.should == "edb2e14f9ee77d26dd93b4ecede8d16ed408ce149b6cd80b0715a2d911a0afea"
          @node.index.should == 2147483648
          @node.is_private?.should == true
          @node.depth.should == 1
          @node.public_key.to_hex.should == "035a784662a4a20a65bf6aab9ae98a6c068a81c52e4b032c0fb5400c706cfccc56"
          @node.chain_code_hex.should == "47fdacbd0f1097043b78c63c20c34ef4ed9a111d980047ad16282c7ae6236141"
        end

        it "imports a valid public node address" do
          @node = MoneyTree::Node.from_serialized_address "xpub68Gmy5EdvgibQVfPdqkBBCHxA5htiqg55crXYuXoQRKfDBFA1WEjWgP6LHhwBZeNK1VTsfTFUHCdrfp1bgwQ9xv5ski8PX9rL2dZXvgGDnw"
          @node.private_key.should be_nil
          @node.index.should == 2147483648
          @node.is_private?.should == true
          @node.depth.should == 1
          @node.public_key.to_hex.should == "035a784662a4a20a65bf6aab9ae98a6c068a81c52e4b032c0fb5400c706cfccc56"
          @node.chain_code_hex.should == "47fdacbd0f1097043b78c63c20c34ef4ed9a111d980047ad16282c7ae6236141"
        end
      end
    end


  end
end
