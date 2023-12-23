// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {NFT_ERC20} from "./token/NFT_ERC20.sol";
import {NFT_ERC721} from "./token/NFT_ERC721.sol";
import {IERC721Receiver} from "./interface/IERC721Receiver.sol";

contract NTF_Market is IERC721Receiver{
    
    NFT_ERC20 public erc20;
    NFT_ERC721 public erc721;
    
    bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
     
    struct Order {
        address seller;
        uint256 tokenId;
        uint256 price;
    }

    // tokenId to order
    mapping(uint256 => Order) public tokenIdOforder;
    // stroage all order to orders
    Order[] public orders;
    // tokenId to Order of index in orders 
    mapping(uint256 => uint256) public idToOrderIndex; 
    
    event Deal(address indexed buyer, address indexed tokenId, uint256 price);
    event NewOrder(address indexed seller, uint256 indexed tokenId, uint256 price);
    event CancelOrder(address indexed seller, uint256 indexed tokenId);
    event ChangePrice(
        address seller, 
        uint256 tokenId,
        uint256 previousPrice
        uint256 price
    );
    
    /**
     * @dev 初始化market的erc20,erc721合约
     * erc20和erc721的合约地址不能为零 
     */
    constructor(NFT_ERC20 _erc20, NFT_ERC721 _erc721){
        require(_erc20 != address(0), 
        "Market :ERC20 contract must be non-null");

        require(_erc721 != address(0),
        "Market :ERC721 contract must be non-null");

        erc20 = _erc20;
        erc721 = _erc721;

    }
    
    /**
     * @dev token的购买功能
     * @param _tokenId
     * @param _price 
     * 交易的_tokenId不能为零   
     */
    function buy(uint256 _tokenId, uint256 _price) external {
        Order order = getOrderByTokenId(_tokenId);

        address seller = order.seller;
        address buyer = msg.sender;
        uint256 price = order.price;
        // 交易的钱必须等于商品的价格
        require(price == _price, 
        "Market: price is not equal");

        require(erc20.transferFrom(buyer, seller, price),
        "Market: ERC20 transfer is not successful"
        )
        // erc721的商品是拥有者授权给合约去进行transfer
        erc721.safeTransferFrom(address(this), buyer, _tokenId)
        removeListing(_tokenId);

        emit Deal(buyer, seller, _tokenId, price);

    }
    
    /**
     * @dev 撤销nft的上架
     * @param _tokenId
     * 需要检测上架的seller是否是本人
     */
    function CancelOrder(uint256 _tokenId) external {
        Order order = getOrderByTokenId(_tokenId);

        address seller = order.seller;
        require(seller == msg.sender,
        "Market: Sender is not seller");
        
        erc721.safeTransferFrom(address(this), seller, _tokenId);

        removeListing(_tokenId);
        emit CancelOrder(seller, _tokenId);
    
    }

    /**
     * @dev 改变订单的价格
     */
    function changePrice(uint256 _tokenId, uint256 _price)  returns () {
        Order order = getOrderByTokenId(_tokenId);

        require(seller == msg.sender,
        "Market: Sender is not seller");
        // 触发时间需要传递的参数
        uint256 previousPrice = order.price;
        // 需要改变两个全局变来变量 tokenIdOforder和orders
        tokenIdOforder[_tokenId].price = _price;
        // 获得order的索引给，将orders中的对应order改变
        Order stroage UpdateOrder = orders[idToOrderIndex[_tokenId]];
        UpdateOrder.price = _price;

        emit ChangePrice(seller, _tokenId, previousPrice, price);
    }

    /**
     * @dev 通过TOkenId获得order
     * 会检查_tokenId是否是市场的商品 
     */    
    function getOrderByTokenId(uint256 _tokenId) public view {
        require(isListed(_tokenId,
        "Market: token id is listed"));
        return tokenIdOforder[_tokenId];
    }

    function onERCReceived(
        address _operator,
        address _seller,
        uint256 _tokenId,
        bytes calldate _data
    ) public override returns (bytes4) {
        require(_operator == seller,
        "Market: seller must be operator");
        
        uint256 _price = toUint256(_data, 0);
        placeOrder(_seller, _tokenId, _price);

        return MAGIC_ON_ERC721_RECEIVED;
    }
    
    /**
     * @dev 
     */
    function isListed(uint256 _tokenId) public view returns (bool) {
        return tokenIdOforder[_tokenId].seller != address(0);
    }

    function getOrderLength() public view return(uint256) {
        return orders.length;
    }

    function toUint256(bytes memory _bytes, uint256 _start) 
     public
     pure
     returns (uint256) {
        require(_start + 32 >= _start,
        "Market: toUint256_overflow");
         
        require(_bytes.length >= _start + 32, 
        "Market: toUint256_outOfBunds");

        uint256 tempUint;
        assembly {
            tempUint := mload(add(add(_bytes, 0x20), _start))
        }

        return tempUint;
    }

    function placeOrder(
        address _seller,
        uint256 _tokenId,
        uint256 _price
    ) internal {
        require(_price > 0,
        "Market: Price must be greater than zero");

        tokenIdOforder[_tokenId].seller = _seller;
        tokenIdOforder[_tokenId].price = _price;
        tokenIdOforder[_tokenId].tokenId = _tokenId;

        orders.push(tokenIdOforder[_tokenId]));

        idToOrderIndex[_tokenId] = order.length - 1;

        emit NewOrder(_seller, _tokenId, _price);
    }
    
    function removeListing(uint256 _tokenId) internal {
        delete tokenIdOforder[tokenId];

        uint256 orderToRemoveIndex = idToOrderIndex[_tokenId];
        uint256 lastOrderIndex = orders.length - 1;

        if (la stOrderIndex != orderToRemoveIndex) {
            Order memory lastOrder = orders[lastOrderIndex];
            orders[orderToRemoveIndex] = lastOrder;
            idToOrderIndex[lastOrder.tokenId] = lastOrder;

        } 

        orders.pop();
    } 
}