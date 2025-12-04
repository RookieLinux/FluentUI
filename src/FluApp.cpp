#include "FluApp.h"

#include <QGuiApplication>
#include <QQuickItem>
#include <QTimer>
#include <QUuid>
#include <QFontDatabase>
#include <QClipboard>
#include <QTranslator>
#include <utility>
#include "FluentIconDef.h"

FluApp::FluApp(QObject *parent) : QObject{parent} {
    _useSystemAppBar = false;
}

FluApp::~FluApp() = default;

void FluApp::init(QObject *launcher, QLocale locale) {
    this->launcher(launcher);
    _locale = std::move(locale);
    _engine = qmlEngine(launcher);
    _translator = new QTranslator(this); //使用 QTranslator 来加载生成的 qm 文件，就可以让程序显示指定的语言
    QGuiApplication::installTranslator(_translator);
    const QStringList uiLanguages = _locale.uiLanguages();
    for (const QString &name : uiLanguages) {
        const QString baseName = "fluentui_" + QLocale(name).name();
        if (_translator->load(":/qt/qml/FluentUI/i18n/" + baseName)) { //加载qm文件
            _engine->retranslate();//刷新所有使用标记为翻译的字符串的绑定表达式
            break;
        }
    }
}

[[maybe_unused]] QJsonArray FluApp::iconData(const QString &keyword, bool caseSensitive) {
    QJsonArray arr;
    QMetaEnum enumType = FluentIcons::staticMetaObject.enumerator(
        FluentIcons::staticMetaObject.indexOfEnumerator("Type"));
    for (int i = 0; i <= enumType.keyCount() - 1; ++i) {
        QString name = enumType.key(i);
        int icon = enumType.value(i);
        if (keyword.isEmpty() || name.contains(keyword, caseSensitive ? Qt::CaseSensitive : Qt::CaseInsensitive)) {
            QJsonObject obj;
            obj.insert("name", name);
            obj.insert("icon", icon);
            arr.append(obj);
        }
    }
    return arr;
}
