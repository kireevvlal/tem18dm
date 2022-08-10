import QtQuick 2.0
// Компонент режим тепловоза
Rectangle {
    id: regm
    property int value : 1 // входной параметр - значение
    width: 80
    height: 30
    color: "black"
    border.width: 0
    onValueChanged: { // событие на изменение значения

//        if not(dab[0,bRjV]in[1..3])then Visible:=false           //
//        else        case dab[0,bRjV] of                          //
//        1:begin Caption:='тормоз';Font.Color:=clYellow ;end;     //
//        2:begin Caption:='ТЯГА'  ;Font.Color:=clYellow ;end;     //
//        3:begin Caption:='х.ход' ;Font.Color:=clGray   ;end; end;//
//                                     Visible:=true     ;end; End;//

        if  ((value==0) || (value>3))
        { txt.opacity = 0 }
        else {
            if (value == 1) { txt.color = "yellow"; txt.text = "тормоз";}
            if (value == 2) { txt.color = "yellow"; txt.text = "ТЯГА";}
            if (value == 3) { txt.color = "gray";   txt.text = "х.ход";}
            txt.opacity = 1;
            }
    }

    Text {
        id: txt
        color: "#ffffff"
        text: "тормоз"
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 20
}

}

