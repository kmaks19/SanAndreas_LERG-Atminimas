#include <a_samp>
#include "../include/gl_common.inc"

public OnFilterScriptInit()
{
    print("Rcon_Send Loaded");
    return 1;
}


public OnRconCommand(cmd[])
{
    SendFormatToAll(-1, "{c726e0}[VVP] {FFFFFF} %s", cmd);
    return 1;
}
