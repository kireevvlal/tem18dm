import QtQuick 2.7
import "scripts.js" as Scripts
// переключение между экранами "Устройства связи с объектами" - верхнее меню
Rectangle {
    width: 640
    height: 64
    color: "#000000"
    border.width: 0

    property string cltxtSelect:"#1bb7e4"; // цвет текста нажатой кнопки
    property string cltxt:"white";         // штатный цвет текста всех кнопок

    Keys.onPressed: {
        var key = Scripts.getKey(event.key)

        switch(key) {

        case "0":
            btn1.border.color = btn2.border.color = "black"
            img8.source = "../Pictogram/uso/0_TXA.png"
            img9.source = "../Pictogram/uso/0_TSM.png"

            main_window.go_Exit()
            break;
        case "1":
            if (Scripts.setSection(1)) {
                btn1.border.color = "silver"
                btn2.border.color = "black"

                txt_1.color = cltxtSelect;
                txt_2.color = cltxt;
            }
            break;
        case "2":
            if (Scripts.setSection(2)) {
                btn1.border.color = "black"
                btn2.border.color = "silver"

                txt_2.color = cltxtSelect;
                txt_1.color = cltxt;
            }
            break;
        case "8":
            if (kdr_TI_TXA.opacity) {
                if (kdr_TI_TXA.offset == 100) {
                    kdr_TI_TXA.offset = 80;
                    kdr_TI_TXA.numPage = 1;
                }
                else {
                    kdr_TI_TXA.offset += 10;
                    kdr_TI_TXA.numPage++;
                }
            } else {
                img8.source =  "../Pictogram/uso/1_TXA.png"
                img9.source =  "../Pictogram/uso/0_TSM.png"
            }
            Scripts.opacityNul();
            kdr_TI_TXA.opacity = 1;
            break;
        case "9":
            if (kdr_TI_TCM.opacity == 1) {
                if (kdr_TI_TCM.offset == 70) {
                    kdr_TI_TCM.offset = 50;
                    kdr_TI_TCM.numPage = 1;
                }
                else {
                    kdr_TI_TCM.offset += 10;
                    kdr_TI_TCM.numPage++;
                }
            } else {
                img8.source = "../Pictogram/uso/0_TXA.png"
                img9.source = "../Pictogram/uso/1_TSM.png"
            }
            Scripts.opacityNul();
            kdr_TI_TCM.opacity = 1;
            break;
        // *** ! кодировка на ТПК может отличаться
//        case "S":  //66 :
//            knopaS(); // сигнал о нажатии клавиши ДМ "S"
//            break;
        case "I":  //67 :
            kdr_Foot.doTrMessList();
//            knopai(); // сигнал о нажатии клавиши ДМ "i"
            break;
        case "V>0":  //68 :
            Scripts.opacityNul();
            kdr_Reostat.opacity = 1;
            break;
        case "UD":  //73 :
            Scripts.opacityNul();
            kdr_Svz.opacity = 1;
            kdr_FootUso.opacity = 1;
            kdr_FootUso.focus = true;
            break;
        case "V=0":
            main_window.saveToUSB();
            break;
        case "C":
            kdr_Privet.opacity = 1;
            break;
        }
    }

    Text {
        id: txt_1
        x: 0
        y: 27
        width: 64
        height: 37
        color: (main_window.current_section == 1) ? cltxtSelect : cltxt
        text: qsTr("1")
        z: 3
        font.italic: false
        font.bold: true
        font.family: main_window.deffntfam
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 30
        visible: main_window.is_links
    }

    Text {
        id: txt_2
        x: 64
        y: 27
        width: 64
        height: 37
        color: (main_window.current_section == 2) ? cltxtSelect : cltxt
        text: qsTr("2")
        z: 8
        wrapMode: Text.NoWrap
        font.italic: false
        font.pixelSize: 30
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        font.family: main_window.deffntfam
        visible: main_window.is_slave
    }

    Image {
        id: img0
        x: 576
        y: 0
        width: 64
        height: 64
        opacity: 1
        z: 4
        source: "../Pictogram/0_out.png"
    }

    Rectangle {
        id: btn1
        x: 0
        y: 0
        width: 64
        height: 64
        border.width: 1
        border.color: (main_window.current_section == 1) ? "silver" : "black"
        Image {
            id: img1
            x: 1
            y: 1
            width: 62
            height: 62
            source: "../Pictogram/m_lok.png"
        }
        visible: main_window.is_links
    }

    Rectangle {
        id: btn2
        x: 64
        y: 0
        width: 64
        height: 64
        border.width: 1
        border.color: (main_window.current_section == 2) ? "silver" : "black"
        Image {
            id: img2
            x: 1
            y: 1
            width: 62
            height: 62
            source: "../Pictogram/m_lok.png"
        }
        visible: main_window.is_slave
    }

    Image {
        id: img9
        x: 512
        y: 0
        width: 64
        height: 64
        opacity: 1
        z: 4
        source: "../Pictogram/uso/0_TSM.png"
    }

    Image {
        id: img8
        x: 448
        y: 0
        width: 64
        height: 64
        source: "../Pictogram/uso/0_TXA.png"
        opacity: 1
        z: 4
    }

    Image {
        id: img7
        x: 384
        y: 0
        width: 64
        height: 64
        source: "../Pictogram/uso/0z_ti.png"
        opacity: 1
        z: 4
    }
}
