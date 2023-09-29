# Golazo Stacks

## More ways to make your Moments Stand Out

[Laliga's Golazo](https://laligagolazos.com/) is a Community on the Flow Blockchain where users can build Collections of LaLiga Moments.

Gozalo Stacks is an extension of the already existing Laliga Golazo community on flow. Moments are plays or actions that happened in real football games in the Spanish Laliga League.

Golazo Stacks was created to be a way for users to create teams of Moments, and further make their collection unique. As an individual Moment might be unique, but put that Moment in a Stack with other Moments then you can create truely Unique combinations.

**Features**

- Create better ways to run Challenges for Holders
- Gamification of Moments while keeping true to its collectability.
- Possibility of Stack Building Contests among Holders.
- Gives use to Moments from older Series, as they can be used to build stacks with new Series Moments

Link to my In Depth Article - https://dev.to/opeoginni/golazos-stacks-more-ways-to-flex-use-and-make-your-moments-stand-out-1e22

## Installation Guide

- Clone Repo using command `git clone https://github.com/OpeOginni/laliga-golazo-stacks`
- Install Dependencies `npm i`
- Run Flow Emulator `flow emulator`

### Testing Guide

To test Golazos Stacks you will have to make use of Bash Scripts I created an pass in needed args wit required. (Note run all these from the ROOT FOLDER)

- Allow all scripts to be executed using the `chmod` command. Run the followng commands one after the other

```bash
# Script to Deploy all needed contracts
chmod u+x ./bin/deploy-all-contracts

# Script to run needed transactions
chmod u+x ./bin/transactions/setup
chmod u+x ./bin/transactions/createStack

# Script to run needed scripts
chmod u+x ./bin/scripts/getStackIDs
chmod u+x ./bin/scripts/getStackDetails
chmod u+x ./bin/scripts/getStackAttribs
chmod u+x ./bin/scripts/getMomentIDs
```

(Use the Address from the emulator-account account in the flow.json)

- Deploy Needed Contracts using the script `./bin/deploy-all-contracts`
- Setup the Environment using the setup script by running this command `./bin/transactions/setup`
- Get the IDs of the minted Moments by running this command `./bin/scripts/getMomentIDs <user_address>`
- Using the IDs returned create a stack using this script command `./bin/transactions/createStack <momentID_1> <momentID_2> <momentID_3> <momentID_4> <momentID_5> <stack_name>`
- Get the IDs of exisitng Stacks you have (which will be one ID for now) `./bin/scripts/getStackIDs <user_address>`
- Using the Stack ID you can get the Attributes of the Stack with the command `./bin/scripts/getStackAttribs <owner_address> <stack_id>`
- Using the Stack ID you can also get the Details of the Stack with the command `./bin/scripts/getStackDetails <owner_address> <stack_id>`
