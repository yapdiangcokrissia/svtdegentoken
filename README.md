# svtdegentoken

## Overview
This Solidity smart contract implements a tokenized in-game store system where users can redeem tokens for characters in the game. It also includes features such as loyalty points and discount application.

## Smart Contract Details
- **Token Name:** Degen
- **Token Symbol:** DGN
- **Version:** 0.8.0

## Contract Functionalities
1. **Minting:** Owner can mint new tokens.
2. **Redeeming:** Users can redeem tokens for characters in the in-game store.
3. **Burning:** Users can burn their own tokens.
4. **Adding Characters:** Owner can add new characters to the in-game store.
5. **Removing Characters:** Owner can remove characters from the in-game store.
6. **Applying Discount:** Owner can apply a discount to a character.
7. **Loyalty Points:** Users earn loyalty points with each purchase.

## Usage
1. **Minting:** Mint new tokens using the `mint` function.
2. **Redeeming:** Redeem tokens for characters using the `redeem` function.
3. **Burning:** Burn tokens using the `burn` function.
4. **Adding Characters:** Add characters to the store using the `addCharacterToStore` function.
5. **Removing Characters:** Remove characters from the store using the `removeCharacterFromStore` function.
6. **Applying Discount:** Apply a discount to a character using the `applyDiscount` function.
7. **Viewing Purchase History:** View purchase history using the `getPurchaseHistory` function.
8. **Viewing Loyalty Points:** View loyalty points using the `getLoyaltyPoints` function.

## Events
The contract emits the following events:
- `Minted`: When tokens are minted.
- `Redeemed`: When tokens are redeemed for a character.
- `Burned`: When tokens are burned.
- `CharacterAddedToStore`: When a new character is added to the store.
- `CharacterRemovedFromStore`: When a character is removed from the store.
- `DiscountApplied`: When a discount is applied to a character.
- `LoyaltyPointsEarned`: When loyalty points are earned.

## License
This smart contract is licensed under the MIT License.

