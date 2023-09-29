/*
import GolazosStacks from "../../contracts/GolazosStacks.cdc"
import Golazos from "../../contracts/utils/Golazos.cdc"
import FungibleToken from "../../contracts/utils/FungibleToken.cdc"
import DapperUtilityCoin from "../../contracts/utils/DapperUtilityCoins.cdc"
*/

import GolazosStacks from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator
import Golazos from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator
import FungibleToken from 0xee82856bf20e2aa6
import DapperUtilityCoin from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator

transaction(
    name: String,
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
        // We are Hardcoding the Metadata for now
        let metadata: {String: String} = { "MatchAwayScore": "1", "MatchAwayTeam": "RCD Espanyol de Barcelona", "MatchDate": "2023-04-15 16:30:00 +0000 UTC", "MatchDay": "29", "MatchHighlightedTeam": "RCD Espanyol de Barcelona", "MatchHomeScore": "3", "MatchHomeTeam": "Real Betis", "MatchSeason": "2022-2023", "PlayDataID": "2301868_214125_recrRlVPGDUOBPN2r", "PlayerCountry": "Mexico", "PlayerDataID": "214125", "PlayerFirstName": "César", "PlayerJerseyName": "C. Montes", "PlayerKnownName": "", "PlayerLastName": "Montes", "PlayerNumber": "23", "PlayerPosition": "Defender", "PlayHalf": "2", "PlayTime": "48", "PlayType": "GOAL"}


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
