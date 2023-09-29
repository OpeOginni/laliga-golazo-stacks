// import Golazos from "../../contracts/utils/Golazos.cdc"

import Golazos from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator

transaction(
    name: String,
    metadata: {String: String}
   ) {
    // local variable for the admin reference
    let admin: &Golazos.Admin

    prepare(signer: AuthAccount) {
        // borrow a reference to the Admin resource
        self.admin = signer.borrow<&Golazos.Admin>(from: Golazos.AdminStoragePath)
            ?? panic("Could not borrow a reference to the Golazos Admin capability")
    }

    execute {
        let id = self.admin.createPlay(
            classification: name,
            metadata: metadata
        )

        log("====================================")
        log("New Play:")
        log("PlayID: ".concat(id.toString()))
        log("====================================")
    }
}
