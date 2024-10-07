import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQml 2.1 // Добавлен импорт для Timer


ApplicationWindow {
    visible: true
    minimumWidth: 360
    minimumHeight: 640

    maximumWidth: 360
    maximumHeight: 640

    title: "Калькулятор"
    background: Rectangle {
        color: "#024873"
    }

    FontLoader {
        id: openSansSemibold
        source: "qrc:/prefix1/OpenSans-Semibold.ttf"  // Путь к шрифту в ресурсах
    }

    function appendToDisplay(value) {
        if (secretEntryTimer.running) {
            secretInput += value; // Ввод для секретного меню
            ansdisplay.text = secretInput;
        }

        var lastChar = indisplay.text[indisplay.text.length - 1];

        if (value === "+/-") {
            if (indisplay.text.startsWith("-"))
                indisplay.text = indisplay.text.slice(1);
            else
                indisplay.text = "-" + indisplay.text;
            return;
        }

        if (value === "()") {
            if (indisplay.text.indexOf("(") === -1 ||
                (indisplay.text.split("(").length <= indisplay.text.split(")").length)) {

                // Проверяем, что последний символ не является числом
                if (isNaN(lastChar))
                    indisplay.text += "(";
            }
            else {
                // Проверяем, добавляем ли закрывающую скобку
                if (lastChar !== '+' && lastChar !== '-' && lastChar !== '×' && lastChar !== '÷' && lastChar !== '(')
                    indisplay.text += ")";
            }
            return;
        }

        if (indisplay.text === "0")
            indisplay.text = value;
        else if (value === '+' || value === '÷' || value === '-' || value === '×' || value === '/')
            if (lastChar == '+' || lastChar == '÷' || lastChar == '-' || lastChar == '×' || lastChar == '/')
                indisplay.text = indisplay.text.slice(0, -1) + value;
            else
                indisplay.text += value;
        else
            indisplay.text += value;
    }

    function clearDisplay() {
        indisplay.text = "0";
        ansdisplay.text = "0";
    }

    function calculateResult() {
        try {
            var expression = indisplay.text;
            indisplay.text = "0";

            expression = expression.replace(/(\d+)\s*%/g, function(match, num) {
                return (Number(num) / 100).toString();
            });

            expression = expression.replace(/÷/g, "/").replace(/×/g, "*");

            ansdisplay.text = String(eval(expression));

        } catch (e) {
            ansdisplay.text = "Error";
        }
    }

    function openSecretMenu() {
        secretMenu.visible = true;
        secretInput = "";
        indisplay.text = "";
     }

    property bool isSecretActive: false
    property string secretInput: ""

     // Таймер для длительного нажатия
     Timer {
        id: longPressTimer
        interval: 4000 // 4 секунды
        onTriggered: {
            secretInput = ""; // Сбрасываем секретный ввод
            secretEntryTimer.start(); // Начинаем ожидание ввода "123"
        }
     }

     // Таймер для ввода секрета
     Timer {
        id: secretEntryTimer
        interval: 5000 // 5 секунд для ввода "123"
        repeat: false
        onTriggered: {
            secretInput = ""; // Очищаем ввод по истечении времени
        }
     }

     // Основной контейнер для всего интерфейса
     Column {
        height: parent.height
        width: parent.width

        Image {
           id: logo
           source: "qrc:/prefix1/status.png"
           width: parent.width
           height: 24
           anchors.horizontalCenter: parent.horizontalCenter
        }

        Column {
            spacing: 8

            height: 156
            width: 360

            anchors.top: parent.top // Привязываем к верхней части окна
            anchors.topMargin: 24  // Отступ в 24 пикселей

            Rectangle {
                width: parent.width
                height: 44;
                color: "#04bfad"
            }

            // Поле для отображения ввода
            TextField {
                height: 35
                width: 280

                anchors.top: parent.top // Привязываем к верхней части окна
                anchors.topMargin: 44  // Отступ в 44 пикселей

                anchors.left: parent.left // Привязываем к левой части окна
                anchors.leftMargin: 39  // Отступ в 39 пикселей

                id: indisplay
                background: Rectangle{
                    color: "#04bfad"
                    width: 360;
                    height: 70;

                    anchors.left: parent.left
                    anchors.leftMargin: -39
                }
                onTextChanged: {
                    if (secretInput === "123") {
                        secretEntryTimer.stop(); // Останавливаем таймер
                        openSecretMenu(); // Открываем секретное меню
                    }
                }

                font.family: openSansSemibold.name
                font.pixelSize: 20
                font.letterSpacing: 1

                color: "#FFFFFF"
                horizontalAlignment: TextInput.AlignRight
                readOnly: true
            }


            // Поле для отображения ответа
            TextField {

                height: 65
                width: 281

                anchors.top: parent.top // Привязываем к верхней части окна
                anchors.topMargin: 82  // Отступ в 82 пикселей

                anchors.left: parent.left // Привязываем к левой части окна
                anchors.leftMargin: 39  // Отступ в 39 пикселей

                id: ansdisplay
                background: Rectangle{
                    color: "#04bfad"
                    radius: 28;
                    width: 360;
                    height: 75;

                    anchors.left: parent.left
                    anchors.leftMargin: -39
                }

                font.family: openSansSemibold.name
                font.pixelSize: 50
                font.letterSpacing: 0.5

                color: "#FFFFFF"
                horizontalAlignment: TextInput.AlignRight
                readOnly: true
            }
        }

        // Контейнер для кнопок калькулятора
        Grid {
            columns: 4
            spacing: 24

            anchors.top: parent.top // Привязываем к верхней части окна
            anchors.topMargin: 204  // Отступ в 20 пикселей

            anchors.left: parent.left // Привязываем к верхней части окна
            anchors.leftMargin: 24  // Отступ в 20 пикселей

            // Кнопки цифр и операций
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#f7e425" : "#0889a6"
                    radius: 30
                }
                Image {
                    source: "qrc:/prefix1/par.png"
                    anchors.centerIn: parent
                    width: 30  // Настройка ширины изображения
                    height: 30  // Настройка высоты изображения
                }

                onClicked:
                    appendToDisplay('()')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#f7e425" : "#0889a6"
                    radius: 30
                }
                Image {
                    source: "qrc:/prefix1/plm.png"
                    anchors.centerIn: parent
                    width: 30  // Настройка ширины изображения
                    height: 30  // Настройка высоты изображения
                }
                onClicked:
                    appendToDisplay('+/-')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#f7e425" : "#0889a6"
                        radius: 30
                    }
                Image {
                    source: "qrc:/prefix1/percent.png"
                    anchors.centerIn: parent
                    width: 30  // Настройка ширины изображения
                    height: 30  // Настройка высоты изображения
                }
                onClicked:
                    appendToDisplay('%')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#f7e425" : "#0889a6"
                    radius: 30
                }
                Image {
                    source: "qrc:/prefix1/divide.png"
                    anchors.centerIn: parent
                    width: 30  // Настройка ширины изображения
                    height: 30  // Настройка высоты изображения
                }
                onClicked:
                    appendToDisplay('÷')
            }

            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#04bfad" : "#b0d1d8"
                    radius: 30
                }
                Text {
                    text: "7"
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: parent.down ? "#FFFFFF" : "#024873"
                    anchors.centerIn: parent
                }
                onClicked:
                    appendToDisplay('7')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#04bfad" : "#b0d1d8"
                    radius: 30
                }
                Text {
                    text: "8"
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: parent.down ? "#FFFFFF" : "#024873"
                    anchors.centerIn: parent
                }
                onClicked:
                    appendToDisplay('8')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#04bfad" : "#b0d1d8"
                    radius: 30
                }
                Text {
                    text: "9"
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: parent.down ? "#FFFFFF" : "#024873"
                    anchors.centerIn: parent
                }
                onClicked:
                    appendToDisplay('9')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#f7e425" : "#0889a6"
                    radius: 30
                }
                Image {
                    source: "qrc:/prefix1/multi.png"
                    anchors.centerIn: parent
                    width: 20  // Настройка ширины изображения
                    height: 20  // Настройка высоты изображения
                }
                onClicked:
                    appendToDisplay('×')
            }

            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#04bfad" : "#b0d1d8"
                    radius: 30
                }
                Text {
                    text: "4"
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: parent.down ? "#FFFFFF" : "#024873"
                    anchors.centerIn: parent
                }
                onClicked:
                    appendToDisplay('4')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#04bfad" : "#b0d1d8"
                    radius: 30
                }
                Text {
                    text: "5"
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: parent.down ? "#FFFFFF" : "#024873"
                    anchors.centerIn: parent
                }
                onClicked:
                    appendToDisplay('5')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#04bfad" : "#b0d1d8"
                    radius: 30
                }
                Text {
                    text: "6"
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: parent.down ? "#FFFFFF" : "#024873"
                    anchors.centerIn: parent
                }
                onClicked:
                    appendToDisplay('6')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#f7e425" : "#0889a6"
                    radius: 30
                }
                Image {
                    source: "qrc:/prefix1/minus.png"
                    anchors.centerIn: parent
                    width: 30  // Настройка ширины изображения
                    height: 30  // Настройка высоты изображения
                }
                onClicked:
                    appendToDisplay('-')
            }


            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#04bfad" : "#b0d1d8"
                    radius: 30
                }
                Text {
                    text: "1"
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: parent.down ? "#FFFFFF" : "#024873"
                    anchors.centerIn: parent
                }
                onClicked:
                    appendToDisplay('1')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#04bfad" : "#b0d1d8"
                    radius: 30
                }
                Text {
                    text: "2"
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: parent.down ? "#FFFFFF" : "#024873"
                    anchors.centerIn: parent
                }
                onClicked:
                    appendToDisplay('2')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#04bfad" : "#b0d1d8"
                    radius: 30
                }
                Text {
                    text: "3"
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: parent.down ? "#FFFFFF" : "#024873"
                    anchors.centerIn: parent
                }
                onClicked:
                    appendToDisplay('3')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#f7e425" : "#0889a6"
                    radius: 30
                }
                Image {
                    source: "qrc:/prefix1/plus.png"
                    anchors.centerIn: parent
                    width: 30  // Настройка ширины изображения
                    height: 30  // Настройка высоты изображения
                }
                onClicked:
                    appendToDisplay('+')
            }


            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#f7e425" : "#f25e5e"
                    radius: 30
                }
                Text {
                    text: "С"
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: "#FFFFFF"
                    anchors.centerIn: parent
                }
                onClicked:
                    clearDisplay()
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#04bfad" : "#b0d1d8"
                    radius: 30
                }
                Text {
                    text: "0"
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: parent.down ? "#FFFFFF" : "#024873"
                    anchors.centerIn: parent
                }
                onClicked:
                    appendToDisplay('0')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#04bfad" : "#b0d1d8"
                    radius: 30
                }
                Text {
                    text: "."
                    font.family: openSansSemibold.name
                    font.pixelSize: 24
                    font.letterSpacing: 1

                    color: parent.down ? "#FFFFFF" : "#024873"
                    anchors.centerIn: parent
                }
                onClicked:
                    appendToDisplay('.')
            }
            RoundButton {
                width: 60
                height: 60
                background: Rectangle {
                    color: parent.down ? "#f7e425" : "#0889a6"
                    radius: 30
                }
                Image {
                    source: "qrc:/prefix1/eq.png"
                    anchors.centerIn: parent
                    width: 30  // Настройка ширины изображения
                    height: 30  // Настройка высоты изображения
                }

                onClicked: {
                    calculateResult(); // Обычный режим работы
                }

                onPressed:
                    longPressTimer.start(); // Запускаем таймер при нажатии
                onReleased:
                    longPressTimer.stop(); // Останавливаем таймер, если кнопка отпущена до 4 секунд
            }

        }
    }

    // Окно секретного меню
    Dialog {
       id: secretMenu
       title: "Секретное меню"
       modal: true
       visible: false
       Column {
           spacing: 10
           Text {
               text: "Секретное меню"
               font.pointSize: 24
           }
           Button {
               text: "Назад"
               onClicked: secretMenu.close()
           }
       }
    }
}
