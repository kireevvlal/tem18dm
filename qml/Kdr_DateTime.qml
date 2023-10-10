import QtQuick 2.0
// Set date and time
Rectangle {
    width: 512
    height: 197
    color: "#000000"
    property int active: 0
    property int year: 2023
    property int month: 1
    property int day: 1
    property int hour: 0
    property int minute: 0
    property int second: 0
    Timer {
        triggeredOnStart: true

        interval: 500
//        repeat: true
        running: kdr_DateTime.opacity

        onTriggered: {
            var par = ioBf.getKdrDateTime()
            year = par[0]
            month = par[1]
            day = par[2]
            hour = par[3]
            minute = par[4]
            second = par[5]
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
        id: text12
        x: 0
        y: 0
        color: "#f9f8f8"
        text: qsTr("НАСТРОЙКА ДАТЫ и ВРЕМЕНИ")
        textFormat: Text.AutoText
        styleColor: "#8877e4"
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
    }

    Text {
        id: txt1
        x: 10
        y: 30
        color: (active == 0) ? "yellow" : "silver"
        text: qsTr("Год")
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
    }

    Text {
        id: txt_year
        x: 200
        y: 30
        color: "cyan"
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
        text: year
    }

    Text {
        id: txt2
        x: 10
        y: 60
        color: (active == 1) ? "yellow" : "silver"
        text: qsTr("Месяц")
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
    }

    Text {
        id:txt_month
        x: 200
        y: 60
        color: "cyan"
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
        text: month
    }

    Text {
        id: txt3
        x: 10
        y: 90
        color: (active == 2) ? "yellow" : "silver"
        text: qsTr("День")
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
    }

    Text {
        id: txt_day
        x: 200
        y: 90
        color: "cyan"
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
        text: day
    }

    Text {
        id: txt4
        x: 10
        y: 120
        color: (active == 3) ? "yellow" : "silver"
        text: qsTr("Час")
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
    }

    Text {
        id: txt_hour
        x: 200
        y: 120
        color: "cyan"
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
        text: hour
    }

    Text {
        id: txt5
        x: 10
        y: 150
        color: (active == 4) ? "yellow" : "silver"
        text: qsTr("Минута")
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
    }

    Text {
        id: txt_minute
        x: 200
        y: 150
        color: "cyan"
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
        text: minute
    }

    Text {
        id: txt6
        x: 10
        y: 180
        color: (active == 5) ? "yellow" : "silver"
        text: qsTr("Секунда")
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
    }

    Text {
        id: txt_second
        x: 200
        y: 180
        color: "cyan"
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
        text: second
    }
}

