Title: Protocol Reference

# Protocol Reference

This reference is generated from JSON Schemas used in the testing and development of KDE Connect.

This document should not be interpreted as a formal specification, or guaranteed interface for third parties.

## Table of Contents

* [Core Protocol](#core-protocol)
    * [`kdeconnect.*`](#kdeconnect)
    * [`kdeconnect.identity`](#kdeconnectidentity)
    * [`kdeconnect.pair`](#kdeconnectpair)
* [Battery Plugin](#battery-plugin)
    * [`kdeconnect.battery`](#kdeconnectbattery)
    * [`kdeconnect.battery.request`](#kdeconnectbatteryrequest)
* [Clipboard Plugin](#clipboard-plugin)
    * [`kdeconnect.clipboard`](#kdeconnectclipboard)
    * [`kdeconnect.clipboard.connect`](#kdeconnectclipboardconnect)
* [Connectivity Report Plugin](#connectivity-report-plugin)
    * [`kdeconnect.connectivity_report`](#kdeconnectconnectivity_report)
    * [`kdeconnect.connectivity_report.request`](#kdeconnectconnectivity_reportrequest)
* [Contacts Plugin](#contacts-plugin)
    * [`kdeconnect.contacts.request_all_uids_timestamps`](#kdeconnectcontactsrequest_all_uids_timestamps)
    * [`kdeconnect.contacts.request_vcards_by_uid`](#kdeconnectcontactsrequest_vcards_by_uid)
    * [`kdeconnect.contacts.response_uids_timestamps`](#kdeconnectcontactsresponse_uids_timestamps)
    * [`kdeconnect.contacts.response_vcards`](#kdeconnectcontactsresponse_vcards)
* [FindMyPhone Plugin](#findmyphone-plugin)
    * [`kdeconnect.findmyphone.request`](#kdeconnectfindmyphonerequest)
* [Lock](#lock)
    * [`kdeconnect.lock`](#kdeconnectlock)
    * [`kdeconnect.lock.request`](#kdeconnectlockrequest)
* [MousePad Plugin](#mousepad-plugin)
    * [`kdeconnect.mousepad.echo`](#kdeconnectmousepadecho)
    * [`kdeconnect.mousepad.keyboardstate`](#kdeconnectmousepadkeyboardstate)
    * [`kdeconnect.mousepad.request`](#kdeconnectmousepadrequest)
* [MPRIS Plugin](#mpris-plugin)
    * [`kdeconnect.mpris`](#kdeconnectmpris)
    * [`kdeconnect.mpris.request`](#kdeconnectmprisrequest)
* [Notification Plugin](#notification-plugin)
    * [`kdeconnect.notification`](#kdeconnectnotification)
    * [`kdeconnect.notification.action`](#kdeconnectnotificationaction)
    * [`kdeconnect.notification.reply`](#kdeconnectnotificationreply)
    * [`kdeconnect.notification.request`](#kdeconnectnotificationrequest)
* [Ping Plugin](#ping-plugin)
    * [`kdeconnect.ping`](#kdeconnectping)
* [Presenter Plugin](#presenter-plugin)
    * [`kdeconnect.presenter`](#kdeconnectpresenter)
* [RunCommand Plugin](#runcommand-plugin)
    * [`kdeconnect.runcommand`](#kdeconnectruncommand)
    * [`kdeconnect.runcommand.request`](#kdeconnectruncommandrequest)
* [SFTP Plugin](#sftp-plugin)
    * [`kdeconnect.sftp`](#kdeconnectsftp)
    * [`kdeconnect.sftp.request`](#kdeconnectsftprequest)
* [Share Plugin](#share-plugin)
    * [`kdeconnect.share.request`](#kdeconnectsharerequest)
    * [`kdeconnect.share.request.update`](#kdeconnectsharerequestupdate)
* [SMS Plugin](#sms-plugin)
    * [`kdeconnect.sms.attachment_file`](#kdeconnectsmsattachment_file)
    * [`kdeconnect.sms.messages`](#kdeconnectsmsmessages)
    * [`kdeconnect.sms.request`](#kdeconnectsmsrequest)
    * [`kdeconnect.sms.request_attachment`](#kdeconnectsmsrequest_attachment)
    * [`kdeconnect.sms.request_conversation`](#kdeconnectsmsrequest_conversation)
    * [`kdeconnect.sms.request_conversations`](#kdeconnectsmsrequest_conversations)
* [SystemVolume Plugin](#systemvolume-plugin)
    * [`kdeconnect.systemvolume`](#kdeconnectsystemvolume)
    * [`kdeconnect.systemvolume.request`](#kdeconnectsystemvolumerequest)
* [Telephony Plugin](#telephony-plugin)
    * [`kdeconnect.telephony`](#kdeconnecttelephony)
    * [`kdeconnect.telephony.request_mute`](#kdeconnecttelephonyrequest_mute)

* [Appendix](#appendix)
    * [Symbols](#symbols)
    * [Data Types](#data-types)


## Core Protocol

The core of the KDE Connect protocol is built on the exchange of JSON packets, similar to JSON-RPC.

### References

* <https://invent.kde.org/network/kdeconnect-kde>
* <https://invent.kde.org/network/kdeconnect-android>
* <https://invent.kde.org/network/kdeconnect-ios>

### Packets

#### `kdeconnect.*`

The structure of a KDE Connect packet is similar to a JSON-RPC request, although the protocols are quite different. The `id` field holds a timestamp, the `type` field holds a type string and the `body` field holds a dictionary of parameters. While the `id` field is not used in KDE Connect, the `type` and `body` fields are analogous to the `method` and `params` members of a JSON-RPC request.

Packets are sent by devices with no guarantee that they will be received, or that if received there will be a response. For this reason, plugins consistently handle any incoming packet regardless of whether it was expected or not. In other words, packet handling in KDE Connect is typically idempotent.

Payloads are declared by the presence of the `payloadSize` and `payloadTransferInfo` fields, which indicate that the packet sender is waiting to transfer `payloadSize` bytes over the connection described by `payloadTransferInfo`. For example, the `payloadTransferInfo` dictionary might have a `port` entry holding a TCP port the device is listening on for incoming connections.

```js
{
    "id": 0,
    "type": "kdeconnect.share.request",
    "body": {
        "filename": "image.png"
    },
    "payloadSize": 882,
    "payloadTransferInfo": {
        "port": 1739
    }
}
```

* `id`: [**`Number`**](#number) [🔒](#symbols)

    A UNIX epoch timestamp (ms). In some cases KDE Connect clients erroneously set this field as a string.

* `type`: [**`String`**](#string) [🔒](#symbols)

    **`pattern`**: `/^kdeconnect(\.[a-z_]+)+$/`

    A string in the form of `kdeconnect.<plugin>` or `kdeconnect.<plugin>.<action>` such as `kdeconnect.mpris` and `kdeconnect.mpris.request`.

* `body`: [**`Object`**](#object) [🔒](#symbols)

    A dictionary of parameters appropriate for the packet `type`.

This packet has no body fields.

* `payloadSize`: [**`Number`**](#number)

    **`range`**: Unrestricted

    The size of the payload to expect. There is a currently unused convention of using `-1` to declare a stream of indefinite size.

* `payloadTransferInfo`: [**`Object`**](#object)

    A dictionary of properties necessary for clients to negotiate a transfer channel.

#### `kdeconnect.identity`

The KDE Connect identity packet is used to identify devices and their capabilities.

Each networking module may define additional fields necessary for clients to connect. For example, in the LAN protocol the identity packet is broadcast over UDP with a `tcpPort` field.

```js
{
    "id": 0,
    "type": "kdeconnect.identity",
    "body": {
        "deviceId": "740bd4b9_b418_4ee4_97d6_caf1da8151be",
        "deviceName": "FOSS Phone",
        "deviceType": "phone",
        "incomingCapabilities": [
            "kdeconnect.mock.echo",
            "kdeconnect.mock.transfer"
        ],
        "outgoingCapabilities": [
            "kdeconnect.mock.echo",
            "kdeconnect.mock.transfer"
        ],
        "protocolVersion": 7
    }
}
```

* `deviceId`: [**`String`**](#string) [🔒](#symbols)

    **`pattern`**: `/^[a-zA-Z0-9_]{32,38}$/`

    A unique ID for the device. Must be between 32 and 38 characters and made of only alphanumerical characters and underscores. A valid device ID can be generated from a random UUIDv4 string by removing the hyphens (`-`) or replacing them with underscores (`_`), such as `740bd4b9_b418_4ee4_97d6_caf1da8151be`.

* `deviceName`: [**`String`**](#string) [🔒](#symbols)

    **`pattern`**: `/^[^"',;:.!?()\[\]<>]{1,32}$/`

    A human-readable label for the device. Must be 1-32 characters in length and can't contain any of the following punctuation marks `"',;:.!?()[]<>`. When displayed to the user for pairing or other privileged interactions, it should always be displayed within quotes.

* `deviceType`: [**`String`**](#string) [🔒](#symbols)

    **`enum`**: `'desktop'`|`'laptop'`|`'phone'`|`'tablet'`|`'tv'`

    A device type string. Since the `incomingCapabilities` and `outgoingCapabilities` fields describe the functionality of a device, the `deviceType` field is typically only used to select an icon.

* `incomingCapabilities`: [**`Array`**](#array) of [**`String`**](#string) [🔒](#symbols)

    A list of packet types the device can consume. Note that this is only an indication a device can consume a packet type, not that it will.

* `outgoingCapabilities`: [**`Array`**](#array) of [**`String`**](#string) [🔒](#symbols)

    A list of packet types the device can provide. Note that this is only an indication a device can provide a packet type, not that it will.

* `protocolVersion`: [**`Number`**](#number) [🔒](#symbols)

    **`enum`**: `7`

    The protocol version. The only value currently valid is `7`

#### `kdeconnect.pair`

The KDE Connect pair packet is used to negotiate pairing between devices. Devices must be paired before sending any other packets and should reject any incoming packets from unpaired devices.

A device sends a packet with `pair` set to `true` to request pairing. A response is expected with `pair` set to `true` to accept or `false` to `reject`. By convention the request times out after 30 seconds.

A device sends a packet with `pair` set to `false` to unpair or reject a pairing request. No response is expected.

```js
{
    "id": 0,
    "type": "kdeconnect.pair",
    "body": {
        "pair": true
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.pair",
    "body": {
        "pair": false
    }
}
```

* `pair`: [**`Boolean`**](#boolean) [🔒](#symbols)

    If `true` a pairing request is being accepted or a new one started. If `false` a pairing request is being rejected or a paired device is unpairing.

* `timestamp`: [**`Number`**](#number)

    Required if this is a pairing request. The current time in seconds since epoch. Used in the calculation of the pair verification code since protocol version 8.

## Battery Plugin

The Battery plugin allows a device to expose the status of its battery.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/battery>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/BatteryPlugin>
* <https://invent.kde.org/network/kdeconnect-ios/tree/master/KDE%20Connect/KDE%20Connect/Plugins%20and%20Plugin%20Views/Battery>

### Packets

#### `kdeconnect.battery`

This packet is a battery status update.

```js
{
    "id": 0,
    "type": "kdeconnect.battery",
    "body": {
        "currentCharge": 15,
        "isCharging": false,
        "thresholdEvent": 1
    }
}
```

* `currentCharge`: [**`Number`**](#number) [🔒](#symbols)

    **`range`**: `-1–100`

    The current battery percentage, typically between `0` and `100`. If the value is `-1`, the device should be treated as though it has no battery.

* `isCharging`: [**`Boolean`**](#boolean) [🔒](#symbols)

    A boolean value indicating whether the battery is currently charging.

* `thresholdEvent`: [**`Number`**](#number)

    **`enum`**: `0`|`1`

    Either `1` if the battery is below the threshold level, `0` otherwise. The threshold is chosen arbitrarily by the reporting device.

#### `kdeconnect.battery.request`

⚠️ Deprecated: This packet is sent to request a battery status update.

```js
{
    "id": 0,
    "type": "kdeconnect.battery.request",
    "body": {
        "request": true
    }
}
```

* `request`: [**`Boolean`**](#boolean) [🔒](#symbols)

    ⚠️ Deprecated: Whether to request a status update. It only makes sense for this to be `true`.

## Clipboard Plugin

The Clipboard plugin allows syncing clipboard text content between devices.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/clipboard>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/ClipboardPlugin>
* <https://invent.kde.org/network/kdeconnect-ios/tree/master/KDE%20Connect/KDE%20Connect/Plugins%20and%20Plugin%20Views/Clipboard>

### Packets

#### `kdeconnect.clipboard`

This packet is sent when the clipboard content changes. In other words, it is typically sent when the selection owner changes.

```js
{
    "id": 0,
    "type": "kdeconnect.clipboard",
    "body": {
        "content": "some text"
    }
}
```

* `content`: [**`String`**](#string) [🔒](#symbols)

    Text content of the clipboard.

#### `kdeconnect.clipboard.connect`

This packet is only sent when a device connects.

```js
{
    "id": 0,
    "type": "kdeconnect.clipboard",
    "body": {
        "content": "some text",
        "timestamp": 0
    }
}
```

* `content`: [**`String`**](#string) [🔒](#symbols)

    Text content of the clipboard.

* `timestamp`: [**`Number`**](#number) [🔒](#symbols)

    UNIX epoch timestamp (ms) for the clipboard content. If the timestamp is `0` or less than the local timestamp, the content should be ignored.

## Connectivity Report Plugin

The Connectivity Report plugin allows a device to expose the status of its connectivity.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/connectivity_report>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/ConnectivityReportPlugin>

### Packets

#### `kdeconnect.connectivity_report`

This packet is a connectivity report.

```js
{
    "id": 0,
    "type": "kdeconnect.connectivity_report",
    "body": {
        "signalStrengths": {
            "6": {
                "networkType": "4G",
                "signalStrength": 3
            },
            "17": {
                "networkType": "HSPA",
                "signalStrength": -1
            }
        }
    }
}
```

* `signalStrengths`: [**`Object`**](#object) [🔒](#symbols)

    A dictionary of signal states. Each key is an arbitrary, but unique, string and each value is a `Signal` object.

    * **`Signal`** ([**`Object`**](#object))

        The ID of the attachment.

        * `networkType`: [**`String`**](#string) [🔒](#symbols)

            **`enum`**: `'GSM'`|`'CDMA'`|`'iDEN'`|`'UMTS'`|`'CDMA2000'`|`'EDGE'`|`'GPRS'`|`'HSPA'`|`'LTE'`|`'5G'`|`'Unknown'`

            The network type.

        * `signalStrength`: [**`Number`**](#number) [🔒](#symbols)

            **`range`**: `-1–5`

            The signal strength. As with the battery plugin, `-1` means the device is not available. Values `0` through `5` describe the coarse strength of the signal.

#### `kdeconnect.connectivity_report.request`

⚠️ Deprecated: This packet is sent to request a connectivity report.

```js
{
    "id": 0,
    "type": "kdeconnect.connectivity_report.request",
    "body": {}
}
```

This packet has no body fields.

## Contacts Plugin

The Contacts plugin allows devices to share contacts in vCard format.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/contacts>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/ContactsPlugin>

### Packets

#### `kdeconnect.contacts.request_all_uids_timestamps`

This packet is a request for a list of contact UIDs with modification timestamps.

```js
{
    "id": 0,
    "type": "kdeconnect.contacts.request_all_uids_timestamps",
    "body": {}
}
```

This packet has no body fields.

#### `kdeconnect.contacts.request_vcards_by_uid`

This packet is a request for a list of contact UIDs with vCard data.

```js
{
    "id": 0,
    "type": "kdeconnect.contacts.request_vcards_by_uid",
    "body": {
        "uids": [
            "test-contact1",
            "test-contact2"
        ]
    }
}
```

* `uids`: [**`Array`**](#array) of [**`String`**](#string) [🔒](#symbols)

    A list of contact UIDs.

#### `kdeconnect.contacts.response_uids_timestamps`

This packet is a list of contact UIDs with modification timestamps.

```js
{
    "id": 0,
    "type": "kdeconnect.contacts.response_all_uids_timestamps",
    "body": {
        "uids": [
            "test-contact1",
            "test-contact2"
        ],
        "test-contact1": 1608700784336,
        "test-contact2": 1608700782848
    }
}
```

* `uids`: [**`Array`**](#array) of [**`String`**](#string) [🔒](#symbols)

    A list of contact UIDs. Each UID has a corresponding uid-timestamp pair in the body object.

#### `kdeconnect.contacts.response_vcards`

This packet is a list of contact UIDs with vCard data.

```js
{
    "id": 0,
    "type": "kdeconnect.contacts.response_vcards",
    "body": {
        "uids": [
            "test-contact1",
            "test-contact2"
        ],
        "test-contact1": "BEGIN:VCARD\nVERSION:2.1\nFN:Contact One\nTEL;CELL:123-456-7890\nX-KDECONNECT-ID-DEV-test-device:test-contact1\nX-KDECONNECT-TIMESTAMP:1608700784336\nEND:VCARD",
        "test-contact2": "BEGIN:VCARD\nVERSION:2.1\nFN:Contact Two\nTEL;CELL:123-456-7891\nX-KDECONNECT-ID-DEV-test-device:test-contact2\nX-KDECONNECT-TIMESTAMP:1608700782848\nEND:VCARD"
    }
}
```

* `uids`: [**`Array`**](#array) of [**`String`**](#string) [🔒](#symbols)

    A list of contact UIDs. Each UID has a corresponding uid-vcard pair in the body object.

## FindMyPhone Plugin

The FindMyPhone plugin allows requesting a device to announce it's location, usually by playing a sound like a traditional cordless phone.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/findmyphone>
* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/findthisdevice>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/FindMyPhonePlugin>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/FindRemoteDevicePlugin>
* <https://invent.kde.org/network/kdeconnect-ios/tree/master/KDE%20Connect/KDE%20Connect/Plugins%20and%20Plugin%20Views/FindMyPhone>

### Packets

#### `kdeconnect.findmyphone.request`

This packet is a request for a device to announce its location. By convention, sending a second packet cancels the request.

```js
{
    "id": 0,
    "type": "kdeconnect.findmyphone.request",
    "body": {}
}
```

This packet has no body fields.

## Lock

The Lock plugin allows requesting a device to lock or unlock.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/lockdevice>

### Packets

#### `kdeconnect.lock`

This packet is a lock status update.

```js
{
    "id": 0,
    "type": "kdeconnect.lock",
    "body": {
        "isLocked": true
    }
}
```

* `isLocked`: [**`Boolean`**](#boolean) [🔒](#symbols)

    Indicates the current locked status of the device. If `true` the device is locked and `false` if unlocked.

#### `kdeconnect.lock.request`

This packet is a request for a lock status update or change.

```js
{
    "id": 0,
    "type": "kdeconnect.lock.request",
    "body": {
        "requestLocked": true
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.lock.request",
    "body": {
        "setLocked": false
    }
}
```

* `requestLocked`: [**`Boolean`**](#boolean)

    **`enum`**: `True`

    Indicates this is a request for the current locked status. Always true, if present.

* `setLocked`: [**`Boolean`**](#boolean)

    A request to change the locked status. If `true` the device will be locked or if `false` unlocked.

## MousePad Plugin

The MousePad plugin allows remote control of the pointer and keyboard.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/mousepad>
* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/remotecontrol>
* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/remotekeyboard>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/MousePadPlugin>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/MouseReceiverPlugin>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/RemoteKeyboardPlugin>
* <https://invent.kde.org/network/kdeconnect-ios/tree/master/KDE%20Connect/KDE%20Connect/Plugins%20and%20Plugin%20Views/RemoteInput>

### Packets

#### `kdeconnect.mousepad.echo`

This packet is an echo for a `kdeconnect.mousepad.request` packet.

```js
{
    "id": 0,
    "type": "kdeconnect.mousepad.echo",
    "body": {
        "key": "a",
        "isAck": true
    }
}
```

* `key`: [**`String`**](#string)

    A request to press-release a single readable character, which may be a unicode character and thus more than one byte.

* `specialKey`: [**`Number`**](#number)

    **`range`**: `0–32`

    A request to press-release a single non-printable character, usually a control character or function key such as Backspace or F10.

* `alt`: [**`Boolean`**](#boolean)

    Indicates whether the Alt modifier should be applied to the associated `key` or `specialKey`.

* `ctrl`: [**`Boolean`**](#boolean)

    Indicates whether the Control modifier should be applied to the associated `key` or `specialKey`.

* `shift`: [**`Boolean`**](#boolean)

    Indicates whether the Shift modifier should be applied to the associated `key` or `specialKey`.

* `super`: [**`Boolean`**](#boolean)

    Indicates whether the Super modifier should be applied to the associated `key` or `specialKey`.

* `singleclick`: [**`Boolean`**](#boolean)

    A single press-release of the primary pointer button.

* `doubleclick`: [**`Boolean`**](#boolean)

    A double press-release of the primary pointer button.

* `middleclick`: [**`Boolean`**](#boolean)

    A single press-release of the middle pointer button.

* `rightclick`: [**`Boolean`**](#boolean)

    A single press-release of the secondary pointer button.

* `singlehold`: [**`Boolean`**](#boolean)

    A single press of the primary pointer button.

* `singlerelease`: [**`Boolean`**](#boolean)

    A single release of the primary pointer button.

* `dx`: [**`Number`**](#number)

    A double precision integer indicating a relative position delta for the pointer on the X-axis.

* `dy`: [**`Number`**](#number)

    A double precision integer indicating a relative position delta for the pointer on the Y-axis.

* `scroll`: [**`Boolean`**](#boolean)

    Whether the associated `dx` or `dy` movement is a scroll event.

* `isAck`: [**`Boolean`**](#boolean) [🔒](#symbols)

    Indicates the packet is a confirmation of a request. Always `true` and always present.

#### `kdeconnect.mousepad.keyboardstate`

This packet is a keyboard status update.

```js
{
    "id": 0,
    "type": "kdeconnect.mousepad.keyboardstate",
    "body": {
        "state": true
    }
}
```

* `state`: [**`Boolean`**](#boolean) [🔒](#symbols)

    Indicates the keyboard is ready to receive keypress events.

#### `kdeconnect.mousepad.request`

This packet is a request for a pointer or keyboard event.

```js
{
    "id": 0,
    "type": "kdeconnect.mousepad.request",
    "body": {
        "key": "a",
        "sendAck": true
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.mousepad.request",
    "body": {
        "dx": 1.0,
        "dy": -1.0
    }
}
```

* `key`: [**`String`**](#string)

    A request to press-release a single readable character, which may be a unicode character and thus more than one byte.

* `specialKey`: [**`Number`**](#number)

    **`range`**: `0–32`

    A request to press-release a single non-printable character, usually a control character or function key such as Backspace or F10.

* `alt`: [**`Boolean`**](#boolean)

    Indicates whether the Alt modifier should be applied to the associated `key` or `specialKey`.

* `ctrl`: [**`Boolean`**](#boolean)

    Indicates whether the Control modifier should be applied to the associated `key` or `specialKey`.

* `shift`: [**`Boolean`**](#boolean)

    Indicates whether the Shift modifier should be applied to the associated `key` or `specialKey`.

* `super`: [**`Boolean`**](#boolean)

    Indicates whether the Super modifier should be applied to the associated `key` or `specialKey`.

* `singleclick`: [**`Boolean`**](#boolean)

    A single press-release of the primary pointer button.

* `doubleclick`: [**`Boolean`**](#boolean)

    A double press-release of the primary pointer button.

* `middleclick`: [**`Boolean`**](#boolean)

    A single press-release of the middle pointer button.

* `rightclick`: [**`Boolean`**](#boolean)

    A single press-release of the secondary pointer button.

* `singlehold`: [**`Boolean`**](#boolean)

    A single press of the primary pointer button.

* `singlerelease`: [**`Boolean`**](#boolean)

    A single release of the primary pointer button.

* `dx`: [**`Number`**](#number)

    A double precision integer indicating a position delta on the X-axis.

* `dy`: [**`Number`**](#number)

    A double precision integer indicating a position delta on the Y-axis.

* `scroll`: [**`Boolean`**](#boolean)

    Whether the associated `dx` or `dy` movement is a scroll event.

* `sendAck`: [**`Boolean`**](#boolean)

    Indicates that the devices wants a `kdeconnect.mousepad.echo` packet as confirmation of a keyboard event.

## MPRIS Plugin

The MPRIS plugin allows sharing control of media players.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/mpriscontrol>
* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/mprisremote>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/MprisPlugin>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/MprisReceiverPlugin>

### Packets

#### `kdeconnect.mpris`

This packet is used to expose media players to a remote device and transfer album art.

```js
{
    "id": 0,
    "type": "kdeconnect.mpris",
    "body": {
        "playerList": [
            "Test Player"
        ],
        "supportAlbumArtPayload": true
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.mpris",
    "body": {
        "player": "Test Player",
        "canPause": true,
        "canPlay": true,
        "canGoNext": true,
        "canGoPrevious": false,
        "canSeek": true,
        "isPlaying": true,
        "pos": 0,
        "albumArtUrl": "file:///path/to/image.png",
        "nowPlaying": "Unknown",
        "artist": "Test Artist",
        "title": "Test Title",
        "album": "Test Album",
        "length": 180000,
        "volume": 100
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.mpris",
    "body": {
        "player": "Test Player",
        "albumArtUrl": "file:///path/to/image.png",
        "transferringAlbumArt": true
    },
    "payloadSize": 882,
    "payloadTransferInfo": {
        "port": 1739
    }
}
```

* `playerList`: [**`Array`**](#array) of [**`String`**](#string)

    A list of player names.

* `player`: [**`String`**](#string)

    A player name. This field is used to target a player.

* `canPause`: [**`Boolean`**](#boolean)

    Can pause.

* `canPlay`: [**`Boolean`**](#boolean)

    Can play.

* `canGoNext`: [**`Boolean`**](#boolean)

    Can go next.

* `canGoPrevious`: [**`Boolean`**](#boolean)

    Can go previous.

* `canSeek`: [**`Boolean`**](#boolean)

    Can seek.

* `isPlaying`: [**`Boolean`**](#boolean)

    Whether playback is active.

* `loopStatus`: [**`String`**](#string)

    **`enum`**: `'None'`|`'Track'`|`'Playlist'`

    The loop status.

* `shuffle`: [**`Boolean`**](#boolean)

    Whether shuffle is enabled.

* `pos`: [**`Number`**](#number)

    **`range`**: Unrestricted

    Current track position (ms).

* `albumArtUrl`: [**`String`**](#string)

    Current track album art URL.

* `nowPlaying`: [**`String`**](#string)

    ⚠️ Deprecated: An inclusive string of the format 'Artist - Title'.

* `artist`: [**`String`**](#string)

    Current track artist.

* `title`: [**`String`**](#string)

    Current track title.

* `album`: [**`String`**](#string)

    Current track album.

* `length`: [**`Number`**](#number)

    Current track length (ms).

* `volume`: [**`Number`**](#number)

    **`range`**: `0–100`

    Current player volume (%).

* `supportAlbumArtPayload`: [**`Boolean`**](#boolean)

    Indicates this device supports album art payloads. This field should be set when responding with a list of players.

* `transferringAlbumArt`: [**`Boolean`**](#boolean)

    Indicates this packet carries an album art payload.

#### `kdeconnect.mpris.request`

This packet is used to request the status of remote media players, issue commands, and request the transfer of album art payloads.

```js
{
    "id": 0,
    "type": "kdeconnect.mpris.request",
    "body": {
        "requestPlayerList": true
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.mpris.request",
    "body": {
        "player": "Test Player",
        "requestNowPlaying": true,
        "requestVolume": true
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.mpris.request",
    "body": {
        "player": "Test Player",
        "action": "Play"
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.mpris.request",
    "body": {
        "player": "Test Player",
        "albumArtUrl": "file:///path/to/image.png"
    }
}
```

* `player`: [**`String`**](#string)

    The player name

* `requestNowPlaying`: [**`Boolean`**](#boolean)

    Whether the current status is requested.

* `requestPlayerList`: [**`Boolean`**](#boolean)

    Whether the player list is requested.

* `requestVolume`: [**`Boolean`**](#boolean)

    Whether the current volume is requested.

* `Seek`: [**`Number`**](#number)

    A request to seek relative to the current position (us).

* `setLoopStatus`: [**`String`**](#string)

    **`enum`**: `'None'`|`'Track'`|`'Playlist'`

    A request to set the loop status.

* `SetPosition`: [**`Number`**](#number)

    **`range`**: Unrestricted

    A request to set the track position (ms).

* `setShuffle`: [**`Boolean`**](#boolean)

    A request to set the shuffle mode.

* `setVolume`: [**`Number`**](#number)

    **`range`**: `0–100`

    A request to set the player volume.

* `action`: [**`String`**](#string)

    **`enum`**: `'Pause'`|`'Play'`|`'PlayPause'`|`'Stop'`|`'Next'`|`'Previous'`

    A request to activate a player action.

## Notification Plugin

The Notification plugin syncs notifications between devices.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/notifications>
* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/sendnotifications>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/NotificationsPlugin>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/ReceiveNotificationsPlugin>

### Packets

#### `kdeconnect.notification`

This packet is a notification.

```js
{
    "id": 0,
    "type": "kdeconnect.notification",
    "body": {
        "id": "notification-id",
        "title": "Information",
        "text": "Something happened",
        "ticker": "Information: Something happened",
        "appName": "Terminal",
        "isClearable": true,
        "onlyOnce": false,
        "silent": true,
        "requestReplyId": "17499937-334b-4704-9c2c-24a0bcd4155a",
        "time": "1631436143331",
        "actions": [
            "Ignore",
            "Open"
        ],
        "payloadHash": "d97f60d052bf11d1e88821e04fff0007"
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.notification",
    "body": {
        "id": "notification-id",
        "isCancel": true
    }
}
```

* `id`: [**`String`**](#string) [🔒](#symbols)

    The notification ID.

* `isCancel`: [**`Boolean`**](#boolean)

    If `true` the notification with the indicated ID has been closed.

* `isClearable`: [**`Boolean`**](#boolean)

    If `true` the notification with the indicated ID can be closed.

* `onlyOnce`: [**`Boolean`**](#boolean)

    If `true` the notification should only be sent the first time it's received, otherwise it should be re-sent each time. See the `silent` field for determining whether a notification is new or not.

* `silent`: [**`Boolean`**](#boolean)

    If `true` the notification is preexisting, otherwise the remote device just received it.

* `time`: [**`String`**](#string)

    A UNIX epoch timestamp (ms) in string form.

* `appName`: [**`String`**](#string) [🔒](#symbols)

    The notifying application name.

* `ticker`: [**`String`**](#string) [🔒](#symbols)

    The notification title and text in a single string.

* `title`: [**`String`**](#string) [🔒](#symbols)

    The notification title.

* `text`: [**`String`**](#string) [🔒](#symbols)

    The notification body.

* `payloadHash`: [**`String`**](#string)

    An MD5 hash of the notification icon. If the packet contains this field, it will be accompanied by payload transfer information.

* `actions`: [**`Array`**](#array) of [**`String`**](#string)

    A list of action names for the notification. Respond with `kdeconnect.notification.action` to activate.

* `requestReplyId`: [**`String`**](#string)

    The UUID for repliable notifications (eg. chat). Respond with `kdeconnect.notification.reply` to reply.

#### `kdeconnect.notification.action`

This packet is an activation of a notification action.

```js
{
    "id": 0,
    "type": "kdeconnect.notification.action",
    "body": {
        "key": "notification-id",
        "action": "Open"
    }
}
```

* `key`: [**`String`**](#string) [🔒](#symbols)

    The notification ID.

* `action`: [**`String`**](#string) [🔒](#symbols)

    The notification action name.

#### `kdeconnect.notification.reply`

This packet is a reply for a repliable notification.

```js
{
    "id": 0,
    "type": "kdeconnect.notification.reply",
    "body": {
        "requestReplyId": "reply-id",
        "message": "Reply text"
    }
}
```

* `message`: [**`String`**](#string) [🔒](#symbols)

    The message to reply with.

* `requestReplyId`: [**`String`**](#string) [🔒](#symbols)

    The reply ID of the notification.

#### `kdeconnect.notification.request`

This packet is a request for notifications.

```js
{
    "id": 0,
    "type": "kdeconnect.notification.request",
    "body": {
        "cancel": "notification-id"
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.notification.request",
    "body": {
        "request": true
    }
}
```

* `cancel`: [**`String`**](#string)

    If present, holds the ID of a notification that should be closed.

* `request`: [**`Boolean`**](#boolean)

    Indicates this is a request for the notifications.

## Ping Plugin

The Ping plugin allows sending and receiving simple 'pings', with an optional message. Usually these are displayed as notifications.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/ping>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/PingPlugin>
* <https://invent.kde.org/network/kdeconnect-ios/tree/master/KDE%20Connect/KDE%20Connect/Plugins%20and%20Plugin%20Views/Ping>

### Packets

#### `kdeconnect.ping`

This packet is a ping request.

```js
{
    "id": 0,
    "type": "kdeconnect.ping",
    "body": {
        "message": "A message"
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.ping",
    "body": {}
}
```

* `message`: [**`String`**](#string)

    An optional message.

## Presenter Plugin

The Presenter plugin allows sending and receiving simple 'pings', with an optional message. Usually these are displayed as notifications.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/presenter>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/PresenterPlugin>
* <https://invent.kde.org/network/kdeconnect-ios/tree/master/KDE%20Connect/KDE%20Connect/Plugins%20and%20Plugin%20Views/Presenter>

### Packets

#### `kdeconnect.presenter`

This packet is a presentation remote event.

```js
{
    "id": 0,
    "type": "kdeconnect.presenter",
    "body": {
        "dx": 1.0,
        "dy": 1.0
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.presenter",
    "body": {
        "stop": true
    }
}
```

* `dx`: [**`Number`**](#number)

    A double precision integer indicating a position delta on the X-axis.

* `dy`: [**`Number`**](#number)

    A double precision integer indicating a position delta on the Y-axis.

* `stop`: [**`Boolean`**](#boolean)

    Stop controlling the virtual pointer.

## RunCommand Plugin

The RunCommand plugin allows defining and executing remote commands.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/remotecommands>
* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/runcommand>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/RunCommandPlugin>
* <https://invent.kde.org/network/kdeconnect-ios/tree/master/KDE%20Connect/KDE%20Connect/Plugins%20and%20Plugin%20Views/RunCommand>

### Packets

#### `kdeconnect.runcommand`

This packet is a list of available commands.

```js
{
    "id": 0,
    "type": "kdeconnect.runcommand",
    "body": {
        "commandList": "{\"command-id1\": {\"name\": \"Command\",\"command\": \"/path/to/command1\"}}"
    }
}
```

* `commandList`: [**`String`**](#string) [🔒](#symbols)

    A serialized dictionary of commands that the device offers. The key is sent in a `kdeconnect.runcommand.request` packet to execute its corresponding command. Each value has a `name` field and a `command` field.

#### `kdeconnect.runcommand.request`

This packet is a runcommand status update.

```js
{
    "id": 0,
    "type": "kdeconnect.runcommand.request",
    "body": {
        "key": "bea9fb3e-0c80-4d05-afdc-6a8f4156bc03"
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.runcommand.request",
    "body": {
        "requestCommandList": true
    }
}
```

* `key`: [**`String`**](#string)

    If the packet body contains this field it is a request to execute the command with the ID `key`.

* `requestCommandList`: [**`Boolean`**](#boolean)

    If the packet body contains this field it is a request for the command list.

## SFTP Plugin

The SFTP plugin enables secure file sharing with SFTP.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/sftp>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/SftpPlugin>

### Packets

#### `kdeconnect.sftp`

This packet contains SFTP login information.

```js
{
    "id": 0,
    "type": "kdeconnect.sftp",
    "body": {
        "ip": "192.168.1.71",
        "port": 1743,
        "user": "kdeconnect",
        "password": "UzcNCrI7T668JyxUFjOxQncBPNcO",
        "path": "/storage/emulated/0",
        "multiPaths": [
            "/storage/0000-0000",
            "/storage/0000-0000/DCIM/Camera",
            "/storage/emulated/0",
            "/storage/emulated/0/DCIM/Camera"
        ],
        "pathNames": [
            "SD Card",
            "Camera Pictures (SD Card)",
            "All files",
            "Camera pictures"
        ]
    }
}
```

* `errorMessage`: [**`String`**](#string)

    An error message.

* `ip`: [**`String`**](#string) [🔒](#symbols)

    The host address.

* `port`: [**`Number`**](#number) [🔒](#symbols)

    The host port.

* `user`: [**`String`**](#string) [🔒](#symbols)

    The user. Currently always `kdeconnect`.

* `password`: [**`String`**](#string) [🔒](#symbols)

    The one-time password. ⚠️ Deprecated: use private key authentication via the TLS certificate.

* `path`: [**`String`**](#string) [🔒](#symbols)

    The base path of the remote server. This should generally only be used as a fallback if the `multiPaths` field is missing.

* `multiPaths`: [**`Array`**](#array) of [**`String`**](#string) [🔒](#symbols)

    An ordered list of paths for the remote server. Usually contains at least a 'root' directory and a path the the camera folder, but may contain additional paths to external storage devices.

* `pathNames`: [**`Array`**](#array) of [**`String`**](#string) [🔒](#symbols)

    An ordered list of names associated with the paths in `multiPaths`, in the same order.

#### `kdeconnect.sftp.request`

This packet is a request to start SFTP.

```js
{
    "id": 0,
    "type": "kdeconnect.sftp.request",
    "body": {
        "startBrowsing": true
    }
}
```

* `startBrowsing`: [**`Boolean`**](#boolean) [🔒](#symbols)

    A request for the remote device to prepare for SFTP and respond with a `kdeconnect.sftp` packet.

## Share Plugin

The Share plugin allows sharing files, text content and URLs.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/share>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/SharePlugin>
* <https://invent.kde.org/network/kdeconnect-ios/tree/master/KDE%20Connect/KDE%20Connect/Plugins%20and%20Plugin%20Views/Share>

### Packets

#### `kdeconnect.share.request`

This packet is an upload request.

```js
{
    "id": 0,
    "type": "kdeconnect.share.request",
    "body": {
        "filename": "image.png"
    },
    "payloadSize": 882,
    "payloadInfo": {
        "port": 1739
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.share.request",
    "body": {
        "text": "Some text"
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.share.request",
    "body": {
        "url": "https://kdeconnect.kde.org"
    }
}
```

* `filename`: [**`String`**](#string)

    Name of the file being transferred. If the packet contains this field, it will be accompanied by payload transfer information.

* `creationTime`: [**`Number`**](#number)

    Creation time of the file being transferred as a UNIX epoch timestamp (ms).

* `lastModified`: [**`Number`**](#number)

    Modification time of the file being transferred as a UNIX epoch timestamp (ms).

* `open`: [**`Boolean`**](#boolean)

    Whether a received file should be opened when the transfer completes.

* `numberOfFiles`: [**`Number`**](#number)

    Number of files in a composite file transfer.

* `totalPayloadSize`: [**`Number`**](#number)

    Total size in bytes of a composite file transfer.

* `text`: [**`String`**](#string)

    Text content being shared. The receiving device decides how to present to text to the user.

* `url`: [**`String`**](#string)

    URL being shared. The receiving device will typically open the URL with the default handler for the URI scheme.

#### `kdeconnect.share.request.update`

This packet is the metadata for a multi-file transfer. By convention it is sent in advance of the packets containing the payload, which will include the same fields, potentially with updated totals.

```js
{
    "id": 0,
    "type": "kdeconnect.share.request.update",
    "body": {
        "numberOfFiles": 1,
        "totalPayloadSize": 4096
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.share.request.update",
    "body": {
        "numberOfFiles": 2,
        "totalPayloadSize": 8192
    }
}
```

* `numberOfFiles`: [**`Number`**](#number)

    Number of files in a multi-file transfer.

* `totalPayloadSize`: [**`Number`**](#number)

    Total size in bytes of a multi-file transfer.

## SMS Plugin

The SMS plugin allows sending and receiving SMS/MMS messages.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/sms>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/SMSPlugin>
* <https://invent.kde.org/network/kdeconnect-android/blob/master/src/org/kde/kdeconnect/Helpers/SMSHelper.java>

### Packets

#### `kdeconnect.sms.attachment_file`

This packet is a message attachment transfer.

```js
{
    "id": 0,
    "type": "kdeconnect.sms.attachment_file",
    "body": {
        "filename": "image.png"
    },
    "payloadSize": 882,
    "payloadTransferInfo": {
        "port": 1739
    }
}
```

* `filename`: [**`String`**](#string) [🔒](#symbols)

    The name of the file being transferred.

#### `kdeconnect.sms.messages`

This packet is a list of messages.

```js
{
    "id": 0,
    "type": "kdeconnect.sms.messages",
    "body": {
        "messages": [
            {
                "addresses": [
                    {
                        "address": "+1-234-567-8912"
                    }
                ],
                "attachments": [
                    {
                        "part_id": 190,
                        "mime_type": "image/jpeg",
                        "encoded_thumbnail": "iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAIAAAB7GkOtAAAACXBIWXMAAC4jAAAuIwF4pT92AAAAB3RJTUUH5AkCAgMHUNVLwAAAAxFJREFUeNrtwYEAAAAAw6D5U1/hAFUBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAbwK0AAH/2ARQAAAAAElFTkSuQmCC",
                        "unique_identifier": "PART_1624666113891_image000000.jpg"
                    }
                ],
                "body": "Thread 1, Message 2",
                "date": 2,
                "type": 2,
                "read": 1,
                "thread_id": 1,
                "_id": 2,
                "sub_id": 1,
                "event": 1
            },
            {
                "addresses": [
                    {
                        "address": "+1-234-567-8914"
                    }
                ],
                "body": "Message one",
                "date": 3,
                "type": 2,
                "read": 1,
                "thread_id": 2,
                "_id": 3,
                "sub_id": 1,
                "event": 1
            }
        ],
        "version": 2
    }
}
```

* `messages`: [**`Array`**](#array) of **`Message`** [🔒](#symbols)

    A list of messages.

    * **`Message`** ([**`Object`**](#object))

        A message object.

        * `_id`: [**`Number`**](#number) [🔒](#symbols)

            The message ID.

        * `addresses`: [**`Array`**](#array) of **`Address`** [🔒](#symbols)

            A list of participating contacts. If the message is incoming, the first `Address` will be the sender. If the message is outgoing, every `Address` will be a recipient.

            * **`Address`** ([**`Object`**](#object))

                An object representing a phone number or other contact method.

                * `address`: [**`String`**](#string)

                    A free-form address string. Usually a phone number or e-mail address.

        * `attachments`: [**`Array`**](#array) of **`Attachment`**

            A list of message attachments.

            * **`Attachment`** ([**`Object`**](#object))

                A file attachment. Send the `part_id` and `unique_identifier` with a `kdeconnect.sms.request_attachment` packet to transfer the full file.

                * `part_id`: [**`Number`**](#number) [🔒](#symbols)

                    The ID of the attachment.

                * `mime_type`: [**`String`**](#string) [🔒](#symbols)

                    The mime-type of the attachment.

                * `encoded_thumbnail`: [**`String`**](#string) [🔒](#symbols)

                    A base64 encoded preview of the attachment.

                * `unique_identifier`: [**`String`**](#string) [🔒](#symbols)

                    Unique name of the file.

        * `body`: [**`String`**](#string)

            The message body.

        * `date`: [**`Number`**](#number) [🔒](#symbols)

            A UNIX epoch timestamp (ms) for the message.

        * `event`: [**`Number`**](#number)

            The event type. `1` for 'text', `2` for 'multi-target'.

        * `read`: [**`Number`**](#number)

            **`enum`**: `0`|`1`

            Whether the message is read or not.

        * `sub_id`: [**`Number`**](#number)

            **`range`**: Unrestricted

            The SIM card or subscription ID.

        * `thread_id`: [**`Number`**](#number) [🔒](#symbols)

            **`range`**: Unrestricted

            The thread ID.

        * `type`: [**`Number`**](#number) [🔒](#symbols)

            **`range`**: `0–6`

            The message status. Typically either `1` (inbox) or `2` (sent). See Android's `Telephony.TextBasedSmsColumns` message type enumeration.

* `version`: [**`Number`**](#number)

    **`enum`**: `2`

    The version of SMS protocol in use.

#### `kdeconnect.sms.request`

This packet is a request to send an SMS/MMS message.

```js
{
    "id": 0,
    "type": "kdeconnect.sms.request",
    "body": {
        "addresses": [
            {
                "address": "+1-234-567-8901"
            }
        ],
        "attachments": [
            {
                "fileName": "image.jpeg",
                "base64EncodeFile": "iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAIAAAB7GkOtAAAACXBIWXMAAC4jAAAuIwF4pT92AAAAB3RJTUUH5AkCAgMHUNVLwAAAAxFJREFUeNrtwYEAAAAAw6D5U1/hAFUBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAbwK0AAH/2ARQAAAAAElFTkSuQmCC",
                "mimeType": "image/jpeg"
            }
        ],
        "messageBody": "Outgoing message",
        "subID": 1,
        "version": 2
    }
}
```

* `addresses`: [**`Array`**](#array) of **`Address`** [🔒](#symbols)

    A list of target contacts.

    * **`Address`** ([**`Object`**](#object))

        An object representing a phone number or other contact method.

        * `address`: [**`String`**](#string)

            A free-form address string. Usually a phone number or e-mail address.

* `attachments`: [**`Array`**](#array) of **`Outgoing Attachment`**

    None

    * **`Outgoing Attachment`** ([**`Object`**](#object))

        None

        * `fileName`: [**`String`**](#string)

            A file name.

        * `base64EncodedFile`: [**`String`**](#string)

            Base64 encoded data.

        * `mimeType`: [**`String`**](#string)

            A mime-type string.

* `messageBody`: [**`String`**](#string) [🔒](#symbols)

    None

* `subID`: [**`Number`**](#number)

    The SIM card or account to send with.

* `version`: [**`Number`**](#number)

    **`enum`**: `2`

    The version of SMS protocol in use.

#### `kdeconnect.sms.request_attachment`

This packet is a request for a message attachment.

```js
{
    "id": 0,
    "type": "kdeconnect.sms.request_attachment",
    "body": {
        "part_id": 190,
        "unique_identifier": "PART_1624666113891_image000000.jpg"
    }
}
```

* `part_id`: [**`Number`**](#number) [🔒](#symbols)

    The ID of the attachment.

* `unique_identifier`: [**`String`**](#string) [🔒](#symbols)

    Unique name of the file.

#### `kdeconnect.sms.request_conversation`

This packet is a request for messages from a thread.

```js
{
    "id": 0,
    "type": "kdeconnect.sms.request_conversation",
    "body": {
        "threadID": 42
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.sms.request_conversation",
    "body": {
        "threadID": 42,
        "rangeStartTimestamp": 1643990699000,
        "numberToRequest": 10
    }
}
```

* `threadID`: [**`Number`**](#number) [🔒](#symbols)

    **`range`**: Unrestricted

    The thread ID.

* `rangeStartTimestamp`: [**`Number`**](#number)

    **`range`**: Unrestricted

    UNIX epoch timestamp (ms) for the earliest message.

* `numberToRequest`: [**`Number`**](#number)

    **`range`**: Unrestricted

    The maximum number of messages to return.

#### `kdeconnect.sms.request_conversations`

This packet is a request for the latest message in each thread.

```js
{
    "id": 0,
    "type": "kdeconnect.sms.request_conversations",
    "body": {}
}
```

This packet has no body fields.

## SystemVolume Plugin

The SystemVolume plugin allows sharing volume controls between devices.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/remotesystemvolume>
* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/systemvolume>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/SystemVolumePlugin>

### Packets

#### `kdeconnect.systemvolume`

This packet is a mixer stream state update.

```js
{
    "id": 0,
    "type": "kdeconnect.systemvolume",
    "body": {
        "sinkList": [
            {
                "name": "alsa_output.pci-0000_00_1b.0.analog-stereo",
                "description": "Built-in Audio Analog Stereo",
                "muted": false,
                "volume": 32768,
                "maxVolume": 65536,
                "enabled": false
            }
        ]
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.systemvolume",
    "body": {
        "name": "alsa_output.pci-0000_00_1b.0.analog-stereo",
        "volume": 49,
        "muted": false,
        "enabled": true
    }
}
```

* `sinkList`: [**`Array`**](#array) of **`Stream`**

    The list of audio streams.

    * **`Stream`** ([**`Object`**](#object))

        An audio stream object

        * `name`: [**`String`**](#string) [🔒](#symbols)

            The stream name.

        * `description`: [**`String`**](#string) [🔒](#symbols)

            The stream display name.

        * `enabled`: [**`Boolean`**](#boolean)

            Whether the stream is enabled.

        * `muted`: [**`Boolean`**](#boolean) [🔒](#symbols)

            Whether the stream is muted.

        * `maxVolume`: [**`Number`**](#number)

            The stream max volume level.

        * `volume`: [**`Number`**](#number) [🔒](#symbols)

            The stream volume level.

* `name`: [**`String`**](#string)

    The stream name.

* `enabled`: [**`Boolean`**](#boolean)

    Whether the stream is enabled.

* `muted`: [**`Boolean`**](#boolean)

    Whether the stream is muted.

* `volume`: [**`Number`**](#number)

    The stream volume level.

#### `kdeconnect.systemvolume.request`

This packet is a audio stream request. It is used to request both the list of streams and changes to those streams.

```js
{
    "id": 0,
    "type": "kdeconnect.systemvolume.request",
    "body": {
        "requestSinks": true
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.systemvolume.request",
    "body": {
        "name": "alsa_output.pci-0000_00_1b.0.analog-stereo",
        "volume": 49,
        "muted": false,
        "enabled": true
    }
}
```

* `requestSinks`: [**`Boolean`**](#boolean)

    Indicates this is a request for the stream list.

* `name`: [**`String`**](#string)

    The name of a stream. If the packet contains this field, it is a request to adjust a stream.

* `enabled`: [**`Boolean`**](#boolean)

    Indicates the stream should become the active default. Always true if present.

* `muted`: [**`Boolean`**](#boolean)

    The requested mute state.

* `volume`: [**`Number`**](#number)

    **`range`**: Unrestricted

    The requested volume. The maximum value is provided by the `maxVolume` field of the stream.

## Telephony Plugin

The Telephony plugin allows notification of events such as incoming or missed calls.

### References

* <https://invent.kde.org/network/kdeconnect-kde/tree/master/plugins/telephony>
* <https://invent.kde.org/network/kdeconnect-android/tree/master/src/org/kde/kdeconnect/Plugins/TelephonyPlugin>

### Packets

#### `kdeconnect.telephony`

This packet is a telephony event, such as the phone ringing.

Note that both the `sms` event type and the `messageBody` field are deprecated in favor of the SMS plugin.

```js
{
    "id": 0,
    "type": "kdeconnect.telephony",
    "body": {
        "event": "talking",
        "contactName": "John Smith",
        "phoneNumber": "555-555-5555",
        "phoneThumbnail": "<base64 encoded JPEG>"
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.telephony",
    "body": {
        "event": "talking",
        "contactName": "John Smith",
        "phoneNumber": "555-555-5555",
        "isCancel": true
    }
}
```

```js
{
    "id": 0,
    "type": "kdeconnect.telephony",
    "body": {
        "event": "sms",
        "contactName": "John Smith",
        "messageBody": "A text message",
        "phoneNumber": "555-555-5555",
        "phoneThumbnail": "<base64 encoded JPEG>"
    }
}
```

* `event`: [**`String`**](#string) [🔒](#symbols)

    **`enum`**: `'missedCall'`|`'ringing'`|`'talking'`|`'sms'`

    None

* `contactName`: [**`String`**](#string)

    The contact name associated with the event.

* `messageBody`: [**`String`**](#string)

    ⚠️ Deprecated: The message text associated with the event.

* `phoneNumber`: [**`String`**](#string)

    The phone number associated with the event.

* `phoneThumbnail`: [**`String`**](#string)

    base64 encoded JPEG.

* `isCancel`: [**`Boolean`**](#boolean)

    If `event` has stopped.

#### `kdeconnect.telephony.request_mute`

This packet is sent to request the ringer be muted.

```js
{
    "id": 0,
    "type": "kdeconnect.telephony.request_mute",
    "body": {}
}
```

This packet has no body fields.


## Appendix

### Data Types

These are the basic data types in the KDE Connect protocol, as described by the
JSON Schema specification. Note that the `integer` type defined in some versions
of JSON Schema is never used.

#### `Boolean`

A logical data type that can have only the values `true` or `false`.

#### `Number`

A numeric data type in the double-precision 64-bit floating point format
(IEEE 754).

#### `String`

A null-terminated sequence of UTF-8 encoded bytes.

#### `Array`

An ordered collection of values.

#### `Object`

A mapping collection of string keys to values.

#### `Null`

The intentional absence of any object value. Note that this type is currently
unused in the protocol and reserved for future use.

### Symbols

* ⚠️ **Deprecated**

    Clients are free to ignore these packets and fields, and encouraged to stop
    using them when possible.

* 🔒 **Required**

    Packets missing these fields may be ignored or result in undefined
    behaviour.

### References

* <https://json-schema.org>
* <https://datatracker.ietf.org/doc/html/draft-fge-json-schema-validation-00>


