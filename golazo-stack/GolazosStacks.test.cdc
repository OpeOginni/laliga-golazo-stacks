import FungibleToken from "../official-contracts/FungibleToken"
import NonFungibleToken from "../official-contracts/NonFungibleToken"
import MetadataViews from "../official-contracts/MetadataViews"
import Golazos from "../official-contracts/Golazos"

access(all) contract GolazosStacks: NonFungibleToken {

    access(all) var totalStacks: UInt64

      access(all) event ContractInitialized()
      access(all) event Withdraw(id: UInt64, from: Address?)
      access(all) event Deposit(id: UInt64, to: Address?)

      pub let CollectionStoragePath: StoragePath
      pub let CollectionPublicPath: PublicPath
      pub let MinterStoragePath: StoragePath


    access(all) struct Stack {
        access(all) let price: UFix64
        access(all) let momentIDs: [UInt64]
        access(all) let stackChemistry: UInt64
        

        init(momentIDs: [UInt64], stackChemistry: UInt64) {
        assert(momentIDs.length == 5, message: "A Stack is made up of 5 moments")
        
        self.price = 0.00
        self.momentIDs = momentIDs
        self.stackChemistry = stackChemistry
    }
}

  access(all) resource StackCollection { 
    access(self) var ownerCollection: Capability<&Golazos.Collection>
    access(self) var stacks: {UInt64: Stack}
    access(self) var ownerCapability: Capability<&{FungibleToken.Receiver}>
    access(self) var beneficiaryCapability: Capability<&{FungibleToken.Receiver}>

        init (
            ownerCollection: Capability<&Golazos.Collection>,
            ownerCapability: Capability<&{FungibleToken.Receiver}>,
            beneficiaryCapability: Capability<&{FungibleToken.Receiver}>,
        ) {
            pre {
                ownerCollection.check(): "Owner's Moment Collection Capability is invalid!"
                ownerCapability.check(): "Owner's Receiver Capability is invalid!"
                beneficiaryCapability.check(): "Beneficiary's Receiver Capability is invalid!" 
            }
            self.ownerCollection = ownerCollection
            self.ownerCapability = ownerCapability
            self.beneficiaryCapability = beneficiaryCapability
            self.stacks = {}
  }

  access(all) fun createGolazostack(){
  }

  }

      init() {
        self.totalStacks = 0

    }
}
