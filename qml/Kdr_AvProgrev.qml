import QtQuick 2.0

Rectangle {
    width: 512
    height: 197

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_AvProgrev.opacity

        onTriggered: {
            var par = ioBf.getParamKdrAvProgrev();
            ind_Ubs.value = par[0]; //ioBf.getParam();
            ind_Izb.value = par[1]; //ioBf.getParam();
            ind_TmsOtD.value = par[2].toFixed(2); //ioBf.getParamExt(2);
            ind_TvdOtD.value = par[3].toFixed(2); //ioBf.getParamExt(2);
            ind_TvdInK.value = par[4].toFixed(2); //ioBf.getParamExt(2);
            ind_TvdOtK.value = par[5].toFixed(2); //ioBf.getParamExt(2);
            ind_TvzOkr.value = par[6].toFixed(2); //ioBf.getParamExt(2);
            ind_Fd.value = par[7]; //ioBf.getParam();
        }

    }


    Image {
        id: image1
        z: 1
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrDiz_lin.png"

        Text {
            id: text1
            x: 341
            y: 70
            color: "lightGray"
            text: qsTr("F")
            font.bold: true
            font.pixelSize: 38
            font.family: main_window.deffntfam
        }

        Text {
            id: text3
            x: 177
            y: 32
            color: "#d3d3d3"
            text: qsTr("Uбс:")
            font.pixelSize: 14
            font.bold: true
            font.family: main_window.deffntfam
        }

        Text {
            id: text11
            x: 448
            y: 89
            color: "#d3d3d3"
            text: qsTr("о/м")
            font.bold: true
            font.pixelSize: 16
            font.family: main_window.deffntfam
        }

        Text {
            id: text12
            x: 8
            y: 8
            color: "#f9f8f8"
            text: qsTr("АВТОПРОГРЕВ")
            textFormat: Text.AutoText
            styleColor: "#8877e4"
            font.bold: true
            font.pixelSize: 16
            font.family: main_window.deffntfam
        }


        Text {
            id: text4
            x: 177
            y: 55
            color: "#d3d3d3"
            text: qsTr("Iзб:")
            font.bold: true
            font.pixelSize: 14
            font.family: main_window.deffntfam
        }

        Text {
            id: text6
            x: 41
            y: 106
            width: 161
            height: 17
            color: "#d3d3d3"
            text: qsTr("воды (выход дизеля):")
            font.bold: true
            font.pixelSize: 14
            font.family: main_window.deffntfam

            Text {
                id: text5
                x: 0
                y: -21
                width: 161
                height: 17
                color: "#d3d3d3"
                text: qsTr("масла (выход дизеля):")
                font.bold: true
                font.pixelSize: 14
                font.family: main_window.deffntfam
            }

            Text {
                id: text10
                x: -29
                y: -34
                color: "#d3d3d3"
                text: qsTr("t")
                font.bold: true
                font.pixelSize: 44
                font.family: main_window.deffntfam
            }
        }

        Text {
            id: text7
            x: 41
            y: 126
            width: 161
            height: 17
            color: "#d3d3d3"
            text: qsTr("воды (вход калорифера):")
            font.bold: true
            font.pixelSize: 14
            font.family: main_window.deffntfam
        }

        Text {
            id: text8
            x: 41
            y: 168
            width: 161
            height: 17
            color: "#d3d3d3"
            text: qsTr("воздуха окружающего:")
            font.bold: true
            font.pixelSize: 14
            font.family: main_window.deffntfam
        }

        Text {
            id: text9
            x: 41
            y: 145
            width: 161
            height: 17
            color: "#d3d3d3"
            text: qsTr("воды (выход калорифера):")
            font.bold: true
            font.pixelSize: 14
            font.family: main_window.deffntfam
        }

        Text {
            id: text13
            x: 293
            y: 32
            color: "#d3d3d3"
            text: qsTr("В")
            font.bold: true
            font.pixelSize: 14
            font.family: main_window.deffntfam
        }

        Text {
            id: text14
            x: 293
            y: 56
            width: 12
            height: 16
            color: "#d3d3d3"
            text: qsTr("А")
            font.bold: true
            font.pixelSize: 14
            font.family: main_window.deffntfam
        }

        Text {
            id: text15
            x: 293
            y: 90
            width: 12
            height: 16
            color: "#d3d3d3"
            text: qsTr("С")
            font.bold: true
            font.pixelSize: 14
            font.family: main_window.deffntfam
        }
    }

    TInd {
        id: ind_Ubs
        value: "000"
        x: 246
        y: 33
        width: 31
        height: 16
        z: 2
        txtColor: "#00ffff"
        txtSize: 14
    }

    TInd {
        id: ind_Izb
        x: 246
        y: 55
        width: 31
        height: 16
        z: 5
        txtSize: 14
        value: "000"
    }

    TInd {
        id: ind_TmsOtD
        x: 246
        y: 88
        width: 31
        height: 16
        z: 6
        txtSize: 14
        value: "000"
    }

    TInd {
        id: ind_TvdOtD
        x: 246
        y: 110
        width: 31
        height: 16
        z: 7
        txtSize: 14
        value: "000"
    }

    TInd {
        id: ind_TvdInK
        x: 246
        y: 132
        width: 31
        height: 16
        z: 8
        txtSize: 14
        value: "000"
    }

    TInd {
        id: ind_TvdOtK
        x: 246
        y: 154
        width: 31
        height: 16
        z: 9
        txtSize: 14
        value: "000"
    }

    TInd {
        id: ind_TvzOkr
        x: 246
        y: 176
        width: 31
        height: 16
        z: 10
        txtSize: 14
        value: "000"
    }

    TInd {
        id: ind_Fd
        x: 364
        y: 88
        height: 26
        color: "#808080"
        z: 20
        txtSize: 24
        txtColor: "#ffffff"
        border.color: "#00000000"
    }
}

