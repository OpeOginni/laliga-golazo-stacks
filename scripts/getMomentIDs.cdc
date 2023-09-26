import Golazos from "../contracts/official-contracts/Golazos.cdc"


pub fun main(address: Address): [UInt64] {
  let account = getAuthAccount(address)


  let path = Golazos.CollectionStoragePath


 var momentCollection = account.borrow<&Golazos.Collection>(from: Golazos.CollectionStoragePath)!
  if momentCollection == nil {
    panic("Get momentCollection Failed")
  }

return momentCollection.getIDs()

}
