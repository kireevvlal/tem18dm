import QtQuick 2.0
// Компонент позиция контроллера машиниста
Rectangle {
    id: pkm
    property int pkms : 1 // входной параметр - значение
    width: 80
    height: 30
    color: "black"
    border.width: 0
    onPkmsChanged: { // событие на изменение значения

        if  ((pkms == 0) || ( pkms > 9))
        { txt.opacity = 0 }    // Visible:=false
        else {
             if (pkms == 1)
             { txt.color = "gray"}
             else txt.color = "white";

             txt.text = pkms - 1;
             txt.opacity = 1;

            }
    }

    Text {
        id: txt
        color: "#b18e8e"
        text: "0"
        font.bold: true
        font.family: main_window.deffntfam
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 30
}

}

