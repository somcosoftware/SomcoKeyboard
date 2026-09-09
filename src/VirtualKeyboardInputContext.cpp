#include "VirtualKeyboardInputContext.h"

#include <private/qquickflickable_p.h>

#include <QPropertyAnimation>
#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickwindow.h>

#include "DeclarativeInputEngine.h"
#include "EnterKeyAction.hpp"
#include "EnterKeyActionAttachedType.hpp" // IWYU pragma: keep
#include "KeyboardTheme.h"
#include "ThemeManager.h"
#include <QQmlEngine>

/**
 * Private data class for VirtualKeyboardInputContext
 */
class VirtualKeyboardInputContextPrivate
{
public:
    VirtualKeyboardInputContextPrivate();

    QQuickFlickable* Flickable;
    QQuickItem* FocusItem;
    bool Visible;
    /**
     * Gate for explicit hide requests: only requestHide() (the hide key on
     * the keyboard) sets this flag, so automatic hide requests from Qt
     * (e.g. input widget focus loss) are ignored by hideInputPanel().
     */
    bool UserHideRequested{false};
    DeclarativeInputEngine* InputEngine;
    ThemeManager* Themes;
    QPropertyAnimation* FlickableContentScrollAnimation{nullptr};
};

VirtualKeyboardInputContextPrivate::VirtualKeyboardInputContextPrivate()
    : Flickable(0), FocusItem(0), Visible(false), InputEngine(new DeclarativeInputEngine()), Themes(new ThemeManager())
{
}

VirtualKeyboardInputContext::VirtualKeyboardInputContext() : QPlatformInputContext(), d(new VirtualKeyboardInputContextPrivate)
{
    d->FlickableContentScrollAnimation = new QPropertyAnimation(this);
    d->FlickableContentScrollAnimation->setPropertyName("contentY");
    d->FlickableContentScrollAnimation->setDuration(400);
    d->FlickableContentScrollAnimation->setEasingCurve(QEasingCurve(QEasingCurve::OutBack));
    connect(d->InputEngine, &DeclarativeInputEngine::animatingChanged, this, &VirtualKeyboardInputContext::ensureFocusedObjectVisible);
    connect(d->InputEngine, &DeclarativeInputEngine::keyboardRectangleChanged, this, &VirtualKeyboardInputContext::emitKeyboardRectChanged);

    qmlRegisterSingletonType<DeclarativeInputEngine>("SomcoKeyboard", 1, 0, "InputEngine", inputEngineProvider);
    qmlRegisterSingletonType<VirtualKeyboardInputContext>("SomcoKeyboard", 1, 0, "InputContext", inputContextProvider);
    qmlRegisterType<EnterKeyAction>("SomcoKeyboard", 1, 0, "EnterKeyAction");

    qmlRegisterSingletonType<ThemeManager>("SomcoKeyboard", 1, 0, "ThemeManager", themeManagerProvider);
    qmlRegisterType<KeyboardTheme>("SomcoKeyboard", 1, 0, "KeyboardTheme");
}

VirtualKeyboardInputContext::~VirtualKeyboardInputContext() {}

VirtualKeyboardInputContext* VirtualKeyboardInputContext::instance()
{
    static VirtualKeyboardInputContext* InputContextInstance = new VirtualKeyboardInputContext;
    return InputContextInstance;
}

QObject* VirtualKeyboardInputContext::inputItem() const { return d->FocusItem; }

bool VirtualKeyboardInputContext::focusItemHasEnterKeyAction(QObject* item) const
{
    return item != nullptr && qmlAttachedPropertiesObject<EnterKeyAction>(item, false);
}

void VirtualKeyboardInputContext::registerInputPanel(QObject* inputPanel)
{
    Q_ASSERT(!this->inputPanel);
    this->inputPanel = inputPanel;
    if (QQuickItem* item = qobject_cast<QQuickItem*>(inputPanel))
        item->setZ(std::numeric_limits<qreal>::max());
}

bool VirtualKeyboardInputContext::isValid() const { return true; }

QRectF VirtualKeyboardInputContext::keyboardRect() const { return d->InputEngine->keyboardRectangle(); }

void VirtualKeyboardInputContext::showInputPanel()
{
    d->Visible = true;
    QPlatformInputContext::showInputPanel();
    emitInputPanelVisibleChanged();
}

void VirtualKeyboardInputContext::hideInputPanel()
{
    // Ignore automatic hide requests from Qt (e.g. QLineEdit clears the input
    // method on focus out, which used to close the keyboard). The keyboard
    // stays open on focus loss and can only be closed via requestHide().
    if (!d->UserHideRequested)
    {
        return;
    }
    d->UserHideRequested = false;
    if (d->FocusItem && d->FocusItem->inputMethodQuery(Qt::ImEnabled).toBool())
    {
        // if the current focus item accepts input, clear its focus to ensure visual consistency
        d->FocusItem->setFocus(false);
    }
    d->Visible = false;
    QPlatformInputContext::hideInputPanel();
    emitInputPanelVisibleChanged();
}

void VirtualKeyboardInputContext::requestHide()
{
    // Mark the request as user-initiated so hideInputPanel() accepts it
    d->UserHideRequested = true;
    hideInputPanel();
}

bool VirtualKeyboardInputContext::isInputPanelVisible() const { return d->Visible; }

bool VirtualKeyboardInputContext::isAnimating() const { return false; }

