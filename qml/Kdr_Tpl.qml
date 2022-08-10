import QtQuick 2.0
Rectangle {
    width: 512
    height: 197

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Toplivo.opacity
        onTriggered: {
            var par = ioBf.getParamKdrTpl();
            ind_Ttn.value = par[0];
            ind_PiF.value = par[1];
            ind_P.value = par[2];
            ind_PiD.value = par[3];
            ind_Oby.value = par[4];
            ind_Mss.value = par[5];
            ind_Z.value = par[6];
            ind_Fd.value = par[7];
//            ind_Ttn.value = ioBf.getParam();
//            ind_PiF.value = ioBf.getParam();
//            ind_P.value = ioBf.getParam();
//            ind_PiD.value = ioBf.getParam();
//            ind_Oby.value = ioBf.getParam();
//            ind_Mss.value = ioBf.getParam();
//            ind_Z.value = ioBf.getParam();
//            ind_Fd.value = ioBf.getParam();

        }

    }

    Image {
        id: image1
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrTpl_lin.png"

        TInd {
            id: ind_Ttn
            x: 121
            y: 106
            width: 37
            height: 13
        }

        TInd {
            id: ind_PiF
            x: 271
            y: 62
            width: 37
            height: 13
        }

        TInd {
            id: ind_P
            x: 271
            y: 106
            width: 37
            height: 13
        }

        TInd {
            id: ind_PiD
            x: 271
            y: 152
            width: 37
            height: 13
        }

        TInd {
            id: ind_Oby
            x: 17
            y: 62
            width: 37
            height: 18
        }

        TInd {
            id: ind_Mss
            x: 17
            y: 101
            width: 37
            height: 13
        }

        TInd {
            id: ind_Z
            x: 429
            y: 60
            width: 37
            height: 13
        }

//        TInd {
//            id: ind_Fd
//            x: 523
//            y: 172
//            width: 46
//            height: 16
//            color: "#7f7b7b"
//            txtColor: "white"
//            txtSize: 19
//        }
       TInd {
            id: ind_Fd
            x: 404
            y: 130
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
            text: qsTr("ТОПЛИВО")
            font.bold: true
            font.pixelSize: 14
        }
    }
}

