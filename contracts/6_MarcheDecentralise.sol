// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract MarcheDecentralise {
    struct Product {
        string name;
        uint price;
        uint stock;
    }

    mapping(uint => Product) public products;
    uint public productCount;
    address public owner;

    event ProductAdded(uint id, string name);
    event ProductUpdated(uint id, string name);
    event ProductDeleted(uint id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Seul le proprietaire peut effectuer cette action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addProduct(string memory _name, uint _price, uint _stock) external onlyOwner {
        productCount++;
        products[productCount] = Product(_name, _price, _stock);
        emit ProductAdded(productCount, _name);
    }

    function updateProduct(uint _id, string memory _name, uint _price, uint _stock) external onlyOwner {
        require(_id > 0 && _id <= productCount, "Produit non existant");
        Product storage product = products[_id];
        product.name = _name;
        product.price = _price;
        product.stock = _stock;
        emit ProductUpdated(_id, _name);
    }

    function deleteProduct(uint _id) external onlyOwner {
        require(_id > 0 && _id <= productCount, "Produit non existant");
        delete products[_id];
        emit ProductDeleted(_id);
    }

    function getProduct(uint _id) public view returns (string memory, uint, uint) {
        require(_id > 0 && _id <= productCount, "Produit non existant");
        Product memory product = products[_id];
        return (product.name, product.price, product.stock);
    }

    function copyProduct(uint _id) public view returns (Product memory) {
        require(_id > 0 && _id <= productCount, "Produit non existant");
        return products[_id];
    }
}
