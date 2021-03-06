import QtQuick 2.6
import QtQuick.Layouts 1.3
import JAGCS 1.0

import "qrc:/Controls" as Controls

import "../Vehicles"

Item {
    id: vehicleDisplay

    property int vehicleId: 0

    property AerialVehicle vehicle: AerialVehicle {}

    signal updateCommandStatus(var command, var status)

    implicitWidth: list.contentWidth
    implicitHeight: list.contentHeight + sizings.shadowSize

    Component.onCompleted: manual.setVehicleId(vehicleId)
    Component.onDestruction: manual.setVehicleId(0)

    AerialVehicleDisplayPresenter {
        id: presenter
        view: vehicleDisplay
        Component.onCompleted: setVehicle(vehicleId)
    }

    Connections {
        target: displaysSettingsButton
        onClicked: instrumentsVisibility.visible ? instrumentsVisibility.close() :
                                                   instrumentsVisibility.open()
    }

    ListModel {
        id: instrumentsModel

        ListElement {
            name: qsTr("Diagnostics panel")
            setting: "diagnosticsVisible"
            instrument: "../Instruments/DiagnosticsPanel.qml"
            instrumentVisible: true
        }

        ListElement {
            name: qsTr("Status panel")
            setting: "statusVisible"
            instrument: "../Instruments/StatusPanel.qml"
            instrumentVisible: true
        }

        ListElement {
            name: qsTr("Flight instrument(FD)")
            setting: "fdVisible"
            instrument: "../Instruments/FlightDirector.qml"
            instrumentVisible: true
        }

        ListElement {
            name: qsTr("Horizontal situation indicator(HSI)")
            setting: "hsiVisible"
            instrument: "../Instruments/HorizontalSituationIndicator.qml"
            instrumentVisible: true
        }

        ListElement {
            name: qsTr("Landing indicator")
            setting: "landingVisible"
            instrument: "../Instruments/LandingIndicator.qml"
            instrumentVisible: true
        }

        ListElement {
            name: qsTr("Control panel")
            setting: "controlVisible"
            instrument: "../Instruments/ControlPanel.qml"
            instrumentVisible: true
        }
    }

    Controls.Popup {
        id: instrumentsVisibility
        x: displaysSettingsButton.x
        y: -sizings.padding
        closePolicy: Controls.Popup.CloseOnEscape | Controls.Popup.CloseOnPressOutside
        padding: sizings.padding
        onVisibleChanged: displaysSettingsButton.enabled = !visible

        ColumnLayout {
            spacing: sizings.spacing

            Repeater {
                model: instrumentsModel

                // Replace with Qt 5.10 Action
                Controls.CheckBox {
                    text: name
                    onCheckedChanged: instrumentVisible = checked
                    onClicked: settings.setValue("veh_" + vehicleId + "/" + setting, checked)
                    Component.onCompleted: {
                        checked = settings.boolValue("veh_" + vehicleId + "/" + setting, true);
                        instrumentVisible = checked;
                    }
                }
            }
        }
    }

    ListView {
        id: list
        width: vehicleDisplay.width - sizings.shadowSize
        height: vehicleDisplay.height - sizings.shadowSize
        flickableDirection: Flickable.AutoFlickIfNeeded
        boundsBehavior: Flickable.StopAtBounds
        spacing: sizings.spacing
        model: instrumentsModel

        Controls.ScrollBar.vertical: Controls.ScrollBar {
            visible: parent.contentHeight > parent.height
        }

        delegate: Loader {
            width: parent.width
            active: instrumentVisible
            height: active && item ? item.implicitHeight : -list.spacing
            source: instrument
        }
    }
}
