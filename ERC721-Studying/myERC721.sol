// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "./ERC721.sol";

contract test is ERC721{

    uint public MAX = 100; // 总量

    // 构造函数
    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://www.baidu.com/";
    }

    // 铸造函数
    function mint(address to, uint tokenId) external {
        require(tokenId >= 0 && tokenId < MAX, "tokenId out of range");
        _mint(to, tokenId);
    }

    function burn(uint256 tokenId) external {
        require(tokenId >= 0 && tokenId < MAX, "tokenId out of range");
        _burn(tokenId);
    }
}