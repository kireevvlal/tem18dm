import QtQuick 2.0

Item {

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: true
        onTriggered: {
            var par = ioBf.getParamFrameTop();
            revers.value = par[0][0]; //ioBf.getReversor();// реверсор
            pkm.pkms = par[0][1]; //ioBf.getPKM();         // позиция
            regim.value = par[0][2]; //ioBf.getRegim();    // режим работы тепловоза
            txt_time.text = par[1][0];
            txt_data.text = par[1][1];
            txt_RejPro.text = par[2][0]; // прожиг
            txt_RejAP.text = par[2][1]; // автопрогрев
            txt_RejPrTime.text = par[3][0]; //ioBf.getRejPrT("value");// --- косяк с разными значениями --че делать то?
            txt_RejPrTime.color = (par[3][1] == "2") ?  "yellow" : "gray";
            txt_RejPrT.opacity = (par[3][2] == "1") ? 1 : 0;
            prBar1.value = par[4]; //ioBf.getParamDiap(100);// заглушка
        }

    }

    TRevers {
        id: revers
        x: 24
        y: 46
    }

    TPKM {
        id: pkm
        x: 24
        y: 15
        width: 64
        color: "#000000"
        pkms: 5
    }

    TRegm {
        id: regim
        x: 16
        y: 88
        height: 25
        value: 1
    }

    Text {
        id: txt_RejPrTime
        x: 16
        y: 118
        width: 80
        color: "#6e6e63"
        text: qsTr("00:00:00")
        font.family: "Segoe UI Black"
        clip: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pointSize: 12
        visible: true
    }

    Image {
        id: img_ind_f
        x: 16
        y: 138
        width: 22
        height: 40
        clip: false
        source: "../Pictogram/flesh1.png"
        visible: true
    }

    Image {
        id: img_z0
        x: 39
        y: 147
        width: 35
        height: 19
        clip: true
        source: "../Pictogram/flesh zapis1.png"
        visible: true

    }

    PrBar {
        id: prBar1
        x: 75
        y: 148
        width: 61
        height: 14
        clip: true
        kind: 1
        val_max: 100
        value: 0
        visible: true
    }

    Text {
        id: text2
        x: 157
        y: 6
        color: "#d2e8fb"
        text: qsTr("ТЭМ18ДМ  №___")
        font.bold: true
        font.pointSize: 13
    }

    Text {
        id: txt_time
        x: 528
        y: 8
        color: "#d2e8fb"
        text: qsTr("время")
        horizontalAlignment: Text.AlignRight
        font.pointSize: 13
        font.bold: true
    }

    Text {
        id: txt_data
        x:  528
        y: 25
        color: "#d2e8fb"
        text: qsTr("дата")
        font.family: "Segoe UI Emoji"
        font.pointSize: 13
        font.bold: true
    }

    ExtCircularGauge {
        id: indPt
        x: 128
        y: 74
        width: 150
        height: 150
        maximumValue: 1.2
        minimumValue: 0
        parameter: "Рт МПа"
        start: 0.9
        finish: 1.2
        valuePrecision: 2
        labelPrecision: 1
    }

    ExtCircularGauge {
        id: indPm
        x: 292
        y: 74
        width: 150
        height: 150
        maximumValue: 1.2
        minimumValue: 0
        parameter: "Рм МПа"
        start: 0.9
        finish: 1.2
        valuePrecision: 2
        labelPrecision: 1
    }
    ExtCircularGauge {
        id: indFd
        x: 458
        y: 54
        width: 170
        height: 170
        maximumValue: 900
        minimumValue: 0
        parameter: "F об/мин"
        start: 600
        finish: 750
    }

    Text {
        id: txt_RejPrT
        x: 128
        y: 27
        color: "#f0f026"
        text: qsTr("Длительный х.ход! Установи 8 ПКМ на 10 минут")
        font.pointSize: 10
        font.bold: true
    }

    Text {
        id: txt_RejAP
        x: 128
        y: 43
        color: "#f0f026"
        text: qsTr("Режим автопрогрева")
        font.family: "Segoe UI Historic"
        font.pointSize: 10
        font.bold: true
    }

    Text {
        id: txt_RejPro
        x: 128
        y: 59
        color: "#f0f026"
        text: qsTr("Прожиг коллектора")
        font.pointSize: 10
        font.bold: true
        style: Text.Outline
    }
}
