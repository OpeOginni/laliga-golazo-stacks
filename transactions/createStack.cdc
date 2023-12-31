// import GolazosStacks from "../contracts/GolazosStacks.cdc"

import GolazosStacks from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator

transaction(momentIDs: [UInt64], momentStackName: String) {

    prepare(signer: AuthAccount) {

    let signerGolazosCollection =  signer.borrow<&GolazosStacks.GolazosStackCollection>(from: GolazosStacks.GolazoStackStoragePath) ?? panic("Can't Borrow")

    signerGolazosCollection.createMomentStack(momentIDs: momentIDs, momentStackName: momentStackName)
    }

    execute {

    log("Moment Stack Created")

    }
}
