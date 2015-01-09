using System;
using PlayerIO.GameLibrary;

namespace ServerSide
{
	/*
	 * Checks if user is 1st time in game. If yes - gives start capital, creates PlayerObject, credits powerups, etc. 
	 */
	public class RegistrationManager
	{
        private BasicRoom _roomLink;

		public RegistrationManager(BasicRoom roomLink)
		{
            _roomLink = roomLink;
		}

		public void checkIfNewbie(Player player)
		{
			if (!player.PlayerObject.Contains(DBProperties.SPELL_OBJECT)) //new guy
			{
                double expiresDate = Utils.unixSecs() + GameConfig.SPELL_ACTIVATION_TIME * 60 * 60;
                if (player.isGuest)
                    expiresDate = Utils.unixSecs() + (60 * 60 * 24 * 365 * 500L); //for 500 years, should be enough; Adding L solves "The operation overflows at compile time in checked mode" problem

				DatabaseObject spells = new DatabaseObject(); //fill slots
                DatabaseObject freezeSpell = new DatabaseObject();
                freezeSpell.Set(DBProperties.SPELL_SLOT, 1).Set(DBProperties.SPELL_EXPIRES, expiresDate);
                DatabaseObject splitSpell = new DatabaseObject();
                splitSpell.Set(DBProperties.SPELL_SLOT, 2).Set(DBProperties.SPELL_EXPIRES, expiresDate);
                DatabaseObject lightningSpell = new DatabaseObject();
                lightningSpell.Set(DBProperties.SPELL_SLOT, 3).Set(DBProperties.SPELL_EXPIRES, expiresDate);
                DatabaseObject charmSpell = new DatabaseObject();
                charmSpell.Set(DBProperties.SPELL_SLOT, 4).Set(DBProperties.SPELL_EXPIRES, expiresDate);
                DatabaseObject bouncyShield = new DatabaseObject();
                bouncyShield.Set(DBProperties.SPELL_SLOT, 5).Set(DBProperties.SPELL_EXPIRES, expiresDate);
				spells.Set(Spells.FREEZE, freezeSpell); 
				spells.Set(Spells.SPLIT_IN_TWO, splitSpell);
				spells.Set(Spells.LIGHTNING_ONE, lightningSpell);
                spells.Set(Spells.LASER_SHOTS, charmSpell);
                spells.Set(Spells.BOUNCY_SHIELD, bouncyShield);

				player.PlayerObject.Set(DBProperties.SPELL_OBJECT, spells);
                player.PlayerObject.Set(DBProperties.ENERGY, GameConfig.ENERGY_MAX);
                player.PlayerObject.Set(DBProperties.ENERGY_LAST_UPDATE, Utils.unixSecs());
                player.PlayerObject.Set(DBProperties.ENERGY_EXPIRES, (double)0);
                player.PlayerObject.Set(DBProperties.RANK_NUMBER, 1);
                player.PlayerObject.Set(DBProperties.RANK_PROGRESS, GameConfig.RANK_PROGRESS_START);
                player.PlayerObject.Set(DBProperties.BOUNCER_ID, ShopItemsInfo.BOUNCER_STANDART_BLUE);
                player.PlayerObject.Set(DBProperties.SOUNDS_ON, true);
                player.PlayerObject.Set(DBProperties.MUSIC_ON, true);

				player.PlayerObject.Save();

                BuyItemInfo bluePanel = new BuyItemInfo(ShopItemsInfo.BOUNCER_STANDART_BLUE);
                player.PayVault.Give(new BuyItemInfo[1]  { bluePanel }, delegate() { }, _roomLink.handleError);
                player.PayVault.Credit(GameConfig.COINS_START_AMOUNT, "Started playing",
                    delegate() { Console.WriteLine("Player got start coins"); }, handleError);				
			}
		}

        private void handleError(PlayerIOError value)
        {
            throw new Exception(value.Message, value);
        }

		private void giveStartCapital(Player player)
		{
			/*Console.WriteLine("givestartcapital");
			player.PayVault.Credit(1000, "starter", delegate() { Console.WriteLine("1000 credited"); }, handleError);
			BuyItemInfo[] allItems = new BuyItemInfo[Data.powerupNames.Length * 3];
			for (int j = 0; j < Data.powerupNames.Length; j++)
			{
				for (int i = 0; i < 3; i++) //3 items of each kind
				{
					allItems[j * 3 + i] = new BuyItemInfo(Data.powerupNames[j]); //fill array with "BuyItemInfo"
				}
			}
			player.PayVault.Give(allItems, null, handleError);*/
		}
	}
}
