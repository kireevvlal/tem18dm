import QtQuick 2.0
// Компонент реверсор
Rectangle {
    id: reversor
    property int value: 1 // входной параметр значение
    width: 64
    height: 40
    color: "black"
    border.width: 0
    onValueChanged: {
     switch (value) {
      case 1: { // нейтраль
        img1.opacity = 1;
        img2.opacity = 0;
        img3.opacity = 0;
        break;
      }
      case 2: { // вперед
        img1.opacity = 0;
        img2.opacity = 1;
        img3.opacity = 0;
        break;
      }
      case 3: { // назад
        img1.opacity = 0;
        img2.opacity = 0;
        img3.opacity = 1;
        break;
      }
      default: { //заглушечка
        img1.opacity = 0;
        img2.opacity = 0;
        img3.opacity = 0;
        break;
      }

    }
}
    Image {
        id: img1
        x: 0
        y: 0
        width: 64
        height: 40
        source: "../Pictogram/reversor/r_1.png"
    }

    Image {
        id: img2
        x: 0
        y: 0
        width: 64
        height: 40
        opacity: 0
        source: "../Pictogram/reversor/r_2.png"
    }

    Image {
        id: img3
        x: 0
        y: 0
        width: 64
        height: 42
        opacity: 0
        source: "../Pictogram/reversor/r_3.png"
    }

}

