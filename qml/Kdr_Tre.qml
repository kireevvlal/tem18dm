import QtQuick 2.0

Rectangle {
    width: 800
    height: 80
    color: "red"

    Text {
        id: text1
        x: 64
        y: 8
        color: "yellow"
        text: qsTr("МПСУ")
        font.underline: true
        font.bold: true
        font.pixelSize: 20
    }

    Text {
        id: text2
        x: 64
        y: 47
        color: "white"
        text: qsTr("сообщение")
        font.pixelSize: 16
    }

   // NumberAnimation on opacity { from:0; to: 1;duration: 3000;loops: Animation.Infinite}

}

