pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool available: adapter !== null && adapter !== undefined
    readonly property int state: available ? adapter.state : BluetoothAdapterState.Disabled
    readonly property bool enabled: available && adapter.enabled
    readonly property bool busy: state === BluetoothAdapterState.Enabling
        || state === BluetoothAdapterState.Disabling
    readonly property bool blocked: state === BluetoothAdapterState.Blocked

    readonly property var devices: Bluetooth.devices?.values ?? []
    readonly property var connectedDevices: devices.filter(device => device && device.connected)
    readonly property int connectedCount: connectedDevices.length

    readonly property string icon: {
        if (!available || blocked || !enabled) return "󰂲";
        if (connectedCount > 0) return "󰂱";
        return "󰂯";
    }

    readonly property string statusText: {
        if (!available) return "Bluetooth unavailable";
        if (blocked) return "Bluetooth blocked";
        if (busy) return state === BluetoothAdapterState.Enabling ? "Turning on" : "Turning off";
        if (!enabled) return "Bluetooth off";
        if (connectedCount === 1) return connectedDevices[0].name || connectedDevices[0].deviceName || "1 device connected";
        if (connectedCount > 1) return connectedCount + " devices connected";
        return "Bluetooth on";
    }

    function toggle() {
        if (!available || blocked || busy) return;
        adapter.enabled = !adapter.enabled;
    }
}
