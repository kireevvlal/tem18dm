import QtQuick 2.0

Item {
    Text {
        id: name
    }

    Text {
        id: age
    }

    Text {
        id: deposit
    }

    Text {
        id: sex
    }

    Text {
        id: flval1
    }

    Text {
        id: flval2
    }

    Text {
        id: flval3
    }

    Text {
        id: intval
    }

    Text {
        id: ex1
    }

    Text {
        id: ex2
    }

    Text {
        id: ex3
    }

    Timer {
        onTriggered: {
            var par = cppobject.getManSettings();
            name.text = par[0][0];
            age.text = par[0][1];
            deposit.text = par[0][2].toFixed(2);
            sex.text = par[0][3] ? "men" : "women";
            flval1.text = par[1][1]
            flval2.text = par[1][2]
            flval3.text = par[1][3]
            intval.text = par[1][0]
            ex1.text = par[2]
            ex2.text = par[3]
            ex3.text = par[4]
            ex1.visible = ex2.visible = ex3.visible = par[5]
        }
    }
}
