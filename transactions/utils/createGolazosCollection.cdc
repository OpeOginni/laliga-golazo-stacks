import Golazos from "../../contracts/official-contracts/Golazos.cdc"

transaction() {

    prepare(signer: AuthAccount) {

    let emptyCollection <- Golazos.createEmptyCollection()

    signer.save(<-emptyCollection, to: Golazos.CollectionStoragePath)

    signer.link<&{Golazos.MomentNFTCollectionPublic}>(Golazos.CollectionPublicPath, target: Golazos.CollectionStoragePath)
    }

    execute {

    }
}
