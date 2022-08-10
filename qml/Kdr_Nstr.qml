import QtQuick 2.0
// Экран НАСТРОЙКИ , ввод - НЕ СДЕЛАН вообще!!!
Rectangle {
    width: 512
    height: 197
    color: "#000000"

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_AvProgrev.opacity

        onTriggered: {

        }

    }


    Image {
        id: image1
        x: 0
        sourceSize.height: 157
        sourceSize.width: 512
        z: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrNst.png"

    }

    Text {
        id: text3
        x: 410
        y: 28
        color: "#d3d3d3"
        text: qsTr("запись")
        z: 1
        font.pixelSize: 12
        font.bold: true
    }

    Text {
        id: text12
        x: 261
        y: 8
        color: "#f9f8f8"
        text: qsTr("НАСТРОЙКИ")
        textFormat: Text.AutoText
        styleColor: "#8877e4"
        font.bold: true
        font.pixelSize: 14
    }

    Text {
        id: text4
        x: 338
        y: 85
        color: "#d3d3d3"
        text: qsTr("сигнал тревоги:")
        z: 14
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: text5
        x: 309
        y: 102
        width: 123
        height: 17
        color: "#d3d3d3"
        text: qsTr("время                      час:")
        z: 13
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: text6
        x: 382
        y: 121
        width: 50
        height: 17
        color: "#d3d3d3"
        text: qsTr("минуты:")
        z: 12
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: text7
        x: 327
        y: 141
        width: 105
        height: 17
        color: "#d3d3d3"
        text: qsTr("дата                день:")
        z: 11
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: text8
        x: 409
        y: 180
        width: 23
        height: 17
        color: "#d3d3d3"
        text: qsTr("год:")
        z: 10
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: text9
        x: 394
        y: 161
        width: 38
        height: 17
        color: "#d3d3d3"
        text: qsTr("месяц:")
        z: 9
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: text14
        x: 460
        y: 85
        width: 47
        height: 16
        color: "#00ffff"
        text: qsTr("откл")
        z: 8
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: text15
        x: 460
        y: 102
        width: 47
        height: 16
        color: "#00ffff"
        text: qsTr("12")
        z: 7
        font.pixelSize: 12
        font.bold: true
    }

    Text {
        id: text16
        x: 460
        y: 121
        width: 47
        height: 16
        color: "#00ffff"
        text: qsTr("55")
        z: 6
        font.pixelSize: 12
        font.bold: true
    }

    Text {
        id: text17
        x: 460
        y: 141
        width: 47
        height: 16
        color: "#00ffff"
        text: qsTr("07")
        z: 5
        font.pixelSize: 12
        font.bold: true
    }

    Text {
        id: text18
        x: 460
        y: 161
        width: 47
        height: 16
        color: "#00ffff"
        text: qsTr("май")
        z: 4
        font.pixelSize: 12
        font.bold: true
    }

    Text {
        id: text19
        x: 460
        y: 180
        width: 47
        height: 16
        color: "#00ffff"
        text: qsTr("2020")
        z: 3
        font.pixelSize: 12
        font.bold: true
    }


}

