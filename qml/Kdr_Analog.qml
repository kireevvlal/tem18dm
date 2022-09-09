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

//    function usoTxtAng(j,str_r, str_n, str_o, str_i, str_a) {
//        // значения нужно вытащить из структуры
//        // присвоение свойствам значений

//        usoModelAnalog.setProperty(j, "Anlg_r", str_r);
//        usoModelAnalog.setProperty(j, "Anlg_n", str_n);
//        usoModelAnalog.setProperty(j, "Anlg_o", str_o);
//        usoModelAnalog.setProperty(j, "Anlg_i", str_i);
//        usoModelAnalog.setProperty(j, "Anlg_a", str_a);
//    }

    function usoTxtAng(j, strarr) {
        // значения нужно вытащить из структуры
        // присвоение свойствам значений
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
//                str_r = ioBf.getStructAnlg_r(i+offset);
//                str_n = ioBf.getStructAnlg_n(i+offset);
//                str_o = ioBf.getStructAnlg_o(i+offset);
//                str_i = ioBf.getStructAnlg_i(i+offset);
//                str_a = ioBf.getStructAnlg_a(i+offset);

//                usoTxtAng(i, str_r, str_n, str_o, str_i, str_a);
            }

        }
    }
    //
    Timer { // значение втаблицу
        id: timer_value
        triggeredOnStart: true
        repeat:true
        interval: 500
        running: true // включается по usoview.opacity
        property int j:0;
        onTriggered: {
            var i;
            var values = ioBf.getAnalogArray(offset);
            var precition = values[0];
            for (i = 0;i < cntRowTabl; i++) {
                 // значения сигналов
                 // !!!!! дописать ioBf смещение по массиву в зависимости от offset
                  //  j ++ ; отладка
                 usoModelAnalog.setProperty(i, "Anlg_val", precition ? values[i + 1].toFixed(precition) : values[i + 1].toString()); //(offset+j).toString());
             }
        }
    }

    Text {  // текст подсказка
        id: text2
        x: 266
        y: 3
        color: "#808080"
        text: "переход по страницам стрелки вверх/вниз"
        font.pixelSize: 12
        font.bold: false
    }


    // ** не пригодилось ** переключение страниц
    //    Keys.onPressed: {
    //        switch(event.key){
    //            case Qt.Key_Down:
    //            {
    //                numPage = numPage + 1;
    //                if (numPage>cntPage) {numPage=1};
    //                console.log("стрелка вниз/перевели фокус на внутр QML/ num_page==" + numPage);
    //                text1.text = qsTr(namePage+ ": окно " + numPage + "[" + cntPage + "]");
    //                offset = bazaoffset + (numPage-1)*cntRowTabl;

    //                // перерисовываем таблицу
    //                timer_text.restart();

    //                break;
    //            }
    //            case Qt.Key_Up:
    //            {
    //                numPage = numPage - 1;
    //                if (numPage<1) {numPage=cntPage};
    //                console.log("стрелка вверх/перевели фокус на внутр QML/ numPage==" + numPage);

    //                text1.text= qsTr(namePage+ ": окно " + numPage + "[" + cntPage + "]");

    //                offset = bazaoffset + (numPage-1)*cntRowTabl;

    //                // перерисовываем таблицу
    //                timer_text.restart();

    //                break;
    //            }
    //        }
    //    }

}

