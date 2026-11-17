#pragma once

#include <QColor>
#include <QObject>
#include <QString>
#include <QUrl>
// qqml.h provides the QML_* registration macros on Qt 6 (via QtQmlIntegration)
// as well as on Qt 5.15, so it is safe to include on both major versions.
#include <qqml.h>

class KeyboardTheme : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString themeName READ themeName WRITE setThemeName NOTIFY themeNameChanged REQUIRED FINAL)
    Q_PROPERTY(QColor overlayBackgroundColor MEMBER m_overlayBackgroundColor NOTIFY overlayBackgroundColorChanged FINAL)
    Q_PROPERTY(QColor backgroundColor MEMBER m_backgroundColor NOTIFY backgroundColorChanged FINAL)
    Q_PROPERTY(QColor btnBackgroundColor MEMBER m_btnBackgroundColor NOTIFY btnBackgroundColorChanged FINAL)
    Q_PROPERTY(QColor btnSpecialBackgroundColor MEMBER m_btnSpecialBackgroundColor NOTIFY btnSpecialBackgroundColorChanged FINAL)
    Q_PROPERTY(QColor btnEnterBackgroundColor MEMBER m_btnEnterBackgroundColor NOTIFY btnEnterBackgroundColorChanged FINAL)
    Q_PROPERTY(QColor btnTextColor MEMBER m_btnTextColor NOTIFY btnTextColorChanged FINAL)
    Q_PROPERTY(QString btnTextFontFamily MEMBER m_btnTextFontFamily NOTIFY btnTextFontFamilyChanged FINAL)
    Q_PROPERTY(int btnTextFontSize MEMBER m_btnTextFontSize NOTIFY btnTextFontSizeChanged FINAL)

    Q_PROPERTY(QString backspaceIcon MEMBER m_backspaceIcon NOTIFY backspaceIconChanged FINAL)
    Q_PROPERTY(QString enterIcon MEMBER m_enterIcon NOTIFY enterIconChanged FINAL)
    Q_PROPERTY(QString shiftOnIcon MEMBER m_shiftOnIcon NOTIFY shiftOnIconChanged FINAL)
    Q_PROPERTY(QString shiftOffIcon MEMBER m_shiftOffIcon NOTIFY shiftOffIconChanged FINAL)
    Q_PROPERTY(QString capsLockIcon MEMBER m_capsLockIcon NOTIFY capsLockIconChanged FINAL)
    Q_PROPERTY(QString hideKeyboardIcon MEMBER m_hideKeyboardIcon NOTIFY hideKeyboardIconChanged FINAL)
    Q_PROPERTY(QString languageIcon MEMBER m_languageIcon NOTIFY languageIconChanged FINAL)
    Q_PROPERTY(QString spaceIcon MEMBER m_spaceIcon NOTIFY spaceIconChanged FINAL)

public:
    explicit KeyboardTheme(QObject* parent = nullptr);

    QString themeName() const;
    void setThemeName(const QString& name);

signals:
    void themeNameChanged();
    void overlayBackgroundColorChanged();
    void backgroundColorChanged();
    void btnBackgroundColorChanged();
    void btnSpecialBackgroundColorChanged();
    void btnEnterBackgroundColorChanged();
    void btnTextColorChanged();
    void btnTextFontFamilyChanged();
    void btnTextFontSizeChanged();

    void backspaceIconChanged();
    void enterIconChanged();
    void shiftOnIconChanged();
    void shiftOffIconChanged();
    void capsLockIconChanged();
    void hideKeyboardIconChanged();
    void languageIconChanged();
    void spaceIconChanged();

private:
    QString m_themeName;
    QColor m_overlayBackgroundColor;
    QColor m_backgroundColor;
    QColor m_btnBackgroundColor;
    QColor m_btnSpecialBackgroundColor;
    QColor m_btnEnterBackgroundColor;
    QColor m_btnTextColor;
    QString m_btnTextFontFamily;
    int m_btnTextFontSize{16};

    QString m_backspaceIcon;
    QString m_enterIcon;
    QString m_shiftOnIcon;
    QString m_shiftOffIcon;
    QString m_capsLockIcon;
    QString m_hideKeyboardIcon;
    QString m_languageIcon;
    QString m_spaceIcon;
};
