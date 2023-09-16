import NonFungibleToken from 0x1d7e57aa55817448
import MetadataViews from 0x1d7e57aa55817448
import Golazos from 0x87ca73a41bb50ad5


pub fun main(address: Address, tokenID: UInt64): AnyStruct {
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

  return momentTraits["PlayType"]!

}