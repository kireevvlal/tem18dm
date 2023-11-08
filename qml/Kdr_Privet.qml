import QtQuick 2.0

Rectangle {
    id: rectangle1
    width: 221
    height: 150
    color: "black"
    visible: true
//    property int counter: 0


    Timer {
        id: privet_timer
        triggeredOnStart: true
        interval: 5000
        repeat: true
        running: kdr_Privet.opacity
        onTriggered: {

//            counter++;
//            if (counter > 10) {
            if (triggeredOnStart) {
                triggeredOnStart = false;
                var par = ioBf.getKdrPrivet();
                text_sensor.text = par[0];
                text_injection.text = par[1];
            }
            else
                kdr_Privet.opacity = 0;
//                counter = 0;
//            }
        }
    }


    Text {
        id: text_rrw
        x: 48
        y: 0
        color: "gray"
        text: qsTr("Russian Railways")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 0
        font.bold: true
        font.pixelSize: 12
        font.family: main_window.deffntfam
    }

    Text {
        id: text_vnikti
        x: 73
        y: 17
        color: "gray"
        text: qsTr("JSC \"VNIKTI\"")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 0
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }


    Text {
        id: text_tem18
        x: 76
        y: 33
        color: "silver"
        text: qsTr("ТЭМ18ДМ")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        font.pixelSize: 12
        font.family: main_window.deffntfam
    }

    Text {
        id: text_sensor
        x: 78
        y: 57
        color: "silver"
        text: qsTr("DT:16kg")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pixelSize: 7
        font.family: main_window.deffntfam
    }

    Text {
        id: text_injection
        x: 119
        y: 57
        color: "silver"
        text: qsTr("No Elvp")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pixelSize: 7
        font.family: main_window.deffntfam
    }

    Text {
        id: text_addr1
        x: 5
        y: 74
        color: "gray"
        text: qsTr("410 Oktyabrskoy Revolutsii str.,")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 0
        font.bold: true
        font.pixelSize: 8
        font.family: main_window.deffntfam
    }

    Text {
        id: text_addr2
        x: 5
        y: 86
        color: "gray"
        text: qsTr("Kolomna, Moscow region, 140402, RU")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 0
        font.bold: true
        font.pixelSize: 8
        font.family: main_window.deffntfam
    }

    Text {
        id: text_phone
        x: 45
        y: 105
        color: "gray"
        text: qsTr("tel.: (496)618-82-56")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 0
        font.bold: true
        font.pixelSize: 8
        font.family: main_window.deffntfam
    }

    Text {
        id: text_email
        x: 28
        y: 116
        color: "gray"
        text: qsTr("e-mail: otdel-nd@yandex.ru")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 0
        font.bold: true
        font.pixelSize: 8
        font.family: main_window.deffntfam
    }

    Text {
        id: text_version
        x: 8
        y: 132
        color: "silver"
        text: qsTr("v.1.11 01/11/23")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pixelSize: 7
        font.family: main_window.deffntfam
    }

    Text {
        id: text_year
        x: 175
        y: 132
        color: "silver"
        text: qsTr("©2023")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pixelSize: 7
        font.family: main_window.deffntfam
    }
}

