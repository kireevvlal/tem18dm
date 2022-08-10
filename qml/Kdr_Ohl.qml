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
            ind_TiVN2.value = par[0];
            ind_TiD.value = par[1];
            ind_ToD.value = par[2];
            ind_Fd.value = par[3];
        }

    }

    Image {
        id: image1
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrOhl_lin.png"

        TInd {
            id: ind_TiVN2
            x: 64
            y: 84
            width: 37
            height: 13
        }

        TInd {
            id: ind_TiD
            x: 215
            y: 84
            width: 37
            height: 13
        }

        TInd {
            id: ind_ToD
            x: 451
            y: 84
            width: 37
            height: 13
        }

//        TInd {
//            id: ind_Fd
//            x: 418
//            y: 169
//            width: 69
//            height: 30
//            color: "#2f2727"
//            txtSize: 26
//            txtColor: "#ffffff"
//        }

        TInd {
            id: ind_Fd
            x: 326
            y: 132
            height: 26
            color: "gray"
            txtColor: "white"
            txtSize: 24
            border.color: "#00000000"
        }


        Text {
            id: text1
            x: 17
            y: 8
            color: "#f9f8f8"
            text: qsTr("ОХЛАЖДЕНИЕ")
            font.bold: true
            font.pixelSize: 15
        }
    }
}

