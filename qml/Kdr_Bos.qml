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
            ind_Ubs.value = Math.round(par[0]);
            ind_Rp.value = par[1];
            ind_Rm.value = par[2];
            ind_Iz.value = Math.round(par[3]);
            ind_Uzu.value = par[4];
            ind_Ivst.value = Math.round(par[5]);
            ind_Sh2.value = Math.round(par[6]);
            ind_Sh2p.value = Math.round(par[7]);
            k_RSIm.visible = par[8] & 1;
            k_RSIp.visible = par[8] & 2;
            ind_Iz.color = (par[8] & 4) ? "red" : "black";
            ind_Ubs.color = (par[8] & 8) ? "red" : "black";
            ind_Rp.color = (par[8] & 16) ? "red" : "black";
            ind_Rm.color = (par[8] & 32) ? "red" : "black";
            z_Iz.visible = par[8] & 4;
            z_Ubs.visible = par[8] & 8;
            z_Rp.visible = par[8] & 16;
            z_Rm.visible = par[8] & 32;
            z_Rpk.visible = par[8] & 64;
            z_Rmk.visible = par[8] & 128;
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
            x: 0
            y: 0
            color: "#dcd6d6"
            text: qsTr("БОРТОВАЯ СЕТЬ")
            font.bold: true
            font.pixelSize: 16
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
        Text {
            id: z_Ubs
            x: 0
            y: 18
            color: "yellow"
            text: qsTr("Неисправна система энергоснабжения")
            font.bold: true
            font.pixelSize: 12
        }
        Text {
            id: z_Rp
            x: 0
            y: 32
            color: "yellow"
            text: qsTr("R цепей [+]-корпус меньше 250 кОм")
            font.bold: true
            font.pixelSize: 12
        }
        Text {
            id: z_Rm
            x: 0
            y: 46
            color: "yellow"
            text: qsTr("R цепей [-]-корпус меньше 250 кОм")
            font.bold: true
            font.pixelSize: 12
        }
        Text {
            id: z_Rpk
            x: 0
            y: 60
            color: "yellow"
            text: qsTr("Цепи управления [+] на корпусе")
            font.bold: true
            font.pixelSize: 12
        }
        Text {
            id: z_Rmk
            x: 0
            y: 74
            color: "yellow"
            text: qsTr("Цепи управления [-] на корпусе")
            font.bold: true
            font.pixelSize: 12
        }
        Text {
            id: z_Iz
            x: 294
            y: 95
            width: 113
            height: 16
            color: "yellow"
            text: qsTr("Нет заряда батареи")
            font.bold: true
            font.pixelSize: 12
        }
    }
}

