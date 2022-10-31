import QtQuick 2.0


Rectangle {
    width: 512
    height: 197
    color: "#000000"

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_TED.opacity
        onTriggered: {
            var par = ioBf.getParamKdrTed();
            ind_Ig.value = par[0];
            ind_Itd1.value = par[1];
            ind_Itd2.value = par[2];
            k_KT1.visible = k_KT2.visible = k_KVT1.visible = k_KVT2.visible = par[3] & 1;
            k_P1.visible = par[3] & 2;
            k_P2.visible = par[3] & 4;
        }
    }

    Image {
        id: image1
//        anchors.rightMargin: 0
//        anchors.bottomMargin: 0
//        anchors.leftMargin: 0
//        anchors.topMargin: 0
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrTed_lin.png"

        TInd {
            id: ind_Itd1
            x: 362
            y: 53
            width: 37
            height: 13
        }

        TInd {
            id: ind_Ig
            x: 38
            y: 76
            width: 37
            height: 13
        }

        TInd {
            id: ind_Itd2
            x: 364
            y: 166
            width: 37
            height: 13
        }

        Text {
            id: name_kdr_Ted
            x: 0
            y: 0
            color: "#f9f8f8"
            text: qsTr("ТЯГОВЫЕ ДВИГАТЕЛИ")
            transformOrigin: Item.Center
            anchors.top: parent.top
            anchors.topMargin: 0
            font.bold: true
            font.pixelSize: 14
        }

        Image {
            id: k_KT1
            x: 429
            y: 51
            width: 17
            height: 17
            source: "../Shem_TEM18DM/kontaktor_lin.png"
        }

        Image {
            id: k_KT2
            x: 430
            y: 160
            width: 17
            height: 17
            source: "../Shem_TEM18DM/kontaktor_lin.png"
            visible: true
        }

        Image {
            id: k_P1
            x: 463
            y: 64
            width: 17
            height: 16
            sourceSize.height: 16
            sourceSize.width: 17
            source: "../Shem_TEM18DM/kontaktor_g_lin.png"
        }

        Image {
            id: k_P2
            x: 463
            y: 138
            width: 17
            height: 17
            z: 1
            source: "../Shem_TEM18DM/kontaktor_g_lin.png"
            visible: true

        }

        Image {
            id: k_KVT1
            x: 375
            y: 88
            width: 17
            height: 22
            source: "../Shem_TEM18DM/kontaktor_g_lin.png"
        }

        Image {
            id: k_KVT2
            x: 374
            y: 109
            width: 17
            height: 22
            source: "../Shem_TEM18DM/kontaktor_g_lin.png"
        }
    }
}

