// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTstaking is ReentrancyGuard {
using SafeERC20 for IERC20;


IERC20 public immutable rewardsToken;
IERC721 public immutable nftCollection;

constructor(IERC721 _nftCollection, IERC20 _rewardsToken) {
    nftCollection = _nftCollection;
    rewardsToken = _rewardsToken;
}

uint256 public constant SILVER_MULTIPLIER = 2;
uint256 public constant GOLD_MULTIPLIER = 3;

struct StakedToken {
    address staker;
    uint256 tokenId;
    string name;
    string level;
    string shop;
    string actor;
    string singer;
    string country;
    string equipment;
    string game;
    string offensive;
    string defensive;
}

// Staker info
struct Staker {
    uint256 amountStaked;
    StakedToken[] stakedTokens;
    uint256 timeOfLastUpdate;
    uint256 unclaimedRewards;
    uint256 package; // 0: non-package, 1: silver, 2: gold
    string paid; 
    string hi;
    string say;
}

uint256 private rewardsPerHour = 10000000000;

  event NoMan(address indexed user);
  event YesMan(address indexed user);

mapping(address => string) public userNames;// new mapping to store user names
mapping(address => Staker) public stakers;
mapping(uint256 => address) public stakerAddress;
mapping(address => string) public membershipLevels;
mapping(address => uint256) public membershipTimestamps;

string[] private names = ["Pro", "Franchise", "Lambo"];
string[] private levels = ["Coach", "Team Owner", "Stadium Owner"];
string[] private actors = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
string[] private singers = ["Volleyball Stadium Owner", "Volleyball Team Owner", "Volleyball Head Coach", "Volleyball Fan", "Volleyball Defensive Specialist", "Volleyball Libero", "Volleyball Middle Blocker", "Volleyball Opposite Hitter", "Volleyball Outside Hitter", "Volleyball Setter", "Golf Pro", "Golf Head Coach", "Golf Stadium Owner", "Golf Team Owner", "Golf Fan", "Esports Fan", "Esports Pro Gamer", "Esports Team Owner", "Esports Stadium Owner", "Esports Head Coach", "Football Kick Return", "Football Holder", "Football Long Snapper", "Football Punter", "Football Kicker", "Football Strong Safety", "Football Free Safety", "Football Corner Back", "Football Right Outside Linebacker"];
string[] private shops = ["Jersey Number 00#10", "Jersey Number 0#8", "Jersey Number 69#3", "Jersey Number 42#5", "Jersey Number 34#5", "Jersey Number 33#5", "Jersey Number 32#5", "Jersey Number 30#6", "Jersey Number 25#5"];
string[] private countrys = ["Plexicon Valley", "Plex City", "Beijing", "Finland", "Seoul"];
string[] private equipments = ["Bat", "Helmet", "Racket", "Club"];
string[] private offensives = ["100", "200","300", "500", "1000", "700"];
string[] private defensives = ["100", "200","300", "500", "1000", "700"];
string[] private games = ["Baseball", "Basketball" , "Cricket", "Football", "Esports", "Golf", "Soccerr"];



function getRandomName() private view returns (string memory) {
    uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % names.length;
    return names[randomIndex];
}


function getRandomCountry() private view returns (string memory) {
    uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % countrys.length;
    return countrys[randomIndex];
}

function getRandomEquipment() private view returns (string memory) {
    uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % equipments.length;
    return equipments[randomIndex];
}

function getRandomOffensive() private view returns (string memory) {
    uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % offensives.length;
    return offensives[randomIndex];
}

function getRandomDefensive() private view returns (string memory) {
    uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % defensives.length;
    return defensives[randomIndex];
}


function getRandomGame() private view returns (string memory) {
    uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % games.length;
    return games[randomIndex];
}

function getRandomLevel() private view returns (string memory) {
    uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % levels.length;
    return levels[randomIndex];
}

function getRandomShop() private view returns (string memory) {
    uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % shops.length;
    return shops[randomIndex];
}

