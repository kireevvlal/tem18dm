import QtQuick 2.0
// Экран НАСТРОЙКИ , ввод - НЕ СДЕЛАН вообще!!!
Rectangle {
    width: 512
    height: 197
    color: "#000000"
    property int active: 0
    property int pos: 0
    property string number: "0001"
    property bool elinj: true
    property int psensors: 16
    property int svolume: 100
    Timer {
        triggeredOnStart: true

        interval: 500
//        repeat: true
        running: kdr_Nastroika.opacity

        onTriggered: {
            var par = ioBf.getKdrNastroyka()
            number = par[0]
            elinj = par[1]
            psensors = par[2]
            svolume = par[3]
        }

    }


    Image {
        id: image1
        x: 0
        sourceSize.height: 157
        sourceSize.width: 512
        z: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        source: "../Shem_TEM18DM/kdrNst.png"

    }

    Text {
        id: text12
        x: 0
        y: 0
        color: "#f9f8f8"
        text: qsTr("НАСТРОЙКИ")
        textFormat: Text.AutoText
        styleColor: "#8877e4"
        font.bold: true
        font.pixelSize: 14
    }

    Text {
        id: txt1
        x: 10
        y: 30
        color: (active == 0) ? "yellow" : "silver"
        text: qsTr("Номер тепловоза")
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
    }

    Text {
        id: txt_number
        x: 200
        y: 30
        color: "cyan"
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        text: number
    }
    Text {
        id: txt_undrln
        x: (!pos) ? 200 : ((pos == 1) ? 209 : ((pos == 2) ? 218 : 227))
        y: 30
        color: "cyan"
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        text: active ? "" : "_"
    }

    Text {
        id: txt2
        x: 10
        y: 60
        color: (active == 1) ? "yellow" : "silver"
        text: qsTr("Электронный впрыск")
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
    }

    Text {
        id:txt_elinj
        x: 200
        y: 60
        color: "cyan"
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        text: elinj ? qsTr("ЕСТЬ") : qsTr("НЕТ")
    }

    Text {
        id: txt3
        x: 10
        y: 90
        color: (active == 2) ? "yellow" : "silver"
        text: qsTr("Датчики давления")
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
    }

    Text {
        id: txt_psensors
        x: 200
        y: 90
        color: "cyan"
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        text: psensors
    }

    Text {
        id: txt4
        x: 10
        y: 120
        color: (active == 3) ? "yellow" : "silver"
        text: qsTr("Громкость звука, %")
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
    }

    Text {
        id: txt_svolume
        x: 200
        y: 120
        color: "cyan"
        textFormat: Text.AutoText
        font.bold: true
        font.pixelSize: 14
        text: svolume
    }
}

