#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include scripts\chat_commands;

Init()
{
    CreateCommand(level.chat_commands["ports"], "setfog", "function", ::setFogCommand, 1);
}

setFogCommand(args)
{
    player = self;

    if (args.size != 1)
    {
        player TellPlayer(array("^3Usage: .setfog <0|1>"), 1);
        return;
    }

    fogState = int(args[0]);

    if (fogState == 0)
    {
        player setClientDvar("r_fog", 0);
        player TellPlayer(array("^1Fog Disabled"), 1);
    }
    else if (fogState == 1)
    {
        player setClientDvar("r_fog", 1);
        player TellPlayer(array("^2Fog Enabled"), 1);
    }
    else
    {
        player TellPlayer(array("^3Invalid fog state. Use 0 or 1."), 1);
    }
}