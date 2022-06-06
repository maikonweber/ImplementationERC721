// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFT is ERC721 {
     address public artist;
     address public txFeeToken;
     uint public txFeeAmount;
     mapping(address => uint) public excludedList;

      constructor(
           address _artist,
           address _txFeeToken,
           uint _txFeeAmount
      ) ERC721("MyNFT", "ABC") {
           artist = _artist;
           txFeeToken = _txFeeToken;
           txFeeAmount = _txFeeAmount;
           excludedList[_artist] = true;
          _mint(artist, 0);
      }

     function setExcluded(address _excluded, bool status) public {
          require(msg.sender == artist, 'artist only');
          excludedList[_excluded] = status;
     }

     function transferFrom(
          address _from,
          address _to,
          uint256 _tokenId
     ) public override  {
         require(isApprovedOrOwner(_msgSender(), tokenId), "ERC 721: transfer caller is not approved or owner");
         if(excludedList[from] == false) {
              _payTxFee(from);
           }
         _Transfer(from, to, tokenId);
     }

     function safeTransferFrom(address from,address to, uint256 tokenId, bytes memory _data) public override {
       if(excludedList[from] == false) {
            _payTxFee(from);
         }
           _safeTransfer(from, to, tokenId, _data);

     }

     function _payTxFee(address _from) private {
          IERC20 token = IERC20(txFeeToken);
          token.transferFrom(_from, txFeeAmount);
     }



}
