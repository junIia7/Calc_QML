#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Загрузка QML файла из ресурсов
    engine.load(QUrl(QStringLiteral("qrc:/prefix1/interface.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
