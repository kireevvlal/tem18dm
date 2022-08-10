import QtQuick 2.0
// элемент (строка) таблицы для аналог сигнала
Rectangle {
    id: rectangle1
    width: 510
    height: 15
    color: "#00000000"
    border.color: "#00000000"
    property string edit1value: "0"
    property string edit2value: "0"
    property string edit3value: "0"
    property string edit4value: "0"
    property string edit5value: "0"
    property string edit6value: "0"


    TInd { //значение
        id: edit6
        x: 449
        y: 0
        width: 59
        height: parent.height
        txtColor: "#ffffff"
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
        value: edit6value
        border.width: 2
        txtSize: 12
        border.color: "#808080"
    }

    Rectangle {// edit1value
        id: rectangle2
        x: 0
        y: 0
        width: 70
        height: 15
        Text {
            id: text1
            x: 0
            y: 0
            width: 70
            height: 15
            color: "#ffffff"
            text: edit1value
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }
        border.width: 2
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
        id: rectangle3
        x: 70
        y: 0
        width: 69
        height: 15
        Text {
            id: text2
            x: 0
            y: 0
            width: 69
            height: 15
            color: "#ffffff"
            text: edit2value
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }
        border.width: 2
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
        id: rectangle4
        x: 139
        y: 0
        width: 52
        height: 15
        Text {
            id: text3
            x: 0
            y: 0
            width: 52
            height: 15
            color: "#ffffff"
            text: edit3value
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }
        border.width: 2
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
        x: 191
        y: 0
        width: 179
        height: 15
        Text {
            id: text4
            x: 5
            y: 0
            width: 240
            height: 15
            color: "#ffffff"
            text: edit4value
            font.pixelSize: 12
            horizontalAlignment: Text.AlignLeft
        }
        border.width: 2
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
        id: rectangle6
        x: 369
        y: 0
        width: 80
        height: 15
        Text {
            id: text5
            x: 0
            y: 0
            width: 80
            height: 15
            color: "#ffffff"
            text: edit5value
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }
        border.width: 2
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

}
