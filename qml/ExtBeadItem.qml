import QtQuick 2.0

Rectangle {
    property color itemcolor: "red"
    property bool itemvisible: false
    property int textvisible: 0
    property string textvalue: "0"
    property int pbheight: 10

    id: pbitem
    x:0
    y:0
    width: parent.width
    height: pbheight
    border.color: "#000000"
    border.width: 1
    color: itemcolor //itemvisible ? itemcolor : "#000000"
    visible: itemvisible
    Text {
        width: parent.width
        text: textvalue
        font.pixelSize: 10
        font.bold: true
        color: "blue"
        horizontalAlignment: Text.AlignHCenter
        visible: textvisible
    }

}

