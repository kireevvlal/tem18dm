import QtQuick 2.7

Rectangle {
    width: 512
    height: 197
    color: "#070606"
    property int first: -1
    property int count: 0

    Text {
        id: text1
        x: 2
        y: 4
        color: "#f3d0d0"
        text: qsTr("всего сообщений:")
        font.bold: true
        font.pixelSize: 12
        font.family: main_window.deffntfam
    }

    TInd {
        id: ind_count
        x: 120
        y: 1
        txtSize: 12
        width: 40
        value: count
    }

    Text {
        x: 164
        y: 4
        color: "#f3d0d0"
        text: qsTr("(")
        font.bold: true
        font.pixelSize: 12
        font.family: main_window.deffntfam
    }

    TInd {
        id: ind_first
        x: 168
        y: 1
        txtSize: 12
        width: 40
        value: first + 1
    }

    Text {
        x: 208
        y: 4
        color: "#f3d0d0"
        text: qsTr(")")
        font.bold: true
        font.pixelSize: 12
        font.family: main_window.deffntfam
    }

    ListModel {
        id: tr_mess_list_model
    }


    ListView {
        y: 20
        x: 2
        width: parent.width - 10
        height: parent.height - 20
        model: tr_mess_list_model
        delegate:  Text {
            text: message
            color: "silver"
            font.pixelSize: 10
            font.family: main_window.deffntfam
        }
    }

    Timer {
        id: tr_mess_list_timer
        triggeredOnStart: true
        repeat: true
        interval: 500
        running: kdr_TrLs.opacity
        onTriggered: {
            var par = ioBf.getKdrTrL();
            tr_mess_list_model.clear();
            count = par.length;
            if (first < 0) {
                first = count - 16;
                if (first < 0)
                    first = 0;
            }
            for (var i = first; i < first + 16 && i < count; i++) {
                tr_mess_list_model.append({ message: qsTr(par[i]) });
            }
//            ind_i.value = par.length
        }
    }
}


