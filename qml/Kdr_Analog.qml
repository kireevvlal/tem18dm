import QtQuick 2.7

Rectangle {// Экран отображения аналоговых сигналов с перелитыванием страниц стерлками вверх/вниз
    //width: 508 //512
    height: 197 //245 //246
    color: "#000000"

    property int cntRowTabl: 10;   // количество строк 10 при нумерации с нуля
    property int bazaoffset: 80;  // начальный индекс из массива надписей
    property int offset: 80;      // текущий индекс из массива надписей (выводим по cntRowTabl строк)
    property string namePage: qsTr("параметры УСТА"); // название экрана
    property int cntPage: 4;      // количество страниц на экране

    // переменные для передачи надписей из массива констант из файла zapuso.h
    property string str_r: "s_r";   // разьем
    property string str_n: "s_n";   // номер выхода
    property string str_o: "s_o";   // обозначение
    property string str_i: "s_i";   // имя
    property string str_a: "s_a";   // размерность

    property int  numPage: 1;     // номер активной страницы
    onOffsetChanged: timer_text.restart();

    // заголовок экрана
    Text {
        id: text1
        x: 0
        y: 0
        color: "#d2e8fb"
        text:  qsTr(namePage+ ": окно " + numPage + "[" + cntPage + "]");
        font.bold: true
        font.pixelSize: 14
        font.family: main_window.deffntfam
    }

    //************************************
    // подготовка данных
    ListModel {
        id:usoModelAnalog
        Component.onCompleted: {
            var i;
            for (i = 0;i < cntRowTabl; i++)
            {   // создание динамическго списка usoModelAnalog с полями:
               usoModelAnalog.append(
               {"Anlg_r":"", "Anlg_n":"", "Anlg_o":"", "Anlg_i":"","Anlg_val":"", "Anlg_a":""});
            }
        }
    }

    // в столбик
    Column {
        id: usoLeftDin
        x: 1 //6
        y: 18 //23
        width: 508
        height: 174
        
        ListView {
            id: viewLeftDin
            x: 0
            width: parent.width
            height: 174
            highlightRangeMode: ListView.NoHighlightRange
            model: usoModelAnalog
            header: Rectangle {// верхний декор
                width: parent.width
                height: 20
                gradient:Gradient{
                    GradientStop{position: 0; color: "gray"}
                    GradientStop{position: 0.9; color: "blue"}
                    GradientStop{position: 1; color: "gray"}
                }
                Text{
                    color: "white";
                    font.pixelSize: 12
                    font.family: main_window.deffntfam
                    text: "  Разъем                          Обозн.        Наименование                      Значение   Ед.изм.";
                }

            }

            delegate: USOAnalog {
                x:0
                y:20
               // width: 508 //510
                height: 16
                radius: 0
                border.width: 1
                edit1value: Anlg_r;
                edit2value: Anlg_n;
                edit3value: Anlg_o;
                edit4value: Anlg_i;
                edit5value: Anlg_val;
                edit6value: Anlg_a;
            }
        }
    }


    function usoTxtAng(j, strarr) {
        usoModelAnalog.setProperty(j, "Anlg_r", strarr[0]);
        usoModelAnalog.setProperty(j, "Anlg_n", strarr[1]);
        usoModelAnalog.setProperty(j, "Anlg_o", strarr[2]);
        usoModelAnalog.setProperty(j, "Anlg_i", strarr[3]);
        usoModelAnalog.setProperty(j, "Anlg_a", strarr[4]);
    }


    Timer { // надписи в таблице
        id: timer_text
        triggeredOnStart: false // true - запускается сразу и по repet(т.е.срабатывает два раза)
        repeat:false // и еще разок вывели и успокоились
        interval: 100
        running: true
        onTriggered: {
            // console.log(" таймер timer_text сработал  в Kdr_Analog");
            var i;
            var strarr;
            //столбики
            for (i=0;i<cntRowTabl;i++) {
                strarr = ioBf.getStructAnlg(i + offset);
                usoTxtAng(i, strarr);
            }
        }
    }
    //
    Timer { // значение втаблицу
        id: timer_value
        triggeredOnStart: true
        repeat:true
        interval: 500
        running: kdr_USTA_Analog.opacity || kdr_TI_TXA.opacity || kdr_TI_TCM.opacity || kdr_BEL_Analog.opacity //true // включается по usoview.opacity
        property int j:0;
        onTriggered: {
            var i;
            if ((kdr_USTA_Analog.opacity && offset < 40) || (kdr_BEL_Analog.opacity && offset == 40) ||
                    (kdr_TI_TXA.opacity && offset >=80) ||(kdr_TI_TCM.opacity && offset >= 50 && offset <= 70)) {
                var values = ioBf.getAnalogArray(offset);
                var precision = values[0];
                for (i = 0;i < cntRowTabl; i++) {
                    usoModelAnalog.setProperty(i, "Anlg_val", precision ? values[i + 1].toFixed(precision) : values[i + 1].toString()); //(offset+j).toString());
                }
            }
        }
    }

}

