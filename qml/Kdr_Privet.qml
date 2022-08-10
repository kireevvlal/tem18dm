import QtQuick 2.0

Rectangle {
    id: rectangle1
    width: 640
    height: 480
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#198a26"
        }

        GradientStop {
            position: 1
            color: "#0415a9"
        }
    }
    visible: true


    Text {
        id: text1
        x: 66
        color: "#ffffff"
        text: qsTr("АО \"ВНИКТИ\" ")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 0
        font.bold: true
        font.pixelSize: 24
    }


    Text {
        id: text2
        x: 71
        y: 66
        color: "#f9f8f8"
        text: qsTr("ТЭМ18ДМ")
        scale: 2.41
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: -57
        anchors.verticalCenter: parent.verticalCenter

        font.bold: true
        font.pixelSize: 29
    }


   // Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
   NumberAnimation on opacity { from:1; to: 0; duration: 6000;/*loops: Animation.Infinite*/ }

    Text {
        id: text5
        x: 9
        y: 212
        width: 279
        height: 20
        color: "#fdfdfd"
        text: "v. 29.07.2022"
        anchors.horizontalCenterOffset: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: 195
        anchors.verticalCenter: text2.verticalCenter
        font.bold: true
        font.pixelSize: 16
        wrapMode: Text.WordWrap
    }

    Text {
        id: text3
        x: 9
        y: 133
        width: 279
        height: 41
        color: "#fbfbfb"
        text: qsTr("140402, М.о., г.Коломна, ул.Октябрьской революции, 410")
        transformOrigin: Item.Center
        anchors.horizontalCenterOffset: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: 144
        anchors.verticalCenter: text2.verticalCenter
        wrapMode: Text.WordWrap
        font.bold: true
        font.pixelSize: 16
    }
    Text {
        id: text4
        x: 9
        y: 186
        width: 279
        height: 20
        color: "#fbfbfb"
        text: qsTr("тел.: (496) 618-82-26")
        anchors.horizontalCenterOffset: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: 174
        anchors.verticalCenter: text2.verticalCenter
        font.bold: true
        font.pixelSize: 16
        wrapMode: Text.WordWrap
    }

    Text {
        id: text6
        x: 64
        y: 65
        color: "#0a47b0"
        text: qsTr("ТЭМ18ДМ")
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        scale: 2.41
        anchors.verticalCenterOffset: -57
        anchors.horizontalCenterOffset: 0
        font.pixelSize: 28
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}

