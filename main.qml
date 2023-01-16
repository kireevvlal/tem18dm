import QtQuick 2.7
import QtQuick.Window 2.2
import "qml"

Window {
    id: main_window
    width: 640
    height: 480
    visible: true
    color: "black"
    property alias kdr_Masl: kdr_Masl
//    flags: Qt.FramelessWindowHint | Qt.Window
    title: qsTr("TEM18DM Bi05-04 640x480")

//    rotation: 0
//    scale: 1
//    z: 100
//    focus: true
    property int cnt: 0;
    property int current_section: 1; // 1 - own, 2 - extra
    property bool is_slave: false; // true - is exchange with slave locomotive
    property bool is_links: false; // true - is exchange with BEL or USTA or TI
    property int current_system: 0; // 0 - not 1 - diesel, 2 - electro, 3 - links
//    property int current_subsystem: 0; // 0 - not

//    signal setKdr(kdr: int);

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running:  true
        Component.onCompleted: {
            // KVA Fix screen blink
            opastyNul(); // все экраны в невидимое состояние
            // все менюшки в начальное невидимое состояние
            kdr_FootDizel.opacity=0;
            kdr_FootElektrooborud.opacity=0;
            kdr_FootUso.opacity = 0;
            kdr_Foot_Usta.opacity=0;
            kdr_FootBEL.opacity=0;
            kdr_Foot_TI.opacity=0;

            kdr_Foot.opacity = 1;
            kdr_Foot.focus = true;

            kdr_Main_small.opacity = 1; // главный маленький
        }
        onTriggered: {
            var par = ioBf.getParamMainWindow();
            // frame_Left
            is_slave = par[0][3]; // связь по МСС
            is_links = par[0][0] || par[0][1] || par[0][2]; // Связь БЭЛ, УСТА, ТИ

            var is_slave_usta = par[0][3] && par[0][4]; // есть связь МСС и на slave есть связь с УСТА

            pr_Mtg1.value = par[1].toFixed(0); //ioBf.getParamDiap(1500);// заглушка
            pr_Mtg2.value = par[2].toFixed(0);// ioBf.getParamDiap(1500); // заглушка

            indUb0.text = par[3].toFixed(0); //ioBf.getParamDiap(100);// заглушка
            indUb1.text = par[4].toFixed(0); //ioBf.getParamDiap(100);// заглушка

            indIz0.text = par[5].toFixed(0); //ioBf.getParamDiap(60);// заглушка
            indIz1.text = par[6].toFixed(0); //ioBf.getParamDiap(60);// заглушка

            in1OM1.visible = par[7][0] && par[0][1];
            in1OM2.visible = par[7][1] && par[0][1];
            in1BX.visible = par[7][2] && par[0][1];
            in1DR.visible = par[7][3] && par[0][1];
            in1RZ.visible = par[7][4] && par[0][1];
            in1OT.visible = par[7][5] && par[0][1];

            in2OM1.visible = par[8][0] && is_slave_usta;
            in2OM2.visible = par[8][1] && is_slave_usta;
            in2BX.visible = par[8][2] && is_slave_usta;
            in2DR.visible = par[8][3] && is_slave_usta;
            in2RZ.visible = par[8][4] && is_slave_usta;
            in2OT.visible = par[8][5] && is_slave_usta;

            indUb0.visible = indIz0.visible = pr_Mtg1.visible = par[0][1];
            indUb1.visible = indIz1.visible = pr_Mtg2.visible = is_slave_usta;
            txtUb.visible = txtV.visible = txtIz.visible = txtA.visible = par[0][1] || is_slave_usta;

            // frame_Top
            pkm.pkms = par[10][0];
            revers.value = par[10][1];
            regim.value = par[10][2]; // режим работы тепловоза

            txt_time.text = par[11][0];
            txt_data.text = par[11][1];
            txt_RejPrT.text = par[12][0];
            txt_RejPro.text = par[12][1]; // прожиг
            txt_RejAP.text = par[12][2]; // автопрогрев
            txt_RejPrTime.text = par[13][0]; //ioBf.getRejPrT("value");// --- косяк с разными значениями --че делать то?
            txt_RejPrTime.color = (par[13][1] == "2") ?  "yellow" : "gray";
            txt_RejPrT.opacity = (par[13][2] == "1") ? 1 : 0;

            // save to USB
            insertedUSB.visible = par[14][0];
            recordUSB.visible = recUSBprBar.visible = par[14][1];
            recUSBprBar.value = par[14][2];

            indPt.value = par[15][0];
            var start = par[15][1];
            var finish = par[15][2];
            if (indPt.start != start) {
                indPt.start = start;
                indPt.repaint = true;
            }
            if (indPt.finish != finish) {
                indPt.finish = finish;
                indPt.repaint = true;
            }
            indPm.value = par[15][3];
            start = par[15][4];
            finish = par[15][5];
            if (indPm.start != start) {
                indPm.start = start;
                indPm.repaint = true;
            }
            if (indPm.finish != finish) {
                indPm.finish = finish;
                indPm.repaint = true;
            }
            indFd.value = par[15][6];
            start = par[15][7];
            finish = par[15][8];
            if (indFd.start != start) {
                indFd.start = start;
                indFd.repaint = true;
            }
            if (indFd.finish != finish) {
                indFd.finish = finish;
                indFd.repaint = true;
            }

            indPt.visible = indPm.visible = indFd.visible = par[9];
            // Trevoga messages
            if (par[16][0] != "") {
                if (!kdr_Tre.opacity)
                    ioBf.playSoundOnShowBanner();
                kdr_Tre.opacity = 1;
                kdr_Tre.focus = true;
                kdr_Tre.str1 = par[16][0];
                kdr_Tre.str2 = par[16][1];
            } else
            if (kdr_Tre.opacity) {
                kdr_Tre.opacity = 0;
                //kdr_Tre.focus = false;
                switch (current_system) {
                case 0:
                    kdr_Foot.opacity = 1;
                    kdr_Foot.focus = true;
                    break;
                case 1:
                    kdr_FootDizel.opacity = 1;
                    kdr_FootDizel.focus = true;
                    break;
                case 2:
                    kdr_FootElektrooborud.opacity = 1;
                    kdr_FootElektrooborud.focus = true;
                    break;
                case 3:
                    kdr_FootUso.opacity = 1;
                    kdr_FootUso.focus = true;
                    break;
                case 4:
                    kdr_Foot.opacity = 1;
                    kdr_Foot.focus = true;
                    break;
                case 5:
                    kdr_Foot.opacity = 1;
                    kdr_Foot.focus = true;
                    break;
                case 6:
                    kdr_Foot.opacity = 1;
                    kdr_Foot.focus = true;
                    break;
                case 7:
                    kdr_Foot.opacity = 1;
                    kdr_Foot.focus = true;
                    break;
                }
            }
       }
}

