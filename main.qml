import QtQuick 2.7
import QtQuick.Window 2.2
import "qml"

Window {
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
    property int current_system: 0; // 0 - not 1 - diesel, 2 - electro, 3 - links
    property int current_subsystem: 0; // 0 - not

//    signal setKdr(kdr: int);

    Timer {
        triggeredOnStart: true

        interval: 1000
        repeat: true
        running:  true
        Component.onCompleted: {
            go_Exit(); // KVA Fix screen blink
        }
        onTriggered: {

       }
}

// расставляем компоненты

    Frame_Top {
        id: frame_Top
        x: 0
        y: 0

    }

    Frame_Left {
        id: frame_Left
        x: 0
        y: 182

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
            cltxtSelect: "blue"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            focus: true

            onSwitchFootDizel:  { // переход на дизельное меню
                kdr_FootDizel.opacity = 1;
                kdr_FootDizel.focus = true;
                setSystem(1);
            }

            onSwitchFootElektr:  { // переход на электрическое меню
                       kdr_FootElektrooborud.opacity = 1;
                       kdr_FootElektrooborud.focus = true;
                setSystem(2);
                      }
            onSwitchSection: function(section) {
                setSection(section);
            }

            onKnopaS: { showKdr_Nastroiki();
                     //   if (kdr_Main.color == "steelblue" ) { kdr_Main.color = "red";} // условие не читается
                     //    else kdr_Main.color = "black";
                                               } // сигнал о нажатии клавиши ДМ "S"  /alt+b
            onKnopai: { showKdr_ArhivMessage();} // сигнал о нажатии клавиши ДМ "i"  /alt+c
            onKnopaSt:{ showKdr_Reostat();     } // сигнал о нажатии клавиши ДМ "St" /alt+d
            onKnopaUD: { // сигнал о нажатии клавиши ДМ "UD" /alt+i
                showKdr_Svazi();
                setSystem(3);
            }
            onSaveToUSB: { ioBf.querySaveToUSB("G:/"); }  // сигнал о необходимости записи на USB (для отработки под Windows)

            onSwitchFoot_Exit: {  // в начальное состояние
                go_Exit();
                setSystem(0);
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
                setSubsystem(6);
            } // цилиндры
            onSwitchDzl_Maslo:   {
                opastyNul();
                kdr_Masl.opacity = 1;
                setSubsystem(7);
            }
            onSwitchDzl_Toplivo: {
                opastyNul();
                kdr_Toplivo.opacity = 1;
                setSubsystem(8);
            }
            onSwitchDzl_Holod:   {
                opastyNul();
                kdr_Ohl.opacity = 1;
                setSubsystem(9);
            }
            onSwitchDzl_Exit:    {
                go_Exit();
                setSubsystem(0);
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
                setSubsystem(6);
            }    // бортовая сеть
            onSwitchEl_Vozbugdenie: {
                opastyNul();
                kdr_Vzb.opacity = 1;
                setSubsystem(7);
            }    // система возбуждения
            onSwitchEl_Tagovie:     {
                opastyNul();
                kdr_TED.opacity = 1;
                setSubsystem(8);
            }    // тяговые двигатели
            onSwitchEl_Motores:     {
                opastyNul();
                kdr_Mot.opacity = 1;
                setSubsystem(9);
            }    // моторесурс
            onSwitchEl_Exit: {
                go_Exit();
                setSubsystem(0);
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
            onSwitchUso_USTA_Analogi: function(offset) {
                if (offset) {
                    if (kdr_USTA_Analog.offset == 30) {
                        kdr_USTA_Analog.offset = 0;
                        kdr_USTA_Analog.numPage = 1;
                    }
                    else {
                        kdr_USTA_Analog.offset += 10;
                        kdr_USTA_Analog.numPage++;
                    }
                }
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
        function setSection(section) {
            current_section = section;
            ioBf.changeKdr(current_section * 100 + current_system * 10 + current_subsystem)
        }

        function setSystem(system) {
            current_system = system;
            ioBf.changeKdr(current_section * 100 + current_system * 10 + current_subsystem)
        }

        function setSubsystem(subsystem) {
            current_subsystem = subsystem;
            ioBf.changeKdr(current_section * 100 + current_system * 10 + current_subsystem)
        }
}
