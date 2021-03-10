/**
 * =============================================================================
 *									Sht Staff ON
 *  							All rights reserved.
 * =============================================================================
 *
 * Para dar compile é necessário usar #include <sht>
 *
 * Dúvidas? Xuap#3581
 * 
 */
 
#include <sourcemod>
#include <cstrike>
#include <sht>
#include <emperor>
#include <multicolors>

#define PLUGIN_VER "1.0"

#pragma semicolon 1
#pragma newdecls required

ConVar sht_staffon_flag;
ConVar sht_staffon_hide_spec;

public Plugin myinfo = 
{
	name = "Staff Online",
	author = "ShutAP",
	description = "Shows the staff online on the server in the chat.",
	version = PLUGIN_VER,
	url = "https://steamcommunity.com/id/xurape"
};

public void OnPluginStart()
{
	// Cvars
	CreateConVar("sm_sht_staffon_ver", PLUGIN_VER, "Plugin version // Do not touch!", FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);	
	sht_staffon_flag = CreateConVar("sht_staffon_flag", "b", "Pre-defined flag for all staffs that are going to be on the chat.");
	sht_staffon_hide_spec = CreateConVar("sht_staffon_hide_spec", "1", "Hide all staffs that are on spectator (When using the StealthRevived plugin)");
	
	// Translations
	LoadTranslations("sht_staffon.phrases");
	
	// Commands
	RegConsoleCmd("sm_staff", Online_Staff, "Shows the online staff on the chat.");
}

public Action Online_Staff(int client, int args)
{
	char traducao[256];
	Format(traducao, sizeof(traducao), "%t", "chat_title");
	CPrintToChat(client, "%s", traducao);
	
	for (int i = 1; i < MAXPLAYERS+1; i++)
	{
		char flag[2];
		char nome[MAX_NAME_LENGTH];
		int flag_vip = EMP_Flag_StringToInt(flag);
		GetConVarString(sht_staffon_flag, flag, sizeof(flag));
		if(EMP_IsValidClient(i) && IsClientInGame(i) && Client_HasAdminFlags(i, flag_vip)) {
			GetClientName(i, nome, sizeof(nome));
			if(i < 0) {
				Format(traducao, sizeof(traducao), "%t", "chat_staffoff");
				CPrintToChat(client, "%s", traducao);				
			} else {				
				int hide_spec = GetConVarInt(sht_staffon_hide_spec);
				if(hide_spec == 1) {
					if(GetClientTeam(i) == CS_TEAM_SPECTATOR) {
						
					} else {
						Format(traducao, sizeof(traducao), "%t", "chat_staffon", nome);
						CPrintToChat(client, "%s", traducao);
					}				
				}
				else {
					Format(traducao, sizeof(traducao), "%t", "chat_staffon", nome);
					CPrintToChat(client, "%s", traducao);
				}
			}
		} else {
			
		}
	}
	
	Format(traducao, sizeof(traducao), "%t", "chat_end");
	CPrintToChat(client, "%s", traducao);
	
	return Plugin_Handled;
}
