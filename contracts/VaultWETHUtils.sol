// SPDX-License-Identifier: Unlicense

import "../interfaces/IWETH9.sol";
import "../interfaces/VaultAPI.sol";

pragma solidity ^0.8.0;

contract VaultWETHUtils {

    IWETH9 immutable public WETH9;

    constructor(address _weth9) {
        WETH9 = IWETH9(_weth9);
    }

    function deposit(address vault) payable external {
        // Wrap
        WETH9.deposit{value: msg.value}();

        WETH9.approve(vault, msg.value);

        // Deposit and transfer
        VaultAPI(vault).deposit(msg.value, msg.sender);
    }

    function withdraw(address vault) external {
        _withdraw(vault, VaultAPI(vault).balanceOf(msg.sender));
    }

    function withdraw(address vault, uint256 shares) external {
        _withdraw(vault, shares);
    }

    function withdraw(address vault, uint256 deadline, bytes calldata signature) external {
        uint256 shares = VaultAPI(vault).balanceOf(msg.sender);

        _permit(vault, shares, deadline, signature);
        _withdraw(vault, shares);
    }

    function withdraw(address vault, uint256 shares, uint256 deadline, bytes calldata signature) external {
        _permit(vault, shares, deadline, signature);
        _withdraw(vault, shares);
    }

    function _withdraw(address vault, uint256 shares) internal {
        address self = address(this);

        // Transfer shares
        VaultAPI(vault).transferFrom(msg.sender, self, shares);

        // Withdraw
        VaultAPI(vault).withdraw(shares);

        // Unwrap
        WETH9.withdraw(WETH9.balanceOf(self));

        // Send back
        payable(msg.sender).transfer(self.balance);

        // In the case we have some remainings, send back
        uint256 remainingBalance = VaultAPI(vault).balanceOf(self);
        if (remainingBalance > 0) {
            VaultAPI(vault).transfer(msg.sender, remainingBalance);
        }
    }

    function _permit(
        address vault,
        uint256 value,
        uint256 deadline,
        bytes calldata signature
    ) internal {
        require(
            VaultAPI(vault).permit(
                msg.sender,
                address(this),
                value,
                deadline,
                signature
            ),
            "Unable to permit on vault"
        );
    }

    fallback() external payable {}

    receive() external payable {}
}