# Welcome to PowerDale

PowerDale is a small town with around 100 residents. Most houses have a smart meter installed that can save and send information about how much power a house is drawing/using.

There are three major providers of energy in town that charge different amounts for the power they supply.

- _Dr Evil's Dark Energy_
- _The Green Eco_
- _Power for Everyone_

# Introducing JOI Energy

JOI Energy is a new start-up in the energy industry. Rather than selling energy they want to differentiate themselves from the market by recording their customers' energy usage from their smart meters and recommending the best supplier to meet their needs.

You have been placed into their development team, whose current goal is to produce an API which their customers and smart meters will interact with.

Unfortunately, two members of the team are on annual leave, and another one has called in sick! You are left with another ThoughtWorker to progress with the current user stories on the story wall. This is your chance to make an impact on the business, improve the code base and deliver value.

## Users

To trial the new JOI software 5 people from the JOI accounts team have agreed to test the service and share their energy data.

| User    | Smart Meter ID  | Power Supplier        |
| ------- | --------------- | --------------------- |
| Sarah   | `smart-meter-0` | Dr Evil's Dark Energy |
| Peter   | `smart-meter-1` | The Green Eco         |
| Charlie | `smart-meter-2` | Dr Evil's Dark Energy |
| Andrea  | `smart-meter-3` | Power for Everyone    |
| Nemo    | `smart-meter-4` | The Green Eco         |

These values are used in the code and in the following examples too.

## Store readings

In Salesforce org, we'll store readings under Reading object.

Parameters

| Field          | Description                                          |
| -------------- | ---------------------------------------------------- |
| `Client`       | Owner of the smart meter                             |
| `Reading Time` | The date/time (as epoch) when the _reading_ is taken |
| `Value`        | The consumption in `kW` at the _time_ of the reading |


Example readings

| Client         |  Reading Time        |  Value (`kW`)  |
| -------------- |  --------------:     | -------------: |
| Charlie        |  `2020-11-29 8:00`   |  4.0503        |
| Charlie        |  `2020-11-29 9:00`   |  3.0621        |
| Charlie        |  `2020-11-29 10:00`  |  4.0222        |
| Charlie        |  `2020-11-29 11:00`  |  2.0423        |


In the above example, the smart meter sampled readings, in `kW`, every hour. Note that the reading is in `kW` and not `kWH`, which means that each reading represents the consumption at the reading time. If no power is being consumed at the time of reading, then the reading value will be `0`. Given that `0` may introduce new challenges, we can assume that there is always some consumption, and we will never have a `0` reading value. These readings are then sent by the smart meter to the application using REST. There is a service in the application that calculates the `kWH` from these readings

## View Current Price Plan and Compare Usage Cost Against all Price Plans

Parameters

| Parameter      | Description                                          |
| -------------- | ---------------------------------------------------- |
| `clientId `    | Id of the smart meter Owner                          |

Example PricePlans

| planId             | planName        |  rate         |  cost      |
| -----------------  | --------------: | -----------:  |  ------:   | 
| a0Z6F000010ZgA2UAK | price-plan-2    |  2.00         |  0.0275    |
| a0Z6F000010ZgA3UAK | price-plan-0    |  10.00        |  0.137     |
| a0Z6F000010ZgA1UAK | price-plan-1    |  1.00         |  0.013     |


## View Recommended Price Plans for Usage


Parameters

| Parameter      | Description                                          |
| -------------- | ---------------------------------------------------- |
| `clientId`     | Id of the smart meter Owner                          |
| `limit`        | limit the number of plans to be displayed            |


Example Recommended Price Plans

| planId             | planName        |  rate         |  cost      |
| -----------------  | --------------: | -----------:  |  ------:   | 
| a0Z6F000010ZgA1UAK | price-plan-1    |  1.00         |  0.013     |
| a0Z6F000010ZgA3UAK | price-plan-0    |  10.00        |  0.137     |


********************************************

# Setting up Development Workspace

### Before you start, lets go through some useful references

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- Salesforce CLI Setup [this](https://developer.salesforce.com/tools/salesforcecli) or [this](https://github.com/salesforcecli/cli)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_unified.htm)
- [Scratch Org](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_scratch_orgs.htm)
- [Development models](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).


### 1) Salesforce CLI
Lets start by installing Salesforce CLI or upgrade to latest version (take a note of your node version compatibility)

```
npm install @salesforce/cli --global
```

### 2) Development Org
Signup for a new Developer Trial Org. The form could act funny and wont provide any feedback on success or failure. Watch your email, it takes a while to receive the activation email with link

https://developer.salesforce.com/signup

### 3) Enable Dev Hub 
- From Setup, enter Dev Hub in the Quick Find box, then select Dev Hub
- Click the toggle to "Enable Dev Hub"

### 4) Enable Scratch Org
Enable Org Shape for Scratch Orgs in the Dev Hub org that you use to create scratch orgs.

1. Copy the org ID from **Setup > Company Information**.
2. From Setup, enter Scratch Orgs in the Quick Find box, then select **Scratch Orgs**.
3. Click the toggle for **Enable Org Shape for Scratch Orgs**.
4. In the text box, enter the 15-character org ID for the Dev Hub, then click **Save**.

### 5) Setup local workspace
Start with cloning the repo, and then...

1) *Authenticate*
```
sf org login web --alias JoyOfEnergy
```

> Successfully authorized developer@thoughtworks.com with org ID 00DIS000000J6Zd2AK

2) *Create Scratch Org*
```
sf org create scratch --definition-file config/project-scratch-def.json --alias JoyOfEnergyScratchOrg --set-default --target-dev-hub JoyOfEnergy
```

> Warning: Record types defined in the scratch org definition file will stop being capitalized by default in a future release.\
>...\
>Your scratch org is ready.

3) *List Orgs*: This will show your DevHub and Scratch orgs
```
sf org list
```

4) Get Scratch Org Details (the scratch org UserName can be fetched from `org list` or `org create scratch` command output). The output will provide `Instance Url`, `UserName` and `Password` to log into Scratch Org
```
sf org display user --target-org test-whatever@example.com
```
**Note:** a password needs to be generated before first login `sf org generate password --target-org test-whatever@example.com`


5) The first deploy would start the source tracking. All source in the package directories in the sfdx-project.json file is deployed to the scratch org
```
sf project deploy start
```

> Deploying v51.0 metadata to test-whatever@example.com using the v60.0 SOAP API.
Deploy ID: 0Af1m00000tNImVCAW
Status: Succeeded | ████████████████████████████████████████ | 19/19 Components | Tracking: 21/21

6) Import Accounts and Plan data in your Scratch Org (`data/Account.json`)
```
sf data import tree --files data/Account.json --target-org JoyOfEnergyScratchOrg
```

> === Import Results\
> Reference ID     Type         ID \
>...


Now that your local workspace and DevHub Scratch org is ready, spend some time to look at the configurations and code. Will discuss the next adventure with this codebase when we meet. Looking forward...

