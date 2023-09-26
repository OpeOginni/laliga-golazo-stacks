import GolazosStacks from "../../contracts/GolazosStacks.cdc"
import Golazos from "../../contracts/official-contracts/Golazos.cdc"
import FungibleToken from "../../contracts/official-contracts/FungibleToken.cdc"
import DapperUtilityCoin from "../../contracts/official-contracts/DapperUtilityCoins.cdc"

transaction(
    name: String,
    metadata: {String: String},
    tier: String,
    maxMintSize: UInt64?,
   ) {
    // local variable for the admin reference
    let admin: &Golazos.Admin

    prepare(signer: AuthAccount) {
        // borrow a reference to the Admin resource
        self.admin = signer.borrow<&Golazos.Admin>(from: Golazos.AdminStoragePath)
            ?? panic("Could not borrow a reference to the Golazos Admin capability")

    let emptyCollection <- Golazos.createEmptyCollection()

    signer.save(<-emptyCollection, to: Golazos.CollectionStoragePath)

    signer.link<&{Golazos.MomentNFTCollectionPublic}>(Golazos.CollectionPublicPath, target: Golazos.CollectionStoragePath)
    

    let signerGolazosCollection =  signer.getCapability<&{Golazos.MomentNFTCollectionPublic}>(Golazos.CollectionPublicPath) // This is True

    let signerGolazosCapability = signer.getCapability<&{FungibleToken.Receiver}>(/public/dapperUtilityCoinReceiver)

    log(signerGolazosCollection.check())


    let emptyCollection2 <- GolazosStacks.createGolazoStackCollection(ownerCollection: signerGolazosCollection, ownerFungibleTokenReciverCapability: signerGolazosCapability)

    signer.save(<-emptyCollection2, to: GolazosStacks.GolazoStackStoragePath)

    signer.link<&{GolazosStacks.StackPublic}>(GolazosStacks.GolazoStackPublicPath, target: GolazosStacks.GolazoStackStoragePath)
    }

    execute {
        let playID = self.admin.createPlay(
            classification: name,
            metadata: metadata
        )

        let seriesID = self.admin.createSeries(name: name)

        let setID = self.admin.createSet(name: name)

        let editionID = self.admin.createEdition(
            seriesID: seriesID,
            setID: setID,
            playID: playID,
            maxMintSize: maxMintSize,
            tier: tier,
        )
        log("====================================")
        log("Setup Complete")
        log("====================================")
    }
}
