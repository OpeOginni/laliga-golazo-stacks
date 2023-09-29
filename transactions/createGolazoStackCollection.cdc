// import GolazosStacks from "../contracts/GolazosStacks.cdc"
// import Golazos from "../contracts/utils/Golazos.cdc"
// import FungibleToken from "../contracts/utils/FungibleToken.cdc"

import GolazosStacks from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator
import Golazos from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator
import FungibleToken from 0xee82856bf20e2aa6

transaction() {

    prepare(signer: AuthAccount) {

    // let signerGolazosCollection =  signer.getCapability<&Golazos.Collection>(Golazos.CollectionPublicPath)
    let signerGolazosCollection =  signer.getCapability<&{Golazos.MomentNFTCollectionPublic}>(Golazos.CollectionPublicPath) // This is True

    let signerGolazosCapability = signer.getCapability<&{FungibleToken.Receiver}>(/public/dapperUtilityCoinReceiver)

    log(signerGolazosCollection.check())


    let emptyCollection <- GolazosStacks.createGolazoStackCollection(ownerCollection: signerGolazosCollection, ownerFungibleTokenReciverCapability: signerGolazosCapability)

    signer.save(<-emptyCollection, to: GolazosStacks.GolazoStackStoragePath)

    signer.link<&{GolazosStacks.StackPublic}>(GolazosStacks.GolazoStackPublicPath, target: GolazosStacks.GolazoStackStoragePath)

    
    }

    execute {

    log("CollectionCreated")

    }
}
