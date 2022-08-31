import QtQuick 2.7

Rectangle {
    id: extbeads
    property int cntitems: 10
    property var colors: []
    property var value: 0
    property real maxvalue: 1500
    property bool start: true
    color: "#000000"

    ListModel {
        id: extBeadsModel
        Component.onCompleted: {
            //var colors = ["lightgreen", "green", "orange", "red", "yellow", "brown", "lightblue", "blue", "lightsteelblue", "steelblue"];
            var i;
            for (i = 0; i < extbeads.cntitems  ; i++)
                extBeadsModel.append({"ebcolor": extbeads.colors[i], "ebvisible": false, "ebtextvisible": false});
        }
    }

    Column {
        id: pbcolumn
        x: 0
        y: 0
        height: parent.height
        width: parent.width


        ListView {
            x: 0
            y: 0
            height: parent.height
            width: parent.width
            model: extBeadsModel

            delegate: ExtBeadItem {
                itemvisible: ebvisible
                itemcolor: ebcolor
                textvisible: ebtextvisible
                textvalue: value //ebtextvalue
                pbheight: extbeads.height / extbeads.cntitems
            }


        }
    }

    onValueChanged: {
        var step = maxvalue / cntitems;
        var result, text;
        if (!start) {
            for (var i = 0, tmp = 0; i < cntitems; i++) {
                if (value > step * i) {
                    result = true;
                    if (value >= step * (i + 1))
                        if (i < cntitems - 1)
                            text = false;
                        else
                            text = true;
                    else
                        text = true;
                }
                else {
                    result = false;
                    text = false;
                }
                extBeadsModel.setProperty(cntitems - i - 1, "ebvisible", result);
                extBeadsModel.setProperty(cntitems - i - 1, "ebtextvisible", text);
            }
        } else
            start = false;
    }

}
