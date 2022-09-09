import QtQuick 2.7
// УСО Экран отображения дискр сигналов
Rectangle {
 //   width: 512
//    height: 197
    color: "#000000"

    property int cntRowTabl: 12;  // количество строк 12 но нумерация с нуля
    property int bazaoffset: 72;  // начальный индекс из массива надписей
    property int offset: 72;      // текущий индекс из массива надписей
    property string namePage: qsTr("УСТА: дискретные входы"); // название экрана

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
                   {"Dscrt_r1":"", "Dscrt_n1":"", "Dscrt_o1":"", "Dscrt_i1":"","Dscrt_val1":"0", "Dscrt_a1":"",
                "Dscrt_r2":"", "Dscrt_n2":"", "Dscrt_o2":"", "Dscrt_i2":"","Dscrt_val2":"0", "Dscrt_a2":""});
            }
        }
    }
    // вывод на экран
    // левый столбик
    Column {
        id: usoLeftDin
        x: 1
        y: 18//23
 //       width: 256
        height: 168//167
        
        ListView {
            id: viewLeftDin
            x: 0
            width: 254
            height: parent.height // 167
            highlightRangeMode: ListView.NoHighlightRange
            model: usoModelDiskr
            header: Rectangle {  // верхний декор
                width: parent.width
                height: 14 // 16
                gradient:Gradient{
                    GradientStop{position: 0; color: "gray"}
                    GradientStop{position: 0.9; color: "blue"}
                    GradientStop{position: 1; color: "gray"}

                }
                Text{
                    color: "white";
                    font.pixelSize: 12
                    text: " Разъем   №   Обозн.   Наименование";
                }
            }

            delegate: USODiskrt {
                x:0
                y:18//20
                radius: 0
                border.width: 1
                edit1value: Dscrt_r1;
                edit2value: Dscrt_n1;
                edit3value: Dscrt_o1;
                edit4value: Dscrt_i1;
                edit5value: Dscrt_val1;
            }
        }
    }
    // правый столбик
    Column {
        id: usoRightDin
        x: 255
        y: 18//23
//        width: 256
        height: 168// 167

        ListView {
            id: viewRightDin
            x: 0
            width: 256
            height: parent.height //167
            highlightRangeMode: ListView.NoHighlightRange
            model: usoModelDiskr
            header: Rectangle {// верхний декор
                x: 0 //10
                width: parent.width
                height: 14//20
                gradient:Gradient{
                    GradientStop{position: 0; color: "gray"}
                    GradientStop{position: 0.9; color: "blue"}
                    GradientStop{position: 1; color: "gray"}
                }
                Text{
                    color: "white";
                    font.pixelSize: 12
                    text: " Разъем   №   Обозн.   Наименование";
                }
            }

            delegate: USODiskrt {
                x:0//2//10 //0
                y:18//20
                radius: 0
                border.width: 1
                edit1value: Dscrt_r2;
                edit2value: Dscrt_n2;
                edit3value: Dscrt_o2;
                edit4value: Dscrt_i2;
                edit5value: Dscrt_val2;

            }
        }
    }

//    function usoTxtDiskr1(j,str_r, str_n, str_o, str_i) {
//        // значения нужно вытащить из структуры
//        // присвоение свойствам значений
//        usoModelDiskr.setProperty(j, "Dscrt_r1", str_r);
//        usoModelDiskr.setProperty(j, "Dscrt_n1", str_n);
//        usoModelDiskr.setProperty(j, "Dscrt_o1", str_o);
//        usoModelDiskr.setProperty(j, "Dscrt_i1", str_i);
//    }

//    function usoTxtDiskr2(j,str_r, str_n, str_o, str_i) {
//        // значения нужно вытащить из структуры
//        // присвоение свойствам значений
//        usoModelDiskr.setProperty(j, "Dscrt_r2", str_r);
//        usoModelDiskr.setProperty(j, "Dscrt_n2", str_n);
//        usoModelDiskr.setProperty(j, "Dscrt_o2", str_o);
//        usoModelDiskr.setProperty(j, "Dscrt_i2", str_i);
//    }

    function usoTxtDiskr(bank, j, strarr) {
        // значения нужно вытащить из структуры
        // присвоение свойствам значений
        if (bank) {
            usoModelDiskr.setProperty(j, "Dscrt_r2", strarr[0]);
            usoModelDiskr.setProperty(j, "Dscrt_n2", strarr[1]);
            usoModelDiskr.setProperty(j, "Dscrt_o2", strarr[2]);
            usoModelDiskr.setProperty(j, "Dscrt_i2", strarr[3]);
        } else {
            usoModelDiskr.setProperty(j, "Dscrt_r1", strarr[0]);
            usoModelDiskr.setProperty(j, "Dscrt_n1", strarr[1]);
            usoModelDiskr.setProperty(j, "Dscrt_o1", strarr[2]);
            usoModelDiskr.setProperty(j, "Dscrt_i1", strarr[3]);
        }
    }

    Timer { // надписи
        id: timer_text
        triggeredOnStart: false // true - запускается сразу и по repet(т.е.срабатывает два раза)
        repeat:false            // и еще разок вывели и успокоились
        interval: 100
        running: true
        onTriggered: {
            var i;
            var strarr;
            //столбики
            for (i = 0; i < cntRowTabl; i++) {
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
            var values = ioBf.getDiskretArray(offset);
             for (i = 0;i < cntRowTabl; i++) {
                // значения сигналов
                 // !!!!! дописать  ioBf
                 usoModelDiskr.setProperty(i, "Dscrt_val1", values[i].toString()); //(offset +i ).toString());            // лево
                 usoModelDiskr.setProperty(i, "Dscrt_val2", values[i + cntRowTabl].toString()); //(offset + i + cntRowTabl).toString());// право
            }
        }
    }

}

