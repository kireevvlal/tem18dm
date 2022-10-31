import QtQuick 2.0

Rectangle {
    width: 512
    height: 197
    color: "black"
//    z: 1

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: true
        onTriggered: {
            var par = ioBf.getParamKdrTop();
            txt_time.text = par[0]; //ioBf.tm();
            txt_data.text = par[1]; //ioBf.dt();
        }

    }

    Text {
        id: text2
        x: 157
        y: 6
        color: "#d2e8fb"
        text: qsTr("ТЭМ18ДМ  №___")
        font.bold: true
        font.pointSize: 13
    }

    Text {
        id: txt_time
        x: 400
        y: 8
        color: "#d2e8fb"
        text: qsTr("время")
        horizontalAlignment: Text.AlignRight
        font.pointSize: 13
        font.bold: true
    }

    Text {
        id: txt_data
        x:  400
        y: 25
        color: "#d2e8fb"
        text: qsTr("дата")
        font.pointSize: 13
        font.bold: true
    }

    ExtCircularGauge {
        id: indPt
        x: 0
        y: 74
        width: 150
        height: 150
        maximumValue: 1.2
        minimumValue: 0
        parameter: "Рт МПа"
        start: 0.9
        finish: 1.2
        valuePrecision: 2
        labelPrecision: 1
    }

    ExtCircularGauge {
        id: indPm
        x: 164
        y: 74
        width: 150
        height: 150
        maximumValue: 1.2
        minimumValue: 0
        parameter: "Рм МПа"
        start: 0.9
        finish: 1.2
        valuePrecision: 2
        labelPrecision: 1
    }
    ExtCircularGauge {
        id: indFd
        x: 330
        y: 54
        width: 170
        height: 170
        maximumValue: 900
        minimumValue: 0
        parameter: "F об/мин"
        start: 600
        finish: 750
    }

            Text {
                id: txt_RejPrT
                x: 0
                y: 27
                color: "#f0f026"
                text: qsTr("Длительный х.ход! Установи 8 ПКМ на 10 минут")
                font.pointSize: 10
                font.bold: true
            }

            Text {
                id: txt_RejAP
                x: 0
                y: 43
                color: "#f0f026"
                text: qsTr("Режим автопрогрева")
                font.pointSize: 10
                font.bold: true
            }

            Text {
                id: txt_RejPro
                x: 0
                y: 59
                color: "#f0f026"
                text: qsTr("Прожиг коллектора")
                font.pointSize: 10
                font.bold: true
                style: Text.Outline
            }
}
