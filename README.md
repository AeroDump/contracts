![스크린샷 2024-09-01 204946](https://github.com/user-attachments/assets/a61c5c15-9647-4129-990d-ba3026e7d383)

# AeroDump: Revolutionizing Token Distribution
`AeroDump` is a cutting-edge platform designed to simplify and automate the distribution of tokens for users and project owners across multiple blockchain networks. 
Built to support airdrops, marketing event rewards, and large-scale token transfers, AeroDump leverages the power of automation, cross-chain interoperability, and secure vaults to provide an efficient, hands-free solution for bulk token distribution.

### [AeroDump Platform](https://aerodump.vercel.app/)

# Process
![image](https://github.com/user-attachments/assets/45b95d8f-273e-4461-890b-49ce3c94ada1)

## Key Features of this Flow:
**Easy Onboarding with Web3Auth:** 
- Web3Auth simplifies the login process by allowing users and project owners to use their social accounts for `secure and quick access` to the platform.
- This lowers the barrier for entry, especially for those unfamiliar with complex Web3 wallet setups.

**Hands-Free Automation with Multi-Network Support:**
- Chainlink Automation allows for `automatic triggering` of the token distribution from the LayerZero vault, while `LayerZero CCIP` ensures that tokens can be distributed across `multiple networks`. This enables cross-chain token distribution without the need for constant developer or operator intervention.

**Cross-Chain Attestation Updates:**
- When a user verifies a project on AeroDumpAttestations (which lives on Base Sepolia), attestation data is automatically updated in AeroDumpOFTAdapter via AeroDumpComposer using `LayerZero's omnichain messaging with the composed message pattern`. AeroDumpOFTAdapter and `AeroDumpComposer run on the Hedera chain`, ensuring `cross-chain data updates`.

**LayerZero Omnichain Token Transfer:**
- Users can lock tokens on supported chains, and recipients can receive those tokens on any chain they choose, utilizing `LayerZero’s omnichain token transfer feature`.

**Cross-Chain Flexibility:**
- With LayerZero CCIP, users or project owners can distribute tokens across various networks like `Ethereum, Solana, Avalanche`, and others. The tokens are `bridged seamlessly` to the chosen network during the distribution process.

**LayerZero Vault for Secure Holding:**
- The vault securely holds the tokens until the automation system triggers distribution. Tokens are only released when the conditions are met, ensuring safety and transparency.

## User Journey
```mermaid
graph TD;
    Sign-In/Sign-Up-->Register-Project;
    Register-Project-->Upload-CSV;
    Register-Project-->Fill-the-Text;
    Upload-CSV-->Deposit-Vault;
    Fill-the-Text-->Deposit-Vault;
    Deposit-Vault-->Auto-Distribution;
    Auto-Distribution-->Check-History;
```

1. **Visit Platform and Log In**:
   - Log in easily using Web3Auth with your social accounts.

2. **Register Project and Tokens**:
   - Enter project details, token information, and more.

3. **Upload CSV File**:
   - Upload a CSV file containing recipient addresses, token amounts, and network details or Users paste the address, token amounts, and network details into text box directly.

4. **Deposit Tokens**:
   - Deposit the tokens into the LayerZero vault for distribution.

5. **Automated Token Distribution**:
   - Chainlink Automation distributes tokens to recipients based on the CSV file, with multi-chain support via LayerZero CCIP.

6. **Check Distribution History**:
   - After completion, view all records on the history page using ENVIO on-chain indexing.

## How it's made
> **LayerZero**
>> **OFTAdapter.sol, composerfirst and composersecond contracts**
- Aerodump leverages LayerZero for seamless omnichain messaging, enabling attestations data from the home network to be sent to adapters on multiple chains. Attestations contracts are based on the home network, ensuring secure and reliable data communication across different blockchain environments. Cross-chain data access ensures that adapters on various chains can securely interact with attestations from the home network. LayerZero's OFT vault standards are utilized for efficient cross-chain asset transfers and management.
Aerodump's cross-chain solution enhances interoperability and functionality within decentralized ecosystems. This setup ensures fast, secure, and scalable interactions across blockchains. LayerZero technology facilitates a robust framework for multi-chain messaging and asset management in Aerodump's ecosystem.

> **Sign Protocol**
>> **AeroDumpAttestations.sol, Attestation contract**
- Sign Protocol enables cross-chain attestations that are verifiable across multiple networks. In our project, we're using Sign Protocol to create verified attestations for verifing a project, locked tokens and other project data, ensuring secure and transparent verification. These attestations can communicate across different chains via LayerZero, ensuring interoperability. This setup allows our system to authenticate token and project status across various blockchains, providing a unified verification standard without compromising security or decentralization. It simplifies the process of trustlessly confirming a project is verified and is tokens locked by a user along with the amount across chains, enhancing user trust in cross-chain interactions​.

> **Chainlink**
- We are using Chainlink Automation to trigger custom logic upkeep for automating the process of sending airdrops to recipients, one at a time. This avoids the need for looping over recipients, which would otherwise result in high gas costs. By using Chainlink's hyper-reliable decentralized automation network, we ensure efficient and gas-optimized transactions, sending airdrops to individual addresses automatically. Chainlink Upkeep handles the conditional execution of smart contract functions, making it scalable and cost-effective, especially for tasks that involve numerous recipients across various chains​.

> **Web3Auth**
- We use the Web3Auth SDK to provide users with a streamlined, passwordless authentication experience, generating a Web3 wallet for them instantly. This allows users to securely access our app without managing private keys directly, utilizing their existing social logins (like Google, Twitter, etc.) for seamless onboarding. Web3Auth integrates multi-party computation (MPC) and non-custodial key infrastructure to ensure both ease of use and high security across Web3 apps​. This setup enhances user engagement and simplifies Web3 interactions for newcomers.

## Foundry

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
