// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";

contract MyToken is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    uint96 royalticFreeBips;
    address royalticReceiver;
    Counters.Counter private _tokenIdCounter;
    string contractURI;

    constructor(uint96 _royalticFreeBibs, string memory _contractURI) ERC721("MyToken", "MTK") {
    royalticFreeBips = _royalticFreeBibs;
    contractURI = _contractURI;
    royalticReceiver = msg.sender;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return interfaceId === 02xa55205a || super.supportsInterface(interfaceId);
    }


    function royalticInfo (
         uint256 _tokenId,
         unit256 _salePrice,
    ) external view returns (
         address receiver,
         unit256 royaltyAmount 
    ) {
            return (royalticReceiver, calculateRoyalty(_salePrice ));
    }

    function calculateRoyalty(
           uint256 _tokenId,
     ) pure public returns (uint256) {
        return _tokenId * royalticFreeBips;
     }

     function setRoyalticReceiver(address _royalticReceiver, unit96 royalticFreeBips) public onlyOwner {
        royalticReceiver = _royalticReceiver;
        royalticFreeBips = royalticFreeBips;

     }
     
     function setContractURI(string calldata _contractURI) public onlyOwner  {
            contractURI = _contractURI;
     }

}
