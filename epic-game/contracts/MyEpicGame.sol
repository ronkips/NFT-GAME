// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract MyEpicGame {
    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint kip;
        uint maxKip;
        uint attackDamage;
    }

    // A lil array to help us hold the default data for our characters.
    // This will be helpful when we mint new characters and need to know

    CharacterAttributes[] defaultCharacters;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterKip,
        uint[] memory characterAttackDmg
    ) {
        // Loop through all the characters, and save their values in our contract so
        // we can use them later when we mint our NFTs.
        for (uint i = 0; i < characterNames.length; i += 1) {
            defaultCharacters.push(
                CharacterAttributes({
                    characterIndex: i,
                    name: characterNames[i],
                    imageURI: characterImageURIs[i],
                    kip: characterKip[i],
                    maxKip: characterKip[i],
                    attackDamage: characterAttackDmg[i]
                })
            );
            CharacterAttributes memory c = defaultCharacters[i];
            console.log(
                "Done initializing %s w/ KIP %s, img %s",
                c.name,
                c.kip,
                c.imageURI
            );
        }
    }
}
