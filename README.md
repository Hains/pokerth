Build Pokerth against Qt6.<br>
Set QTDIR variable:
```
export QTDIR=/usr/lib/qt6
export PATH=$QTDIR/bin:$PATH
```
Before qpokerth.pro command.

When Qt6 has been built from source (e.g. Qt 6.8.2).
```
export QTDIR=/usr/local/Qt-6.8.2
export PATH=$QTDIR/bin:$PATH
export QT_SELECT=qt6
```
<br>
Fix build against Qt6 (applies to Qt 6.6, not tested with Qt 6.7.x).<br>

uics/ui_settingsdialog.h: In member function ‘void Ui_settingsDialog::setupUi(QDialog*)’:
uics/ui_settingsdialog.h:2442:25: error: no matching function for call to ‘QObject::connect(QSlider*&, void (QAbstractSlider::*)(int), QLabel*&, <unresolved overloaded function type>)’
 2442 |         QObject::connect(horizontalSlider_soundVolume, &QSlider::valueChanged, label_soundVolume, &QLabel::setNum);
      |         ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /usr/include/x86_64-linux-gnu/qt6/QtCore/qvariant.h:22,


ui_settingsdialog.h is an automatically generated header file during compilation.

Change line 2442

From 

QObject::connect(horizontalSlider_soundVolume, &QSlider::valueChanged, label_soundVolume, &QLabel::setNum);

to

QObject::connect(horizontalSlider_soundVolume, &QSlider::valueChanged, label_soundVolume, qOverload``<int>``(&QLabel::setNum));

