import QtQuick 2.7
// УСО Экран отображения дискр сигналов
Rectangle {
    width: 512
    height: 197
    color: "#000000"

    property int cntRowTabl: 12;  // количество строк 12 но нумерация с нуля
    property int bazaoffset: 72;  // начальный индекс из массива надписей
    property int offset: 72;      // текущий индекс из массива надписей
    property string namePage: qsTr("параметры УСТА: дискретные входы"); // название экрана

    // переменные для передачи надписей из массива констант из файла zapuso.h
    property string str_r: "s_r";   // разьем
    property string str_n: "s_n";   // номер выхода
    property string str_o: "s_o";   // обозначение
    property string str_i: "s_i";   // имя


// заголовок
    Text {
        id: text1
        x: 0
        y: 0
        color: "#d2e8fb"
        text: namePage
        font.bold: true
        font.pixelSize: 14
    }
    //************************************
    // подготовка данных
    ListModel {
        id:usoModelDiskr
        Component.onCompleted: {
            var i;
            for (i = 0;i < cntRowTabl; i++)
            {   // создание динамическго списка с полями:
               usoModelDiskr.append(
                   {"Anlg_r1":"", "Anlg_n1":"", "Anlg_o1":"", "Anlg_i1":"","Anlg_val1":"0", "Anlg_a1":"",
                "Anlg_r2":"", "Anlg_n2":"", "Anlg_o2":"", "Anlg_i2":"","Anlg_val2":"0", "Anlg_a2":""});
            }
        }
    }
    // вывод на экран
    // левый столбик
    Column {
        id: usoLeftDin
        x: 1
        y: 23
        width: 256
        height: 167
        
        ListView {
            id: viewLeftDin
            x: 0
            width: 256
            height: 167
            highlightRangeMode: ListView.NoHighlightRange
            model: usoModelDiskr
            header: Rectangle {  // верхний декор
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
                    text: "  Разъем     №   Обозн.    Наименование";
                }
            }

            delegate: USODiskrt {
                x:0
                y:20
                radius: 0
                border.width: 1
                edit1value: Anlg_r1;
                edit2value: Anlg_n1;
                edit3value: Anlg_o1;
                edit4value: Anlg_i1;
                edit5value: Anlg_val1;
            }
        }
    }
    // правый столбик
    Column {
        id: usoRightDin
        x: 256
        y: 23
        width: 256
        height: 167

        ListView {
            id: viewRightDin
            x: 0
            width: 256
            height: 167
            highlightRangeMode: ListView.NoHighlightRange
            model: usoModelDiskr
            header: Rectangle {// верхний декор
                x: 2 //10
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
                    text: "  Разъем     №   Обозн.    Наименование";
                }
            }

            delegate: USODiskrt {
                x:2//10 //0
                y:20
                radius: 0
                border.width: 1
                edit1value: Anlg_r2;
                edit2value: Anlg_n2;
                edit3value: Anlg_o2;
                edit4value: Anlg_i2;
                edit5value: Anlg_val2;

            }
        }
    }

//    function usoTxtDiskr1(j,str_r, str_n, str_o, str_i) {
//        // значения нужно вытащить из структуры
//        // присвоение свойствам значений
//        usoModelDiskr.setProperty(j, "Anlg_r1", str_r);
//        usoModelDiskr.setProperty(j, "Anlg_n1", str_n);
//        usoModelDiskr.setProperty(j, "Anlg_o1", str_o);
//        usoModelDiskr.setProperty(j, "Anlg_i1", str_i);
//    }

//    function usoTxtDiskr2(j,str_r, str_n, str_o, str_i) {
//        // значения нужно вытащить из структуры
//        // присвоение свойствам значений
//        usoModelDiskr.setProperty(j, "Anlg_r2", str_r);
//        usoModelDiskr.setProperty(j, "Anlg_n2", str_n);
//        usoModelDiskr.setProperty(j, "Anlg_o2", str_o);
//        usoModelDiskr.setProperty(j, "Anlg_i2", str_i);
//    }

    function usoTxtDiskr(bank, j, strarr) {
        // значения нужно вытащить из структуры
        // присвоение свойствам значений
        if (bank) {
            usoModelDiskr.setProperty(j, "Anlg_r2", strarr[0]);
            usoModelDiskr.setProperty(j, "Anlg_n2", strarr[1]);
            usoModelDiskr.setProperty(j, "Anlg_o2", strarr[2]);
            usoModelDiskr.setProperty(j, "Anlg_i2", strarr[3]);
        } else {
            usoModelDiskr.setProperty(j, "Anlg_r1", strarr[0]);
            usoModelDiskr.setProperty(j, "Anlg_n1", strarr[1]);
            usoModelDiskr.setProperty(j, "Anlg_o1", strarr[2]);
            usoModelDiskr.setProperty(j, "Anlg_i1", strarr[3]);
        }
    }

    Timer { // надписи
        id: timer_text
        triggeredOnStart: false // true - запускается сразу и по repet(т.е.срабатывает два раза)
        repeat:false            // и еще разок вывели и успокоились
        interval: 500
        running: true
        onTriggered: {
            var i;
            var strarr;
            //столбики
            for (i=0;i<cntRowTabl;i++) {
                strarr = ioBf.getStructDiskr(i + offset);
                usoTxtDiskr(0, i, strarr);
                strarr = ioBf.getStructDiskr(i + offset + cntRowTabl);
                usoTxtDiskr(1, i, strarr);
//                str_r = ioBf.getStructDiskr_r(i+offset);
//                str_n = ioBf.getStructDiskr_n(i+offset);
//                str_o = ioBf.getStructDiskr_o(i+offset);
//                str_i = ioBf.getStructDiskr_i(i+offset);
//                usoTxtDiskr1(i, str_r, str_n, str_o, str_i);

//                str_r = ioBf.getStructDiskr_r(i +offset+ cntRowTabl);
//                str_n = ioBf.getStructDiskr_n(i +offset + cntRowTabl);
//                str_o = ioBf.getStructDiskr_o(i +offset + cntRowTabl);
//                str_i = ioBf.getStructDiskr_i(i +offset + cntRowTabl);
//                usoTxtDiskr2(i, str_r, str_n, str_o, str_i);
            }
            // console.log(offset);
        }
    }

    //

    Timer { // значение
        id: timer_value
        triggeredOnStart: true
        repeat:true
        interval: 500
        running: true // включается по usoview.opacity
        property int j:0;
        onTriggered: {
             var i;
             for (i = 0;i < cntRowTabl; i++) {
                // значения сигналов
                 // !!!!! дописать  ioBf
                 usoModelDiskr.setProperty(i, "Anlg_val1", (offset +i ).toString());            // лево
                 usoModelDiskr.setProperty(i, "Anlg_val2", (offset + i + cntRowTabl).toString());// право
            }
        }
    }
}

