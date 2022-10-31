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

            ind_Fd.value = par[0];
            ind_TSP.value = par[1];


            ind_T1.value = par[2];
            stolbik1.value = ind_T1.value;

            ind_T2.value = par[3];
            stolbik2.value = ind_T2.value;

            ind_T3.value = par[4];
            stolbik3.value =ind_T3.value ;

            ind_T4.value = par[5];
            stolbik4.value = ind_T4.value;

            ind_T5.value = par[6];
            stolbik5.value = ind_T5.value;

            ind_T6.value = par[7];
            stolbik6.value = ind_T6.value;


            ind_Ttk1.value = par[8];
            ind_Ttk2.value = par[9];

            ind_Tmx.value = par[10];
            ind_Tmn.value = par[11];
            ind_Tsr.value = par[12];

            ind_D1.value = par[13];
            ind_D2.value = par[14];
            ind_D3.value = par[15];
            ind_D4.value = par[16];
            ind_D5.value = par[17];
            ind_D6.value = par[18];

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
            id: text2
            x: 3
            y: 30
            color: "lightGray"
            text: qsTr("спай:")
            font.pixelSize: 12
            font.bold: true
        }

        TInd {
            id: ind_TSP
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
            id: stolbik1
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
            id: stolbik2
            x: 164
            y: 16
            width: 21
            height: 104
            value: 0
            kind:0
        }

        PrBar {
            id: stolbik3
            x: 195
            y: 16
            width: 21
            height: 104
            value: 0
            kind:0
        }

        PrBar {
            id: stolbik4
            x: 226
            y: 16
            width: 21
            height: 104
            value: 0
            kind:0
        }

        PrBar{
            id: stolbik5
            x: 257
            y: 16
            width: 21
            height: 104
            value: 0
            kind:0
        }

        PrBar {
            id: stolbik6
            x: 288
            y: 16
            width: 21
            height: 104
            value: 0
            kind:0
        }

        TInd {
            id: ind_T1
            x: 129
            y: 128
            width: 31
            height: 16
            z: 5
            txtSize: 12
            value: "000"
        }

        TInd {
            id: ind_T2
            x: 160
            y: 128
            width: 31
            height: 16
            z: 6
            txtSize: 12
            value: "000"
        }

        TInd {
            id: ind_T3
            x: 191
            y: 128
            width: 31
            height: 16
            z: 7
            txtSize: 10
            value: "000"
        }

        TInd {
            id: ind_T4
            x: 222
            y: 128
            width: 31
            height: 16
            z: 8
            txtSize: 12
            value: "000"
        }

        TInd {
            id: ind_T5
            x: 253
            y: 128
            width: 31
            height: 16
            z: 9
            txtSize: 12
            value: "000"
        }

        TInd {
            id: ind_T6
            x: 284
            y: 128
            width: 31
            height: 16
            z: 10
            txtSize: 12
            value: "000"
        }

        TInd {
            id: ind_D1
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
            id: ind_D2
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
            id: ind_D3
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
            id: ind_D4
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
            id: ind_D5
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
            id: ind_D6
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
            id: ind_Tmx
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
            id: ind_Tmn
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
            id: ind_Tsr
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
            id: ind_Ttk1
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
            id: ind_Ttk2
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
                id: ind_Fd
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
