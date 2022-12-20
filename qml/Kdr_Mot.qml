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
            ind_MotC.value =Math.round(par[0] / 3600);
            ind_MotM.value = Math.round((par[0] % 3600) / 60);
            ind_MotS.value = Math.round(par[0] % 60);
            ind_TagC.value = Math.round(par[1] / 3600);
            ind_TagM.value = Math.round((par[1] % 3600) / 60);
            ind_TagS.value = Math.round(par[1] % 60);
            ind_Rab.value = par[2].toFixed(1);
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
    }

    TInd {
        id: ind_MotC
        x: 59
        y: 55
        value: "000000000"

    }

    Text {
        id: text_MotC
        x: 147
        y: 55
        color: "#8f8282"
        text: qsTr("ч")
        font.pixelSize: 16
        font.bold: true
        verticalAlignment: Text.AlignVCenter
    }

    TInd {
        id: ind_MotM
        value: "00"
        x: 156
        y: 55
        width: 40
        height: 22
    }

    Text {
        id: text_MotM
        x: 200
        y: 55
        color: "#8f8282"
        text: qsTr("м")
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 16
    }

    TInd {
        id: ind_MotS
        value: "00"
        x: 216
        y: 55
        width: 40
        height: 22
    }

    Text {
        id: text_MotS
        x: 260
        y: 55
        color: "#8f8282"
        text: qsTr("с")
        font.pixelSize: 16
        font.bold: true
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
        verticalAlignment: Text.AlignVCenter
    }

    TInd {
        id: ind_TagC
        x: 59
        y: 89
        value: "000000000"

    }
    Text {
        id: text_TagC
        x: 147
        y: 89
        color: "#8f8282"
        text: qsTr("ч")
        font.pixelSize: 16
        font.bold: true
        verticalAlignment: Text.AlignVCenter
    }

    TInd {
        id: ind_TagM
        value: "00"
        x: 156
        y: 89
        width: 40
        height: 22
    }

    Text {
        id: text_TagM
        x: 200
        y: 89
        color: "#8f8282"
        text: qsTr("м")
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 16
    }

    TInd {
        id: ind_TagS
        value: "00"
        x: 216
        y: 89
        width: 40
        height: 22
    }

    Text {
        id: text_TagS
        x: 260
        y: 89
        color: "#8f8282"
        text: qsTr("с")
        font.pixelSize: 16
        font.bold: true
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
        verticalAlignment: Text.AlignVCenter
    }

    TInd {
        id: ind_Rab
        value: "000000000"
        x: 65
        y: 124
        width: 130
        height: 22
        txtColor: "white"
    }

    Text {
        id: text_Rab_kWtC
        x: 199
        y: 124
        color: "#8f8282"
        text: qsTr("кВт * ч")
        font.pixelSize: 16
        font.bold: true
        verticalAlignment: Text.AlignVCenter
    }

    // Fd
    Text {
        id: text_Fd
        x: 360
        y: 108
        color: "#080000"
        text: qsTr("F")
        styleColor: "#0f0c0c"
        font.pixelSize: 16
        font.bold: true
    }

    TInd {
        id: ind_Fd
        x: 370
        y: 108
        height: 26
        color: "gray"
        txtColor: "white"
        txtSize: 24
        border.color: "#00000000"
    }

    Text {
        id: text_obm
        x: 457
        y: 108
        color: "#080000"
        text: qsTr("о/м")
        font.pixelSize: 16
        font.bold: true
        styleColor: "#0f0c0c"
    }
}

