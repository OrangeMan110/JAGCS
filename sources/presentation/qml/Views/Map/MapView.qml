import QtQuick 2.6
import QtLocation 5.6
import QtPositioning 5.6

import "Overlays"

Map {
    id: root

    property var lineModel
    property var pointModel
    property var vehicleModel
    property var mouseCoordinate: map.toCoordinate(Qt.point(mouseArea.mouseX,
                                                            mouseArea.mouseY));

    signal saveMapViewport()
    signal picked(var coordinate)

    plugin: Plugin { name: "osm" }
    gesture.flickDeceleration: 3000
    gesture.enabled: true
    activeMapType: supportedMapTypes[5] // TerrainMapType
    copyrightsVisible: false

    Behavior on center {
        CoordinateAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    MissionLineMapOverlayView {
        model: lineModel
    }

    RadiusMapOverlayView {
        model: pointModel
    }

    AcceptanceRadiusMapOverlayView {
        model: pointModel
    }

    MissionPointMapOverlayView {
        model: pointModel
    }

    VehicleMapOverlayView {
        model: vehicleModel
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: bar.coordinate = mouseCoordinate
        onClicked: map.picked(mouseCoordinate)
    }

    MapStatusBar {
        id: bar
        anchors.bottom: parent.bottom
        width: parent.width
    }

    Component.onDestruction: saveMapViewport()

    function setGesturesEnabled(enabled) {
        gesture.acceptedGestures = enabled ?
                    (MapGestureArea.PinchGesture |
                     MapGestureArea.PanGesture |
                     MapGestureArea.FlickGesture) :
                    MapGestureArea.PinchGesture
    }
}
