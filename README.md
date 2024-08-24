# AeroDump
Our multi-sender platform goes beyond simple bulk transfers by offering support for multiple networks, secure and trusted token distribution, and automated multi-send functions. Project managers can rely on tools such as Chainlink, KYC, and AI-driven automation to manage token distribution with greater trust and transparency.

# Process
![image](https://github.com/user-attachments/assets/96a7cf08-7d8f-4ffe-a4f0-ffb8bf13ded8)

# Our using the Tech

**Support for Multiple Networks (Chainlink CCIP)**
- Through Chainlink CCIP, we support token transfers across various networks such as EVM, SVM, and Move. This flexibility allows for seamless bulk transfers across multiple blockchains, rather than being limited to a single network.

**Sign Protocol for Trust and Security**
- When a project, rather than an individual user, sends large volumes of tokens for events or airdrops, Sign Protocol ensures that the project is official and trustworthy. By providing signatures and certifications, the project establishes transparency and guarantees safe token distribution.

**ERC-4626-Based Asset Vault Service**
- Using LayerZero's ERC-4626 standard, we offer a single asset vault service that allows projects to manage event or airdrop tokens efficiently. Projects can deposit tokens into the vault and distribute them in bulk as needed. This ensures stable rewards distribution to the community and enhances transparency in tokenomics.
 
**ENVIO**
- After completing a multi-sender transaction, ENVIO displays the transaction explorer on the history page, offering users a clear view of transaction records.

**XMTP**
- During a multi-send operation, XMTP continuously notifies registered wallet addresses of project marketing event newsletters. This ensures users receive important updates related to the project's activities.

**Tableland for Data Storage and Management**
- We use Tableland to store all wallet addresses and token quantities involved in multi-send transactions. When sending tokens in the future, previously used wallet addresses are flagged to prevent malicious behavior, such as administrators creating multiple wallets to exploit airdrops.

**Galadriel AI-Powered Automatic Multi-Sender**
- With Galadriel, project managers can pre-set deadlines, token quantities, and the number of user wallet addresses to receive the tokens. As the distribution date approaches, managers simply input the wallet addresses, and the AI automatically calculates the correct token amounts and sends them on the specified date. Essentially, this enables AI-driven automatic multi-sender functionality.

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


