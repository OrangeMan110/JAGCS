import QtQuick 2.6
import QtQuick.Layouts 1.3

import "qrc:/Controls" as Controls

ColumnLayout {
    id: control

    property var menuModel

    signal reqestComponent(string source, string text, var properties)

    function home() {
        repeater.model = menuModel;
    }

    spacing: sizings.spacing

    Repeater {
        id: repeater
        model: menuModel

        Controls.Button {
            text: modelData.text ? modelData.text : ""
            iconSource: modelData.icon ? modelData.icon : ""
            iconColor: modelData.iconColor ? modelData.iconColor : iconColor
            onClicked: {
                if (modelData.source) {
                    reqestComponent(modelData.source, text,
                                    modelData.properties ? modelData.properties : {});

                }
                else if (modelData.menu) {
                    repeater.model = modelData.menu;
                }
            }
            Layout.preferredWidth: sizings.controlBaseSize * 7
            Layout.fillWidth: true
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
