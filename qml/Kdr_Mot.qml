import QtQuick 2.0

Rectangle {
    width: 512
    height: 197
    z: 2147483646

    Image {
        id: image1
        z: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrMot_lin.png"

    }

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Mot.opacity
        onTriggered: {
            var par = ioBf.getParamKdrMot();
            var sec = par[0] % 60
            var min = (par[0] % 3600 - sec) / 60
            ind_MotC.value = (par[0] - min * 60 - sec) / 3600
            ind_MotM.value = min
            ind_MotS.value = sec
            sec = par[1] % 60
            min = (par[1] % 3600 - sec) / 60
            ind_TagC.value = (par[1] - min * 60 - sec) / 3600
            ind_TagM.value = min
            ind_TagS.value = sec
            ind_Rab.value = par[2].toFixed(1)
            ind_Fd.value = par[3];
        }
    }

    Text {
        id: text1
        x: 0
        y: 0
        color: "#f9f8f8"
        text: "МОТОРЕСУРС"
        z: 1
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
    }
    // motoresurs
    Text {
           id: text_motoresurs
           x: 9
           y: 55
           color: "#8f8282"
           text: qsTr("время:")
           font.bold: true
           verticalAlignment: Text.AlignVCenter
           font.pixelSize: 14
           font.family: main_window.deffntfam
    }

    TInd {
        id: ind_MotC
        x: 64
        y: 55
        value: "000000"

    }

    Text {
        id: text_MotC
        x: 152
        y: 55
        color: "#8f8282"
        text: qsTr("ч")
        font.pixelSize: 16
        font.bold: true
        font.family: main_window.deffntfam
        verticalAlignment: Text.AlignVCenter
    }

    TInd {
        id: ind_MotM
        value: "00"
        x: 165
        y: 55
        width: 40
        height: 22
    }

    Text {
        id: text_MotM
        x: 213
        y: 55
        color: "#8f8282"
        text: qsTr("м")
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 16
        font.family: main_window.deffntfam
    }

    TInd {
        id: ind_MotS
        value: "00"
        x: 233
        y: 55
        width: 40
        height: 22
    }

    Text {
        id: text_MotS
        x: 281
        y: 55
        color: "#8f8282"
        text: qsTr("с")
        font.pixelSize: 16
        font.bold: true
        font.family: main_window.deffntfam
        verticalAlignment: Text.AlignVCenter
    }

    // Tyaga
    Text {
        id: text_Tyaga
        x: 9
        y: 89
        color: "#8f8282"
        text: qsTr("в тяге:")
        font.pixelSize: 16
        font.bold: true
        font.family: main_window.deffntfam
        verticalAlignment: Text.AlignVCenter
    }

    TInd {
        id: ind_TagC
        x: 64
        y: 89
        value: "000000"

    }
    Text {
        id: text_TagC
        x: 152
        y: 89
        color: "#8f8282"
        text: qsTr("ч")
        font.pixelSize: 16
        font.bold: true
        font.family: main_window.deffntfam
        verticalAlignment: Text.AlignVCenter
    }

    TInd {
        id: ind_TagM
        value: "00"
        x: 165
        y: 89
        width: 40
        height: 22
    }

    Text {
        id: text_TagM
        x: 213
        y: 89
        color: "#8f8282"
        text: qsTr("м")
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 15
        font.family: main_window.deffntfam
    }

    TInd {
        id: ind_TagS
        value: "00"
        x: 233
        y: 89
        width: 40
        height: 22
    }

    Text {
        id: text_TagS
        x: 281
        y: 89
        color: "#8f8282"
        text: qsTr("с")
        font.pixelSize: 16
        font.bold: true
        font.family: main_window.deffntfam
        verticalAlignment: Text.AlignVCenter
    }

    // rabota
    Text {
        id: text_rabota
        x: 9
        y: 124
        color: "#8f8282"
        text: qsTr("работа:")
        font.pixelSize: 16
        font.bold: true
        font.family: main_window.deffntfam
        verticalAlignment: Text.AlignVCenter
    }

    TInd {
        id: ind_Rab
        value: "000000"
        x: 72
        y: 124
        width: 130
        height: 22
        txtColor: "white"
    }

    Text {
        id: text_Rab_kWtC
        x: 206
        y: 124
        color: "#8f8282"
        text: qsTr("кВт * ч")
        font.pixelSize: 16
        font.bold: true
        font.family: main_window.deffntfam
        verticalAlignment: Text.AlignVCenter
    }

    // Fd
    Text {
        id: text_Fd
        x: 353
        y: 108
        color: "silver"
        text: qsTr("F")
        styleColor: "#0f0c0c"
        font.pixelSize: 20
        font.bold: true
        font.family: main_window.deffntfam
    }

    TInd {
        id: ind_Fd
        x: 367
        y: 108
        height: 24
        width: 60
        color: "gray"
        txtColor: "white"
        txtSize: 24
        border.color: "#00000000"
    }

    Text {
        id: text_obm
        x: 427
        y: 112
        color: "silver"
        text: qsTr("об/мин")
        font.pixelSize: 16
        font.bold: true
        font.family: main_window.deffntfam
        styleColor: "#0f0c0c"
    }
}

