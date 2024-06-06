// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/access/Ownable.sol";

contract svtdegentoken is ERC20, Ownable {

    // Struct to represent a character and its inventory
    struct Character {
        string name;
        string category;
        uint256 price;
        uint256 stock;
    }

    // Struct to represent a purchase record
    struct Purchase {
        string characterName;
        string location;
        uint256 quantity;
        uint256 timestamp;
    }

    // Struct to represent loyalty points
    struct Loyalty {
        uint256 points;
        uint256 lastUpdated;
    }

    // Mapping for in-game store characters by name
    mapping(string => Character) public storeCharacters;
    // Mapping to store redeemed characters and their locations by user
    mapping(address => Purchase[]) public purchaseHistory;
    // Mapping to store loyalty points for each user
    mapping(address => Loyalty) public loyaltyPoints;
    // Array of predefined locations
    string[] private locations;

    // Event logging for key actions
    event Minted(address indexed to, uint256 amount);
    event Redeemed(address indexed from, uint256 amount, string characterName, string location, uint256 quantity);
    event Burned(address indexed from, uint256 amount);
    event CharacterAddedToStore(string characterName, string category, uint256 price, uint256 stock);
    event CharacterRemovedFromStore(string characterName);
    event DiscountApplied(string characterName, uint256 discountPercentage);
    event LoyaltyPointsEarned(address indexed user, uint256 points);

    constructor() ERC20("Degen", "DGN") {
        // Initialize with store characters
        addCharacterToStore("Jeon Wonwoo", "Warriors", 300, 10);
        addCharacterToStore("Choi Seungcheol", "Leaders", 250, 15);
        addCharacterToStore("Kim Mingyu", "Protectors", 500, 5);
        addCharacterToStore("Chwe Hansol", "Strategists", 200, 20);

        // Initialize locations
        locations = ["HYBE", "SM", "YG", "STARSHIP"];
    }

    // Minting function: Only the owner can mint new tokens
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        emit Minted(to, amount);
    }

    // Redeeming function: Redeem tokens for characters in the in-game store and specify the location
    function redeem(string memory characterName, string memory location, uint256 quantity) public {
        Character storage character = storeCharacters[characterName];
        require(character.price > 0, "Character not available in store");
        require(character.stock >= quantity, "Insufficient character stock");
        uint256 totalPrice = character.price * quantity;
        require(balanceOf(msg.sender) >= totalPrice, "Insufficient balance");
        require(isValidLocation(location), "Invalid location");

        // Deduct balance from the user's account
        _transfer(msg.sender, owner(), totalPrice);

        // Update the user's balance and character stock
        _burn(msg.sender, totalPrice);
        character.stock -= quantity;

        // Record purchase
        purchaseHistory[msg.sender].push(Purchase(character.name, location, quantity, block.timestamp));
        emit Redeemed(msg.sender, totalPrice, characterName, location, quantity);

        // Award loyalty points
        uint256 pointsEarned = totalPrice / 10; // 10% of the total price as loyalty points
        loyaltyPoints[msg.sender].points += pointsEarned;
        loyaltyPoints[msg.sender].lastUpdated = block.timestamp;
        emit LoyaltyPointsEarned(msg.sender, pointsEarned);
    }

    // Function to check if a location is valid
    function isValidLocation(string memory location) internal view returns (bool) {
        for (uint256 i = 0; i < locations.length; i++) {
            if (keccak256(abi.encodePacked(locations[i])) == keccak256(abi.encodePacked(location))) {
                return true;
            }
        }
        return false;
    }

    // Burn function: Allows anyone to burn their own tokens
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
        emit Burned(msg.sender, amount);
    }

    // Owner can add new characters to the in-game store
    function addCharacterToStore(string memory characterName, string memory category, uint256 price, uint256 stock) public onlyOwner {
        storeCharacters[characterName] = Character(characterName, category, price, stock);
        emit CharacterAddedToStore(characterName, category, price, stock);
    }

    // Owner can remove characters from the in-game store
    function removeCharacterFromStore(string memory characterName) public onlyOwner {
        require(storeCharacters[characterName].price > 0, "Character not found in store");
        delete storeCharacters[characterName];
        emit CharacterRemovedFromStore(characterName);
    }

    // Owner can apply a discount to a character
    function applyDiscount(string memory characterName, uint256 discountPercentage) public onlyOwner {
        require(storeCharacters[characterName].price > 0, "Character not found in store");
        require(discountPercentage > 0 && discountPercentage <= 100, "Invalid discount percentage");
        storeCharacters[characterName].price = storeCharacters[characterName].price * (100 - discountPercentage) / 100;
        emit DiscountApplied(characterName, discountPercentage);
    }

    // Get a list of purchase history for a user
    function getPurchaseHistory(address user) public view returns (Purchase[] memory) {
        return purchaseHistory[user];
    }

    // Get the loyalty points for a user
    function getLoyaltyPoints(address user) public view returns (uint256) {
        return loyaltyPoints[user].points;
    }
}
