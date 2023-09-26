import FungibleToken from "../../contracts/official-contracts/FungibleToken.cdc"
import DapperUtilityCoin from "../../contracts/official-contracts/DapperUtilityCoins.cdc"

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
