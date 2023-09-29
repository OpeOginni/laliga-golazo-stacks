// import GolazosStacks from "../contracts/GolazosStacks.cdc"

import GolazosStacks from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator

// Made this Transaction just for the Bash scripts as Dealing with Arrays is complicated there 
transaction(momentID_1: UInt64, momentID_2: UInt64, momentID_3: UInt64, momentID_4: UInt64, momentID_5: UInt64, momentStackName: String) {

    prepare(signer: AuthAccount) {
    let momentIDs: [UInt64] = [momentID_1, momentID_2, momentID_3, momentID_4, momentID_5]

    let signerGolazosCollection =  signer.borrow<&GolazosStacks.GolazosStackCollection>(from: GolazosStacks.GolazoStackStoragePath) ?? panic("Can't Borrow")

    signerGolazosCollection.createMomentStack(momentIDs: momentIDs, momentStackName: momentStackName)
    }

    execute {

    log("Moment Stack Created")

    }
}