function getRandomActor() private view returns (string memory) {
    uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % actors.length;
    return actors[randomIndex];
}

function getRandomSinger() private view returns (string memory) {
    uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % singers.length;
    return singers[randomIndex];
}

 function buySilverPackage() external payable {
        require(stakers[msg.sender].package == 0, "You have already purchased a package");
        require(msg.value == 0.001 ether, "Invalid amount");

        stakers[msg.sender].package = 1;
        membershipLevels[msg.sender] = "Silver";

   
         string[3] memory goldNames = ["Fan", "Mascot", "Player"];
         uint256 index = uint256(keccak256(abi.encodePacked(msg.sender, block.number))) % goldNames.length;
         stakers[msg.sender].say = goldNames[index];

        // Generate random name
        if (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % 2 == 0) {
            stakers[msg.sender].paid = "Jerry"; // assign random name "Jerry"
            membershipTimestamps[msg.sender] = block.timestamp;
            stakers[msg.sender].unclaimedRewards += rewardsPerHour * SILVER_MULTIPLIER;
            emit NoMan(msg.sender);
        } else {
            stakers[msg.sender].paid = "Petter"; // assign random name "Petter"
            membershipTimestamps[msg.sender] = block.timestamp;
            stakers[msg.sender].unclaimedRewards += rewardsPerHour * SILVER_MULTIPLIER;
            emit NoMan(msg.sender);
        }
    }

   function buyGoldPackage() external payable {
        require(stakers[msg.sender].package == 0, "You have already purchased a package");
        require(msg.value == 0.002 ether, "Invalid amount");

        stakers[msg.sender].package = 2;
        membershipLevels[msg.sender] = "Gold";

       string[2] memory silverNames = ["Rookie", "D League"];
       uint256 index = uint256(keccak256(abi.encodePacked(msg.sender, block.number))) % silverNames.length;
       stakers[msg.sender].hi = silverNames[index];


        // Generate random name
        if (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % 2 == 0) {
            stakers[msg.sender].paid = "Jerry"; // assign random name "Jerry"
            membershipTimestamps[msg.sender] = block.timestamp;
            stakers[msg.sender].unclaimedRewards += rewardsPerHour * GOLD_MULTIPLIER;
            emit YesMan(msg.sender);
        } else {
            stakers[msg.sender].paid = "Petter"; // assign random name "Petter"
            membershipTimestamps[msg.sender] = block.timestamp;
            stakers[msg.sender].unclaimedRewards += rewardsPerHour * GOLD_MULTIPLIER;
            emit YesMan(msg.sender);
        }
    }

    function getStakerPaidName(address user) public view returns (string memory) {
    require(stakers[user].package != 0, "User has not purchased a package");

    if (stakers[user].package == 1) {
        // Array of names for Silver package
        string[2] memory silverNames = ["Rookie", "D League"];
        uint256 index = uint256(keccak256(abi.encodePacked(user, block.number))) % silverNames.length;
        return silverNames[index];
    } else if (stakers[user].package == 2) {
        // Array of names for Gold package
          string[3] memory goldNames = ["Fan", "Mascot", "Player"];
        uint256 index = uint256(keccak256(abi.encodePacked(user, block.number))) % goldNames.length;
        return goldNames[index];
    } else {
        revert("Invalid package level");
    }
}




