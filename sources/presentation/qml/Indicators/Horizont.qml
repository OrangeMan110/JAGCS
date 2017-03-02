import QtQuick 2.6
import "qrc:/JS/helper.js" as Helper

Item {
    id: horizont

    property int pitch: 0
    property int roll: 0
    property int minPitch: -25
    property int maxPitch: 25

    property int effectiveHeight

    onRollChanged: canvas.requestPaint()
    onPitchChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        width: horizont.width
        height: horizont.height
        onPaint: {
            var ctx = canvas.getContext('2d');

            ctx.clearRect(0, 0, width, height);

            var size = 10000;
            var offset = Helper.mapToRange(pitch, minPitch, maxPitch,
                                           effectiveHeight);

            ctx.save();
            ctx.beginPath();

            ctx.translate(width / 2, height / 2);
            ctx.rotate(-roll * Math.PI / 180);
            ctx.translate(0, offset - effectiveHeight / 2);

            ctx.fillStyle = palette.skyColor;
            ctx.fillRect(-size / 2, -size / 2, size, size / 2);

            ctx.fillStyle = palette.groundColor;
            ctx.fillRect(-size / 2, 0, size, size / 2);

            ctx.lineWidth = 1;
            ctx.strokeStyle = palette.textColor;
            ctx.moveTo(-size / 2, 0);
            ctx.lineTo(size / 2, 0);

            ctx.stroke();
            ctx.restore();
        }
    }
}
