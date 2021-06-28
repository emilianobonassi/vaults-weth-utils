<h1 align=center><code>Yearn V2 Vaults WETH Utils</code></h1>

**Yearn V2 Vaults WETH Utils** is a collection of smart contracts to simplify Yearn V2 Vaults interaction for WETH.

## How it works

It simplifies the deposit/withdraw with Yearn V2 Vaults for WETH using directly ETH.

It supports `permit` to allow 1-tx operations.

## Usage

You have the following methods available:
- `deposit(address vault) payable external`, wrap (`msg.value`) ETH and deposit to the `vault`, transfering back the shares to the `msg.sender`.
- `withdraw(address vault)`, withdraw all the `vault` shares owned by the `msg.sender` and send back the respective ETH. Requires approve.
- `withdraw(address vault, uint256 shares)`, like above but for a specific amount of `shares`.
- `withdraw(address vault, uint256 deadline, bytes calldata signature)`, like the previous (full shares) but using permit.
- `withdraw(address vault, uint256 shares, uint256 deadline, bytes calldata signature)`, like above but for a specific amount of `shares`.

It's a developer tool, use at your own risk, no audit!