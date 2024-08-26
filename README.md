# AeroDump
Our multi-sender platform goes beyond simple bulk transfers by offering support for multiple networks, secure and trusted token distribution, and automated multi-send functions. Project owners can rely on tools such as Chainlink, KYC, and AI-driven automation to manage token distribution with greater trust and transparency.

# Process
![image](https://github.com/user-attachments/assets/e42cce5a-4601-4c80-af1d-5902c02936e8)

## Key Features of this Flow:
- **Hands-Free Automation with Multi-Network Support:** Chainlink Automation allows for `automatic triggering` of the token distribution from the LayerZero vault, while `Chainlink CCIP` ensures that tokens can be distributed across `multiple networks`. This enables cross-chain token distribution without the need for constant developer or operator intervention.
- **Cross-Chain Flexibility:** With Chainlink CCIP, users or project owners can distribute tokens across various networks like `Ethereum, Solana, Avalanche`, and others. The tokens are `bridged seamlessly` to the chosen network during the distribution process.
- **CSV File Management:** The user uploads a CSV file containing recipient information (address, token amount, and network). This data is used by the automation to ensure accurate and efficient distribution across networks.
- **LayerZero Vault for Secure Holding:** The vault securely holds the tokens until the automation system triggers distribution. Tokens are only released when the conditions are met, ensuring safety and transparency.
- **Scalability and Efficiency:** By leveraging both `Chainlink Automation` and `CCIP`, the system scales to handle bulk token transfers across various blockchains without the need for manual monitoring or intervention.

<details>
<summary>
  Foundry
</summary>
<div markdown="1">

  **Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
</div>
</details>