void VirtualKeyboardInputContext::setFocusObject(QObject* object)
{
    static const int NumericInputHints = Qt::ImhPreferNumbers | Qt::ImhDate | Qt::ImhTime | Qt::ImhFormattedNumbersOnly;

    QObject::disconnect(visibleConnection);

    if (!object)
    {
        return;
    }

    d->FocusItem = dynamic_cast<QQuickItem*>(object);
    if (!d->FocusItem)
    {
        return;
    }

    bool AcceptsInput = d->FocusItem->inputMethodQuery(Qt::ImEnabled).toBool();
    if (!AcceptsInput)
    {
        // Focus moved to a non-input item inside QML: close the keyboard on
        // purpose (explicit internal request, not an automatic Qt hide)
        requestHide();
        return;
    }

    // set the focusItem as parent of InputPanel
    if (QObject* item = inputItem())
    {
        // ToDo: the InputPanel is set once, so cast can be done at register QQuickItem
        if (QQuickItem* vkbPanel = qobject_cast<QQuickItem*>(inputPanel))
        {
            // ToDo: cast of inputItem is overflow ... use d->FocusItem
            if (QQuickItem* quickItem = qobject_cast<QQuickItem*>(item))
            {
                const QVariant isRootItem = vkbPanel->property("__isRootItem");
                /*
                    For integrated keyboards, make sure it's a sibling to the overlay. The
                    high z-order will make sure it gets events also during a modal session.
                */
                if (isRootItem.isValid() && !isRootItem.toBool())
                {
                    vkbPanel->setParentItem(quickItem->window()->contentItem());
                    vkbPanel->setProperty("__reparented", true);
                }
            }
        }
    }

    visibleConnection = QObject::connect(d->FocusItem, &QQuickItem::visibleChanged, this,
                                         [this]
                                         {
                                             // The input item itself disappeared (e.g. page
                                             // switch): keep closing the keyboard in that case
                                             if (!d->FocusItem->isVisible())
                                                 requestHide();
                                             else
                                                 showInputPanel();
                                         });

    emit inputItemChanged();

    Qt::InputMethodHints InputMethodHints(d->FocusItem->inputMethodQuery(Qt::ImHints).toInt());
    if (InputMethodHints & Qt::ImhDigitsOnly)
    {
        d->InputEngine->setInputMode(DeclarativeInputEngine::DigitsOnly);
        d->InputEngine->setSymbolMode(false);
        d->InputEngine->setShiftState(DeclarativeInputEngine::ShiftOff);
    }
    else if (InputMethodHints & NumericInputHints)
    {
        d->InputEngine->setInputMode(DeclarativeInputEngine::Letters);
        d->InputEngine->setSymbolMode(true);
        d->InputEngine->setShiftState(DeclarativeInputEngine::ShiftOff);
    }
    else
    {
        d->InputEngine->setInputMode(DeclarativeInputEngine::Letters);
        d->InputEngine->setSymbolMode(false);
        // Auto-capitalize on focus if enabled, field is not password, and field is empty
        bool shouldUppercase = d->InputEngine->isAutoCapitalize() && !isPasswordField() && surroundingText().isEmpty();
        d->InputEngine->setShiftState(shouldUppercase ? DeclarativeInputEngine::ShiftOn : DeclarativeInputEngine::ShiftOff);
    }

    QQuickItem* i = d->FocusItem;
    d->Flickable = 0;
    while (i)
    {
        QQuickFlickable* Flickable = dynamic_cast<QQuickFlickable*>(i);
        if (Flickable)
        {
            d->Flickable = Flickable;
        }
        i = i->parentItem();
    }

    ensureFocusedObjectVisible();
}

QString VirtualKeyboardInputContext::surroundingText() const
{
    if (!d->FocusItem)
        return QString();
    return d->FocusItem->inputMethodQuery(Qt::ImSurroundingText).toString();
}

bool VirtualKeyboardInputContext::isPasswordField() const
{
    if (!d->FocusItem)
        return false;
    Qt::InputMethodHints hints(d->FocusItem->inputMethodQuery(Qt::ImHints).toInt());
    return (hints & Qt::ImhHiddenText) || (hints & Qt::ImhSensitiveData);
}

void VirtualKeyboardInputContext::ensureFocusedObjectVisible()
{
    if (!d->Visible || !d->Flickable || d->InputEngine->isAnimating())
    {
        return;
    }

    QRectF FocusItemRect(0, 0, d->FocusItem->width(), d->FocusItem->height());
    FocusItemRect = d->Flickable->mapRectFromItem(d->FocusItem, FocusItemRect);
    d->FlickableContentScrollAnimation->setTargetObject(d->Flickable);
    if (FocusItemRect.bottom() >= d->Flickable->height())
    {
        auto ContentY = d->Flickable->contentY() + (FocusItemRect.bottom() - d->Flickable->height()) + 20;
        d->FlickableContentScrollAnimation->setEndValue(ContentY);
        d->FlickableContentScrollAnimation->start();
    }
    else if (FocusItemRect.top() < 0)
    {
        auto ContentY = d->Flickable->contentY() + FocusItemRect.top() - 20;
        d->FlickableContentScrollAnimation->setEndValue(ContentY);
        d->FlickableContentScrollAnimation->start();
    }
}

QObject* VirtualKeyboardInputContext::inputEngineProvider(QQmlEngine* engine, QJSEngine* scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    return VirtualKeyboardInputContext::instance()->d->InputEngine;
}

QObject* VirtualKeyboardInputContext::themeManagerProvider(QQmlEngine* engine, QJSEngine* scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    return VirtualKeyboardInputContext::instance()->d->Themes;
}

QObject* VirtualKeyboardInputContext::inputContextProvider(QQmlEngine* engine, QJSEngine* scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    const auto instance = VirtualKeyboardInputContext::instance();
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QQmlEngine::setObjectOwnership(instance, QQmlEngine::CppOwnership);
#else
    QJSEngine::setObjectOwnership(instance, QJSEngine::CppOwnership);
#endif
    return instance;
}
