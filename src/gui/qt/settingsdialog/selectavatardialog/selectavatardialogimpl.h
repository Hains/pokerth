/*****************************************************************************
 * PokerTH - The open source texas holdem engine                             *
 * Copyright (C) 2006-2012 Felix Hammer, Florian Thauer, Lothar May          *
 *                                                                           *
 * This program is free software: you can redistribute it and/or modify      *
 * it under the terms of the GNU Affero General Public License as            *
 * published by the Free Software Foundation, either version 3 of the        *
 * License, or (at your option) any later version.                           *
 *                                                                           *
 * This program is distributed in the hope that it will be useful,           *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of            *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
 * GNU Affero General Public License for more details.                       *
 *                                                                           *
 * You should have received a copy of the GNU Affero General Public License  *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.     *
 *                                                                           *
 *                                                                           *
 * Additional permission under GNU AGPL version 3 section 7                  *
 *                                                                           *
 * If you modify this program, or any covered work, by linking or            *
 * combining it with the OpenSSL project's OpenSSL library (or a             *
 * modified version of that library), containing parts covered by the        *
 * terms of the OpenSSL or SSLeay licenses, the authors of PokerTH           *
 * (Felix Hammer, Florian Thauer, Lothar May) grant you additional           *
 * permission to convey the resulting work.                                  *
 * Corresponding Source for a non-source form of such a combination          *
 * shall include the source code for the parts of OpenSSL used as well       *
 * as that of the covered work.                                              *
 *****************************************************************************/
#ifndef SELECTAVATARDIALOGIMPL_H
#define SELECTAVATARDIALOGIMPL_H

#ifdef GUI_800x480
#include "ui_selectavatardialog_800x480.h"
#else
#include "ui_selectavatardialog.h"
#endif
#include <QtWidgets>
#include <QtCore>
#include <QtGui>

class ConfigFile;
class selectAvatarDialogImpl;

class selectAvatarDialogImpl: public QDialog, public Ui::selectAvatarDialog
{
	Q_OBJECT
public:
	selectAvatarDialogImpl(QWidget *parent = 0, ConfigFile *c = 0);

	int exec();


public slots:
	void toggleGroupBox1(bool);
	void toggleGroupBox2(bool);
	void isAccepted();
	void isRejected();

	QString getAvatarLink();
	void setExternalAvatar();

	bool getSettingsCorrect() const	{
		return settingsCorrect;
	}

	void refreshAvatarView();


private:

	ConfigFile* myConfig;

	bool settingsCorrect;
	QString externalAvatar;
	QString avatarDir;
	QString myAppDataPath;
	QStringList miscAvatarList;
	QStringList peopleAvatarList;


};

#endif
