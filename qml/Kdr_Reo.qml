import QtQuick 2.0

Rectangle {
    width: 512
    height: 197
    color: "#000000"

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Reostat.opacity
        onTriggered: {
            var par = ioBf.getParamKdrReo();
            ind_T1.value = par[0]; //ioBf.getParam();
            ind_T2.value = par[1]; //ioBf.getParam();
            ind_T3.value = par[2]; //ioBf.getParam();
            ind_T4.value = par[3]; //ioBf.getParam();
            ind_T5.value = par[4]; //ioBf.getParam();
            ind_T6.value = par[5]; //ioBf.getParam();
            ind_Ttk1.value = par[6]; //ioBf.getParam();
            ind_Ttk2.value = par[7]; //ioBf.getParam();

            ind_Fu.value = par[8].toFixed(0); //ioBf.getParam();
            ind_Mg.value = par[9].toFixed(0); //ioBf.getParam();
            ind_Mz.value = par[10].toFixed(0); //ioBf.getParam();
            ind_Ug.value = par[11].toFixed(0); //ioBf.getParam();
            ind_Uz.value = par[12].toFixed(0); //ioBf.getParam();
            ind_Ig.value = par[13].toFixed(0); //ioBf.getParam();
            ind_I1.value = par[14].toFixed(0); //ioBf.getParam();
            ind_I2.value = par[15].toFixed(0); //ioBf.getParam();
            ind_Iv.value = par[16].toFixed(0); //ioBf.getParam();
            ind_Iz.value = par[17].toFixed(0); //ioBf.getParam();
            ind_Ubs.value = par[18].toFixed(0); //ioBf.getParam();

            ind_Lz.value = par[19].toFixed(0); //ioBf.getParam();
            ind_Lv.value = par[20].toFixed(0); //ioBf.getParam();
            ind_Pm.value = par[21].toFixed(2); //ioBf.getParam();
            ind_Pt.value = par[22].toFixed(2); //ioBf.getParam();
            ind_Tv.value = par[23].toFixed(2); //ioBf.getParam();
            ind_Tm.value = par[24].toFixed(2); //ioBf.getParam();

            ind_O1.value = par[25]; //ioBf.getParam();
            ind_O2.value = par[26]; //ioBf.getParam();

                    }

    }
    Text {
        id: text1
        x: 7
        y: 8
        color: "#f9f8f8"
        text: qsTr("РЕОСТАТ")
        font.bold: true
        font.pixelSize: 16
        font.family: main_window.deffntfam
    }

    TInd {
        id: ind_T1
        x: 3
        y: 98
        width: 28
        height: 20
        txtSize: 10
    }

    Text {
        id: text2
        x: 7
        y: 49
        color: "#d3d3d3"
        text: qsTr("t газов цилиндров, С")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text3
        x: 18
        y: 80
        color: "#d3d3d3"
        text: qsTr("1")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text4
        x: 48
        y: 80
        color: "#d3d3d3"
        text: qsTr("2")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text5
        x: 79
        y: 80
        color: "#d3d3d3"
        text: qsTr("3")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text6
        x: 111
        y: 80
        color: "#d3d3d3"
        text: qsTr("4")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text7
        x: 138
        y: 80
        width: 10
        height: 17
        color: "#d3d3d3"
        text: qsTr("5")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text9
        x: 7
        y: 145
        color: "#d3d3d3"
        text: qsTr("вход в ТК1")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text10
        x: 7
        y: 164
        color: "#d3d3d3"
        text: qsTr("вход в ТК2")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    TInd {
        id: ind_Iz
        x: 285
        y: 175
        width: 40
        height: 13
        txtSize: 10
    }

    TInd {
        id: ind_Iv
        x: 285
        y: 160
        width: 40
        height: 13
        txtSize: 10
    }

    TInd {
        id: ind_I2
        x: 285
        y: 145
        width: 40
        height: 13
        txtSize: 10
    }

    TInd {
        id: ind_I1
        x: 285
        y: 130
        width: 40
        height: 13
        txtSize: 10
    }

    TInd {
        id: ind_Ig
        x: 285
        y: 115
        width: 40
        height: 13
        txtSize: 10
    }

    TInd {
        id: ind_Ubs
        x: 285
        y: 85
        width: 40
        height: 13
        txtSize: 10
    }

    TInd {
        id: ind_Uz
        x: 285
        y: 70
        width: 40
        height: 13
        txtSize: 10
        txtColor: "#ffffff"
    }

    TInd {
        id: ind_Ug
        x: 285
        y: 55
        width: 40
        height: 13
        txtSize: 10
    }

    TInd {
        id: ind_Mz
        x: 285
        y: 24
        width: 40
        height: 13
        txtSize: 10
        txtColor: "#ffffff"
    }

    TInd {
        id: ind_T2
        x: 33
        y: 98
        width: 28
        height: 20
        txtSize: 10
    }

    Text {
        id: text8
        x: 170
        y: 80
        color: "#d3d3d3"
        text: qsTr("6")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    TInd {
        id: ind_T3
        x: 64
        y: 98
        width: 28
        height: 20
        txtSize: 10
    }

    TInd {
        id: ind_T4
        x: 94
        y: 98
        width: 28
        height: 20
        txtSize: 10
    }

    TInd {
        id: ind_T5
        x: 124
        y: 98
        width: 28
        height: 20
        txtSize: 10
    }

    TInd {
        id: ind_T6
        x: 155
        y: 98
        width: 28
        height: 20
        txtSize: 10
    }

    TInd {
        id: ind_Ttk1
        x: 90
        y: 143
        width: 28
        height: 20
        txtSize: 10
    }

    TInd {
        id: ind_Ttk2
        x: 90
        y: 163
        width: 28
        height: 20
        txtSize: 10
    }

    TInd {
        id: ind_Mg
        x: 285
        y: 7
        width: 40
        height: 13
        txtSize: 10
    }

    Text {
        id: text11
        x: 227
        y: 7
        color: "#d3d3d3"
        text: qsTr("тг:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text12
        x: 227
        y: 27
        color: "#d3d3d3"
        text: qsTr("задание:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text13
        x: 227
        y: 58
        color: "#d3d3d3"
        text: qsTr("тг:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text14
        x: 227
        y: 71
        color: "#d3d3d3"
        text: qsTr("задание:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text15
        x: 227
        y: 85
        color: "#d3d3d3"
        text: qsTr("борт.сети:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text16
        x: 227
        y: 118
        color: "#d3d3d3"
        text: qsTr("тг:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text17
        x: 227
        y: 131
        color: "#d3d3d3"
        text: qsTr("тележка 1:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text18
        x: 227
        y: 146
        color: "#d3d3d3"
        text: qsTr("тележка 2:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text19
        x: 227
        y: 160
        color: "#d3d3d3"
        text: qsTr("возбужд:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text20
        x: 227
        y: 175
        color: "#d3d3d3"
        text: qsTr("заряда:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text21
        x: 200
        y: 11
        color: "#d3d3d3"
        text: qsTr("M")
        font.bold: true
        font.pixelSize: 25
        font.family: main_window.deffntfam
    }

    Text {
        id: text22
        x: 200
        y: 66
        color: "#d3d3d3"
        text: qsTr("U")
        font.bold: true
        font.pixelSize: 25
        font.family: main_window.deffntfam
    }

    Text {
        id: text23
        x: 204
        y: 130
        color: "#d3d3d3"
        text: qsTr("I")
        font.bold: true
        font.pixelSize: 25
        font.family: main_window.deffntfam
    }

    Text {
        id: text24
        x: 328
        y: 13
        width: 26
        height: 18
        color: "#d3d3d3"
        text: qsTr("кВт")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text25
        x: 328
        y: 58
        width: 26
        height: 18
        color: "#d3d3d3"
        text: qsTr("В")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text26
        x: 329
        y: 119
        width: 26
        height: 18
        color: "#d3d3d3"
        text: qsTr("А")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    TInd {
        id: ind_O2
        x: 444
        y: 181
        width: 40
        height: 13
        txtSize: 10
        txtColor: "#ffffff"
    }

    TInd {
        id: ind_O1
        x: 444
        y: 166
        width: 40
        height: 13
        txtSize: 10
        txtColor: "#ffffff"
    }

    TInd {
        id: ind_Lv
        x: 444
        y: 146
        width: 40
        height: 13
        txtSize: 10
        txtColor: "#ffffff"
    }

    TInd {
        id: ind_Lz
        x: 444
        y: 131
        width: 40
        height: 13
        txtSize: 10
        txtColor: "#ffffff"
    }

    TInd {
        id: ind_Fu
        x: 444
        y: 106
        width: 40
        height: 8
        txtSize: 10
    }

    TInd {
        id: ind_Tm
        x: 444
        y: 71
        width: 40
        height: 13
        txtSize: 10
    }

    TInd {
        id: ind_Tv
        x: 444
        y: 55
        width: 40
        height: 13
        txtSize: 10
    }

    TInd {
        id: ind_Pt
        x: 444
        y: 24
        width: 40
        height: 13
        txtSize: 10
    }

    TInd {
        id: ind_Pm
        x: 444
        y: 7
        width: 40
        height: 13
        txtSize: 10
    }

    Text {
        id: text27
        x: 399
        y: 7
        color: "#d3d3d3"
        text: qsTr("масла:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text28
        x: 399
        y: 27
        color: "#d3d3d3"
        text: qsTr("топлива:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text29
        x: 399
        y: 58
        color: "#d3d3d3"
        text: qsTr("воды:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text30
        x: 398
        y: 74
        color: "#d3d3d3"
        text: qsTr("масла:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text32
        x: 386
        y: 133
        color: "#d3d3d3"
        text: qsTr("Угол возб:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text33
        x: 386
        y: 148
        color: "#d3d3d3"
        text: qsTr("выпр:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text34
        x: 386
        y: 167
        color: "#d3d3d3"
        text: qsTr("ОП1:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text35
        x: 386
        y: 182
        color: "#d3d3d3"
        text: qsTr("ОП2:")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text36
        x: 376
        y: 12
        color: "#d3d3d3"
        text: qsTr("P")
        font.bold: true
        font.pixelSize: 25
    }

    Text {
        id: text37
        x: 380
        y: 61
        color: "#d3d3d3"
        text: qsTr("t")
        font.bold: true
        font.pixelSize: 25
        font.family: main_window.deffntfam
    }

    Text {
        id: text38
        x: 380
        y: 100
        color: "#d3d3d3"
        text: qsTr("F")
        font.bold: true
        font.pixelSize: 25
        font.family: main_window.deffntfam
    }

    Text {
        id: text39
        x: 487
        y: 13
        width: 26
        height: 18
        color: "#d3d3d3"
        text: qsTr("МПа")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text40
        x: 487
        y: 58
        width: 26
        height: 18
        color: "#d3d3d3"
        text: qsTr("С")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text41
        x: 487
        y: 100
        width: 26
        height: 18
        color: "#d3d3d3"
        text: qsTr("о/м")
        font.bold: true
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }
}

