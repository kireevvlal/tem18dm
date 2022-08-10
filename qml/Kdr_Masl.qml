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
            ind_PiD.value = par[0]; //ioBf.getParam();
            ind_TiD.value = par[1]; //ioBf.getParam();
            ind_ToD.value = par[2]; //ioBf.getParam();
            ind_PiD.value = par[3]; //ioBf.getParam();
            ind_PoD.value = par[4]; //ioBf.getParam();
            ind_Fd.value = par[5]; //ioBf.getParam();
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
            x: 13
            y: 8
            color: "#f9f8f8"
            text: qsTr("МАСЛО")
            font.bold: true
            font.pixelSize: 14
        }

        TInd {
            id: ind_PiD
            x: 13
            y: 67
            width: 37
            height: 13
        }

        TInd {
            id: ind_TiD
            x: 119
            y: 113
            width: 37
            height: 13
        }

        TInd {
            id: ind_ToD
            x: 376
            y: 113
            width: 37
            height: 13
        }

        TInd {
            id: ind_PoD
            x: 457
            y: 67
            width: 37
            height: 13
        }

        TInd {
            id: ind_Fd
            x: 190
            y: 131
            height: 26
            color: "gray"
            txtColor: "white"
            txtSize: 24
            border.color: "#00000000"
        }
    }
}

