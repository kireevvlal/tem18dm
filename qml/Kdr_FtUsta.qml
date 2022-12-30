import QtQuick 2.7
//  меню УСТА
Rectangle {
    width: 640
    height: 64
    color: "#000000"
    border.width: 0

    property int idDisp:0; // номер нажатой клавиши - номер секции подвязать
    property string cltxtSelect:"#1bb7e4"; // цвет текста нажатой кнопки
    property string cltxt:"white";         // штатный цвет текста всех кнопок

    signal switchUso_USTA_DisVih();    // переход на меню
    signal switchUso_USTA_DisVhod();  //
    signal switchUso_USTA_Analogi(int offset);   //
    signal switchUso_Exit();    // переход на уровень ввех

    signal knopaS();  // сигнал о нажатии клавиши ДМ "S"
    signal knopai();  // сигнал о нажатии клавиши ДМ "i"
    signal knopaSt(); // сигнал о нажатии клавиши ДМ "St"
    signal knopaUD(); // сигнал о нажатии клавиши ДМ "UD"

    signal knopaDwn(); // сигнал о нажатии клавиши ДМ "стрелка вниз"
    signal knopaUp(); // сигнал о нажатии клавиши ДМ "стрелка вверх"

    Keys.onPressed: {
        switch(event.key) {
//        case Qt.Key_Down: { knopaDwn(); }
//        case Qt.Key_Up:   { knopaUp();  }

        case Qt.Key_0:   {
            // ?? надо на Главное меню вернуться
            img1.source = "../Pictogram/m0_lok.png";// !! доделать
            img2.source = "../Pictogram/m0_lok.png";// !! доделать

            idDisp = 0;

            img7.source =  "../Pictogram/uso/0_dot.png"
            img8.source =  "../Pictogram/uso/0_din.png"
            img9.source =  "../Pictogram/uso/0_a.png"

            switchUso_Exit();
            break;
        }
        case Qt.Key_1:        {
            if (kdr_Foot.setSection(1)) {
                img1.source = "../Pictogram/m1_lok.png";
                img2.source = "../Pictogram/m0_lok.png";

                idDisp = 1; // ?? надо подать сигнал о смене секций
                txt_1.color = cltxtSelect;
                txt_2.color = cltxt;
            }
            break;
        }
        case Qt.Key_2:        {
            if (kdr_Foot.setSection(1)) {
                img1.source = "../Pictogram/m0_lok.png";
                img2.source = "../Pictogram/m1_lok.png";

                idDisp = 2; // ?? надо подать сигнал о смене секций
                txt_2.color = cltxtSelect;
                txt_1.color = cltxt;
            }
            break;
        }
        case Qt.Key_7:        {
            img7.source =  "../Pictogram/uso/1_dot.png"
            img8.source =  "../Pictogram/uso/0_din.png"
            img9.source =  "../Pictogram/uso/0_a.png"

            switchUso_USTA_DisVih();
            break;
        }
        case Qt.Key_8:        {
            img7.source =  "../Pictogram/uso/0_dot.png"
            img8.source =  "../Pictogram/uso/1_din.png"
            img9.source =  "../Pictogram/uso/0_a.png"

            switchUso_USTA_DisVhod();
            break;
        }
        case Qt.Key_9:        {
            if (kdr_USTA_Analog.opacity == 1) {
                switchUso_USTA_Analogi(1);
            }
            else {
                img7.source = "../Pictogram/uso/0_dot.png"
                img8.source = "../Pictogram/uso/0_din.png"
                img9.source = "../Pictogram/uso/1_aud.png"
            }
            break;
        }
        // *** ! кодировка на ТПК может отличаться
        case Qt.Key_B:  //66 :
        {   knopaS(); // сигнал о нажатии клавиши ДМ "S"
            break;
        }
        case Qt.Key_C:  //67 :
        {   knopai(); // сигнал о нажатии клавиши ДМ "i"
            break;
        }
        case Qt.Key_D:  //68 :
        {   knopaSt(); // сигнал о нажатии клавиши ДМ "St"
            break;
        }
        case Qt.Key_I:  //73 :
        {   knopaUD(); // сигнал о нажатии клавиши ДМ "UD"
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
        color: (main_window.current_section == 1) ? cltxtSelect : cltxt
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
        source: (main_window.current_section == 1) ? "../Pictogram/m1_lok.png" : "../Pictogram/m0_lok.png"
    }

    Image {
        id: img2
        x: 64
        y: 0
        width: 64
        height: 64
        z: 4
        source: (main_window.current_section == 2) ? "../Pictogram/m1_lok.png" : "../Pictogram/m0_lok.png"
    }

    Image {
        id: img9
        x: 512
        y: 0
        width: 64
        height: 64
        opacity: 1
        z: 4
        source: "../Pictogram/uso/0_a.png"
    }

    Image {
        id: img8
        x: 448
        y: 0
        width: 64
        height: 64
        source: "../Pictogram/uso/0_din.png"
        opacity: 1
        z: 4
    }

    Image {
        id: img7
        x: 384
        y: 0
        width: 64
        height: 64
        source: "../Pictogram/uso/0_dot.png"
        opacity: 1
        z: 4
    }

    Image {
        id: img6
        x: 320
        y: 0
        width: 64
        height: 64
        source: "../Pictogram/uso/0z_ust.png"
        z: 4
        opacity: 1
    }
}
