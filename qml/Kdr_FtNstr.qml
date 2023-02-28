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

    signal switchNstr_Exit();    // переход на уровень ввех
    signal saveNstr();


    Keys.onPressed: {
        var key = Scripts.getKey(event.key)

        switch(key) {

        case "0":
            btn1.border.color = btn2.border.color = "black"
            switchNstr_Exit();
            break;
        case "9":
            ioBf.saveSettings(kdr_Nastroika.number, kdr_Nastroika.psensors, kdr_Nastroika.elinj, kdr_Nastroika.svolume)
            main_window.lcm_number =qsTr("ТЭМ18ДМ  №" + kdr_Nastroika.number)
            main_window.sound_volume = kdr_Nastroika.svolume
            break;
        case "UP":
            if (kdr_Nastroika.active > 0)
                kdr_Nastroika.active--
            kdr_Nastroika.pos = 0;
            break;
        case "DOWN":
            if (kdr_Nastroika.active < 3)
                kdr_Nastroika.active++
            kdr_Nastroika.pos = 0;
            break;
        case "LEFT":
            switch (kdr_Nastroika.active) {
            case 0:
                if (kdr_Nastroika.pos > 0)
                    kdr_Nastroika.pos--
                break;
            case 1: kdr_Nastroika.elinj = (kdr_Nastroika.elinj) ? false : true
                break;
            case 2: kdr_Nastroika.psensors = (kdr_Nastroika.psensors == 16) ? 6 : 16
                break;
            case 3:
                if (kdr_Nastroika.svolume - 10 >= 10)
                    kdr_Nastroika.svolume -= 10;
                else
                    kdr_Nastroika.svolume = 10;
                break;
            }
            break;
        case "RIGHT":
            switch (kdr_Nastroika.active) {
            case 0:
                if (kdr_Nastroika.pos < 3)
                    kdr_Nastroika.pos++
                break;
            case 1: kdr_Nastroika.elinj = (kdr_Nastroika.elinj) ? false : true
                break;
            case 2: kdr_Nastroika.psensors = (kdr_Nastroika.psensors == 16) ? 6 : 16
                break;
            case 3:
                if (kdr_Nastroika.svolume + 10 <= 100)
                    kdr_Nastroika.svolume += 10;
                else
                    kdr_Nastroika.svolume = 100;
                break;
            }
            break;
        case "E":
            if (!kdr_Nastroika.active) {
                var digit = parseInt(kdr_Nastroika.number.charAt(kdr_Nastroika.pos))
                if (digit > 0) {
                    digit--;
                    kdr_Nastroika.number = kdr_Nastroika.number.substring(0, kdr_Nastroika.pos) + digit.toString(10)
                        + kdr_Nastroika.number.substring(kdr_Nastroika.pos + 1)
                }
            }
            break;
        case "C":
            if (!kdr_Nastroika.active) {
                var dig = parseInt(kdr_Nastroika.number.charAt(kdr_Nastroika.pos))
                if (dig < 9)
                    dig++;
                kdr_Nastroika.number = kdr_Nastroika.number.substring(0, kdr_Nastroika.pos) + dig.toString(10)
                        + kdr_Nastroika.number.substring(kdr_Nastroika.pos + 1)
            }
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
        source: "../Pictogram/save.png"
    }

}