// расставляем компоненты

    Item {
        id: frame_Top
        x: 0
        y: 0

        TPKM {
            id: pkm
            x: 10
            y: 10
            width: 64
            color: "#000000"
            pkms: 5
        }

        TRevers {
            id: revers
            x: 10
            y: 41
        }

        TRegm {
            id: regim
            x: 4
            y: 83
            height: 25
            value: 1
        }

        Text {
            id: txt_RejPrTime
            x: 4
            y: 118
            width: 80
            color: "#6e6e63"
            text: qsTr("00:00:00")
            font.family: "Segoe UI Emoji"
            clip: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            font.pointSize: 12
            visible: false // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        }

        Image {
            id: insertedUSB
            x: 4
            y: 128
            width: 22
            height: 40
            clip: false
            source: "../Pictogram/flesh1.png"
            visible: false
        }

        Image {
            id: recordUSB
            x: 26
            y: 137
            width: 35
            height: 19
            clip: true
            source: "../Pictogram/flesh zapis1.png"
            visible: false

        }

        PrBar {
            id: recUSBprBar
            x: 61
            y: 138
            width: 61
            height: 14
            clip: true
            kind: 1
            val_max: 100
            value: 0
            visible: false
        }

        Rectangle {
            id: header
            x: 129
            y: 1
            height: 24
            width: 320
            color: (main_window.current_section == 1 ?"black" : "gray")
            Text {
                id: header_text
                width: parent.width
    //            x: 129
    //            y: 2
                color: (main_window.current_section == 1 ?"#d2e8fb" : "black")
                text: (main_window.current_section == 1 ? qsTr("ТЭМ18ДМ  №101") : qsTr("выбрана вторая секция"))
                font.bold: true
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Text {
            id: txt_RejPrT
            x: 128
            y: 27
            color: "#f0f026"
            text: qsTr("Длительный х.ход! Установи 8 ПКМ на 10 минут")
            font.pointSize: 10
            font.bold: true
        }

        Text {
            id: txt_RejPro
            x: 128
            y: 43
            color: "#f0f026"
            text: qsTr("Прожиг коллектора")
            font.pointSize: 10
            font.bold: true
            style: Text.Outline
        }

        Text {
            id: txt_RejAP
            x: 128
            y: 59
            color: "#f0f026"
            text: qsTr("Режим автопрогрева")
            font.family: "Segoe UI Historic"
            font.pointSize: 10
            font.bold: true
        }

        Text {
            id: txt_time
            x: 528
            y: 8
            color: "#d2e8fb"
            text: qsTr("время")
            horizontalAlignment: Text.AlignRight
            font.family: "Segoe UI Emoji"
            font.pointSize: 12
            font.bold: true
        }

        Text {
            id: txt_data
            x:  528
            y: 25
            color: "#d2e8fb"
            text: qsTr("дата")
            font.family: "Segoe UI Emoji"
            font.pointSize: 12
            font.bold: true
        }

        ExtCircularGauge {
            id: indPt
            x: 128
            y: 74
            width: 150
            height: 150
            maximumValue: 1.2
            minimumValue: 0
            parameter: "Рт МПа"
            start: 0.9
            finish: 1.2
            valuePrecision: 2
            labelPrecision: 1
        }

        ExtCircularGauge {
            id: indPm
            x: 292
            y: 74
            width: 150
            height: 150
            maximumValue: 1.2
            minimumValue: 0
            parameter: "Рм МПа"
            start: 0.9
            finish: 1.2
            valuePrecision: 2
            labelPrecision: 1
        }
        ExtCircularGauge {
            id: indFd
            x: 458
            y: 54
            width: 170
            height: 170
            maximumValue: 900
            minimumValue: 0
            parameter: "F об/мин"
            start: 600
            finish: 750
        }
    }

    Item {
        id: frame_Left
        x: 0
        y: 0
        Text {
            id: txtUb
            x: 8
            y: 182
            width: 23
            height: 17
            color: "#acb3b3"
            text: qsTr("Uб:")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: indUb0
            x: 40
            y: 182
            width: 23
            height: 17
            color: "#d2e8fb"
            text: qsTr("0")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: txtV
            x: 78
            y: 182
            width: 23
            height: 17
            color: "#acb3b3"
            text: qsTr("В")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: indUb1
            x: 104
            y: 182
            width: 23
            height: 17
            color: "#d2e8fb"
            text: qsTr("0")
            font.family: "Segoe UI Black"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }



        Text {
            id: txtIz
            x: 8
            y: 198
            width: 23
            height: 18
            color: "#acb3b3"
            text: qsTr("Iз:")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: indIz0
            x: 40
            y: 198
            width: 23
            height: 17
            color: "#d2e8fb"
            text: qsTr("0")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: txtA
            x: 78
            y: 198
            width: 23
            height: 18
            color: "#acb3b3"
            text: qsTr("А")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: indIz1
            x: 104
            y: 198
            width: 23
            height: 17
            color: "#d2e8fb"
            text: qsTr("0")
            font.family: "Segoe UI Emoji"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }


        ExtBeads {
            id: pr_Mtg1
            x: 38
            y: 217
            height: 195
            width: 28
            cntitems: 15
            colors: ["#f01f00", "#f02f00", "#f03f00", "#f04f00", "#f05f00", "#f06f00", "#f07f00", "#f08f00", "#f09f99", "#f0afaa", "#f0bfbb", "#f0cfcc", "#f0dfdd", "#f0efee", "#f0ffff"]
            value: 0
            maxvalue: 1500
        }

        ExtBeads {
            id: pr_Mtg2
            x: 102
            y: 217
            height: 195
            width: 28
            cntitems: 15
            colors: ["#f01f00", "#f02f00", "#f03f00", "#f04f00", "#f05f00", "#f06f00", "#f07f00", "#f08f00", "#f09f99", "#f0afaa", "#f0bfbb", "#f0cfcc", "#f0dfdd", "#f0efee", "#f0ffff"]
            value: 1500
            maxvalue: 1500
        }

        TInd {
            id: in1OM1
            x: 5
            y: 217
            width: 30
            height: 30
            radius: 2
            gradient: Gradient {
                GradientStop {position: 0;color: "#aca6a6"}
                GradientStop {position: 0.5; color: "#e4d6d6"}
                GradientStop {position: 1;color: "#aca6a6"}
            }
            txtSize: 16
            txtColor: "#000000"
            value: "ОМ"
            border.width: 0
            border.color: "#e4d6d6"
        }

        TInd {
            id: in1OM2
            x: 5
            y: 250
            width: 30
            height: 30
            radius: 2
            gradient: Gradient {
                GradientStop {position: 0;color: "#aca6a6"}
                GradientStop {position: 0.5; color: "#e4d6d6"}
                GradientStop {position: 1;color: "#aca6a6"}
            }
            txtSize: 16
            txtColor: "#000000"
            value: "ОМ"
            border.width: 0
            border.color: "#e4d6d6"
        }

        Image {
            id: in1BX
            x: 5
            y: 283
            width: 30
            height: 30
            source: "../Pictogram/ind_box.png"
        }

        TInd {
            id: in1DR
            x: 5
            y: 316
            width: 30
            height: 30
            color: "#160000"
            radius: 2
            txtSize: 15
            txtColor: "red"
            border.width: 2
            border.color: "red"
            value: "ДРУ"
            gradient: Gradient{
                GradientStop {position:0.0; color: "silver"}
                GradientStop {position:0.3; color: "black"}
                GradientStop {position:0.7; color: "black"}
                GradientStop {position:1; color: "silver"}
            }
        }


        TInd {
            id: in1RZ
            x: 5
            y: 349
            width: 30
            height: 30
            radius: 2
            txtSize: 18
            txtColor: "yellow"
            value: "РЗ"
            border.width: 2
            border.color: "yellow"
            gradient: Gradient{
                GradientStop {position:0.0; color: "silver"}
                GradientStop {position:0.3; color: "black"}
                GradientStop {position:0.7; color: "black"}
                GradientStop {position:1; color: "silver"}
            }

        }

        TInd {
            id: in1OT
            x: 5
            y: 382
            width: 30
            height: 30
            radius: 2
            gradient: Gradient {
                GradientStop { position: 0; color: "#ffff00"}
                GradientStop {position: 0.5;color: "#ffffff"}
                GradientStop {position: 1;color: "#ffff00"}
            }
            txtSize: 15
            txtColor: "#000000"
            value: "ОТМ"
            border.width: 0
            border.color: "#ffff00"
        }



        TInd {
            id: in2OM1
            x: 69
            y: 217
            width: 30
            height: 30
            radius: 2
            txtSize: 16
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#aca6a6"
                }

                GradientStop {
                    position: 0.531
                    color: "#e4d6d6"
                }

                GradientStop {
                    position: 1 //1.033
                    color: "#aca6a6"
                }
            }
            txtColor: "#000000"
            value: "ОМ"
            border.width: 0
            border.color: "#e4d6d6"
        }

        TInd {
            id: in2OM2
            x: 69
            y: 250
            width: 30
            height: 30
            radius: 2
            txtSize: 16
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#aca6a6"
                }

                GradientStop {
                    position: 0.531
                    color: "#e4d6d6"
                }

                GradientStop {
                    position: 1 //1.033
                    color: "#aca6a6"
                }
            }
            txtColor: "#000000"
            value: "ОМ"
            border.width: 0
            border.color: "#e4d6d6"
        }

        Image {
            id: in2BX
            x: 69
            y: 283
            width: 30
            height: 30
            source: "../Pictogram/ind_box.png"
        }

        TInd {
            id: in2DR
            x: 69
            y: 316
            width: 30
            height: 30
            radius: 2
            txtSize: 15
            txtColor: "red"
            value: "ДРУ"
            border.width: 2
            border.color: "red"
            gradient: Gradient{
                GradientStop {position:0.0; color: "silver"}
                GradientStop {position:0.3; color: "black"}
                GradientStop {position:0.7; color: "black"}
                GradientStop {position:1; color: "silver"}
            }
        }

        TInd {
            id: in2RZ
            x: 69
            y: 349
            width: 30
            height: 30
            radius: 2
            txtSize: 18
            txtColor: "#ffff00"
            value: "РЗ"
            border.width: 2
            border.color: "#ffff00"
            gradient: Gradient{
                GradientStop {position:0.0; color: "silver"}
                GradientStop {position:0.3; color: "black"}
                GradientStop {position:0.7; color: "black"}
                GradientStop {position:1; color: "silver"}
            }

        }

        TInd {
            id: in2OT
            x: 69
            y: 382
            width: 30
            height: 30
            radius: 2
            txtSize: 15
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#ffff00"
                }

                GradientStop {
                    position: 0.498
                    color: "#ffffff"
                }

                GradientStop {
                    position: 1
                    color: "#ffff00"
                }
            }
            txtColor: "#000000"
            value: "ОТМ"
            border.width: 0
            border.color: "#ffff00"
        }
    }
    Kdr_smlMain {
        id: kdr_Main_small
        x: 128
        y: 219
        z: 99
    }

    Kdr_Ted {
        id: kdr_TED
        x: 128
        y: 219
        z: 1
    }

    Kdr_Tre {
        id: kdr_Tre
        x: 0
        y: 416
        width: 640
        height: 64
        z: 99
    }

    Kdr_Privet {
        id: kdr_Privet
        x: 0
        y: 0
        width: 640
        height: 480
        anchors.verticalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        z: 100
        opacity: 1
    }

    Kdr_Bos {
        id: kdr_Bos
        x: 128
        y: 219
        z: 9
    }

    Kdr_Vzb {
        id: kdr_Vzb
        x: 128
        y: 219
    }

    Kdr_Mot {
        id: kdr_Mot
        x: 128
        y: 219
        z: 2
    }

    Kdr_Tpl {
        id: kdr_Toplivo
        x: 128
        y: 219
        width: 512
        height: 197
        z: 39
    }

    Kdr_Svz {
        id: kdr_Svz
        x: 128
        y: 219
        z: 5
    }

    Kdr_Masl {
        id: kdr_Masl
        x: 128
        y: 219
        width: 512
        height: 197
        border.width: 0
        z: 10
    }

    Kdr_Ohl {
        id: kdr_Ohl
        x: 128
        y: 219
        width: 512
        height: 197
        z: 11
    }

    Kdr_Trl {
        id: kdr_TrLs
        x: 128
        y: 219
        width: 512
        height: 197
        z: 12
        first: 0
    }

    Kdr_Reo {
        id: kdr_Reostat
        x: 128
        y: 219
        z: 14
    }

    Kdr_Dizl {
        id: kdr_Dizl
        x: 128
        y: 219
        z: 15
    }

    Kdr_AvProgrev {
        id: kdr_AvProgrev
        x: 128
        y: 219
        width: 512
        height: 197
        z: 17
    }

    Kdr_Nstr {
        id: kdr_Nastroika
        x: 128
        y: 219
        opacity: 1
        z: -3

    }

    Kdr_Analog {
            id: kdr_TI_TXA
            x: 128
            y: 219
            //width: 512
            height: 197
            cntPage: 3
            offset: 80
            bazaoffset: 80
            z: 77 //24
            namePage: qsTr("параметры ТИ");
            opacity: 0
        }

    Kdr_Analog {
            id: kdr_TI_TCM
            x: 128
            y: 219
            //width: 512
            height: 197
            cntPage: 3
            offset: 50
            bazaoffset: 50
            z: 25
            namePage: qsTr("параметры ТИ");
            opacity: 0
        }

    Kdr_Dskrt {
            id: kdr_USTA_DskrVihodi
            x: 128
            y: 219
            //width: 512
            //height: 210//197
            cntRowTabl: 12
            z: 77// 26
            namePage: qsTr("УСТА: дискретные выходы");
            offset: 48
            bazaoffset: 48
            opacity: 0
        }

    Kdr_Dskrt {
            id: kdr_USTA_DskrVh
            x: 128
            y: 219
            //width: 512
            //height: 197
            cntRowTabl: 12
            z: 77// 27
            namePage: qsTr("УСТА: дискретные входы");
            offset: 72
            bazaoffset: 72
            opacity: 0
        }

    Kdr_Analog {
            id: kdr_USTA_Analog
            x: 128
            y: 219
           // width: 512
            height: 197
            numPage: 1
            cntPage: 4
            offset: 0
            bazaoffset: 0
            z: 77 //29
            opacity: 0
        }

    Kdr_Dskrt {
            id: kdr_BEL_DskrVihodi
            x: 128
            y: 219
            //width: 512
            //height: 197
            cntRowTabl: 12
            offset: 0
            bazaoffset: 0
            namePage: qsTr("БЭЛ: дискретные выходы");
            z: 77// 30
            opacity: 0
        }

    Kdr_Dskrt {
            id: kdr_BEL_DskrVh
            x: 128
            y: 219
            //width: 512
            //height: 197
            cntRowTabl: 12
            namePage: qsTr("БЭЛ: дискретные входы");
            offset: 24
            bazaoffset: 24
            z: 77// 31
            opacity: 0
        }

    Kdr_Analog {
            id: kdr_BEL_Analog
            x: 128
            y: 219
           // width: 512
            height: 197
            opacity: 0
            visible: true
            cntPage: 1
            offset: 40
            bazaoffset: 40
            namePage: qsTr("параметры БЭЛ");
            z: 77 //32
    }


      //****************************************************************************
      //***  организация меню  *****************************************************
        Kdr_Foot {// главное меню
            id: kdr_Foot
            x: 0
            y: 416
            width: 640
            height: 64
            z: 0
            cltxtSelect: "#1bb7e4"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            focus: true

            onSwitchFootDizel:  { // переход на дизельное меню
                kdr_FootDizel.opacity = 1;
                kdr_FootDizel.focus = true;
//                setSystem(1);
            }

            onSwitchFootElektr:  { // переход на электрическое меню
                       kdr_FootElektrooborud.opacity = 1;
                       kdr_FootElektrooborud.focus = true;
//                setSystem(2);
                      }

            onKnopaS: { showKdr_Nastroiki();
                     //   if (kdr_Main.color == "steelblue" ) { kdr_Main.color = "red";} // условие не читается
                     //    else kdr_Main.color = "black";
                                               } // сигнал о нажатии клавиши ДМ "S"  /alt+b
            onKnopai: { showKdr_ArhivMessage();} // сигнал о нажатии клавиши ДМ "i"  /alt+c
            onKnopaSt:{ showKdr_Reostat();     } // сигнал о нажатии клавиши ДМ "St" /alt+d
            onKnopaUD: { // сигнал о нажатии клавиши ДМ "UD" /alt+i
                showKdr_Svazi();
//                setSystem(3);
            }
            onSaveToUSB: { ioBf.querySaveToUSB(); }  // сигнал о необходимости записи на USB (для отработки под Windows)

            onSwitchFoot_Exit: {  // в начальное состояние
                go_Exit();
//                setSystem(0);
            }
        }


        Kdr_FtDzl {//дизельное меню
            id: kdr_FootDizel
            x: 0
            y: 416
            width: 640
            height: 64
            opacity: 0
            z: 33
            focus: false

            onSwitchDzl_Cilindr: {
                opastyNul();
                kdr_Dizl.opacity = 1;
//                setSubsystem(6);
            } // цилиндры
            onSwitchDzl_Maslo:   {
                opastyNul();
                kdr_Masl.opacity = 1;
//                setSubsystem(7);
            }
            onSwitchDzl_Toplivo: {
                opastyNul();
                kdr_Toplivo.opacity = 1;
//                setSubsystem(8);
            }
            onSwitchDzl_Holod:   {
                opastyNul();
                kdr_Ohl.opacity = 1;
//                setSubsystem(9);
            }
            onSwitchDzl_Exit:    {
                go_Exit();
//                setSubsystem(0);
            }// возврат на главный экран
            onKnopaS: { showKdr_Nastroiki();   } // сигнал о нажатии клавиши ДМ "S"  /alt+b
            onKnopai: { showKdr_ArhivMessage();} // сигнал о нажатии клавиши ДМ "i"  /alt+c
            onKnopaSt:{ showKdr_Reostat();     } // сигнал о нажатии клавиши ДМ "St" /alt+d
            onKnopaUD:{ showKdr_Svazi();       } // сигнал о нажатии клавиши ДМ "UD" /alt+i
        }

        Kdr_FtElektr {//меню электрооборудование
            id: kdr_FootElektrooborud
            x: 0
            y: 416
            width: 640
            height: 64
            opacity: 0;
            z: 34
            focus: false

            onSwitchEl_Bortovay:    {
                opastyNul();
                kdr_Bos.opacity = 1;
//                setSubsystem(6);
            }    // бортовая сеть
            onSwitchEl_Vozbugdenie: {
                opastyNul();
                kdr_Vzb.opacity = 1;
//                setSubsystem(7);
            }    // система возбуждения
            onSwitchEl_Tagovie:     {
                opastyNul();
                kdr_TED.opacity = 1;
//                setSubsystem(8);
            }    // тяговые двигатели
            onSwitchEl_Motores:     {
                opastyNul();
                kdr_Mot.opacity = 1;
//                setSubsystem(9);
            }    // моторесурс
            onSwitchEl_Exit: {
                go_Exit();
//                setSubsystem(0);
            }
            onKnopaS: { showKdr_Nastroiki();   } // сигнал о нажатии клавиши ДМ "S"  /alt+b
            onKnopai: { showKdr_ArhivMessage();} // сигнал о нажатии клавиши ДМ "i"  /alt+c
            onKnopaSt:{ showKdr_Reostat();     } // сигнал о нажатии клавиши ДМ "St" /alt+d
            onKnopaUD:{ showKdr_Svazi();       } // сигнал о нажатии клавиши ДМ "UD" /alt+i

        }

        Kdr_FtUso { // верхнее меню УСО - появляется с экраном "СВЯЗИ" вызывается с любого экрана по "UD"
            id: kdr_FootUso
            x: 0
            y: 416
            width: 640
            height: 64
            opacity: 0
            z: 36
            onSwitchUso_TI: {  // переход на меню Температурного измерителя
                opastyNul(); kdr_FootUso.opacity=0;  kdr_Main_small.opacity=1;
                kdr_Foot_TI.opacity=1; kdr_Foot_TI.focus=true;}

            onSwitchUso_USTA: { // переход на меню УСТА
                opastyNul(); kdr_FootUso.opacity=0; kdr_Main_small.opacity=1;
                kdr_Foot_Usta.opacity=1; kdr_Foot_Usta.focus=true;   }

            onSwitchUso_BEL: { // переход на меню БЭЛ
                opastyNul(); kdr_FootUso.opacity=0; kdr_Main_small.opacity=1;
                kdr_FootBEL.opacity=1; kdr_FootBEL.focus=true;   }


            onSwitchUso_Exit: {   go_Exit();   }
            onKnopaS: { showKdr_Nastroiki();   } // сигнал о нажатии клавиши ДМ "S"  /alt+b
            onKnopai: { showKdr_ArhivMessage();} // сигнал о нажатии клавиши ДМ "i"  /alt+c
            onKnopaSt:{ showKdr_Reostat();     } // сигнал о нажатии клавиши ДМ "St" /alt+d
            onKnopaUD:{ showKdr_Svazi();       } // сигнал о нажатии клавиши ДМ "UD" /alt+i

        }

        Kdr_FtTI {
            id: kdr_Foot_TI // меню просмотра УСО ТИ
            x: 0
            y: 416
            width: 640
            height: 64
            opacity: 0
            z: 37
            onSwitchUso_TI_TXA: function(offset) {
                if (offset) {
                    if (kdr_TI_TXA.offset == 100) {
                        kdr_TI_TXA.offset = 80;
                        kdr_TI_TXA.numPage = 1;
                    }
                    else {
                        kdr_TI_TXA.offset += 10;
                        kdr_TI_TXA.numPage++;
                    }
                }
                opastyNul();
                kdr_TI_TXA.opacity = 1;
            }
            onSwitchUso_TI_TCM: function(offset) {
                if (offset) {
                    if (kdr_TI_TCM.offset == 70) {
                        kdr_TI_TCM.offset = 50;
                        kdr_TI_TCM.numPage = 1;
                    }
                    else {
                        kdr_TI_TCM.offset += 10;
                        kdr_TI_TCM.numPage++;
                    }
                }
                opastyNul();
                kdr_TI_TCM.opacity = 1;
            }

            onSwitchUso_Exit:  { go_Exit();    }
            onKnopaS: { showKdr_Nastroiki();   } // сигнал о нажатии клавиши ДМ "S"  /alt+b
            onKnopai: { showKdr_ArhivMessage();} // сигнал о нажатии клавиши ДМ "i"  /alt+c
            onKnopaSt:{ showKdr_Reostat();     } // сигнал о нажатии клавиши ДМ "St" /alt+d
            onKnopaUD:{ showKdr_Svazi();       } // сигнал о нажатии клавиши ДМ "UD" /alt+i


        }

        Kdr_FtUsta {// меню просмотра УСО УСТА
            id: kdr_Foot_Usta
            x: 0
            y: 416
            width: 640
            height: 64
            opacity: 0
            z: 37 //!!!

            onSwitchUso_USTA_DisVih:  { opastyNul(); kdr_USTA_DskrVihodi.opacity = 1; }
            onSwitchUso_USTA_DisVhod: { opastyNul(); kdr_USTA_DskrVh.opacity = 1;     }
            onSwitchUso_USTA_Analogi: function(/*offset*/) {
                if (kdr_USTA_Analog.opacity) {
                    if (kdr_USTA_Analog.offset == 30) {
                        kdr_USTA_Analog.offset = 0;
                        kdr_USTA_Analog.numPage = 1;
                    }
                    else {
                        kdr_USTA_Analog.offset += 10;
                        kdr_USTA_Analog.numPage++;
                    }
                } else
                    kdr_USTA_Analog.offset = 0;
                opastyNul();
                kdr_USTA_Analog.opacity = 1;
            }

//            onKnopaDwn: { kdr_USTA_Analog.numPage = kdr_USTA_Analog.numPage + 1;  }
//            onKnopaUp:  { kdr_USTA_Analog.numPage = kdr_USTA_Analog.numPage - 1;  }


            onSwitchUso_Exit: { go_Exit(); }
            onKnopaS: { showKdr_Nastroiki();   } // сигнал о нажатии клавиши ДМ "S"  /alt+b
            onKnopai: { showKdr_ArhivMessage();} // сигнал о нажатии клавиши ДМ "i"  /alt+c
            onKnopaSt:{ showKdr_Reostat();     } // сигнал о нажатии клавиши ДМ "St" /alt+d
            onKnopaUD:{ showKdr_Svazi();       } // сигнал о нажатии клавиши ДМ "UD" /alt+i

        }

        Kdr_FtBEL { // меню просмотра УСО БЭЛ
            id: kdr_FootBEL
            x: 0
            y: 416
            width: 640
            height: 64
            opacity: 0
            z: 38

            onSwitchUso_BEL_DisVih:  { opastyNul(); kdr_BEL_DskrVihodi.opacity = 1; }
            onSwitchUso_BEL_DisVhod: { opastyNul(); kdr_BEL_DskrVh.opacity = 1; }
            onSwitchUso_BEL_Analogi: { opastyNul(); kdr_BEL_Analog.opacity = 1; }

            onSwitchUso_Exit: { go_Exit(); }
            onKnopaS: { showKdr_Nastroiki();   } // сигнал о нажатии клавиши ДМ "S"  /alt+b
            onKnopai: { showKdr_ArhivMessage();} // сигнал о нажатии клавиши ДМ "i"  /alt+c
            onKnopaSt:{ showKdr_Reostat();     } // сигнал о нажатии клавиши ДМ "St" /alt+d
            onKnopaUD:{ showKdr_Svazi();       } // сигнал о нажатии клавиши ДМ "UD" /alt+i

        }

    function  showKdr_Nastroiki()    // сигнал о нажатии клавиши ДМ "S"  /alt+b
    {
    opastyNul(); kdr_Nastroika.opacity = 1;
    }

    function  showKdr_ArhivMessage() // сигнал о нажатии клавиши ДМ "i"  /alt+c
    {
//        opastyNul();
        kdr_FootDizel.opacity=0;
        kdr_FootElektrooborud.opacity=0;
        kdr_FootUso.opacity = 0;
        kdr_Foot_Usta.opacity=0;
        kdr_FootBEL.opacity=0;
        kdr_Foot_TI.opacity=0;

        // главный экран показываем
        //kdr_Foot.is_exit = true;

        //            txt_1.color = txt_2.color = cltxt;
//        kdr_TrLs.opacity = 1;
    }

    function showKdr_Reostat()      // сигнал о нажатии клавиши ДМ "St"/alt+d
    {
        opastyNul(); kdr_Reostat.opacity = 1;

    }

    function showKdr_Svazi()        // сигнал о нажатии клавиши ДМ "UD"/alt+i
    {
        opastyNul();

        kdr_FootDizel.opacity=0;
        kdr_FootElektrooborud.opacity=0;
        kdr_Foot_TI.opacity=0;

        kdr_Svz.opacity = 1;
        kdr_FootUso.opacity = 1;
        kdr_FootUso.focus = true;


    }

    function  go_Exit()    // выход из меню
    {
        kdr_TrLs.first = -1; // ????????????????????????????????????????
        opastyNul(); // все экраны в невидимое состояние
        // все менюшки в начальное невидимое состояние
        kdr_FootDizel.opacity=0;
        kdr_FootElektrooborud.opacity=0;
        kdr_FootUso.opacity = 0;
        kdr_Foot_Usta.opacity=0;
        kdr_FootBEL.opacity=0;
        kdr_Foot_TI.opacity=0;

        // главный экран показываем
        //kdr_Foot.is_exit = true;
        kdr_Foot.doExit();
        kdr_Foot.opacity = 1;
        kdr_Foot.focus = true;

        kdr_Main_small.opacity = 1; // главный маленький

    }

        function opastyNul()  { // гасим-гасим все экраны

            kdr_Vzb.opacity = 0;
            kdr_Mot.opacity = 0;
            kdr_AvProgrev.opacity = 0;
            kdr_Bos.opacity = 0;
            kdr_TED.opacity = 0;
            kdr_Svz.opacity = 0;
            kdr_Toplivo.opacity = 0;
            kdr_Masl.opacity = 0;
            kdr_Ohl.opacity = 0;
            kdr_TrLs.opacity = 0;
            kdr_Dizl.opacity = 0;

            kdr_Reostat.opacity = 0;
            kdr_Nastroika.opacity = 0;

            kdr_TI_TXA.opacity = 0;
            kdr_TI_TCM.opacity = 0;
            kdr_USTA_DskrVihodi.opacity = 0;
            kdr_USTA_DskrVh.opacity = 0;
            kdr_USTA_Analog.opacity = 0;

            kdr_BEL_DskrVihodi.opacity = 0;
            kdr_BEL_DskrVh.opacity = 0;
            kdr_BEL_Analog.opacity = 0;

            kdr_Main_small.opacity = 0;

    }


        function focusikNul()  {
//     закомменированные пока не нужны - на них фокус не переводили
//                kdr_Vzb.focus = false;
//                kdr_Mot.focus = false;
//                kdr_AvProgrev.focus = false;
//                kdr_Bos.focus = false;
//                kdr_TED.focus = false;
//                kdr_Svz.focus = false;
//                kdr_Tpl.focus = false;
//                kdr_Masl.focus = false;
//                kdr_Ohl.focus = false;
//                kdr_TrLs.focus = false;
//                kdr_Dizl.focus = false;
//                kdr_Reostat.focus = false;
//                kdr_Nastroika.focus = false;

            kdr_TI_TXA.focus = false; //*
            kdr_TI_TCM.focus = false; //*

//                kdr_USTA_DskrVihodi.focus = false;
//                kdr_USTA_DskrVh.focus = false;
            kdr_USTA_Analog.focus = false; //*

//                kdr_BEL_DskrVihodi.focus = false;
//                kdr_BEL_DskrVh.focus = false;
            kdr_BEL_Analog.focus = false; //*

            kdr_Main.focus = true;

    }
//        function setSection(section) {
//            //current_section = section;
//            if (ioBf.changeKdr(section * 100 + current_system * 10 + current_subsystem))
//                current_section = section;
//        }

//        function setSystem(system) {
//            current_system = system;
//            ioBf.changeKdr(current_section * 100 + current_system * 10 + current_subsystem)
//        }

//        function setSubsystem(subsystem) {
//            current_subsystem = subsystem;
//            ioBf.changeKdr(current_section * 100 + current_system * 10 + current_subsystem)
//        }
}
