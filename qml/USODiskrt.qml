import QtQuick 2.0

// строка таблицы для вывода дискретного сигнала
Rectangle {
    id: rectangle1
   // width: 256
    height: 14//15
    color: "#00000000"
    border.color: "#00000000"
    property string edit1value: "разъем" // qsTr("разъем")
    property string edit2value: "№"
    property string edit3value: "обозн"
    property string edit4value: "наименование"
    property string edit5value: "0"

    TInd {// значение
        id: edit5
        x: 232
        y: 0
        width: 23
        height: parent.height + 1 //parent.height
        value: edit5value
        gradient: Gradient {
            GradientStop {position: 0.1;  color: "gray"}
            GradientStop {position:0.9;  color: "black"}
            GradientStop {position:1;  color: "gray"}
        }
        txtSize: 10//12
        border.width: 1
        border.color: "#808080"
    }

    Rectangle {// разъем
        id: rectangle2
        x: 0
        y: 0
        width: 46
        height: 15
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#363232"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
        border.color: "#808080"
        border.width: 1

        Text {
            id: text1
            x: 0
            y: 0
            width: 46
            color: "#ffffff"
            text:  edit1value
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 10//12
        }
    }

    Rectangle {// номер
        id: rectangle3
        x: 45
        y: 0
        width: 36//33
        height: 15
        Text {
            id: text2
            x: 0
            y: 0
            width: 33
            color: "#ffffff"
            text: edit2value
            font.pixelSize: 10
            horizontalAlignment: Text.AlignHCenter
        }
        border.width: 1
        border.color: "#808080"
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#363232"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
    }

    Rectangle { //обозначение
        id: rectangle4
        x: 80
        y: 0
        width: 38//36
        height: 15
        Text {
            id: text3
            x: 0
            y: 0
            width: 38 //36
            color: "#ffffff"
            text: edit3value
            font.pixelSize: 10
            horizontalAlignment: Text.AlignHCenter
        }
        border.width: 1
        border.color: "#808080"
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#363232"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
    }

    Rectangle {
        id: rectangle5
        x: 116
        y: 0
        width: 118 //115
        height: 15
        Text {
            id: text4
            x: 4
            y: 0
            width: 112
            color: "#ffffff"
            text: edit4value
            font.pixelSize: 10
            horizontalAlignment: Text.AlignLeft
        }
        border.width: 1
        border.color: "#808080"
//        gradient: Gradient {
//            GradientStop {position: 0.1;  color: "#ffffff"}
//            GradientStop {position:0.9;  color: "black"}
//            GradientStop {position:1;  color: "gray"}
//        }
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#363232"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }

    }

}
