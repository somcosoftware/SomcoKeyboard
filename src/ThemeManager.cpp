#include "ThemeManager.h"
#include "KeyboardTheme.h"
#include <QDebug>

ThemeManager::ThemeManager(QObject* parent) : QObject(parent) {}

ThemeManager::~ThemeManager() {}

QQmlListProperty<KeyboardTheme> ThemeManager::availableThemes()
{
    return QQmlListProperty<KeyboardTheme>(
        this, this,
        [](QQmlListProperty<KeyboardTheme>* list, KeyboardTheme* theme)
        {
            auto self = static_cast<ThemeManager*>(list->data);
            self->addTheme(theme);
        },
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        [](QQmlListProperty<KeyboardTheme>* list) -> qsizetype { return static_cast<ThemeManager*>(list->data)->m_availableThemes.count(); },
        [](QQmlListProperty<KeyboardTheme>* list, qsizetype index) -> KeyboardTheme*
        { return static_cast<ThemeManager*>(list->data)->m_availableThemes.at(index); },
#else
        // Qt 5 uses int instead of qsizetype in QQmlListProperty.
        [](QQmlListProperty<KeyboardTheme>* list) -> int { return static_cast<ThemeManager*>(list->data)->m_availableThemes.count(); },
        [](QQmlListProperty<KeyboardTheme>* list, int index) -> KeyboardTheme*
        { return static_cast<ThemeManager*>(list->data)->m_availableThemes.at(index); },
#endif
        [](QQmlListProperty<KeyboardTheme>* list)
        {
            static_cast<ThemeManager*>(list->data)->m_availableThemes.clear();
            emit static_cast<ThemeManager*>(list->data)->availableThemesChanged();
        });
}

KeyboardTheme* ThemeManager::currentTheme() const { return m_currentTheme; }
void ThemeManager::setCurrentTheme(KeyboardTheme* theme)
{
    if (m_currentTheme != theme)
    {
        qDebug() << "SomcoKeyboard: Current theme changed to:" << theme->themeName();
        m_currentTheme = theme;
        emit currentThemeChanged();
    }
}

void ThemeManager::addTheme(KeyboardTheme* theme)
{
    if (!m_availableThemes.contains(theme))
    {
        m_availableThemes.append(theme);
        emit availableThemesChanged();
        qDebug() << "SomcoKeyboard: Added new theme:" << theme->themeName();
    }
}

void ThemeManager::setTheme(const QString& name)
{
    for (auto theme : qAsConst(m_availableThemes))
    {
        if (theme->themeName() == name)
        {
            setCurrentTheme(theme);
            return;
        }
    }
    qWarning() << "SomcoKeyboard: Theme " << name << " not found!";
}

QStringList ThemeManager::getAvailableThemeNames() const
{
    QStringList names;
    for (auto theme : m_availableThemes)
    {
        names << theme->themeName();
    }
    return names;
}
