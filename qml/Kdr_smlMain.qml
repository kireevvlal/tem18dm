import QtQuick 2.0

Rectangle {
    width: 512
    height: 197
    color: "black"
    z: 2147483646

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Main_small.opacity
        onTriggered: {
            var par = ioBf.getParamKdrSmlMain();
            indIg.value = Math.round(par[0]) / 1000;
            indIg.finish = par[4] / 1000;

            indUg.value = Math.round(par[1]);
            indUg.finish = par[5];

            stb_Tvd.value = par[2];
            stb_Tvd.barColor = (par[2] < 10) ? "red" : (par[2] < 45) ? "yellow" : (par[2] < 87) ? "#00d7d7" : "red";

            stb_Tms.value = par[3];
            stb_Tms.barColor = (par[3] < 20) ? "red" : (par[3] < 45) ? "yellow" : (par[3] < 70) ? "#00d7d7" : "red";

//            indT_vd.text =  ioBf.getParamDiap(150);
//            stb_Tvd.value = indT_vd.text;

//            indT_ms.text = ioBf.getParamDiap(50);
//            stb_Tms.value = indT_ms.text;

        }

    }

    Text {
        id: text3
        x: 198
        y: 133
        width: 8
        height: 17
        color: "#fbfdff"
        text: qsTr("1")
        font.bold: true
        font.pixelSize: 20
    }

    Text {
        id: text4
        x: 198
        y: 162
        color: "#fbfcff"
        text: qsTr("2")
        font.bold: true
        font.pixelSize: 20
    }

    ExtCircularGauge {
        id: indIg
        x: 8
        y: 7
        width: 190
        height: 190
        maximumValue: 3
        minimumValue: 0
        parameter: "Iг кА"
        start: 0
        finish: 0
        valuePrecision: 2
    }

    ExtCircularGauge {
        id: indUg
        x: 211
        y: 7
        width: 190
        height: 190
        maximumValue: 1200
        minimumValue: 0
        parameter: "Uг В"
        start: 0
        finish: 0
    }

//     PrBar {
//        id: stb_Tvd
//        x: 444
//        y: 35
//        width: 23
//        height: 160
//        radius: 0
//        color2: "#4682b4"
//        value: 150
//        val_max: 150
//        z: 8
//        kind: 0
//    }


//    PrBar {
//         id: stb_Tms
//         x: 478
//         y: 35
//         width: 23
//         height: 160
//         radius: 0
//         color2: "#4682b4"
//         value: 150
//         val_max: 150
//         z: 9
//         kind: 0
//     }
    ExtGauge {
        id: stb_Tvd
        x: 406
        y: 0
        height: 200
        parameter: "В"
        name: "Т, С"
//        warningValue: 80
//        errorValue: 90
        barColor: "red"
        maxValue: 150
        barWidth: 30
        visibleMinorTickmarks: false
    }

    ExtGauge {
        id: stb_Tms
        x: 444
        y: 0
        height: 200
        visibleLabels: false
        parameter: "М"
//        warningValue: 95
//        errorValue: 110
        maxValue: 150
        barWidth: 30
        visibleMinorTickmarks: false
    }

//    Text {
//        id: text5
//        x: 416
//        y: 6
//        width: 58
//        height: 14
//        color: "#d3d3d3"
//        text: qsTr("T, C     в          м")
//        font.pixelSize: 12
//        font.bold: true
//    }

//    Text {
//        id: indT_vd
//        x: 442
//        y: 20
//        width: 23
//        height: 14
//        color: "#d2e8fb"
//        text: qsTr("0")
//        horizontalAlignment: Text.AlignHCenter
//        font.pixelSize: 12
//        font.bold: true
//    }

//    Text {
//        id: indT_ms
//        x: 478
//        y: 20
//        width: 23
//        height: 14
//        color: "#d2e8fb"
//        text: qsTr("0")
//        horizontalAlignment: Text.AlignHCenter
//        font.pixelSize: 12
//        font.bold: true
//    }

//    Rectangle {
//        id: shkala
//        x: 414
//        y: 35
//        width: 97
//        height: 160
//        color: "#000000"
//        z: 5
//        opacity: 1

//        Text {
//            id: text13
//            x: 1
//            y: 140
//            width: 80
//            height: 20
//            color: "#808080"
//            text: qsTr("0___________")
//            verticalAlignment: Text.AlignBottom
//            font.pixelSize: 14
//            font.bold: false
//        }

//        Text {
//            id: text15
//            x: 0
//            y: 33
//            width: 80
//            height: 20
//            color: "#808080"
//            text: qsTr("100________")
//            verticalAlignment: Text.AlignBottom
//            font.pixelSize: 14
//            font.bold: false
//            z: 3
//        }

//        Text {
//            id: text14
//            x: 0
//            y: 84
//            width: 80
//            height: 23
//            color: "#808080"
//            text: qsTr("50__________")
//            verticalAlignment: Text.AlignBottom
//            font.pixelSize: 14
//            font.bold: false
//            z: 2
//        }
//    }

//    Gauge_Big {
//        id: indIg
//        x: 0
//        y: 0
//        width: 189
//        height: 197
//        gaugeName: "I * 10"
//        max: 300
//    }


}

