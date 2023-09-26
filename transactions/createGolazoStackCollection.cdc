import GolazosStacks from "../contracts/GolazosStacks.cdc"
import Golazos from "../contracts/official-contracts/Golazos.cdc"
import FungibleToken from "../contracts/official-contracts/FungibleToken.cdc"

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
