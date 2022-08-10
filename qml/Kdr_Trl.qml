import QtQuick 2.0

Rectangle {
    width: 512
    height: 197
    color: "#070606"

    Text {
        id: text1
        x: 14
        y: 8
        color: "#f3d0d0"
        text: qsTr("сообщения за текущий сеанс:")
        font.bold: true
        font.pixelSize: 12
    }

    TInd {
        id: ind_i
        x: 213
        y: 5
        txtSize: 12
    }
}

