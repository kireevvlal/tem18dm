import QtQuick 2.7

Rectangle {
    width: 512
    height: 197
    color: "black"
    property int ledsize: 12

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: kdr_Develop.opacity
        onTriggered: {
            var par = ioBf.getKdrDevelop();
            li_BEL_open.val = !par[0][0]
            li_USTA_open.val = !par[0][1]
            li_TI_open.val = !par[0][2]
            li_MSS_open.val = !par[0][3]

            li_BEL_conn.val = !par[1][0]
            li_USTA_conn.val = !par[1][1]
            li_TI_conn.val = !par[1][2]
            li_MSS_conn.val = !par[1][3]

            bad_vars_list_model.clear()
            for (var i = 0; i < par[2].length && i < 12; i++) {
                bad_vars_list_model.append({ variable: qsTr(par[2][i]) });
            }

            qual_BEL.text = par[3][0];
            qual_USTA.text = par[3][1];
            qual_TI.text = par[3][2];
            qual_MSS.text = par[3][3];

            errors_BEL.text = par[4][0];
            errors_USTA.text = par[4][1];
            errors_TI.text = par[4][2];
            errors_MSS.text = par[4][3];

            li_BEL_isbytes.val = !par[5][0]
            li_USTA_isbytes.val = !par[5][1]
            li_TI_isbytes.val = !par[5][2]
            li_MSS_isbytes.val = !par[5][3]
        }
    }

    ListModel {
        id: bad_vars_list_model
    }


    ListView {
        y: 22
        x: 280
//        width: parent.width - 10
        height: parent.height
        model: bad_vars_list_model
        delegate:  Text {
            text: variable
            color: "silver"
            font.pixelSize: 10
            font.family: main_window.deffntfam
        }
    }

    Text {
        id: txt_BEL
        x: 70
        y: 0
        text: qsTr("БЭЛ")
        font.pixelSize: 12
        font.family: main_window.deffntfam
        color: "#ffffff"
    }

    Text {
        id: txt_USTA
        x: 120
        y: 0
        text: qsTr("УСТА")
        font.pixelSize: 12
        font.family: main_window.deffntfam
        color: "#ffffff"
    }


    Text {
        id: txt_TI
        x: 170
        y: 0
        text: qsTr("ТИ")
        font.pixelSize: 12
        font.family: main_window.deffntfam
        color: "#ffffff"
    }

    Text {
        id: txt_MSS
        x: 220
        y: 0
        text: qsTr("МСС")
        font.pixelSize: 12
        font.family: main_window.deffntfam
        color: "#ffffff"
    }

    Text {
        id: text1
        x: 14
        y: 20
        color: "#ffffff"
        text: qsTr("Open")
        font.family: main_window.deffntfam
        font.pixelSize: 12
    }

    LedIndicator {
        id: li_BEL_open
        x: 70
        y: 20
        width: ledsize
        height: ledsize
    }

    LedIndicator {
        id: li_USTA_open
        x: 120
        y: 20
        width: ledsize
        height: ledsize
    }

    LedIndicator {
        id: li_TI_open
        x: 170
        y: 20
        width: ledsize
        height: ledsize
    }

    LedIndicator {
        id: li_MSS_open
        x: 220
        y: 20
        width: ledsize
        height: ledsize
    }

    Text {
        id: text2
        x: 14
        y: 40
        color: "#ffffff"
        text: qsTr("Conn")
        font.family: main_window.deffntfam
        font.pixelSize: 12
    }

    LedIndicator {
        id: li_BEL_conn
        x: 70
        y: 40
        width: ledsize
        height: ledsize
    }

    LedIndicator {
        id: li_USTA_conn
        x: 120
        y: 40
        width: ledsize
        height: ledsize
    }

    LedIndicator {
        id: li_TI_conn
        x: 170
        y: 40
        width: ledsize
        height: ledsize
    }

    LedIndicator {
        id: li_MSS_conn
        x: 220
        y: 40
        width: ledsize
        height: ledsize
    }

    Text {
        id: text4
        x: 15
        y: 80
        color: "#ffffff"
        text: qsTr("Quality")
        font.family: main_window.deffntfam
        font.pixelSize: 12
    }

    Text {
        id: qual_BEL
        x: 70
        y: 80
        width: 48
        height: 22
        color: "#ffffff"
        font.pixelSize: 10
        font.family: main_window.deffntfam
        text: "0"
    }

    Text {
        id: qual_USTA
        x: 120
        y: 80
        width: 48
        height: 22
        color: "#ffffff"
        font.pixelSize: 10
        font.family: main_window.deffntfam
        text: "0"
    }

    Text {
        id: qual_TI
        x: 170
        y: 80
        width: 48
        height: 22
        color: "#ffffff"
        font.pixelSize: 10
        font.family: main_window.deffntfam
        text: "0"
    }

    Text {
        id: qual_MSS
        x: 220
        y: 80
        width: 48
        height: 22
        color: "#ffffff"
        font.pixelSize: 10
        font.family: main_window.deffntfam
        text: "0"
    }

    Text {
        id: text5
        x: 15
        y: 100
        color: "#ffffff"
        text: qsTr("Errors")
        font.family: main_window.deffntfam
        font.pixelSize: 12
    }

    Text {
        id: errors_BEL
        x: 70
        y: 100
        width: 48
        height: 22
        color: "#ffffff"
        text: "0"
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: errors_USTA
        x: 120
        y: 100
        width: 48
        height: 22
        color: "#ffffff"
        text: "0"
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: errors_TI
        x: 170
        y: 100
        width: 48
        height: 22
        color: "#ffffff"
        text: "0"
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: errors_MSS
        x: 220
        y: 100
        width: 48
        height: 22
        color: "#ffffff"
        text: "0"
        font.pixelSize: 10
        font.family: main_window.deffntfam
    }

    Text {
        id: text6
        x: 14
        y: 60
        color: "#ffffff"
        text: qsTr("IsBytes")
        font.pixelSize: 12
        font.family: main_window.deffntfam
    }

    LedIndicator {
        id: li_BEL_isbytes
        x: 70
        y: 60
        width: ledsize
        height: ledsize
    }

    LedIndicator {
        id: li_USTA_isbytes
        x: 120
        y: 60
        width: ledsize
        height: ledsize
    }

    LedIndicator {
        id: li_TI_isbytes
        x: 170
        y: 60
        width: ledsize
        height: ledsize
    }

    LedIndicator {
        id: li_MSS_isbytes
        x: 220
        y: 60
        width: ledsize
        height: ledsize
    }

}

