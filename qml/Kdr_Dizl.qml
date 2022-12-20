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

            f_d.value = par[1];
            t_hsp.value = par[2];

            t1.value = g1.value = par[3][0];
            t2.value = g2.value = par[3][1];
            t3.value = g3.value = par[3][2];
            t4.value = g4.value = par[3][3];
            t5.value = g5.value = par[3][4];
            t6.value = g6.value = par[3][5];

            tk1.value = par[4][0];
            tk2.value = par[4][1];

            t_max.value = par[5];
            t_min.value = par[6];
            t_sr.value = par[7];

            d1.value = par[8][0];
            d2.value = par[8][1];
            d3.value = par[8][2];
            d4.value = par[8][3];
            d5.value = par[8][4];
            d6.value = par[8][5];

            t1.visible = g1.visible = d1.visible = par[0] && (t1.value <= 990);
            t2.visible = g2.visible = d2.visible = par[0] && (t2.value <= 990);
            t3.visible = g3.visible = d3.visible = par[0] && (t3.value <= 990);
            t4.visible = g4.visible = d4.visible = par[0] && (t4.value <= 990);
            t5.visible = g5.visible = d5.visible = par[0] && (t5.value <= 990);
            t6.visible = g6.visible = d6.visible = par[0] && (t6.value <= 990);
            tk1.visible = par[0] && (tk1.value <= 990);
            tk2.visible = par[0] && (tk2.value <= 990);
            t_hsp.visible = t_max.visible = t_min.visible = t_sr.visible = par[0];

            // дискретные сигналы не используются:
//            rct_trTT1.visible = ! rct_trTT1.visible;
//            rct_trTT2.visible = ! rct_trTT2.visible;

//            txt_Trb.visible = ! txt_Trb.visible;
//            txt_Zyl.visible = true;
//            txt_Rej.visible = ! txt_Rej.visible;

