// import FungibleToken from "../../contracts/utils/FungibleToken.cdc"
// import DapperUtilityCoin from "../../contracts/utils/DapperUtilityCoins.cdc"

import FungibleToken from 0xee82856bf20e2aa6
import DapperUtilityCoin from 0xf8d6e0586b0a20c7 // Keep Uncommented When Running the Emulator

transaction() {

    prepare(signer: AuthAccount) {

    let emptyDapperVault <- DapperUtilityCoin.createEmptyVault()

    signer.save(<-emptyDapperVault, to:  /storage/dapperUtilityCoinVault)


    signer.link<&DapperUtilityCoin.Vault{FungibleToken.Balance}>(
            /public/dapperUtilityCoinBalance,
            target: /storage/dapperUtilityCoinVault
        )

    signer.link<&{FungibleToken.Receiver}>(
            /public/dapperUtilityCoinReceiver,
            target: /storage/dapperUtilityCoinVault
        )

    }

    execute {

    log("created dapper vault")

    }
}
