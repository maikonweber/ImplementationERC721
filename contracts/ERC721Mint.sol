//SPDX-License-Identifier: MIT  
pragma solidity ^0.8.12;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./IERC2981.sol";
import "./LibPart.sol";
import "./LibRoyalties2981.sol";
import "./impl/AbstractRoyalties.sol";
import "./impl/RoyaltiesV2Impl.sol";
// Import Payment Splitter



contract yourNFT is ERC721A, Ownable, ReentrancyGuard {
    using Strings for uint256;
    uint96 constant _WEIGHT_VALUE = 1000000;

    struct RoyaltyInfo {
        address receiver;
        uint96 royaltyFraction;
    }
    mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
    RoyaltyInfo private _defaultRoyaltyInfo;
    address[] public artists;
    uint256 public _royalityFee;
    uint256 public minimuPrice;
    string public baseURI;
    string public baseExtension = ".json";
    uint256 public maxSupply = 10000;
    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
    bool public revealed = false;
     event Sale(address from, address to, uint256 value);

    constructor (
        string memory _name,
        string memory _symbol,
        uint256 _minimuPrice,
        uint256 royalityFee,
        string memory _initBaseURI,
        address[] memory _artists
    ) ERC721A (_name, _symbol) {
         baseURI  = _initBaseURI;
        _royalityFee = royalityFee;
         artists = _artists;
        setCost(_minimuPrice);
    }

  function _setDefaultRoyalty(address receiver, uint96 feeNumerator)
        internal
    {
        require(feeNumerator <= _feeDenominator(), "fee exceed salePrice");
        require(receiver != address(0), "invalid receiver");

        _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
    }

    function _deleteDefaultRoyalty() internal {
        delete _defaultRoyaltyInfo;
    }

  function transferRoyalty(address to, uint256 tokenId)
        public
        payable
    {
      require(msg.value > 0, "must transfer a non-zero amount");
      require(msg.sender)     

      _tokenRoyaltyInfo[tokenId].receiver = to;
      _tokenRoyaltyInfo[tokenId].royaltyFraction = _WEIGHT_VALUE;
      _tokenRoyaltyInfo[tokenId].receiver.transfer(msg.value);
      emit Sale(to, tokenId, msg.value);
    }

        

   
    function _setTokenRoyalty(
        uint256 tokenId,
        address receiver,
        uint96 feeNumerator
    ) internal {
        require(feeNumerator <= _feeDenominator(), "fee exceed salePrice");
        require(receiver != address(0), "invalid parameters");

        _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
    }

  function _resetTokenRoyalty(uint256 tokenId) internal {
        delete _tokenRoyaltyInfo[tokenId];
    }



 function setDefaultRoyalty(address receiver, uint96 feeNumerator)
        external
        onlyOwner
    {
        _setDefaultRoyalty(receiver, feeNumerator);
    }



function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        external
        view
        returns (address, uint256)
       {
         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];

        if (royalty.receiver == address(0)) {
            royalty = _defaultRoyaltyInfo;
        }

        uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) /
            _feeDenominator();

        return (royalty.receiver, royaltyAmount);
    }

       function _feeDenominator() internal pure returns (uint96) {
        return 10000;
    }


      function _payRoyality(uint256 _royalityFees) public payable virtual {
        (bool success1, ) = payable(address(this)).call{value: _royalityFees}("");
        require(success1);
    }


    function isArtist (address sender) public view returns (bool) {
        // If address inside artists array, return true
        for (uint256 i = 0; i < artists.length; i++) {
            if (artists[i] == sender) {
                return bool(true);
            }
        }
    }

    function seeArtictsArray() public view returns (address[] memory) {
        return artists;
    }

 
    function mint(
        address from,
        uint256 amount
        ) public {
        uint256 supply = totalSupply();
        require(supply <= maxSupply);
        require(amount > 0); // if msg sender is not an artist, then he can't mint
        if(!isArtist(msg.sender)) {
            require(true);
             _safeMint(from, amount);
        }
    }

    
  function withdrawMoney() external onlyOwner nonReentrant {
    (bool success, ) = msg.sender.call{value: address(this).balance}("");
    require(success, "Transfer failed.");
  }


function setCost(uint256 _cost) public onlyOwner {
    minimuPrice = _cost;
}

function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
    require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(baseURI, _tokenId.toString(), baseExtension))
        : "https://muttercorp.com/error";

  }

  function setRevealed(bool _state) public onlyOwner {
    revealed = _state;
  }


  

}