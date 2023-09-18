import NonFungibleToken from 0x1d7e57aa55817448
import MetadataViews from 0x1d7e57aa55817448
import Golazos from 0x87ca73a41bb50ad5

// import FungibleToken from "../official-contracts/FungibleToken.cdc"
// import NonFungibleToken from "../official-contracts/NonFungibleToken.cdc"
// import Golazos from "../official-contracts/Golazos.cdc"


pub fun main(address: Address, tokenID: UInt64): String {
  let account = getAuthAccount(address)

  let res: {String: AnyStruct} = {}

  let path = Golazos.CollectionStoragePath


 var momentCollection = account.borrow<&Golazos.Collection>(from: Golazos.CollectionStoragePath)!
  if momentCollection == nil {
    panic("Get momentCollection Failed")
  }

  let momentNFT = momentCollection.borrowMomentNFT(id: tokenID)!
  if momentNFT == nil {
    panic("Get momentNFT Failed")
  }

  let momentTraits = momentNFT.getTraits()

  let playType = momentTraits["PlayType"]!

  return playType as! String // Force-downcasting Operator (as!) (https://developers.flow.com/cadence/language/operators#force-downcasting-operator-as)

}

// Command to execute script in Mainnet

// flow scripts execute ./scripts/getMomentMetadata.cdc 0x6b939a05bfb81e11 669445677 --network mainnet