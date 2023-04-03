# Genesis constantine-2 from constantine-2 hard fork

constantine-2 is a hard fork of constantine-1 at block height: 1200861

```bash
{
  "block_id": {
    "hash": "4D4806A5D506960492CE851000D21925D59AF69723B7588A91C3DEAFDBD214FA",
    "parts": {
      "total": 1,
      "hash": "C87A3412EC8EF1728799CC10735940D67976CFB318DE62FB6C24950B296F13B8"
    }
  },
  "block": {
    "header": {
      "version": {
        "block": "11"
      },
      "chain_id": "constantine-1",
      "height": "1200861",
      "time": "2023-04-03T10:07:17.733327673Z",
      "last_block_id": {
        "hash": "4D3A09AC08578E4161E74D70B406CA6D690191BEE50FFDF90E05A26B48DD1705",
        "parts": {
          "total": 1,
          "hash": "7C25DC88AF1E08D09CFA2DB5EDDA66473DC28165640712644AAB3E57A6B83FCE"
        }
      },
      "last_commit_hash": "2AA415C458BFBEEEA84E9A05B9E149EAA41319B914D6D9BC9A3CBA09E5CE72A7",
      "data_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
      "validators_hash": "8BFCB26137F117F67104CF83EDB43BB913C47144D759781312E3CB7AA050B0E3",
      "next_validators_hash": "8BFCB26137F117F67104CF83EDB43BB913C47144D759781312E3CB7AA050B0E3",
      "consensus_hash": "3AB4B0648EC46497FE810009B6AB29A5E18983B0A615BE174305F94968486602",
      "app_hash": "FC488AEDE59E9D05A1DE948BCA30971D236AC66872C77002A526C41E751DF099",
      "last_results_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
      "evidence_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
      "proposer_address": "227950C1373382B7B12B2A1A12FFD9FC2C4A60FD"
    },
    "data": {
      "txs": null
    },
    "evidence": {
      "evidence": null
    },
    "last_commit": {
      "height": "1200860",
      "round": 0,
      "block_id": {
        "hash": "4D3A09AC08578E4161E74D70B406CA6D690191BEE50FFDF90E05A26B48DD1705",
        "parts": {
          "total": 1,
          "hash": "7C25DC88AF1E08D09CFA2DB5EDDA66473DC28165640712644AAB3E57A6B83FCE"
        }
      },
      "signatures": [
        {
          "block_id_flag": 2,
          "validator_address": "227950C1373382B7B12B2A1A12FFD9FC2C4A60FD",
          "timestamp": "2023-04-03T10:07:17.733327673Z",
          "signature": "4im8SXzytgMLJdr1IhvS3uG5UdjI0svQ1aolKW3fpM5IGum5skymW9rduXyMYt3zcYsIWja9wBf3Q4di07oaAQ=="
        },
        {
          "block_id_flag": 3,
          "validator_address": "CFA65AE4EA6A81DC44F45C017E3F108CE1EF578E",
          "timestamp": "2023-04-03T10:07:17.980060015Z",
          "signature": "AeGSY/QFauI7kMY07nR3gYq4ht9Os8BWxxLv5vwr15BiF0inL4eB9bj02fU2azwmyAWOgWjwIZi0rA1N6EgVAA=="
        }
      ]
    }
  }
}
```

## Upgrade workflow

- Export constantine-1 state

```
archwayd  export --height 1200861 > constantine-1-export-1200861.json
```

