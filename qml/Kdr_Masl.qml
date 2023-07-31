import QtQuick 2.0

Rectangle {
    width: 512
    height: 197

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Masl.opacity
        onTriggered: {
            var par = ioBf.getParamKdrMasl();
            ind_PiD.value = par[0].toFixed(2);
            ind_TiD.value = par[1];
            ind_PoD.value = par[2].toFixed(2);
            ind_ToD.value = par[3];
            ind_Fd.value = par[4];
            zPm.visible = par[5] & 1;
            zTm.visible = par[5] & 2;
            ind_PiD.color = (par[5] & 1) ? "red" : "black";
            ind_TiD.color = (par[5] & 2) ? "red" : "black";
        }

    }

    Image {
        id: image1
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrMsl_lin.png"

        Text {
            id: text1
            x: 0
            y: 0
            color: "#f9f8f8"
            text: qsTr("МАСЛО")
            font.bold: true
            font.pixelSize: 14
            font.family: main_window.deffntfam
        }

        TInd {
            id: ind_PiD
            x: 15
            y: 98
            width: 37
            height: 13
        }

        TInd {
            id: ind_TiD
            x: 119
            y: 125
            width: 37
            height: 13
        }

        TInd {
            id: ind_ToD
            x: 376
            y: 125
            width: 37
            height: 13
        }

        TInd {
            id: ind_PoD
            x: 105
            y: 73
            width: 37
            height: 13
        }

        TInd {
            id: ind_Fd
            x: 188
            y: 132
            width: 40
            height: 26
            color: "gray"
            txtColor: "white"
            txtSize: 20
            border.color: "#00000000"
        }

        Text {
            id: text2
            x: 234
            y: 140
            color: "silver"
            text: qsTr("об/мин")
            font.pixelSize: 12
            font.family: main_window.deffntfam
        }

        Text {
            id: zPm
            x: 87
            y: 88
            color: "yellow"
            text: qsTr("P масла ниже нормы")
            font.bold: true
            font.pixelSize: 12
            font.family: main_window.deffntfam
        }
        Text {
            id: zTm
            x: 87
            y: 103
            color: "yellow"
            text: qsTr("Запрет работы под нагрузкой (t масла < 45°C)")
            font.bold: true
            font.pixelSize: 12
            font.family: main_window.deffntfam
        }
    }
}
