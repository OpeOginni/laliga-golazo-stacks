import Golazos from "../contracts/official-contracts/Golazos.cdc"


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