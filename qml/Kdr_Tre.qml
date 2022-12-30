import QtQuick 2.0

Rectangle {
    id: kdr_tre
    width: 800
    height: 80
    color: "red"
    property string str1: "МПСУ"
    property string str2: "сообщение"
//    property int section: 0
//    property int index: 0
    Text {
        id: text1
        x: 64
        y: 8
        color: "yellow"
        text: qsTr(str1)
        font.underline: true
        font.bold: true
        font.pixelSize: 20
    }

    Text {
        id: text2
        x: 64
        y: 44
        color: "white"
        text: qsTr(str2)
        font.pixelSize: 16
    }

   // NumberAnimation on opacity { from:0; to: 1;duration: 3000;loops: Animation.Infinite}
    Keys.onPressed: {
        // console.log("код нажатой клавиши ===>" + event.key);
        switch(event.key){

        case Qt.Key_0:
        case Qt.Key_1:
        case Qt.Key_2:
        case Qt.Key_3:
        case Qt.Key_4:
        case Qt.Key_5:
        case Qt.Key_6:
        case Qt.Key_7:
        case Qt.Key_8:
        case Qt.Key_9:
        {
            ioBf.kvitTrBanner();
            break;
        }
        }
    }
}

