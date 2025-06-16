// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract VendingMachineV4 is Initializable {
  uint public numSodas;
  address public owner;
  uint256 public sodaPrice;
  mapping(address buyer => uint256 bought) public amountBought;

  event SodaAdded(uint256 amount);
  event SodaSold(uint8 amount, address indexed buyer);
  event SodaPriceChanged(uint256 price);

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor () {
    _disableInitializers();
  }

  function initialize(uint _numSodas, uint256 _price) public initializer {
    numSodas = _numSodas;
    owner = msg.sender;

    sodaPrice = _price;
    emit SodaPriceChanged(_price);
  }

  function purchaseSoda(uint8 amount) public payable {
    require(msg.value >= amount * sodaPrice, "Insufficient funds");
    require(numSodas > 0, "Soda finished");
    numSodas -= amount;
    amountBought[msg.sender] += amount;

    emit SodaSold(amount, msg.sender);
  }

  function withdrawProfits() public onlyOwner {
    require(address(this).balance > 0, "Profits must be greater than 0 in order to withdraw!");
    (bool sent, ) = owner.call{value: address(this).balance}("");
    require(sent, "Failed to send ether");
  }

  function setNewOwner(address _newOwner) public onlyOwner {
    owner = _newOwner;
  }

  function addSodas(uint256 amount) public onlyOwner {
    numSodas += amount;
    emit SodaAdded(amount);
  }

  function setPrice(uint256 _price) external onlyOwner {
    sodaPrice = _price;
    emit SodaPriceChanged(_price);
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function.");
    _;
  }
}