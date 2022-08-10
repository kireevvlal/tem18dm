import QtQuick 2.0
// Бортовая сеть
Rectangle {
    width: 512
    height: 197

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Bos.opacity // вкл как только кадр становится видимым
        onTriggered: {
            var par = ioBf.getParamKdrBos();
            ind_Ubs.value = par[0];
            ind_Rp.value = par[1];
            ind_Rm.value = par[2];
            ind_Iz.value = par[3];
            ind_Uzu.value = par[4];
            ind_Ivst.value = par[5];
            ind_Sh2p.value = par[6];
            ind_Sh2.value = par[7];
            k_RSIm.visible = ! k_RSIm.visible;
            k_RSIp.visible = ! k_RSIm.visible;

            if (k_RSIm.visible) // тест заливки
                 {ind_Ubs.color = "red";  ind_Iz.color = "red";}
            else {ind_Ubs.color ="black"; ind_Iz.color = "black";}
}
}
    Image {
        id: kdr_Bos
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrBos_lin.png"

        Text {
            id: text1
            x: 8
            y: 8
            color: "#dcd6d6"
            text: qsTr("БОРТОВАЯ СЕТЬ")
            font.bold: true
            font.pixelSize: 14
        }

        TInd {
            id: ind_Ubs
            x: 105
            y: 95
            width: 37
            height: 13
            color: "red"
            txtColor: "white"
        }

        TInd {
            id: ind_Rp
            x: 105
            y: 164
            width: 37
            height: 13
            color: "red"
            txtColor: "white"
        }

        TInd {
            id: ind_Rm
            x: 234
            y: 164
            width: 37
            height: 13
            color: "red"
            txtColor: "white"
        }

        TInd {
            id: ind_Iz
            x: 234
            y: 95
            width: 37
            height: 13
            color: "red"
            border.width: 1
            txtColor: "white"
        }

        TInd {
            id: ind_Uzu
            x: 17
            y: 164
            width: 37
            height: 13
        }

        TInd {
            id: ind_Ivst
            x: 332
            y: 37
            width: 37
            height: 13
        }

        TInd {
            id: ind_Sh2p
            x: 411
            y: 36
            width: 37
            height: 13
        }

        TInd {
            id: ind_Sh2
            x: 412
            y: 61
            width: 37
            height: 13
        }

        Image {
            id: k_RSIm
            x: 51
            y: 116
            width: 19
            height: 16
            sourceSize.height: 16
            sourceSize.width: 17
            source: "../Shem_TEM18DM/kontaktor_g_lin.png"
        }

        Image {
            id: k_RSIp
            x: 51
            y: 140
            width: 19
            height: 16
            source: "../Shem_TEM18DM/kontaktor_g_lin.png"
            sourceSize.height: 16
            sourceSize.width: 17
        }
    }
}

