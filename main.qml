import QtQuick 2.7
import QtQuick.Window 2.2
import QtMultimedia 5.7
import "qml"
import "qml/scripts.js" as Scripts

Window {
    id: main_window
    width: 640
    height: 480
    visible: true
    color: "black"

    property bool started: false
    property int moduleType: 1 // 1- Atronic BI0504, 2 - TPK
    property string lcm_number: "0001"
    property string passwordstr: ""
    property int sound_volume: 100
    property string deffntfam: "Sans Serif"

    property int current_section: 1; // 1 - own, 2 - extra
    property bool is_slave: false; // true - is exchange with slave locomotive
    property bool is_links: false; // true - is exchange with BEL or USTA or TI
    property int current_system: 0; // 0 - not 1 - diesel, 2 - electro, 3 - links

        flags: Qt.FramelessWindowHint | Qt.Window
    title: qsTr("TEM18DM Bi05-04 640x480")

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running:  true
        Component.onCompleted: {
            // KVA Fix screen blink
            Scripts.opacityNul(); // все экраны в невидимое состояние
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
            if (!started) {
//                var fonts = Qt.fontFamilies()
                var settings = ioBf.getSettings();
                moduleType = settings[0]
                lcm_number = qsTr("ТЭМ18ДМ  №" + settings[1])
                sound_volume = settings[2]
                started = true;
            }
            var par = ioBf.getParamMainWindow();
            // frame_Left
            is_slave = par[0][3]; // связь по МСС
            is_links = par[0][0] || par[0][1] || par[0][2]; // Связь БЭЛ, УСТА, ТИ

            var is_slave_usta = par[0][3] && par[0][4]; // есть связь МСС и на slave есть связь с УСТА

            pr_Mtg1.value = par[1].toFixed(0);
            pr_Mtg2.value = par[2].toFixed(0);

            indUb0.text = par[3].toFixed(0);
            indUb1.text = par[4].toFixed(0);

            indIz0.text = par[5].toFixed(0);
            indIz1.text = par[6].toFixed(0);

            in1OM2.visible = txt1OM2.visible = par[7][0] && par[0][1];
            in1OM1.visible = txt1OM1.visible = par[7][1] && par[0][1];
            in1BX.visible = par[7][2] && par[0][1];
            in1DR.visible = par[7][3] && par[0][1];
            in1RZ.visible = par[7][4] && par[0][1];
            in1OT.visible = par[7][5] && par[0][1];

            in2OM2.visible = txt2OM2.visible = par[8][0] && is_slave_usta;
            in2OM1.visible = txt2OM1.visible = par[8][1] && is_slave_usta;
            in2BX.visible = par[8][2] && is_slave_usta;
            in2DR.visible = par[8][3] && is_slave_usta;
            in2RZ.visible = par[8][4] && is_slave_usta;
            in2OT.visible = par[8][5] && is_slave_usta;

            indUb0.visible = indIz0.visible = pr_Mtg1.visible = par[0][1];
            indUb1.visible = indIz1.visible = pr_Mtg2.visible = is_slave_usta;
            txtUb.visible = txtV.visible = txtIz.visible = txtA.visible = par[0][1] || is_slave_usta;

            // frame_Top
            pkm.pkms = par[9][0];
            revers.value = par[9][1];
            regim.value = par[9][2]; // режим работы тепловоза

            txt_time.text = par[10][0];
            txt_data.text = par[10][1];

            txt_RejPrT.text = par[11][0];
            txt_RejPro.text = par[11][1]; // прожиг
            txt_RejAP.text = par[11][2]; // автопрогрев
            txt_RejPrTime.text = par[12][0]; //ioBf.getRejPrT("value");// --- косяк с разными значениями --че делать то?
            txt_RejPrTime.color = (par[12][1] == "2") ?  "yellow" : "gray";
            txt_RejPrT.opacity = (par[12][2] == "1") ? 1 : 0;

            // save to USB
            insertedUSB.visible = par[13][0];
            recordUSB.visible = recUSBprBar.visible = par[13][1];
            recUSBprBar.value = par[13][2];

            indPt.value = indPt.digitalvalue =  par[14][0];
            if (indPt.digitlvalue < 0)
                indPt.digitalvalue = 0;

            var start = par[14][1];
            var finish = par[14][2];

            if (indPt.start != start) {
                indPt.start = start;
                indPt.repaint = true;
            }
            if (indPt.finish != finish) {
                indPt.finish = finish;
                indPt.repaint = true;
            }
            indPm.value = indPm.digitalvalue = par[14][3];
            if (indPm.digitalvalue < 0)
                indPm.digitalvalue = 0;
            start = par[14][4];
            finish = par[14][5];

            if (indPm.start != start) {
                indPm.start = start;
                indPm.repaint = true;
            }
            if (indPm.finish != finish) {
                indPm.finish = finish;
                indPm.repaint = true;
            }
            indFd.value = indFd.digitalvalue = par[14][6];
            if (indFd.digitalvalue < 0)
                indFd.digitalvalue = 0;
            start = par[14][7];
            finish = par[14][8];

            if (indFd.start != start) {
                indFd.start = start;
                indFd.repaint = true;
            }
            if (indFd.finish != finish) {
                indFd.finish = finish;
                indFd.repaint = true;
            }

            indPt.visible = indPm.visible = indFd.visible = par[0][1];
            // Trevoga messages
            if (par[15][0] != "") {
//                if (!kdr_Tre.opacity)
                if (!kdr_Tre.opacity || kdr_Tre.str1 != par[15][0] || kdr_Tre.str2 != par[15][1])
                    errorSound.play(); //ioBf.playSoundOnShowBanner();
                kdr_Tre.opacity = 1;
                kdr_Tre.focus = true;
                kdr_Tre.str1 = par[15][0];
                kdr_Tre.str2 = par[15][1];
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
//                case 7:
//                    kdr_Foot.opacity = 1;
//                    kdr_Foot.focus = true;
//                    break;
                case 11:
                    kdr_Foot_TI.opacity = 1;
                    kdr_Foot_TI.focus = true;
                    break;
                case 12:
                    kdr_Foot_Usta.opacity = 1;
                    kdr_Foot_Usta.focus = true;
                    break;
                case 13:
                    kdr_FootBEL.opacity = 1;
                    kdr_FootBEL.focus = true;
                    break;
                }
            }
       }
}

    SoundEffect {
            id: errorSound
            source: "error.wav"
            volume: sound_volume / 100
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
            clip: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            font.pointSize: 12
            font.family: deffntfam
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
                text: (main_window.current_section == 1 ? lcm_number : qsTr("выбрана вторая секция"))
                font.bold: true
                font.pointSize: 12
                font.family: deffntfam
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
            font.family: deffntfam
        }

        Text {
            id: txt_RejPro
            x: 128
            y: 43
            color: "#f0f026"
            text: qsTr("Прожиг коллектора")
            font.pointSize: 10
            font.bold: true
            font.family: deffntfam
            style: Text.Outline
        }

        Text {
            id: txt_RejAP
            x: 128
            y: 59
            color: "#f0f026"
            text: qsTr("Режим автопрогрева")
            font.pointSize: 10
            font.bold: true
            font.family: deffntfam
        }

        Text {
            id: txt_time
            x: 528
            y: 8
            color: "#d2e8fb"
            text: qsTr("время")
            //horizontalAlignment: Text.AlignRight
            font.pointSize: 12
            font.bold: true
            font.family: deffntfam
        }

        Text {
            id: txt_data
            x:  528
            y: 25
            color: "#d2e8fb"
            text: qsTr("дата")
            font.pointSize: 12
            font.bold: true
            font.family: deffntfam
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
            labelTextSize: 11
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
            labelTextSize: 11
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
            labelTextSize: 12
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
            font.family: deffntfam
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
            font.family: deffntfam
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
            font.family: deffntfam
        }

        Text {
            id: indUb1
            x: 104
            y: 182
            width: 23
            height: 17
            color: "#d2e8fb"
            text: qsTr("0")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
            font.family: deffntfam
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
            font.family: deffntfam
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
            font.family: deffntfam
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
            font.family: deffntfam
        }

        Text {
            id: indIz1
            x: 104
            y: 198
            width: 23
            height: 17
            color: "#d2e8fb"
            text: qsTr("0")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
            font.family: deffntfam
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
            id: txt1OM2
            x: 5
            y: 217
            width: 30
            height: 16
            radius: 2
            gradient: Gradient {
                GradientStop {position: 0;color: "#aca6a6"}
                GradientStop {position: 1;color: "#aca6a6"}
            }
            txtSize: 16
            txtColor: "#000000"
            value: "2"
            border.width: 0
            border.color: "#e4d6d6"
        }

        TInd {
            id: in1OM2
            x: 5
            y: 231
            width: 30
            height: 16
            radius: 2
            gradient: Gradient {
                GradientStop {position: 0;color: "#aca6a6"}
                GradientStop {position: 1;color: "#aca6a6"}
            }
            txtSize: 16
            txtColor: "#000000"
            value: "ОМ"
            border.width: 0
            border.color: "#e4d6d6"
        }

        TInd {
            id: txt1OM1
            x: 5
            y: 250
            width: 30
            height: 16
            radius: 2
            gradient: Gradient {
                GradientStop {position: 0;color: "#aca6a6"}
                GradientStop {position: 1;color: "#aca6a6"}
            }
            txtSize: 16
            txtColor: "#000000"
            value: "1"
            border.width: 0
            border.color: "#e4d6d6"
        }

        TInd {
            id: in1OM1
            x: 5 //5
            y: 264 //217
            width: 30
            height: 16
            radius: 2
            gradient: Gradient {
                GradientStop {position: 0;color: "#aca6a6"}
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
            id: txt2OM2
            x: 69
            y: 217
            width: 30
            height: 16
            radius: 2
            gradient: Gradient {
                GradientStop {position: 0;color: "#aca6a6"}
                GradientStop {position: 1;color: "#aca6a6"}
            }
            txtSize: 16
            txtColor: "#000000"
            value: "2"
            border.width: 0
            border.color: "#e4d6d6"
        }

        TInd {
            id: in2OM2
            x: 69
            y: 231
            width: 30
            height: 16
            radius: 2
            txtSize: 16
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#aca6a6"
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
            id: txt2OM1
            x: 69
            y: 250
            width: 30
            height: 16
            radius: 2
            gradient: Gradient {
                GradientStop {position: 0;color: "#aca6a6"}
                GradientStop {position: 1;color: "#aca6a6"}
            }
            txtSize: 16
            txtColor: "#000000"
            value: "1"
            border.width: 0
            border.color: "#e4d6d6"
        }

        TInd {
            id: in2OM1
            x: 69
            y: 264
            width: 30
            height: 16
            radius: 2
            txtSize: 16
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#aca6a6"
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
        opacity: 0
    }

    Kdr_Tre {
        id: kdr_Tre
        x: 0
        y: 416
        width: 640
        height: 64
        z: 99
        opacity: 0
    }

    Kdr_Privet {
        id: kdr_Privet
        x: 418
        y: 0
        width: 221
        height: 150
        z: 100
        opacity: 1
    }

    Kdr_Bos {
        id: kdr_Bos
        x: 128
        y: 219
        z: 9
        opacity: 0
    }

    Kdr_Vzb {
        id: kdr_Vzb
        x: 128
        y: 219
        opacity: 0
    }

    Kdr_Mot {
        id: kdr_Mot
        x: 128
        y: 219
        z: 2
        opacity: 0
    }

    Kdr_Tpl {
        id: kdr_Toplivo
        x: 128
        y: 219
        width: 512
        height: 197
        z: 39
        opacity: 0
    }

    Kdr_Svz {
        id: kdr_Svz
        x: 128
        y: 219
        z: 255
        opacity: 0
    }

    Kdr_Masl {
        id: kdr_Masl
        x: 128
        y: 219
        width: 512
        height: 197
        border.width: 0
        z: 10
        opacity: 0
    }

    Kdr_Ohl {
        id: kdr_Ohl
        x: 128
        y: 219
        width: 512
        height: 197
        z: 11
        opacity: 0
    }

    Kdr_Trl {
        id: kdr_TrLs
        x: 128
        y: 219
        width: 512
        height: 197
        z: 300
        first: 0
        opacity: 0
    }

    Kdr_Reo {
        id: kdr_Reostat
        x: 128
        y: 219
        z: 14
        opacity: 0
    }

    Kdr_Dizl {
        id: kdr_Dizl
        x: 128
        y: 219
        z: 15
        opacity: 0
    }

    Kdr_AvProgrev {
        id: kdr_AvProgrev
        x: 128
        y: 219
        width: 512
        height: 197
        z: 17
        opacity: 0
    }

    Kdr_Nstr {
        id: kdr_Nastroika
        x: 128
        y: 219
        opacity: 0
        z: 300
    }

    Kdr_DateTime {
        id: kdr_DateTime
        x: 128
        y: 219
        opacity: 0
        z: 300
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

    Kdr_Develop {
        id: kdr_Develop
        x: 128
        y: 219
        z: 255
        opacity: 0
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
        }

        Kdr_FtUso { // верхнее меню УСО - появляется с экраном "СВЯЗИ" вызывается с любого экрана по "UD"
            id: kdr_FootUso
            x: 0
            y: 416
            width: 640
            height: 64
            opacity: 0
            z: 36
        }

        Kdr_FtTI {
            id: kdr_Foot_TI // меню просмотра УСО ТИ
            x: 0
            y: 416
            width: 640
            height: 64
            opacity: 0
            z: 37
        }

        Kdr_FtUsta {// меню просмотра УСО УСТА
            id: kdr_Foot_Usta
            x: 0
            y: 416
            width: 640
            height: 64
            opacity: 0
            z: 37 //!!!
        }

        Kdr_FtBEL { // меню просмотра УСО БЭЛ
            id: kdr_FootBEL
            x: 0
            y: 416
            width: 640
            height: 64
            opacity: 0
            z: 38
        }


    function  go_Exit(special)    // выход из меню
    {        
        if (!special) {
            kdr_TrLs.first = -1; // ????????????????????????????????????????
            Scripts.opacityNul(); // все экраны в невидимое состояние
        }
        // все менюшки в начальное невидимое состояние
        kdr_FootDizel.opacity=0;
        kdr_FootElektrooborud.opacity=0;
        kdr_Foot_Usta.opacity=0;
        kdr_FootBEL.opacity=0;
        kdr_Foot_TI.opacity=0;
//        kdr_FootNstr.opacity=0;

        // главный экран показываем
        //kdr_Foot.is_exit = true;
        if (!special) {
            kdr_FootUso.opacity = 0; // !!!
            kdr_Foot.doExit();
            kdr_Foot.opacity = 1;
            kdr_Foot.focus = true;
        }
        kdr_Main_small.opacity = 1; // главный маленький

    }

    function saveToUSB() {
        ioBf.querySaveToUSB()
    }

}
