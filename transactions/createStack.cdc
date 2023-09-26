import GolazosStacks from "../contracts/GolazosStacks.cdc"


transaction(momentIDs: [UInt64], momentStackName: String) {

    prepare(signer: AuthAccount) {

    let signerGolazosCollection =  signer.borrow<&GolazosStacks.GolazosStackCollection>(from: GolazosStacks.GolazoStackStoragePath) ?? panic("Can't Borrow")

    signerGolazosCollection.createMomentStack(momentIDs: momentIDs, momentStackName: momentStackName)
    }

    execute {

    log("Moment Stack Created")

    }
}
