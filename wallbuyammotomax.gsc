#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    level endon("game_ended");
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
        if(!isDefined(level.maC1))
        {
            wait 5;
            level.maC1 = "DONE";
    		replaceFunc(maps\mp\zombies\_zm_weapons::ammo_give,::new_ammo_give);
        }    
    }
}

new_ammo_give( weapon ) //checked changed to match cerberus output
{
    give_ammo = 0;
    fill_clip = 0; // Add a flag to control clip filling

    if ( !is_offhand_weapon( weapon ) )
    {
        weapon = get_weapon_with_attachments( weapon );
        if ( isDefined( weapon ) )
        {
            stockmax = 0;
            stockmax = weaponstartammo( weapon );
            clipmax = weaponclipsize( weapon ); // Get the maximum clip size
            clipcount = self getweaponammoclip( weapon );
            currstock = self getammocount( weapon );
            stockleft = currstock - clipcount;

            if ( stockleft < stockmax )
            {
                give_ammo = 1;
            }

            // Always fill the clip when buying ammo for a primary weapon
            if ( clipcount < clipmax )
            {
                fill_clip = 1;
            }
        }
    }
    else if ( self has_weapon_or_upgrade( weapon ) )
    {
        if ( self getammocount( weapon ) < weaponmaxammo( weapon ) )
        {
            give_ammo = 1;
            // For offhand weapons, we might not want to automatically "refill" in the same way
            // Consider if you want to add a specific clip mechanic for offhands.
        }
    }

    if ( give_ammo || fill_clip ) // Give ammo OR fill the clip
    {
        self play_sound_on_ent( "purchase" );
        if ( give_ammo )
        {
            self givemaxammo( weapon );
            alt_weap = weaponaltweaponname( weapon );
            if ( alt_weap != "none" )
            {
                self givemaxammo( alt_weap );
            }
        }
        if ( fill_clip )
        {
            self setweaponammoclip( weapon, clipmax ); // Fill the clip to max
        }
        return 1;
    }

    return 0;
}