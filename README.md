# ARES Treasury Execution System

ARES Protocol manages a large on-chain treasury and needs a secure way to execute governance-approved transactions.  
This repository implements a modular treasury execution system designed to reduce common governance and treasury risks such as replay attacks, premature execution, and double reward claims.

### Features

- Governance proposal system
- Time-delayed treasury execution
- Cryptographic authorization using signatures
- Merkle-based contributor reward distribution
- Replay protection using nonces
- Double claim prevention
- Modular contract architecture

### System Components

The protocol is separated into independent modules:

- **AresTreasury (Core)**  
  Handles proposal lifecycle: creation, queueing, execution, and cancellation.

- **AuthorizationModule**  
  Verifies signatures from approved governance signers and prevents replay attacks through nonce tracking.

- **TimelockModule**  
  Enforces a mandatory delay before any treasury transaction can be executed.

- **RewardDistributor**  
  Allows contributors to claim rewards using Merkle proofs in a gas-efficient way.

### Security Protections

The system includes protections against common smart contract risks:

- Signature replay attacks
- Unauthorized treasury execution
- Double reward claims
- Premature execution of proposals
- Governance transaction replay

### Project Structure
src  
├── core  
│   └── AresTreasury.sol  
├── interfaces  
│   ├── IAresTreasury.sol  
│   ├── IAuthorization.sol  
│   └── IRewardDistributor.sol   
├── libraries   
│   ├── ECDSAValidator.sol  
│   └── ProposalHashLib.sol  
└── modules    
    ├── AuthorizationModule.sol  
    ├── RewardDistributor.sol  
    └── TimelockModule.sol  
