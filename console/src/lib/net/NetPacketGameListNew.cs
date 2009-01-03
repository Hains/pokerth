﻿/***************************************************************************
 *   Copyright (C) 2008 by Lothar May                                      *
 *                                                                         *
 *   This file is part of pokerth_console.                                 *
 *   pokerth_console is free software: you can redistribute it and/or      *
 *   modify it under the terms of the GNU Affero General Public License    *
 *   as published by the Free Software Foundation, either version 3 of     *
 *   the License, or (at your option) any later version.                   *
 *                                                                         *
 *   pokerth_console is distributed in the hope that it will be useful,    *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the                                *
 *   GNU Affero General Public License along with pokerth_console.         *
 *   If not, see <http://www.gnu.org/licenses/>.                           *
 ***************************************************************************/

using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.IO;


namespace pokerth_lib
{
	class NetPacketGameListNew : NetPacket
	{
		public NetPacketGameListNew()
			: base(NetPacket.NetTypeGameListNew)
		{
		}

		public NetPacketGameListNew(int size, BinaryReader r)
			: base(NetPacket.NetTypeGameListNew)
		{
			if (size < 20)
				throw new NetPacketException("NetPacketGameListNew invalid size.");
			Properties.Add(PropType.GameId,
				Convert.ToString(IPAddress.NetworkToHostOrder((int)r.ReadUInt32())));
			Properties.Add(PropType.AdminPlayerId,
				Convert.ToString(IPAddress.NetworkToHostOrder((int)r.ReadUInt32())));
			Properties.Add(PropType.GameMode,
				Convert.ToString(IPAddress.NetworkToHostOrder((short)r.ReadUInt16())));

			int gameNameLen = IPAddress.NetworkToHostOrder((short)r.ReadUInt16());

			int curNumPlayers = IPAddress.NetworkToHostOrder((short)r.ReadUInt16());
			Properties.Add(PropType.CurNumPlayers, Convert.ToString(curNumPlayers));
			Properties.Add(PropType.GamePrivacyFlags,
				Convert.ToString(IPAddress.NetworkToHostOrder((short)r.ReadUInt16())));

			ScanGameInfoBlock(r);

			// Read name of the game.
			byte[] tmpName = r.ReadBytes(gameNameLen);
			Properties.Add(PropType.GameName,
				Encoding.UTF8.GetString(tmpName));
			// Skip the padding.
			int namePadding = AddPadding(tmpName.Length) - tmpName.Length;
			if (namePadding > 0)
				r.ReadBytes(namePadding);

			// Read player ids.
			List<string> playerSlots = new List<string>();
			for (int i = 0; i < curNumPlayers; i++)
				playerSlots.Add(Convert.ToString(IPAddress.NetworkToHostOrder((int)r.ReadUInt32())));
			ListProperties.Add(ListPropType.PlayerSlots, playerSlots);
		}

		public override void Accept(INetPacketVisitor visitor)
		{
			visitor.VisitGameListNew(this);
		}

		public override byte[] ToByteArray()
		{
			throw new NotImplementedException();
		}
	}
}