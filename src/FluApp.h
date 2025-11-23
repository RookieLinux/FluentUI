#pragma once

#include <QObject>
#include <QWindow>
#include <QtQml/qqml.h>
#include <QQmlContext>
#include <QJsonObject>
#include <QQmlEngine>
#include <QTranslator>
#include <QQuickWindow>
#include <QJsonArray>
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The FluApp class
 */
class FluApp : public QObject {
    Q_OBJECT
    Q_PROPERTY_AUTO(bool, useSystemAppBar)
    Q_PROPERTY_AUTO(QString, windowIcon)
    Q_PROPERTY_AUTO(QLocale, locale)
    Q_PROPERTY_AUTO_P(QObject *, launcher)
    QML_NAMED_ELEMENT(FluApp) //使qml可以调用其内的所有属性、invokable函数、枚举
    QML_SINGLETON
    //QML_SINGLETON  https://doc.qt.io/qt-6/qml-singleton.html
private:
    explicit FluApp(QObject *parent = nullptr);

    ~FluApp() override;

public:
    SINGLETON(FluApp)

    static FluApp *create(QQmlEngine *, QJSEngine *) {
        return getInstance();
    }

    Q_INVOKABLE void init(QObject *launcher, QLocale locale = QLocale::system());

    [[maybe_unused]] Q_INVOKABLE static QJsonArray iconData(const QString &keyword = "", bool caseSensitive = true);

private:
    QQmlEngine *_engine{};
    QTranslator *_translator = nullptr;
};