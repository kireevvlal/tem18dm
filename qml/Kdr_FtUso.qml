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

    signal switchUso_TI();      // переход на меню
    signal switchUso_USTA();    //
    signal switchUso_BEL();     //
    signal switchUso_Exit();    // переход на уровень ввех

    signal knopaS();  // сигнал о нажатии клавиши ДМ "S"
    signal knopai();  // сигнал о нажатии клавиши ДМ "i"
    signal knopaSt(); // сигнал о нажатии клавиши ДМ "St"
    signal knopaUD(); // сигнал о нажатии клавиши ДМ "UD"

    Keys.onPressed: {
        var key = Scripts.getKey(event.key)

        switch(key) {

        case "0":
            btn1.border.color = btn2.border.color = "black"
            img7.source = "../Pictogram/uso/0_ti.png"
            img8.source = "../Pictogram/uso/0_ust.png"
            img9.source = "../Pictogram/uso/0_bel.png"
            switchUso_Exit();
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
        case "7":
            main_window.current_system = 11;
            switchUso_TI();
            break;
        case "8":
            main_window.current_system = 12;
            switchUso_USTA();
            break;
        case "9":
            main_window.current_system = 13;
            switchUso_BEL();
            break;
        case "I":  //67 :
            kdr_Foot.doTrMessList();
            knopai(); // сигнал о нажатии клавиши ДМ "i"
            break;
        case "V>0":  //68 :
            knopaSt(); // сигнал о нажатии клавиши ДМ "St"
            break;
        case "UD":  //73 :
            knopaUD(); // сигнал о нажатии клавиши ДМ "UD"
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
        font.family: "Times New Roman"
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
        font.family: "Times New Roman"
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
        source: "../Pictogram/uso/0_bel.png"
    }

    Image {
        id: img8
        x: 448
        y: 0
        width: 64
        height: 64
        source: "../Pictogram/uso/0_ust.png"
        opacity: 1
        z: 4
    }

    Image {
        id: img7
        x: 384
        y: 0
        width: 64
        height: 64
        source: "../Pictogram/uso/0_ti.png"
        opacity: 1
        z: 4
    }
}
