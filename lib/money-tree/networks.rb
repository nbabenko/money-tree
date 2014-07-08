module MoneyTree
  NETWORKS = {
    bitcoin: {
      address_version: '00',
      p2sh_version: '05',
      p2sh_char: '3',
      privkey_version: '80',
      privkey_compression_flag: '01',
      extended_privkey_version: "0488ade4",
      extended_pubkey_version: "0488b21e",
      compressed_wif_chars: %w(K L),
      uncompressed_wif_chars: %w(5),
      protocol_version: 70001
    },
    bitcoin_testnet: {
      address_version: '6f',
      p2sh_version: 'c4',
      p2sh_char: '2',
      privkey_version: 'ef',
      privkey_compression_flag: '01',
      extended_privkey_version: "04358394",
      extended_pubkey_version: "043587cf",
      compressed_wif_chars: %w(c),
      uncompressed_wif_chars: %w(9),
      protocol_version: 70001
    },
    dogecoin: {
      address_version: '1e',
      p2sh_version: '16',
      p2sh_char: 'A',
      privkey_compression_flag: '01',
      privkey_version: '9e',
      extended_privkey_version: "02fac398",
      extended_pubkey_version: "02facafd",
      compressed_wif_chars: %w(Q),
      uncompressed_wif_chars: %w(6),
      protocol_version: 70002
    },
    dogecoin_testnet: {
      address_version: '71',
      p2sh_version: 'c4',
      p2sh_char: '2',
      privkey_compression_flag: '01',
      privkey_version: 'f1',
      extended_privkey_version: "0432a243",
      extended_pubkey_version: "0432a9a8",
      compressed_wif_chars: %w(c),
      uncompressed_wif_chars: %w(9),
      protocol_version: 70002
    }
  }


end
