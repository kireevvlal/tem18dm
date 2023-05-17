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

    //** переключение
    Keys.onPressed: {
        var key = Scripts.getKey(event.key)
        if (!kdr_TrLs.opacity && !kdr_Nastroika.opacity && !kdr_Develop.opacity) {
            if (key === "3" || key === "4"|| key === "5"|| key === "6"|| key === "7") {
                main_window.passwordstr += key
                if (main_window.passwordstr == "35746")
                    Qt.quit();
                else if (main_window.passwordstr == "357") {
                    doNastroyki() // settings
                    main_window.current_system = 4
                }
                else if (main_window.passwordstr == "46357")
                    kdr_Develop.opacity = 1;
            } else if (key !== "SPECIAL")
                main_window.passwordstr = ""
        }

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
            main_window.go_Exit(kdr_TrLs.opacity || kdr_Nastroika.opacity || kdr_Develop.opacity || kdr_Svz)
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

        case "8":
            if (kdr_TrLs.opacity)  // кадр тревожных сообщений
                trListUp();
            else {
                if (img8.opacity == 1)  // будем переключаться на меню ДИЗЕЛЬ
                {
                    kdr_FootDizel.opacity = 1;
                    kdr_FootDizel.focus = true;
                    current_system = 1;
                }
            }
            break;
        case "9":
            if (kdr_TrLs.opacity)   // кадр тревожных сообщений
                trListDown();
            else if (kdr_Nastroika.opacity) {
                ioBf.saveSettings(kdr_Nastroika.number, kdr_Nastroika.psensors, kdr_Nastroika.elinj, kdr_Nastroika.svolume)
                main_window.lcm_number =qsTr("ТЭМ18ДМ  №" + kdr_Nastroika.number)
                main_window.sound_volume = kdr_Nastroika.svolume
            } else {
                if (img9.opacity == 1) // будем переключаться на меню ЭЛЕКТРООБОРУДОВАНИЕ
                {
                    kdr_FootElektrooborud.opacity = 1;
                    kdr_FootElektrooborud.focus = true;
                    current_system = 2;
                }
            }
            break;

        case "I":  //67 :
            doTrMessList();
            current_system = 5;
            break;

        case "V>0": //Qt.Key_D:  //68 :
            Scripts.opacityNul();
            kdr_Reostat.opacity = 1;
            current_system = 6;
            img0.opacity = 1;
            break;

        case "UD":  //73 :
            Scripts.opacityNul();
            kdr_Svz.opacity = 1;
            kdr_FootUso.opacity = 1;
            kdr_FootUso.focus = true;
            current_system = 3;
            break;

        case "V=0":
            main_window.saveToUSB();
            break;

        case "DOWN":
            if (kdr_TrLs.opacity)
                trListDown();
            else if (kdr_Nastroika.opacity) {
                if (kdr_Nastroika.active < 3)
                    kdr_Nastroika.active++
                kdr_Nastroika.pos = 0;
            }
            break;

        case "UP":
            if (kdr_TrLs.opacity)
                trListUp();
            else if (kdr_Nastroika.opacity) {
                if (kdr_Nastroika.active > 0)
                    kdr_Nastroika.active--
                kdr_Nastroika.pos = 0;
            }
            break;

        case "E":
            if (kdr_Nastroika.opacity) {
                if (!kdr_Nastroika.active) {
                    var digit = parseInt(kdr_Nastroika.number.charAt(kdr_Nastroika.pos))
                    if (digit > 0) {
                        digit--;
                        kdr_Nastroika.number = kdr_Nastroika.number.substring(0, kdr_Nastroika.pos) + digit.toString(10)
                                + kdr_Nastroika.number.substring(kdr_Nastroika.pos + 1)
                    }
                }
            }
            break;

        case "C":
            if (kdr_Nastroika.opacity) {
                if (!kdr_Nastroika.active) {
                    var dig = parseInt(kdr_Nastroika.number.charAt(kdr_Nastroika.pos))
                    if (dig < 9)
                        dig++;
                    kdr_Nastroika.number = kdr_Nastroika.number.substring(0, kdr_Nastroika.pos) + dig.toString(10)
                            + kdr_Nastroika.number.substring(kdr_Nastroika.pos + 1)
                }
            } else
                kdr_Privet.opacity = 1;
            break;
//        case "CONTRAST":
//            kdr_Develop.opacity = 1;
//            break;

        case "LEFT":
            if (kdr_Nastroika.opacity) {
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
            }
            break;
        case "RIGHT":
            if (kdr_Nastroika.opacity) {
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
            }
            break;
        }

    }

    function trListUp() {
        if (kdr_TrLs.first - 13 >= 0)
            kdr_TrLs.first -= 13;
        else
            kdr_TrLs.first = 0;
    }

    function trListDown() {
        if (kdr_TrLs.first < kdr_TrLs.count - 25) {
            kdr_TrLs.first += 13;
        }
        else
            if (kdr_TrLs.count > 13)
                kdr_TrLs.first = kdr_TrLs.count - 14;
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
        color: cltxt
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
        color: cltxt
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
                main_window.go_Exit(kdr_TrLs.opacity || kdr_Nastroika.opacity || kdr_Develop.opacity || kdr_Svz)
            }
            if (current_section == 1 && !is_links && start_counter >= 4) {
                if (!Scripts.setSection(2))
                    doExit()
                main_window.go_Exit(kdr_TrLs.opacity || kdr_Nastroika.opacity || kdr_Develop.opacity || kdr_Svz)
            }
        }

    }

    function doExit() {
        Scripts.setSection(1);
        current_system = 0;
        btn1.border.color = btn2.border.color = "black"
//        if (!kdr_TrLs.opacity)
        img0.opacity = img8.opacity = img9.opacity = 0;
        err.vz8 = err.vz9 = 0;
        txt_1.color = txt_2.color = cltxt;
    }

    function doTrMessList() {
        Scripts.opacityNul();
        kdr_FootUso.opacity = 0
        Scripts.setSection(1);
        current_system = 0;
//        img8.opacity = img9.opacity = 0;
        img0.opacity = 1;
        err.vz8 = err.vz9 = 0;
        img8.source = "../Pictogram/0_up.png";
        img9.source = "../Pictogram/0_dn.png";
        img8.opacity = img9.opacity = 1;
        kdr_TrLs.opacity = 1;
        kdr_Foot.opacity = 1;
        kdr_Foot.focus = true;
    }

    function doNastroyki() {
        Scripts.opacityNul();
        kdr_FootUso.opacity = 0
        Scripts.setSection(1);
        current_system = 0;
        img8.opacity = 0;
        img0.opacity = 1;
        err.vz8 = err.vz9 = 0;
        img9.source = "../Pictogram/save.png";
        img9.opacity = 1;
        kdr_Nastroika.opacity = 1;
        kdr_Foot.opacity = 1;
        kdr_Foot.focus = true;
    }

}
