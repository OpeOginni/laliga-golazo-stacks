import FungibleToken from "../official-contracts/FungibleToken.cdc"
import NonFungibleToken from "../official-contracts/NonFungibleToken.cdc"
import Golazos from "../official-contracts/Golazos.cdc"
import MetadataViews from  "../official-contracts/MetadataViews.cdc"

access(all) contract GolazosStacks {

    access(all) var totalStacks: UInt64
  
    access(all) struct StackMomentsAttributes {
    // These attributes will be used to determine how closely alike Moments in a Stack are
    // These attributes are also the main feature that makes Challenges with Stacks possible EG, A Challenge to create a Stack of Moments with Only Goals with a particular Match Day occuring 3 times,
    // OR Moments when a particular HomeTeam is Higlighted, these attributes can be used to check if the Challenge Requirements are met by the Stack

        access(all) let momentIDs: [UInt64]
        access(all) let matchHighlightedTeamCount: {String: UInt64}
        access(all) let playerPositionCount: {String: UInt64}
        access(all) let matchDayCount: {String: UInt64}
        access(all) let playTypeCount: {String: UInt64}
        access(all) let playerCountryCount: {String: UInt64}
        access(all) let matchSeasonCount: {String: UInt64}
        access(all) let playHalfCount: {String: UInt64}
        access(all) let matchHomeTeamCount: {String: UInt64}
        access(all) let matchAwayTeamCount: {String: UInt64}
        access(all) let editionTierCount: {String: UInt64}
        access(all) let seriesNameCount: {String: UInt64}

        init(
            momentIDs: [UInt64], 
            matchHighlightedTeamCount: {String: UInt64}, 
            playerPositionCount: {String: UInt64}, 
            matchDayCount: {String: UInt64}, 
            playTypeCount: {String: UInt64},
            playerCountryCount: {String: UInt64},
            matchSeasonCount: {String: UInt64},
            playHalfCount: {String: UInt64},
            matchHomeTeamCount: {String: UInt64},
            matchAwayTeamCount: {String: UInt64},
            editionTierCount: {String: UInt64},
            seriesNameCount: {String: UInt64}
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
              self.editionTierCount = editionTierCount
              self.seriesNameCount = seriesNameCount
            }

        access(contract) fun setAttribute(attribute: String, value: String) {

            // Using the Ternary Conditional Operator (https://developers.flow.com/cadence/language/operators#ternary-conditional-operator)
            switch attribute {
                case "MatchHighlightedTeam":
                    // If the mapping doesnt exist (nill), give it a value of 1, else if it already exsits increment the value by 1
                    self.matchHighlightedTeamCount[value] = self.matchHighlightedTeamCount[value] == nil ? 1 : self.matchHighlightedTeamCount[value]! + 1
                case "PlayerPosition":
                    self.playerPositionCount[value] = self.playerPositionCount[value] == nil ? 1 : self.playerPositionCount[value]! + 1
                case "MatchDay":
                    self.matchDayCount[value] = self.matchDayCount[value] == nil ? 1 : self.matchDayCount[value]! + 1
                case "PlayType":
                    self.playTypeCount[value] = self.playTypeCount[value] == nil ? 1 : self.playTypeCount[value]! + 1
                case "PlayerCountry":
                    self.playerCountryCount[value] = self.playerCountryCount[value] == nil ? 1 : self.playerCountryCount[value]! + 1
                case "MatchSeason":
                    self.matchSeasonCount[value] = self.matchSeasonCount[value] == nil ? 1 : self.matchSeasonCount[value]! + 1
                case "PlayHalf":
                    self.playHalfCount[value] = self.playHalfCount[value] == nil ? 1 : self.playHalfCount[value]! + 1
                case "MatchHomeTeam":
                    self.matchHomeTeamCount[value] = self.matchHomeTeamCount[value] == nil ? 1 : self.matchHomeTeamCount[value]! + 1
                case "MatchAwayTeam":
                    self.matchAwayTeamCount[value] = self.matchAwayTeamCount[value] == nil ? 1 : self.matchAwayTeamCount[value]! + 1
                case "editionTier":
                    self.editionTierCount[value] = self.editionTierCount[value] == nil ? 1 : self.editionTierCount[value]! + 1
                case "seriesName":
                    self.seriesNameCount[value] = self.seriesNameCount[value] == nil ? 1 : self.seriesNameCount[value]! + 1
            }
        }

        // The function to Calculate the StackChemistry should be in this Struct
        access(all) fun getMomentStackChemistry(): UFix64 {
            return 1.00
        }

        // The function to Calculate the StackStrength should be in this Struct
        access(all) fun getMomentStackStrength(): UFix64 {
            return 1.00
        }
    }

    access(all) struct MomentStack {
        access(all) var price: UFix64
        access(all) var onSale: Bool
        access(all) let momentIDs: [UInt64] // I want to make this a constant at the moment, to create a new stack, you have to destroy any old stacks and create a new one
        access(all) let momentStackChemistry: UFix64
        access(all) var momentStackName: String
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

        access(all) fun changeStackName(newName: String) {
            self.momentStackName = newName
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
            // 3) Populate Stack Moment Attribute Struct

                let momentStackAttribute: StackMomentsAttributes = StackMomentsAttributes(
                    momentIDs: momentIDs,
                    matchHighlightedTeamCount: {},
                    playerPositionCount: {},
                    matchDayCount: {},
                    playTypeCount: {},
                    playerCountryCount: {},
                    matchSeasonCount: {},
                    playHalfCount: {},
                    matchHomeTeamCount: {},
                    matchAwayTeamCount: {},
                    editionTierCount: {},
                    seriesNameCount: {}
                )
                
                for momentID in momentIDs {

                    let momentTraits: {String: AnyStruct} = self.getMomentTraits(momentID: momentID)

                    // This might look large and redundant, but I kept the this one to run checks on the moments to make sure they have the needed traits
                    let matchHighlightedTeam: AnyStruct = momentTraits["MatchHighlightedTeam"] ?? panic("Moment has missing Trait: MatchHighlightedTeam")
                    let playerPosition: AnyStruct = momentTraits["PlayerPosition"] ?? panic("Moment has missing Trait: PlayerPosition")
                    let matchDay: AnyStruct = momentTraits["MatchDay"] ?? panic("Moment has missing Trait: MatchDay")
                    let playType: AnyStruct = momentTraits["PlayType"] ?? panic("Moment has missing Trait: PlayType")
                    let playerCountry: AnyStruct = momentTraits["PlayerCountry"] ?? panic("Moment has missing Trait: PlayerCountry")
                    let matchSeason: AnyStruct = momentTraits["MatchSeason"] ?? panic("Moment has missing Trait: MatchSeason")
                    let playHalf: AnyStruct = momentTraits["PlayHalf"] ?? panic("Moment has missing Trait: PlayHalf")
                    let matchHomeTeam: AnyStruct = momentTraits["MatchHomeTeam"] ?? panic("Moment has missing Trait: MatchHomeTeam")
                    let matchAwayTeam: AnyStruct = momentTraits["MatchAwayTeam"] ?? panic("Moment has missing Trait: MatchAwayTeam")
                    let editionTier: AnyStruct = momentTraits["editionTier"] ?? panic("Moment has missing Trait: editionTier")
                    let seriesName: AnyStruct = momentTraits["seriesName"] ?? panic("Moment has missing Trait: seriesName")

                    // While this is changing the traits to string seperately
                    let matchHighlightedTeamString: String = matchHighlightedTeam as! String
                    let playerPositionString: String = playerPosition as! String
                    let matchDayString: String = matchDay as! String
                    let playTypeString: String = playType as! String
                    let playerCountryString: String = playerCountry as! String
                    let matchSeasonString: String = matchSeason as! String
                    let playHalfString: String = playHalf as! String
                    let matchHomeTeamString: String = matchHomeTeam as! String
                    let matchAwayTeamString: String = matchAwayTeam as! String
                    let editionTierString: String = matchHighlightedTeam as! String
                    let seriesNameString: String = matchHighlightedTeam as! String

                    // Large issue as what is being returned is a String But as AnyStruct

                    // After searching through the Docs found this (https://developers.flow.com/cadence/language/operators#conditional-downcasting-operator-as)
                    // A way to givee the ORIGINAL type back to a variable with AnyStruct
                    // It can either be done Conditionaly (as?) or Forcefully (as!)
                    // Im sure of returning a string so I will be opting for Forcecefull asting


                    // This is where we populate the Stack Moment Attribute Struct (Might be done in a better way 🤷‍♂️)
                    momentStackAttribute.setAttribute(attribute: "MatchHighlightedTeam", value: matchHighlightedTeamString)
                    momentStackAttribute.setAttribute(attribute: "PlayerPosition", value: playerPositionString)
                    momentStackAttribute.setAttribute(attribute: "MatchDay", value: matchDayString)
                    momentStackAttribute.setAttribute(attribute: "PlayType", value: playTypeString)
                    momentStackAttribute.setAttribute(attribute: "PlayerCountry", value: playerCountryString)
                    momentStackAttribute.setAttribute(attribute: "MatchSeason", value: matchSeasonString)
                    momentStackAttribute.setAttribute(attribute: "PlayHalf", value: playHalfString)
                    momentStackAttribute.setAttribute(attribute: "MatchHomeTeam", value: matchHomeTeamString)
                    momentStackAttribute.setAttribute(attribute: "MatchAwayTeam", value: matchAwayTeamString)
                    momentStackAttribute.setAttribute(attribute: "editionTier", value: editionTierString)
                    momentStackAttribute.setAttribute(attribute: "seriesName", value: seriesNameString)
                }
            
            // 4) Create the Stack Struct
            let momentStack: MomentStack = MomentStack(
                price: 0.00, // Price will be Zero as the stack is JUST being created
                momentIDs: momentIDs,
                momentStackChemistry: momentStackAttribute.getMomentStackChemistry(), // We can get this from the moment attribute function
                momentStackName: momentStackName,
                stackMomentsAttributes: momentStackAttribute
            )
        }

    }

    /// createCollection returns a new collection resource to the caller

    // access(all) fun createGolazosStackCollection(){
    //     let newCollection <- create GolazosStackCollection(
    //         ownerCollection: self.account.save(<-Golazos.createEmptyCollection()), 
    //         ownerCapability: self.account.link<&{FungibleToken.Receiver}>(
    //             /public/GolazosReceiver, 
    //             target: /storage/GolazosReceiver
    //         )!
    //     )

    //     self.account.save(<-newCollection, to: /storage/GolazosStackCollection)
    // }

      init() {
        self.totalStacks = 0
      }
    } 
