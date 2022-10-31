import QtQuick 2.0

Rectangle {
    width: 512
    height: 197
    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Svz.opacity
        onTriggered: {
            var params = ioBf.getParamKdrSvz();

            ind_Ubs.value = Math.round(params[0] * 10) / 10;
            led_c1.visible = params[1] & 16; // АСК
            led_c2.visible = params[1] & 1; // БЭЛ
            led_c4.visible = params[1] & 4; // ТИ
            led_c5.visible = params[1] & 2; // УСТА
            led_c6.visible = params[1] & 8; // МСС
            led_ASK.visible = params[2] & 16;
            led_BSO.visible = params[2] & 32;
            led_Tii.visible = params[2] & 4;
            led_UST.visible = params[2] & 2;
            led_BEL.visible = params[2] & 1;
            led_MSS.visible = params[2] & 8;
            oSKZ.value = params[3];
            oASK.value = params[4];
            oBSO.value = params[5];
            oTii.value = params[6];
            oUST.value = params[7];
            oBEL.value = params[8];
        }
    }

    Image {
        id: image1
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrSvz_lin.png"

    }

    TInd {
        id: ind_Ubs
        x: 303
        y: 49
        width: 37
        height: 13
    }

    TInd {
        id: oSKZ
        value: "00"
        x: 304
        y: 75
        width: 19
        height: 14
        txtSize: 12
    }

    TInd {
        id: oASK
        x: 167
        y: 181
        width: 19
        height: 14
        txtSize: 12
        value: "00"
    }

    TInd {
        id: oBSO
        x: 229
        y: 181
        width: 19
        height: 14
        txtSize: 12
        value: "00"
    }

    TInd {
        id: oTii
        x: 295
        y: 180
        width: 19
        height: 16
        txtSize: 12
        value: "00"
    }

    TInd {
        id: oUST
        x: 357
        y: 179
        width: 19
        height: 16
        txtSize: 12
        value: "00"
    }

    TInd {
        id: oBEL
        x: 422
        y: 179
        width: 19
        height: 16
        txtSize: 12
        value: "00"
    }

    Text {
        id: text1
        x: 5
        y: 2
        color: "#f9f8f8"
        text: "СВЯЗИ"
        font.bold: true
        font.pixelSize: 12
    }

    LedIndicator {
        id: led_c6
        x: 409
        y: 76
        width: 11
        height: 11
    }

    LedIndicator {
        id: led_c1
        x: 457
        y: 110
        width: 11
        height: 11
    }

    LedIndicator {
        id: led_c4
        x: 409
        y: 87
        width: 11
        height: 11
    }

    LedIndicator {
        id: led_c5
        x: 409
        y: 99
        width: 11
        height: 11
    }

    LedIndicator {
        id: led_c2
        x: 409
        y: 111
        width: 11
        height: 11
    }

    LedIndicator {
        id: led_ASK
        x: 152
        y: 181
        width: 14
        height: 14
        val: 1
    }

    LedIndicator {
        id: led_BSO
        x: 215
        y: 181
        width: 14
        height: 14
        val: 1
    }

    LedIndicator {
        id: led_Tii
        x: 280
        y: 181
        width: 14
        height: 14
        val: 1
    }

    LedIndicator {
        id: led_UST
        x: 343
        y: 180
        width: 14
        height: 14
        val: 1
    }

    LedIndicator {
        id: led_BEL
        x: 407
        y: 180
        width: 14
        height: 14
        val: 1
    }

    LedIndicator {
        id: led_MSS
        x: 290
        y: 75
        width: 14
        height: 14
        val: 1
    }
}

