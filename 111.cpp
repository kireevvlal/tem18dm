#include <QString>
#include <QJsonArray>

class Settings {
    QString name;
    int age;
    float deposit;
    bool sex;
public slots:
    QJsonArray getManSettings();
};

QJsonArray Settings::getManSettings() // Разобраться с цветом гистограмм
{
    int one = 100;
    float arr[3] = {99.99, 77.77, 11.11 };
    QString str = "Япомнючудноемгновенье";
    name = "Vanya";
    age = 38;
    deposit = 134777.86;
    sex = 1; // men

    return {
    QJsonArray { name, age, deposit, sex }, // Settings
    QJsonArray { one, QJsonArray { arr[0], arr[1], arr[2] } },
    str, 12, 133.3, false };
}

//
