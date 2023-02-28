import QtQuick 2.7

// переключение между экранами
Rectangle {
    id: rct
    width: 640
    height: 64
    color: "transparent" // прозрачный цвет фона
    opacity: 1
    border.width: 0

    property int vz1: 1 ; // тревога 1 0-невидимый/1-видимый
    property int vz2: 1; // тревога 2
    property int vz3: 0; // тревога 3
    property int vz4: 0; // тревога 4
    property int vz5: 0; // тревога 5
    property int vz6: 0; // тревога 6
    property int vz7: 0; // тревога 7
    property int vz8: 0; // тревога 8
    property int vz9: 0; // тревога 9

    property int tr1: 0; // тревога 1 / 0 - зеленый / 1-красный
    property int tr2: 0; // тревога 2
    property int tr3: 0; // тревога 3
    property int tr4: 0; // тревога 4
    property int tr5: 0; // тревога 5
    property int tr6: 0; // тревога 6
    property int tr7: 0; // тревога 7
    property int tr8: 0; // тревога 8
    property int tr9: 0; // тревога 9


    Rectangle {
        id: rt1
        x: 0
        y: 0
        width: 64
        height: 64
        color: rct.color
        z: 2


    LedIndicator {
        id: led_Tr1
        x: 45
        y: 45
        width: 17
        height: 17
        z: 1
        opacity: main_window.is_links
        val : tr1
    }
    }

    Rectangle {
        id: rt2
        x: 64
        y: 0
        width: 64
        height: 64
        color: rct.color
        opacity: 1
        z: 4

        LedIndicator {
            id: led_Tr2
            x: 45
            y: 45
            width: 17
            height: 17
            z: 2
            opacity: main_window.is_slave
            val : tr2
        }
    }

    Rectangle {
        id: rt3
        x: 128
        y: 0
        width: 64
        height: 64
        color: rct.color
        LedIndicator {
            id: led_Tr3
            x: 45
            y: 45
            width: 17
            height: 17
            colorBord: "#ffffff"
            z: 2
            opacity: vz3
            val : tr3

        }
        z: 4
    }

    Rectangle {
        id: rt4
        x: 192
        y: 0
        width: 64
        height: 64
        color: rct.color
        LedIndicator {
            id: led_Tr4
            x: 45
            y: 45
            width: 17
            height: 17
            z: 2
            opacity: vz4
            val : tr4
        }
        z: 4
    }

    Rectangle {
        id: rt5
        x: 256
        y: 0
        width: 64
        height: 64
        color: rct.color
        LedIndicator {
            id: led_Tr5
            x: 45
            y: 45
            width: 17
            height: 17
            colorBord: "#ffffff"
            z: 2
            opacity: vz5
            val : tr5
        }
        z: 4
    }

    Rectangle {
        id: rt6
        x: 320
        y: 0
        width: 64
        height: 64
        color: rct.color
        LedIndicator {
            id: led_Tr6
            x: 45
            y: 45
            width: 17
            height: 17
            colorBord: "#ffffff"
            z: 2
            opacity: vz6
            val : tr6
        }
        z: 4
    }

    Rectangle {
        id: rt7
        x: 384
        y: 0
        width: 64
        height: 64
        color: rct.color
        LedIndicator {
            id: led_Tr7
            x: 45
            y: 45
            width: 17
            height: 17
            colorBord: "#ffffff"
            z: 2
            opacity: vz7
            val : tr7
        }
        z: 4
    }

    Rectangle {
        id: rt8
        x: 448
        y: 0
        width: 64
        height: 64
        color: rct.color
        LedIndicator {
            id: led_Tr8
            x: 45
            y: 45
            width: 17
            height: 17
            colorBord: "#ffffff"
            z: 2
            opacity: vz8
            val : tr8

        }
        z: 4
    }

    Rectangle {
        id: rt9
        x: 512
        y: 0
        width: 64
        height: 64
        color: rct.color
        LedIndicator {
            id: led_Tr9
            x: 45
            y: 45
            width: 17
            height: 17
            colorBord: "#ffffff"
            z: 2
            opacity: vz9
            val : tr9

        }
        z: 4
    }


}
