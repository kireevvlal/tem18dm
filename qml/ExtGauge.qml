import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4


Item {
    id: extgauge
    property bool visibleLabels: true       // false - скрыть значения шкалы
    property bool visibleTickmarks: true    // false - скрыть метки шкалы
    property bool visibleMinorTickmarks: true    // false - скрыть промежуточные метки шкалы
    property bool isHeader: true            // false - показывать вверху наименование параметра и его значение
    property real value: 0                  // значение измеряемого параметра
    property string parameter               // наименование параметра
    property string name: ""                // ...
    property int barWidth: 24               // ширина цветового индикатора
    property int minValue: 0                // минимальное значение
    property int maxValue: 150              // максимальное значение
    property string barColor: "lightblue"
//    property int warningValue: maxValue + 1               // граница, при превышении которой цвет становится warning (желтый)
//    property int errorValue: maxValue + 1                  // граница, при превышении которой цвет становится error (красный)
    onValueChanged: {
        gauge.value = value;
    }
    Text {
        y: 0
        x: 0
        font.pixelSize: 14
        color: "lightgray"
        text: name
        visible: isHeader
    }

    Text {
        y: 0
        x: 32
        width: barWidth
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        color: "lightgray"
        text: parameter
        visible: isHeader
    }

    Text {
        z: 2
        width: barWidth
        y: {
            var calc = gauge.height - (gauge.height - 16) * (value / (gauge.maximumValue - gauge.minimumValue)) - 8;
            isHeader ? 16 : (calc > gauge.height - 20)? gauge.height - 20 : calc;
        }
        x: 32
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        //font.bold: true
        color: "#00d7d7" //isHeader ? (value > errorValue ? "red" : (value > warningValue ? "yellow" : "lightblue")) : "blue"
        text: gauge.value
    }

    Gauge {
        z: 1
        id: gauge
//        value: 100
        minimumValue: minValue
        maximumValue: maxValue
        tickmarkStepSize: 50
        minorTickmarkCount: visibleTickmarks ? 4 : 0
        font.pixelSize: 15
        y: isHeader ? 28 : 0
        height: parent.height - (isHeader ? 28 : 0)

        style: GaugeStyle {
            id: gstyle

            valueBar: Rectangle {
                color: barColor //value > errorValue ? ("red") : (value > warningValue ? "yellow" : "lightblue")
                implicitWidth: barWidth
            }

            tickmark: Item {
                implicitWidth: 8
                implicitHeight: 1

                Rectangle {
                    width: 8
                    height: 1
                    color: "lightgray"
                    visible: styleData.value < gauge.maximumValue && visibleTickmarks ? true : false
                }
            }

            minorTickmark: Item {
                implicitWidth: 6
                implicitHeight: 2

                Rectangle {
                    width: 6
                    height: 1
                    color: "lightgray"
                    visible: visibleMinorTickmarks
                }
            }

            tickmarkLabel:
                Item {
                implicitWidth: 20
                implicitHeight: 28
                Text {
                    font.pixelSize: 15
                    text: styleData.value < gauge.maximumValue ? styleData.value : ""
                    color: "lightgray"
                    visible: visibleLabels
                }
            }
        }
    }
}
