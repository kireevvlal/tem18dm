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
    property int labelTextSize: 12
    property color limitcolor: "gray"
    property real oldvalue: 0;
    property real digitalvalue: 0;
    style: CircularGaugeStyle {
        id: ecgstyle
        minimumValueAngle: -140
        maximumValueAngle: 140
        tickmarkInset: toPixels(0.1)
        minorTickmarkInset: tickmarkInset
        labelInset: toPixels(0.34)
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
            ctx.lineWidth =  1;
            ctx.strokeStyle = "lightgray";
            ctx.arc(outerRadius, outerRadius, outerRadius - toPixels(0.1),
                    degreesToRadians(minimumValueAngle - 90), degreesToRadians(maximumValueAngle - 90));
            ctx.stroke();
            // external arc
            ctx.beginPath();
            ctx.lineWidth =  1;
            ctx.strokeStyle = "lightgray";
            ctx.arc(outerRadius, outerRadius, outerRadius,
                    degreesToRadians(minimumValueAngle - 90), degreesToRadians(maximumValueAngle - 90));
             ctx.stroke();
            // lines
            // left
            ctx.beginPath();
            ctx.lineWidth =  1;
            ctx.strokeStyle = "lightgray";
            ctx.moveTo(outerRadius -  outerRadius * Math.sin(degreesToRadians(minimumValueAngle +180)),
                       outerRadius + outerRadius * Math.cos(degreesToRadians(minimumValueAngle + 180)))
            ctx.lineTo(outerRadius - (outerRadius - toPixels(0.1)) * Math.sin(degreesToRadians(minimumValueAngle + 180)),
                       outerRadius + (outerRadius - toPixels(0.1)) * Math.cos(degreesToRadians(minimumValueAngle + 180)))
            ctx.stroke()
            // right
            ctx.beginPath();
            ctx.lineWidth =  1;
            ctx.strokeStyle = "lightgray";
            ctx.moveTo(outerRadius + outerRadius * Math.sin(degreesToRadians(180 - maximumValueAngle)),
                       outerRadius + outerRadius * Math.cos(degreesToRadians(180 - maximumValueAngle)))
            ctx.lineTo(outerRadius + (outerRadius - toPixels(0.1)) * Math.sin(degreesToRadians(180 - maximumValueAngle)),
                       outerRadius + (outerRadius - toPixels(0.1)) * Math.cos(degreesToRadians(180 - maximumValueAngle)))
            ctx.stroke()

            // red sector
            if (begin !== end) {
            ctx.beginPath();
            ctx.lineWidth =  tickmarkInset - 2;
            ctx.strokeStyle = ecgauge.limitcolor;
            var sAngle = valueToAngle(begin) - 90;
            var eAngle = valueToAngle(end) - 90;
            ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2 - 1, degreesToRadians(sAngle), degreesToRadians(eAngle));
            ctx.stroke();
            }
        }

        background: Canvas {
            id: gaugecanvas
            property real value: ecgauge.value
            anchors.fill: parent
            onValueChanged: {
                if ((value < ecgauge.start || value > ecgauge.finish)
                        && (ecgauge.oldvalue >= ecgauge.start && ecgauge.oldvalue <= ecgauge.finish))
                    requestPaint();
                if ((value >= ecgauge.start && value <= ecgauge.finish)
                        && (oldvalue < ecgauge.start || oldvalue > ecgauge.finish))
                    requestPaint();

                if (ecgauge.repaint) {
                    requestPaint();
                    ecgauge.repaint = false;
                }
                ecgauge.oldvalue = value;
            }

            onPaint: {
                if (ecgauge.value >= ecgauge.start && ecgauge.value <= ecgauge.finish)
                    ecgauge.limitcolor = "gray";
                else
                    ecgauge.limitcolor = "red";
                var ctx = getContext("2d");
                paintBackground(ctx, ecgauge.start, ecgauge.finish);
            }
            // Numeric value
            Text {
                color: "lightblue"
                font.bold: true;
                style: Text.Outline
                font.pixelSize: toPixels(0.2) //(0.15)
                font.family: main_window.deffntfam
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height - toPixels(0.3)
                text: valuePrecision ? ecgauge.digitalvalue.toFixed(valuePrecision) : Math.round(ecgauge.digitalvalue)
            }
            // unit measure
            Text {
                font.pixelSize: toPixels(0.2) //(0.15)
                font.family: main_window.deffntfam
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
            font.pixelSize: labelTextSize //toPixels(0.15) //(0.12)
            font.family: main_window.deffntfam
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

