import QtQuick 2.0
import "scripts.js" as Scripts

Rectangle {
//    id: kdr_tre
    width: 800
    height: 80
    color: "red"
    property string str1: "МПСУ"
    property string str2: "сообщение"
    Text {
        id: text1
        x: 64
        y: 8
        color: "yellow"
        text: qsTr(str1)
        font.underline: true
        font.bold: true
        font.pixelSize: 20
        font.family: main_window.deffntfam
    }

    Text {
        id: text2
        x: 64
        y: 40
        color: "white"
        text: qsTr(str2)
        font.pixelSize: 16
        font.family: main_window.deffntfam
    }

   // NumberAnimation on opacity { from:0; to: 1;duration: 3000;loops: Animation.Infinite}
    Keys.onPressed: {
        // console.log("код нажатой клавиши ===>" + event.key);
        var key = Scripts.getKey(event.key)
//        Scripts.processKeys(key)

        switch(key) {

        case "0":
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
        case "7":
        case "8":
        case "9":
        {
            ioBf.kvitTrBanner();
            break;
        }
        }
    }
}
