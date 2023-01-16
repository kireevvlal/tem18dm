import QtQuick 2.0

Rectangle {
    width: 512
    height: 197

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Ohl.opacity
        onTriggered: {
            var par = ioBf.getParamKdrOhl();
            ind_TiOM.value = par[0];
            ind_TiVN2.value = par[1];
            ind_TiD.value = par[2];
            ind_ToD.value = par[3];
            ind_Fd.value = par[4];
            ind_ToD.color = (par[5] & 1) ? "red" : "black";
            zTz.visible = par[5] & 2;
            zTp.visible = par[5] & 4;
        }

    }

    Image {
        id: image1
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrOhl_lin.png"

        TInd {
            id: ind_TiOM
            x: 36
            y: 84
            width: 37
            height: 13
        }

        TInd {
            id: ind_TiVN2
            x: 104
            y: 84
            width: 37
            height: 13
        }

        TInd {
            id: ind_TiD
            x: 253
            y: 84
            width: 37
            height: 13
        }

        TInd {
            id: ind_ToD
            x: 454
            y: 84
            width: 37
            height: 13
        }


        TInd {
            id: ind_Fd
            x: 332
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
            x: 376
            y: 140
            color: "silver"
            text: qsTr("об/мин")
            font.pixelSize: 12
        }

        Text {
            id: text1
            x: 0
            y: 0
            color: "#f9f8f8"
            text: qsTr("ОХЛАЖДЕНИЕ")
            font.bold: true
            font.pixelSize: 14
        }

        Text {
            id: zTz
            x: 201
            y: 19
            color: "yellow"
            text: qsTr("Запрет работы под нагрузкой (t воды < 45°C)")
            font.bold: true
            font.pixelSize: 12
        }
        Text {
            id: zTp
            x: 238
            y: 57
            color: "yellow"
            text: qsTr("Предельно допустимая t воды (>86°C)")
            font.bold: true
            font.pixelSize: 12
        }
    }
}

