// import GolazosStacks from "../contracts/GolazosStacks.cdc"

import GolazosStacks from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator

pub fun main(address: Address): [UInt64]{

let acct = getAccount(address)

let golazoStacksCollection = acct.getCapability<&{GolazosStacks.StackPublic}>(GolazosStacks.GolazoStackPublicPath)

let stackIDs = golazoStacksCollection.borrow()!.getStackIDs()


  return stackIDs
}
