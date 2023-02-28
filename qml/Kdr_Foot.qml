import QtQuick 2.7
import "scripts.js" as Scripts


// переключение между экранами
// индикаторы лежат отдельно
Rectangle {
    width: 640
    height: 64
    color: "#000000"
    border.width: 0

    property string cltxtSelect:"#1bb7e4"; // цвет текста нажатой кнопки
    property string cltxt:"white";         // штатный цвет текста всех кнопок
    property int start_counter: 0;

    signal switchFootDizel();  // переход на меню ДИЗЕЛЬ
    signal switchFootElektr(); // переход на меню ЭЛЕКТРООБОРУДОВАНИЕ
    signal switchFoot_Exit();    // переход в начало

    signal knopaS();  // сигнал о нажатии клавиши ДМ "S"
    signal knopai();  // сигнал о нажатии клавиши ДМ "i"
    signal knopaSt(); // сигнал о нажатии клавиши ДМ "St"
    signal knopaUD(); // сигнал о нажатии клавиши ДМ "UD"
    signal saveToUSB(); // сигнал о необходимости записи на USB (для отработки под Windows)

    //** переключение
    Keys.onPressed: {
        var key = Scripts.getKey(event.key)
        if (key === "3" || key === "4"|| key === "5"|| key === "6"|| key === "7") {
            main_window.passwordstr += key
            if (main_window.passwordstr == "45764576")
                Qt.quit();
            else if (main_window.passwordstr == "35746") {
                knopaS() // settings
                main_window.current_system = 4
            }
        } else if (key !== "SPECIAL")
                main_window.passwordstr = ""

        switch(key) {

        case "0":
            btn1.border.color = btn2.border.color = "black"
            img8.source = "../Pictogram/0_diz.png";
            img9.source = "../Pictogram/0_ele.png";
            img0.opacity = 0;
            img8.opacity = 0; err.vz8 = 0;
            img9.opacity = 0; err.vz9 = 0;
            txt_1.color = txt_2.color = cltxt;
            kdr_TrLs.opacity = kdr_Nastroika.opacity = kdr_Develop.opacity = 0;
            switchFoot_Exit();
            break;
        case "1":
            if (Scripts.setSection(1)) {
                btn1.border.color = "silver"
                btn2.border.color = "black"
                img8.source = "../Pictogram/0_diz.png";
                img9.source = "../Pictogram/0_ele.png";
                img0.opacity = 1;
                img8.opacity = 1; err.vz8 = 1;
                img9.opacity = 1; err.vz9 = 1;
                txt_1.color =cltxtSelect;
                txt_2.color = cltxt;
            }
            break;
        case "2":
            if (Scripts.setSection(2)) {
                btn1.border.color = "black"
                btn2.border.color = "silver"
                img8.source = "../Pictogram/0_diz.png";
                img9.source = "../Pictogram/0_ele.png";
                img0.opacity = 1;
                img8.opacity = 1; err.vz8 = 1;
                img9.opacity = 1; err.vz9 = 1;
                txt_2.color = cltxtSelect;
                txt_1.color = cltxt;
            }
            break;
        case "3":
            break;
        case "4":
            break;
        case "5":
            break;
        case "6":
            break;
        case "7":
            break;
        case "8":
            if (kdr_TrLs.opacity)  // кадр тревожных сообщений
                trListUp();
            else {
                if (img8.opacity == 1)  // будем переключаться на меню ДИЗЕЛЬ
                {
                    switchFootDizel();
                    current_system = 1;
                }
            }
            break;
        case "9":
            if (kdr_TrLs.opacity)   // кадр тревожных сообщений
                trListDown();
            else {
                if (img9.opacity == 1) // будем переключаться на меню ЭЛЕКТРООБОРУДОВАНИЕ
                {
                    switchFootElektr();
                    current_system = 2;
                }
            }
            break;
            // *** ! кодировка на ТПК может отличаться
//        case Qt.Key_B:  //66 :
//            knopaS(); // сигнал о нажатии клавиши ДМ "S"
//            main_window.current_system = 4;
//            break;

        case "I":  //67 :
            doTrMessList();
            knopai(); // сигнал о нажатии клавиши ДМ "i"
            current_system = 5;
            break;

        case "V>0": //Qt.Key_D:  //68 :
            img0.opacity = 1;
            knopaSt(); // сигнал о нажатии клавиши ДМ "St"
            current_system = 6;
            break;

        case "UD":  //73 :
            knopaUD(); // сигнал о нажатии клавиши ДМ "UD"
            current_system = 3;
            break;

        case "V=0":
//            main_window.current_system = 7;
            saveToUSB();
            break;

        case "DOWN":
            if (kdr_TrLs.opacity)
                trListDown();
            break;

        case "UP":
            if (kdr_TrLs.opacity)
                trListUp();
            break;
        case "C":
            kdr_Privet.opacity = 1;
            break;
        case "CONTRAST":
            kdr_Develop.opacity = 1;
            break;
        }
    }

    function trListUp() {
        if (kdr_TrLs.first - 15 >= 0)
            kdr_TrLs.first -= 15;
        else
            kdr_TrLs.first = 0;
    }

    function trListDown() {
        if (kdr_TrLs.first < kdr_TrLs.count - 29) {
            kdr_TrLs.first += 15;
        }
        else
            if (kdr_TrLs.count > 15)
                kdr_TrLs.first = kdr_TrLs.count - 16;
    }

    Text {
        id: no_connections
        x: 20
        y: 20
        color: "silver"
        text: qsTr("НЕТ СВЯЗИ")
        font.bold: true
        font.family: main_window.deffntfam
        font.pixelSize: 30
        visible: !is_links && !is_slave
    }

    Text {
        id: txt_1
        x: 0
        y: 27
        width: 64
        height: 37
        color: "#ffffff"
        text: qsTr("1")
        z: 3
        font.italic: false
        font.bold: true
        font.family: main_window.deffntfam
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 30
        visible: is_links
    }

    Text {
        id: txt_2
        x: 64
        y: 27
        width: 64
        height: 37
        color: "#ffffff"
        text: qsTr("2")
        z: 8
        wrapMode: Text.NoWrap
        font.italic: false
        font.pixelSize: 30
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        font.family: main_window.deffntfam
        visible: is_slave
    }


    Image {
        id: img0
        x: 576
        y: 0
        width: 64
        height: 64
        opacity: 0
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
        border.color: "black"
        Image {
            id: img1
            x: 1
            y: 1
            width: 62
            height: 62
            source: "../Pictogram/m_lok.png"
        }
        visible: is_links
    }

    Rectangle {
        id: btn2
        x: 64
        y: 0
        width: 64
        height: 64
        border.width: 1
        border.color: "black"
        Image {
            id: img2
            x: 1
            y: 1
            width: 62
            height: 62
            source: "../Pictogram/m_lok.png"
        }
        visible: is_links
    }

    Image {
        id: img9
        x: 512
        y: 0
        width: 64
        height: 64
        opacity: 0
        z: 4
        source: "../Pictogram/0_ele.png"
    }

    Image {
        id: img8
        x: 448
        y: 0
        width: 64
        height: 64
        opacity: 0
        z: 4
        source: "../Pictogram/0_diz.png"
    }

    Kdr_LedError { // панель с тревогами-ошибками
        id: err
        x: 0
        y: 0
        width: 640
        height: 64
        tr2: 0
        tr1: 0
        vz2: 1
        vz1: 1
        z: 9
    }


    Timer { // для отрисовки лампочек с ошибками
        triggeredOnStart: true
        interval: 500
        repeat: true
        running: kdr_Foot.opacity // при появлении панели - лампочки иницализируем
        onTriggered: {
            if (start_counter < 4)
                start_counter++;
            var trs = ioBf.getParamKdrFoot();
            err.tr1 = trs[0]; // 0
            err.tr2 = trs[1]; // 1
            err.tr8 = trs[2]; // 7
            err.tr9 = trs[3]; // 8
            if (current_section == 2 && !is_slave) {
                Scripts.setSection(1);
                switchFoot_Exit();
            }
            if (current_section == 1 && !is_links && start_counter >= 4) {
                Scripts.setSection(2);
//                if (kdr_TrLs.opacity || kdr_Nastroika.opacity || kdr_Develop.opacity) {
//                    switchFoot_Exit();
//                    kdr_TrLs.opacity = 1; // restore
//                } else
                    switchFoot_Exit();
            }
        }

    }

    function doExit() {
        Scripts.setSection(1);
        current_system = 0;
        btn1.border.color = btn2.border.color = "black"
        if (!kdr_TrLs.opacity)
        img0.opacity = img8.opacity = img9.opacity = 0;
        err.vz8 = err.vz9 = 0;
        txt_1.color = txt_2.color = cltxt;
    }

    function doTrMessList() {
        Scripts.opacityNul();
        Scripts.setSection(1);
        current_system = 0;
        btn1.border.color = btn2.border.color = "black"
        img8.opacity = img9.opacity = 0;
        img0.opacity = 1;
        err.vz8 = err.vz9 = 0;
        txt_1.color = txt_2.color = cltxt;
        img8.source = "../Pictogram/0_up.png";
        img9.source = "../Pictogram/0_dn.png";
        img8.opacity = img9.opacity = 1;
        kdr_TrLs.opacity = 1;
        kdr_Foot.opacity = 1;
        kdr_Foot.focus = true;
    }

}
