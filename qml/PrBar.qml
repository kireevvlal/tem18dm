import QtQuick 2.0

Rectangle {
    width: 100
    height: 100
    color: "#aca6a6"                  // фон
    radius: 1
    border.color: "#404040"
    border.width: 0
    property  int value: 800
    property int val_max: 800
    property int kind: 0              // расположение 1-gorizont / 0-vertik
    property color color1: "#ffffff"  // цвет заливки
    property color color2: "#16f2cd"  // цвет заливки
    property bool txtvzbl : false     // значение не выводить

    Rectangle {
        id: grdnt
        x: 0
        y: if (kind==0) { (parent.height - (parent.height*value/val_max)) } else {0}
        width:  if (kind==0) { parent.width } else {((parent.width*value/val_max))}
        height: if (kind==0) { (parent.height*value/val_max) } else {parent.height}
        radius: 3
        border.width: 0
        gradient: Gradient {
            GradientStop {
                position: 0
                color: color1
            }

            GradientStop {
                position: 1
                color: color2
            }
        }
    }

    Text {
        id: txt
        x: 0
        y: if (kind==0) {grdnt.y} else { 0 }
        width: parent.width
        height: 15
        text: value // значение, а не проценты
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
        font.family: main_window.deffntfam
        opacity: if (txtvzbl) { 1 } else { 0 } // видимость
    }
}

