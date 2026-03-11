# ARES Treasury System Architecture

### Overview

The ARES treasury system is designed as a modular execution framework for governance-controlled funds.  
The architecture separates responsibility across independent modules to reduce complexity and improve security.

This separation limits the impact of failures and makes each component easier to audit.

---

### Core Components

### 1. AresTreasury (Core Execution Layer)

The treasury contract acts as the main coordination layer of the protocol.

It manages the full proposal lifecycle:

1. Proposal creation
2. Proposal queueing
3. Timelock delay
4. Transaction execution
5. Cancellation

Proposals cannot execute immediately.  
They must first be queued and pass the configured timelock delay before execution.

---

### 2. Authorization Module

Governance authorization is handled by the `AuthorizationModule`.

This module maintains a registry of approved signers who are allowed to authorize treasury operations.  
Signatures are verified using ECDSA and include nonce tracking to prevent replay attacks.

Each signer has an independent nonce mapping to ensure that previously used signatures cannot be reused.

Security protections provided:

- replay protection
- signer verification
- nonce tracking

---

### 3. Timelock Execution Engine

The `TimelockModule` enforces delayed execution of governance proposals.

When a proposal is queued, the module records an execution timestamp based on the configured delay.  
Execution is only allowed once the required delay has passed.

This mechanism protects the treasury from instant execution of malicious proposals and provides time for monitoring and intervention if necessary.

---

### 4. Reward Distribution Module

Contributor rewards are distributed through the `RewardDistributor` module.

To support a large number of recipients without excessive gas costs, the system uses a Merkle tree distribution model.

The process works as follows:

1. A Merkle root representing the reward distribution is published on-chain.
2. Contributors submit a Merkle proof to verify their allocation.
3. The contract verifies the proof and transfers the reward tokens.

Claim tracking ensures that each address can only claim once.

Security protections include:

- proof verification
- double claim prevention
- independent user claims

---

## Security Boundaries

Each module operates within a clearly defined responsibility boundary:

| Module | Responsibility |
|------|------|
AresTreasury | Proposal lifecycle and transaction execution |
AuthorizationModule | Signature verification and replay protection |
TimelockModule | Delayed execution enforcement |
RewardDistributor | Scalable reward distribution |

Separating these concerns reduces the risk of critical vulnerabilities affecting the entire system.

---

## Trust Assumptions

The system assumes that governance signers act honestly and that the Merkle distribution root is generated off-chain correctly.

The timelock delay acts as a safety mechanism that provides time for community monitoring and response in the event of a malicious proposal.



## Conclusion

The ARES treasury architecture provides a simple but secure foundation for governance-controlled fund management.  
