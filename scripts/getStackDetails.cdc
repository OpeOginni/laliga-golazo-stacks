import GolazosStacks from "../contracts/GolazosStacks.cdc"


pub fun main(address: Address, stackID: UInt64): {String: AnyStruct}{

let acct = getAccount(address)

let golazoStacksCollection = acct.getCapability<&{GolazosStacks.StackPublic}>(GolazosStacks.GolazoStackPublicPath)

let stack = golazoStacksCollection.borrow()!.getStackData(stackID: stackID)  ?? panic("Collection does not have a stack with that ID")

  return stack
}
