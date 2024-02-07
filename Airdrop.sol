// SPDX License-Identifier: MIT

import "./node_modules//@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./node_modules//@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./node_modules//@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "./node_modules//@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";



pragma solidity ^0.8.20;

contract Airdrop {
    using SafeERC20 for IERC20Metadata;

    address owner;
    address dropToken;
    uint dropAmount;
    bytes32 root;
    mapping (address => bool) userClaimed;
    constructor(address _dropToken, uint256 _dropAmount) {
        owner = msg.sender;
        dropToken = _dropToken;
        dropAmount = _dropAmount;
    }
 
/// @param _root  set the root of the Merkle tree
    function setRoot(bytes32 _root) public {
        require(msg.sender == owner);
        root = _root;
    }
/// 
/// @param proof array of hashes from which the root will be reconstructed
    function claim(bytes32[] calldata proof) public {
        require(!userClaimed[msg.sender]);
        require(MerkleProof.verify(proof, root, keccak256(abi.encodePacked(msg.sender))));
        IERC20Metadata(dropToken).safeTransfer(msg.sender, dropAmount);
        userClaimed[msg.sender] = true;
    }
}
