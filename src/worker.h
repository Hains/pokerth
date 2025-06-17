#include <QtCore>

class Worker : public QObject {
    Q_OBJECT
public:
    Worker();
    ~Worker();
signals:
    void finished();
    void error(QString err);
};