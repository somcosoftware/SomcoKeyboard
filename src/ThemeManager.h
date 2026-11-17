#pragma once

#include "KeyboardTheme.h"
#include <QObject>
#include <QQmlListProperty>
#include <qqml.h> // QML_SINGLETON (works on Qt 5 and Qt 6)

class ThemeManager : public QObject
{
    Q_OBJECT
    QML_SINGLETON

    Q_PROPERTY(QQmlListProperty<KeyboardTheme> availableThemes READ availableThemes NOTIFY availableThemesChanged)
    Q_PROPERTY(KeyboardTheme* currentTheme READ currentTheme NOTIFY currentThemeChanged)

public:
    explicit ThemeManager(QObject* parent = nullptr);
    virtual ~ThemeManager();

    QQmlListProperty<KeyboardTheme> availableThemes();
    KeyboardTheme* currentTheme() const;

    Q_INVOKABLE void addTheme(KeyboardTheme* theme);
    Q_INVOKABLE void setTheme(const QString& name);
    Q_INVOKABLE QStringList getAvailableThemeNames() const;

signals:
    void availableThemesChanged();
    void currentThemeChanged();

private:
    void setCurrentTheme(KeyboardTheme* theme);

    QList<KeyboardTheme*> m_availableThemes;
    KeyboardTheme* m_currentTheme{nullptr};
};
