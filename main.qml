import QtQuick 2.7
import QtQuick.Window 2.2
import "qml"

Window {
    width: 640
    height: 480
    visible: true
    color: "black"
//    flags: Qt.FramelessWindowHint | Qt.Window
    title: qsTr("TEM18DM Bi05-04 640x480")

//    rotation: 0
//    scale: 1
//    z: 100
//    focus: true
    property int cnt: 0;


    Timer {
        triggeredOnStart: true

        interval: 1000
        repeat: true
        running:  true
        Component.onCompleted: {
            go_Exit(); // KVA Fix screen blink
        }
        onTriggered: {
            cnt ++;
            var par = ioBf.getParamMain();
            txt_time.text = par[0][0]; //ioBf.tm();
            txt_data.text = par[0][1]; //ioBf.dt();

            if (indPt.value + 0.1 > indPt.maximumValue) {
                indPt.value = 0;
            }
            else
                indPt.value  = indPt.value + 0.1;

            if (indPm.value + 0.1 > indPm.maximumValue) {
                indPm.value = 0;
            }
            else
                indPm.value  = indPm.value + 0.1;

            if (indFd.value + 50 > indFd.maximumValue) {
                indFd.value = 0;
            } else
                indFd.value  =  indFd.value + 50;

            revers.value = par[1][0]; //ioBf.getReversor();// реверсор
            pkm.pkms = par[1][1]; //ioBf.getPKM();         // позиция
            regim.value = par[1][2]; //ioBf.getRegim();    // режим работы тепловоза

            txt_RejPro.text = par[2][0]; //ioBf.getRejPro(); // прожиг
            txt_RejAP.text = par[2][1]; //ioBf.getRejAP(); // автопрогрев

            txt_RejPrTime.text = par[3][0]; //ioBf.getRejPrT("value");// --- косяк с разными значениями --че делать то?
            if (/*ioBf.getRejPrT("tm")*/ par[3][1] == "2") { txt_RejPrTime.color = "yellow" ;} else  txt_RejPrTime.color = "gray";
            if (/*ioBf.getRejPrT("ms")*/ par[3][2] == "1") { txt_RejPrT.opacity = 1;} else {txt_RejPrT.opacity = 0;}

            // индикация регистрации
            //img_z0.visible = ! img_z0.visible;
            //img_ind_f.visible = ! img_ind_f.visible;

            prBar1.value = par[4][0]; //ioBf.getParamDiap(100);// заглушка

            pr_Mtg1.value = par[4][1]; //ioBf.getParamDiap(1500);// заглушка
            pr_Mtg2.value = 1500;// ioBf.getParamDiap(1500); // заглушка

                img_in2BX.opacity = ! img_in2BX.opacity;// заглушка
if (cnt==2 ) {  in1DR.opacity = ! in1DR.opacity}; // ДРУ уровень воды
if (cnt==1 ) {  in1OM.opacity = ! in1OM.opacity}; // отключатель моторов
if (cnt==3 ) {  in1RZ.opacity = ! in1RZ.opacity}; // реле земли
if (cnt==4 ) {  in1OT.opacity = ! in1OT.opacity}; // обрыв тормозной магистрали

            indUb0.text = par[4][2]; //ioBf.getParamDiap(100);// заглушка
            indUb1.text = par[4][3]; //ioBf.getParamDiap(100);// заглушка

            indIz0.text = par[4][4]; //ioBf.getParamDiap(60);// заглушка
            indIz1.text = par[4][5]; //ioBf.getParamDiap(60);// заглушка

if  (cnt>6 ) { cnt = 0};
       }
}

// расставляем компоненты

    TRevers {
        id: revers
        x: 24
        y: 46
    }

    TPKM {
        id: pkm
        x: 24
        y: 15
        width: 64
        color: "#000000"
        pkms: 5
    }
    TRegm {
        id: regim
        x: 16
        y: 88
        height: 25
        value: 1
    }

    Text {
        id: text2
        x: 285
        y: 6
        color: "#d2e8fb"
        text: qsTr("ТЭМ18ДМ  №___")
        font.bold: true
        font.pointSize: 13
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
        y: 415
        width: 640
        height: 64
        z: -1
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

    Text {
        id: txt_time
        x: 566
        y: 8
        color: "#d2e8fb"
        text: qsTr("время")
        horizontalAlignment: Text.AlignRight
        font.pointSize: 13
        font.bold: true
    }

    Text {
        id: txt_data
        x:  566
        y: 25
        color: "#d2e8fb"
        text: qsTr("дата")
        font.pointSize: 13
        font.bold: true
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
        y: 23
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
        }

    Kdr_Analog {
            id: kdr_BEL_Analog
            x: 128
            y: 219
           // width: 512
            height: 197
            opacity: 1
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
            cltxtSelect: "blue"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            focus: true

            onSwitchFootDizel:  { // переход на дизельное меню
                       kdr_FootDizel.opacity = 1;
                       kdr_FootDizel.focus = true;
                      }

            onSwitchFootElektr:  { // переход на электрическое меню
                       kdr_FootElektrooborud.opacity = 1;
                       kdr_FootElektrooborud.focus = true;
                      }

            onKnopaS: { showKdr_Nastroiki();
                     //   if (kdr_Main.color == "steelblue" ) { kdr_Main.color = "red";} // условие не читается
                     //    else kdr_Main.color = "black";
                                               } // сигнал о нажатии клавиши ДМ "S"  /alt+b
            onKnopai: { showKdr_ArhivMessage();} // сигнал о нажатии клавиши ДМ "i"  /alt+c
            onKnopaSt:{ showKdr_Reostat();     } // сигнал о нажатии клавиши ДМ "St" /alt+d
            onKnopaUD:{ showKdr_Svazi();       } // сигнал о нажатии клавиши ДМ "UD" /alt+i

            onSwitchFoot_Exit: { go_Exit(); } // в начальное состояние
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

            onSwitchDzl_Cilindr: {opastyNul(); kdr_Dizl.opacity = 1;} // цилиндры
            onSwitchDzl_Maslo:   {opastyNul(); kdr_Masl.opacity = 1;}
            onSwitchDzl_Toplivo: {opastyNul(); kdr_Toplivo.opacity = 1;}
            onSwitchDzl_Holod:   {opastyNul(); kdr_Ohl.opacity = 1;}
            onSwitchDzl_Exit:    { go_Exit();  }// возврат на главный экран
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

            onSwitchEl_Bortovay:    {opastyNul(); kdr_Bos.opacity = 1;}    // бортовая сеть
            onSwitchEl_Vozbugdenie: {opastyNul(); kdr_Vzb.opacity = 1;}    // система возбуждения
            onSwitchEl_Tagovie:     {opastyNul(); kdr_TED.opacity = 1;}    // тяговые двигатели
            onSwitchEl_Motores:     {opastyNul(); kdr_Mot.opacity = 1;}    // моторесурс
            onSwitchEl_Exit: { go_Exit();      }
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
            onSwitchUso_TI_TXA: { opastyNul(); kdr_TI_TXA.opacity = 1; }
            onSwitchUso_TI_TCM: { opastyNul(); kdr_TI_TCM.opacity = 1; }

            onKnopaDwn: { //  нужно только один экран листать
                if (kdr_TI_TXA.opacity == 1) {
                kdr_TI_TXA.numPage = kdr_TI_TXA.numPage + 1;}

                if (kdr_TI_TCM.opacity == 1) {
                kdr_TI_TCM.numPage = kdr_TI_TCM.numPage + 1;}
            }
            onKnopaUp: {
                if (kdr_TI_TXA.opacity == 1) {
                kdr_TI_TXA.numPage = kdr_TI_TXA.numPage - 1;}

                if (kdr_TI_TCM.opacity == 1) {
                kdr_TI_TCM.numPage = kdr_TI_TCM.numPage - 1;}
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
            onSwitchUso_USTA_Analogi: { opastyNul(); kdr_USTA_Analog.opacity = 1;     }

            onKnopaDwn: { kdr_USTA_Analog.numPage = kdr_USTA_Analog.numPage + 1;  }
            onKnopaUp:  { kdr_USTA_Analog.numPage = kdr_USTA_Analog.numPage - 1;  }


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

        Text {
            id: txt_RejPrT
            x: 142
            y: 27
            color: "#f0f026"
            text: qsTr("Длительный х.ход! Установи 8ПКМ на 10 минут")
            font.pointSize: 10
            font.bold: true
        }

        Text {
            id: txt_RejAP
            x: 142
            y: 43
            color: "#f0f026"
            text: qsTr("Режим автопрогрева")
            font.pointSize: 10
            font.bold: true
        }

        Text {
            id: txt_RejPro
            x: 142
            y: 59
            color: "#f0f026"
            text: qsTr("Прожиг коллектора")
            font.pointSize: 10
            font.bold: true
        }

        Text {
            id: txt_RejPrTime
            x: 16
            y: 118
            width: 80
            color: "#6e6e63"
            text: qsTr("00:00:00")
            clip: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            font.pointSize: 12
            visible: true
        }

        Image {
            id: img_ind_f
            x: 16
            y: 138
            width: 22
            height: 40
            clip: false
            source: "Pictogram/flesh1.png"
            visible: true
        }

        Image {
            id: img_z0
            x: 39
            y: 147
            width: 35
            height: 19
            clip: true
            source: "Pictogram/flesh zapis1.png"
            visible: true

        }

        PrBar {
            id: prBar1
            x: 75
            y: 148
            width: 61
            height: 14
            clip: true
            kind: 1
            val_max: 100
            value: 0
            visible: true
        }

        Text {
            id: indUb0
            x: 42
            y: 185
            width: 23
            height: 17
            color: "#d2e8fb"
            text: qsTr("0")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: indUb1
            x: 73
            y: 185
            width: 23
            height: 17
            color: "#d2e8fb"
            text: qsTr("0")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }

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
            id: txtUb1
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
            x: 42
            y: 204
            width: 23
            height: 17
            color: "#d2e8fb"
            text: qsTr("0")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: indIz1
            x: 73
            y: 204
            width: 23
            height: 17
            color: "#d2e8fb"
            text: qsTr("0")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.bold: true
        }

        Image {
            id: img_in1BX
            x: 3
            y: 225
            width: 28
            height: 28
            source: "Pictogram/ind_box.png"
        }

        Image {
            id: img_in2BX
            x: 67
            y: 225
            width: 28
            height: 28
            source: "Pictogram/ind_box.png"
        }

     PrBar{ //   PrBar {
            id: pr_Mtg1
            x: 34
            y: 242
            width: 27
            height: 170
            color: "#000000"
            radius: 0
            val_max: 1500
            opacity: 1
            color1: "#4682b4" // #f32b2b"
            color2: "#b0e0e6"
            kind: 0
            value: 1500
            txtvzbl: true
        }

      PrBar{ //   PrBar {
            id: pr_Mtg2
            x: 98
            y: 242
            width: 27
            height: 170
            color: "#000000"
            radius: 0
            val_max: 1500
            value: 1500
            color2: "#b0e0e6"
            color1: "#4682b4"
            kind: 0
            txtvzbl: true
      }

      TInd {
          id: in1DR
          x: 1
          y: 297
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
            id: in2DR
            x: 65
            y: 297
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
            id: in1RZ
            x: 1
            y: 338
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
            id: in2RZ
            x: 65
            y: 338
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
            id: in1OT
            x: 1
            y: 379
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
            id: in1OM
            x: 1
            y: 258
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
            id: in2OM
            x: 65
            y: 258
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
            id: in2OT
            x: 65
            y: 379
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

    Kdr_smlMain {
        id: kdr_Main_small
        x: 128
        y: 219
        z: 99
    }

    function  showKdr_Nastroiki()    // сигнал о нажатии клавиши ДМ "S"  /alt+b
    {
    opastyNul(); kdr_Nastroika.opacity = 1;
    }

    function  showKdr_ArhivMessage() // сигнал о нажатии клавиши ДМ "i"  /alt+c
    {
    opastyNul(); kdr_TrLs.opacity = 1;
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
        opastyNul(); // все экраны в невидимое состояние
        // все менюшки в начальное невидимое состояние
        kdr_FootDizel.opacity=0;
        kdr_FootElektrooborud.opacity=0;
        kdr_FootUso.opacity = 0;
        kdr_Foot_Usta.opacity=0;
        kdr_FootBEL.opacity=0;
        kdr_Foot_TI.opacity=0;
        // главный экран показываем

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
}
