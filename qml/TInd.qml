import QtQuick 2.0

Rectangle {
    id: ind0
    property variant value: "0"
    width: 82
    height: 22
    color: "black"
    border.width: 0
    property int txtSize: 16
    property color txtColor: "cyan"


    Text {
        id: text1
        text: value
        width: parent.width-1
        height: parent.height-1
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: txtSize
        color: txtColor
    }
}

