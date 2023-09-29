import FungibleToken from "./utils/FungibleToken.cdc"
import NonFungibleToken from "./utils/NonFungibleToken.cdc"
import Golazos from "./utils/Golazos.cdc"
import MetadataViews from  "./utils/MetadataViews.cdc"
import DapperUtilityCoin from "./utils/DapperUtilityCoins.cdc"

access(all) contract GolazosStacks {

    access(all) var totalStacks: UInt64

    access(all) event StackCreated(momentIDs: [UInt64], stackID: UInt64, address: Address?)
    access(all) event StackListed(stackID: UInt64, price: UFix64, seller: Address?)
    // access(all) event StackPurchased(stackID: UInt64, price: UFix64, seller: Address?)
    // access(all) event StackTransfered(stackID: UInt64, from: Address?, to: Address?)
    access(all) event StackDestroyed(stackID: UInt64)

    access(all) let GolazoStackStoragePath: StoragePath
    access(all) let GolazoStackPublicPath: PublicPath


  
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
            ) {
              self.momentIDs = momentIDs
              self.matchHighlightedTeamCount = {}
              self.playerPositionCount = {}
              self.matchDayCount = {}
              self.playTypeCount = {}
              self.playerCountryCount = {}
              self.matchSeasonCount = {}
              self.playHalfCount = {}
              self.matchHomeTeamCount = {}
              self.matchAwayTeamCount = {}
              self.editionTierCount = {}
              self.seriesNameCount = {}
            }

        access(contract) fun setAttribute(attribute: String, value: String) {

            // Using the Ternary Conditional Operator (https://developers.flow.com/cadence/language/operators#ternary-conditional-operator)
            switch attribute {
                case "MatchHighlightedTeam":
                    // If the mapping doesnt exist (nill), give it a value of 1, else if it already exsits increment the value by 1
                    self.matchHighlightedTeamCount[value] = (self.matchHighlightedTeamCount[value] ?? 0) + 1
                case "PlayerPosition":
                    self.playerPositionCount[value] = (self.playerPositionCount[value] ?? 0) + 1
                case "MatchDay":
                    self.matchDayCount[value] = (self.matchDayCount[value] ?? 0) + 1
                case "PlayType":
                    self.playTypeCount[value] = (self.playTypeCount[value] ?? 0) + 1
                case "PlayerCountry":
                    self.playerCountryCount[value] = (self.playerCountryCount[value] ?? 0) + 1
                case "MatchSeason":
                    self.matchSeasonCount[value] = (self.matchSeasonCount[value] ?? 0) + 1
                case "PlayHalf":
                    self.playHalfCount[value] = (self.playHalfCount[value] ?? 0) + 1
                case "MatchHomeTeam":
                    self.matchHomeTeamCount[value] = (self.matchHomeTeamCount[value] ?? 0) + 1
                case "MatchAwayTeam":
                    self.matchAwayTeamCount[value] = (self.matchAwayTeamCount[value] ?? 0) + 1
                case "editionTier":
                    self.editionTierCount[value] = (self.editionTierCount[value] ?? 0) + 1
                case "seriesName":
                    self.seriesNameCount[value] = (self.seriesNameCount[value] ?? 0) + 1
            }
        }

        access(contract) fun getMomentStackAttribute(attribute: String): {String: UInt64}{

            var attributeResult:{String: UInt64} = {}
            switch attribute {
                case "MatchHighlightedTeam":
                    attributeResult = self.matchHighlightedTeamCount
                case "PlayerPosition":
                    attributeResult = self.playerPositionCount
                case "MatchDay":
                    attributeResult = self.matchDayCount
                case "PlayType":
                    attributeResult = self.playTypeCount
                case "PlayerCountry":
                    attributeResult = self.playerCountryCount
                case "MatchSeason":
                    attributeResult = self.matchSeasonCount
                case "PlayHalf":
                    attributeResult = self.playHalfCount
                case "MatchHomeTeam":
                    attributeResult = self.matchHomeTeamCount
                case "MatchAwayTeam":
                    attributeResult = self.matchAwayTeamCount
                case "editionTier":
                    attributeResult = self.editionTierCount
                case "seriesName":
                    attributeResult = self.seriesNameCount
            }

            return attributeResult

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

            var momentStackAttributes = self.getMomentStackAttributes()

            log(momentStackAttributes)

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
        access(all) fun getMomentStackAttributes(): {String: AnyStruct}{
            return {
                "MatchHighlightedTeam": self.matchHighlightedTeamCount,
                "PlayerPosition": self.playerPositionCount,
                "MatchDay": self.matchDayCount,
                "PlayType": self.playTypeCount,
                "PlayerCountry": self.playerCountryCount,
                "MatchSeason": self.matchSeasonCount,
                "PlayHalf": self.playHalfCount,
                "MatchHomeTeam": self.matchHomeTeamCount,
                "MatchAwayTeam": self.matchAwayTeamCount,
                "editionTier": self.editionTierCount,
                "seriesName": self.seriesNameCount
            }
        }
    }

    access(all) struct MomentStack {
        access(all) var price: UFix64
        access(all) var onSale: Bool
        access(all) let momentIDs: [UInt64] // I want to make this a constant at the moment, to create a new stack, you have to destroy any old stacks and create a new one
        access(all) let momentStackChemistry: UInt64
        access(all) var momentStackName: String
        access(all) let stackMomentsAttributes: StackMomentsAttributes

        init(price: UFix64, momentIDs: [UInt64], momentStackChemistry: UInt64, momentStackName: String, stackMomentsAttributes: StackMomentsAttributes) {
            assert(momentIDs.length == 5, message: "A Stack is made up of 5 Moments")

            self.price = price
            self.onSale = false
            self.momentIDs = momentIDs
            self.momentStackChemistry = momentStackChemistry
            self.momentStackName = momentStackName
            self.stackMomentsAttributes = stackMomentsAttributes
        }

        access(contract) fun changeStackName(newName: String) {
            self.momentStackName = newName
        }

        access(contract) fun placeStackForSale(price: UFix64) {
            self.onSale = true
            self.price = price
        }

        access(contract) fun cancleStackSale() {
            self.onSale = false
            self.price = 0.00
        }

        access(contract) fun ChangeSalePrice(price: UFix64) {
            self.price = price
        }
    }

    access(all) resource interface StackPublic {
        // access(all) fun purchase(stackID: UInt64, buyTokens: @DapperUtilityCoin.Vault, buyerStacksCollection: Capability<&GolazosStacks.GolazosStackCollection>, keepStack: Bool): @[Golazos.NFT]
        access(all) fun addMomentStack(momentStack: MomentStack, stackID: UInt64)
        access(all) fun getMomentStackAttributes(stackID: UInt64): {String: AnyStruct} // Returns the details of a particular stack in the Collection using the ID
        access(all) fun getMomentDatasInMomentStack(stackID: UInt64): [&Golazos.NFT?]? // Returns the details of each Moment in a Stack
        access(all) fun getStackIDs(): [UInt64] // Returns available Stack Resource IDs in a Stack Collection
        access(all) fun getStackData(stackID: UInt64): {String: AnyStruct}?
    }
  
    access(all) resource GolazosStackCollection: StackPublic {
        access(self) var ownerCollection: Capability<&{Golazos.MomentNFTCollectionPublic}> // A reference to the Capability of the User's Golazos Collection
        access(self) var stacks: {UInt64: MomentStack} // A mapping of an Unsigned Integer to a Stack, represents the stack ID
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

        access(all) fun addMomentStack(momentStack: MomentStack, stackID: UInt64){
            // This function will be used to send a stack from one user to another user, without having to dismantle the stack, if a user wants the moments to be transfered with the stack too

            // Only add the Stack IF all the Moments in the Stack are in the Collection
            // This function is meant to be called AFTER a successful transfer of all moments in the stack

            for momentID in momentStack.momentIDs {
                if(self.ownerCollection.borrow()!.borrowMomentNFT(id: momentID) == nil){
                    return
                }
            }

            // If a Stack is Just being moved it should retain its ID
            self.stacks[stackID] = momentStack
        }

        access(all) fun createMomentStack(momentIDs: [UInt64], momentStackName: String) {
            /* 
            We have a lot of tests and data to obtain before creating a Stack

            1) We need to make sure the user is creating a Stack of exactly 5 Moments
            2) We need to check if the user has all the Moment's by checking the momentID's
            3) We need to get needed details from each Moment to find out what are alike to create unique Chemistry

            Needed Metadata for Chemistry Calculations 

            In file ./test/neededJson.json
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

                    let momentTraits: {String: AnyStruct} = self.getMomentTraits(momentID: momentID)

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

                    // Large issue as what is being returned is a String But as AnyStruct

                    // After searching through the Docs found this (https://developers.flow.com/cadence/language/operators#conditional-downcasting-operator-as)
                    // A way to givee the ORIGINAL type back to a variable with AnyStruct
                    // It can either be done Conditionaly (as?) or Forcefully (as!)
                    // Im sure of returning a string so I will be opting for Forcecefull asting


                    // This is where we populate the Stack Moment Attribute Struct (Might be done in a better way 🤷‍♂️)
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
                price: 0.00, // Price will be Zero as the stack is JUST being created
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

        access(all) fun destroyStack(stackID: UInt64) {
            // This function will destroy a stack 

            if(self.stacks[stackID] != nil){
                return
            }

            // Delete Stack
            self.stacks.remove(key: stackID)

            // EMIT Stack Destruction Event
            emit StackDestroyed(stackID: stackID)
        }

        access(all) fun changeStackName(stackID: UInt64, newName: String) {
            // This function will destroy a stack 

            if(self.stacks[stackID] != nil){
                return
            }

            let stack = self.stacks[stackID]!

            // change stack name
            stack.changeStackName(newName: newName)
        }

        access(all) fun listForSale(stackID: UInt64, price: UFix64) {
            // make sure the user has all Moments in the stack using the `checkStackValidity` function
            if(!self.checkStackValidity(stackID: stackID)){
                // If the Stack is not Valid, we Destroy it and Return (This means the user has a missing Moment and the stack is invalid)
                self.destroyStack(stackID: stackID)
                return
            }

            // Set the listing
            self.stacks[stackID]?.placeStackForSale(price: price)

            // EMIT Stack Listed Event
            emit StackListed(stackID: stackID, price: price, seller: self.owner?.address)
        }

        /// purchase lets a user send tokens to purchase a Bundle that is for sale
        /// the purchased Bundle is returned to the transaction context that called it

        // Purchase Functionality Put on Hold (As it isn't a core needed functionality)
/*
        access(all) fun purchase(stackID: UInt64, buyTokens: @DapperUtilityCoin.Vault, buyerStacksCollection: Capability<&GolazosStacks.GolazosStackCollection>, keepStack: Bool): @[Golazos.NFT] {
            pre {
                self.stacks[stackID] == nil: "No bundle matching this ID for sale!"
                buyerStacksCollection.check(): "Buyer's Golazos Stack Collection Capability is invalid!"
            }

            let momentStack: GolazosStacks.MomentStack = self.stacks[stackID]!

            assert(
                momentStack.onSale == true,
                message: "Moment is not For Sale!"
            )
    
            assert(
                buyTokens.balance == momentStack.price,
                message: "Not enough tokens to buy the Bundle!"
            )
            
            // Deposit the remaining tokens into the owners vault
            self.ownerCapability.borrow()!.deposit(from: <-buyTokens)

            // Return the purchased Stack
            let moments: @[Golazos.NFT] <- []

            for id in momentStack.momentIDs {
                moments.append(<- (self.ownerCollection.borrow()!.withdraw(withdrawID: id) as! @Golazos.NFT))
            }

            // remove the StackID from te contract

            // If the buyer wants to purcahse the stack too, the ID will be put back in the `addMomentStack` function
            self.stacks.remove(key: stackID)

            if(keepStack == true){
            // add the Stack to the Buyer's Collection
            let buyerStacksCollectionRef = buyerStacksCollection.borrow()!
            buyerStacksCollectionRef.addMomentStack(momentStack: momentStack, stackID: stackID)

            // EMIT stack Transfered Event
            emit StackTransfered(stackID: stackID, from: self.owner?.address, to: buyerStacksCollectionRef.owner?.address)
            }

            // EMIT stack Purchase Event
            emit StackPurchased(stackID: stackID, price: momentStack.price, seller: self.owner?.address)

            return <- moments
        }

*/
        access(all) fun changeOwnerReceiver(_ newOwnerCapability: Capability<&{FungibleToken.Receiver}>) {
            pre {
                newOwnerCapability.borrow() != nil: 
                    "Owner's Receiver Capability is invalid!"
            }
            self.ownerCapability = newOwnerCapability
        }


        access(contract) fun checkStackValidity(stackID: UInt64): Bool{
            // This function will check if a Stack is still Valid, it will be used to check if a Stack is still Valid before it is listed for Sale or Purchased
            let stack = self.stacks[stackID]

            // Check if Stack Exsists in the Collection
            if(stack == nil){
                return false
            }

            let momentIDs: [UInt64] = stack!.momentIDs

            // If the Stack Exisits it Check if all the moments in the Stack are still present in the Collection
            for momentID in momentIDs {
                if(self.ownerCollection.borrow()!.borrowMomentNFT(id: momentID) != nil){
                    return false
                }
            }

            // If they all pass it means the Stack is still Valid
            return true
        }

        // These are UTIL functions that can be used to check if a Stack Passes a Challenge or not

        access(self) fun getMomentTraits(momentID: UInt64): {String: AnyStruct} {
        // This is an internal contract function that lets the contract get the Details/Traits for each moment

            let momentNFT = self.ownerCollection.borrow()!.borrowMomentNFT(id: momentID) ?? panic("Moment with ID ".concat(momentID.toString()).concat(" does not exist in the owner's collection"))

            return momentNFT.getTraits()
        }

        /// This function will be used to check if a Stack Reaches the Requirements of a Challenge, by returning its Attributes 
        /// Attributes Include, a value and how many Moments have that Value
        access(all) fun getMomentStackAttributes(stackID: UInt64): {String: AnyStruct} {
            let momentStack = self.stacks[stackID]?.stackMomentsAttributes ?? panic("Stack with ID ".concat(stackID.toString()).concat(" does not exist in the collection"))

            return momentStack.getMomentStackAttributes()
        }

        /// This function will be used to check the data of a stack, it will be used to display the details of a stack to a user
        access(all) fun getStackData(stackID: UInt64): {String: AnyStruct}? {

            let stack: MomentStack = self.stacks[stackID] ?? panic("Stack with ID".concat(stackID.toString()).concat(" does not exist"))  

            let stackData: {String: AnyStruct} = {
                "price": stack.price,
                "onSale": stack.onSale,
                "momentIDs": stack.momentIDs,
                "stackChemistry": stack.momentStackChemistry,
                "stackName": stack.momentStackName
            }

            return stackData
        }

        access(all) fun getMomentDatasInMomentStack(stackID: UInt64): [&Golazos.NFT?]? {
            if let stackData: {String: AnyStruct} = self.getStackData(stackID: stackID) {
                let answer: [&Golazos.NFT?] = []
                let momentIDs = stackData["momentIDs"] as? [UInt64]!
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