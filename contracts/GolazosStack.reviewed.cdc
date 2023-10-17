import FungibleToken from "./utils/FungibleToken.cdc"
import NonFungibleToken from "./utils/NonFungibleToken.cdc"
import Golazos from "./utils/Golazos.cdc"
import MetadataViews from "./utils/MetadataViews.cdc"
import DapperUtilityCoin from "./utils/DapperUtilityCoin.cdc"

access(all) contract GolazosStacks {

    access(all) var totalStacks: UInt64

    access(all) event StackCreated(momentIDs: [UInt64], stackID: UInt64, address: Address?)
    access(all) event StackDestroyed(stackID: UInt64)
    access(all) event StackNameChange(stackID: UInt64, newName: String)

    access(all) let GolazoStackStoragePath: StoragePath
    access(all) let GolazoStackPublicPath: PublicPath

    access(all) struct StackMomentsAttributes {
        access(all) let momentIDs: [UInt64]
        
        access(all) let counts: {String: {String: UInt64}}

        init(
            momentIDs: [UInt64], 
        ) {
            self.momentIDs = momentIDs
            self.counts ={}
        }

        // ex attribute: "MatchHighlightedTeam"
        access(contract) fun setAttribute(attribute: String, value: String) {
            if let attributeDict: &{String: UInt64} = &self.counts[attribute] as &{String: UInt64}? {
                attributeDict[value] = (attributeDict[value] ?? 0) + 1
            } else {
                self.counts[attribute] = {value: 1}
            }
        }

        access(contract) fun getMomentStackAttribute(attribute: String): {String: UInt64}? {
            return self.counts[attribute]
        }

        // The function to Calculate the StackChemistry should be in this Struct
        access(all) fun getMomentStackChemistry(): UInt64 {

            // Initialize weights for different properties
            var countryWeight: UInt64 = 3
            var seriesWeight: UInt64 = 2
            var highlightedTeamWeight: UInt64 = 3
            var matchDateWeight: UInt64 = 5

             // Edition Chemistry Points

            var fandomEditionWeight: UInt64 = 0
            var uncommonEditionWeight: UInt64 = 1
            var rareEditionWeight: UInt64 = 1
            var legendaryEditionWeight: UInt64 = 2
            // let fandomEditionWeight: UInt64 = 0

            var chemistryScore: UInt64 = 0

            var playerCountryAttributeChemScore: UInt64 = 0
            var momentSeriesAttributeChemScore: UInt64 = 0
            var highlightedTeamAttributeChemScore: UInt64 = 0
            var matchDateAttributeChemScore: UInt64 = 0
            var momentTierAttributeChemScore: UInt64 = 0

            var momentStackAttributes: {String: AnyStruct} = self.getMomentStackAttributes()

            // Normally Moments that are alike and just have Different Series Number are not meant to be given Chemistry Points as they are not really different
            // But I left it in for now to make testing easier

            var playerCountryCount = momentStackAttributes["PlayerCountry"]! as! {String: UInt64}
            var momentSeriesCount = momentStackAttributes["seriesName"]! as! {String: UInt64} 
            var matchHighlightedTeamCount = momentStackAttributes["MatchHighlightedTeam"]! as! {String: UInt64}
            var matchDateCount = momentStackAttributes["MatchDay"]! as! {String: UInt64}
            var editionTierCount = momentStackAttributes["editionTier"]! as! {String: UInt64}

            // https://developers.flow.com/cadence/language/values-and-types#dictionary-fields-and-functions

            // PLAYER COUNTRY

            playerCountryCount.forEachKey(fun (key: String): Bool {
                let value = playerCountryCount[key]!

                if(value > 1){ // If an attribute has a value more than one means multiple moments have a particular attribute, the chemistry is calculated my multiplying the value(number of moments) by the weight
                    playerCountryAttributeChemScore = playerCountryAttributeChemScore + (value * countryWeight)
                }
                return true
            })


            // MOMENT SERIES

            momentSeriesCount.forEachKey(fun (key: String): Bool {
                let value = momentSeriesCount[key]!

                if(value > 1){ // If an attribute has a value more than one means multiple moments have a particular attribute, the chemistry is calculated my multiplying the value(number of moments) by the weight
                    momentSeriesAttributeChemScore = momentSeriesAttributeChemScore + (value * seriesWeight)
                }
                return true
            })

            // MATCH HIGHLIGTED TEAM

            matchHighlightedTeamCount.forEachKey(fun (key: String): Bool {
                let value = matchHighlightedTeamCount[key]!

                if(value > 1){ // If an attribute has a value more than one means multiple moments have a particular attribute, the chemistry is calculated my multiplying the value(number of moments) by the weight
                    highlightedTeamAttributeChemScore = highlightedTeamAttributeChemScore + (value * highlightedTeamWeight)
                }
                return true
            })


            // MATCH DATE

            matchDateCount.forEachKey(fun (key: String): Bool {
                let value = matchDateCount[key]!

                if(value > 1){ // If an attribute has a value more than one means multiple moments have a particular attribute, the chemistry is calculated my multiplying the value(number of moments) by the weight
                    matchDateAttributeChemScore = matchDateAttributeChemScore + (value * matchDateWeight)
                }
                return true
            })

        // EDITION TEIR

            editionTierCount.forEachKey(fun (key: String): Bool {

                // Depending on the Moment Tier a specified Chemistry Weight is added
                switch key {
                    case "FANDOM":
                        momentTierAttributeChemScore = momentTierAttributeChemScore + fandomEditionWeight
                    case "UNCOMMON":
                        momentTierAttributeChemScore = momentTierAttributeChemScore + uncommonEditionWeight
                    case "RARE":
                        momentTierAttributeChemScore = momentTierAttributeChemScore + rareEditionWeight
                    case "LEGENDARY":
                        momentTierAttributeChemScore = momentTierAttributeChemScore + legendaryEditionWeight
                }
                return true
            })

            chemistryScore = playerCountryAttributeChemScore + momentSeriesAttributeChemScore + highlightedTeamAttributeChemScore + matchDateAttributeChemScore

            return chemistryScore
        }


        // This function will return an Attribute and the number of Moments that has that Attribute in the Stack, Creators of Challenges can use these
        // Attributes to create Challenges that can be completed by a Stack
        access(all) fun getMomentStackAttributes(): {String: {String: UInt64}} {
            return self.counts
        }
    }

    access(all) struct MomentStack {
        access(all) var onSale: Bool
        access(all) let momentIDs: [UInt64] // I want to make this a constant at the moment, to create a new stack, you have to destroy any old stacks and create a new one
        access(all) let momentStackChemistry: UInt64
        access(all) var momentStackName: String
        access(all) let stackMomentsAttributes: StackMomentsAttributes

        init(momentIDs: [UInt64], momentStackChemistry: UInt64, momentStackName: String, stackMomentsAttributes: StackMomentsAttributes) {
            assert(momentIDs.length == 5, message: "A Stack is made up of 5 Moments")

            self.onSale = false
            self.momentIDs = momentIDs
            self.momentStackChemistry = momentStackChemistry
            self.momentStackName = momentStackName
            self.stackMomentsAttributes = stackMomentsAttributes
        }

        access(contract) fun changeStackName(newName: String) {
            self.momentStackName = newName
        }
    }

    access(all) resource interface StackPublic {
        access(all) fun getMomentStackAttributes(stackID: UInt64): {String: AnyStruct}? // Returns the details of a particular stack in the Collection using the ID
        access(all) fun getMomentDatasInMomentStack(stackID: UInt64): [&Golazos.NFT?]? // Returns the details of each Moment in a Stack
        access(all) fun getStackIDs(): [UInt64] // Returns available Stack Resource IDs in a Stack Collection
        access(all) fun getStackData(stackID: UInt64): {String: AnyStruct}?
    }
  
    access(all) resource GolazosStackCollection: StackPublic {
        access(self) var ownerCollection: Capability<&{Golazos.MomentNFTCollectionPublic}> // A reference to the Capability of the User's Golazos Collection
        access(self) let stacks: {UInt64: MomentStack} // A mapping of an Unsigned Integer to a Stack, represents the stack ID
        access(self) var ownerCapability: Capability<&{FungibleToken.Receiver}> // A Referecnce to the FungibleToken Reciever Capability to aid Transfer of tokens for Selling and Buying
        access(self) var stackedMoments: {UInt64: Bool} // A mapping of MomentIDs to a boolean, represents if a Moment is in a Stack or not

        init (
            ownerCollection: Capability<&{Golazos.MomentNFTCollectionPublic}>,
            ownerFungibleTokenReciverCapability: Capability<&{FungibleToken.Receiver}>
        ) {
            pre {
                ownerCollection.check(): "Owner's Golazos Moment Collection Capability is invalid!"
                ownerFungibleTokenReciverCapability.check(): "Owner's Receiver Capability is invalid!"
            }

                self.ownerCollection = ownerCollection
                self.ownerCapability = ownerFungibleTokenReciverCapability
                self.stacks = {}
                self.stackedMoments = {}
        }

        access(all) fun createMomentStack(momentIDs: [UInt64], momentStackName: String) {
            pre {
                momentIDs.length == 5: "A Stack is made up of 5 Moments"
            }
            /* 
            We have a lot of tests and data to obtain before creating a Stack

            1) We need to make sure the user is creating a Stack of exactly 5 Moments
            2) We need to check if the user has all the Moment's by checking the momentID's
            3) We need to get needed details from each Moment to find out what are alike to create unique Chemistry

            Needed Metadata for Chemistry Calculations 

            In file ./test/neededJson.json
            */

            // 2) User Owns The Moments
            for momentID in momentIDs {
                assert(
                    self.ownerCollection.borrow()!.borrowMomentNFT(id: momentID) != nil,
                    message: "Moment with ID ".concat(momentID.toString()).concat(" does not exist in the owner's collection")
                )
            }

            // 3) Check if Moments have already been used in a Stack
            for momentID in momentIDs {
                assert(
                    self.stackedMoments[momentID] == nil,
                    message: "Moment with ID ".concat(momentID.toString()).concat(" Is already in a Stack")
                )
            }

            // 4) Populate Stack Moment Attribute Struct

            let momentStackAttribute: StackMomentsAttributes = StackMomentsAttributes(momentIDs: momentIDs)
            
            for momentID in momentIDs {

                let momentTraits: {String: AnyStruct} = self.getMomentTraits(momentID: momentID) ?? panic("The moments traits are invalid")

                // This might look large and redundant, but I kept the this one to run checks on the moments to make sure they have the needed traits
                let matchHighlightedTeam: String = (momentTraits["MatchHighlightedTeam"] as! String?) ?? panic("Moment has missing Trait: MatchHighlightedTeam")                    
                let playerPosition: String = (momentTraits["PlayerPosition"] as! String?) ?? panic("Moment has missing Trait: PlayerPosition")
                let matchDay: String = (momentTraits["MatchDay"] as! String?) ?? panic("Moment has missing Trait: MatchDay")
                let playType: String = (momentTraits["PlayType"]as! String?) ?? panic("Moment has missing Trait: PlayType")
                let playerCountry: String = (momentTraits["PlayerCountry"]as! String?) ?? panic("Moment has missing Trait: PlayerCountry")
                let matchSeason: String = (momentTraits["MatchSeason"]as! String?) ?? panic("Moment has missing Trait: MatchSeason")
                let playHalf: String = (momentTraits["PlayHalf"]as! String?) ?? panic("Moment has missing Trait: PlayHalf")
                let matchHomeTeam: String = (momentTraits["MatchHomeTeam"]as! String?) ?? panic("Moment has missing Trait: MatchHomeTeam")
                let matchAwayTeam: String = (momentTraits["MatchAwayTeam"]as! String?) ?? panic("Moment has missing Trait: MatchAwayTeam")
                let editionTier: String = (momentTraits["editionTier"]as! String?) ?? panic("Moment has missing Trait: editionTier")
                let seriesName: String = (momentTraits["seriesName"]as! String?) ?? panic("Moment has missing Trait: seriesName")

                // This is where we populate the Stack Moment Attribute Struct (Might be done in a better way ð¤·ââï¸)
                momentStackAttribute.setAttribute(attribute: "MatchHighlightedTeam", value: matchHighlightedTeam)
                momentStackAttribute.setAttribute(attribute: "PlayerPosition", value: playerPosition)
                momentStackAttribute.setAttribute(attribute: "MatchDay", value: matchDay)
                momentStackAttribute.setAttribute(attribute: "PlayType", value: playType)
                momentStackAttribute.setAttribute(attribute: "PlayerCountry", value: playerCountry)
                momentStackAttribute.setAttribute(attribute: "MatchSeason", value: matchSeason)
                momentStackAttribute.setAttribute(attribute: "PlayHalf", value: playHalf)
                momentStackAttribute.setAttribute(attribute: "MatchHomeTeam", value: matchHomeTeam)
                momentStackAttribute.setAttribute(attribute: "MatchAwayTeam", value: matchAwayTeam)
                momentStackAttribute.setAttribute(attribute: "editionTier", value: editionTier)
                momentStackAttribute.setAttribute(attribute: "seriesName", value: seriesName)

                // Add MomentIDs to the Stacked Moments Mapping
                self.stackedMoments[momentID] = true
            }
            
            // 4) Create the Stack Struct
            let momentStack: MomentStack = MomentStack(
                momentIDs: momentIDs,
                momentStackChemistry: momentStackAttribute.getMomentStackChemistry(), // We can get this from the moment attribute function
                momentStackName: momentStackName,
                stackMomentsAttributes: momentStackAttribute
            )

            self.stacks[GolazosStacks.totalStacks] = momentStack

            // EMIT Stack Creation Event
            emit StackCreated(momentIDs: momentIDs, stackID: GolazosStacks.totalStacks, address: self.owner?.address)

            GolazosStacks.totalStacks = GolazosStacks.totalStacks + 1
        }

        // This function will destroy a stack 
        access(all) fun destroyStack(stackID: UInt64) {

            if self.stacks[stackID] == nil {
                return
            }

            // Delete Stack
            self.stacks.remove(key: stackID)

            // EMIT Stack Destruction Event
            emit StackDestroyed(stackID: stackID)
        }

        // This function will change stack name
        access(all) fun changeStackName(stackID: UInt64, newName: String) {
            if let stack = &self.stacks[stackID] as &MomentStack? {
                stack.changeStackName(newName: newName)
                emit StackNameChange(stackID: stackID, newName: newName)
            }
        }

        /// purchase lets a user send tokens to purchase a Bundle that is for sale
        /// the purchased Bundle is returned to the transaction context that called it

        // Purchase Functionality Put on Hold (As it isn't a core needed functionality)

        access(all) fun changeOwnerReceiver(_ newOwnerCapability: Capability<&{FungibleToken.Receiver}>) {
            pre {
                newOwnerCapability.check(): "Owner's Receiver Capability is invalid!"
            }
            self.ownerCapability = newOwnerCapability
        }

        // This function will check if a Stack is still Valid, it will be used to check if a Stack is still Valid before it is listed for Sale or Purchased
        access(all) fun checkStackValidity(stackID: UInt64): Bool {
            if let stack = &self.stacks[stackID] as &MomentStack? {
                let momentIDs: [UInt64] = stack.momentIDs
                // If the Stack Exisits it Check if all the moments in the Stack are still present in the Collection
                for momentID in momentIDs {
                    if self.ownerCollection.borrow()!.borrowMomentNFT(id: momentID) != nil {
                        return false
                    }
                }

                // If they all pass it means the Stack is still Valid
                return true
            }

            return false
        }

        // These are UTIL functions that can be used to check if a Stack Passes a Challenge or not
        access(all) fun getMomentTraits(momentID: UInt64): {String: AnyStruct}? {
            let momentNFT = self.ownerCollection.borrow()!.borrowMomentNFT(id: momentID)
            return momentNFT?.getTraits()
        }

        /// This function will be used to check if a Stack Reaches the Requirements of a Challenge, by returning its Attributes 
        /// Attributes Include, a value and how many Moments have that Value
        access(all) fun getMomentStackAttributes(stackID: UInt64): {String: AnyStruct}? {
            let momentStack = self.stacks[stackID]?.stackMomentsAttributes

            return momentStack?.getMomentStackAttributes()
        }

        /// This function will be used to check the data of a stack, it will be used to display the details of a stack to a user
        access(all) fun getStackData(stackID: UInt64): {String: AnyStruct}? {
            if let stack = self.stacks[stackID] {
                let stackData: {String: AnyStruct} = {
                    "onSale": stack.onSale,
                    "momentIDs": stack.momentIDs,
                    "stackChemistry": stack.momentStackChemistry,
                    "stackName": stack.momentStackName
                }

                return stackData
            }
            return nil
        }

        access(all) fun getMomentDatasInMomentStack(stackID: UInt64): [&Golazos.NFT?]? {
            if let stackData: {String: AnyStruct} = self.getStackData(stackID: stackID) {
                let answer: [&Golazos.NFT?] = []
                let momentIDs = stackData["momentIDs"]! as! [UInt64]
                for momentID in momentIDs {
                    let ref: &Golazos.NFT? = self.ownerCollection.borrow()!.borrowMomentNFT(id: momentID)
                    answer.append(ref)
                }
                return answer
            }
            return nil
        }

        /// getIDs returns an array of Stack IDs in the Collection
        access(all) fun getStackIDs(): [UInt64] {
            return self.stacks.keys
        }

    }

    /// createCollection returns a new collection resource to the caller

    access(all) fun createGolazoStackCollection(
        ownerCollection: Capability<&{Golazos.MomentNFTCollectionPublic}>,                    
        ownerFungibleTokenReciverCapability: Capability<&{FungibleToken.Receiver}> 
    ): @GolazosStackCollection {
        return <- create GolazosStackCollection(ownerCollection: ownerCollection, ownerFungibleTokenReciverCapability: ownerFungibleTokenReciverCapability)
    }

      init() {
        self.totalStacks = 0
        self.GolazoStackStoragePath = /storage/GolazoStackCollection
        self.GolazoStackPublicPath = /public/GolazoStackCollection
      }
} 