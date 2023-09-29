// import Golazos from "../contracts/utils/Golazos.cdc"

import Golazos from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator

pub fun main(address: Address): [UInt64] {
  let account = getAuthAccount(address)


  let path = Golazos.CollectionStoragePath


 var momentCollection = account.borrow<&Golazos.Collection>(from: Golazos.CollectionStoragePath)!
  if momentCollection == nil {
    panic("Get momentCollection Failed")
  }

return momentCollection.getIDs()

}
