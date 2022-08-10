import QtQuick 2.0

Rectangle {
    width: 512
    height: 197

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Dizl.opacity
        onTriggered: {
            var par = ioBf.getParamKdrDizl();
            ind_TSP.value = par[0];
            ind_Tmx.value = par[1];
            ind_Tmn.value = par[2];
            ind_Tsr.value = par[3];

            ind_T1.value = par[4];
            stolbik1.value = ind_T1.value;

            ind_T2.value = par[5];
            stolbik2.value = ind_T2.value;

            ind_T3.value = par[6];
            stolbik3.value =ind_T3.value ;

            ind_T4.value = par[7];
            stolbik4.value = ind_T4.value;

            ind_T5.value = par[8];
            stolbik5.value = ind_T5.value;

            ind_T6.value = par[9];
            stolbik6.value = ind_T6.value;

            ind_D1.value = par[10];
            ind_D2.value = par[11];
            ind_D3.value = par[12];
            ind_D4.value = par[13];
            ind_D5.value = par[14];
            ind_D6.value = par[15];

            ind_Ttk1.value = par[16];
            ind_Ttk2.value = par[17];

            ind_Fd.value = par[18];

            rct_trTT1.visible = ! rct_trTT1.visible;
            rct_trTT2.visible = ! rct_trTT2.visible;

            txt_Trb.visible = ! txt_Trb.visible;
            txt_Zyl.visible = true;
            txt_Rej.visible = ! txt_Rej.visible;

            ioBf.getParamDiap(200); // ??????????????????????????????

        }

    }


    Image {
        id: image1
        y: 0
        z: 1
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrDiz_lin.png"

        Text {
            id: text1
            x: 337
            y: 83
            color: "lightGray"
            text: qsTr("F")
            font.bold: true
            font.pixelSize: 38
        }

        Text {
            id: text2
            x: 3
            y: 43
            color: "lightGray"
            text: qsTr("спай:")
            font.pixelSize: 12
            font.bold: true
        }

        Text {
            id: text3
            x: 9
            y: 81
            color: "#d3d3d3"
            text: qsTr("max")
            font.pixelSize: 10
            font.bold: true
        }

        Text {
            id: text4
            x: 10
            y: 119
            color: "#d3d3d3"
            text: qsTr("min")
            font.pixelSize: 10
            font.bold: true
        }

        Text {
            id: text5
            x: 13
            y: 151
            color: "#d3d3d3"
            text: qsTr("ср")
            font.pixelSize: 10
            font.bold: true
        }

        Text {
            id: text6
            x: 403
            y: 159
            color: "#d3d3d3"
            text: qsTr("вход в ТК1:")
            font.pixelSize: 10
            font.bold: true
        }

        Text {
            id: text7
            x: 403
            y: 177
            color: "#d3d3d3"
            text: qsTr("вход в ТК2:")
            font.pixelSize: 10
            font.bold: true
        }

        Text {
            id: text11
            x: 442
            y: 95
            color: "#d3d3d3"
            text: qsTr("о/м")
            font.bold: true
            font.pixelSize: 16
        }

        Text {
            id: text12
            x: 8
            y: 8
            color: "#f9f8f8"
            text: qsTr("ЦИЛИНДРЫ")
            textFormat: Text.AutoText
            styleColor: "#8877e4"
            font.bold: true
            font.pixelSize: 16
        }

        //**



        //***

        Text {
            id: text13
            x: 73
            y: 118
            height: 25
            color: "#d3d3d3"
            text: qsTr("000_______________________________")
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.bold: false
        }

        Text {
            id: text14
            x: 73
            y: 93
            height: 25
            color: "#d3d3d3"
            text: qsTr("200_______________________________")
            z: 2
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.bold: false
        }

        Text {
            id: text15
            x: 73
            y: 68
            height: 25
            color: "#d3d3d3"
            text: qsTr("400_______________________________")
            z: 3
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.bold: false
        }

        Text {
            id: text16
            x: 73
            y: 43
            height: 25
            color: "#d3d3d3"
            text: qsTr("600_______________________________")
            z: 4
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 14
            font.bold: false
        }

        Text {
            id: text17
            x: 73
            y: 26
            color: "#d3d3d3"
            text: qsTr("800_______________________________")
            z: 6
            font.pixelSize: 14
            font.bold: false

            //            Stolbik {
        }

        Rectangle {
            id: rct_trTT2
            x: 466
            y: 177
            width: 37
            height: 13
            color: "#f31a1a"
        }

        Rectangle {
            id: rct_trTT1
            x: 466
            y: 159
            width: 37
            height: 13
            color: "#f31a1a"
        }

        PrBar {
            id: stolbik1
            x: 101
            y: 43
            width: 21
            height: 100
            val_max: 800
            z: 1
            value: 0
            kind:0
        }

        PrBar {
            id: stolbik3
            x: 175
            y: 43
            width: 21
            height: 100
            value: 0
            kind:0
        }

        PrBar {
            id: stolbik4
            x: 212
            y: 43
            width: 21
            height: 100
            value: 0
            kind:0
        }

        Column {
            x: 326
            y: 12

            Text {
                id: txt_Trb
                color: "#a45fdc"
                text: qsTr("t газов перед ТК больше нормы")
                visible: true
                font.pixelSize: 10
                font.bold: true
            }

            Text {
                id: txt_Zyl
                color: "#a45fdc"
                text: qsTr("t газов цилиндров больше нормы")
                font.pixelSize: 10
                font.bold: true
            }

            Text {
                id: txt_Rej
                color: "#a45fdc"
                text: qsTr("Нарушение t режима цилиндров")
                font.pixelSize: 10
                font.bold: true
            }
        }

        PrBar {
            id: stolbik2
            x: 138
            y: 43
            width: 21
            height: 100
            value: 0
            kind:0
        }

        PrBar{
            id: stolbik5
            x: 250
            y: 43
            width: 21
            height: 100
            value: 0
            kind:0
        }

        PrBar {
            id: stolbik6
            x: 285
            y: 43
            width: 21
            height: 100
            value: 0
            kind:0
        }
    }

    TInd {
        id: ind_Tmx
        value: "000"
        x: 34
        y: 78
        width: 31
        height: 16
        z: 2
        txtColor: "#ffffff"
        txtSize: 10
    }

    TInd {
        id: ind_Tmn
        x: 34
        y: 112
        width: 31
        height: 16
        z: 3
        txtColor: "#ffffff"
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_Tsr
        x: 34
        y: 148
        width: 31
        height: 16
        z: 4
        txtColor: "#ffffff"
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_T1
        x: 96
        y: 148
        width: 31
        height: 16
        z: 5
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_T2
        x: 133
        y: 148
        width: 31
        height: 16
        z: 6
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_T3
        x: 170
        y: 148
        width: 31
        height: 16
        z: 7
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_T4
        x: 207
        y: 148
        width: 31
        height: 16
        z: 8
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_T5
        x: 244
        y: 148
        width: 31
        height: 16
        z: 9
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_T6
        x: 281
        y: 148
        width: 31
        height: 16
        z: 10
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_D1
        x: 96
        y: 175
        width: 31
        height: 16
        z: 11
        txtColor: "#ffffff"
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_D2
        x: 133
        y: 175
        width: 31
        height: 16
        z: 12
        txtColor: "#ffffff"
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_D3
        x: 170
        y: 175
        width: 31
        height: 16
        z: 13
        txtColor: "#ffffff"
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_D4
        x: 207
        y: 175
        width: 31
        height: 16
        z: 14
        txtColor: "#ffffff"
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_D5
        x: 244
        y: 175
        width: 31
        height: 16
        z: 15
        txtColor: "#ffffff"
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_D6
        x: 281
        y: 175
        width: 31
        height: 16
        z: 16
        txtColor: "#ffffff"
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_Ttk2
        x: 467
        y: 178
        width: 37
        height: 13
        color: "#00000000"
        z: 17
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_Ttk1
        x: 467
        y: 159
        width: 31
        height: 16
        color: "#00000000"
        z: 18
        txtSize: 10
        value: "000"
    }

    TInd {
        id: ind_TSP
        x: 34
        y: 43
        width: 31
        height: 16
        z: 19
        txtSize: 12
        value: "000"
    }

    TInd {
        id: ind_Fd
        x: 359
        y: 94
        height: 26
        color: "#808080"
        z: 20
        txtSize: 24
        txtColor: "#ffffff"
        border.color: "#00000000"
    }

    Row {
    }
}

