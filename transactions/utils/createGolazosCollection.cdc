// import Golazos from "../../contracts/utils/Golazos.cdc"

import Golazos from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator

transaction() {

    prepare(signer: AuthAccount) {

    let emptyCollection <- Golazos.createEmptyCollection()

    signer.save(<-emptyCollection, to: Golazos.CollectionStoragePath)

    signer.link<&{Golazos.MomentNFTCollectionPublic}>(Golazos.CollectionPublicPath, target: Golazos.CollectionStoragePath)
    }

    execute {

    }
}
