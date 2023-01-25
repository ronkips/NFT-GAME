// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Helper we wrote to encode in Base64
import "./libraries/Base64.sol";

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

contract MyEpicGame is ERC721 {
    uint randNonce = 0; // this is used to help ensure that the algorithm has different inputs every time

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint kip;
        uint maxKip;
        uint attackDamage;
    }

    struct BigBoss {
        string name;
        string imageURI;
        uint kip;
        uint maxKip;
        uint attackDamage;
    }
    // The tokenId is the NFTs unique identifier, it's just a number that goes
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    BigBoss public bigBoss;

    // A array to help us hold the default data for our characters.
    // This will be helpful when we mint new characters and need to know

    CharacterAttributes[] defaultCharacters;

    // We create a mapping from the nft's tokenId => that NFTs attributes.
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    // A mapping from an address => the NFTs tokenId. Gives me an easy way
    // to store the owner of the NFT and reference it later.
    mapping(address => uint256) public nftHolders;

    //events
    event CharacterNFTMinted(
        address sender,
        uint256 tokenId,
        uint256 characterIndex
    );
    event AttackComplete(address sender, uint newBossKip, uint newPlayerKip);

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterKip,
        uint[] memory characterAttackDmg,
        string memory bossName,
        string memory bossImageURI,
        uint bossKip,
        uint bossAttackDamage
    ) ERC721("KIP", "HKP") {
        //initialize the boss . save it to our global "bigBoss" variable .
        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            kip: bossKip,
            maxKip: bossKip,
            attackDamage: bossAttackDamage
        });
        console.log(
            "Done initializing boss %s w/ KIP %s, img %s",
            bigBoss.name,
            bigBoss.kip,
            bigBoss.imageURI
        );

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
        // I increment _tokenIds here so that my first NFT has an ID of 1.
        _tokenIds.increment();
    }

    // Users would be able to hit this function and get their NFT based on the
    // characterId they send in!
    function mintCharacterNFT(uint _characterIndex) external {
        // Get current tokenId (starts at 1 since we incremented in the constructor).
        uint256 newItemId = _tokenIds.current();

        // Assigning the tokenId to the caller's wallet address
        _safeMint(msg.sender, newItemId);
        // Holding dynamic data on NFT
        // We map the tokenId => their character attributes
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            kip: defaultCharacters[_characterIndex].kip,
            maxKip: defaultCharacters[_characterIndex].maxKip,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });

        console.log(
            "Minted NFT w/ tokenId %s and characterIndex %s",
            newItemId,
            _characterIndex
        );

        //Keeping an easy way to see who owns the NFT
        nftHolders[msg.sender] = newItemId;

        // Increment the tokenId for the next person using it.
        _tokenIds.increment();

        emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
    }

    //tokenURI function
    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[
            _tokenId
        ];

        string memory strKip = Strings.toString(charAttributes.kip);
        string memory strMaxKip = Strings.toString(charAttributes.maxKip);
        string memory strAttackDamage = Strings.toString(
            charAttributes.attackDamage
        );

        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                charAttributes.name,
                " -- NFT #: ",
                Strings.toString(_tokenId),
                '", "description": "This is an NFT that lets people play in the game Metaverse player!", "image": "',
                charAttributes.imageURI,
                '", "attributes": [ { "trait_type": "Health Points", "value": ',
                strKip,
                ', "max_value":',
                strMaxKip,
                '}, { "trait_type": "Attack Damage", "value": ',
                strAttackDamage,
                "} ]}"
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64", json)
        );
        return output;
    }

    function attackBoss() public {
        // Get the state of the player's NFT.
        uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[
            nftTokenIdOfPlayer
        ];
        console.log(
            "\nPlayer w/ character %s about to attack. Has %s KIP and %s AD",
            player.name,
            player.kip,
            player.attackDamage
        );
        console.log(
            "Boss %s has %s KIP and %s AD",
            bigBoss.name,
            bigBoss.kip,
            bigBoss.attackDamage
        );

        // Make sure the player has more than 0 KIP.
        require(
            player.kip > 0,
            "Error: character must have KIP to attack boss."
        );
        // Make sure the boss has more than 0 KIP.
        require(
            bigBoss.kip > 0,
            "Error: boss must have KIP to attack character."
        );
        console.log("%s swings at %s...", player.name, bigBoss.name);

        // Allow player to attack boss.
        if (bigBoss.kip < player.attackDamage) {
            bigBoss.kip = 0;
            console.log("The boss is dead");
        } else {
            if (randomInt(10) > 5) {
                bigBoss.kip = bigBoss.kip - player.attackDamage;
                console.log(
                    "%s attacked boss. New boss kip: %s",
                    player.name,
                    bigBoss.kip
                );
            } else {
                console.log("%s missed!\n", player.name);
            }
        }
        // Allow boss to attack player.
        if (player.kip < bigBoss.attackDamage) {
            player.kip = 0;
        } else {
            player.kip = player.kip - bigBoss.attackDamage;
        }
        emit AttackComplete(msg.sender, bigBoss.kip, player.kip);

        console.log("Player attacked boss. New boss kip is: %s", bigBoss.kip);
        console.log(
            "Boss attacked player. New player kip is: %s\n",
            player.kip
        );
    }

    function randomInt(uint _modulus) internal returns (uint) {
        randNonce++; //increase nonce
        return
            uint(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNonce)
                )
            ) % _modulus;
    }

    //Adding function to check if the user has a character NFT
    function checkIfUserHasNFT()
        public
        view
        returns (CharacterAttributes memory)
    {
        // Get the tokenId of the user's character NFT
        uint256 userNftTokenId = nftHolders[msg.sender];
        // If the user has a tokenId in the map, return their character.
        if (userNftTokenId > 0) {
            return nftHolderAttributes[userNftTokenId];
        }
        // Else, return an empty character.
        else {
            CharacterAttributes memory emptyStruct;
            return emptyStruct;
        }
    }

    function getAllDefaultCharacters()
        public
        view
        returns (CharacterAttributes[] memory)
    {
        return defaultCharacters;
    }

    function getBigBoss() public view returns (BigBoss memory) {
        return bigBoss;
    }




}




