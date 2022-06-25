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
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';


contract yourNFT is ERC721A, Ownable, ReentrancyGuard, RoyaltiesV2Impl {
    using Strings for uint256;
    uint96 constant _WEIGHT_VALUE = 1000000;
    uint256 internal _artisValue;
    address[] public artists;
    address public txFreeToken;
    uint public _royalityFee;
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
        uint royalityFee,
        string memory _initBaseURI,
        address[] memory _artists
    ) ERC721A (_name, _symbol) {    
         baseURI  = _initBaseURI;
        _royalityFee = royalityFee;
         artists = _artists;
        setCost(_minimuPrice);
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

    function checkTokenRoyaltics(uint256 tokenId,uint256 value) public pure returns (uint256 artistsValue) {

        return artistsValue;  
    } 

   
    function safeTransferFrom(
        address from, 
        address to,
        uint256 tokenId
    ) public override {
        if(isArtist(from) == false) {
            _payTxfree(from, to);
        }

        transferFrom(from, to, tokenId);
    }

    function _payTxfree(address from, address to) public payable {
        uint256 royality = (msg.value * _royalityFee) / 100;
        _payRoyality(from, _royalityFee);
        (bool success2, ) = payable(from).call{value: msg.value - royality}("");
        require(success2);
        emit Sale(from, to, msg.value);
            
    }



    function _payRoyality(address from, uint256 royalityFee) internal {
    IERC20 token = IERC20(owner());

    token.transferFrom(from, owner(), royalityFee);
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

    // Overide ERC721A.transferFrom for utility purposes of payment artist royalties every transfer of nft



    function setRoyalties(uint _tokenId, address payable _royaltiesReceipientAddress, uint96 percentageBeep) public onlyOwner {
      LibPart.Part[] memory royalties = new LibPart.Part[](1);
        royalties[0].account = _royaltiesReceipientAddress;
        royalties[0].value = percentageBeep;
        _saveRoyalties(_tokenId, royalties);
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


    function supportsInterface(bytes4 interfaceId) public view virtual override (ERC721A) returns (bool) {
         if(interfaceId ==  LibRoyalties2981._INTERFACE_ID_ROYALTIES || interfaceId == _INTERFACE_ID_ERC2981){
            return true;
         }

        

            return super.supportsInterface(interfaceId);
         
    }


  

}