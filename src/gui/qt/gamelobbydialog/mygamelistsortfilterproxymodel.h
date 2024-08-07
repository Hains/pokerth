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
#ifndef MYGAMELISTSORTFILTERPROXYMODEL_H
#define MYGAMELISTSORTFILTERPROXYMODEL_H

#include <QSortFilterProxyModel>

class MyGameListSortFilterProxyModel : public QSortFilterProxyModel
{
	Q_OBJECT

public:
	MyGameListSortFilterProxyModel(QObject *parent = 0);
	void setColumn1RegExp(QRegularExpression column1) {
		column1RegExp = column1;
	}
	void setColumn2RegExp(QRegularExpression column2) {
		column2RegExp = column2;
	}
	void setColumn3RegExp(QRegularExpression column3) {
		column3RegExp = column3;
	}
	void setColumn4RegExp(QRegularExpression column4) {
		column4RegExp = column4;
	}
	void setColumn5RegExp(QRegularExpression column5) {
		column5RegExp = column5;
	}

protected:
	bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const;
	bool lessThan(const QModelIndex &left, const QModelIndex &right) const;

private:
	QRegularExpression column1RegExp;
	QRegularExpression column2RegExp;
	QRegularExpression column3RegExp;
	QRegularExpression column4RegExp;
	QRegularExpression column5RegExp;

};

#endif // MYGAMELISTSORTFILTERPROXYMODEL_H
