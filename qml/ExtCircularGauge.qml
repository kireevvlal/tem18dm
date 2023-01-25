import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4

CircularGauge {
    id: ecgauge
    property real start: 0
    property real finish: 0
    property bool repaint: true
    property string parameter
    property int valuePrecision: 0
    property int labelPrecision: 0
    property int valueMultiplayer: 1
    style: CircularGaugeStyle {
        id: ecgstyle
        minimumValueAngle: -140
        maximumValueAngle: 140
        tickmarkInset: toPixels(0.1)
        minorTickmarkInset: tickmarkInset
        labelInset: toPixels(0.35)
        tickmarkStepSize: (maximumValue - minimumValue) / 12
        //minorTickmarkCount: 9

        function toPixels(percentage) {
            return percentage * outerRadius;
        }

        function degreesToRadians(degrees) {
            return degrees * (Math.PI / 180);
        }

        function paintBackground(ctx, begin, end) {
            ctx.reset();
            // internal arc
            ctx.beginPath();
            ctx.lineWidth =  1;//tickmarkInset / 2;
            ctx.strokeStyle = "lightgray";
            ctx.arc(outerRadius, outerRadius, outerRadius - toPixels(0.1),
                    degreesToRadians(minimumValueAngle - 90), degreesToRadians(maximumValueAngle - 90));
            ctx.stroke();
            // external arc
            ctx.beginPath();
            ctx.lineWidth =  1;//tickmarkInset / 2;
            ctx.strokeStyle = "lightgray";
            ctx.arc(outerRadius, outerRadius, outerRadius,
                    degreesToRadians(minimumValueAngle - 90), degreesToRadians(maximumValueAngle - 90));
             ctx.stroke();
            // lines
//            ctx.beginPath();
//            ctx.lineWidth =  1;//tickmarkInset / 2;
//            ctx.strokeStyle = "lightgray";
//            ctx.moveTo()
//            ctx.stroke();

            // red sector
            if (begin !== end) {
            ctx.beginPath();
            ctx.lineWidth =  tickmarkInset - 2;
            ctx.strokeStyle = "gray";
            var sAngle = valueToAngle(begin) - 90;
            var eAngle = valueToAngle(end) - 90;
            ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2 - 1, degreesToRadians(sAngle), degreesToRadians(eAngle));
            ctx.stroke();
            }
        }

        background: Canvas {
            id: gaugecanvas
            property real value: ecgauge.value
//            property bool repaint: ecgauge.repaint
            anchors.fill: parent
            onValueChanged: {
                if (ecgauge.repaint) {
                    requestPaint();
                    ecgauge.repaint = false;
                }
            }

//            onRepaintChanged: {
//                if (ecgauge.repaint) {
//                    requestPaint();
//                    ecgauge.repaint = repaint = false;
//                }
//            }

            onPaint: {
                var ctx = getContext("2d");
                paintBackground(ctx, ecgauge.start, ecgauge.finish);
            }
            // Numeric value
            Text {
                color: "lightblue"
                font.bold: true;
                style: Text.Outline
                font.pixelSize: toPixels(0.2) //(0.15)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height - toPixels(0.3)
                text: valuePrecision ? (ecgauge.value * valueMultiplayer).toFixed(valuePrecision) : Math.round(ecgauge.value * valueMultiplayer)
            }
            // unit measure
            Text {
                font.pixelSize: toPixels(0.2) //(0.15)
                //font.bold: true;
                text: ecgauge.parameter
                color: "lightgray"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height / 2 + toPixels(0.15)
            }
        }

        tickmark: Rectangle {
            implicitWidth: outerRadius * 0.02
            antialiasing: true
            implicitHeight: outerRadius * 0.1
            color: "lightgray"
        }

        minorTickmark: Rectangle {
            implicitWidth: outerRadius * 0.015
            antialiasing: true
            implicitHeight: outerRadius * 0.05
            color: "lightgray"
        }

        tickmarkLabel:  Text {
            font.pixelSize: toPixels(0.15) //(0.12)
            //font.bold: true
            //font.italic: true
            text: labelPrecision ? styleData.value.toFixed(labelPrecision) : styleData.value
            color: "lightgray"
            antialiasing: true
        }

        needle: Rectangle {
            //y: outerRadius * 0.15
            implicitWidth: outerRadius * 0.025
            implicitHeight: outerRadius * 0.55
            antialiasing: true
            color: "lightblue"
        }

        foreground: Item {
            Rectangle {
                width: outerRadius * 0.1
                height: width
                radius: width / 2
                color: "lightblue"
                anchors.centerIn: parent
            }
        }
    }
}

