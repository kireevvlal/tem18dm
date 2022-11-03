import QtQuick 2.0

Item {

    Timer {
        triggeredOnStart: true

        interval: 500
        repeat: true
        running: true
        onTriggered: {
            cnt ++;
            var par = ioBf.getParamFrameLeft();

            // индикация регистрации
            //img_z0.visible = ! img_z0.visible;
            //img_ind_f.visible = ! img_ind_f.visible;

            //            prBar1.value = par[0]; //ioBf.getParamDiap(100);// заглушка

            pr_Mtg1.value = par[0]; //ioBf.getParamDiap(1500);// заглушка
            pr_Mtg2.value = par[1];// ioBf.getParamDiap(1500); // заглушка

            img_in2BX.opacity = ! img_in2BX.opacity;// заглушка
            if (cnt==2 ) {  in1DR.opacity = ! in1DR.opacity}; // ДРУ уровень воды
            if (cnt==1 ) {  in1OM.opacity = ! in1OM.opacity}; // отключатель моторов
            if (cnt==3 ) {  in1RZ.opacity = ! in1RZ.opacity}; // реле земли
            if (cnt==4 ) {  in1OT.opacity = ! in1OT.opacity}; // обрыв тормозной магистрали

            indUb0.text = par[2]; //ioBf.getParamDiap(100);// заглушка
            indUb1.text = par[3]; //ioBf.getParamDiap(100);// заглушка

            indIz0.text = par[4]; //ioBf.getParamDiap(60);// заглушка
            indIz1.text = par[5]; //ioBf.getParamDiap(60);// заглушка

            if  (cnt>6 ) { cnt = 0};
        }
    }

    Text {
        id: indUb0
        x: 42
        y: 3
        width: 23
        height: 17
        color: "#d2e8fb"
        text: qsTr("0")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: indUb1
        x: 73
        y: 3
        width: 23
        height: 17
        color: "#d2e8fb"
        text: qsTr("0")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
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
        id: txtUb1
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
        x: 42
        y: 22
        width: 23
        height: 17
        color: "#d2e8fb"
        text: qsTr("0")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
    }

    Text {
        id: indIz1
        x: 73
        y: 22
        width: 23
        height: 17
        color: "#d2e8fb"
        text: qsTr("0")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 14
        font.bold: true
    }

    Image {
        id: img_in1BX
        x: 3
        y: 43
        width: 28
        height: 28
        source: "../Pictogram/ind_box.png"
    }

    Image {
        id: img_in2BX
        x: 67
        y: 43
        width: 28
        height: 28
        source: "../Pictogram/ind_box.png"
    }

    ExtBeads {
        id: pr_Mtg1
        x: 34
        y: 48
        height: 180
        width: 28
        cntitems: 15
        colors: ["#f01f00", "#f02f00", "#f03f00", "#f04f00", "#f05f00", "#f06f00", "#f07f00", "#f08f00", "#f09f99", "#f0afaa", "#f0bfbb", "#f0cfcc", "#f0dfdd", "#f0efee", "#f0ffff"]
        value: 0
        maxvalue: 1500
    }

    ExtBeads {
        id: pr_Mtg2
        x: 98
        y: 48
        height: 180
        width: 28
        cntitems: 15
        colors: ["#f01f00", "#f02f00", "#f03f00", "#f04f00", "#f05f00", "#f06f00", "#f07f00", "#f08f00", "#f09f99", "#f0afaa", "#f0bfbb", "#f0cfcc", "#f0dfdd", "#f0efee", "#f0ffff"]
        value: 1500
        maxvalue: 1500
    }

  TInd {
      id: in1DR
      x: 1
      y: 115
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
        id: in2DR
        x: 65
        y: 115
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
        id: in1RZ
        x: 1
        y: 156
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
        id: in2RZ
        x: 65
        y: 156
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
        id: in1OT
        x: 1
        y: 197
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
        id: in1OM
        x: 1
        y: 76
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
        id: in2OM
        x: 65
        y: 76
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
        id: in2OT
        x: 65
        y: 197
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
