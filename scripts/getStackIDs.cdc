import GolazosStacks from "../contracts/GolazosStacks.cdc"


pub fun main(address: Address): [UInt64]{

let acct = getAccount(address)

let golazoStacksCollection = acct.getCapability<&{GolazosStacks.StackPublic}>(GolazosStacks.GolazoStackPublicPath)

let stackIDs = golazoStacksCollection.borrow()!.getStackIDs()


  return stackIDs
}
