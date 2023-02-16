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

            indIg.digitalvalue = Math.round(par[1]);
            indIg.value = indIg.digitalvalue / 1000;
            if (indIg.digitalvalue < 0)
                indIg.digitalvalue = 0;
            var finish = par[5] / 1000;
            if (indIg.finish != finish) {
                indIg.finish = finish;
                indIg.repaint = true;
            }


            indUg.value = indUg.digitalvalue = Math.round(par[2]);
            if (indUg.digitalvalue < 0)
                indUg.digitalvalue = 0;
            finish = par[6];
            if (indUg.finish != finish) {
                indUg.finish = finish;
                indUg.repaint = true;
            }
            stb_Tvd.value = stb_Tvd.digitalvalue =  par[3];
            stb_Tvd.barColor = (par[3] < 10) ? "red" : (par[3] < 45) ? "yellow" : (par[3] < 87) ? "#00d7d7" : "red";

            stb_Tms.value = stb_Tms.digitalvalue = par[4];
            stb_Tms.barColor = (par[4] < 20) ? "red" : (par[4] < 45) ? "yellow" : (par[4] < 70) ? "#00d7d7" : "red";

            vh1.visible = (par[7] & 1) && par[0][0]; // ??? добавил наличие связи в условии
            vh2.visible = (par[7] & 2) && par[0][0]; // ??? добавил наличие связи в условии

            indIg.visible =  indUg.visible = par[0][0]; // usta connection
            stb_Tvd.visible = stb_Tms.visible = par[0][1]; // ti connection

        }

    }

    Text {
        id: vh1
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
        id: vh2
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
        labelTextSize: 13
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
        labelTextSize: 13
    }

    ExtGauge {
        id: stb_Tvd
        x: 406
        y: 0
        height: 200
        parameter: "В"
        name: "Т, С"
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
        maxValue: 150
        barWidth: 30
        visibleMinorTickmarks: false
    }

}

