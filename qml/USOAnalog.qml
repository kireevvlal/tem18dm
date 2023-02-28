import QtQuick 2.0
// элемент (строка) таблицы для аналог сигнала
Rectangle {
    id: rectangle1
    //width: 508
    height: parent.height
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
        x: 380 //449
        y: 0
        z: 99
        width: 80 //55
        height: parent.height
        //txtColor: "#ffffff"
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
        value: edit5value
        border.width: 1
        txtSize: 12
        border.color: "#808080"
    }

    Rectangle {// edit1value
        id: rectangle2
        x: 0
        y: 0
        width: 68
        height: parent.height //15
        Text {
            id: text1
            x: 2
            y: 0
            width: parent.width - 2
            height: 15
            color: "#ffffff"
            text: edit1value
            font.pixelSize: 12
            font.family: main_window.deffntfam
            horizontalAlignment: Text.AlignLeft
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
        id: rectangle3
        x: 67
        y: 0
        width: 69
        height: parent.height //15
        Text {
            id: text2
            x: 0
            y: 0
            width: parent.width
            height: 15
            color: "#ffffff"
            text: edit2value
            font.pixelSize: 12
            font.family: main_window.deffntfam
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
        id: rectangle4
        x: 135
        y: 0
        width: 50
        height: parent.height //15
        Text {
            id: text3
            x: 0
            y: 0
            width: parent.width
            height: 15
            color: "#ffffff"
            text: edit3value
            font.pixelSize: 12
            font.family: main_window.deffntfam
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
        x: 184
        y: 0
        width: 197
        height: 15
        Text {
            id: text4
            x: 5
            y: 0
            width: parent.width
            height: parent.height //15
            color: "#ffffff"
            text: edit4value
            font.pixelSize: 12
            font.family: main_window.deffntfam
            horizontalAlignment: Text.AlignLeft
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
        id: rectangle6
        x: 459 //369
        y: 0
        width: 50 //80
        height: 15
        Text {
            id: text5
            x: 0
            y: 0
            width: parent.width // 80
            height: parent.height //15
            color: "#ffffff"
            text: edit6value
            font.pixelSize: 12
            font.family: main_window.deffntfam
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

}
