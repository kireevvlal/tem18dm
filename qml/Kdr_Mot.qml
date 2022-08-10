import QtQuick 2.0

Rectangle {
    width: 512
    height: 197
    z: 2147483646

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Mot.opacity
        onTriggered: {

            ind_Fd.value = ioBf.getParamKdrMot()[0]; //ioBf.getParam();
            ind_MotC.value ++;
            ind_MotM.value ++;
            ind_MotS.value ++;
            ind_TagC.value ++;
            ind_TagM.value ++;
            ind_TagS.value ++;
            ind_Rab.value  ++;
        }

    }
    Image {
        id: image1
        z: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrMot_lin.png"

        //        TInd {
        //            id: ind_Fd
        //            value: "0000"
        //            x: 448
        //            y: 130
        //            width: 82
        //            height: 31
        //            color: "black"
        //            txtSize: 21
        //            txtColor: "white"
        //        }
    }

    Text {
        id: text1
        x: 31
        y: 8
        color: "#f9f8f8"
        text: "МОТОРЕСУРС"
        z: 1
        font.bold: true
        font.pixelSize: 14
    }

    Text {
        id: text2
        x: 9
        y: 57
        color: "#8f8282"
        text: qsTr("время:")
        font.bold: true
        font.pixelSize: 14
    }

    TInd {
        id: ind_MotC
        x: 59
        y: 55
        value: "000000000"

    }

    Text {
        id: text13
        x: 457
        y: 113
        color: "#080000"
        text: qsTr("о/м")
        font.pixelSize: 14
        font.bold: true
        styleColor: "#0f0c0c"
    }

    TInd {
        id: ind_Fd
        x: 370
        y: 106
        height: 26
        color: "gray"
        txtColor: "white"
        txtSize: 24
        border.color: "#00000000"
    }

    Text {
        id: text12
        x: 360
        y: 108
        color: "#080000"
        text: qsTr("F")
        styleColor: "#0f0c0c"
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: text11
        x: 199
        y: 125
        color: "#8f8282"
        text: qsTr("кВт * ч")
        font.pixelSize: 14
        font.bold: true
    }

    TInd {
        id: ind_Rab
        value: "000000000"
        x: 62
        y: 122
        width: 134
        height: 22
        txtColor: "white"
    }

    Text {
        id: text10
        x: 9
        y: 124
        color: "#8f8282"
        text: qsTr("работа:")
        font.pixelSize: 14
        font.bold: true
    }

    TInd {
        id: ind_TagS
        value: "00"
        x: 250
        y: 91
        width: 65
        height: 22
    }

    TInd {
        id: ind_TagM
        value: "00"
        x: 161
        y: 89
        width: 65
        height: 22
    }

    Text {
        id: text9
        x: 316
        y: 92
        color: "#8f8282"
        text: qsTr("с")
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: text7
        x: 147
        y: 91
        color: "#8f8282"
        text: qsTr("ч")
        font.pixelSize: 14
        font.bold: true
    }

    TInd {
        id: ind_TagC
        x: 59
        y: 89
        value: "000000000"

    }

    Text {
        id: text6
        x: 9
        y: 91
        color: "#8f8282"
        text: qsTr("в тяге:")
        font.pixelSize: 14
        font.bold: true
    }

    TInd {
        id: ind_MotS
        value: "00"
        x: 248
        y: 55
        width: 65
        height: 22
    }

    TInd {
        id: ind_MotM
        value: "00"
        x: 161
        y: 55
        width: 65
        height: 22
    }

    Text {
        id: text5
        x: 315
        y: 57
        color: "#8f8282"
        text: qsTr("с")
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: text3
        x: 147
        y: 57
        color: "#8f8282"
        text: qsTr("ч")
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: text4
        x: 231
        y: 57
        color: "#8f8282"
        text: qsTr("м")
        font.bold: true
        font.pixelSize: 14
    }

    Text {
        id: text8
        x: 231
        y: 91
        color: "#8f8282"
        text: qsTr("м")
        font.bold: true
        font.pixelSize: 14
    }
}

