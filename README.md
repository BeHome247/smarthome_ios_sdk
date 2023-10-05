## Introduction

The `BHSmartHomeFramework`` enables an app to communicate with gateways and devices tied to the provided credentials.

## Sample application

The `BHSmartHomeSDK_SampleProject` project offers a sample app demonstrating how to utilize various features of the SDK. The user interface is developed in SwiftUI, and the logic for interacting with a gateway and its devices is located within various view models in the project:

- GatewaysViewModel
- DevicesViewModel
- ConnectionViewModel
- LightSwitchViewModel
- DimmerViewModel
- LockViewModel
- ThermostatViewModel

## Installation

To install the `BHSmartHomeFramework`, you must manually add it to your Xcode project. Choose your target, then drag the .xcframework file into the **Frameworks, Libraries, and Embedded Content section.**

IMAGE

## Getting Started

Once you've integrated the framework into your project, you'll need to import it:

```swift
import BHSmartHomeFramework
```

Before leveraging the SDK's features, initiate it using your API Key:

```swift
GatewayManager.shared.start(apiKey: "YOUR_API_KEY")
```

Skipping this step will result in the SDK's functions not operating, as they require an API Key.

## Features

### Gateway List

To retrieve a list of gateways associated with the given credentials, employ the `fetchGateways` method:

```swift
let gateways = await GatewayManager.shared.fetchGateways(
    email: email,
    password: password,
    domain: domain
)
```

This method returns a list of `Gateway` entities, each containing these public attributes:

- id
- status (UP or DOWN)
- batteryLevel
- lastSeen

It's important to note that this function is `async`, necessitating the use of the `await` keyword.

If the provided credentials are not valid, you will get a `.invalidCredentials` error notification and the `fetchGateways` method will return an empty list.

### Connect to a Gateway

For gateway connection, use the `connect(_ gateway: Gateway)` method:

```swift
let gateways = await GatewayManager.shared.fetchGateways(
    email: email,
    password: password,
    domain: domain
)

guard let gateway = gateways.first else { return }

await GatewayManager.shared.connect(gateway)
```

Upon successful connection via the `connect` method, a .connect notification will be sent from the gateway. At this point, you can begin interaction with both the gateway and its devices.

### Reconnect to a Gateway

Once a connection to a gateway is established, the SDK caches its details. However, there might be instances where the connection is lost, e.g., when restarting the app. To reconnect using cached data, which is quicker, use the `connect()` method:

```swift
GatewayManager.shared.connect()
```

### Connection Status

To verify if a connection with a gateway is active, check the `isConnected` property:

```swift
let isConnected = GatewayManager.shared.isConnected
```

Additionally, you can retrieve the `id` of the currently connected gateway:

```swift
let gatewayId = GatewayManager.shared.gatewayId
```

Bear in mind, the `gatewayId` may be `nil` if no connection exists.

### Interacting with the Gateway

Once a connection is set up, message exchanges can begin. All possible messages are defined within the `GatewayMessageType` enum.

To dispatch a message, utilize one of the two available methods in the `GatewayManager` class:

- `send(_ messageType: GatewayMessageType, data: [String: Any] = [:])`
- `send(_ messageType: GatewayMessageType, deviceId: String, data: [String: Any] = [:])`

For queries that pertain to the gateway, employ the first method. If the query relates to a specific device, use the second one, specifying the `deviceId`.

The gateway can dispatch update or error notifications in response to user messages or due to a device status change, like when another user modifies a device.

To listen for these updates, register as a gateway observer:

```swift
class MyViewModel {
    init() {
        GatewayManager.shared.add(observer: self)
    }
}
```

For successful registration, ensure your object adheres to the `GatewayObserver` protocol and implements the mandated functions.

```swift
extension MyViewModel: GatewayObserver {
    func notify(_ notification: GatewayUpdateNotification) {
        // Handle update notification
    }

    func notify(error: GatewayError) {
        // Handle error
    }
}
```

A `GatewayUpdateNotification`` embodies three attributes:

- `operation`: Defines the operation relevant to the notification. As an example, activating a switch results in a .turnOn operation.
- `deviceId`: Denotes the device that initiated the notification. Referring back to the previous example, this would be the switch's ID. This may be nil if the alert doesn't relate to a specific device.
- `data`: Provides supplemental data. Say, for a thermostat mode alteration, this would relay the new mode. You'll need to cast this to its concrete type. Taking the thermostat instance into account:

```swift
let newMode = notification.data as? String
```

Conversely, `GatewayError` is an enumeration encapsulating various error types:

- missingAPIKey
- invalidCredentials
- connectionError
- codeAlreadyExists
- tokenExpired
- connectWiFi

### Connection Error

If the connection with the gateway is lost or not established and you attempt to send a message, you'll receive a .connectionError notification. Therefore, it's advisable to monitor these notifications and implement error-handling mechanisms in your code.

### Device List

To retrieve the list of devices connected to a gateway, send a `.deviceList` message:

```swift
GatewayManager.shared.send(.deviceList)
```

To obtain the results, check for the `.deviceList` notification from the gateway. The device list will be available in the data property of the notification

```swift
func notify(_ notification: GatewayUpdateNotification) {
    switch notification.operation {
        case .deviceList:
            let devices = notification.data as? [Device] ?? []
        default:
            break
    }
}
```

### Device Types

`Device` is an enumeration where each case has an associated value that indicates the specific type of device. The SDK currently recognizes the following device types:

- Lock
- Switch
- Dimmer
- Thermostat
- Motion Sensor

Each device type is associated with unique properties:

