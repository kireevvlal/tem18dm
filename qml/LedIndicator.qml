import QtQuick 2.0

Rectangle {
    id: indic

    property int val: 0 // состояние индикатора 0-выкл/1-включен

    property color clrIndic_0: "green"   // заливка
    property color clrIndic_1: "red"     // заливка
    property color colorBord: "#ffffff"  // рамка


    height: 35
    width: 35
    color: "#00000000"

    Rectangle {
        id: rectangle1
        color: if (val==0) { clrIndic_0 } else {clrIndic_1}
        radius: 22
        border.color: colorBord
        anchors.fill: parent
        border.width: 1
        smooth: true

        Rectangle {
            id: rectangle2
            width: 7
            height: 7
            color: "#ffffff"
            radius: 99
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 24
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 21
        }
    }




}


