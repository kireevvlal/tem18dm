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
            ind_Oby.value = par[0];
            ind_Mss.value = par[1];
            ind_PiF.value = par[2].toFixed(2);
            ind_dP.value = Math.abs(par[3]).toFixed(2);
            ind_PiD.value = par[4].toFixed(2);
            ind_Ttn.value = par[5];
            ind_Fd.value = par[6];
            ind_PiF.color = ind_PiD.color = (par[7] & 1) ? "red" : "black";
            xTp.visible = par[7] & 1;
        }

    }

    Image {
        id: image1
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrTpl_lin.png"

        TInd {
            id: ind_Ttn
            x: 257
            y: 165
            width: 37
            height: 13
        }

        TInd {
            id: ind_PiF
            x: 257
            y: 61
            width: 37
            height: 13
        }

        TInd {
            id: ind_dP
            x: 257
            y: 96
            width: 37
            height: 13
        }

        TInd {
            id: ind_Oby
            x: 13
            y: 140
            width: 37
            height: 18
            visible: false;
        }

        TInd {
            id: ind_PiD
            x: 257
            y: 129
            width: 37
            height: 13
        }


        TInd {
            id: ind_Mss
            x: 13
            y: 165
            width: 37
            height: 13
            visible: false;
        }

        TInd {
            id: ind_Fd
            x: 404
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
            x: 450
            y: 140
            color: "silver"
            text: qsTr("об/мин")
            font.pixelSize: 12
            font.family: main_window.deffntfam
        }

        Text {
            id: text1
            x: 0
            y: 0
            color: "#f9f8f8"
            text: qsTr("ТОПЛИВО")
            font.bold: true
            font.pixelSize: 14
            font.family: main_window.deffntfam
        }

        Text {
            id: xTp
            x: 184
            y: 9
            color: "yellow"
            text: qsTr("P топлива ниже нормы")
            font.bold: true
            font.pixelSize: 12
            font.family: main_window.deffntfam
        }
    }

}

