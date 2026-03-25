# Liquid Staking Derivative (LSD)

This repository demonstrates the core architecture of a Liquid Staking protocol. It allows users to contribute to network security while maintaining liquidity for use in DeFi (e.g., as collateral in Aave).

## The Exchange Rate Model
Unlike "rebasing" tokens that change your balance, this implementation uses an **Exchange Rate** model (similar to Rocket Pool's rETH). 
- When you stake, you receive tokens based on: `amount / exchangeRate`.
- As rewards are added to the vault, the `exchangeRate` increases.
- When you unstake, you receive more of the underlying asset than you originally deposited.

## Features
* **Mint/Redeem**: Atomic entry and exit points.
* **Reward Accrual**: Dedicated function for authorized oracles/validators to "push" rewards into the contract.
* **Non-Reentrant**: Protected against pool-draining exploits.
