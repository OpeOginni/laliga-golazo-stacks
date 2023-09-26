import FungibleToken from "../../contracts/utils/FungibleToken.cdc"
import DapperUtilityCoin from "../../contracts/utils/DapperUtilityCoins.cdc"

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
