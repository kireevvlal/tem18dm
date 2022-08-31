import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

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

//ProgressBar {
//    property color itemcolor: "red"
//    property real itemvalue: 0.5
//    property int pbheight: 10

//    id: pbitem
//    x:0
//    y:0
//    width: parent.width
//    height: pbheight
//    value: itemvalue
//    orientation: Qt.Vertical

//    //property real pbvalue: 0.5
//    style: ProgressBarStyle {
//        background: Rectangle {
//            radius: 0
//            color: "#000000"
//            border.color: "gray"
//            border.width: 1
//            implicitWidth: parent.parent.width
//            implicitHeight: pbheight //parent.parent.height / 10
//        }
//        progress: Rectangle {
//            color: itemvalue > 0 ? itemcolor : "#000000"
//            border.color: "gray"
//        }
//    }
//}
