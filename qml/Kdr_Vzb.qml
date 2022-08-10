import QtQuick 2.0

Rectangle {
    width: 512
    height: 197

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Vzb.opacity
        onTriggered: {
            var par = ioBf.getParamKdrVzb();
            ind_Ivz.value = par[0];
            ind_Ug.value = par[1];
            ind_Ig.value = par[2];
            ind_Sh1.value = par[3];
//            ind_Ivz.value = ioBf.getParam();
//            ind_Ug.value = ioBf.getParam();
//            ind_Ig.value = ioBf.getParam();
//            ind_Sh1.value = ioBf.getParam();
            k_KV.visible = ! k_KV.visible;
        }

    }

    Image {
        id: image1
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrVzb_lin.png"

        Text {
            id: text1
            x: 14
            y: 8
            color: "#f9f8f8"
            text: qsTr("ВОЗБУЖДЕНИЕ")
            font.bold: true
            font.pixelSize: 14
        }

        TInd {
            id: ind_Ivz
            x: 267
            y: 128
            width: 37
            height: 13
        }

        TInd {
            id: ind_Ug
            x: 430
            y: 128
            width: 37
            height: 13
        }

        TInd {
            id: ind_Ig
            x: 471
            y: 77
            width: 37
            height: 13
        }

        TInd {
            id: ind_Sh1
            x: 133
            y: 128
            width: 37
            height: 13
            txtColor: "white"
        }

        Image {
            id: k_KV
            x: 301
            y: 39
            width: 20
            height: 16
            source: "../Shem_TEM18DM/kontaktor_g_lin.png"
        }

        Rectangle {
            id: tVz
            x: 105
            y: 70
            width: 137
            height: 81
            color: "#00000000"
            border.color: "#f92525"
            border.width: 1
        }

        Rectangle {
            id: tG
            x: 372
            y: 113
            width: 34
            height: 44
            color: "#00000000"
            border.width: 1
            border.color: "#f92525"
        }
    }
}

