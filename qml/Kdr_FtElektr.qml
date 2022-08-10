import QtQuick 2.7
// переключение между экранами "ЭЛЕКТРООБОРУДОВАНИЕ"
// лампочки отдельной формой лежат сверху на отдельной форме
Rectangle {
    width: 640
    height: 64
    color: "#000000"
    border.width: 0

    property int idDisp:0; // номер нажатой клавиши - номер секции подвязать
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
        switch(event.key){
        case Qt.Key_0:
        {
            // ?? надо на Главное меню вернуться
            img1.source = "../Pictogram/m0_lok.png";// !! доделать
            img2.source = "../Pictogram/m0_lok.png";// !! доделать

            idDisp = 0;

            img6.source = "../Pictogram/elektr/0_akb.png"
            img7.source = "../Pictogram/elektr/0_vzb.png"
            img8.source = "../Pictogram/elektr/0_ted.png"
            img9.source = "../Pictogram/elektr/0_rgm.png"

            switchEl_Exit();
            break;
        }
        case Qt.Key_1:
        {
            img1.source = "../Pictogram/m1_lok.png";
            img2.source = "../Pictogram/m0_lok.png";

            idDisp = 1; // ?? надо подать сигнал о смене секций
            txt_1.color = cltxtSelect;
            txt_2.color = cltxt;

            break;
        }
        case Qt.Key_2:
        {
            img1.source = "../Pictogram/m0_lok.png";
            img2.source = "../Pictogram/m1_lok.png";

            idDisp = 2; // ?? надо подать сигнал о смене секций
            txt_2.color = cltxtSelect;
            txt_1.color = cltxt;
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
            img6.source = "../Pictogram/elektr/1_akb.png"
            img7.source = "../Pictogram/elektr/0_vzb.png"
            img8.source = "../Pictogram/elektr/0_ted.png"
            img9.source = "../Pictogram/elektr/0_rgm.png"

            switchEl_Bortovay();
            break;
        }
        case Qt.Key_7:
        {
            img6.source = "../Pictogram/elektr/0_akb.png"
            img7.source = "../Pictogram/elektr/1_vzb.png"
            img8.source = "../Pictogram/elektr/0_ted.png"
            img9.source = "../Pictogram/elektr/0_rgm.png"

            switchEl_Vozbugdenie();
            break;
        }
        case Qt.Key_8:
        {
            img6.source = "../Pictogram/elektr/0_akb.png"
            img7.source = "../Pictogram/elektr/0_vzb.png"
            img8.source = "../Pictogram/elektr/1_ted.png"
            img9.source = "../Pictogram/elektr/0_rgm.png"

            switchEl_Tagovie();
            break;
        }
        case Qt.Key_9:
        {
            img6.source = "../Pictogram/elektr/0_akb.png"
            img7.source = "../Pictogram/elektr/0_vzb.png"
            img8.source = "../Pictogram/elektr/0_ted.png"
            img9.source = "../Pictogram/elektr/1_rgm.png"

            switchEl_Motores();
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
        //        case Qt.Key_Escape :{ ioBf.close(); break};

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
        opacity: 1
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

            var trs = ioBf.getTrevogaElectr();
            err.tr1 = trs[0];
            err.tr2 = trs[1];

            err.tr6 = trs[2];
            err.tr7 = trs[3];
            err.tr8 = trs[4];
            err.tr9 = trs[5];
        }

    }

}