function stake(uint256 _tokenId) external nonReentrant {
    if (stakers[msg.sender].amountStaked > 0) {
        uint256 rewards = calculateRewards(msg.sender);
        stakers[msg.sender].unclaimedRewards += rewards;
    }

    require(
        nftCollection.ownerOf(_tokenId) == msg.sender,
        "You don't own this token!"
    );

    nftCollection.transferFrom(msg.sender, address(this), _tokenId);
    


    string memory name = getRandomName();
    string memory level = getRandomLevel();
    string memory shop = getRandomShop();
    string memory actor = getRandomActor();
    string memory singer = getRandomSinger();
    string memory country = getRandomCountry();
    string memory equipment = getRandomEquipment();
    string memory game = getRandomGame();
    string memory offensive = getRandomOffensive();
    string memory defensive = getRandomDefensive();

    StakedToken memory stakedToken = StakedToken(msg.sender, _tokenId, name, level, shop, actor, singer, country, equipment, game, offensive, defensive);

   
    stakers[msg.sender].stakedTokens.push(stakedToken);

    stakers[msg.sender].amountStaked++;

    stakers[msg.sender].package = 0;

    stakerAddress[_tokenId] = msg.sender;

    stakers[msg.sender].timeOfLastUpdate = block.timestamp;
}

