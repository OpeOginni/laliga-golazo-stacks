import FungibleToken from 0x01
import NonFungibleToken from 0x01
import MetadataViews from 0x01
import Golazos from 0x01

access(all) contract GolazosStacks {

  access(all) var totalStacks: UInt64
  
    access(all) struct StackMomentsAttributes {
    // These attributes will be used to determine how closely alike Moments in a Stack are
    // These attributes are also the main feature that makes Challenges with Stacks possible EG, A Challenge to create a Stack of Moments with Only Goals with a particular Match Day occuring 3 times,
    // OR Moments when a particular HomeTeam is Higlighted, these attributes can be used to check if the Challenge Requirements are met by the Stack

        access(all) let momentIDs: [UInt64]
        access(all) let matchHighlightedTeamCount: {String: Int}
        access(all) let playerPositionCount: {String: Int}
        access(all) let matchDayCount: {String: Int}
        access(all) let playTypeCount: {String: Int}
        access(all) let playerCountryCount: {String: Int}
        access(all) let matchSeasonCount: {String: Int}
        access(all) let playHalfCount: {String: Int}
        access(all) let matchHomeTeamCount: {String: Int}
        access(all) let matchAwayTeamCount: {String: Int}

        init(
          momentIDs: [UInt64], 
          matchHighlightedTeamCount: {String: Int}, 
          playerPositionCount: {String: Int}, 
          matchDayCount: {String: Int}, 
          playTypeCount: {String: Int},
          playerCountryCount: {String: Int},
          matchSeasonCount: {String: Int},
          playHalfCount: {String: Int},
          matchHomeTeamCount: {String: Int},
          matchAwayTeamCount: {String: Int}
             ) {
              self.momentIDs = momentIDs
              self.matchHighlightedTeamCount = matchHighlightedTeamCount
              self.playerPositionCount = playerPositionCount
              self.matchDayCount = matchDayCount
              self.playTypeCount = playTypeCount
              self.playerCountryCount = playerCountryCount
              self.matchSeasonCount = matchSeasonCount
              self.playHalfCount = playHalfCount
              self.matchHomeTeamCount = matchHomeTeamCount
              self.matchAwayTeamCount = matchAwayTeamCount
    }

    access(all) struct MomentStack {
        access(all) let price: UFix64
        access(all) let onSale: Bool
        access(all) let momentIDs: [UInt64]
        access(all) let momentStackChemistry: UFix64
        access(all) let momentStackName: String
        access(all) let stackMomentsAttributes: StackMomentsAttributes

        init(price: UFix64, momentIDs: [UInt64], momentStackChemistry: UFix64, momentStackName: String, stackMomentsAttributes: StackMomentsAttributes) {
            assert(momentIDs.length == 5, message: "A Stack is made up of 5 Moments")

            self.price = price
            self.onSale = false
            self.momentIDs = momentIDs
            self.momentStackChemistry = momentStackChemistry
            self.momentStackName = momentStackName
            self.stackMomentsAttributes = stackMomentsAttributes
        }
    }

    access(all) resource interface StackPublic {
        // pub fun purchase(bundleID: UInt64, buyTokens: @DapperUtilityCoin.Vault): @[TopShot.NFT]
        pub fun getMomentStackData(stackID: UInt64): MomentStack? // Returns the details of a particular stack in the Collection using the ID
        pub fun getMomentDatasInMomentStack(stackID: UInt64): [&Golazos.NFT?]? // Returns the details of each Moment in a Stack
        pub fun getIDs(): [UInt64] // Returns available Stack Resource IDs in a Stack Collection
    }
  
  access(all) resource GolazosStackCollection: StackPublic {
    access(self) var ownerCollection: Capability<&Golazos.Collection> // A reference to the Capability of the User's Golazos Collection
    access(self) var stacks: {UInt64: MomentStack} // A mapping of an Unsigned Integer to a Stack, represents the stack ID
    access(self) var ownerCapability: Capability<&{FungibleToken.Receiver}> // A Referecnce to the FungibleToken Reciever Capability to aid Transfer of tokens for Selling and Buying

  init (
      ownerCollection: Capability<&Golazos.Collection>,
      ownerCapability: Capability<&{FungibleToken.Receiver}>
  ) {
      pre {
        ownerCollection.check(): "Owner's Golazos Moment Collection Capability is invalid!"
        ownerCapability.check(): "Owner's Receiver Capability is invalid!"
      }

      self.ownerCollection = ownerCollection
      self.ownerCapability = ownerCapability
      self.stacks = {}

  }
    access(self) fun getMomentTraits(momentID: UInt64): {String: AnyStruct} {
    // This is an internal contract function that lets the contract get the Details/Traits for each moment

    let momentNFT = self.ownerCollection.borrow()!.borrowMomentNFT(id: momentID) ?? panic("Moment with ID ".concat(momentID.toString()).concat(" does not exist in the owner's collection"))

    return momentNFT.getTraits()
    }

    access(all) fun createMomentStack(momentIDs: [UInt64], momentStackName: String) {
     /* 
     We have a lot of tests and data to obtain before creating a Stack

     1) We need to make sure the user is creating a Stack of exactly 5 Moments
     2) We need to check if the user has all the Moment's by checking the momentID's
     3) We need to get needed details from each Moment to find out what are alike to create unique Chemistry

     Needed Metadata for Chemistry Calculations 

     - MatchDay
     - PlayType
     - 
     */

     // 1) Exactly 5 Moments 
    
      assert(momentIDs.length == 5, message: "A Stack is made up of 5 Moments")

    // 2) User Owns The Moments
      for momentID in momentIDs {
        assert(
          self.ownerCollection.borrow()!.borrowMomentNFT(id: momentID) != nil,
          message: "Moment with ID ".concat(momentID.toString()).concat(" does not exist in the owner's collection")
        )
      }
    // 3) User Owns The Moments
    
 

}

      }

    /// createCollection returns a new collection resource to the caller

    access(all) fun createGolazosStackCollection()

    } 

      init() {
        self.totalStacks = 0

      }
}