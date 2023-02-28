import QtQuick 2.7
import "scripts.js" as Scripts
// переключение между экранами "ЭЛЕКТРООБОРУДОВАНИЕ"
// лампочки отдельной формой лежат сверху на отдельной форме
Rectangle {
    width: 640
    height: 64
    color: "#000000"
    border.width: 0

    property string cltxtSelect:"#1bb7e4"; // цвет текста нажатой кнопки
    property string cltxt:"white";         // штатный цвет текста всех кнопок

    signal switchEl_Bortovay();       // бортовая сеть
    signal switchEl_Vozbugdenie();    // система возбуждения
    signal switchEl_Tagovie();        // тяговые двигатели
    signal switchEl_Motores();        // моторесурс
    signal switchEl_Exit();           // переход на уровень ввех

    signal knopaS(); // сигнал о нажатии клавиши ДМ "S"
    signal knopai(); // сигнал о нажатии клавиши ДМ "i"
    signal knopaSt(); // сигнал о нажатии клавиши ДМ "St"
    signal knopaUD(); // сигнал о нажатии клавиши ДМ "UD"

    Keys.onPressed: {
        var key = Scripts.getKey(event.key)

        switch(key) {

        case "0":
            // ?? надо на Главное меню вернуться
            btn1.border.color = btn2.border.color = "black"

            img6.source = "../Pictogram/elektr/0_akb.png"
            img7.source = "../Pictogram/elektr/0_vzb.png"
            img8.source = "../Pictogram/elektr/0_ted.png"
            img9.source = "../Pictogram/elektr/0_rgm.png"

            switchEl_Exit();
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
        case "6":
            img6.source = "../Pictogram/elektr/1_akb.png"
            img7.source = "../Pictogram/elektr/0_vzb.png"
            img8.source = "../Pictogram/elektr/0_ted.png"
            img9.source = "../Pictogram/elektr/0_rgm.png"

            switchEl_Bortovay();
            break;
        case "7":
            img6.source = "../Pictogram/elektr/0_akb.png"
            img7.source = "../Pictogram/elektr/1_vzb.png"
            img8.source = "../Pictogram/elektr/0_ted.png"
            img9.source = "../Pictogram/elektr/0_rgm.png"

            switchEl_Vozbugdenie();
            break;
        case "8":
            img6.source = "../Pictogram/elektr/0_akb.png"
            img7.source = "../Pictogram/elektr/0_vzb.png"
            img8.source = "../Pictogram/elektr/1_ted.png"
            img9.source = "../Pictogram/elektr/0_rgm.png"

            switchEl_Tagovie();
            break;
        case "9":
            img6.source = "../Pictogram/elektr/0_akb.png"
            img7.source = "../Pictogram/elektr/0_vzb.png"
            img8.source = "../Pictogram/elektr/0_ted.png"
            img9.source = "../Pictogram/elektr/1_rgm.png"

            switchEl_Motores();
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
        source: "../Pictogram/elektr/0_rgm.png"
    }

    Image {
        id: img8
        x: 448
        y: 0
        width: 64
        height: 64
        source: "../Pictogram/elektr/0_ted.png"
        opacity: 1
        z: 4
    }

    Image {
        id: img7
        x: 384
        y: 0
        width: 64
        height: 64
        source: "../Pictogram/elektr/0_vzb.png"
        opacity: 1
        z: 4
    }

    Image {
        id: img6
        x: 320
        y: 0
        width: 64
        height: 64
        source: "../Pictogram/elektr/0_akb.png"
        opacity: 1
        z: 4
    }

    Image {
        id: img5
        x: 256
        y: 0
        width: 64
        height: 64
        source: "../Pictogram/elektr/0z_ele.bmp"
        opacity: 1
        z: 4
    }

    Kdr_LedError {
        id: err
        x: 0
        y: 0
        tr1: 0
        vz6: 1
        vz7: 1
        vz8: 1
        vz9: 1
        vz2: 1
        vz1: 1
        z: 9
    }

    Timer { // для отрисовки лампочек с ошибками
        triggeredOnStart: true
        interval: 500
        repeat: true
        running: kdr_FootElektrooborud.opacity // при появлении панели - лампочки иницализируем
        onTriggered: {

            var trs = ioBf.getParamKdrFtElektr();
            err.tr1 = trs[0];
            err.tr2 = trs[1];

            err.tr6 = trs[2];
            err.tr7 = trs[3];
            err.tr8 = trs[4];
            err.tr9 = trs[5];
        }

    }

}