```swift
...
// Device type
guard let selectedDevice = devices.first else { return }

switch selectedDevice {
    case .thermostat(let thermostat):
        // Thermostat type
    case .lock(let lock):
        // Lock type
    case .dimmer(let dimmer):
        // Dimmer type
    case .lightSwitch(let lightSwitch):
        // Switch type
    case .motionSensor(let motionSensor):
        // MotionSensor type
}
...
```

#### Switch

A switch has two states: on or off.

```swift
GatewayManager.shared.send(
    .turnOn,
    deviceId: switchId
)
```

```swift
GatewayManager.shared.send(
    .turnOff,
    deviceId: switchId
)
```

#### Dimmer

A dimmer, similar to a switch, can be toggled on or off:

```swift
GatewayManager.shared.send(
    .turnOn,
    deviceId: dimmerId
)
```

```swift
GatewayManager.shared.send(
    .turnOff,
    deviceId: dimmerId
)
```

Additionally, you can adjust the dimmer's brightness:

```swift
GatewayManager.shared.send(
    .dim,
    deviceId: dimmerId,
    data: ["value": value]
)
```

Here, `value` represents an integer ranging from 0 to 100.

#### Lock

A lock can either be locked or unlocked.

Lock:

```swift
GatewayManager.shared.send(
    .lock,
    deviceId: lockId
)
```

Unlock:

```swift
GatewayManager.shared.send(
    .unlock,
    deviceId: lockId
)
```

#### Access Codes

To retrieve the list of access codes linked to a lock:

```swift
GatewayManager.shared.send(
    .fetchCodes,
    deviceId: lockId
)
```

When the gateway responds, it will send a `.fetchCodes` notification containing the list of `pincodes` in the notification's data:

```swift
func notify(_ notification: GatewayUpdateNotification) {
    switch notification.operation {
    case .fetchCodes:
        let codes = notification.data as? [Pincode] ?? []
    default:
        break
    }
}
```

To add a new code to a lock:

```swift
let codeData = ["name": name, "code": code]
GatewayManager.shared.send(
    .addCode,
    deviceId: lockId,
    data: codeData
)
```

**Ensure that the code is between 4 to 8 digits long.**

If the code is successfully added, you'll receive an `.addCode` notification from the gateway. The newly added code will be included in the notification's data.

However, if the code already exists, you'll receive a `.codeAlreadyExists` error notification:

```swift
func notify(error: GatewayError) {
    switch error {
        case .codeAlreadyExists:
            // Handle error
        default:
            break
    }
}
```

You also have the option to add time restrictions to a code, specifying the valid dates for the code:

```swift
let restrictionData = ["id": codeId, "from": from, "to": to]
GatewayManager.shared.send(
    .addCodeRestriction,
    deviceId: deviceId,
    data: restrictionData
)
```

In this context, `from` and `to` are date strings formatted as `yyyy-MM-dd'T'HH:mm:ss`.

You can also remove restrictions from a code:

```swift
GatewayManager.shared.send(
    .removeCodeRestriction,
    deviceId: lockId,
    data: ["id": codeId]
)
```

For both the above operations, you'll receive either a `.addCodeRestriction` or a `.removeCodeRestriction` notification confirming the action's success.

Lastly, you can delete a code from a lock:

```swift
GatewayManager.shared.send(
    .removeCode,
    deviceId: lockId,
    data: ["id": codeId]
)
```

#### Thermostat

To adjust the thermostat's setpoint:

```swift
GatewayManager.shared.send(
    .updateThermostatSetpoint,
    deviceId: thermostatId,
    data: ["setpoint": temperature]
)
```

To set the heating setpoint:

```swift
GatewayManager.shared.send(
    .updateThermostatSetpointHeating,
    deviceId: thermostatId,
    data: ["setpoint": temperature]
)
```

To set the cooling setpoint:

```swift
GatewayManager.shared.send(
    .updateThermostatSetpointCooling,
    deviceId: thermostatId,
    data: ["setpoint": temperature]
)
```

To change the mode:

```swift
GatewayManager.shared.send(
    .updateThermostatMode,
    deviceId: thermostatId,
    data: ["mode": mode]
)
```

Here, `mode` can be one of the following: `heat`, `cool`, `auto`, or `off`.

To modify the fan mode:

Update fan mode:

```swift
GatewayManager.shared.send(
    .updateThermostatFanMode,
    deviceId: thermostatId,
    data: ["mode": mode]
)
```

In this case, `mode` can be: `auto_low`, `low`, or `off`.

### Connection

#### Connection Status

To verify the status of the gateway's connection:

```swift
GatewayManager.shared.send(.connectionStatus)
```

After sending this message, you'll receive a `.connectionStatus` notification detailing the connection's status:

```swift
func notify(_ notification: GatewayUpdateNotification) {
    switch notification.operation {
    case .connectionStatus:
        let connectionStatus = notification.data as? GatewayConnectionType ?? .offline
    default:
        break
    }
}
```

The possible connection statuses are:

- ethernet
- modem
- wifi
- offline

#### WiFi Networks

To retrieve a list of networks accessible to the gateway:

```swift
GatewayManager.shared.send(.startWiFiScan)
```

The gateway will then dispatch a `.startWiFiScan` notification that carries the list of networks:

```swift
func notify(_ notification: GatewayUpdateNotification) {
    switch notification.operation {
    case .startWiFiScan:
        let networks = notification.data as? [WiFiNetwork] ?? []
    default:
        break
    }
}
```

To stop the WiFi scan:

```swift
GatewayManager.shared.send(.stopWiFiScan)
```

## Disconnect

To finish the connection with a gateway, use the `disconnect` function:

```swift
GatewayManager.shared.disconnect()
```

This action will also clear all cached data. Thus, it's advisable to execute it during your app's sign-out process. Post-disconnection, to re-establish the connection, invoke the `connect(\_ gateway: Gateway)` function.
