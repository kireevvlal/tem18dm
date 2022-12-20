import QtQuick 2.0

Item {

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: true
        onTriggered: {
            var par = ioBf.getParamFrameLeft();

            pr_Mtg1.value = par[1].toFixed(0); //ioBf.getParamDiap(1500);// заглушка
            pr_Mtg2.value = par[2].toFixed(0);// ioBf.getParamDiap(1500); // заглушка

            indUb0.text = par[3].toFixed(0); //ioBf.getParamDiap(100);// заглушка
            indUb1.text = par[4].toFixed(0); //ioBf.getParamDiap(100);// заглушка

            indIz0.text = par[5].toFixed(0); //ioBf.getParamDiap(60);// заглушка
            indIz1.text = par[6].toFixed(0); //ioBf.getParamDiap(60);// заглушка

            in1OM1.visible = par[7][0] && par[0][0];
            in1OM2.visible = par[7][1] && par[0][0];
            in1BX.visible = par[7][2] && par[0][0];
            in1DR.visible = par[7][3] && par[0][0];
            in1RZ.visible = par[7][4] && par[0][0];
            in1OT.visible = par[7][5] && par[0][0];

            in2OM1.visible = par[8][0] && par[0][1];
            in2OM2.visible = par[8][1] && par[0][1];
            in2BX.visible = par[8][2] && par[0][1];
            in2DR.visible = par[8][3] && par[0][1];
            in2RZ.visible = par[8][4] && par[0][1];
            in2OT.visible = par[8][5] && par[0][1];

            indUb0.visible = indIz0.visible = pr_Mtg1.visible = par[0][0];
            indUb1.visible = indIz1.visible = pr_Mtg2.visible = par[0][1];
            txtUb.visible = txtV.visible = txtIz.visible = txtA.visible = par[0][0] || par[0][1];
        }
    }

    Text {
        id: txtUb
        x: 8
        y: 0
        width: 23
        height: 17
        color: "#acb3b3"
        text: qsTr("Uб:")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: indUb0
        x: 40
        y: 0
        width: 23
        height: 17
        color: "#d2e8fb"
        text: qsTr("0")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: txtV
        x: 78
        y: 0
        width: 23
        height: 17
        color: "#acb3b3"
        text: qsTr("В")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: indUb1
        x: 104
        y: 0
        width: 23
        height: 17
        color: "#d2e8fb"
        text: qsTr("0")
        font.family: "Segoe UI Black"
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
    }



    Text {
        id: txtIz
        x: 8
        y: 16
        width: 23
        height: 18
        color: "#acb3b3"
        text: qsTr("Iз:")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: indIz0
        x: 40
        y: 16
        width: 23
        height: 17
        color: "#d2e8fb"
        text: qsTr("0")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: txtA
        x: 78
        y: 16
        width: 23
        height: 18
        color: "#acb3b3"
        text: qsTr("А")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: indIz1
        x: 104
        y: 16
        width: 23
        height: 17
        color: "#d2e8fb"
        text: qsTr("0")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
    }


    ExtBeads {
        id: pr_Mtg1
        x: 38
        y: 35
        height: 195
        width: 28
        cntitems: 15
        colors: ["#f01f00", "#f02f00", "#f03f00", "#f04f00", "#f05f00", "#f06f00", "#f07f00", "#f08f00", "#f09f99", "#f0afaa", "#f0bfbb", "#f0cfcc", "#f0dfdd", "#f0efee", "#f0ffff"]
        value: 0
        maxvalue: 1500
    }

    ExtBeads {
        id: pr_Mtg2
        x: 102
        y: 35
        height: 195
        width: 28
        cntitems: 15
        colors: ["#f01f00", "#f02f00", "#f03f00", "#f04f00", "#f05f00", "#f06f00", "#f07f00", "#f08f00", "#f09f99", "#f0afaa", "#f0bfbb", "#f0cfcc", "#f0dfdd", "#f0efee", "#f0ffff"]
        value: 1500
        maxvalue: 1500
    }

    TInd {
        id: in1OM1
        x: 5
        y: 35
        width: 30
        height: 30
        radius: 2
        gradient: Gradient {
            GradientStop {position: 0;color: "#aca6a6"}
            GradientStop {position: 0.5; color: "#e4d6d6"}
            GradientStop {position: 1;color: "#aca6a6"}
        }
        txtSize: 16
        txtColor: "#000000"
        value: "ОМ"
        border.width: 0
        border.color: "#e4d6d6"
    }

    TInd {
        id: in1OM2
        x: 5
        y: 68
        width: 30
        height: 30
        radius: 2
        gradient: Gradient {
            GradientStop {position: 0;color: "#aca6a6"}
            GradientStop {position: 0.5; color: "#e4d6d6"}
            GradientStop {position: 1;color: "#aca6a6"}
        }
        txtSize: 16
        txtColor: "#000000"
        value: "ОМ"
        border.width: 0
        border.color: "#e4d6d6"
    }

    Image {
        id: in1BX
        x: 5
        y: 101
        width: 30
        height: 30
        source: "../Pictogram/ind_box.png"
    }

  TInd {
      id: in1DR
      x: 5
      y: 134
      width: 30
      height: 30
      color: "#160000"
      radius: 2
        txtSize: 15
        txtColor: "red"
        border.width: 2
        border.color: "red"
        value: "ДРУ"
        gradient: Gradient{
            GradientStop {position:0.0; color: "silver"}
            GradientStop {position:0.3; color: "black"}
            GradientStop {position:0.7; color: "black"}
            GradientStop {position:1; color: "silver"}
        }
    }


    TInd {
        id: in1RZ
        x: 5
        y: 167
        width: 30
        height: 30
        radius: 2
        txtSize: 18
        txtColor: "yellow"
        value: "РЗ"
        border.width: 2
        border.color: "yellow"
        gradient: Gradient{
            GradientStop {position:0.0; color: "silver"}
            GradientStop {position:0.3; color: "black"}
            GradientStop {position:0.7; color: "black"}
            GradientStop {position:1; color: "silver"}
        }

    }

    TInd {
        id: in1OT
        x: 5
        y: 200
        width: 30
        height: 30
        radius: 2
        gradient: Gradient {
            GradientStop { position: 0; color: "#ffff00"}
            GradientStop {position: 0.5;color: "#ffffff"}
            GradientStop {position: 1;color: "#ffff00"}
        }
        txtSize: 15
        txtColor: "#000000"
        value: "ОТМ"
        border.width: 0
        border.color: "#ffff00"
    }



    TInd {
        id: in2OM1
        x: 69
        y: 35
        width: 30
        height: 30
        radius: 2
        txtSize: 16
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#aca6a6"
            }

            GradientStop {
                position: 0.531
                color: "#e4d6d6"
            }

            GradientStop {
                position: 1 //1.033
                color: "#aca6a6"
            }
        }
        txtColor: "#000000"
        value: "ОМ"
        border.width: 0
        border.color: "#e4d6d6"
    }

    TInd {
        id: in2OM2
        x: 69
        y: 68
        width: 30
        height: 30
        radius: 2
        txtSize: 16
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#aca6a6"
            }

            GradientStop {
                position: 0.531
                color: "#e4d6d6"
            }

            GradientStop {
                position: 1 //1.033
                color: "#aca6a6"
            }
        }
        txtColor: "#000000"
        value: "ОМ"
        border.width: 0
        border.color: "#e4d6d6"
    }

    Image {
        id: in2BX
        x: 69
        y: 101
        width: 30
        height: 30
        source: "../Pictogram/ind_box.png"
    }

    TInd {
        id: in2DR
        x: 69
        y: 134
        width: 30
        height: 30
        radius: 2
        txtSize: 15
        txtColor: "red"
        value: "ДРУ"
        border.width: 2
        border.color: "red"
        gradient: Gradient{
            GradientStop {position:0.0; color: "silver"}
            GradientStop {position:0.3; color: "black"}
            GradientStop {position:0.7; color: "black"}
            GradientStop {position:1; color: "silver"}
        }
    }

    TInd {
        id: in2RZ
        x: 69
        y: 167
        width: 30
        height: 30
        radius: 2
        txtSize: 18
        txtColor: "#ffff00"
        value: "РЗ"
        border.width: 2
        border.color: "#ffff00"
        gradient: Gradient{
            GradientStop {position:0.0; color: "silver"}
            GradientStop {position:0.3; color: "black"}
            GradientStop {position:0.7; color: "black"}
            GradientStop {position:1; color: "silver"}
        }

    }

    TInd {
        id: in2OT
        x: 69
        y: 200
        width: 30
        height: 30
        radius: 2
        txtSize: 15
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ffff00"
            }

            GradientStop {
                position: 0.498
                color: "#ffffff"
            }

            GradientStop {
                position: 1
                color: "#ffff00"
            }
        }
        txtColor: "#000000"
        value: "ОТМ"
        border.width: 0
        border.color: "#ffff00"
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