//            ioBf.getParamDiap(200); // ??????????????????????????????

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
            id: text2
            x: 3
            y: 30
            color: "lightGray"
            text: qsTr("спай:")
            font.pixelSize: 12
            font.bold: true
        }

        TInd {
            id: t_hsp
            x: 34
            y: 32
            width: 31
            height: 16
            z: 19
            txtSize: 12
            value: "000"
        }



        // Cilinders
        Text {
            id: text12
            x: 0
            y: 0
            color: "#f9f8f8"
            text: qsTr("ЦИЛИНДРЫ")
            textFormat: Text.AutoText
            styleColor: "#8877e4"
            font.bold: true
            font.pixelSize: 14
        }

        Text {
            id: text13
            x: 100
            y: 106
            z: 1
            //height: 25
            color: "#d3d3d3"
            text: qsTr("000__________________________")
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 12
            font.bold: false
        }

        Text {
            id: text14
            x: 100
            y: 80
            //height: 25
            color: "#d3d3d3"
            text: qsTr("200__________________________")
            z: 2
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 12
            font.bold: false
        }

        Text {
            id: text15
            x: 100
            y: 54
            //height: 25
            color: "#d3d3d3"
            text: qsTr("400__________________________")
            z: 3
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 12
            font.bold: false
        }

        Text {
            id: text16
            x: 100
            y: 26
            //height: 25
            color: "#d3d3d3"
            text: qsTr("600__________________________")
            z: 4
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 12
            font.bold: false
        }

        Text {
            id: text17
            x: 100
            y: 2
            //height: 25
            color: "#d3d3d3"
            text: qsTr("800__________________________")
            z: 5
            font.pixelSize: 12
            font.bold: false
            verticalAlignment: Text.AlignBottom
            //            Stolbik {
        }



        PrBar {
            id: g1
            x: 133
            y: 16
            width: 21
            height: 104
            val_max: 800
            z: 1
            value: 0
            kind:0
        }

        PrBar {
            id: g2
            x: 164
            y: 16
            width: 21
            height: 104
            value: 0
            kind:0
        }

        PrBar {
            id: g3
            x: 195
            y: 16
            width: 21
            height: 104
            value: 0
            kind:0
        }

        PrBar {
            id: g4
            x: 226
            y: 16
            width: 21
            height: 104
            value: 0
            kind:0
        }

        PrBar{
            id: g5
            x: 257
            y: 16
            width: 21
            height: 104
            value: 0
            kind:0
        }

        PrBar {
            id: g6
            x: 288
            y: 16
            width: 21
            height: 104
            value: 0
            kind:0
        }

        TInd {
            id: t1
            x: 129
            y: 128
            width: 31
            height: 16
            z: 5
            txtSize: 12
            value: "000"
        }

        TInd {
            id: t2
            x: 160
            y: 128
            width: 31
            height: 16
            z: 6
            txtSize: 12
            value: "000"
        }

        TInd {
            id: t3
            x: 191
            y: 128
            width: 31
            height: 16
            z: 7
            txtSize: 10
            value: "000"
        }

        TInd {
            id: t4
            x: 222
            y: 128
            width: 31
            height: 16
            z: 8
            txtSize: 12
            value: "000"
        }

        TInd {
            id: t5
            x: 253
            y: 128
            width: 31
            height: 16
            z: 9
            txtSize: 12
            value: "000"
        }

        TInd {
            id: t6
            x: 284
            y: 128
            width: 31
            height: 16
            z: 10
            txtSize: 12
            value: "000"
        }

        TInd {
            id: d1
            x: 129
            y: 144
            width: 31
            height: 16
            z: 11
            txtColor: "#ffffff"
            txtSize: 12
            value: "000"
        }

        TInd {
            id: d2
            x: 160
            y: 144
            width: 31
            height: 16
            z: 12
            txtColor: "#ffffff"
            txtSize: 12
            value: "000"
        }

        TInd {
            id: d3
            x: 191
            y: 144
            width: 31
            height: 16
            z: 13
            txtColor: "#ffffff"
            txtSize: 12
            value: "000"
        }

        TInd {
            id: d4
            x: 222
            y: 144
            width: 31
            height: 16
            z: 14
            txtColor: "#ffffff"
            txtSize: 12
            value: "000"
        }

        TInd {
            id: d5
            x: 253
            y: 144
            width: 31
            height: 16
            z: 15
            txtColor: "#ffffff"
            txtSize: 12
            value: "000"
        }

        TInd {
            id: d6
            x: 284
            y: 144
            width: 31
            height: 16
            z: 16
            txtColor: "#ffffff"
            txtSize: 12
            value: "000"
        }
        // max, min, average
        TInd {
            id: t_max
            value: "000"
            x: 12
            y: 128
            width: 31
            height: 16
            z: 2
            txtColor: "#ffffff"
            txtSize: 12
        }

        TInd {
            id: t_min
            x: 44
            y: 128
            width: 31
            height: 16
            z: 3
            txtColor: "#ffffff"
            txtSize: 12
            value: "000"
        }

        TInd {
            id: t_sr
            x: 76
            y: 128
            width: 31
            height: 16
            z: 4
            txtColor: "#ffffff"
            txtSize: 12
            value: "000"
        }

        Text {
            id: text_max
            x: 16
            y: 144
            color: "#d3d3d3"
            text: qsTr("max")
            font.pixelSize: 10
            font.bold: true
        }

        Text {
            id: text_min
            x: 48
            y: 144
            color: "#d3d3d3"
            text: qsTr("min")
            font.pixelSize: 10
            font.bold: true
        }

        Text {
            id: text_avg
            x: 80
            y: 144
            color: "#d3d3d3"
            text: qsTr("ср")
            font.pixelSize: 10
            font.bold: true
        }

        Text {
            id: text6
            x: 40
            y: 160
            color: "#d3d3d3"
            text: qsTr("вход в ТК1:")
            font.pixelSize: 10
            font.bold: true
        }

        Text {
            id: text7
            x: 40
            y: 176
            color: "#d3d3d3"
            text: qsTr("вход в ТК2:")
            font.pixelSize: 10
            font.bold: true
        }


        TInd {
            id: tk1
            x: 129
            y: 160
            width: 31
            height: 16
            color: "#00000000"
            z: 18
            txtSize: 12
            value: "000"
        }

        TInd {
            id: tk2
            x: 129
            y: 176
            width: 31
            height: 13
            color: "#00000000"
            z: 17
            txtSize: 12
            value: "000"
        }



            Text {
                id: txt_Zyl
                x: 314
                y: 12
                color: "yellow"
                text: qsTr("t газов цилиндров больше нормы")
                font.pixelSize: 12
                font.bold: true
                visible: false
            }

            Text {
                id: txt_Rej
                x: 314
                y: 28
                color: "yellow"
                text: qsTr("Нарушение t режима цилиндров")
                font.pixelSize: 12
                font.bold: true
                visible: false
            }

            Text {
                id: txt_Trb
                x: 160
                y: 174
                color: "yellow"
                text: qsTr("t газов перед ТК больше нормы")
                font.pixelSize: 12
                font.bold: true
                visible: false
            }
            // N (F)
            Text {
                id: text1
                x: 337
                y: 83
                color: "lightGray"
                text: qsTr("F")
                font.bold: true
                font.pixelSize: 38
            }

            TInd {
                id: f_d
                x: 357
                y: 102
                width: 56
                height: 26
                color: "#808080"
                z: 20
                txtSize: 24
                txtColor: "#ffffff"
                border.color: "#00000000"
            }

            Text {
                id: text11
                x: 419
                y: 103
                color: "#d3d3d3"
                text: qsTr("об/мин")
                font.bold: true
                font.pixelSize: 16
            }
    }
}


/*##^##
Designer {
    D{i:0;formeditorZoom:1.5}
}
##^##*/
