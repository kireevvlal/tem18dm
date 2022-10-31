import QtQuick 2.7


// переключение между экранами
// индикаторы лежат отдельно
Rectangle {
    width: 640
    height: 64
    color: "#000000"
    border.width: 0

    property string cltxtSelect:"#1bb7e4"; // цвет текста нажатой кнопки
    property string cltxt:"white";         // штатный цвет текста всех кнопок

    //property int idDisp:0;  // номер нажатой клавиши - может привязать номер секции

    signal switchFootDizel();  // переход на меню ДИЗЕЛЬ
    signal switchFootElektr(); // переход на меню ЭЛЕКТРООБОРУДОВАНИЕ
    signal switchFoot_Exit();    // переход в начало
    signal switchSection(section: int);

    signal knopaS();  // сигнал о нажатии клавиши ДМ "S"
    signal knopai();  // сигнал о нажатии клавиши ДМ "i"
    signal knopaSt(); // сигнал о нажатии клавиши ДМ "St"
    signal knopaUD(); // сигнал о нажатии клавиши ДМ "UD"
    signal saveToUSB(); // сигнал о необходимости записи на USB (для отработки под Windows)

    //** переключение
    Keys.onPressed: {
        // console.log("код нажатой клавиши ===>" + event.key);
        switch(event.key){

        case Qt.Key_0:
        {
            img1.source = "../Pictogram/m0_lok.png"; err.vz1 = 1;
            img2.source = "../Pictogram/m0_lok.png"; err.vz2 = 1;
            img0.opacity = 0;
            img8.opacity = 0; err.vz8 = 0;
            img9.opacity = 0; err.vz9 = 0;
            switchFoot_Exit();
            break;
        }
        case Qt.Key_1:
        {
            img1.source = "../Pictogram/m1_lok.png"; err.vz1 = 1;
            img2.source = "../Pictogram/m0_lok.png"; err.vz2 = 1;
            img0.opacity = 1;
            img8.opacity = 1; err.vz8 = 1;
            img9.opacity = 1; err.vz9 = 1;
            txt_1.color =cltxtSelect;
            txt_2.color = cltxt;

            //idDisp = 1;  // ?? надо подать сигнал о смене секций, а может и не надо?
            switchSection(1);
            break;
        }
        case Qt.Key_2:
        {
            img1.source = "../Pictogram/m0_lok.png"; err.vz1 = 1;
            img2.source = "../Pictogram/m1_lok.png"; err.vz2 = 1;
            img0.opacity = 1;
            img8.opacity = 1; err.vz8 = 1;
            img9.opacity = 1; err.vz9 = 1;
            txt_2.color = cltxtSelect;
            txt_1.color = cltxt;

            //idDisp = 2;  // ?? надо подать сигнал о смене секций, а может и не надо?
            switchSection(2);
            break;
        }
        case Qt.Key_3:
        {
            break;
        }
        case Qt.Key_4:
        {
            break;
        }
        case Qt.Key_5:
        {
            break;
        }
        case Qt.Key_6:
        {
            break;
        }
        case Qt.Key_7:
        {
            break;
        }
        case Qt.Key_8:
        {
            if (img8.opacity == 1)  // будем переключаться на меню ДИЗЕЛЬ
            {
                switchFootDizel();
            }
            break;
        }
        case Qt.Key_9:
        {
            if (img9.opacity == 1) // будем переключаться на меню ЭЛЕКТРООБОРУДОВАНИЕ
            {
                switchFootElektr();
            }
            break;
        }
        // *** ! кодировка на ТПК может отличаться
        case Qt.Key_B:  //66 :
        {
            console.log("даем сигнал о нажатии В");
            knopaS(); // сигнал о нажатии клавиши ДМ "S"
            break;
        }
        case Qt.Key_C:  //67 :
        {
            console.log("даем сигнал о нажатии C");
            knopai(); // сигнал о нажатии клавиши ДМ "i"
            break;
        }
        case Qt.Key_D:  //68 :
        {
            console.log("даем сигнал о нажатии D");
            knopaSt(); // сигнал о нажатии клавиши ДМ "St"
            break;
        }
        case Qt.Key_I:  //73 :
        {
            console.log("даем сигнал о нажатии I");
            knopaUD(); // сигнал о нажатии клавиши ДМ "UD"
            break;
        }
        // ***
        case Qt.Key_Escape :{
            // выходим из программы
            ioBf.close();
            break;
        }
        // kireev add for windows
        case Qt.Key_S: {
                console.log("даем сигнал о нажатии S");
            saveToUSB();
            break;
        }

        }
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
        font.family: "Times New Roman"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 30
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
        font.family: "Times New Roman"
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

    Image {
        id: img1
        x: 0
        y: 0
        width: 64
        height: 64
        z: 2
        source: "../Pictogram/m0_lok.png"
    }

    Image {
        id: img2
        x: 64
        y: 0
        width: 64
        height: 64
        z: 4
        source: "../Pictogram/m0_lok.png"
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
            var trs = ioBf.getTrevogaTotal();
            err.tr1 = trs[0]; // 0
            err.tr2 = trs[1]; // 1
            err.tr8 = trs[2]; // 7
            err.tr9 = trs[3]; // 8
        }

    }


}