function withdraw(uint256 _tokenId) external nonReentrant {
    require(
        stakers[msg.sender].amountStaked > 0,
        "You have no tokens staked"
    );

    require(
        stakerAddress[_tokenId] == msg.sender,
        "You don't own this token!"
    );

    uint256 rewards = calculateRewards(msg.sender);
    stakers[msg.sender].unclaimedRewards += rewards;

    uint256 index = 0;
    for (uint256 i = 0; i < stakers[msg.sender].stakedTokens.length; i++) {
        if (
            stakers[msg.sender].stakedTokens[i].tokenId == _tokenId &&
            stakers[msg.sender].stakedTokens[i].staker != address(0)
        ) {
            index = i;
            break;
        }
    }

    stakers[msg.sender].stakedTokens[index].staker = address(0);
    stakers[msg.sender].stakedTokens[index].name = "";

    stakers[msg.sender].amountStaked--;

    stakerAddress[_tokenId] = address(0);
       

        nftCollection.transferFrom(address(this), msg.sender, _tokenId);

        stakers[msg.sender].timeOfLastUpdate = block.timestamp;
    }

    function claimRewards() external {
        uint256 rewards = calculateRewards(msg.sender) +
            stakers[msg.sender].unclaimedRewards;
        require(rewards > 0, "You have no rewards to claim");
        stakers[msg.sender].timeOfLastUpdate = block.timestamp;
        stakers[msg.sender].unclaimedRewards = 0;
        rewardsToken.safeTransfer(msg.sender, rewards);
    }

    function availableRewards(address _staker) public view returns (uint256) {
        uint256 rewards = calculateRewards(_staker) +
            stakers[_staker].unclaimedRewards;
        return rewards;
    }

    function getUserAssignedName(address user) public view returns (string memory) {
    return userNames[user];
     }


    function getStakedTokens(address _user) public view returns (StakedToken[] memory) {
        if (stakers[_user].amountStaked > 0) {
            StakedToken[] memory _stakedTokens = new StakedToken[](stakers[_user].amountStaked);
            uint256 _index = 0;

            for (uint256 j = 0; j < stakers[_user].stakedTokens.length; j++) {
                if (stakers[_user].stakedTokens[j].staker != (address(0))) {
                    _stakedTokens[_index] = stakers[_user].stakedTokens[j];
                    _index++;
                }
            }

            return _stakedTokens;
        }
        else {
            return new StakedToken[](0);
        }
    }

   

    function getStakedTokenNames(address _user) public view returns (string[] memory) {
    StakedToken[] memory stakedTokens = getStakedTokens(_user);
    string[] memory tokenNames = new string[](stakedTokens.length);

    for (uint i = 0; i < stakedTokens.length; i++) {
        tokenNames[i] = stakedTokens[i].name;
    }

    return tokenNames;
  }

   function getStakedLevelNames(address _user) public view returns (string[] memory) {
    StakedToken[] memory stakedTokens = getStakedTokens(_user);
    string[] memory tokenLevel = new string[](stakedTokens.length);

    for (uint i = 0; i < stakedTokens.length; i++) {
        tokenLevel[i] = stakedTokens[i].level;
    }

    return tokenLevel;
  }

  function getStakedShopNames(address _user) public view returns (string[] memory) {
    StakedToken[] memory stakedTokens = getStakedTokens(_user);
    string[] memory tokenShop = new string[](stakedTokens.length);

    for (uint i = 0; i < stakedTokens.length; i++) {
        tokenShop[i] = stakedTokens[i].shop;
    }

    return tokenShop;
  }
    function getStakedActorNames(address _user) public view returns (string[] memory) {
    StakedToken[] memory stakedTokens = getStakedTokens(_user);
    string[] memory tokenActor = new string[](stakedTokens.length);

    for (uint i = 0; i < stakedTokens.length; i++) {
        tokenActor[i] = stakedTokens[i].actor;
    }

    return tokenActor;
  }
    function getStakedSingerNames(address _user) public view returns (string[] memory) {
    StakedToken[] memory stakedTokens = getStakedTokens(_user);
    string[] memory tokenSinger = new string[](stakedTokens.length);

    for (uint i = 0; i < stakedTokens.length; i++) {
        tokenSinger[i] = stakedTokens[i].singer;
    }

    return tokenSinger;
  }
   function getStakedCountryNames(address _user) public view returns (string[] memory) {
    StakedToken[] memory stakedTokens = getStakedTokens(_user);
    string[] memory tokenCountry = new string[](stakedTokens.length);

    for (uint i = 0; i < stakedTokens.length; i++) {
        tokenCountry[i] = stakedTokens[i].country;
    }

    return tokenCountry;
  }
   function getStakedEquipmentNames(address _user) public view returns (string[] memory) {
    StakedToken[] memory stakedTokens = getStakedTokens(_user);
    string[] memory tokenEquipment = new string[](stakedTokens.length);

    for (uint i = 0; i < stakedTokens.length; i++) {
        tokenEquipment[i] = stakedTokens[i].equipment;
    }

    return tokenEquipment;
  }
   function getStakedGameNames(address _user) public view returns (string[] memory) {
    StakedToken[] memory stakedTokens = getStakedTokens(_user);
    string[] memory tokenGame = new string[](stakedTokens.length);

    for (uint i = 0; i < stakedTokens.length; i++) {
        tokenGame[i] = stakedTokens[i].game;
    }

    return tokenGame;
  }
 function getStakedOffensiveNames(address _user) public view returns (string[] memory) {
    StakedToken[] memory stakedTokens = getStakedTokens(_user);
    string[] memory tokenOffensive = new string[](stakedTokens.length);

    for (uint i = 0; i < stakedTokens.length; i++) {
        tokenOffensive[i] = stakedTokens[i].offensive;
    }

    return tokenOffensive;
  }
   function getStakedDefensiveNames(address _user) public view returns (string[] memory) {
    StakedToken[] memory stakedTokens = getStakedTokens(_user);
    string[] memory tokenDefensive = new string[](stakedTokens.length);

    for (uint i = 0; i < stakedTokens.length; i++) {
        tokenDefensive[i] = stakedTokens[i].defensive;
    }

    return tokenDefensive;
  }



  function calculateRewards(address _staker) internal view returns (uint256 _rewards) {
    uint256 multiplier = 1;
    if (stakers[_staker].package == 1) {
        multiplier = SILVER_MULTIPLIER;
    } else if (stakers[_staker].package == 2) {
        multiplier = GOLD_MULTIPLIER;
    }

    if (stakers[_staker].package == 0) {
        // If the user doesn't have any package, provide rewards like earlier
        return (((
            ((block.timestamp - stakers[_staker].timeOfLastUpdate) *
                stakers[_staker].amountStaked)
        ) * rewardsPerHour) / 10000000000);
    } else {
        // If the user has a package, provide rewards multiplied by the package multiplier
        return (((
            ((block.timestamp - stakers[_staker].timeOfLastUpdate) *
                stakers[_staker].amountStaked)
        ) * rewardsPerHour * multiplier) / 10000000000);
    }
}

}