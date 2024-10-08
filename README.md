Fix build against Qt6

uics/ui_settingsdialog.h: In member function ‘void Ui_settingsDialog::setupUi(QDialog*)’:
uics/ui_settingsdialog.h:2442:25: error: no matching function for call to ‘QObject::connect(QSlider*&, void (QAbstractSlider::*)(int), QLabel*&, <unresolved overloaded function type>)’
 2442 |         QObject::connect(horizontalSlider_soundVolume, &QSlider::valueChanged, label_soundVolume, &QLabel::setNum);
      |         ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /usr/include/x86_64-linux-gnu/qt6/QtCore/qvariant.h:22,


ui_settingsdialog.h is an automatically generated file.

Change line 2442

From 

QObject::connect(horizontalSlider_soundVolume, &QSlider::valueChanged, label_soundVolume, &QLabel::setNum);

to

QObject::connect(horizontalSlider_soundVolume, &QSlider::valueChanged, label_soundVolume, qOverload``<int``>(&QLabel::setNum));
