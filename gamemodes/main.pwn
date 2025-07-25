//LERG 2023

#include <a_samp>
#include <a_mysql>
#include <foreach>
#include <sscanf2>
#include <streamer>
#include <regex>
#include <MD5>

#include <YSI\y_va>
#include <YSI\y_dialog>
#include <YSI\y_inline>
#include <YSI\y_commands>
#include <YSI\y_malloc>
#include <YSI\y_flooding>
#include <sampmailjs>

#undef MAX_PLAYERS
#define MAX_PLAYERS 50

#define HOSTNAME "127.0.0.1"
#define DATABASE "lerg"
#define USERNAME "root"
#define DATABASE_PSW "mantas159"

#define IsValidNickName(%1) \
    regex_match(%1, "([A-Z]{1,1})[a-z]{2,9}+_([A-Z]{1,1})[a-z]{2,9}")

#define IsValidEmail(%1) \
    regex_match(%1, "[a-zA-Z0-9_.]+@([a-zA-Z0-9-]+.)+[a-zA-Z]{2,4}")

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define MSG SendClientMessage

#define function%0(%1) forward%0(%1); public%0(%1)

#define lergVersion "LERG # 0.0.4"

#define IsValidNickName(%1) \
    regex_match(%1, "([A-Z]{1,1})[a-z]{2,9}+_([A-Z]{1,1})[a-z]{2,9}")

#define IsValidEmail(%1) \
    regex_match(%1, "[a-zA-Z0-9_.]+@([a-zA-Z0-9-]+.)+[a-zA-Z]{2,4}")


#define _Kick(%0) SetTimerEx("Metam", 500, false, "d", %0)
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define PlusPlayerScore(%1,%2) \ 
    SetPlayerScore(%1, GetPlayerScore(%1) + %2)   

#define PlusPlayerHealth(%1,%2,%3) \
	SetPlayerHealth(%1, GetPlayerHealth(%1, %2) + %3)

#define MSG SendClientMessage

#define function%0(%1) forward%0(%1); public%0(%1)

#define PLAYCOL_HIDDEN     				    0xf8f8ffFF // gaudomiem
#define GREEN 								0x33AA33AA
#define COL_ADMIN	            		    "{1BB300}"
#define Melyna  							0x00B8D8AA
#define RED             					0xFF000030
#define BLUE 								0x33CCFFAA
#define PILKA 								0xAFAFAFFF


//Color names
#define VIP_COLOR							0xFFFF00FF
#define ADMIN_COLOR							0x33AA33AA
#define OWNER_COLOR 						0x33CCFFAA
#define DEFAULT_COLOR 						0x808080FF

#define ILVLADMIN (1)
#define IILVLADMIN (2)
#define IIILVLADMIN (3)
#define KOMANDOSNARIAI (4)
#define SAVININKAS (5)

#define VIPPRIZIURETOJAS (1)
#define ADMINPRIZIURETOJAS (2)
#define DPRIZIURETOJAS (3)
#define UNBANPRIZIURETOJAS (4)

#define thirtyDays 2592000 //galiojimo laikas
#define sevenDays 604800

#define naujienos ""

#define thirtyDays 2592000 //galiojimo laikas
#define sevenDays 604800
/*=====================================================================================*/

#define skirtiadmin 1
#define vipkomandos 2
#define adminkomandos 3
#define get 4
#define to 5
#define savkomandos 6
#define playerInfo 7
#define bausti 8
#define bausti2 9
#define bausti3 10
#define admins 11
#define rasytiadmins 12
#define vipgaliojimas 13
#define admingaliojimas 14
#define nepaememinlist 15
#define MEDIKUINFO 16
#define PDINFO 17
#define noglic 18
#define bendradarbiai 19
#define pdkomandos 20
#define medkomandos 21
#define armijainfo 22
#define rlog 23
#define direktoriulist 24
#define leisgyviss 25
#define kviesti 26
#define ispejimai 27
#define priezastys 28
#define drkzinute 29
#define dvp 30
#define priimtidarbuotoja 31
#define dfondas 32
#define visidarbuotojai 33
#define kontrole 34
#define nuimtiisp 35
#define nedirbantys 36
#define vipprizkomandos 37
#define aprizkomandos 38
#define dprizkomandos 39
#define valdzioslist 40
#define savkomandos1 41
#define savkomandos2 42
#define savkomandos3 43
#define drkkomandos 44

#define MAX_DARBU 4

new DarbuotojuVardai[MAX_DARBU][MAX_PLAYERS][MAX_PLAYER_NAME];

new
	MEDIKU_XP,
	POLICININKU_XP,
	ARMIJOS_XP
;

#define MEDIKAI 1
#define POLICININKAI 2
#define ARMIJA 3

enum darbuinfo
{
	DarboFondas,
	patirtis,
	drk[MAX_PLAYER_NAME],
	pav[MAX_PLAYER_NAME],
	drkpareigosenuo[31],
	pavpareigosenuo[31],
	drkisp,
	pavisp,
	bool:dirba,
	nedirbsiki,
	dienosminimumasMIN,
	dienosminimumasPAGYD,
	dienosminimumasBAUDOS,
	direktoriauszinute[128],
	bool:arijungta,
	Rangas1[30],
	Rangas2[30],
	Rangas3[30],
	Rangas4[30],
	Rangas5[30],
	Rangas6[30], // 5 Rangai 30 simboli� rangui.,

	Skin1_male,
	Skin1_female,

	Skin2_male,
	Skin2_female,

	Skin3_male,
	Skin3_female,

	Skin4_male,
	Skin4_female,

	Skin5_male,
	Skin5_female,

	Skin6_male,
	Skin6_female
}
new DarboInfo[MAX_DARBU][darbuinfo];
//
enum DPRIZ
{
	prizvardas[MAX_PLAYER_NAME],
	prizpareigosenuo[31],
	prizisp
}
new DPRIZINFO[DPRIZ];

enum VIPPRIZ
{
	prizvardas[MAX_PLAYER_NAME],
	prizpareigosenuo[31],
	prizisp
}
new VIPPRIZINFO[VIPPRIZ];

enum ADMINPRIZ
{
	prizvardas[MAX_PLAYER_NAME],
	prizpareigosenuo[31],
	prizisp
}
new ADMINPRIZINFO[ADMINPRIZ];

enum UNBANPRIZ
{
	prizvardas[MAX_PLAYER_NAME],
	prizpareigosenuo[31],
	prizisp
}
new UNBANPRIZ_INFO[UNBANPRIZ];

enum SAVININKAI
{
	sav_vardas0[MAX_PLAYER_NAME],
	sav_vardas1[MAX_PLAYER_NAME]
}
new SAVININKAI_INFO[SAVININKAI];

enum KNARIAI
{
	knario_vardas0[MAX_PLAYER_NAME], // Kolkas 2
	knario_vardas1[MAX_PLAYER_NAME]
}
new KOMANDOSNARIAI_INFO[KNARIAI];
//
enum pickupsData
{
	ginkline,
	ginklinesisejimas,
	ginklinesgun,
	ligoninesiejimas,
	ligoninesisejimas,
	bankoiejimas,
	bankoisejimas,
	viriausybesiejimas,
	viriausybesisejimas,
	hotelioiejimas,
	hotelioisejimas,
	vmiejimas,
	vmisejimas,
	medikuisidarbinimas,
	pdiejimas,
	pdisejimas,
	pdisidarbinimas,
	medinfo,
	pdinfo,
	sveikatospaz,
	armijosisidarbinimas,
	armijosinfo,
	gunlicbuypickup,
	admbauda
};

new pickups[1][pickupsData];

enum 
{ 
	DDMMYY, 
	DDYYMM, 
	MMDDYY, 
	MMYYDD, 
	YYDDMM, 
	YYMMDD 
};

enum SpikesInfo {
	Float: SpygliaiX,
	Float: SpygliaiY,
	Float: SpygliaiZ,
	bool: arPadeti,
	SpygliuObj,
	Text3D: SpygliuText
};
new SpygliaiInfo[MAX_PLAYERS][SpikesInfo];

#define MAX_ITA sizeof(itarimai)


enum ita_enum
{
	// Itarimo tipas 1 - bauda u� paprastus nusi�engimus, 2 - bauda u� �tarimus
	itarimo_vardas[120],
	itarimo_bausmes_vardas[22],
	vairavimotaskai, // MAX 100
	baudoskiekis_adm,
	starkiekis
}; // Vienas vairavimo taskas kainuos ?

#define MAX_BAUDOS 50

enum baudos_adm
{
	BaudosVardas[120],
	kamskirta[24],
	kasisrase[24],
	kadaisrase[31],
	baudos_suma
};
new BauduInfo[MAX_PLAYERS][MAX_BAUDOS][baudos_adm];

new itarimai[][ita_enum] =
{
    {"{8C6547}�{ffffff} Chuligani�kas vairavimas",																"50 vairavimo ta�k�", 50, 40000, 0},
    {"{8C6547}�{ffffff} Kelio kirtimas per pa�alines vietas (�olynus, �aligatvius ir pana�iai)",    				"20 stars",	 30, 20000, 0},
    {"{8C6547}�{ffffff} Kampo nukirtimai",   	 																"20 stars",	 15, 15000, 0},
    {"{8C6547}�{ffffff} Va�iavimas prie�inga eismo juosta (negalioja lenkanti ir apva�iuojant kli�t�)",    		"20 stars",	 50, 40000, 0},
	{"{8C6547}�{ffffff} �iuk�liad��i�, stoteli�, hidrant�, �viesofor� trankymai",                                "20 stars",	 40, 25000, 0},
	{"{8C6547}�{ffffff} Va�iavimas gele�inkelio b�giais",                                						"20 stars",	 50, 50000, 0},
	{"{8C6547}�{ffffff} �okin�jimas per �vairius stunt'us",                                						"20 stars",	 25, 25000, 0},
	{"{8C6547}�{ffffff} Avarijos suk�limas (u� kiekvien� sukelt� skirting� avarij�)",                            "20 stars",	 50, 50000, 0},
	{"{8C6547}�{ffffff} DM (masinis �udymas)", "50 star", 0, 0, 50},
	{"{8C6547}�{ffffff} Relog", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Pareig�no u�puolimas", "20 star", 0, 0, 20},
	{"{8C6547}�{ffffff} Pareig�no neklausymas arba(ir) ��eidin�jimas", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Civilio u�puolimas arba(ir) ��eidin�jimas", "25 star", 0,0, 25},
	{"{8C6547}�{ffffff} Ginklo demonstravimas vie�oje vietoje", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Ginklo naudojimas vie�oje vietoje", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Ky�io si�lymas", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Ma�inos dau�ymas", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Trukdymas policijos darbui", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} I�lipimas i� stabdomos tr. priemon�s", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Pagalba b�gliui", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Bereik�mis policijos kvietimas", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Grasinimas policijos pareig�nui", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Nepasi�alinimas i� streiko vietos, kai buvo to pareikalauta", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Chuligani�kas elgesys", "25 star", 0, 0, 25},
	{"{8C6547}�{ffffff} Reido trukdymas", "25 star", 0, 0, 25}
};
//=============== /dzinute =============
enum darbuskinlist
{
	Skinas
};

new pdskinlistmale[][darbuskinlist] =
{
	{280},
	{281},
	{282},
	{283},
	{284},
	{288},
	{300},
	{301},
	{302},
	{310},
	{311}
};

new medikuskinlistmale[][darbuskinlist] =
{
	{274},
	{275},
	{276}
};

new pdskinlistfemale[][darbuskinlist] =
{	
	{306},
	{307},
	{309}
};	

new AllowedCharacters[] =
{
    "0","1","2","3","4","5","6	","7","8","9",
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r", "s","t","u","v","w","x","y","z",
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
    "�", "�", "�", "�", "�", "�", "�", "�", "�",
    "�", "�", "�", "�", "�", "�", "�", "�", "�"
};

enum playerData
{
	ID,
	slaptazodis[65],
	skin,
	pinigai,
	patirtis,
	Cache:	Player_Cache,
	ADMIN,
	AdminLaikas,
	PasirinktasZaidejas,
	PasirinktasZaidejasOFF[24],
	adminskelbti,
	Muted,
	regdata[14],
	VIP,
	lytis,
	VipLaikas,
	darbas,
	uniforma,
	wUniform,
	gaudomumas,
	selfhealtimer,
	CmdVipTimerG,
	CmdVipTimerV,
	CmdAdminTimerKill,
	CmdAdminTimerSkelbti,
	glic,
	spdata[30],
	bool:Spectatina,
	BeforeSpectatingSkin,
	BeforeSpectatingInterior,
	BeforeSpectatingWorld,
	bool:SpectatingOthers,
	SpectatingAtTarget,
	bool:SpectatingAtPed,
	Float:BeforeSpectatingX,
	Float:BeforeSpectatingY,
	Float:BeforeSpectatingZ,
	direktorius,
	pavaduotojas,
	dskelbti,
	workingSince[31],
	aisp,
	visp,
	disp,
	drkisp, 
	Invited,
	ziuridarbuotoja,
	ziuribendradarbi,
	siandienpradirbo,
	siandienprazaide,
	Text3D: AFK_Label[MAX_PLAYERS],
	bool: AFK_Stat,
	Float: AntiAFK[3],
	bool:Surakintas,

	kvieciaID, 

	bool:viskvmed,
	bool:viskvpd,

	pagydymodelay,
	priziuretojas,
	prizpareigosenuo[31],
	direkopareigosenuo[31],
	lastloginIP[16],
	lastloginDATE[31],
	LaikoLigoninej,
	pagydymai,
	baudos,
	sveikatpazlaikas,
	bool:sveikatpaz,
	pakvietimastimer,
	adminpriz,
	prizskelbti,
	bool:Nutazintas,
	NutazintasTimer,
	ParaseAdminams,
	BanTimer,
	BanLaikas,
	permamute,
	zaidejoMedikuXP,
	zaidejoPolicijosXP,
	zaidejoArmijosXP,
	VairavimoNuobauduTaskai,
	priziuretojausisp,
	DarboRangas,
	KasUztilde[24]
};
new pInfo[MAX_PLAYERS][playerData];

new
	playerName[MAX_PLAYERS][MAX_PLAYER_NAME],
	MySQL: connectionHandle,
	query[3000],
	online[MAX_PLAYERS],
	poPrisijungimo[MAX_PLAYERS],
	poRegistracijos[MAX_PLAYERS],
	poMirties[MAX_PLAYERS],
	Corrupt_Check[MAX_PLAYERS],
	MuteTime[MAX_PLAYERS],
	IPAS[MAX_PLAYERS][17],
	playerCount,
	bool:suLiemene[MAX_PLAYERS],
	bool:bega[MAX_PLAYERS],
 	kasUzdejobega[MAX_PLAYERS][24],
	bool:leisgyvis[MAX_PLAYERS],
	Text3D:leisgyvistext[MAX_PLAYERS],
	leisgyvistimer[MAX_PLAYERS],
	Text3D:darbulabel[MAX_DARBU],
	chatClear = 0,
	SUSKYDU[MAX_PLAYERS],
	IskvietimoCP[MAX_PLAYERS],
	Iskvietimotimer[MAX_PLAYERS],
	nutazintas_idtimer[MAX_PLAYERS],
	ServerRestartTime = 0,
	Text:Logotipas[3],
	Text:SiandienosData[1],
	Text:Laikrodis[1],
	SaveTimer = 0
;

enum FirstAdminLevel
{
	Bausme[64],
	bLaikas
}

new 
	medikucar[1], pdcar[2],armijoscar[1]
;

new FAL[11][FirstAdminLevel] =
{
	{ ""COL_ADMIN"- U�tildymas", 										0  }, // 0
	{ "Administracijos nari� ��eidin�jimai", 							30 }, // 1
	{ "Necenz�rini� �od�i� vartojimas masyviai", 						30 }, // 2
	{ "Flood/spam (4 �inut�s i� eil�s)", 								15 }, // 3
	{ "Blogas /admin naudojimas", 										20 }, // 4
	{ "Blogas vie�uj� prane�im� naudojimas", 							30 }, // 5
	{ " ", 																0  }, // 6
	{ ""COL_ADMIN"- I�metimas", 										0  }, // 7
	{ "AFK netinkamoje vietoje", 										0  }, // 8
	{ "Netinkamas Vardas_Pavard�", 										0  }, // 9
	{ "Ne�ra�yta prie�astis", 											0  }  // 10
};

enum SecondAdminLevel
{
	Bausme[64],
	bLaikas
}

new TAL[18][SecondAdminLevel] =
{
	{ ""COL_ADMIN"- U�tildymas", 										0  }, // 0
	{ "Administracijos nari� ��eidin�jimai", 							30 }, // 1
	{ "Necenz�rini� �od�i� vartojimas masyviai", 						30 }, // 2
	{ "Flood/spam (4 �inut�s i� eil�s)", 								15 }, // 3
	{ "Blogas /admin naudojimas", 										20 }, // 4
	{ "Blogas vie�uj� prane�im� naudojimas", 							30 }, // 5
	{ " ", 																0  }, // 6
	{ ""COL_ADMIN"- I�metimas", 										0  }, // 7
	{ "AFK netinkamoje vietoje", 										0  }, // 8
	{ "Netinkamas Vardas_Pavard�", 										0  }, // 9
	{ "Ne�ra�yta prie�astis", 											0  }, // 10
	{ " ", 																0    }, // 11
	{ ""COL_ADMIN"- Laikinas u�blokavimas", 							0    }, // 12
	{ "Netinkamas Vardas_Pavard� (3 kartai)", 							60   }, // 13
	{ "Admin/VIP komand� piktnaud�iavimas", 							180  }, // 14
	{ "�aid�j� apgavyst�s", 											1440 }, // 15
	{ "�tarim� d�jimas u� niek�", 										300  }, // 16
	{ " ", 																0    } // 17
};


enum ThirdAdminLevel
{
	Bausme[64],
	bLaikas
}

new SAL[18][ThirdAdminLevel] =
{
	{ ""COL_ADMIN"- U�tildymas", 										0  }, // 0
	{ "Administracijos nari� ��eidin�jimai", 							30 }, // 1
	{ "Necenz�rini� �od�i� vartojimas masyviai", 						30 }, // 2
	{ "Flood/spam (4 �inut�s i� eil�s)", 								15 }, // 3
	{ "Blogas /admin naudojimas", 										20 }, // 4
	{ "Blogas vie�uj� prane�im� naudojimas", 							30 }, // 5
	{ " ", 																0  }, // 6
	{ ""COL_ADMIN"- I�metimas", 										0  }, // 7
	{ "AFK netinkamoje vietoje", 										0  }, // 8
	{ "Netinkamas Vardas_Pavard�", 										0  }, // 9
	{ "Ne�ra�yta prie�astis", 											0  }, // 10
	{ " ", 																0    }, // 11
	{ ""COL_ADMIN"- Laikinas u�blokavimas", 							0    }, // 12
	{ "Netinkamas Vardas_Pavard� (3 kartai)", 							60   }, // 13
	{ "Admin/VIP komand� piktnaud�iavimas", 							180  }, // 14
	{ "�aid�j� apgavyst�s", 											1440 }, // 15
	{ "�tarim� d�jimas u� niek�", 										300  }, // 16
	{ " ", 																0    } // 17
};

enum AdminHelpSystem
{
	PadejoPerSiandien,
	PadejoPerSavaite,
	IsvisoPadejo,
	PadedamasZaidejas,
	bool: PaklausePagalbos
}
new AHS[MAX_PLAYERS][AdminHelpSystem];

main()
{
	SetMaxConnections(1,e_FLOOD_ACTION_KICK);
}

public OnGameModeInit()
{
	DisableInteriorEnterExits();
	new MySQLOpt: option_id = mysql_init_options();
	mysql_set_option(option_id, AUTO_RECONNECT, true);
	mysql_log(ERROR);

	connectionHandle = mysql_connect(HOSTNAME, USERNAME, DATABASE_PSW, DATABASE, option_id);

	if(connectionHandle == MYSQL_INVALID_HANDLE || mysql_errno(connectionHandle) != 0)
	{
		print("Prisijungimas prie duomen� baz�s nepavyko");
		SendRconCommand("exit");
		return 1;
	}
	mysql_set_charset("cp1257");
	print("Prisijungimas prie duomen� baz�s pavyko!");

	mysql_format(connectionHandle, query, 250, "SELECT * FROM darbai");
	mysql_tquery(connectionHandle, query, "LoadJobs", "");

	SetTimer("Game", 60000, true);
	SetTimer("SecondsTimer", 1000, true);
	SetTimer("AFK", 1000, true);

	SetNameTagDrawDistance(30.0);
	EnableStuntBonusForAll(false);
	SetWeather(18);

	SetGameModeText(lergVersion);

	LoadPickups();
	LoadJobVehicles();
	LoadTextDraws();

	SendRconCommand("password 0");

	return 1;
}

public OnGameModeExit()
{
	foreach(new i : Player)
	{
		OnPlayerDisconnect(i, 1);
	}
	SaugojamDarboPelnus();
	SaugojamDarba();
	mysql_close(connectionHandle);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SpawnPlayer(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	online[playerid] = false;
	TogglePlayerSpectating(playerid, true);

	Reset(playerid);

	GetPlayerName(playerid, playerName[playerid], MAX_PLAYER_NAME);

	PlayAudioStreamForPlayer(playerid, "http://www.radijas.fm/media/_catalog/www.radijas.fm-radijo-stotis-radiocentras.pls");

	if(!IsValidNickName(playerName[playerid]) && strcmp("Admin_MAXX", playerName[playerid], false))
	{
		MSG(playerid, 0xE3B924FF,"{bec2c4}[{09a9f9}>{bec2c4}]{ffffff} J�s� slapyvardis netinkamas");
		MSG(playerid, 0xE3B924FF,"{bec2c4}[{09a9f9}>{bec2c4}]{ffffff} Teisinga slapyvard�io forma yra:");
		MSG(playerid, 0xE3B924FF,"{bec2c4}[{09a9f9}>{bec2c4}]{ffffff} Vardas_Pavarde");
		SetTimerEx("Metam", 2000, false, "i", playerid);
		return 1;
	}

	playerCount++;
	MSG(playerid, -1, "{5FB30C}�{ffffff} Sveikas atvyk�s � {5FB30C}lerg.lt{ffffff} server�");

	SendFormat(playerid, -1, "{5FB30C}�{ffffff} �iuo metu serveryje yra {5FB30C}%i{ffffff} �aid�jai (-�)", playerCount);

	SendFormatAdmin(GREEN, "%s jungiasi � server�", playerName[playerid]);

	Corrupt_Check[playerid]++;

	GetPlayerIp(playerid, IPAS[playerid], sizeof(IPAS));

	mysql_format(connectionHandle, query, 144, "SELECT * FROM `banlist` WHERE `IP` = '%s' LIMIT 1",IPAS[playerid]);
	mysql_tquery(connectionHandle, query, "OnPlayerBanCheck", "i", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	Corrupt_Check[playerid]++;
	if(online[playerid]) _SAVE(playerid);
	if(cache_is_valid(pInfo[playerid][Player_Cache]))
	{
		cache_delete(pInfo[playerid][Player_Cache]);
		pInfo[playerid][Player_Cache] = MYSQL_INVALID_CACHE;
	}

	playerCount--;
	online[playerid] = false;

    new string[10];
    if(bega[playerid]) format(string, sizeof(string), "b�go");
    else format(string, sizeof(string), "neb�go");
    switch(reason)
    {
    	case 0: SendFormatAdmin(0xAFAFAFFF, "{FF2D00}� {BDBCBC}%s {DAD9D9}| atsijung� d�l technini� problem�. Tur�jo {BDBCBC}%i {DAD9D9}star, {BDBCBC}%s {FF2D00}nuo policijos", playerName[playerid], pInfo[playerid][gaudomumas], string);
    	case 1: SendFormatAdmin(0xAFAFAFFF, "{FF2D00}� {BDBCBC}%s {DAD9D9} | atsijung�. Tur�jo {FF2D00}%i {DAD9D9}star, {BDBCBC}%s {FF2D00}nuo policijos", playerName[playerid], pInfo[playerid][gaudomumas], string);
    	case 2: SendFormatAdmin(0xAFAFAFFF, "{FF2D00}� {BDBCBC}%s {DAD9D9} | buvo i�mestas. Tur�jo {FF2D00}%i {DAD9D9}star, {BDBCBC}%s {FF2D00}nuo policijos", playerName[playerid], pInfo[playerid][gaudomumas], string);
    }

	if(SpygliaiInfo[playerid][arPadeti] == true)
    {
        DestroyDynamicObject(SpygliaiInfo[playerid][SpygliuObj]);
		Delete3DTextLabel(SpygliaiInfo[playerid][SpygliuText]);
    	SpygliaiInfo[playerid][arPadeti] = false;
		SpygliaiInfo[playerid][SpygliaiX] = 0;
		SpygliaiInfo[playerid][SpygliaiY] = 0;
		SpygliaiInfo[playerid][SpygliaiZ] = 0;
    }

	playerName[playerid][0] = EOS;
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(poRegistracijos[playerid])
	{
		SetPlayerSkin(playerid, pInfo[playerid][skin]);
		pInfo[playerid][pinigai] += 15000;
		SetPlayerColor(playerid, DEFAULT_COLOR);
		pInfo[playerid][patirtis] += 5000;
		
		SetTimerEx("Galiojimas", 1000, true, "i", playerid);
		online[playerid] = true;
		leisgyvistimer[playerid] = SetTimerEx("TikrinamGyvybes",500,true, "i", playerid);

		mysql_format(connectionHandle, query, 140, "SELECT MedikoXP, PolicininkoXP, ArmijosXP FROM darbaiSuPakvietimais_xp WHERE Vardas = '%e'", playerName[playerid]);
		mysql_tquery(connectionHandle, query, "OnPlayerJobXPLoad", "i", playerid);
		ShowLogotipas(playerid);
		ShowDataIrLaikas(playerid);
		poRegistracijos[playerid] = false;
	}
	if(poPrisijungimo[playerid])
	{
		ToggleControlPlayer(playerid, false);
		_LOAD(playerid);

        SetTimerEx("Galiojimas", 1000, true, "i", playerid);

		if(pInfo[playerid][ADMIN] > 0 && gettime() >= pInfo[playerid][AdminLaikas] && pInfo[playerid][ADMIN] != SAVININKAS)
		{
			pInfo[playerid][ADMIN] = 0;
			pInfo[playerid][AdminLaikas] = 0;
			MSG(playerid, 0xFF0000AA, "- J�s� �Administratorius� paslaugos 30 D. galiojimo laikas baig�si. Galite �sigyti i� naujo /paslaugos");
	 	}
		if(pInfo[playerid][VIP] == 1 && gettime() >= pInfo[playerid][VipLaikas] && pInfo[playerid][ADMIN] != SAVININKAS)
		{
	        pInfo[playerid][VIP] = 0;
			pInfo[playerid][VipLaikas] = 0;
			MSG(playerid, 0xFF0000AA, "- J�s� �VIP� paslaugos 30 D. galiojimo laikas baig�si. Galite �sigyti i� naujo /paslaugos");
		}
		
		
		if(pInfo[playerid][VIP] == 1) MSG(playerid, -1, "{75B244}��� {FFFFFF}Sveikiname sugr��us, VIP nari! J�s� komandos: {ffff1a} /vkomandos{ffffff}.");
		if(pInfo[playerid][ADMIN] > 0) MSG(playerid, -1, "{75B244}��� {FFFFFF}Sveikiname sugr��us, administratoriau! J�s� komandos: {05c54e} /akomandos{ffffff}.");
		if(pInfo[playerid][ADMIN] == SAVININKAS) MSG(playerid, -1, "{75B244}��� {FFFFFF}Sveikiname sugr��us, savininke! J�s� komandos: {3abeff} /skomandos{ffffff}.");
		if(pInfo[playerid][priziuretojas] == DPRIZIURETOJAS) MSG(playerid, -1, "{75B244}��� {FFFFFF}Sveikiname sugr��us, direktori� pri�i�r�tojau! J�s� komandos: {3abeff} /dprizkomandos{ffffff}.");
		if(pInfo[playerid][priziuretojas] == VIPPRIZIURETOJAS) MSG(playerid, -1, "{75B244}��� {FFFFFF}Sveikiname sugr��us, V.I.P nari� pri�i�r�tojau! J�s� komandos: {3abeff} /vprizkomandos{ffffff}.");
		if(pInfo[playerid][priziuretojas] == ADMINPRIZIURETOJAS) MSG(playerid, -1, "{75B244}��� {FFFFFF}Sveikiname sugr��us, administratori� pri�i�r�tojau! J�s� komandos: {3abeff} /aprizkomandos{ffffff}.");
		if(pInfo[playerid][priziuretojas] == UNBANPRIZIURETOJAS) MSG(playerid, -1, "{75B244}��� {FFFFFF}Sveikiname sugr��us, UNBAN pri�i�r�tojau! J�s� komandos: {3abeff} /unbanprizkomandos{ffffff}.");
		if(pInfo[playerid][direktorius] > 0) MSG(playerid, -1, "{75B244}��� {FFFFFF}Sveikiname sugr��us, direktoriau! J�s� komandos: {3abeff} /dkomandos{ffffff}.");

		SetPlayerSkillLevel (playerid, WEAPONSKILL_PISTOL, 1);
		online[playerid] = true;
		leisgyvistimer[playerid] = SetTimerEx("TikrinamGyvybes",500,true, "i", playerid);

		mysql_format(connectionHandle, query, 140, "SELECT MedikoXP, PolicininkoXP, ArmijosXP FROM darbaiSuPakvietimais_xp WHERE Vardas = '%e'", playerName[playerid]);
		mysql_tquery(connectionHandle, query, "OnPlayerJobXPLoad", "i", playerid);

		ShowLogotipas(playerid);
		ShowDataIrLaikas(playerid);

		poPrisijungimo[playerid] = false;
	}
	if(poMirties[playerid])
	{
		if(pInfo[playerid][wUniform] == 0) SetPlayerSkin(playerid, pInfo[playerid][skin]);
		else if(pInfo[playerid][wUniform] > 0) SetPlayerSkin(playerid, pInfo[playerid][uniforma]);
		pInfo[playerid][pinigai] += 100;
		if(leisgyvis[playerid]){ leisgyvis[playerid] = false; Delete3DTextLabel(leisgyvistext[playerid]);}
		KillTimer(leisgyvistimer[playerid]);
		leisgyvistimer[playerid] = SetTimerEx("TikrinamGyvybes",500,true, "i", playerid);
		KillTimer(nutazintas_idtimer[playerid]);
		pInfo[playerid][Nutazintas] = false;
		pInfo[playerid][NutazintasTimer] = 0;
		poMirties[playerid] = false;
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	KillTimer(leisgyvistimer[playerid]);
	KillTimer(nutazintas_idtimer[playerid]);
	poMirties[playerid] = true;
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	ResetPlayerWeapons(playerid);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(suLiemene[playerid]){
		new Float:hp; 
		PlusPlayerHealth(playerid, hp, randomEx(5, 15));
	}
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if(damagedid != INVALID_PLAYER_ID && damagedid != playerid)
	{
		if(weaponid == 23)
    	{
    		if(pInfo[playerid][darbas] == POLICININKAI || pInfo[playerid][darbas] == ARMIJA)
    		{
    			if(pInfo[damagedid][Nutazintas] == false)
    			{
    				ClearAnimations(damagedid, 1);
    				pInfo[damagedid][Nutazintas] = true;
    				pInfo[damagedid][NutazintasTimer] = gettime() + 7;

    				ApplyAnimation(damagedid, "PED","FLOOR_hit_f", 4.1, 1, 1, 1, 1, 10000, 1);
    				new msg[128];

    				switch(pInfo[playerid][darbas])
    				{
    					case POLICININKAI:
    					{
    						format(msg, sizeof(msg), "~g~%s panaudojo tazeri pries jus",playerName[playerid]);
    						GameTextForPlayer(damagedid, msg, 2500, 5);
    						nutazintas_idtimer[damagedid] = SetTimerEx("RemoveTazed", 7000, 0, "i", damagedid);
    					}
    					case ARMIJA:
    					{
    						format(msg, sizeof(msg), "~g~%s panaudojo tazeri pries jus",playerName[playerid]);
    						GameTextForPlayer(damagedid, msg, 2500, 5);
    						nutazintas_idtimer[damagedid] = SetTimerEx("RemoveTazed", 7000, 0, "i", damagedid);
    					}
    				}
    			}
    		}
    	}
	}
}


public OnPlayerText(playerid, text[])
{
	if(!online[playerid]) return 0;
	ApplyAnimation(playerid,"PED","IDLE_CHAT",8.1,0,1,1,1,1);
	if(pInfo[playerid][Muted] > 0 && pInfo[playerid][permamute] == 0)
	{
		SendFormat(playerid, 0xFF0000AA, "� J�s u�tildytas, kalb�ti gal�site po: %s",\
			ConvertSeconds(pInfo[playerid][Muted] - gettime()));
		return 0;
	}
	if(pInfo[playerid][permamute] == 1)
	{
		MSG(playerid, 0xFF0000AA, "� J�s u�tildytas visam!");
		return 0;
	}
	if(pInfo[playerid][Nutazintas] == true && pInfo[playerid][NutazintasTimer] >= gettime())
    {
       ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 0, 0, 0, 0, 1000, 1);
    }
	foreach(new i : Player)
    {
    	new Float:cords[3];
    	GetPlayerPos(i, cords[0], cords[1], cords[2]);
    	if(IsPlayerInRangeOfPoint(i, 10, cords[0], cords[1], cords[2]))
    	{
    		SendFormat(i, GetPlayerColor(playerid), "%s(%i): {ffffff}%s",playerName[playerid], playerid, text);
    	}
    }
	if(leisgyvis[playerid])
    {
    	ApplyAnimation(playerid,"CRACK","crckdeth2",4.0,0,0,0,1,1);
    	return 0;
    }
	return 0;
}

public e_COMMAND_ERRORS:OnPlayerCommandReceived(playerid, cmdtext[], e_COMMAND_ERRORS:success)
{
    switch(success)
    {
    	case COMMAND_UNDEFINED:
    	{
    		MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
    	}
    }
    return COMMAND_OK;
}

YCMD:darbuxp(playerid, params[], help)
{
	inline showdarbuxp(pid, did, resp, litem, string:input[])
	{
		#pragma unused pid, did, litem, input
		if(resp)
		{
				
		}
	}
	new zBuffer[300], fBuffer[300];

	format(fBuffer, sizeof(fBuffer), "{8596E9}�{ffffff} Medik� XP: {8596E9}%s\n\n{8596E9}�{ffffff} Policijos XP: {8596E9}%s\n\n{8596E9}�{ffffff} Armijos XP: {8596E9}%s{ffffff}",\
	  konvertuoti_pinigus(pInfo[playerid][zaidejoMedikuXP]),  konvertuoti_pinigus(pInfo[playerid][zaidejoPolicijosXP]),  konvertuoti_pinigus(pInfo[playerid][zaidejoArmijosXP]));
	strcat(zBuffer, fBuffer);

	Dialog_ShowCallback(playerid, using inline showdarbuxp, DIALOG_STYLE_MSGBOX, "{ffffff}Darb� patirtis su pakvietimais", zBuffer, "Supratau", "");
	return 1;
}

YCMD:vkomandos(playerid, params[], help)
{
	if(pInfo[playerid][VIP] == 1 || pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new list[600];
		strcat(list, "{CF9F94}/pasigydyti{ffffff} - pagydo\n{CF9F94}/vc{ffffff} - VIP nari� chat'as\n{CF9F94}/v{ffffff} - VIP �inut� vie�ai\n{CF9F94}/vginklai{ffffff} - VIP ginklai\n{CF9F94}/tpd{ffffff} - teleportuoti � darb�\n{CF9F94}/taisyti{ffffff} - sutaisyti automobil�");

		ShowPlayerDialog(playerid, vipkomandos, DIALOG_STYLE_MSGBOX, "VIP komandos", list, "Supratau", "");
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:persirengti(playerid, params[], help)
{
	inline persirengimas(pid, did, resp, litem, string:input[])
	{
		#pragma unused pid, did, input
		if(resp)
		{
			switch(litem)
			{
				case 0:
				{
					if(pInfo[playerid][wUniform] == 0) return MSG(playerid, RED, "- J�s jau su paprastais drabu�iais");
					SetPlayerSkin(playerid, pInfo[playerid][skin]);
					MSG(playerid, -1,"� Persireng�te paprastais drabu�iais");
					pInfo[playerid][wUniform] = 0;
					ApplyAnimation(playerid, "PLAYIDLES", "stretch", 4.1, 0, 0, 0, 0, 0);
				}
				case 1:
				{
					if(pInfo[playerid][darbas] == 0) return MSG(playerid, RED, "- J�s bedarbis, neturite uniformos!");
					if(pInfo[playerid][wUniform] == 1) return MSG(playerid, RED, "- J�s jau su darbiniais drabu�iais");
					SetPlayerSkin(playerid, pInfo[playerid][uniforma]);
					MSG(playerid, -1,"� Persireng�te darbiniais drabu�iais");
					pInfo[playerid][wUniform] = 1;	
					ApplyAnimation(playerid, "PLAYIDLES", "stretch", 4.1, 0, 0, 0, 0, 0);
				}
			}
		}
	}
	Dialog_ShowCallback(playerid, using inline persirengimas, DIALOG_STYLE_LIST, "{ffffff}Persirengimas", "{008000}�{ffffff} Persirengti {008000}paprastais{ffffff} drabu�iais\n{008000}�{ffffff} Persirengti {008000}darbine{ffffff} apranga", "Persirengti", "I�eiti");
	return 1;
}

YCMD:paliktidarba(playerid, params[], help)
{
	if(pInfo[playerid][darbas] == 0) return MSG(playerid, RED, "- J�s bedarbis");
	if(pInfo[playerid][Surakintas]) return MSG(playerid, RED, "- J�s surakintas");
	if(pInfo[playerid][Spectatina]) return MSG(playerid, RED, "- J�s steb�jimo r��ime");
	if(pInfo[playerid][Nutazintas]) return MSG(playerid, RED, "- Prie� jus panaudotas tazeris");
	if(!online[playerid]) return MSG(playerid, RED, "- J�s neprisijung�s");

	inline darbo_palikimas(pid, did, resp, litem, string:input[])
	{
		#pragma unused pid, did, litem, input
		if(resp)
		{
			SendFormatToJob(pInfo[playerid][darbas], -1, "{f49e42}[RACIJA]: %s(%i) paliko darb�", playerName[playerid], playerid);
			pInfo[playerid][wUniform] = false;
			pInfo[playerid][uniforma] = 0;
			pInfo[playerid][darbas] = 0;
			SetPlayerSkin(playerid, pInfo[playerid][skin]);	
			ApplyAnimation(playerid,"PLAYIDLES","stretch",4.1,0,0,0,0,0);

			mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET darbas = '0', isidarbino = '' WHERE vardas = '%e'", playerName[playerid]);
			mysql_tquery(connectionHandle, query, "SendQuery", "");
		}
	}
	Dialog_ShowCallback(playerid, using inline darbo_palikimas, DIALOG_STYLE_MSGBOX, "{ffffff}Darbo palikimas", "{ffffff}Ar tikrai norite palikti darb�?", "Taip", "Ne");
	return 1;
}


YCMD:pasigydyti(playerid, params[], help)
{
	#pragma unused params, help
	if(pInfo[playerid][VIP] > 0 || pInfo[playerid][ADMIN] > 0)
	{
		if(pInfo[playerid][Surakintas]) return MSG(playerid, RED, "- J�s surakintas");
		if(bega[playerid]) return MSG(playerid, RED, "- J�s esate paskelbtas b�gliu!");
		if(pInfo[playerid][selfhealtimer] > gettime() && pInfo[playerid][ADMIN] < SAVININKAS)
		{
			SendFormat(playerid, 0xFF0000AA, "- Pasigydyti galite tik kas 5 minutes, v�l gal�site pasigydyti po %s", ConvertSeconds(pInfo[playerid][selfhealtimer] - gettime()));
		}
		else
		{
			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 100);
			MSG(playerid, -1, "{00FF11}+ Pasigyd�te");
			pInfo[playerid][selfhealtimer] = gettime() + 300;//5min
		}
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:taisyti(playerid, params[], help)
{
	#pragma unused params, help
	if(pInfo[playerid][VIP] > 0 || pInfo[playerid][ADMIN] == SAVININKAS)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			if(pInfo[playerid][pinigai] < 500 && pInfo[playerid][ADMIN] < SAVININKAS) return MSG(playerid, RED, "- Neturite 500�");
			if(bega[playerid]) return MSG(playerid, RED, "- Negalite taisyti automobilio turint b�glio status�!");
			RepairVehicle(GetPlayerVehicleID(playerid));
			if(pInfo[playerid][ADMIN] == SAVININKAS) return MSG(playerid, -1, "{ffffff} Automobilis {FFFA00}sutaisytas");
			else
			{
				MSG(playerid, -1, "{ffffff}Automobilis sutaisytas, u� taisym� sumok�jote {FFFA00}500�");
				pInfo[playerid][pinigai] -= 500;
			}
		}
		else return MSG(playerid, RED, "- Turite b�ti ma�inoje!");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:tpd(playerid, params[], help)
{
	if(pInfo[playerid][VIP] == 1 || pInfo[playerid][ADMIN] == SAVININKAS)
	{
		if(pInfo[playerid][pinigai] < 500) return MSG(playerid, RED, "- Neturite tiek pinig�!");
		if(pInfo[playerid][Spectatina]) return MSG(playerid, RED, "- J�s steb�jimo re�ime!");
		if(bega[playerid]) return MSG(playerid, RED, "- J�s esate paskelbtas b�gliu!");
		if(pInfo[playerid][Surakintas]) return MSG(playerid, RED, "- J�s surakintas");
		if(pInfo[playerid][ADMIN] < KOMANDOSNARIAI){pInfo[playerid][pinigai] -= 500; MSG(playerid, GREEN, "+ Nusiteleportavote iki darbo vietos u� 500�");}
	    switch(pInfo[playerid][darbas])
	    {
			case MEDIKAI:
			{
				SetPlayerPos(playerid, -2566.1682,607.9061,14.4592);
				SetPlayerFacingAngle(playerid, 1.0781);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			case POLICININKAI:
			{
				SetPlayerPos(playerid, -1569.7262,660.9575,7.1875);
				SetPlayerFacingAngle(playerid, 77.5284);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			case ARMIJA:
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				//TODO: 
			}
			default: return MSG(playerid, RED, "- J�s bedarbis!");
	    }
		MSG(playerid, GREEN, "+ Nusiteleportavote iki darbo vietos!");
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:vc(playerid, params[], help)
{
	#pragma unused help
	new msg[128];
	if(pInfo[playerid][VIP] == 1 || pInfo[playerid][ADMIN] == SAVININKAS)
	{
		if(pInfo[playerid][Muted] > 0)
		{
			SendFormat(playerid, 0xFF0000AA, "- J�s u�tildytas, kalb�ti gal�site po: %s",\
				ConvertSeconds(pInfo[playerid][Muted] - gettime()));
			return 1;
		}
		if(sscanf(params, "s[128]", msg)) return MSG(playerid, 0x00B8D8AA, "� Ra�yti VIP chate: /vc [Tekstas]");
		if(strlen(msg) > 128) MSG(playerid, 0xFF0000AA, "- Tekstas per ilgas!");

		SendFormatVip(-1, "{ffff00}[VIP.CHAT] %s(%i): %s", playerName[playerid], playerid, msg);
		SendFormatSav(-1, "{ffff00}[VIP.CHAT] %s(%i): %s", playerName[playerid], playerid, msg);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:v(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][VIP] > 0 || pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new msg[110];
		if(pInfo[playerid][Muted] > 0)
		{
			SendFormat(playerid, 0xFF0000AA, "- J�s u�tildytas, kalb�ti gal�site po: %s", \
			ConvertSeconds(pInfo[playerid][Muted] - gettime()));
			return 1;
		}
		if(sscanf(params, "s[110]", msg)){MSG(playerid, 0x00B8D8AA, "� Skelbti prane�im�: /v [Tekstas]");}
		else
		{
			if(pInfo[playerid][CmdVipTimerV] > gettime() && pInfo[playerid][ADMIN] < SAVININKAS) return SendFormat(playerid, 0xFF0000AA, "- VIP chante galite skelbti kas 5min, v�l gal�site paskelbti po %s", ConvertSeconds(pInfo[playerid][CmdVipTimerV] - gettime()));
        	pInfo[playerid][CmdVipTimerV] = gettime() + 300;//5min
			if(pInfo[playerid][VIP] == 1 || pInfo[playerid][ADMIN] == SAVININKAS){SendFormatToAll(-1, "{ffff1a}VIP {e6e600}%s(%i){ffff1a}: {ffff1a}%s", playerName[playerid], playerid, msg);}
		}
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:vginklai(playerid, params[], help)
{
	if(pInfo[playerid][VIP] > 0 || pInfo[playerid][ADMIN] == SAVININKAS)
	{
		if(pInfo[playerid][CmdVipTimerG] > gettime() && pInfo[playerid][ADMIN] < SAVININKAS) return SendFormat(playerid, 0xFF0000AA, "- VIP ginkl� paket� galite pasiimti kas 5min, v�l gal�site pasiimti po %s", ConvertSeconds(pInfo[playerid][CmdVipTimerG] - gettime()));
		GivePlayerWeapon(playerid, WEAPON_BAT, 1);
  		GivePlayerWeapon(playerid, WEAPON_COLT45, 60);
    	MSG(playerid, -1, "{00FF11}+ Gavote VIP ginkl� paket�");
	    pInfo[playerid][CmdVipTimerG] = gettime() + 300;//5min
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

//Paprastos komandos
YCMD:admin(playerid, params[], help)
{
    new String[2500], Stringas[200], AdminCount, KoksLygis[40];
    
    if(pInfo[playerid][Muted] > 0)
	{
		SendFormat(playerid, 0xFF0000AA, "- J�s u�tildytas, kalb�ti gal�site po: %s", \
		ConvertSeconds(pInfo[playerid][Muted] - gettime()));
		return 1;
	}
    
    if(isnull(params))
    {
        for(new i, size = GetPlayerPoolSize(); i <= size; i++)
        {
            if(IsPlayerConnected(i) && pInfo[i][ADMIN] > 0)
            {
                AdminCount ++;
                if(AdminCount == 0) return MSG(playerid, -1, "{75B244}��� {FFFFFF}�iuo metu prisijungusi� administratori� n�ra!");
                
                switch(pInfo[i][ADMIN])
                {
					case ILVLADMIN: 	KoksLygis = "{ q3AD73A}I lygio administratorius";
					case IILVLADMIN: 	KoksLygis = "{3AD73A}II lygio administratorius";
					case IIILVLADMIN: 	KoksLygis = "{3AD73A}III lygio administratorius";
					case SAVININKAS: 	KoksLygis = "{33B7D3}Savininkas";
                }
                
                format(Stringas, sizeof(Stringas), "{ffffff}%d. {33B7D3}%s{ffffff}, pareigos: %s\n", AdminCount, playerName[i], KoksLygis);
				strcat(String, Stringas);
				
				ShowPlayerDialog(playerid, admins, DIALOG_STYLE_MSGBOX, "Prisijung� serverio administratoriai", String, "�inut�", "U�daryti");
            }
        }
	}
	else
 	{
        if(pInfo[playerid][ParaseAdminams] > gettime() && pInfo[playerid][ADMIN] < SAVININKAS) SendFormat(playerid, -1, "{75B244}��� {FFFFFF}Administratoriams galima ra�yti tik kas 2 min, kit� gal�site ras�yti po: %s!",ConvertSeconds(pInfo[playerid][ParaseAdminams] - gettime()));
        else
		{	
			if(strlen(params) > 128) MSG(playerid, -1, "{75B244}��� {FFFFFF}Tekstas per ilgas!");
        
       		for(new i, size = GetPlayerPoolSize(); i <= size; i++)
			{
				if(IsPlayerConnected(i) && pInfo[i][ADMIN] > ILVLADMIN)
				{
					format(String, sizeof(String), "{2DB2D0}%s(%d) administratoriams: {ffffff}%s (/padeti %i)", playerName[playerid], playerid, params, playerid);
					MSG(i, -1, String);
				}	

  			}
			if(pInfo[playerid][ADMIN] < ILVLADMIN)
			{
				format(String, sizeof(String), "{2DB2D0}Para��te administratoriams: {ffffff}%s", params);
				MSG(playerid, -1, String);
			}
			pInfo[playerid][ParaseAdminams] = gettime() + 120; //2min
			AHS[playerid][PaklausePagalbos] = true;
		}
 	}
    return 1;
}

//ADMIN Komandos
YCMD:padeti(playerid, params[], help)
{
    new String[200], id, HelpText[128];

	if(pInfo[playerid][ADMIN] < ILVLADMIN) return 0;
    
    if(sscanf(params, "us[128]", id, HelpText)) return MSG(playerid, 0x00B8D8AA, "� Pad�ti �aid�jui: /padeti [Dalis Vardo/ID][Tekstas]");
    if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
    if(id == playerid) return MSG(playerid, 0xFF0000AA, "- Sau pad�ti negalite!");
    if(AHS[id][PaklausePagalbos] == false) return MSG(playerid, 0xFF0000AA, "- �aid�jas nepra�� pagalbos arba jam jau pad�jo kitas administratorius!");
    
    SendFormatAdmin(-1, "{75B244}��� {FFFFFF}Administratorius {33B7D3}%s{ffffff} atsak� � �aid�jo {33B7D3}%s{ffffff} pateikt� klausim�:", playerName[playerid], playerName[id]);
	SendFormatAdmin(-1, "{75B244}��� {FFFFFF}{FFF064}%s", HelpText);
	
	format(String, sizeof(String), "{75B244}��� {FFFFFF}Administratorius {33B7D3}%s{ffffff} atsak� � j�s� pateikt� klausim�:", playerName[playerid]);
	MSG(id, -1, String);
	format(String, sizeof(String), "{75B244}��� {FFFFFF}{FFF064}%s", HelpText);
	MSG(id, -1, String);
	
	AHS[id][PaklausePagalbos] = false;
	
	AHS[playerid][PadejoPerSiandien] 	++;
	AHS[playerid][PadejoPerSavaite] 	++;
	AHS[playerid][IsvisoPadejo] 		++;
	
	//Update DB later
	
	return 1;
}

YCMD:baik(playerid, params[], help)
{
	if(pInfo[playerid][Spectatina]) return MSG(playerid, 0xFF0000AA, "- Stebint �aid�j� negalite naudoti �ios komandos!");
	if(pInfo[playerid][Surakintas]) return MSG(playerid, 0xFF0000AA, "- Negalite naudoti �ios komandos nes esate surakintas!");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    ClearAnimations(playerid, 1);
    return 1;
}

YCMD:d(playerid, params[], help)
{
	if(pInfo[playerid][direktorius] > 0)
	{
		if(pInfo[playerid][Muted] > 0) SendFormat(playerid, 0xFF0000AA, "- J�s u�tildytas, kalb�ti gal�site po: %s", ConvertSeconds(pInfo[playerid][Muted] - gettime()));
		new msg[128];
		if(sscanf(params, "s[128]", msg)){MSG(playerid, 0x00B8D8AA, "� Skelbti prane�im� vie�ai: /d [Tekstas]");}
		else
		{
			if(pInfo[playerid][dskelbti] > gettime() && pInfo[playerid][ADMIN] != SAVININKAS) {MSG(playerid, 0xFF0000AA, "- Skelbti galima tik kas 30 sekund�i�!");}
			else
			{
				switch(pInfo[playerid][direktorius])
				{
					case 1:{SendFormatToAll(-1, "{76C4DE}Medik�{ffffff} direktorius {76C4DE}%s(%i){ffffff}: %s", playerName[playerid],playerid, msg);pInfo[playerid][dskelbti] = gettime() + 30;}// Medikai
					case 2:{SendFormatToAll(-1, "{76C4DE}Policijos{ffffff} generalinis komisaras {76C4DE}%s(%i){ffffff}: %s", playerName[playerid],playerid, msg);pInfo[playerid][dskelbti] = gettime() + 30;}// Policija
					case 3:{SendFormatToAll(-1, "{76C4DE}Armijos{ffffff} generolas {76C4DE}%s(%i){ffffff}: %s", playerName[playerid],playerid, msg);	pInfo[playerid][dskelbti] = gettime() + 30;} // Armija
				}
			}
		}
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:r(playerid, params[], help)
{
	new text[100];
	if(pInfo[playerid][Muted] > 0)
	{
		SendFormat(playerid, 0xFF0000AA, "- J�s u�tildytas, kalb�ti gal�site po: %s", \
			ConvertSeconds(pInfo[playerid][Muted] - gettime()));
		return 1;
	}
	if(sscanf(params, "s[100]", text)) return MSG(playerid, 0x00B8D8AA, "� Ra�yti � darbo racij�: /r [Tekstas]");
	if(pInfo[playerid][darbas] == 0) return MSG(playerid, RED, "- J�s neturite racijos!");
	if(strlen(params) > 100) return MSG(playerid, 0xFF0000AA, "- Tekstas per ilgas");

	SendFormatToJob(pInfo[playerid][darbas], -1, "{f49e42}[RACIJA]: %s(%i): %s", playerName[playerid], playerid, text);

	mysql_format(connectionHandle, query, 144, "INSERT INTO rlogas (kasparase, data, darbas, message) VALUES ('%s', '%s', '%i', '%s')", \
		playerName[playerid], GautiData(1), pInfo[playerid][darbas], text);
	mysql_tquery(connectionHandle, query, "SendQuery", "");
	return 1;
}

YCMD:tr(playerid, params[], help)
{
	if(!IsJobFromLaw(pInfo[playerid][darbas])) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	if(pInfo[playerid][Muted] > 0)
	{
		SendFormat(playerid, 0xFF0000AA, "- J�s u�tildytas, kalb�ti gal�site po: %s", \
			ConvertSeconds(pInfo[playerid][Muted] - gettime()));
		return 1;
	}
	if(isnull(params)) return MSG(playerid, 0x00B8D8AA, "� Ra�yti � teis�saugos racij�: /tr [tekstas]");
	if(strlen(params) > 100) return MSG(playerid, 0xFF0000AA, "- Tekstas per ilgas");

	SendFormatForLaw(-1, "{f49e42}[Teis�saugos Racija] %s(%i): %s", playerName[playerid], playerid, params);

	return 1;
}

YCMD:nepaememin(playerid, params[], help)
{
	if(pInfo[playerid][direktorius] == 0) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");

	new deit[31];
	if(sscanf(params, "s[31]", deit)) return MSG(playerid, 0x00B8D8AA, "� Per�i�r�ti darbuotojus ne�vykd�iusius dienos reikalavim�: /nepaemin [YY-MM-DD]");

	new daata[3];
	getdate(daata[0], daata[1], daata[2]);

	if(!isValidDate(deit, YYMMDD, '-')) return MSG(playerid, RED, "- Blogas datos formatas: YY-MM-DD");

	mysql_format(connectionHandle, query, 200, "SELECT * FROM nepaememin WHERE data = '%s' AND darbas = '%i'", deit, pInfo[playerid][direktorius]);
	mysql_tquery(connectionHandle, query, "OnRequestNepaemeMinimumo", "i", playerid);

	return 1;
}

function OnRequestNepaemeMinimumo(playerid)
{
	if(cache_num_rows() > 0)
	{
		new rows, vardas[MAX_PLAYER_NAME], data[31], jobid, totalbaudos, totalpradirbo, totalpagydymai, str[300], fstr[1000];
		cache_get_row_count(rows);
		for(new i = 0; i < rows; i++)
		{
			cache_get_value(i, "vardas", vardas);
			cache_get_value(i, "data", data);
			cache_get_value_int(i, "darbas", jobid);
			
			switch(jobid)
			{
				case MEDIKAI:
				{
					cache_get_value_int(i, "pradirbo", totalpradirbo);
					cache_get_value_int(i, "pagydymai", totalpagydymai);
					if(totalpradirbo == 0)
					{
						format(str, sizeof(str), "{ffffff}- {9FACF3}%s{ffffff} | {9FACF3}%s{ffffff} pradirbo: {9FACF3}0 min{ffffff} pagyd� �moni�: {9FACF3}%i\n", data, vardas, totalpagydymai);
						strcat(fstr, str);	
					}
					else{
						format(str, sizeof(str), "{fffffff}- {9FACF3}%s{fffffff} | {9FACF3}%s{ffffff} pradirbo: {9FACF3}%s{ffffff}, pagyd� �moni�: {9FACF3}%i\n", data, vardas, ConvertSeconds(totalpradirbo), totalpagydymai);
						strcat(fstr, str);	
					}
				}
				case POLICININKAI..ARMIJA:
				{
					cache_get_value_int(i, "pradirbo", totalpradirbo);
					cache_get_value_int(i, "baudos", totalbaudos);
					if(totalpradirbo == 0)
					{
						format(str, sizeof(str), "{ffffff}- {9FACF3}%s{ffffff} | {9FACF3}%s{ffffff} pradirbo: {9FACF3}0 min{ffffff} i�ra�� baud�: {9FACF3}%i\n", data, vardas, totalbaudos);
						strcat(fstr, str);	
					}
					else{
						format(str, sizeof(str), "{fffffff}- {9FACF3}%s{ffffff} | {9FACF3}%s{ffffff} pradirbo: {9FACF3}%s{ffffff}, i�ra�� baud�: {9FACF3}%i\n", data, vardas, ConvertSeconds(totalpradirbo), totalbaudos);
						strcat(fstr, str);	
					}
				}
			}
		}
		ShowPlayerDialog(playerid, nepaememinlist, DIALOG_STYLE_MSGBOX, "Nepa�m� dienos reikalavim� darbuotojai", fstr, "Supratau", "");
	}
	else return MSG(playerid, RED, "- T� dien� n�ra dienos reikalavim� nepa�musi� darbuotoj�!");
	return 1;
}

YCMD:vispeti(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == VIPPRIZIURETOJAS)
	{
		new id, reason[76];

		if(sscanf(params, "us[76]", id, reason)) MSG(playerid, 0x00B8D8AA, "� �sp�ti VIP nar�: /vispeti [Dalis vardo/ID] [Prie�astis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000FF, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, 0xFF0000FF, "- �aid�jas neprisijung�s!");
		if(pInfo[id][VIP] != 1) return MSG(playerid, RED, "- �aid�jas n�ra VIP narys");
		if(pInfo[id][ADMIN] > 3) return MSG(playerid, RED, "- Negalite �sp�ti �aid�jo kuris yra LERG komandos narys");

		pInfo[id][visp] += 1;

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
			GautiData(0), reason, playerName[playerid], playerName[id], 1);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 200, "INSERT INTO `vipISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		if(pInfo[id][visp] >= 3)
		{
			SendFormat(playerid, GREEN, "+ VIP narys %s �sp�tas d�l: %s, jis surinko tris �sp�jimus ir neb�ra VIP narys!", playerName[id], reason);
			pInfo[id][visp] = 0;
			pInfo[id][VIP] = 0;
			pInfo[id][VipLaikas] = 0;
			SendFormat(id, GREEN, "� VIP nari� pri�i�r�tojas %s �sp�jo jus d�l: %s, surinkote tris �sp�jimus ir nebeesate VIP narys!", playerName[playerid], reason);
			MSG(id, -1, "{ffd700}� Daugiau informacijos /priezastys");
			SetPlayerColor(id, DEFAULT_COLOR);
		}
		else if(pInfo[id][visp] < 3)
		{
			SendFormat(playerid, GREEN, "� VIP narys %s �sp�tas d�l: %s, dabar jis turi %i �sp�jimus", playerName[id], reason, pInfo[id][visp]);
			SendFormat(id, GREEN, "� VIP pri�i�r�tojas �sp�jo jus d�l: %s, dabar j�s turite %i �sp�jimus", reason, pInfo[id][visp]);
			MSG(id, -1, "{ffd700}� Daugiau informacijos /priezastys");
		}
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}


YCMD:vispetioff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == VIPPRIZIURETOJAS)
	{
		new Vardas[MAX_PLAYER_NAME], reason[25], id;
		if(sscanf(params, "s[24]s[25]", Vardas, reason)) return MSG(playerid, 0x00B8D8AA, "�sp�ti V.I.P nar� (OFFLINE): /aispetioff [Vardas_Pavard�][Priezastis]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, 0xFF0000AA, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 140, "SELECT vip, visp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "vispeti_off", "iss", playerid, Vardas, reason);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function vispeti_off(playerid, name[], reason[])
{
	if(cache_num_rows() > 0)
	{
		new vip_id, vip_isp;
		cache_get_value_index_int(0, 0, vip_id);
		if(vip_id == 0) return MSG(playerid, RED, "- �aid�jas n�ra V.I.P narys");
		cache_get_value_index_int(0, 1, vip_isp);

		vip_isp ++;

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
			GautiData(0), reason, playerName[playerid], name, 1);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 200, "INSERT INTO `vipISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		if(vip_isp >= 3)
		{
			SendFormat(playerid, GREEN, "+ �sp�jote V.I.P nar� %s d�l %s jis surinko 3 �sp ir yra nu�alintas", name, reason);	

			mysql_format(connectionHandle, query, 144, "UPDATE zaidejai SET vip = '0', visp = '0', VipLaikas = '0'", name);
			mysql_tquery(connectionHandle, query, "SendQuery", "");
		}
		else
		{
			SendFormat(playerid, GREEN, "+ �sp�jote V.I.P nar� %s d�l %s, dabar jis turi %i �sp", name, reason, vip_isp);
		}
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra");
	return 1;
}

YCMD:ispetiunbanpriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, reason[25];
		if(sscanf(params, "us[25]", id, reason)) return MSG(playerid, 0x00B8D8AA, "� �sp�ti UNBAN pri�i�r�toj�: /ispetiunbanpriz [Dalis vardo/ID][Priezatsis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, RED, "- Tokio �aid�jo n�ra");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
		if(pInfo[id][priziuretojas] != UNBANPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra UNBAN priziuretojas pri�i�r�tojas!");

		pInfo[id][priziuretojausisp]++;
		UNBANPRIZ_INFO[prizisp]++;

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
			GautiData(0), reason, playerName[playerid], playerName[id], 8);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 200, "INSERT INTO `unbanprizISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET prizisp = '%i' WHERE vardas = '%e'", \
			pInfo[id][priziuretojausisp], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE unban_priz SET prizisp = '%i' WHERE vardas = '%e'", \
			pInfo[id][priziuretojausisp], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		if(pInfo[id][priziuretojausisp] >= 3)
		{
			SendFormat(playerid, GREEN, "+ �sp�jote UNBAN pri�i�r�toj� %s d�l %s, jis surinko 3 �sp ir yra nu�alinamas nuo pareig�.", playerName[playerid], reason);

			SendFormat(id, GREEN, "� Savininkas %s �sp�jo jus d�l %s, surinkote 3 �sp ir esate nu�alinamas nuo pareig�.", playerName[playerid], reason);

			pInfo[id][priziuretojas] = 0;
			pInfo[id][priziuretojausisp] = 0;

			UNBANPRIZ_INFO[prizvardas] = EOS;
			UNBANPRIZ_INFO[prizpareigosenuo] = EOS;
			UNBANPRIZ_INFO[prizisp] = 0;

			mysql_format(connectionHandle, query, 140, "UPDATE unban_priz SET prizisp = '0', vardas = '', prizpareigosenuo = ''");
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", \
				playerName[id]);
			mysql_tquery(connectionHandle, query, "SendQuery", "");
		}
		else
		{
			SendFormat(playerid, GREEN, "+ �sp�jote UNBAN pri�i�r�toj� %s d�l %s, dabar jis turi %i �sp�jimus", playerName[id], reason, pInfo[id][priziuretojausisp]);
			SendFormat(id, GREEN, "� Savininkas %s �sp�jo jus d�l %s, dabar turite %i �sp�jimus", playerName[playerid], reason, pInfo[id][priziuretojausisp]);
		}
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:ispetidpriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, reason[25];
		if(sscanf(params, "us[25]", id, reason)) return MSG(playerid, 0x00B8D8AA, "� �sp�ti direktori� pri�i�r�toj�: /ispetidpriz [Dalis vardo/ID][Priezatsis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, RED, "- Tokio �aid�jo n�ra");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
		if(pInfo[id][priziuretojas] != DPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra direktori� pri�i�r�tojas!");

		pInfo[id][priziuretojausisp] ++;
		DPRIZINFO[prizisp]++;

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
			GautiData(0), reason, playerName[playerid], playerName[id], 4);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 200, "INSERT INTO `dprizISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET prizisp = '%i' WHERE vardas = '%e'", \
			pInfo[id][priziuretojausisp], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE dpriz SET prizisp = '%i' WHERE vardas = '%e'", \
			pInfo[id][priziuretojausisp], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		if(pInfo[id][priziuretojausisp] >= 3)
		{
			SendFormat(playerid, GREEN, "+ �sp�jote direktori� pri�i�r�toj� %s d�l %s, jis surinko 3 �sp ir yra nu�alinamas nuo pareig�.", playerName[playerid], reason);

			SendFormat(id, GREEN, "� Savininkas %s �sp�jo jus d�l %s, surinkote 3 �sp ir esate nu�alinamas nuo pareig�.", playerName[playerid], reason);

			pInfo[id][priziuretojas] = 0;
			pInfo[id][priziuretojausisp] = 0;

			DPRIZINFO[prizvardas] = EOS;
			DPRIZINFO[prizpareigosenuo] = EOS;
			DPRIZINFO[prizisp] = 0;

			mysql_format(connectionHandle, query, 140, "UPDATE dpriz SET prizisp = '0', vardas = '', prizpareigosenuo = ''");
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", playerName[id]);
			mysql_tquery(connectionHandle, query, "SendQuery", "");
		}
		else
		{
			SendFormat(playerid, GREEN, "+ �sp�jote direktori� pri�i�r�toj� %s d�l %s, dabar jis turi %i �sp�jimus", playerName[id], reason, pInfo[id][priziuretojausisp]);
			SendFormat(id, GREEN, "� Savininkas %s �sp�jo jus d�l %s, dabar turite %i �sp�jimus", playerName[playerid], reason, pInfo[id][priziuretojausisp]);
		}
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:aispetioff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == ADMINPRIZIURETOJAS)
	{
		new Vardas[MAX_PLAYER_NAME], reason[25], id;
		if(sscanf(params, "s[24]s[25]", Vardas, reason)) return MSG(playerid, 0x00B8D8AA, "�sp�ti administratori� (OFFLINE): /aispetioff [Vardas_Pavard�][Priezastis]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, 0xFF0000AA, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 140, "SELECT admin, aisp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "aispeti_off", "iss", playerid, Vardas, reason);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function aispeti_off(playerid, name[], reason[])
{
	if(cache_num_rows() > 0)
	{
		new admin_id, admin_isp;
		cache_get_value_index_int(0, 0, admin_id);
		if(admin_id == 0) return MSG(playerid, RED, "- �aid�jas n�ra administratorius");
		cache_get_value_index_int(0, 1, admin_isp);

		admin_isp ++;

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
			GautiData(0), reason, playerName[playerid], name, 2);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 200, "INSERT INTO `AdminISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		if(admin_isp >= 3)
		{
			SendFormat(playerid, GREEN, "+ �sp�jote administratori� %s d�l %s jis surinko 3 �sp ir yra nu�alintas", name, reason);	

			mysql_format(connectionHandle, query, 144, "UPDATE zaidejai SET admin = '0', aisp = '0', AdminLaikas = '0'", name);
			mysql_tquery(connectionHandle, query, "SendQuery", "");
		}
		else
		{
			SendFormat(playerid, GREEN, "+ �sp�jote administratori� %s d�l %s, dabar jis turi %i �sp", name, reason, admin_isp);
		}
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra");
	return 1;
}

YCMD:ispetiunbanprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new Vardas[MAX_PLAYER_NAME], reason[25], id;
		if(sscanf(params, "s[24]s[25]", Vardas, reason)) return MSG(playerid, 0x00B8D8AA, "�sp�ti UNBAN pri�i�r�toj� (OFFLINE): /ispetiunbanprizoff [Vardas_Pavard�][Priezastis]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, 0xFF0000AA, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 140, "SELECT priziuretojas, prizisp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "ispetiunbanpriz_off", "iss", playerid, Vardas, reason);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function ispetiunbanpriz_off(playerid, name[], reason[])
{
	if(cache_num_rows() > 0)
	{
		new unbanpriz_id, unbanprizo_isp;

		cache_get_value_index_int(0, 0, unbanpriz_id);
		cache_get_value_index_int(0, 0, unbanprizo_isp);

		if(unbanpriz_id != UNBANPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra UNBAN pri�i�r�tojas");

		// 1 vip
		// 2 admin
		// 3 darbo
		// 4 dpriz
		// 5 drk
		// 6 vippriz
		// 7 adminpriz
		// 8 unbanpriz

		unbanprizo_isp ++;

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
			GautiData(0), reason, playerName[playerid], name, 8);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 200, "INSERT INTO `unbanprizISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 150, "UPDATE zaidejai SET prizisp = '%i' WHERE vardas = '%e'", unbanprizo_isp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 150, "UPDATE unban_priz SET prizisp = '%i' WHERE vardas = '%e'", unbanprizo_isp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		if(unbanprizo_isp >= 3)
		{
			SendFormat(playerid, GREEN, "+ �sp�jote UNBAN pri�i�r�toj� %s, d�l %s, jis surinko 3 �sp ir yra nu�alintas nuo pareig�!", name, reason);

			mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", name);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 140, "UPDATE unban_priz SET prizisp = '0', vardas = '', prizpareigosenuo = ''");
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			UNBANPRIZ_INFO[prizvardas] = EOS;
			UNBANPRIZ_INFO[prizpareigosenuo] = EOS;
			UNBANPRIZ_INFO[prizisp] = 0;
		}
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra!");
	return 1;
}

YCMD:ispetiaprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new Vardas[MAX_PLAYER_NAME], reason[25], id;
		if(sscanf(params, "s[24]s[25]", Vardas, reason)) return MSG(playerid, 0x00B8D8AA, "�sp�ti administratori� pri�i�r�toj� (OFFLINE): /ispetiaprizoff [Vardas_Pavard�][Priezastis]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, 0xFF0000AA, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 140, "SELECT priziuretojas, prizisp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "ispetiadminpriz_off", "iss", playerid, Vardas, reason);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function ispetiadminpriz_off(playerid, name[], reason)
{
	if(cache_num_rows() > 0)
	{
		new admin_prz, adminprizo_isp;

		cache_get_value_index_int(0, 0, admin_prz);
		cache_get_value_index_int(0, 0, adminprizo_isp);

		if(admin_prz == 0 || admin_prz != ADMINPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra administratori� pri�i�r�tojas");

		// 1 vip
		// 2 admin
		// 3 darbo
		// 4 dpriz
		// 5 drk
		// 6 vippriz
		// 7 adminpriz
		// 8 unbanpriz

		adminprizo_isp ++;

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
			GautiData(0), reason, playerName[playerid], name, 7);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 200, "INSERT INTO `adminprizISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 150, "UPDATE zaidejai SET prizisp = '%i' WHERE vardas = '%e'", \
			adminprizo_isp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 150, "UPDATE admin_priz SET prizisp = '%i' WHERE vardas = '%e'", \
			adminprizo_isp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		if(adminprizo_isp >= 3)
		{
			SendFormat(playerid, GREEN, "+ �sp�jote administratori� pri�i�r�toj� %s, d�l %s, jis surinko 3 �sp ir yra nu�alintas nuo pareig�!", name, reason);

			mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", name);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 140, "UPDATE admin_priz SET prizisp = '0', vardas = '', prizpareigosenuo = ''");
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			ADMINPRIZINFO[prizvardas] = EOS;
			ADMINPRIZINFO[prizpareigosenuo] = EOS;
			ADMINPRIZINFO[prizisp] = 0;
		}
		else
		{
			SendFormat(playerid, GREEN, "+ �sp�jote administratori� pri�i�r�toj� %s, d�l %s, dabar jis turi %i �sp.", name, reason, adminprizo_isp);
		}
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra");
	return 1;
}

YCMD:ispetivipprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new Vardas[MAX_PLAYER_NAME], reason[25], id;
		if(sscanf(params, "s[24]s[25]", Vardas, reason)) return MSG(playerid, 0x00B8D8AA, "�sp�ti VIP nari� pri�i�r�toj� (OFFLINE): /ispetivipprizoff [Vardas_Pavard�][Priezastis]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, 0xFF0000AA, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 140, "SELECT priziuretojas, prizisp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "ispetivippriz_off", "iss", playerid, Vardas, reason);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function ispetivippriz_off(playerid, name[], reason[])
{
	if(cache_num_rows() > 0)
	{
		new vip_prz, vipprizo_isp;

		cache_get_value_index_int(0, 0, vip_prz);
		cache_get_value_index_int(0, 0, vipprizo_isp);

		if(vip_prz == 0 || vip_prz != VIPPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra V.I.P pri�i�r�tojas");

		// 1 vip
		// 2 admin
		// 3 darbo
		// 4 dpriz
		// 5 drk
		// 6 vippriz
		// 7 adminpriz

		vipprizo_isp ++;

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
			GautiData(0), reason, playerName[playerid], name, 6);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 200, "INSERT INTO `VIPprizISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 150, "UPDATE zaidejai SET prizisp = '%i' WHERE vardas = '%e'", \
			vipprizo_isp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 150, "UPDATE vip_priz SET prizisp = '%i' WHERE vardas = '%e'", \
			vipprizo_isp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		if(vipprizo_isp >= 3)
		{
			SendFormat(playerid, GREEN, "+ �sp�jote V.I.P pri�i�r�toj� %s, d�l %s, jis surinko 3 �sp ir yra nu�alintas nuo pareig�!", name, reason);

			mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", name);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 140, "UPDATE vip_priz SET prizisp = '0', vardas = '', prizpareigosenuo = ''");
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			VIPPRIZINFO[prizvardas] = EOS;
			VIPPRIZINFO[prizpareigosenuo] = EOS;
			VIPPRIZINFO[prizisp] = 0;
		}
		else
		{
			SendFormat(playerid, GREEN, "+ �sp�jote V.I.P pri�i�r�toj� %s, d�l %s, dabar jis turi %i �sp.", name, reason, vipprizo_isp);
		}
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra!");
	return 1;
}

YCMD:ispetidprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new Vardas[MAX_PLAYER_NAME], reason[25], id;
		if(sscanf(params, "s[24]s[25]", Vardas, reason)) return MSG(playerid, 0x00B8D8AA, "�sp�ti direktori� pri�i�r�toj� (OFFLINE): /ispetidprizoff [Vardas_Pavard�][Priezastis]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, 0xFF0000AA, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 140, "SELECT priziuretojas, prizisp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "Ispetidprizaoff", "iss", playerid, Vardas, reason);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function Ispetidprizaoff(playerid, name[], reason[])
{
	if(cache_num_rows() > 0)
	{
		new dprizoisp, dprizas;

		cache_get_value_index_int(0, 0, dprizas);
		cache_get_value_index_int(0, 1, dprizoisp);

		if(dprizas == DPRIZIURETOJAS)
		{
			
			dprizoisp ++;

			mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
				GautiData(0), reason, playerName[playerid], name, 4);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 200, "INSERT INTO `dprizISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
				GautiData(0), reason, playerName[playerid], name);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET prizisp = '%i' WHERE vardas = '%e'", dprizoisp, name);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 140, "UPDATE dpriz SET prizisp = '%i' WHERE vardas = '%e'", dprizoisp, name);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			if(dprizoisp >= 3)
			{
				SendFormat(playerid, GREEN, "+ �sp�jote direktori� pri�i�r�toj� %s, d�l %s, jis surinko 3 �sp ir yra nu�alintas nuo pareig�!", name, reason);

				mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", name);
				mysql_tquery(connectionHandle, query, "SendQuery", "");

				mysql_format(connectionHandle, query, 140, "UPDATE dpriz SET prizisp = '0', vardas = '', prizpareigosenuo = ''");
				mysql_tquery(connectionHandle, query, "SendQuery", "");

				DPRIZINFO[prizvardas] = EOS;
				DPRIZINFO[prizpareigosenuo] = EOS;
				DPRIZINFO[prizisp] = 0;
			}
			else
			{
				SendFormat(playerid, GREEN, "+ �sp�jote direktori� pri�i�r�toj� %s, d�l %s, dabar jis turi %i �sp.", name, reason, dprizoisp);
			}
		}
		else return MSG(playerid, RED, "- �aid�jas n�ra direktori� pri�i�r�tojas!");
	} 
	else return MSG(playerid, RED, "- Tokio �aid�jo n�ra duomen� baz�je!");
	return 1;
}

YCMD:skirtidprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new Vardas[MAX_PLAYER_NAME], id;
		if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Skirti direktori� pri�i�r�tojumi (OFFLINE): /skirtidprizoff [Vardas_Pavard�]");
		if(!IsValidNickName(Vardas)) return MSG(playerid, RED, "- Neteisinga vardo forma. Turi atrodyti taip: Vardas_Pavard�");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, 0xFF0000AA, "- �aid�jas prisijung�s!");

		mysql_format(connectionHandle, query, 140, "SELECT priziuretojas FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "Skirtidprizaoff", "is", playerid, Vardas);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function Skirtidprizaoff(playerid, name[])
{
	if(cache_num_rows() > 0)
	{
		new dprizas;

		cache_get_value_index_int(0,0, dprizas);

		if(dprizas == 1) return MSG(playerid, RED, "- �aid�jas jau turi direktori� pri�i�r�tojaus status�!");
		if(!isnull(DPRIZINFO[prizvardas])) return MSG(playerid, RED, "- Direktori� pri�i�r�tojas jau i�rinktas");

		mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '3', prizpareigosenuo = '%s', prizisp = '0' WHERE vardas = '%e'", GautiData(0), name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE dpriz SET prizpareigosenuo = '%s', vardas = '%e'", GautiData(0), name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		SendFormat(playerid, GREEN, "+ Paskyr�te %s direktori� pri�i�r�tojumi", name);

		format(DPRIZINFO[prizvardas], 24, "%s", name);
		format(DPRIZINFO[prizpareigosenuo], 31, "%s", GautiData(0));
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra!");
	return 1;
}

YCMD:aispeti(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == ADMINPRIZIURETOJAS)
	{
		new id, reason[25];
		if(sscanf(params, "us[25]", id, reason)) return MSG(playerid, 0x00B8D8AA, "� �sp�ti administratori�: /aispeti [Dalis vardo/ID] [Prie�astis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000FF, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, 0xFF0000FF, "- �aid�jas neprisijung�s!");
		if(strlen(reason) > 24) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 24 simboliai");
		if(pInfo[id][ADMIN] == SAVININKAS || pInfo[id][ADMIN] == KOMANDOSNARIAI) return MSG(playerid, 0xFF0000FF, "- LERG Komandos negalite �sp�ti!");
		if(strlen(reason) <= 4) return MSG(playerid, RED, "- Prie�astis negali b�ti trumpesn� nei 5 simboliai");
		if(pInfo[id][ADMIN] == 0) return MSG(playerid, RED, "- �aid�jas n�ra administratorius!");
		if(pInfo[id][ADMIN] > 3) return MSG(playerid, RED, "- Negalite �sp�ti �aid�jo kuris yra LERG komandos narys");
		pInfo[id][aisp] += 1;

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
			GautiData(0), reason, playerName[playerid], playerName[id], 2);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
		
		mysql_format(connectionHandle, query, 200, "INSERT INTO `AdminISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		if(pInfo[id][aisp] >= 3)
		{
			SendFormat(playerid, GREEN, "� Administratorius %s �sp�tas d�l: %s, jis surinko tris �sp�jimus ir neb�ra administratoriu!", playerName[id], reason);
			pInfo[id][aisp] = 0;
			pInfo[id][ADMIN] = 0;
			pInfo[id][ADMIN] = 0;
			SendFormat(id, GREEN, "� Administracijos pri�i�r�tojas %s �sp�jo jus d�l: %s, surinkote tris �sp�jimus ir nebeesate administratorius!", playerName[playerid], reason);
			MSG(id, -1, "{ffd700}� Daugiau informacijos /priezastys");
			SetPlayerColor(id, DEFAULT_COLOR);
		}
		else if(pInfo[id][aisp] < 3)
		{
			SendFormat(playerid, GREEN, "+ Administratorius %s �sp�tas d�l: %s, dabar jis turi %i �sp�jimus", playerName[id], reason, pInfo[id][aisp]);
			SendFormat(id, GREEN, "+ Administracijos pri�i�r�tojas %s �sp�jo jus d�l: %s, dabar j�s turite %i �sp�jimus", playerName[playerid], reason, pInfo[id][aisp]);
			MSG(id, -1, "{ffd700}� Daugiau informacijos /priezastys");
		}
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:nuispvip(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == VIPPRIZIURETOJAS)
	{
		new id, priezastis[31];
		if(sscanf(params, "us[30]", id, priezastis)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� V.I.P nariui: /nuispvip [Dalis vardo/ID][Prie�astis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, RED, "- Tokio �aid�jo n�ra");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s!");
		if(pInfo[id][VIP] == 0) return MSG(playerid, 0xFF0000AA, "- �aid�jas n�ra administratorius!");
		if(pInfo[id][visp] == 0) return MSG(playerid, RED, "- V.I.P narys neturi �sp�jim�!");
		if(strlen(priezastis) > 30) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� negu 30 simboli�");

		SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� V.I.P nariui %s d�l %s", playerName[id], priezastis);

		if(pInfo[playerid][ADMIN] == SAVININKAS){SendFormat(id, GREEN, "� Savininkas %s nu�m� jums V.I.P nario �sp�jim� d�l %s", playerName[playerid], priezastis);}
		else if(pInfo[playerid][priziuretojas] == VIPPRIZIURETOJAS){SendFormat(id, GREEN, "� V.I.p pri�i�r�tojas %s nu�m� jums V.I.P nario �sp�jim� d�l %s", playerName[playerid], priezastis);}
		
		pInfo[id][visp]--;
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:nuispadmin(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == ADMINPRIZIURETOJAS)
	{
		new id, priezastis[31];
		if(sscanf(params, "us[30]", id, priezastis)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� administratoriui: /nuispadmin [Dalis vardo/ID][Prie�astis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, RED, "- Tokio �aid�jo n�ra");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s!");
		if(pInfo[id][ADMIN] == 0) return MSG(playerid, 0xFF0000AA, "- �aid�jas n�ra administratorius!");
		if(pInfo[id][aisp] == 0) return MSG(playerid, RED, "- Administratorius neturi �sp�jim�!");
		if(strlen(priezastis) > 30) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� negu 30 simboli�");

		SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� administratoriui %s d�l %s", playerName[id], priezastis);

		if(pInfo[playerid][ADMIN] == SAVININKAS){SendFormat(id, GREEN, "� Savininkas %s nu�m� jums administratoriaus �sp�jim� d�l %s", playerName[playerid], priezastis);}
		else if(pInfo[playerid][priziuretojas] == ADMINPRIZIURETOJAS){SendFormat(id, GREEN, "� Administratori� pri�i�r�tojas %s nu�m� jums administratoriaus �sp�jim� d�l %s", playerName[playerid], priezastis);}
		
		pInfo[id][aisp]--;

		// Do logs for nuimti �sp�jim�
	}	
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:nuispunbanpriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, priezastis[31];
		if(sscanf(params, "us[30]", id, priezastis)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� UNBAN pri�i�r�tojui: /nuispunbanpriz [Dalis vardo/ID][Prie�astis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, RED, "- Tokio �aid�jo n�ra");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s!");
		if(pInfo[id][priziuretojas] != UNBANPRIZIURETOJAS) return MSG(playerid, 0xFF0000AA, "- �aid�jas n�ra UNBAN pri�i�r�tojas!");
		if(pInfo[id][priziuretojausisp] == 0) return MSG(playerid, RED, "- UNBAN pri�i�r�tojas neturi �sp�jim�!");
		if(strlen(priezastis) > 30) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� negu 30 simboli�");

		SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� UNBAN pri�i�r�tojui %s d�l %s", playerName[id], priezastis);

		SendFormat(id, GREEN, "� Savininkas %s nu�m� jums UNBAN pri�i�r�tojaus �sp�jim� d�l %s", playerName[playerid], priezastis);
		
		pInfo[id][priziuretojausisp]--;

		// Do logs for nuimti �sp�jim�
	}	
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}


YCMD:nuispunbanprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, Vardas[MAX_PLAYER_NAME], priezastis[31];
		if(sscanf(params, "s[24]s[30]", Vardas, priezastis)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� atsijungusiam UNBAN pri�i�r�tojui: /nuispunbanprizoff [Dalis vardo/ID][Prie�astis]");
		if(strlen(priezastis) > 30) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 30 simboli�");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 180, "SELECT priziuretojas, prizisp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "nuispunbanpriz_off", "iss", playerid, Vardas, priezastis);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function nuispunbanpriz_off(playerid, name[], reason[])
{
	if(cache_num_rows() > 0)
	{
		new unbanpriz_id, unbanprizo_isp;
		cache_get_value_index_int(0, 0, unbanpriz_id);
		if(unbanpriz_id != UNBANPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra UNBAN pri�i�r�tojas");
		cache_get_value_index_int(0, 1, unbanprizo_isp);

		if(unbanprizo_isp == 0) return MSG(playerid, RED, "- �aid�jas neturi UNBAN pri�i�r�tojaus �sp�jim�");

		unbanprizo_isp--;

		SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� administratori� pri�i�r�tojui %s, d�l %s, dabar jis turi %i �sp�jimus(-�)", name, reason, unbanprizo_isp);

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET prizisp = '%i' WHERE vardas = '%e'", unbanprizo_isp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo n�ra duomen� baz�je");
	return 1;
}


YCMD:nuispapriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, priezastis[31];
		if(sscanf(params, "us[30]", id, priezastis)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� administratori� pri�i�r�tojui: /nuispapriz [Dalis vardo/ID][Prie�astis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, RED, "- Tokio �aid�jo n�ra");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s!");
		if(pInfo[id][priziuretojas] == ADMINPRIZIURETOJAS) return MSG(playerid, 0xFF0000AA, "- �aid�jas n�ra administratori� pri�i�r�tojas!");
		if(pInfo[id][priziuretojausisp] == 0) return MSG(playerid, RED, "- Administratori� pri�i�r�tojas neturi �sp�jim�!");
		if(strlen(priezastis) > 30) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� negu 30 simboli�");

		SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� administratori� pri�i�r�tojui %s d�l %s", playerName[id], priezastis);

		SendFormat(id, GREEN, "� Savininkas %s nu�m� jums administratoriaus �sp�jim� d�l %s", playerName[playerid], priezastis);
		
		pInfo[id][priziuretojausisp]--;

		// Do logs for nuimti �sp�jim�
	}	
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:nuispaprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, Vardas[MAX_PLAYER_NAME], priezastis[31];
		if(sscanf(params, "s[24]s[30]", Vardas, priezastis)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� atsijungusiam administratori� pri�i�r�tojui: /nuispaprizoff [Dalis vardo/ID][Prie�astis]");
		if(strlen(priezastis) > 30) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 30 simboli�");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 180, "SELECT priziuretojas, prizisp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "nuispadminpriz_off", "iss", playerid, Vardas, priezastis);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function nuispadminpriz_off(playerid, name[], reason[])
{
	if(cache_num_rows() > 0)
	{
		new adminpriz_id, adminpriz_isp;
		cache_get_value_index_int(0, 0, adminpriz_id);
		if(adminpriz_id == 0 || adminpriz_id != ADMINPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra administratori� pri�i�r�tojas");
		cache_get_value_index_int(0, 1, adminpriz_isp);

		if(adminpriz_isp == 0) return MSG(playerid, RED, "- �aid�jas neturi administratoriaus pri�i�r�tojaus �sp�jim�");

		adminpriz_isp--;

		SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� administratori� pri�i�r�tojui %s, d�l %s, dabar jis turi %i �sp�jimus(-�)", name, reason, adminpriz_isp);

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET prizisp = '%i' WHERE vardas = '%e'", adminpriz_isp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo n�ra duomen� baz�je");
	return 1;
}

YCMD:nuispvipoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == VIPPRIZIURETOJAS)
	{
		new id, Vardas[MAX_PLAYER_NAME], priezastis[31];
		if(sscanf(params, "s[24]s[30]", Vardas, priezastis)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� atsijungusiam V.I.P nariui: /nuispvipoff [Dalis vardo/ID][Prie�astis]");
		if(strlen(priezastis) > 30) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 30 simboli�");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 180, "SELECT vip, visp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "OnNuispAdminOff", "iss", playerid, Vardas, priezastis);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function OnNuispAdminOff(playerid, name[], reason[])
{
	if(cache_num_rows() > 0)
	{
		new vip_id, vip_isp;
		cache_get_value_index_int(0, 0, vip_id);
		if(vip_id == 0) return MSG(playerid, RED, "- �aid�jas n�ra V.I.P narys");
		cache_get_value_index_int(0, 1, vip_isp);

		if(vip_isp == 0) return MSG(playerid, RED, "- �aid�jas neturi V.I.P nario �sp�jim�");

		vip_isp--;

		SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� V.I.P nariui %s, d�l %s, dabar jis turi %i �sp�jimus(-�)", name, reason, vip_isp);

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET visp = '%i' WHERE vardas = '%e'", vip_isp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		// Do logs for nuimti ispejima
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra");
	return 1;
}

YCMD:nuispadminoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == ADMINPRIZIURETOJAS)
	{
		new id, Vardas[MAX_PLAYER_NAME], priezastis[31];
		if(sscanf(params, "s[24]s[30]", Vardas, priezastis)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� atsijungusiam administratoriui: /nuispadminoff [Dalis vardo/ID][Prie�astis]");
		if(strlen(priezastis) > 30) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 30 simboli�");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 180, "SELECT admin, aisp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "nuispadmin_off", "iss", playerid, Vardas, priezastis);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function nuispadmin_off(playerid, name[], reason[])
{
	if(cache_num_rows() > 0)
	{
		new admin_id, admin_isp;
		cache_get_value_index_int(0, 0, admin_id);
		if(admin_id == 0) return MSG(playerid, RED, "- �aid�jas n�ra administratorius");
		cache_get_value_index_int(0, 1, admin_isp);

		if(admin_isp == 0) return MSG(playerid, RED, "- �aid�jas neturi administratoriaus �sp�jim�");

		admin_isp--;

		SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� administratoriui %s, d�l %s, dabar jis turi %i �sp�jimus(-�)", name, reason, admin_isp);

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET aisp = '%i' WHERE vardas = '%e'", admin_isp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		// Do logs for nuimti ispejima
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra");
	return 1;
}


YCMD:nuispvippriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� V.I.P pri�i�r�tojui: /nuispvippriz [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, RED, "- Tokio �aid�jo n�ra");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s!");
		if(pInfo[id][priziuretojas] != VIPPRIZIURETOJAS) return MSG(playerid, 0xFF0000AA, "- �aid�jas n�ra V.I.P pri�i�r�tojas!");
		if(pInfo[id][priziuretojausisp] == 0) return MSG(playerid, RED, "- V.I.P pri�i�r�tojas neturi �sp�jim�!");

		SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� V.I.P pri�i�r�tojui %s", playerName[id]);

		SendFormat(id, GREEN, "� Savininkas %s nu�m� jums V.I.P pri�i�r�tojaus �sp�jim�", playerName[playerid]);
		
		pInfo[id][priziuretojausisp]--;

		mysql_format(connectionHandle, query, 140, "UPDATE vip_priz SET prizisp = '%i' WHERE vardas = '%e'", pInfo[id][priziuretojausisp], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", ""); 
	}	
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:nuispvipprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, Vardas[MAX_PLAYER_NAME];
		if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� atsijungusiam V.I.P pri�i�r�tojui: /nuispvipprizoff [Vardas_Pavard�]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 180, "SELECT priziuretojas, prizisp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "nuispvippriz_off", "is", playerid, Vardas);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function nuispvippriz_off(playerid, name[])
{
	new vippriz_id, vippriz_isp;
	cache_get_value_index_int(0, 0, vippriz_id);
	if(vippriz_id == 0 || vippriz_id != VIPPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra V.I.P pri�i�r�tojas");

	cache_get_value_index_int(0, 1, vippriz_isp);

	if(vippriz_isp == 0) return MSG(playerid, RED, "- V.I.P pri�i�r�tojas neturi �sp�jim�");

	vippriz_isp--;

	SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� V.I.P pri�i�r�tojui %s, dabar jis turi %i �sp�jimus(-�)", name, vippriz_isp);

	mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET prizisp = '%i' WHERE vardas = '%e'", vippriz_isp, name);
	mysql_tquery(connectionHandle, query, "SendQuery", ""); 

	mysql_format(connectionHandle, query, 140, "UPDATE vip_priz SET prizisp = '%i' WHERE vardas = '%e'", vippriz_isp, name);
	mysql_tquery(connectionHandle, query, "SendQuery", ""); 
	return 1;
}

YCMD:ispetivippriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, reason[25];
		if(sscanf(params, "us[25]", id, reason)) return MSG(playerid, 0x00B8D8AA, "� �sp�ti V.I.P pri�i�r�toj�: /ispetivippriz [Dalis vardo/ID] [Prie�astis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000FF, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, 0xFF0000FF, "- �aid�jas neprisijung�s!");
		if(strlen(reason) > 24) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 24 simboliai");
		if(pInfo[id][ADMIN] == SAVININKAS || pInfo[id][ADMIN] == KOMANDOSNARIAI) return MSG(playerid, 0xFF0000FF, "- LERG Komandos negalite �sp�ti!");
		if(strlen(reason) <= 4) return MSG(playerid, RED, "- Prie�astis negali b�ti trumpesn� nei 5 simboliai");
		if(pInfo[id][priziuretojas] != VIPPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra V.I.P pri�i�r�tojas!");

		pInfo[id][priziuretojausisp] += 1;

		
		// 1 vip
		// 2 admin
		// 3 darbo
		// 4 dpriz
		// 5 drk
		// 6 vippriz
		// 7 adminpriz
		// 8 unbanpriz

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
			GautiData(0), reason, playerName[playerid], playerName[id], 6);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
		
		mysql_format(connectionHandle, query, 200, "INSERT INTO `VIPprizISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		
		mysql_format(connectionHandle, query, 140, "UPDATE vip_priz SET prizisp = '%i' WHERE vardas = '%e'", \
			pInfo[id][priziuretojausisp], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", ""); 


		if(pInfo[id][priziuretojausisp] >= 3)
		{
			SendFormat(playerid, GREEN, "� V.I.P pri�i�r�tojas %s �sp�tas d�l: %s, jis surinko tris �sp�jimus ir neb�ra pri�i�r�tojas!", playerName[id], reason);
			pInfo[id][priziuretojausisp] = 0;
			pInfo[id][priziuretojas] = 0;

			VIPPRIZINFO[prizvardas] = EOS;
			VIPPRIZINFO[prizpareigosenuo] = EOS;
			VIPPRIZINFO[prizisp] = 0;

			SendFormat(id, GREEN, "� Savininkas %s �sp�jo jus d�l: %s, surinkote tris �sp�jimus ir nebeesate pri�i�r�tojas!", playerName[playerid], reason);
			MSG(id, -1, "{ffd700}� Daugiau informacijos /priezastys");
			SetPlayerColor(id, DEFAULT_COLOR);

			mysql_format(connectionHandle, query, 140, "UPDATE vip_priz SET prizpareigosenuo = '%s', prizisp = '0', vardas = '' WHERE vardas = '%e'", \
				pInfo[id][prizpareigosenuo], playerName[id]);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", playerName[id]);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

		}
		else if(pInfo[id][priziuretojausisp] < 3)
		{
			SendFormat(playerid, GREEN, "+ Pri�i�r�tojas %s �sp�tas d�l: %s, dabar jis turi %i �sp�jimus", playerName[id], reason, pInfo[id][priziuretojausisp]);
			SendFormat(id, GREEN, "+ Savininkas %s �sp�jo jus d�l: %s, dabar j�s turite %i �sp�jimus", playerName[playerid], reason, pInfo[id][priziuretojausisp]);
			MSG(id, -1, "{ffd700}� Daugiau informacijos /priezastys");
		}
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:ispetiapriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, reason[25];
		if(sscanf(params, "us[25]", id, reason)) return MSG(playerid, 0x00B8D8AA, "� �sp�ti ADMIN pri�i�r�toj�: /ispetiapriz [Dalis vardo/ID] [Prie�astis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000FF, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, 0xFF0000FF, "- �aid�jas neprisijung�s!");
		if(strlen(reason) > 24) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 24 simboliai");
		if(pInfo[id][ADMIN] == SAVININKAS || pInfo[id][ADMIN] == KOMANDOSNARIAI) return MSG(playerid, 0xFF0000FF, "- LERG Komandos negalite �sp�ti!");
		if(strlen(reason) <= 4) return MSG(playerid, RED, "- Prie�astis negali b�ti trumpesn� nei 4 simboliai");
		if(pInfo[id][priziuretojas] != ADMINPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra administratori� pri�i�r�tojas!");

		pInfo[id][priziuretojausisp] += 1;

		
		// 1 vip
		// 2 admin
		// 3 darbo
		// 4 dpriz
		// 5 drk
		// 6 vippriz
		// 7 adminpriz
		// 8 unbanpriz

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
			GautiData(0), reason, playerName[playerid], playerName[id], 7);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
		
		mysql_format(connectionHandle, query, 200, "INSERT INTO `adminprizISP_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		
		mysql_format(connectionHandle, query, 140, "UPDATE admin_priz SET prizisp = '%i' WHERE vardas = '%e'", \
			pInfo[id][priziuretojausisp], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", ""); 


		if(pInfo[id][priziuretojausisp] >= 3)
		{
			SendFormat(playerid, GREEN, "� Administratori� pri�i�r�tojas %s �sp�tas d�l: %s, jis surinko tris �sp�jimus ir neb�ra pri�i�r�tojas!", playerName[id], reason);
			pInfo[id][priziuretojausisp] = 0;
			pInfo[id][priziuretojas] = 0;

			ADMINPRIZINFO[prizvardas] = EOS;
			ADMINPRIZINFO[prizpareigosenuo] = EOS;
			ADMINPRIZINFO[prizisp] = 0;

			SendFormat(id, GREEN, "� Savininkas %s �sp�jo jus d�l: %s, surinkote tris �sp�jimus ir nebeesate pri�i�r�tojas!", playerName[playerid], reason);
			MSG(id, -1, "{ffd700}� Daugiau informacijos /priezastys");
			SetPlayerColor(id, DEFAULT_COLOR);

			mysql_format(connectionHandle, query, 140, "UPDATE admin_priz SET prizpareigosenuo = '%s', prizisp = '0', vardas = '' WHERE vardas = '%e'", \
				pInfo[id][prizpareigosenuo], playerName[id]);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", playerName[id]);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

		}
		else if(pInfo[id][priziuretojausisp] < 3)
		{
			SendFormat(playerid, GREEN, "+ Pri�i�r�tojas %s �sp�tas d�l: %s, dabar jis turi %i �sp�jimus", playerName[id], reason, pInfo[id][priziuretojausisp]);
			SendFormat(id, GREEN, "+ Savininkas %s �sp�jo jus d�l: %s, dabar j�s turite %i �sp�jimus", playerName[playerid], reason, pInfo[id][priziuretojausisp]);
			MSG(id, -1, "{ffd700}� Daugiau informacijos /priezastys");
		}
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:atsisakytidrk(playerid, params[], help)
{
	new reason[30];
	if(sscanf(params, "s[30]", reason)) return MSG(playerid, 0x00B8D8AA, "� Atsisakyti direktoriaus: /atsisakytidrk [Prie�astis] (MAX 30 simboli�)");
	if(pInfo[playerid][direktorius] == 0) return MSG(playerid, RED, "- J�s nesate direktorius!");

	if(strlen(reason) > 30 || strlen(reason) < 4) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 30 simboli� ir trumpesn� nei 4 simboliai!");

	foreach(new i : Player)
	{
		if(pInfo[i][darbas] == pInfo[playerid][direktorius])
		{
			pInfo[i][darbas] = 0;
			pInfo[i][uniforma] = 0;
			pInfo[i][wUniform] = 0;
			pInfo[i][workingSince] = EOS;
			SetPlayerSkin(i, pInfo[i][skin]);
			if(i != playerid) MSG(i, GREEN, "� Esate i�mesti i� darbo, d�l to, nes direktorius nu�alintas nuo pareig�!");
		}
	}

	mysql_format(connectionHandle, query, 144, "UPDATE zaidejai SET darbas = '0', wUniform = '0', uniforma = '0', isidarbino = '' WHERE darbas = '%i'", pInfo[playerid][direktorius]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 140, "UPDATE darbai SET drk = '', drkpareigosenuo = '', drkisp = '0' WHERE jobID = '%i'", pInfo[playerid][direktorius]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	new DarboPav[50];
	switch(pInfo[playerid][direktorius])
	{
		case MEDIKAI: DarboPav = "Medik� direktoriaus";
		case POLICININKAI: DarboPav = "Policijos generalinio komisaro";
		case ARMIJA: DarboPav = "Armijos generolo";
	}

	SendFormatToAll(-1, "{ffffff}Direktorius {F9BB85}%s {ffffff}atsisak� {F9BB85}%s{ffffff} pareig�", playerName[playerid], DarboPav);
	SendFormatToAll(-1, "{ffffff}Prie�astis: {F9BB85}%s{ffffff} | Pareigose buvo nuo: {F9BB85}%s{ffffff} | Tur�jo {F9BB85}%i{ffffff} �sp�jimus(-�)", reason, DarboInfo[pInfo[playerid][direktorius]][drkpareigosenuo], DarboInfo[pInfo[playerid][direktorius]][drkisp]);

	DarboInfo[pInfo[playerid][direktorius]][drk] = EOS;
	DarboInfo[pInfo[playerid][direktorius]][drkpareigosenuo] = EOS;
	DarboInfo[pInfo[playerid][direktorius]][drkisp] = 0;

	pInfo[playerid][direktorius] = 0;
	pInfo[playerid][disp] = 0;

	return 1;
}

YCMD:atsisakytidpriz(playerid, params[], help)
{
	new reason[30];
	if(sscanf(params, "s[30]", reason)) return MSG(playerid, 0x00B8D8AA, "� Atsisakyti direktori� pri�i�r�tojaus: /atsisakytidpriz [Prie�astis] (MAX 30 simboli�)");
	if(pInfo[playerid][priziuretojas] != DPRIZIURETOJAS) return MSG(playerid, RED, "- J�s nesate direktori� pri�i�r�tojas");

	if(strlen(reason) > 30 || strlen(reason) < 4) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 30 simboli� ir trumpesn� nei 4 simboliai!");

	mysql_format(connectionHandle, query, 140, "UPDATE dpriz SET vardas = '', prizpareigosenuo = '', prizisp = '0'");
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	SendFormatToAll(-1, "{ffffff}Direktori� pri�i�r�tojas {F9BB85}%s {ffffff}atsisak� {F9BB85}pareig�", playerName[playerid]);
	SendFormatToAll(-1, "{ffffff}Prie�astis: {F9BB85}%s{ffffff} | Pareigose buvo nuo: {F9BB85}%s{ffffff} | Tur�jo {F9BB85}%i{ffffff} �sp�jimus(-�)", reason, DPRIZINFO[prizpareigosenuo], DPRIZINFO[prizisp]);

	DPRIZINFO[prizvardas] = EOS;
	DPRIZINFO[prizpareigosenuo] = EOS;
	DPRIZINFO[prizisp] = 0;

	pInfo[playerid][priziuretojas] = 0;
	pInfo[playerid][priziuretojausisp] = 0;
	return 1;
}

YCMD:atsisakytivpriz(playerid, params[], help)
{
	new reason[30];
	if(sscanf(params, "s[30]", reason)) return MSG(playerid, 0x00B8D8AA, "� Atsisakyti V.I.P nari� pri�i�r�tojaus: /atsisakytivpriz [Prie�astis] (MAX 30 simboli�)");
	if(pInfo[playerid][priziuretojas] != VIPPRIZIURETOJAS) return MSG(playerid, RED, "- J�s nesate V.I.P pri�i�r�tojas");

	if(strlen(reason) > 30 || strlen(reason) < 4) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 30 simboli� ir trumpesn� nei 4 simboliai!");

	mysql_format(connectionHandle, query, 140, "UPDATE vip_priz SET vardas = '', prizpareigosenuo = '', prizisp = '0'");
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	SendFormatToAll(-1, "{ffffff}V.I.P nari� pri�i�r�tojas {F9BB85}%s {ffffff}atsisak� {F9BB85}pareig�", playerName[playerid]);
	SendFormatToAll(-1, "{ffffff}Prie�astis: {F9BB85}%s{ffffff} | Pareigose buvo nuo: {F9BB85}%s{ffffff} | Tur�jo {F9BB85}%i{ffffff} �sp�jimus(-�)", reason, VIPPRIZINFO[prizpareigosenuo], VIPPRIZINFO[prizisp]);

	VIPPRIZINFO[prizvardas] = EOS;
	VIPPRIZINFO[prizpareigosenuo] = EOS;
	VIPPRIZINFO[prizisp] = 0;

	pInfo[playerid][priziuretojas] = 0;
	pInfo[playerid][priziuretojausisp] = 0;
	return 1;
}

YCMD:atsisakytiadminpriz(playerid, params[], help)
{
	new reason[30];
	if(sscanf(params, "s[30]", reason)) return MSG(playerid, 0x00B8D8AA, "� Atsisakyti administratori� pri�i�r�tojaus: /atsisakytiadminpriz [Prie�astis] (MAX 30 simboli�)");
	if(pInfo[playerid][priziuretojas] != ADMINPRIZIURETOJAS) return MSG(playerid, RED, "- J�s nesate administratori� pri�i�r�tojas");

	if(strlen(reason) > 30 || strlen(reason) < 4) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 30 simboli� ir trumpesn� nei 4 simboliai!");

	mysql_format(connectionHandle, query, 140, "UPDATE admin_priz SET vardas = '', prizpareigosenuo = '', prizisp = '0'");
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	SendFormatToAll(-1, "{ffffff}Administratori� pri�i�r�tojas {F9BB85}%s {ffffff}atsisak� {F9BB85}pareig�", playerName[playerid]);
	SendFormatToAll(-1, "{ffffff}Prie�astis: {F9BB85}%s{ffffff} | Pareigose buvo nuo: {F9BB85}%s{ffffff} | Tur�jo {F9BB85}%i{ffffff} �sp�jimus(-�)", reason, ADMINPRIZINFO[prizpareigosenuo], ADMINPRIZINFO[prizisp]);

	ADMINPRIZINFO[prizvardas] = EOS;
	ADMINPRIZINFO[prizpareigosenuo] = EOS;
	ADMINPRIZINFO[prizisp] = 0;

	pInfo[playerid][priziuretojas] = 0;
	pInfo[playerid][priziuretojausisp] = 0;
	return 1;
}

YCMD:atsisakytiunbanpriz(playerid, params[], help)
{
	new reason[30];
	if(sscanf(params, "s[30]", reason)) return MSG(playerid, 0x00B8D8AA, "� Atsisakyti UNBAN pri�i�r�tojaus: /atsisakytiunbanpriz [Prie�astis] (MAX 30 simboli�)");
	if(pInfo[playerid][priziuretojas] != UNBANPRIZIURETOJAS) return MSG(playerid, RED, "- J�s nesate UNBAN pri�i�r�tojas");

	if(strlen(reason) > 30 || strlen(reason) < 4) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 30 simboli� ir trumpesn� nei 4 simboliai!");

	mysql_format(connectionHandle, query, 140, "UPDATE unban_priz SET vardas = '', prizpareigosenuo = '', prizisp = '0'");
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	SendFormatToAll(-1, "{ffffff}UNBAN pri�i�r�tojas {F9BB85}%s {ffffff}atsisak� {F9BB85}pareig�", playerName[playerid]);
	SendFormatToAll(-1, "{ffffff}Prie�astis: {F9BB85}%s{ffffff} | Pareigose buvo nuo: {F9BB85}%s{ffffff} | Tur�jo {F9BB85}%i{ffffff} �sp�jimus(-�)", reason, UNBANPRIZ_INFO[prizpareigosenuo], UNBANPRIZ_INFO[prizisp]);

	UNBANPRIZ_INFO[prizvardas] = EOS;
	UNBANPRIZ_INFO[prizpareigosenuo] = EOS;
	UNBANPRIZ_INFO[prizisp] = 0;

	pInfo[playerid][priziuretojas] = 0;
	pInfo[playerid][priziuretojausisp] = 0;
	return 1;
}

YCMD:skirtivipprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] != SAVININKAS) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");

	new id, Vardas[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Skirti VIP pri�i�r�tojumi (OFFLINE): /skirtivipprizoff [Vardas_Pavard�]");

	id = GetPlayeridMid(Vardas);

	if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");
	if(!IsValidNickName(Vardas)) return MSG(playerid, RED, "- Netinkama vardo forma. Tinkama vardo forma: Vardas_Pavarde");

	mysql_format(connectionHandle, query, 140, "SELECT priziuretojas FROM zaidejai WHERE vardas = '%e'", Vardas);
	mysql_tquery(connectionHandle, query, "OnSkirtivipprizoff", "is", playerid, Vardas);

	return 1;
}

YCMD:skirtiadminprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] != SAVININKAS) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");

	new id, Vardas[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Skirti administratori� pri�i�r�tojumi (OFFLINE): /skirtiadminprizoff [Vardas_Pavard�]");

	id = GetPlayeridMid(Vardas);

	if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");
	if(!IsValidNickName(Vardas)) return MSG(playerid, RED, "- Netinkama vardo forma. Tinkama vardo forma: Vardas_Pavarde");

	mysql_format(connectionHandle, query, 140, "SELECT priziuretojas FROM zaidejai WHERE vardas = '%e'", Vardas);
	mysql_tquery(connectionHandle, query, "OnSkirtiadminprizoff", "is", playerid, Vardas);

	return 1;
}

YCMD:nedirba(playerid, params[], help)
{
	if(DarboInfo[1][dirba] && DarboInfo[2][dirba]) return MSG(playerid, RED, "- Visi darbai �iuo metu dirba!");

	new fstr[1000], str[200];

	for(new i = 1; i < MAX_DARBU; i++)
	{
		switch(i)
		{
			case 1:
			{
				if(!DarboInfo[1][dirba])
				{
					format(str, sizeof(str), "{9FACF3}�{ffffff} Medikai nedirbs iki {9FACF3}%s\n\n", date(DarboInfo[MEDIKAI][nedirbsiki]));
					strcat(fstr, str);
				}
			}
			case 2:
			{
				if(!DarboInfo[2][dirba])
				{
					format(str, sizeof(str), "{9FACF3}�{ffffff} Policijos departamentas nedirbs iki {9FACF3}%s", date(DarboInfo[POLICININKAI][nedirbsiki]));
					strcat(fstr, str);
				}
			}
			case 3:
			{
				if(!DarboInfo[3][dirba])
				{
					format(str, sizeof(str), "{9FACF3}�{ffffff} Armija nedirbs iki {9FACF3}%s", date(DarboInfo[ARMIJA][nedirbsiki]));
					strcat(fstr, str);
				}
			}
		}
	}
	ShowPlayerDialog(playerid, nedirbantys, DIALOG_STYLE_MSGBOX, "Nedirbantys darbai", fstr, "Supratau", "");
	return 1;
}


function OnSkirtiadminprizoff(playerid, name[])
{
	if(cache_num_rows() > 0)	
	{
		new isadminpriz;
		cache_get_value_index_int(0,0, isadminpriz);

		if(isadminpriz == ADMINPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas jau administratori� pri�i�r�tojas");
		if(isadminpriz > 0 || isadminpriz != ADMINPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas jau yra pri�i�r�tojas");

		mysql_format(connectionHandle, query, 144, "UPDATE zaidejai SET priziuretojas = '2', prizisp = '0', prizpareigosenuo = '%s' WHERE vardas = '%e'", GautiData(0), name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE admin_priz SET prizpareigosenuo = '%s', prizisp = '0', vardas = '%e'", GautiData(0), name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		SendFormat(playerid, GREEN, "+ Paskyr�te %s administratori� pri�i�r�tojumi", name);
	}	
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra!");
	return 1;
}

function OnSkirtivipprizoff(playerid, name[])
{
	if(cache_num_rows() > 0)
	{	
		new isvippriz;
		cache_get_value_index_int(0,0, isvippriz);

		if(isvippriz == VIPPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas jau VIP pri�i�r�tojas");

		mysql_format(connectionHandle, query, 144, "UPDATE zaidejai SET priziuretojas = '1', prizisp = '0', prizpareigosenuo = '%s' WHERE vardas = '%e'", GautiData(0), name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
		
		mysql_format(connectionHandle, query, 140, "UPDATE admin_priz SET prizpareigosenuo = '%s', prizisp = '0', vardas = '%e'", GautiData(0), name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		SendFormat(playerid, GREEN, "+ Paskyr�te %s VIP pri�i�r�tojumi", name);
	}	
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra!");
	return 1;
}

YCMD:boom(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] > 0)
	{
		if(!IsPlayerInAnyVehicle(playerid)) return MSG(playerid, RED, "- Privalote b�ti tr. priemon�je");

		new vehicleid = GetPlayerVehicleID(playerid);

		RemovePlayerFromVehicle(playerid);
		SetVehicleHealth(vehicleid, 0);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:sunaikinti(playerid, params[], help)
{
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF0000AA, "� Kad sunaikintum�t automobil�, turite b�ti jame!");
	if(pInfo[playerid][darbas] == 0) return SendClientMessage(playerid, 0xFF0000AA, "- J�s bedarbis!");
	new vehicleid = GetPlayerVehicleID(playerid);
	new model = GetVehicleModel(vehicleid);
	#pragma unused model //kolkas nenaudosim

	switch(pInfo[playerid][darbas])
	{
		case MEDIKAI:
		{
			if(vehicleid == sizeof(medikucar))
			{
				SetTimerEx("ResetJobCar", 3000, false, "ii", playerid, vehicleid);
				MSG(playerid, -1, "{f49e42}Darbin� transporto priemon� susinaikins po 3 sek, jeigu joje nieko nebus!");
				RemovePlayerFromVehicle(playerid);
			}
			else return MSG(playerid, RED, "- �is automobilis n�ra darbinis!");
		}
		case POLICININKAI:
		{
			if(vehicleid == sizeof(pdcar))
			{
				SetTimerEx("ResetJobCar", 3000, false, "ii", playerid, vehicleid);
				MSG(playerid, -1, "{f49e42}Darbin� transporto priemon� susinaikins po 3 sek, jeigu joje nieko nebus!");
				RemovePlayerFromVehicle(playerid);
			}
			else return MSG(playerid, RED, "- �is automobilis n�ra darbinis!");
		}
		case ARMIJA:
		{
			if(vehicleid == sizeof(armijoscar))
			{
				SetTimerEx("ResetJobCar", 3000, false, "ii", playerid, vehicleid);
				MSG(playerid, -1, "{f49e42}Darbin� transporto priemon� susinaikins po 3 sek, jeigu joje nieko nebus!");
				RemovePlayerFromVehicle(playerid);
			}
			else return MSG(playerid, RED, "- �is automobilis n�ra darbinis!");
		}
		default: return MSG(playerid, RED, "- J�s neturite darbo!");
	}
	return 1;
}

YCMD:dkomandos(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][direktorius] > 0)
	{
		new list[1000];
		strcat(list, "\t{CF9F94}Direktoriaus komandos\n\n{CF9F94}/d{ffffff} - skelbti prane�im� vie�ai\n{CF9F94}/nepaememin{ffffff} - nepa�minusi� darbuotoj� dienos minimalaus reikalavimo s�ra�as");
		strcat(list, "\n{CF9F94}/atsisakytidrk{ffffff} - atsisakyti direktoriaus pareig�\n{CF9F94}/dvp{ffffff} - direktoriaus valdymo panel�\n{CF9F94}/dpzu{ffffff} - steb�ti darbuotoj�\n{CF9F94}/darboinfo{ffffff} - darbo informacija");
		ShowPlayerDialog(playerid, drkkomandos, DIALOG_STYLE_MSGBOX, "{ffffff}Direktoriaus komandos", list, "Supratau", "");
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}


YCMD:akomandos(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][ADMIN] > 0)
	{
		new list[1000];

		strcat(list, "\t{CF9F94}I lygio komandos\n\n{CF9F94}/s{ffffff} - prane�ti vie�ai\n{CF9F94}/ac{ffffff} - administratori� chat'as\n{CF9F94}/to{ffffff} - atsiteleportuoti pas �aid�j�\n{CF9F94}/bausti{ffffff} - u�tildyti �aid�ja\n{CF9F94}/unmute{ffffff} - atitildyti �aid�ja\n{CF9F94}/pzu{ffffff} - steb�ti �aid�ja\n{CF9F94}/padeti{ffffff} - pad�ti �aid�jui\n{CF9F94}/boom{ffffff} - sunaikinti automobil�");
		strcat(list, "\n\n\t{CF9F94}II lygio komandos\n\n{CF9F94}/get{ffffff} - atiteleportuoti �aid�j� pas save\n{CF9F94}/takew{ffffff} - atimti ginklus\n{CF9F94}/bausti{ffffff} - �aid�jo baudimas\n{CF9F94}/uzsaldyti{ffffff} - u��aldyti �aid�j�\n{CF9F94}/atsaldyti{ffffff} - at�aldyti �aid�j�\n{CF9F94}/padeti{ffffff} - pad�ti �aid�jui");
		strcat(list, "\n\n\t{CF9F94}III lygio komandos\n\n{CF9F94}/padeti{ffffff} - pad�ti �aid�jui\n{CF9F94}/bausti{ffffff} - �aid�jo baudimas\n{CF9F94}/kill{ffffff} - nu�udyti �aid�ja");

		inline akomandos(pid, did, resp, litem, input[])
		{
			#pragma unused pid, did, resp, litem, input
		}
		Dialog_ShowCallback(playerid, using inline akomandos, DIALOG_STYLE_MSGBOX, "{ffffff}Administratori� komandos", list, "Supratau", "");
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:pskelbti(playerid, params[], help)
{
	if(pInfo[playerid][priziuretojas] == 0) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");

	new msg[110];
	
	if(sscanf(params, "s[110]", msg)) return MSG(playerid, 0x00B8D8AA, "� Skelbti pri�i�r�tojaus prane�im�: /pskelbti [Tekstas]");

	if(pInfo[playerid][prizskelbti] > gettime()) return MSG(playerid, RED, "- Skelbti prane�im� galite tik kas 5 minutes!");

	if(pInfo[playerid][priziuretojas] == ADMINPRIZIURETOJAS){SendFormatToAll(-1, "{05c54e}Administratori� pri�i�r�tojas {67ab04}%s(%i){05c54e}: %s", playerName[playerid], playerid, msg);}
	else if(pInfo[playerid][priziuretojas] == VIPPRIZIURETOJAS){SendFormatToAll(-1, "{05c54e}VIP nari� pri�i�r�tojas {67ab04}%s(%i){05c54e}: %s", playerName[playerid], playerid, msg);}
	else if(pInfo[playerid][priziuretojas] == DPRIZIURETOJAS) {SendFormatToAll(-1, "{05c54e}Direktori� pri�i�r�tojas {67ab04}%s(%i){05c54e}: %s", playerName[playerid], playerid, msg);}
	else if(pInfo[playerid][priziuretojas] == UNBANPRIZIURETOJAS){SendFormatToAll(-1, "{05c54e}UNBAN pri�i�r�tojas {67ab04}%s(%i){05c54e}: %s", playerName[playerid], playerid, msg);}
	pInfo[playerid][prizskelbti] = gettime() + 300; // 5min

	return 1;
}


YCMD:s(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][ADMIN] > 0)
	{
		new msg[110];
		if(pInfo[playerid][Muted] > 0)
		{
			SendFormat(playerid, 0xFF0000AA, "- J�s u�tildytas, kalb�ti gal�site po: %s", \
			ConvertSeconds(pInfo[playerid][Muted] - gettime()));
			return 1;
		}
		if(sscanf(params, "s[110]", msg)){MSG(playerid, 0x00B8D8AA, "� Skelbti prane�im�: /s [Tekstas]");}
		else
		{
			if(pInfo[playerid][CmdAdminTimerSkelbti] > gettime() && pInfo[playerid][ADMIN] < SAVININKAS) return SendFormat(playerid, 0xFF0000AA, "- Administracijos chante galite skelbti kas 5min, v�l gal�site paskelpti po %s", ConvertSeconds(pInfo[playerid][CmdAdminTimerSkelbti] - gettime()));
        	pInfo[playerid][CmdAdminTimerSkelbti] = gettime() + 300;//5min
			if(pInfo[playerid][ADMIN] > 0 && pInfo[playerid][ADMIN] < SAVININKAS){SendFormatToAll(-1, "{05c54e}Administratorius {67ab04}%s(%i){05c54e}: {05c54e}%s", playerName[playerid], playerid, msg);}

			else if(pInfo[playerid][ADMIN] == SAVININKAS){SendFormatToAll(-1, "{05c54e}Savininkas {67ab04}%s(%i){05c54e}: {05c54e}%s", playerName[playerid], playerid, msg);}
		}
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:spygliai(playerid, params[], help)
{
	if(IsJobFromLaw(pInfo[playerid][darbas]))
	{
		switch(SpygliaiInfo[playerid][arPadeti])
		{
			case true:
			{
				GameTextForPlayer(playerid, "~r~SPYGLIAI NUIMTI", 3000, 3);
				DestroyDynamicObject(SpygliaiInfo[playerid][SpygliuObj]);
				MSG(playerid, RED, "- Spygliai nuimti");
				SpygliaiInfo[playerid][arPadeti] = false;
				Delete3DTextLabel(SpygliaiInfo[playerid][SpygliuText]);
			}
			case false:
			{
                new Float:Cords[4];
                GetPlayerPos(playerid, Cords[0], Cords[1], Cords[2]);
                GetPlayerFacingAngle(playerid, Cords[3]);
                CreateSpikes(playerid,Cords[0], Cords[1] - 2.0, Cords[2] - 0.85, Cords[3], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
                GameTextForPlayer(playerid, "~g~SPYGLIAI PADETI", 3000, 3);
                MSG(playerid, GREEN, "+ Spygliai pad�ti");
                SpygliaiInfo[playerid][arPadeti] = true;
			}
		}
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:liemene(playerid, params[], help)
{
	if(IsJobFromLaw(pInfo[playerid][darbas]))
	{	
		if(pInfo[playerid][wUniform] == 0) return MSG(playerid, RED, "- Liemen�s negalite u�sid�ti nesant su darbine uniforma!");
		if(pInfo[playerid][Spectatina]) return MSG(playerid, RED, "- Liemen�s stebint �aid�j� u�sid�ti negalite!");
		if(pInfo[playerid][Surakintas]) return MSG(playerid, RED, "- Esant surakintam negalite u�sid�ti liemen�s!");

		if(IsPlayerAttachedObjectSlotUsed(playerid, 5)) { RemovePlayerAttachedObject(playerid, 5); suLiemene[playerid] = false; }
		else {SetPlayerAttachedObject(playerid, 5,19142,1,0.1,0.05,0.0,0.0,0.0,0.0); suLiemene[playerid] = true;}
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:vierhutazeris(playerid, params[], help) // Testinimui
{
	GivePlayerWeapon(playerid, WEAPON_SILENCED, 100);
	return 1;
}

YCMD:koordinates(playerid, params[], help)
{
	new Float:coords[3];

	GetPlayerPos(playerid, coords[0], coords[1], coords[2]);

	SendFormat(playerid, -1, "X: %s", coords[0]);
	SendFormat(playerid, -1, "Y: %s", coords[1]);
	SendFormat(playerid, -1, "Z: %s", coords[2]);
	return 1;
}

YCMD:vaziuoju(playerid, params[], help)
{
	new id, Float:cords[3];
	if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Va�iuoti � i�kvietim�: /vaziuoju [Vardas_Pavard�/ID]");
	if(!IsPlayerInAnyVehicle(playerid)) return MSG(playerid, 0xFF0000AA, "- Turite b�ti tr. priemon�je");
	if(!IsPlayerConnected(id)) return MSG(playerid, RED, "- �aid�jas atsijung�s");
	if(id == playerid) return MSG(playerid, RED, "- Pas save vykti negalite!");
	if(pInfo[playerid][darbas] == 0 || pInfo[playerid][darbas] == ARMIJA) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");

	switch(pInfo[playerid][darbas])
	{
		case MEDIKAI:
		{
			if(pInfo[id][kvieciaID] == MEDIKAI)
			{
				SendFormatToJob(MEDIKAI, -1, "{f49e42}[RACIJA]: %s pri�m� i�kvietim� (/vaziuoju %s)", params);

				SendFormat(id, GREEN, "� Medikas %s pri�m� j�s� i�kvietim� ir vyksta pas jus!", playerName[playerid]);

				pInfo[playerid][viskvmed] = true;

				SetPlayerCheckpoint(playerid, cords[0], cords[1], cords[2], 2);

				IskvietimoCP[playerid] = SetPlayerCheckpoint(playerid, cords[0], cords[1], cords[2], 2);
				Iskvietimotimer[playerid] = SetTimerEx("Iskvietimas", 1000, true, "ii", playerid, id);
				pInfo[playerid][PasirinktasZaidejas] = id;
			}
			else return MSG(playerid, RED, "- �aid�jas nei�kviet�s medik�!");
		}
		case POLICININKAI:
		{
			if(pInfo[id][kvieciaID] == POLICININKAI)
			{
				SendFormatToJob(POLICININKAI, -1, "{f49e42}[RACIJA]: %s pri�m� i�kvietim� (/vaziuoju %s)", params);

				SendFormat(id, GREEN, "� Pareig�nas %s pri�m� j�s� i�kvietim� ir vyksta pas jus!", playerName[playerid]);

				pInfo[playerid][viskvpd] = true;

				SetPlayerCheckpoint(playerid, cords[0], cords[1], cords[2], 2);
				IskvietimoCP[playerid] = SetPlayerCheckpoint(playerid, cords[0], cords[1], cords[2], 2);

				Iskvietimotimer[playerid] = SetTimerEx("Iskvietimas", 1000, true, "ii", playerid, id);
				pInfo[playerid][PasirinktasZaidejas] = id;
			}
			else return MSG(playerid, RED, "- �aid�jas nei�kviet�s policijos!");
		}
	}
	return 1;
}

YCMD:ispejimai(playerid, params[], help)
{
	new string[200];
	format(string, sizeof(string), "{ffffff}Turite {6574b3}%i{ffffff} darbo �sp�jimus\nTurite {6574b3}%i{ffffff} VIP �sp�jimus\nTurite {6574b3}%i{ffffff} administratoriaus �sp�jimus\n\nDaugiau informacijos {6574b3}/priezastys", pInfo[playerid][disp], pInfo[playerid][visp], pInfo[playerid][aisp]);
	ShowPlayerDialog(playerid, ispejimai, DIALOG_STYLE_MSGBOX, "{ffffff}� Prie�astys", string, "Supratau", "");
	return 1;
}

YCMD:priezastys(playerid, params[], help)
{
	mysql_format(connectionHandle, query, 200, "SELECT `data`, `priezastis`, `kasispejo`, `isptipas` FROM `ispejimai` WHERE `vardas` = '%e' ORDER BY `ID` DESC LIMIT 20;", playerName[playerid]);
	mysql_tquery(connectionHandle, query, "OnPlayerRequestWarnings", "d", playerid);
	return 1;
}

function OnPlayerRequestWarnings(playerid)
{
	if(cache_num_rows() > 0)
	{
		new string[2048], rows, isptipas, type[13], str[150];
		cache_get_row_count(rows);
		for(new row = 0, count = 0; row<rows; row++,count++)
		{
			new priezastis[25], data[31], kasIspejo[24];

			cache_get_value_index(row, 0, data);

			cache_get_value_index(row, 1, priezastis);

			cache_get_value_name(row, "kasispejo", kasIspejo, 24);

			cache_get_value_index_int(row, 3, isptipas);

			// 1 vip
			// 2 admin
			// 3 darbo
			// 4 dpriz
			// 5 drk
			// 6 vippriz
			// 7 adminpriz
			// 8 unbanpriz
			// 9 nuimta savininko
			if(isptipas == 1){
				type = "VIP";
			}
			else if(isptipas == 2){
				type = "ADMIN";
			}
			else if(isptipas == 3){
				type = "Darbo";
			}
			else if(isptipas == 4){
				type = "D. Pri�";
			}
			else if(isptipas == 5){
				type = "Direktoriaus";
			}
			else if(isptipas == 6){
				type = "V.I.P pri�";
			}
			else if(isptipas == 7){
				type = "ADMIN pri�";
			}
			else if(isptipas == 8){
				type = "UNBAN pri�";
			}
			else if(isptipas == 9){
				type = "Savininkas";
			}
			format(str, sizeof(str), "{2e8b57}%i. %s �sp�jimas | %s | %s | %s\n", count, type, data, priezastis, kasIspejo);
			strcat(string, str);
		}
		ShowPlayerDialog(playerid, priezastys, DIALOG_STYLE_MSGBOX, "{ffffff}ID | Tipas | Data | Prie�astis | Kas �sp�jo", string, "Gerai", "");
	}
	else return MSG(playerid, 0xFF0000FF, "- Prie�as�i� n�ra!");
	return 1;
}

YCMD:bendradarbiai(playerid, params[], help)
{
	if(pInfo[playerid][darbas] == 0) return 0;

	new str[100], fstr[600], columnnumber;
	foreach(new i : Player)
	{
		if(pInfo[i][darbas] == pInfo[playerid][darbas])
		{
			columnnumber++;	
			format(str, sizeof(str), "%i. %s\n", columnnumber, playerName[i]);
			strcat(fstr, str);
		}
	}
	ShowPlayerDialog(playerid, bendradarbiai, DIALOG_STYLE_LIST, "Bendradarbiai", fstr, "Pasirinkti", "I�eiti");
	return 1;
}

YCMD:begliai(playerid, params[], help)
{
	if(!IsJobFromLaw(pInfo[playerid][darbas])) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	MSG(playerid, 0x00B8D8AA, "B�gliai:");
	foreach(new i : Player)
	{
		if(online[i] && bega[i])
		{
			new numb;
			numb++;
			SendFormat(playerid, 0x00B8D8AA, "%i. %s [u�d�jo %s]", numb, playerName[i], kasUzdejobega[i]);
		}
		else return MSG(playerid, RED, "- B�gli� n�ra!");
	}
	return 1;
}

YCMD:bega(playerid, params[], help)
{
	if(!IsJobFromLaw(pInfo[playerid][darbas])) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	new id;
	if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Paskelbti b�gliu: /bega [Dalis Vardo/ID]");
	if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
	if(!IsPlayerConnected(id)) return MSG(playerid, RED, "- Tokio �aid�jo n�ra");
	if(bega[id]) return MSG(playerid, RED, "- �aid�jas jau turi b�glio status�!");
	if(pInfo[playerid][Spectatina]) return MSG(playerid, RED, "- J�s steb�jimo re�ime!");

	bega[id] = true;

	SetPlayerColor(id, PLAYCOL_HIDDEN);

	format(kasUzdejobega[id], 24, "%s", playerName[playerid]);

	SendFormatForLaw(-1, "{f49e42}[Teis�saugos racija]: Pareig�nas %s: D�mesio �aid�jas %s b�ga nuo policijos!", playerName[playerid], playerName[id]);

	SendFormat(id, -1, "� Pareig�nas %s paskelb� jus b�gliu!", playerName[playerid]);

	return 1;
}

YCMD:nubega(playerid, params[], help)
{
	if(!IsJobFromLaw(pInfo[playerid][darbas])) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	new id;
	if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Nuimti b�glio status�: /nubega [Dalis Vardo/ID]");
	if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
	if(!IsPlayerConnected(id)) return MSG(playerid, RED, "- Tokio �aid�jo n�ra");
	if(!bega[id]) return MSG(playerid, RED, "- �aid�jas neturi b�glio statuso!");
	if(strcmp(kasUzdejobega[id], playerName[playerid], true) != 0) return MSG(playerid, RED, "- Nuimti b�glio status� gali tik tas kas u�d�jo!");

	bega[id] = false;

	format(kasUzdejobega[id], 24, "");

	SetPlayerColor(id, DEFAULT_COLOR);

	SendFormatForLaw(-1, "{f49e42}[Teis�saugos racija]: Pareig�nas %s: �aid�jas %s nebeb�ga nuo policijos!", playerName[playerid], playerName[id]);

	SendFormat(id, -1, "� Pareig�nas %s nu�m� jums b�glio status�!", playerName[playerid]);

	return 1;
}

YCMD:ant(playerid, params[], help)
{
	if(IsJobFromLaw(pInfo[playerid][darbas]))
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Surakinti/atrakinti �aid�j�: /ant [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra");
		if(playerid == id) return MSG(playerid, 0xFF0000AA, "- Sav�s surakinti negalite");
		if(pInfo[playerid][wUniform] == 0) return MSG(playerid, 0xFF0000AA, "- J�s nedirbate! Negalite surakinti �aid�jo! Esate be darbin�s uniformos.");
		if(pInfo[playerid][Spectatina] == true) return MSG(playerid, 0xFF0000AA, "- Stebint �aid�j� jo surakinti negalite!");
		if(pInfo[playerid][Surakintas] == true) return MSG(playerid, 0xFF0000AA, "- Negalite surakinti �aid�jo, kadangi esate surakintas!");
		if(IsPlayerInAnyVehicle(playerid)) return MSG(playerid, 0xFF0000AA, "- S�dint ma�inoje �aid�jo surakinti negalite!");

		new Float:cords[3];

		GetPlayerPos(id, cords[0], cords[1], cords[2]);

		if(IsPlayerInRangeOfPoint(playerid, 3, cords[0], cords[1], cords[2]))
		{
			if(pInfo[id][Surakintas] == false)
			{
				SetPlayerSpecialAction(id, SPECIAL_ACTION_CUFFED);
				SetPlayerAttachedObject(id,0,19418,5,0.016000,0.032000,0.025000,17.500005,-10.099991,-48.099990,1.0,1.0,1.0);

				pInfo[id][Surakintas] = true;

				SendFormat(id, -1, "%s surakino jus", playerName[playerid]);
				SendFormat(playerid, -1, "Surakinote %s", playerName[id]);

				ClearAnimations(id);
				pInfo[id][Nutazintas] = false;
				pInfo[id][NutazintasTimer] = 0;
				KillTimer(nutazintas_idtimer[id]);

				RemoveTazed(id);
				TogglePlayerControllable(id, false);
			}
			else
			{
				pInfo[id][Surakintas] = false;
				SetPlayerSpecialAction(id, SPECIAL_ACTION_NONE);
				RemovePlayerAttachedObject(id, 0);
				TogglePlayerControllable(id, true);
				ClearAnimations(id);
				SendFormat(id, -1, "%s atrakino jus", playerName[playerid]);
				SendFormat(playerid, -1, "Atrakinote %s", playerName[id]);
			}
		}
		else return MSG(playerid, RED, "- �aid�jas per toli!");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:ita(playerid, params[], help)
{
	if(IsJobFromLaw(pInfo[playerid][darbas]))
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� �tarti �aid�j�: /ita [Dalis vardo/ID]");
		if(pInfo[playerid][Spectatina]) return MSG(playerid, RED, "- J�s steb�jimo re�ime!");
		
		if(IsPlayerConnected(id) && online[id])
		{
			// if(playerid == id) return MSG(playerid, RED, "- Sav�s �tarti negalite");

			new Float:cords[3];
			GetPlayerPos(id, cords[0], cords[1], cords[2]);
			if(IsPlayerInRangeOfPoint(playerid, 10, cords[0], cords[1], cords[2]))
			{
				pInfo[playerid][PasirinktasZaidejas] = id;
				new fBuffer[2000], zBuffer[1000], itariamas_zaidejas[50];
				for(new i = 0; i < MAX_ITA; i++)
				{
					format(zBuffer, sizeof(zBuffer), "%s\t \t \t{ffffff}%s\n", itarimai[i][itarimo_vardas], itarimai[i][itarimo_bausmes_vardas]);
					strcat(fBuffer, zBuffer);
				}
				format(itariamas_zaidejas, sizeof(itariamas_zaidejas), "� �tariamas �aid�jas %s", pInfo[playerid][PasirinktasZaidejas]);
				inline itarti_zaideja(pid, did, resp, litem, string:input[])
				{
					id = pInfo[playerid][PasirinktasZaidejas];
					#pragma unused pid, did, input

					if(resp)
					{
						new itaReason[120];

						format(itaReason, sizeof itaReason, "%s", itarimai[litem][itarimo_vardas]);

						if(strfind(itaReason, "{8C6547}�{ffffff}") != -1)
							strreplace(itaReason, "{8C6547}�{ffffff}", "");
						switch(litem)
						{
							case 0..7:
							{
								SendFormatToJob(POLICININKAI, -1, "{f49e42}[RACIJA]: %s(%i): I�ra�iau %s(%i) administracin� baud�", playerName[playerid], playerid, playerName[id], id);
								SendFormatToJob(POLICININKAI, -1, "\t{f49e42}� Prie�astis: %s | Bauda: %s�", itaReason, konvertuoti_pinigus(itarimai[litem][baudoskiekis_adm]));

								mysql_format(connectionHandle, query, 300, "INSERT INTO `zaideju_baudos_administracines` (`baudosvardas`, `kamskirta`, `kasisrase`, `kadaisrase`, `baudos_suma`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
									itaReason, playerName[id], playerName[playerid], GautiData(0), itarimai[litem][baudoskiekis_adm]);
								mysql_tquery(connectionHandle, query, "SendQuery", "");

								pInfo[id][VairavimoNuobauduTaskai] += itarimai[litem][vairavimotaskai]; // Vairavimo ta�kai u� nuobaud�.
								SendFormat(id, GREEN, "+ Pareig�nas %s(%i) i�ra�� jums administracine baud� u� %s (%s�)", playerName[playerid], playerid, itaReason, konvertuoti_pinigus(itarimai[litem][baudoskiekis_adm]));
								MSG(id, GREEN, "+ J� galite susimok�ti policijos komisariate. Turimos baudos: /baudos");
								SendFormat(playerid, GREEN, "+ I�ra��te %s(%i) administracine baud� u� %s (%s�)", playerName[id], id, itaReason, konvertuoti_pinigus(itarimai[litem][baudoskiekis_adm]));

								//Tikrinti jeigu >= 100 tai prane�ti darbuotojui, jog atimt� teises.
							}
							case 8..24:
							{
								SendFormatToJob(POLICININKAI, -1, "{f49e42}[RACIJA]: %s(%i): �tariau %s(%i) u� %s (+%i star)", playerName[playerid], playerid, playerName[id], id, itaReason, itarimai[litem][starkiekis]);
								pInfo[id][gaudomumas] += itarimai[litem][starkiekis];

								SendFormat(playerid, GREEN, "+ �tar�te %s(%i) u� %s (+%i star)", playerName[id], id, itaReason, itarimai[litem][starkiekis]);
								SendFormat(id, GREEN, "[�tarimai] %s(%i) �tar� jus u� %s (+%i star)", playerName[playerid], playerid, itaReason, itarimai[litem][starkiekis]);
							}
						}
					}
					return 1;
				}
				Dialog_ShowCallback(playerid, using inline itarti_zaideja, DIALOG_STYLE_TABLIST, itariamas_zaidejas, fBuffer, "�tarti", "I�eiti");
			}
		}
		else return MSG(playerid, RED, "- Tokio �aid�jo n�ra");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:policija(playerid, params[], help)
{
	if(pInfo[playerid][darbas] != POLICININKAI) return MSG(playerid, RED, "- Komanda skirta policijai!");

	new list[500];	
	strcat(list, "{CF9F94}Policijos {ffffff}komandos\n\n{CF9F94}/skydas{ffffff} - u�deda skyd� ant rankos/nugaros\n{CF9F94}/liemene{ffffff} - u�deda neper�aunam� liemen�\n{CF9F94}/gaudomi{ffffff} - gaudom� s�ra�as\n{CF9F94}/begliai{ffffff} - b�gli� s�ra�as\n{CF9F94}/bega{ffffff} - u�deda b�glio status�\n{CF9F94}/nubega{ffffff} - nuim� b�glio status�\n{CF9F94}/ant{ffffff} - surakina �aid�j�\n{CF9F94}/r{ffffff} - darbo racija\n{CF9F94}/tr{ffffff} - teis�saugos racija");
	ShowPlayerDialog(playerid, pdkomandos, DIALOG_STYLE_MSGBOX, "Policijos komandos", list, "Supratau", "");
	return 1;
}

YCMD:medikas(playerid, params[], help)
{

	if(pInfo[playerid][darbas] != MEDIKAI) return MSG(playerid, RED, "- Komanda skirta medikams!");

	new list[500];	
	strcat(list, "{CF9F94}Medik� {ffffff}komandos\n\n{CF9F94}/psarvus{ffffff} - parduoti �arvus\n{CF9F94}pheal{ffffff} - parduoti pagydym�\n{CF9F94}/r{ffffff} - darbo racija");
	ShowPlayerDialog(playerid, medkomandos, DIALOG_STYLE_MSGBOX, "Policijos komandos", list, "Supratau", "");
	return 1;
}

YCMD:valdzia(playerid, params[], help)
{
	new status[40], str[200], fstr[1000], id;

	if(!isnull(DPRIZINFO[prizvardas]))
	{
		id = GetPlayeridMid(DPRIZINFO[prizvardas]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "{00FFAA}Direktori� pri�i�r�tojas\n\t{00FFAA}� {ffffff}Pri�i�r�tojas {00FFAA}%s {ffffff}�iuo metu %s {ffffff}�aidime pareigose nuo {00FFAA}%s %i {ffffff}�sp\n", DPRIZINFO[prizvardas], status, DPRIZINFO[prizpareigosenuo], DPRIZINFO[prizisp]); 
		strcat(fstr, str);
	}
	else
	{
		format(str, sizeof(str), "{00FFAA}Direktori� pri�i�r�tojas\n\t{00FFAA}� {ffffff}Pri�i�r�tojas nei�rinktas\n");
		strcat(fstr, str);
	}

	if(!isnull(VIPPRIZINFO[prizvardas]))
	{
		id = GetPlayeridMid(VIPPRIZINFO[prizvardas]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\n{00FFAA}V.I.P nari� pri�i�r�tojas\n\t{00FFAA}� {ffffff}Pri�i�r�tojas {00FFAA}%s {ffffff}�iuo metu %s {ffffff}�aidime pareigose nuo {00FFAA}%s %i {ffffff}�sp\n", VIPPRIZINFO[prizvardas], status, VIPPRIZINFO[prizpareigosenuo], VIPPRIZINFO[prizisp]);
		strcat(fstr, str);
	}
	else
	{
		format(str, sizeof(str), "\n{00FFAA}V.I.P nari� pri�i�r�tojas\n\t{00FFAA}� {ffffff}Pri�i�r�tojas nei�rinktas\n");
		strcat(fstr, str);
	}

	if(!isnull(ADMINPRIZINFO[prizvardas]))
	{
		id = GetPlayeridMid(ADMINPRIZINFO[prizvardas]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\n{00FFAA}Administratori� pri�i�r�tojas\n\t{00FFAA}� {ffffff}Pri�i�r�tojas {00FFAA}%s {ffffff}�iuo metu %s {ffffff}�aidime pareigose nuo {00FFAA}%s %i {ffffff}�sp\n", ADMINPRIZINFO[prizvardas], status, ADMINPRIZINFO[prizpareigosenuo], ADMINPRIZINFO[prizisp]);
		strcat(fstr, str);
	}

	else
	{
		format(str, sizeof(str), "\n{00FFAA}Administratori� pri�i�r�tojas\n\t{00FFAA}� {ffffff}Pri�i�r�tojas nei�rinktas\n");
		strcat(fstr, str);
	}

	if(!isnull(UNBANPRIZ_INFO[prizvardas]))
	{
		id = GetPlayeridMid(UNBANPRIZ_INFO[prizvardas]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\n{00FFAA}Unban pri�i�r�tojas\n\t{00FFAA}� {ffffff}Pri�i�r�tojas {00FFAA}%s {ffffff}�iuo metu %s {ffffff}�aidime pareigose nuo {00FFAA}%s %i {ffffff}�sp\n", UNBANPRIZ_INFO[prizvardas], status, UNBANPRIZ_INFO[prizpareigosenuo], UNBANPRIZ_INFO[prizisp]);
		strcat(fstr, str);
	}

	else
	{
		format(str, sizeof(str), "\n{00FFAA}Unban pri�i�r�tojas\n\t{00FFAA}� {ffffff}Pri�i�r�tojas nei�rinktas\n");
		strcat(fstr, str);
	}

	if(!isnull(SAVININKAI_INFO[sav_vardas0]))
	{
		id = GetPlayeridMid(SAVININKAI_INFO[sav_vardas0]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\n{00FFAA}Savininkai\n\t{00FFAA}� {ffffff}Savininkas {00FFAA}%s {ffffff}�iuo metu %s\n", SAVININKAI_INFO[sav_vardas0], status);
		strcat(fstr, str);
	}
	else
	{
		format(str, sizeof(str), "\n{00FFAA}Savininkai\n\t{00FFAA}� {ffffff}Savininkas neprid�tas\n");
		strcat(fstr, str);
	}

	if(!isnull(SAVININKAI_INFO[sav_vardas1]))
	{
		id = GetPlayeridMid(SAVININKAI_INFO[sav_vardas1]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\t{00FFAA}� {ffffff}Savininkas {00FFAA}%s {ffffff}�iuo metu %s\n", SAVININKAI_INFO[sav_vardas1], status);
		strcat(fstr, str);
	}
	else
	{
		format(str, sizeof(str), "\t{00FFAA}� {ffffff}Savininkas neprid�tas\n");
		strcat(fstr, str);
	}

	if(!isnull(KOMANDOSNARIAI_INFO[knario_vardas0]))
	{
		id = GetPlayeridMid(KOMANDOSNARIAI_INFO[knario_vardas0]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\n{00FFAA}Komandos nariai\n\t{00FFAA}� {ffffff}Komandos narys {00FFAA}%s {ffffff}�iuo metu %s\n", KOMANDOSNARIAI_INFO[knario_vardas0], status);
		strcat(fstr, str);
	}
	else
	{
		format(str, sizeof(str), "\n{00FFAA}Komandos nariai\n\t{00FFAA}� {ffffff}Komandos narys neprid�tas\n");
		strcat(fstr, str);
	}	

	if(!isnull(KOMANDOSNARIAI_INFO[knario_vardas1]))
	{
		id = GetPlayeridMid(KOMANDOSNARIAI_INFO[knario_vardas1]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\t{00FFAA}� {ffffff}Komandos narys {00FFAA}%s {ffffff}�iuo metu %s\n", KOMANDOSNARIAI_INFO[knario_vardas1], status);
		strcat(fstr, str);
	}
	else
	{
		format(str, sizeof(str), "\t{00FFAA}� {ffffff}Komandos narys neprid�tas\n");
		strcat(fstr, str);
	}

	ShowPlayerDialog(playerid, valdzioslist, DIALOG_STYLE_MSGBOX, "Direktoriai", fstr, "Supratau", "");
	return 1;
}

YCMD:darboinfo(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][direktorius] > 0)
	{
		new zBuffer[500], fBuffer[500], ardirba[30];
		inline ShowInfoAboutWork(pid, did, resp, litem, string:input[])
		{
			#pragma unused pid, did, input, resp, litem
		}
		switch(pInfo[playerid][direktorius])
		{
			case MEDIKAI:
			{
				format(fBuffer, sizeof(fBuffer), "\t{ffffff}Medik� informacija\n\n{496da6}�{ffffff} Minimalus {496da6}pra�aidimo{ffffff} reikalavimas: {496da6}%i min\n\n{496da6}�{ffffff} Minimalus {496da6}pagydym�{ffffff} reikalavimas: {496da6}%i{ffffff}",\
				DarboInfo[MEDIKAI][dienosminimumasMIN], DarboInfo[MEDIKAI][dienosminimumasPAGYD]);
				strcat(zBuffer, fBuffer);

				format(fBuffer, sizeof(fBuffer), "\n\n{496da6}�{ffffff} Minimalus {496da6}patirties{ffffff} reikalavimas norint �sidarbinti: {496da6}%i{ffffff} XP\n\n{496da6}�{ffffff} I� viso {496da6}prisijungusi�{ffffff} darbuotoj�: {496da6}%i{ffffff}",\
				MEDIKU_XP, GetWorkersCount(MEDIKAI, true));

				strcat(zBuffer, fBuffer);

				if(DarboInfo[MEDIKAI][dirba]) ardirba = "dirba";
				else ardirba = "nedirba";

				format(fBuffer, sizeof(fBuffer), "\n\n{496da6}� {ffffff}Dirba: {496da6}%s", ardirba);
				strcat(zBuffer, fBuffer);

				if(!DarboInfo[MEDIKAI][dirba]){format(fBuffer, sizeof(fBuffer), "\n\n{496da6}� {ffffff} Nedirbs iki: {496da6}%s", date(DarboInfo[MEDIKAI][nedirbsiki])); strcat(zBuffer, fBuffer);}


			}
			case POLICININKAI:
			{
				format(fBuffer, sizeof(fBuffer), "\t{ffffff}Policinink� informacija\n\n{496da6}�{ffffff} Minimalus {496da6}pra�aidimo{ffffff} reikalavimas: {496da6}%i{ffffff} min\n\n{496da6}�{ffffff} Minimalus {496da6}baud�{ffffff} reikalavimas: {496da6}%i{ffffff}",\
				DarboInfo[POLICININKAI][dienosminimumasMIN], DarboInfo[POLICININKAI][dienosminimumasBAUDOS]);
				strcat(zBuffer, fBuffer);

				format(fBuffer, sizeof(fBuffer), "\n\n{496da6}�{ffffff} Minimalus {496da6}patirties{ffffff} reikalavimas norint �sidarbinti: {496da6}%i{ffffff} XP\n\n{496da6}�{ffffff} I� viso {496da6}prisijungusi�{ffffff} darbuotoj�: {496da6}%i{ffffff}",\
				POLICININKU_XP, GetWorkersCount(POLICININKAI, true) );

				strcat(zBuffer, fBuffer);

				if(DarboInfo[POLICININKAI][dirba]) ardirba = "dirba";
				else ardirba = "nedirba";

				format(fBuffer, sizeof(fBuffer), "\n\n{496da6}� {ffffff}Dirba: {496da6}%s", ardirba);
				strcat(zBuffer, fBuffer);

				if(!DarboInfo[POLICININKAI][dirba]){format(fBuffer, sizeof(fBuffer), "\n\n{496da6}� {ffffff} Nedirbs iki: {496da6}%s", date(DarboInfo[POLICININKAI][nedirbsiki])); strcat(zBuffer, fBuffer);}
			}
			case ARMIJA:
			{
				format(fBuffer, sizeof(fBuffer), "\t{ffffff}Armijos informacija\n\n{496da6}�{ffffff} Minimalus {496da6}pra�aidimo{ffffff} reikalavimas: {496da6}%i{ffffff} min\n\n{496da6}�{ffffff} Minimalus {496da6}baud�{ffffff} reikalavimas: {496da6}%i{ffffff}",\
				DarboInfo[ARMIJA][dienosminimumasMIN], DarboInfo[ARMIJA][dienosminimumasBAUDOS]);
				strcat(zBuffer, fBuffer);

				format(fBuffer, sizeof(fBuffer), "\n\n{496da6}�{ffffff} Minimalus {496da6}patirties{ffffff} reikalavimas norint �sidarbinti: {496da6}%i{ffffff} XP\n\n{496da6}�{ffffff} I� viso {496da6}prisijungusi�{ffffff} darbuotoj�: {496da6}%i{ffffff}",\
				POLICININKU_XP, GetWorkersCount(ARMIJA, true) );

				strcat(zBuffer, fBuffer);

				if(DarboInfo[ARMIJA][dirba]) ardirba = "dirba";
				else ardirba = "nedirba";

				format(fBuffer, sizeof(fBuffer), "\n\n{496da6}� {ffffff}Dirba: {496da6}%s", ardirba);
				strcat(zBuffer, fBuffer);

				if(!DarboInfo[ARMIJA][dirba]){format(fBuffer, sizeof(fBuffer), "\n\n{496da6}� {ffffff} Nedirbs iki: {496da6}%s", date(DarboInfo[ARMIJA][nedirbsiki])); strcat(zBuffer, fBuffer);}
			}
		}

		Dialog_ShowCallback(playerid, using inline ShowInfoAboutWork, DIALOG_STYLE_MSGBOX, "{ffffff}J�s� darbo informacija", \
		zBuffer, "Supratau", "");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:direktoriai(playerid, params[], help)
{
	new status[40], str[200], fstr[1000], id;

	if(!isnull(DPRIZINFO[prizvardas]))
	{
		id = GetPlayeridMid(DPRIZINFO[prizvardas]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "{00FFAA}Direktori� pri�i�r�tojas\n\t{00FFAA}� {ffffff}Pri�i�r�tojas {00FFAA}%s {ffffff}�iuo metu %s {ffffff}�aidime pareigose nuo {00FFAA}%s %i {ffffff}�sp\n", DPRIZINFO[prizvardas], status, DPRIZINFO[prizpareigosenuo], DPRIZINFO[prizisp]); 
		strcat(fstr, str);
	}
	else
	{
		format(str, sizeof(str), "{00FFAA}Direktori� pri�i�r�tojas\n\t{00FFAA}� {ffffff}Pri�i�r�tojas nei�rinktas\n");
		strcat(fstr, str);
	}

	if(!isnull(DarboInfo[MEDIKAI][drk]))
	{
		id = GetPlayeridMid(DarboInfo[MEDIKAI][drk]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\n{00FFAA}Medik� vald�ia\n\t{00FFAA}� {ffffff}Direktorius {00FFAA}%s {ffffff}�iuo metu %s {ffffff}�aidime pareigose nuo {00FFAA}%s %i {ffffff}�sp\n", DarboInfo[MEDIKAI][drk], status, DarboInfo[MEDIKAI][drkpareigosenuo], DarboInfo[MEDIKAI][drkisp]);
		strcat(fstr, str);
	}
	else
	{
		format(str, sizeof(str), "\n{00FFAA}Medik� vald�ia\n\t{00FFAA}� {ffffff}Direktorius nei�rinktas\n");
		strcat(fstr, str);
	}

	if(!isnull(DarboInfo[MEDIKAI][pav]))
	{
		id = GetPlayeridMid(DarboInfo[MEDIKAI][pav]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\t{00FFAA}� {ffffff}Pavaduotojas {00FFAA}%s {ffffff}�iuo metu %s {ffffff}�aidime pareigose nuo {00FFAA}%s %i {ffffff}�sp\n", DarboInfo[MEDIKAI][pav], status, DarboInfo[MEDIKAI][pavpareigosenuo], DarboInfo[MEDIKAI][pavisp]);
		strcat(fstr, str);
	}
	else
	{
		format(str, sizeof(str), "\t{00FFAA}� {ffffff}Pavaduotojas nei�rinktas\n");
		strcat(fstr, str);
	}

	if(!isnull(DarboInfo[POLICININKAI][drk]))
	{
		id = GetPlayeridMid(DarboInfo[POLICININKAI][drk]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\n{00FFAA}Policijos vald�ia\n\t{00FFAA}� {ffffff}Direktorius {00FFAA}%s {ffffff}�iuo metu %s {ffffff}�aidime pareigose nuo {00FFAA}%s %i {ffffff}�sp\n", DarboInfo[POLICININKAI][drk], status, DarboInfo[POLICININKAI][drkpareigosenuo], DarboInfo[POLICININKAI][drkisp]);
		strcat(fstr, str);
	}

	else
	{
		format(str, sizeof(str), "\n{00FFAA}Policijos vald�ia\n\t{00FFAA}� {ffffff}Direktorius nei�rinktas\n");
		strcat(fstr, str);
	}

	if(!isnull(DarboInfo[POLICININKAI][pav]))
	{
		id = GetPlayeridMid(DarboInfo[POLICININKAI][pav]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\t{00FFAA}� {ffffff}Pavaduotojas {00FFAA}%s {ffffff}�iuo metu %s {ffffff}�aidime pareigose nuo {00FFAA}%s %i {ffffff}�sp\n", DarboInfo[POLICININKAI][pav], status, DarboInfo[POLICININKAI][pavpareigosenuo], DarboInfo[POLICININKAI][pavisp]);
		strcat(fstr, str);
	}

	else
	{
		format(str, sizeof(str), "\t{00FFAA}� {ffffff}Pavaduotojas nei�rinktas\n");
		strcat(fstr, str);
	}


	if(!isnull(DarboInfo[ARMIJA][drk]))
	{
		id = GetPlayeridMid(DarboInfo[ARMIJA][drk]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\n{00FFAA}Armijos vald�ia\n\t{00FFAA}� {ffffff}Generolas {00FFAA}%s {ffffff}�iuo metu %s {ffffff}�aidime pareigose nuo {00FFAA}%s %i {ffffff}�sp\n", DarboInfo[ARMIJA][drk], status, DarboInfo[ARMIJA][drkpareigosenuo], DarboInfo[ARMIJA][drkisp]);
		strcat(fstr, str);
	}
	
	else
	{
		format(str, sizeof(str), "\n{00FFAA}Armijos vald�ia\n\t{00FFAA}� {ffffff}Direktorius nei�rinktas\n");
		strcat(fstr, str);
	}

	if(!isnull(DarboInfo[ARMIJA][pav]))
	{
		id = GetPlayeridMid(DarboInfo[ARMIJA][pav]);
		if(id != INVALID_PLAYER_ID) status = "{00FF11}yra";
		else status = "{FF3C00}n�ra";
		format(str, sizeof(str), "\t{00FFAA}� {ffffff}Generolas leitenantas {00FFAA}%s {ffffff}�iuo metu %s {ffffff}�aidime pareigose nuo {00FFAA}%s %i {ffffff}�sp\n", DarboInfo[ARMIJA][pav], status, DarboInfo[ARMIJA][pavpareigosenuo], DarboInfo[ARMIJA][pavisp]);
		strcat(fstr, str);
	}
	else
	{
		format(str, sizeof(str), "\t{00FFAA}� {ffffff}Pavaduotojas nei�rinktas\n");
		strcat(fstr, str);
	}
	ShowPlayerDialog(playerid, direktoriulist, DIALOG_STYLE_MSGBOX, "Direktoriai", fstr, "Supratau", "");
	return 1;
}

YCMD:dzinute(playerid, params[], help)
{
	if(pInfo[playerid][darbas] == 0) return MSG(playerid, RED, "J�s bedarbis!");
	if(!DarboInfo[pInfo[playerid][darbas]][arijungta]) return MSG(playerid, RED, "- Darbo �inut� i�jungta");
	if(isnull(DarboInfo[pInfo[playerid][darbas]][direktoriauszinute])) return MSG(playerid, RED, "- Darbo �inut�s n�ra");

	ShowPlayerDialog(playerid, drkzinute, DIALOG_STYLE_MSGBOX, "Darbo �inut�", DarboInfo[pInfo[playerid][darbas]][direktoriauszinute], "Supratau", "");

	return 1;
}

YCMD:armija(playerid, params[], help)
{
	if(pInfo[playerid][darbas] != ARMIJA) return MSG(playerid, RED, "- Komanda skirta armijai!");

	new list[500];
	strcat(list, "{CF9F94}Armijos {ffffff}komandos\n\n{CF9F94}/skydas{ffffff} - u�deda skyd� ant rankos/nugaros\n{CF9F94}/liemene{ffffff} - u�deda neper�aunam� liemen�\n{CF9F94}/gaudomi{ffffff} - gaudom� s�ra�as\n{CF9F94}/begliai{ffffff} - b�gli� s�ra�as\n{CF9F94}/bega{ffffff} - u�deda b�glio status�\n{CF9F94}/nubega{ffffff} - nuim� b�glio status�\n{CF9F94}/ant{ffffff} - surakina �aid�j�\n{CF9F94}/r{ffffff} - darbo racija\n{CF9F9�}/tr{ffffff} - teis�saugos racija");

	ShowPlayerDialog(playerid, armijainfo, DIALOG_STYLE_MSGBOX, "Armijos komandos", list, "Supratau", "");
	return 1;
}

YCMD:dvp(playerid, params[], help)
{
    if(pInfo[playerid][direktorius] > 0){ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");}
    else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
    return 1;
}


YCMD:rlogas(playerid, params[], help)
{	
	if(pInfo[playerid][ADMIN] < SAVININKAS) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	
	new deit[31], darboid;
	if(sscanf(params, "s[31]i", deit, darboid)) return MSG(playerid, 0x00B8D8AA, "� Per�i�r�ti racijos logus: [YY-MM-DD] [DARBO ID]");

	new daata[3];
	getdate(daata[0], daata[1], daata[2]);

	if(!isValidDate(deit, YYMMDD, '-')) return MSG(playerid, RED, "- Blogas datos formatas: YY-MM-DD");

	mysql_format(connectionHandle, query, 300, "SELECT kasparase, data, darbas, message FROM rlogas WHERE data = '%s' AND darbas = '%i'", deit, darboid);
	mysql_tquery(connectionHandle, query, "OnRequestRLOGS", "i", playerid);
	return 1;
}

function OnRequestRLOGS(playerid)
{
	if(cache_num_rows() > 0)
	{
		new rows;
		cache_get_row_count(rows);
		new name[MAX_PLAYER_NAME], dejt[31], jobid, str[200], fstr[2000], msg[120];
		for(new i = 0; i<rows; i++)
		{
			cache_get_value_index(i, 0,name);
			cache_get_value_index(i, 1,dejt);
			cache_get_value_index_int(i, 2, jobid);
			cache_get_value(i, 3, msg);

			format(str, sizeof(str), "{F39F9F}%s {ffffff}| {F39F9F}%s{ffffff} �inut�: {F39F9F}%s\n", dejt, name, msg);
			strcat(fstr, str);
		}
		ShowPlayerDialog(playerid, rlog, DIALOG_STYLE_MSGBOX, "Racijos logai", fstr, "Supratau", "");
	}
	else return MSG(playerid, RED, "- Racijos log� n�ra!");	
	return 1;
}


YCMD:pagydyti(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] > 2)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Pagydyti kit� �aid�j�: /pagydyti [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(id == playerid) return MSG(playerid, 0xFF0000AA, "- Sav�s pagydyti su �ia komanda pasigydyti negalite, tam yra /pasigydyti!");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
		if(pInfo[playerid][pagydymodelay] > gettime()) return SendFormat(playerid, RED, "- Pagydyti �aid�j� galite tik kas 3 minutes, v�l pagydyti gal�site po %s", ConvertSeconds(pInfo[playerid][pagydymodelay] - gettime()));

		SetPlayerHealth(id, 100);
		SetPlayerArmour(id, 100);

		SendFormat(playerid, 0x00B8D8AA, "+ Pagyd�te %s", playerName[id]);

		SendFormat(id, GREEN, "Administratorius %s pagyd� jus!",playerName[playerid]);

		pInfo[playerid][pagydymodelay] = gettime() + 180; // 3 min 
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:gaudomi(playerid, params[], help)
{
	if(!IsJobFromLaw(pInfo[playerid][darbas])) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	new number;
	foreach(new i : Player)
	{
		if(online[i] && pInfo[i][gaudomumas] > 0)
		{
			number ++;
			if(!bega[i]) SendFormat(playerid, 0x00B8D8AA, "%i. %s [%i star]", number, playerName[i], pInfo[i][gaudomumas]);
			else SendFormat(playerid, 0x00B8D8AA, "%i. %s [%i star] [turi b�glio status�]", number, playerName[i], pInfo[i][gaudomumas]);
		}
		else return MSG(playerid, RED, "- Gaudom� n�ra");
	}
	return 1;
}

YCMD:bausti(playerid, params[], help)
{
    if(pInfo[playerid][ADMIN] > 0)
	{
	    new id;
	    if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Bausti �aid�j�: /bausti [Dalis Vardo/ID]");
	    if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
		if(id == playerid) return MSG(playerid, 0xFF0000AA, "- Sav�s bausti negalima!");
		if(pInfo[id][ADMIN] > pInfo[playerid][ADMIN]) return MSG(playerid, 0xFF0000AA, "- Negalite bausti auk�tesnio lygio administratori� u� jus!");
		pInfo[playerid][PasirinktasZaidejas] = id;
		new String[1500], Stringas[1500];
		switch(pInfo[playerid][ADMIN])
		{
		    case ILVLADMIN:
		    {
		        strcat(String, "Bausm�\tLaikas\n");
                for(new i = 0; i < sizeof(FAL); i ++)
				{
     				if(FAL[i][bLaikas] == 0)
					{
						format(Stringas, sizeof(Stringas), "%s\n", FAL[i][Bausme]);
						strcat(String, Stringas);
					}
					else
					{
						format(Stringas, sizeof(Stringas), "%s\t{33B7D3}%s {ffffff}min.\n", FAL[i][Bausme], ConvertSeconds(FAL[i][bLaikas]));
						strcat(String, Stringas);
					}
				}
				ShowPlayerDialog(playerid, bausti, DIALOG_STYLE_TABLIST_HEADERS, "�aid�jo baudimas", String, "Pasirinkti", "U�daryti");
		    }
		    case IILVLADMIN:
			{
				strcat(String, "Bausm�\tLaikas\n");

				for(new i = 0; i < sizeof(TAL); i ++)
				{
 					if(TAL[i][bLaikas] == 0)
					{
						format(Stringas, sizeof(Stringas), "%s\n", TAL[i][Bausme]);
						strcat(String, Stringas);
					}
					else
					{
						format(Stringas, sizeof(Stringas), "%s\t{33B7D3}%s {ffffff}min.\n", TAL[i][Bausme], ConvertSeconds(TAL[i][bLaikas]));
						strcat(String, Stringas);
					}
				}

				ShowPlayerDialog(playerid, bausti2, DIALOG_STYLE_TABLIST_HEADERS, "�aid�jo baudimas", String, "Pasirinkti", "U�daryti");
			}
   			case IIILVLADMIN, SAVININKAS:
			{
				strcat(String, "Bausm�\tLaikas\n");

				for(new i = 0; i < sizeof(SAL); i ++)
				{
 					if(SAL[i][bLaikas] == 0)
					{
						format(Stringas, sizeof(Stringas), "%s\n", SAL[i][Bausme]);
						strcat(String, Stringas);
					}
					else
					{
						format(Stringas, sizeof(Stringas), "%s\t{33B7D3}%s {ffffff}min.\n", SAL[i][Bausme], ConvertSeconds(SAL[i][bLaikas]));
						strcat(String, Stringas);
					}
				}
				ShowPlayerDialog(playerid, bausti3, DIALOG_STYLE_TABLIST_HEADERS, "�aid�jo baudimas", String, "Pasirinkti", "U�daryti");
			}
		}
 	}
 	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:ac(playerid, params[], help)
{
	#pragma unused help
	new string[90], msg[128];
	if(pInfo[playerid][ADMIN] > 0)
	{
		if(pInfo[playerid][Muted] > 0)
		{
			format(string, sizeof( string), "- Jus u�tildytas, kalbeti galesite po: %s", \
			ConvertSeconds(pInfo[playerid][Muted] - gettime()));
			MSG(playerid, 0xFF0000AA, string);
			return 1;
		}
		if(sscanf(params, "s[128]", msg)) return MSG(playerid, 0x00B8D8AA, "� Ra�yti Administratoriu chate: /ac [Tekstas]");
		if(strlen(msg) > 128) MSG( playerid, 0xFF0000AA, "- Tekstas per ilgas!");
		SendFormatAdmin(-1, "{f08080}[ADMIN.CHAT] {f4525f}%s(%i){f08080}: {f4525f}%s",playerName[playerid], playerid, msg);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:unmute(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][ADMIN] > IILVLADMIN)
	{
		new id, priezastis[64];
		if(sscanf(params, "us[64]", id, priezastis)) return MSG(playerid,0x00B8D8AA,"� Atitildyti �aid�j�: /unmute [Dalis vardo/ID] [Prie�astis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
		if(id == playerid && pInfo[id][ADMIN] != SAVININKAS) return MSG(playerid, 0xFF0000AA, "- Sav�s atitildyti negalima!");
		if(pInfo[id][ADMIN] == SAVININKAS && pInfo[playerid][ADMIN] != SAVININKAS) return MSG(playerid, 0xFF0000FF, "- LERG Komandos negalite atitildyti!");
		if(strlen(priezastis) <= 4) return MSG(playerid, 0xFF0000AA, "- J�s� nurodyta prie�astis per trumpa!");

		pInfo[id][Muted] = 0;
        KillTimer(MuteTime[id]);
		if(pInfo[id][permamute] == 1) pInfo[id][permamute] = 0;

        SendFormat(id, 0x00B8D8AA, "Administratorius %s(%i) atitild� jus d�l: %s", playerName[playerid], playerid, priezastis);

        SendFormat(playerid, 0x00B8D8AA, "Atitild�te �aid�j� %s(%i) d�l: %s",playerName[id], id, priezastis);

        SendFormatAdmin(-1, "{f08080} [ADMIN.CHAT] Administratorius {f4525f}%s{f4525f} atitild� �aid�j� {f4525f}%s{f4525f} d�l: {f4525f}%s",playerName[playerid], playerName[id], priezastis);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:pzu(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] > ILVLADMIN)
	{
		if(pInfo[playerid][Spectatina] == false)
		{
			new id;
			if(sscanf(params, "u",id )) return MSG(playerid, 0x00B8D8AA, "� Steb�ti �aid�j�: /pzu [Dalis vardo/ID]");
			if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, " Tokio �aid�jo n�ra!");
			if(id == playerid) return MSG(playerid, 0xFF0000AA, "- Sav�s steb�ti negalite!");
			if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
			if(pInfo[playerid][Surakintas] == true) return MSG(playerid, 0xFF0000AA, "- Negalite steb�ti �aid�jo kai esate surakintas!");
			if(bega[playerid]) return MSG(playerid, RED, "- Negalite steb�ti �aid�jo turint b�glio re�im�!");
			if(pInfo[id][Spectatina]) return MSG(playerid, RED, "- �aid�jas steb�jimo re�ime!");

			for(new slot=0; slot<12; slot++)GetPlayerWeaponData(playerid,slot,pInfo[playerid][spdata][slot],pInfo[playerid][spdata][12+slot]);

			pInfo[playerid][BeforeSpectatingSkin] = GetPlayerSkin(playerid);
            GetPlayerPos(playerid, pInfo[playerid][BeforeSpectatingX], pInfo[playerid][BeforeSpectatingY], pInfo[playerid][BeforeSpectatingZ]);
           	pInfo[playerid][BeforeSpectatingInterior] = GetPlayerInterior(playerid);
            pInfo[playerid][BeforeSpectatingWorld] = GetPlayerVirtualWorld(playerid);

            SetPlayerInterior(playerid, GetPlayerInterior(id));
            SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));

			SendFormat(playerid, -1, "{bec2c4}[ {09a9f9}> {bec2c4}] {ffffff}Stebite �aid�j� {09a9f9}%s(%i)", playerName[id], id);

            TogglePlayerSpectating(playerid, 1);

            pInfo[playerid][Spectatina] = true;
            pInfo[playerid][SpectatingAtTarget] = id;
            pInfo[playerid][SpectatingAtPed] = true;

            PlayerSpectatePlayer(playerid, id);
		}
		else
		{
			pInfo[playerid][Spectatina] = false;
            SetPlayerVirtualWorld(playerid, pInfo[playerid][BeforeSpectatingWorld]);
            SetPlayerInterior(playerid, pInfo[playerid][BeforeSpectatingInterior]);
            SetSpawnInfo(playerid, NO_TEAM, pInfo[playerid][BeforeSpectatingSkin], pInfo[playerid][BeforeSpectatingX], pInfo[playerid][BeforeSpectatingY], pInfo[playerid][BeforeSpectatingZ], 0, 0, 0, 0, 0, 0, 0);
            TogglePlayerSpectating(playerid, 0);
            for(new slot=0; slot<12; slot++) GivePlayerWeapon(playerid,pInfo[playerid][spdata][slot],pInfo[playerid][spdata][12+slot]);
		}
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:nuispdrk(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == DPRIZIURETOJAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� direktoriui: /nuispdrk [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, RED, "- Tokio �aid�jo n�ra");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s!");
		if(pInfo[id][direktorius] == 0) return MSG(playerid, 0xFF0000AA, "- �aid�jas n�ra direktorius!");
		if(pInfo[id][drkisp] == 0) return MSG(playerid, RED, "- Direktorius neturi �sp�jim�!");

		SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� direktoriui %s", playerName[id]);

		SendFormat(id, GREEN, "� Direktori� pri�i�r�tojas %s nu�m� jums direktoriaus �sp�jim�", playerName[playerid]);

		pInfo[id][drkisp] --;

		mysql_format(connectionHandle, query, 140, "UPDATE darbai SET drkisp = '%i' WHERE jobID = '%i'", pInfo[id][drkisp], pInfo[id][direktorius]);
		mysql_tquery(connectionHandle, query, "SendQuery", ""); 
	}	
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}


YCMD:nuispdrkoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == DPRIZIURETOJAS)
	{
		new id, Vardas[MAX_PLAYER_NAME];
		if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Nuimti �sp�jim� direktoriui (OFFLINE): /nuispdrkoff [Vardas_Pavard�]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 180, "SELECT direktorius, drkisp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "Nuispdrkaoff", "is", playerid, Vardas);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function Nuispdrkaoff(playerid, name[])
{
	if(cache_num_rows() > 0)
	{
		new direkoid, direkoisp;

		cache_get_value_index_int(0,0, direkoid);
		if(direkoid == 0) return MSG(playerid, RED, "- �aid�jas n�ra direktorius");
		cache_get_value_index_int(0,1, direkoisp);
		if(direkoisp == 0) return MSG(playerid, RED, "- Direktorius �sp�jim� neturi!");

		direkoisp --;

		SendFormat(playerid, GREEN, "+ Nu�m�te �sp�jim� direktoriui %s, dabar jis turi %i �sp�jimus(-�)", name, direkoisp);

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET direktoriaus_ispejimai = '%i' WHERE vardas = '%e'", direkoisp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra!");
	return 1;
}

YCMD:ispetidrk(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == DPRIZIURETOJAS)
	{
		new id, reason[25];
		if(sscanf(params, "us[25]", id, reason)) return MSG(playerid, 0x00B8D8AA, "� �sp�ti direktori�: /ispetidrk [Dalis vardo/ID] [Prie�astis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s!");
		if(pInfo[id][direktorius] == 0) return MSG(playerid, 0xFF0000AA, "- �aid�jas n�ra direktorius!");
		if(strlen(reason) > 24) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 24 simboliai");
		if(strlen(reason) <= 4) return MSG(playerid, RED, "- Prie�astis negali b�ti trumpesn� nei 5 simboliai");

		pInfo[id][drkisp] ++;

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", GautiData(0), reason, playerName[playerid], playerName[id], 5);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 200, "INSERT INTO `DrkIsp_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", GautiData(0), reason, playerName[playerid], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET direktoriaus_ispejimai = '%i' WHERE vardas = '%e'", pInfo[id][drkisp], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery");

		mysql_format(connectionHandle, query, 140, "UPDATE darbai SET drkisp = '%i' WHERE jobID = '%i'", pInfo[id][drkisp], pInfo[id][direktorius]);
		mysql_tquery(connectionHandle, query, "SendQuery", ""); 

		if(pInfo[id][drkisp] >= 3)
		{
			SendFormat(playerid, GREEN, "+ �sp�jote direktori� %s d�l %s, surinko 3 �sp�jimus ir yra nu�alinamas nuo pareig�!", playerName[id], reason);
			SendFormat(id, GREEN, "� Direktori� pri�i�r�tojas %s �sp�jo jus d�l: %s, surinkote 3 �sp�jimus ir esate nu�alinamas nuo pareig�!", playerName[playerid], reason);

			foreach(new i : Player)
			{
				if(pInfo[i][darbas] == pInfo[id][direktorius])
				{
					pInfo[i][darbas] = 0;
					pInfo[i][uniforma] = 0;
					pInfo[i][wUniform] = 0;
					pInfo[i][workingSince] = EOS;
					SetPlayerSkin(i, pInfo[i][skin]);
					if(i != id) MSG(i, GREEN, "� Esate i�mesti i� darbo, d�l to, nes direktorius nu�alintas nuo pareig�");
				}
			}

			mysql_format(connectionHandle, query, 144, "UPDATE zaidejai SET darbas = '0', uniforma = '0', wUniform = '0', isidarbino = '' WHERE darbas = '%i'", pInfo[id][direktorius]);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 140, "UPDATE darbai SET drk = '', drkpareigosenuo = '', drkisp = '0' WHERE jobID = '%i'", pInfo[id][direktorius]);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			pInfo[id][direktorius] = 0;
			pInfo[id][disp] = 0;
			pInfo[id][darbas] = 0;
			pInfo[id][wUniform] = 0;
			pInfo[id][uniforma] = 0;
			pInfo[id][workingSince] = EOS;
			SetPlayerSkin(id, pInfo[id][skin]);
		}
		else
		{
			SendFormat(playerid, GREEN, "+ �sp�jote direktori� %s d�l %s, jis dabar turi %i �sp�jimus", playerName[id], reason, pInfo[id][drkisp]);
			SendFormat(id, GREEN, "� Direktori� pri�i�r�tojas %s �sp�jo jus d�l: %s, dabar turite %i �sp�jimus", playerName[playerid], reason, pInfo[id][drkisp]);
		}
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:nuimtivip(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] != SAVININKAS) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");

	new id, reason[25];
	
	if(sscanf(params, "us[25]", id, reason)) return MSG(playerid, 0x00B8D8AA, "� Nuimti VIP status�: /nuimtivip [Dalis vardo/ID] [Prie�astis]");

	if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
	if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s!");
	if(pInfo[id][VIP] == 0) return MSG(playerid, 0xFF0000AA, "- �aid�jas n�ra VIP narys!");
	if(strlen(reason) > 24) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 24 simboliai");
	if(pInfo[id][ADMIN] > 3 && id != playerid) return MSG(playerid, RED, "- Didesnio nei 3 lygio administratoriaus VIP statuso nuimti negalite!");

	pInfo[id][VIP] = 0;
	pInfo[id][VipLaikas] = 0;

	SendFormat(id, GREEN, "� VIP nari� pri�i�r�tojas %s nu�m� j�s� VIP nario status� d�l %s", playerName[playerid], reason);
	SendFormat(playerid, GREEN, "+ Nu�m�te VIP nario status� �aid�jui %s d�l %s", playerName[id], reason);
	return 1;
}

YCMD:nuimtivipoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] != SAVININKAS) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");

	new Vardas[MAX_PLAYER_NAME], id;
	if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Nuimti V.I.P nar� (OFFLINE): /nuimtivipoff [Vardas_Pavard�]");

	id = GetPlayeridMid(Vardas);

	if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");
	mysql_format(connectionHandle, query, 140, "SELECT vip FROM zaidejai WHERE vardas = '%e'", Vardas);
	mysql_tquery(connectionHandle, query, "nuimtivip_off", "is", playerid, Vardas);
	return 1;
}

function nuimtivip_off(playerid, name[])
{
	if(cache_num_rows() > 0)
	{
		new vip_id;
		cache_get_value_index_int(0, 0, vip_id);

		if(vip_id == 0) return MSG(playerid, RED, "- �aid�jas n�ra V.I.P narys");

		SendFormat(playerid, GREEN, "+ Nu�m�te V.I.P nar� �aid�jui %s", name);

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET vip = '0', visp = '0', VipLaikas = '0' WHERE vardas = '%e'", name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, RED, "- Tokio �aid�j� duomen� baz�je n�ra");
	return 1;
}

YCMD:nuimtiadmin(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] != SAVININKAS) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");

	new id, reason[25];
	
	if(sscanf(params, "us[25]", id, reason)) return MSG(playerid, 0x00B8D8AA, "� Nuimti administratori�: /nuimtiadmin [Dalis vardo/ID] [Prie�astis]");

	if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
	if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s!");
	if(pInfo[id][ADMIN] == 0) return MSG(playerid, 0xFF0000AA, "- �aid�jas n�ra administratorius!");
	if(strlen(reason) > 24) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 24 simboliai");
	if(pInfo[id][ADMIN] > 3 && id != playerid) return MSG(playerid, RED, "- Didesnio nei 3 lygio administratoriaus statuso nuimti negalite!");

	pInfo[id][ADMIN] = 0;
	pInfo[id][AdminLaikas] = 0;

	SendFormat(id, GREEN, "� Administratori� pri�i�r�tojas %s nu�m� j�s� administratoriaus status� d�l %s", playerName[playerid], reason);
	SendFormat(playerid, GREEN, "+ Nu�m�te administratoriaus status� �aid�jui %s d�l %s", playerName[id], reason);
	return 1;
}

YCMD:nuimtiadminoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] != SAVININKAS) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");

	new Vardas[MAX_PLAYER_NAME], id;
	if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Nuimti administratori� (OFFLINE): /nuimtiadminoff [Vardas_Pavard�]");

	id = GetPlayeridMid(Vardas);

	if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");
	mysql_format(connectionHandle, query, 140, "SELECT admin FROM zaidejai WHERE vardas = '%e'", Vardas);
	mysql_tquery(connectionHandle, query, "nuimtiadmin_off", "is", playerid, Vardas);
	return 1;
}

function nuimtiadmin_off(playerid, name[])
{
	if(cache_num_rows() > 0)
	{
		new admin_id;
		cache_get_value_index_int(0, 0, admin_id);

		if(admin_id == 0) return MSG(playerid, RED, "- �aid�jas n�ra administratorius");

		SendFormat(playerid, GREEN, "+ Nu�m�te administratori� �aid�jui %s", name);

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET admin = '0', aisp = '0', AdminLaikas = '0' WHERE vardas = '%e'", name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, RED, "- Tokio �aid�j� duomen� baz�je n�ra");
	return 1;
}


YCMD:nuimtidrkoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new Vardas[MAX_PLAYER_NAME], id;
		if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Nuimti direktori� (OFFLINE): /nuimtidrkoff [Vardas_Pavard�]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 140, "SELECT direktorius FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "Nuimtidrkaoff", "is", playerid, Vardas);
	}
	return 1;
}

function Nuimtidrkaoff(playerid, name[])
{
	if(cache_num_rows() > 0)
	{
		new direktoriusid;
		cache_get_value_index_int(0, 0, direktoriusid);

		if(direktoriusid == 0) return MSG(playerid, RED, "- �aid�jas n�ra direktorius");

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET direktorius = '0', direktoriaus_ispejimai = '0' WHERE vardas = '%e'", name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		SendFormat(playerid, GREEN, "+ Nu�m�te direktori� �aid�jui %s", name);

		foreach(new i : Player)
		{
			if(pInfo[i][darbas] == direktoriusid)
			{
				pInfo[i][darbas] = 0;
				pInfo[i][uniforma] = 0;
				pInfo[i][wUniform] = 0;
				pInfo[i][workingSince] = EOS;
				SetPlayerSkin(i, pInfo[i][skin]);
				MSG(i, GREEN, "� Esate i�mesti i� darbo, d�l to, nes direktorius nu�alintas nuo pareig�!");
			}
		}

		mysql_format(connectionHandle, query, 144, "UPDATE zaidejai SET darbas = '0', wUniform = '0', uniforma = '0', isidarbino = '' WHERE darbas = '%i'", direktoriusid);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE darbai SET drk = '', drkpareigosenuo = '', drkisp = '0' WHERE jobID = '%i'", direktoriusid);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		DarboInfo[direktoriusid][drk] = EOS;
		DarboInfo[direktoriusid][drkpareigosenuo] = EOS;
		DarboInfo[direktoriusid][drkisp] = 0;
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra");
	return 1;
}

YCMD:nuimtidrk(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == DPRIZIURETOJAS)
	{
		new id, reason[25];
		if(sscanf(params, "us[25]", id, reason)) return MSG(playerid, 0x00B8D8AA, "� Nuimti direktori�: /nuimtidrk [Dalis vardo/ID] [Prie�astis]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s!");
		if(pInfo[id][direktorius] == 0) return MSG(playerid, 0xFF0000AA, "- �aid�jas n�ra direktorius!");
		if(strlen(reason) > 24) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 24 simboliai");

		SendFormat(playerid, GREEN, "+ Nu�m�te direktori� �aid�jui %s, d�l %s", playerName[id], reason);

		SendFormat(id, GREEN, "+ Direktori� pri�i�r�tojas %s nu�alino jus nuo direktoriaus d�l %s", playerName[playerid], reason);

		foreach(new i : Player)
		{
			if(pInfo[i][darbas] == pInfo[id][direktorius])
			{
				pInfo[i][darbas] = 0;
				pInfo[i][uniforma] = 0;
				pInfo[i][wUniform] = 0;
				pInfo[i][workingSince] = EOS;
				SetPlayerSkin(i, pInfo[i][skin]);
				if(i != id) MSG(i, GREEN, "� Esate i�mesti i� darbo, d�l to, nes direktorius nu�alintas nuo pareig�!");
			}
		}

		mysql_format(connectionHandle, query, 144, "UPDATE zaidejai SET darbas = '0', wUniform = '0', uniforma = '0', isidarbino = '' WHERE darbas = '%i'", pInfo[id][direktorius]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE darbai SET drk = '', drkpareigosenuo = '', drkisp = '0' WHERE jobID = '%i'", pInfo[id][direktorius]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		DarboInfo[pInfo[id][direktorius]][drk] = EOS;
		DarboInfo[pInfo[id][direktorius]][drkpareigosenuo] = EOS;
		DarboInfo[pInfo[id][direktorius]][drkisp] = 0;

		pInfo[id][darbas] = 0;
		pInfo[id][wUniform] = 0;
		pInfo[id][uniforma] = 0;
		pInfo[id][workingSince] = EOS;
		pInfo[id][direktorius] = 0;

		SetPlayerSkin(id, pInfo[id][skin]);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:ispetidrkoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == DPRIZIURETOJAS)
	{
		new Vardas[MAX_PLAYER_NAME], id, reason[25];
		if(sscanf(params, "s[24]s[25]", Vardas, reason)) return MSG(playerid, 0x00B8D8AA, "� �sp�ti direktori� (OFFLINE): /ispetidrkoff [Vardas_Pavard�] [Prie�astis]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");

		if(strlen(reason) > 24) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 24 simboliai");
		if(strlen(reason) <= 4) return MSG(playerid, RED, "- Prie�astis negali b�ti trumpesn� nei 5 simboliai");

		mysql_format(connectionHandle, query, 180, "SELECT direktorius, drkisp FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "Ispetidrkaoff", "iss", playerid, Vardas, reason);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function Ispetidrkaoff(playerid, name[], reason[])
{
	if(cache_num_rows() > 0)
	{
		new direktoriusid, direkoisp;

		cache_get_value_index_int(0,0, direktoriusid);
		if(direktoriusid == 0) return MSG(playerid, RED, "- �aid�jas n�ra direktorius!");

		cache_get_value_index_int(0,1, direkoisp);

		direkoisp ++;

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `priezastis`, `kasispejo`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')", \
		GautiData(0), reason, playerName[playerid], name, 5);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 200, "INSERT INTO `DrkIsp_vvp` (`data`, `priezastis`, `kasispejo`, `vardas`) VALUES ('%s', '%s', '%s', '%s')", \
			GautiData(0), reason, playerName[playerid], name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET direktoriaus_ispejimai = '%i' WHERE vardas = '%e'", direkoisp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE darbai SET drkisp = '%i' WHERE vardas = '%e'", direkoisp, name);
		mysql_tquery(connectionHandle, query, "SendQuery", ""); 

		if(direkoisp >= 3)
		{
			SendFormat(playerid, GREEN, "+ �sp�jote direktori� %s d�l %s jis surinko 3 �sp ir yra nu�alintas", name, reason);	

			mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET direktoriaus_ispejimai = '0' WHERE vardas = '%e'", name);
			mysql_tquery(connectionHandle, query, "SendQuery", "");
			foreach(new i : Player)
			{
				if(pInfo[i][darbas] == direktoriusid)
				{
					pInfo[i][darbas] = 0;
					pInfo[i][uniforma] = 0;
					pInfo[i][wUniform] = 0;
					pInfo[i][workingSince] = EOS;
					SetPlayerSkin(i, pInfo[i][skin]);
					MSG(i, GREEN, "� Esate i�mesti i� darbo, d�l to, nes direktorius nu�alintas nuo pareig�");
				}
			}		

			mysql_format(connectionHandle, query, 144, "UPDATE zaidejai SET darbas = '0', wUniform = '0', isidarbino = '', uniforma = '0' WHERE darbas = '%i'", name);
			mysql_tquery(connectionHandle, query, "SendQuery", "");

			mysql_format(connectionHandle, query, 140, "UPDATE darbai SET drk = '', drkisp = '0', drkpareigosenuo = '' WHERE jobID = '%i'", direktoriusid);
			mysql_tquery(connectionHandle, query, "SendQuery", "");
		}
		else
		{
			SendFormat(playerid, GREEN, "+ �sp�jote direktori� %s d�l %s, dabar jis turi %i �sp", name, reason, direkoisp);
		}

	}
	else return MSG(playerid, RED, "- Tokio �aid�jo n�ra duomen� baz�je!");
	return 1;
}

YCMD:dpzu(playerid, params[], help)
{
	if(pInfo[playerid][direktorius] > 0)
	{
		if(pInfo[playerid][Spectatina] == false)
		{
			new id;
			if(sscanf(params, "u",id )) return MSG(playerid, 0x00B8D8AA, "� Steb�ti darbuotoj�: /dpzu [Dalis vardo/ID]");
			if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, " Tokio �aid�jo n�ra!");
			if(id == playerid) return MSG(playerid, 0xFF0000AA, "- Sav�s steb�ti negalite!");
			if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
			if(pInfo[playerid][Surakintas] == true) return MSG(playerid, 0xFF0000AA, "- Negalite steb�ti darbuotojo kai esate surakintas!");
			if(bega[playerid]) return MSG(playerid, RED, "- Negalite steb�ti darbuotojo turint b�glio re�im�!");
			if(pInfo[playerid][direktorius] != pInfo[id][darbas]) return MSG(playerid, RED, "- �aid�jas ne j�s� darbuotojas!");
			if(pInfo[id][Spectatina]) return MSG(playerid, RED, "- Darbuotojas steb�jimo re�ime!");

			for(new slot=0; slot<12; slot++)GetPlayerWeaponData(playerid,slot,pInfo[playerid][spdata][slot],pInfo[playerid][spdata][12+slot]);

			pInfo[playerid][BeforeSpectatingSkin] = GetPlayerSkin(playerid);
            GetPlayerPos(playerid, pInfo[playerid][BeforeSpectatingX], pInfo[playerid][BeforeSpectatingY], pInfo[playerid][BeforeSpectatingZ]);
           	pInfo[playerid][BeforeSpectatingInterior] = GetPlayerInterior(playerid);
            pInfo[playerid][BeforeSpectatingWorld] = GetPlayerVirtualWorld(playerid);

            SetPlayerInterior(playerid, GetPlayerInterior(id));
            SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));

			SendFormat(playerid, -1, "{bec2c4}[ {09a9f9}> {bec2c4}] {ffffff}Stebite darbuotoj� {09a9f9}%s(%i)", playerName[id], id);

            TogglePlayerSpectating(playerid, 1);

            pInfo[playerid][Spectatina] = true;
            pInfo[playerid][SpectatingAtTarget] = id;
            pInfo[playerid][SpectatingAtPed] = true;

            PlayerSpectatePlayer(playerid, id);
		}
		else
		{
			pInfo[playerid][Spectatina] = false;
            SetPlayerVirtualWorld(playerid, pInfo[playerid][BeforeSpectatingWorld]);
            SetPlayerInterior(playerid, pInfo[playerid][BeforeSpectatingInterior]);
            SetSpawnInfo(playerid, NO_TEAM, pInfo[playerid][BeforeSpectatingSkin], pInfo[playerid][BeforeSpectatingX], pInfo[playerid][BeforeSpectatingY], pInfo[playerid][BeforeSpectatingZ], 0, 0, 0, 0, 0, 0, 0);
            TogglePlayerSpectating(playerid, 0);
            for(new slot=0; slot<12; slot++) GivePlayerWeapon(playerid,pInfo[playerid][spdata][slot],pInfo[playerid][spdata][12+slot]);
		}
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;	
}

YCMD:kviesti(playerid, params[], help)
{
	new str[120];
	if(pInfo[playerid][kvieciaID] > 0) return MSG(playerid, GREEN, "- I�kvietimas at�auktas"); pInfo[playerid][kvieciaID] = 0;

	format(str, sizeof(str), "{46BD17}�{ffffff} Medikai [{46BD17}%i aktyv�s{ffffff}]\n{46BD17}� {ffffff}Policija [{46BD17}%i aktyv�s{ffffff}]", GetWorkersCount(MEDIKAI, true), GetWorkersCount(POLICININKAI, true));
	ShowPlayerDialog(playerid, kviesti, DIALOG_STYLE_LIST, "{ffffff}Tarnyb� kvietimas", str, "Kviesti", "I�eiti");
	return 1;
}


YCMD:kill(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] >= IIILVLADMIN)
	{
        new id, String[128], Reason[65];
        if(sscanf(params, "us[64]",id, Reason)) return MSG(playerid, 0x00B8D8AA, "� Nu�udyti �aid�ja: /kill [Dalis vardo/ID][prie�astis]");
		if(bega[id] || pInfo[playerid][Surakintas]) return MSG(playerid, 0xFF0000AA, "- �aid�jas yra surakintas arba su b�glio statusu!");
        if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
        if(id == playerid) return MSG(playerid, 0xFF0000AA, "- Sav�s nuzudyti negalite!");
        if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
		if(pInfo[id][Spectatina]) return MSG(playerid, RED, "- �aid�jas steb�jimo re�ime!");
        switch(pInfo[playerid][ADMIN])
        {
			case IIILVLADMIN:
			{
			    if(pInfo[id][ADMIN] >= IIILVLADMIN) return MSG(playerid, -1, "{75B244}��� {FFFFFF}Auk�tesnio ir tokio pa�io rango administratori� nu�udyti negalite!");
		     	if(pInfo[id][ADMIN] == SAVININKAS && pInfo[playerid][ADMIN] != SAVININKAS) return MSG(playerid, 0xFF0000FF, "- LERG Komandos negalite atitildyti!");
			    if(pInfo[id][CmdAdminTimerKill] > gettime()) return SendFormat(playerid, 0xFF0000AA, "- �udyti �aid�ja galite kas 5min, kit� gal�site �udyti po: %s", ConvertSeconds(pInfo[playerid][CmdAdminTimerKill] - gettime()));
                pInfo[id][CmdAdminTimerKill] = gettime() + 300;//5min
				format(String, sizeof(String), "{75B244}��� {FFFFFF}Jus nu�ud� administratorius {33B7D3}%s{ffffff}. Prie�astis: {33B7D3}%s", playerName[playerid], Reason);
			}
			case SAVININKAS:
			{
			    format(String, sizeof(String), "{75B244}��� {FFFFFF}Jus nu�ud� Savininkas {33B7D3}%s{ffffff}. Prie�astis: {33B7D3}%s", playerName[playerid], Reason);
			}
        }
        ResetPlayerWeapons(id);
        MSG (id, -1, String);

		format(String, sizeof(String), "{75B244}��� {FFFFFF}Nu�ud�te �aideja {33B7D3}%s{ffffff}!", playerName[id]);
		MSG(playerid, -1, String);
		SetPlayerHealth(id, 0);
		KillTimer(leisgyvistimer[id]);
        
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:psarvus(playerid, params[], help)
{
	new id, Float:cords[3], msg[70];
	if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Parduoti �arvus: /psarvus [Dalis vardo/ID]");
	if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra");
	if(pInfo[playerid][darbas] != MEDIKAI) return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	if(playerid == id) return MSG(playerid, 0xFF0000AA, "- Sau parduoti �arv� negalite");
	if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
	if(pInfo[id][Surakintas]) return MSG(playerid, 0xFF0000AA, "- �aid�jas surakintas!");
	if(bega[id]) return MSG(playerid, RED, "- �aid�jas turi b�glio status�!");
	if(pInfo[id][Spectatina]) return MSG(playerid, RED, "- �aid�jas steb�jimo re�ime!");

	GetPlayerPos(id, cords[0], cords[1], cords[2]);

	if(!IsPlayerInRangeOfPoint(playerid, 5, cords[0], cords[1], cords[2])) return MSG(playerid, 0xFF0000AA, "- �aid�jas per toli!");

	pInfo[playerid][PasirinktasZaidejas] = id;

	format(msg, sizeof(msg), "{366735}Medikas {325928}%s {366735}si�lo jums pirkti �arvus u� {325928}1500�", playerName[playerid]);

	inline parduoti_sarvus(pid, did, resp, litem, string:input[])
	{
		#pragma unused pid, did, litem, input
		if(resp)
		{
			new rand = randomEx(30,80);

			if(pInfo[playerid][pinigai] < 1500)
			{
				MSG(playerid, RED, "- Neturite tiek pinig�!");
				MSG(id, RED, "- �aid�jas neturi tiek pinig�!");
			}
			MSG(playerid, GREEN, "+ Nusipirkote �arvus u� 1500�");

			SetPlayerArmour(playerid, 100);
			pInfo[playerid][pinigai] -= 1500;
			SendFormat(id, -1, "{00FFAA}� %s {ffffff}nupirko i� j�s� �arvus u� {00FFAA}1500�{ffffff}, gaunate {00FFAA}%i proc{ffffff} nuo sumos: {00FFAA}%i�",playerName[playerid], rand, (1500/100) * rand);

			pInfo[id][pinigai] += (1500/100) * rand;
			DarboInfo[1][DarboFondas] += 1500 - (1500 / 100 ) * rand;
		}
	}
	Dialog_ShowCallback(id, using inline parduoti_sarvus, DIALOG_STYLE_MSGBOX, "{ffffff}�arvai", msg, "Pirkti", "Nepirkti");
	return 1;
}

YCMD:pheal(playerid, params[], help)
{
	new id, Float:cords[3], msg[70];
	if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Parduoti pagydym�: /psarvus [Dalis vardo/ID]");
	if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra");
	if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
	if(pInfo[playerid][darbas] != MEDIKAI) return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	if(playerid == id) return MSG(playerid, 0xFF0000AA, "- Sau parduoti pagydymo negalite");
	if(pInfo[id][Surakintas]) return MSG(playerid, 0xFF0000AA, "- �aid�jas surakintas!");
	if(bega[id]) return MSG(playerid, RED, "- �aid�jas turi b�glio status�!");
	if(pInfo[id][Spectatina]) return MSG(playerid, RED, "- �aid�jas steb�jimo re�ime!");

	GetPlayerPos(id, cords[0], cords[1], cords[2]);

	if(!IsPlayerInRangeOfPoint(playerid, 5, cords[0], cords[1], cords[2])) return MSG(playerid, 0xFF0000AA, "- �aid�jas per toli!");

	pInfo[playerid][PasirinktasZaidejas] = id;

	format(msg, sizeof(msg), "Medikas %s si�lo jums pirkti pagydym� u� 700�", playerName[playerid]);

	inline parduoti_heal(pid, did, resp, litem, string:input[])
	{
		#pragma unused pid, did, litem, input
		if(resp)
		{
			new rand = randomEx(30,80);

			if(pInfo[playerid][pinigai] < 700)
			{
				MSG(playerid, RED, "- Neturite tiek pinig�!");
				MSG(id, RED, "- �aid�jas neturi tiek pinig�!");
			}
			MSG(playerid, GREEN, "+ Nusipirkote pagydym� u� 700�");

			SetPlayerHealth(playerid, 100);
			pInfo[playerid][pinigai] -= 700;

			SendFormat(id, -1, "{00FFAA}� %s {ffffff}nupirko i� j�s� pagydym� u� {00FFAA}700�{ffffff}, gaunate {00FFAA}%i proc{ffffff} nuo sumos: {00FFAA}%i�",playerName[playerid], rand, (700/100) * rand);

			pInfo[id][pinigai] += (700/100) * rand;
			DarboInfo[1][DarboFondas] += 700 - (700 / 100 ) * rand;
		}
	}
	Dialog_ShowCallback(id, using inline parduoti_heal, DIALOG_STYLE_MSGBOX, "{ffffff}Pagydymas", msg, "Pirkti", "Nepirkti");
	return 1;
}

YCMD:get(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][ADMIN] > IILVLADMIN)
	{
		new id, msg[200];
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Atiteleportuoti �aid�j� pas save: /get [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(id == playerid) return MSG(playerid, 0xFF0000AA, "- Sav�s atiteleportuoti negalite!");
		if(GetPlayerVirtualWorld(playerid) > 0) return MSG(playerid, 0xFF0000AA, "� Tu namuose arba pastate. Pakviesk �aid�j� � nam�.");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
		if(pInfo[playerid][Spectatina]) return MSG(playerid, 0xFF0000AA, "- Stebint �aid�jo pas save atiteleportuoti negalite");
		if(pInfo[id][Spectatina]) return MSG(playerid, 0xFF0000AA, "- �aid�jas steb�jimo re�ime");
		if(bega[id] && pInfo[playerid][ADMIN] < 4) return MSG(playerid, RED, "- �aid�jas turi b�glio status�");
		format(msg, sizeof(msg), "{ffffff}Administratorius {6e6387}%s{ffffff} nori atkelti jus pas save\n\nJeigu sutinkate spauskite �{6e6387}Sutinku{ffffff}�\nJeigu nesutinkate spauskite �{6e6387}Nesutinku{ffffff}�",playerName[playerid]);
		pInfo[id][PasirinktasZaidejas] = playerid;
		if(pInfo[playerid][ADMIN] < SAVININKAS) ShowPlayerDialog(id, get, DIALOG_STYLE_MSGBOX, "Teleportacija", msg, "Sutinku", "Nesutinku");

		new Float:cords[3];

		GetPlayerPos(playerid, cords[0], cords[1], cords[2]);

		SetPlayerPos(id, cords[0], cords[1], cords[2]);

		SetCameraBehindPlayer(id);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}
YCMD:to(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][ADMIN] > 0)
	{
		new id, msg[200];
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Teleportuotis pas �aid�j�: /to [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(id == playerid) return MSG(playerid, 0xFF0000AA, "- Pas save teleportuotis negalite!");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
		if(bega[id] && pInfo[playerid][ADMIN] < 4) return MSG(playerid, RED, "- �aid�jas turi b�glio status�");
		if(pInfo[playerid][Spectatina] == true) return MSG(playerid, RED, "- J�s steb�jimo re�ime!");
		format(msg, sizeof(msg), "{ffffff}Administratorius {6e6387}%s{ffffff} nori pas jus atsiteleportuoti\n\nJeigu sutinkate spauskite �{6e6387}Sutinku{fffffff}�\nJeigu nesutinkate spauskite �{6e6387}Nesutinku{ffffff}�", playerName[playerid]);
		pInfo[playerid][PasirinktasZaidejas] = id;

		if(pInfo[playerid][ADMIN] < SAVININKAS) ShowPlayerDialog(id, to, DIALOG_STYLE_MSGBOX, "{ffffff}Teleportacija", msg, "Sutinku", "Nesutinku");

		new Float:cords[3];

		GetPlayerPos(id, cords[0], cords[1], cords[2]);

		SetPlayerPos(playerid, cords[0], cords[1], cords[2]);

		SetCameraBehindPlayer(id);

		SetPlayerInterior(playerid, GetPlayerInterior(id));

		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:takew(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][ADMIN] > 0)
	{
		new id;
		if(sscanf(params, "u",id )) return MSG(playerid, 0x00B8D8AA, "� Atimti ginklus: /takew [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
		if(pInfo[id][ADMIN] == SAVININKAS && pInfo[playerid][ADMIN] != SAVININKAS) return MSG(playerid, 0xFF0000FF, "- LERG Komandos negalite nuginkluoti!");
		if(id == playerid && pInfo[playerid][ADMIN] < SAVININKAS) return MSG(playerid, 0xFF0000AA, "- Sav�s nuginkluoti negalite!");
		if(pInfo[playerid][Spectatina] == true) return MSG(playerid, 0xFF0000AA, "- Negalite �aid�jo nuginkluoti kuomet jis stebi kit� �aid�j�!");
		if(pInfo[playerid][Surakintas] == true) return MSG(playerid, 0xFF0000AA, "- Negalite �aid�jo nuginkluoti kuomet esant surakintam!");
		else if(bega[id]) return MSG(playerid, 0xFF0000AA, "- Negalite nuginkluoti �aid�jo kuris b�ga nuo teis�saugos!");
		else
		{
			SendFormat(id, 0x00B8D8AA, "- Administratorius %s(%i) nuginklavo jus!", playerName[playerid], playerid);
			ResetPlayerWeapons(id);
			SendFormat(playerid, 0x00B8D8AA, "� Nuginklavote %s(%i)", playerName[id], id);
		}
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:uzsaldyti(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][ADMIN] > IILVLADMIN)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� U��aldyti �aid�j�: /uzsaldyti [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(id == playerid) return MSG(playerid, 0xFF0000AA, "- Sav�s u��aldyti negalima!");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
		if(pInfo[id][ADMIN] == SAVININKAS && pInfo[playerid][ADMIN] != SAVININKAS) return MSG(playerid, 0xFF0000FF, "- LERG Komandos negalite uzsaldyti!");
		if(pInfo[id][Spectatina]) return MSG(playerid, 0xFF0000AA, "- �aid�jas steb�jimo status�");
		SendFormat(playerid, GREEN, "+ U��ald�te %s(%i)", playerName[id], id);
		SendFormat(id, GREEN, "� Administratorius %s(%i) u��ald� jus", playerName[playerid], playerid);
		SendFormatAdmin(GREEN, "� Administratorius %s(%i) u��ald� %s(%i)", playerName[playerid], playerid, playerName[id], id);
		TogglePlayerControllable(id, false);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:atsaldyti(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][ADMIN] > IILVLADMIN)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� At�aldyti �aid�j�: /atsaldyti [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(id == playerid) return MSG(playerid, 0xFF0000AA, "- Sav�s at�aldyti negalima!");
		if(pInfo[id][ADMIN] == SAVININKAS && pInfo[playerid][ADMIN] != SAVININKAS) return MSG(playerid, 0xFF0000FF, "- LERG Komandos negalite atsaldyti!");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
		SendFormat(playerid, GREEN, "+ At�ald�te %s(%i)", playerName[id], id);
		SendFormat(id, GREEN, "� Administratorius %s(%i) at�ald� jus", playerName[playerid], playerid);
		SendFormatAdmin(GREEN, "� Administratorius %s(%i) at�ald� %s(%i)", playerName[playerid], playerid, playerName[id], id);
		TogglePlayerControllable(id, true);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}


//Sav komandos
YCMD:sc(playerid, params[], help)
{
	#pragma unused help
	new string[90], msg[128];
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		if(pInfo[playerid][Muted] > 0)
		{
			format(string, sizeof( string), "- Jus u�tildytas, kalbeti galesite po: %s", \
			ConvertSeconds(pInfo[playerid][Muted] - gettime()));
			MSG(playerid, 0xFF0000AA, string);
			return 1;
		}
		if(sscanf(params, "s[128]", msg)) return MSG(playerid, 0x00B8D8AA, "� Ra�yti Savinink� chate: /sc [Tekstas]");
		if(strlen(msg) > 128) MSG( playerid, 0xFF0000AA, "- Tekstas per ilgas!");
		SendFormatSav(-1, "{f08080}[SAVININK�.CHAT] {f4525f}%s(%i){f08080}: {f4525f}%s",playerName[playerid], playerid, msg);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:skirtivip(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Paskirti VIP nariu: /skirtivip [Dalis Vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra");
		if(!online[playerid]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
		pInfo[id][VIP] = 1;
		pInfo[id][VipLaikas] = gettime() + thirtyDays;
		SendFormat(id, -1, "{21e136}+ Savininkas {1fbf79}%s{21e136} paskyr� jus VIP nariu. VIP naryst� galios {1fbf79}30{21e136} dien�", playerName[playerid]);

		SendFormat(playerid, -1, "{21e136}+ Paskyr�te {1fbf79}%s{21e136} VIP nariu",playerName[id]);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:skirtivippriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Skirti VIP nari� pri�i�r�tojumi: /skirtivippriz [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
		if(pInfo[id][priziuretojas] == VIPPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas jau VIP nari� pri�i�r�tojas");

		pInfo[id][priziuretojas] = VIPPRIZIURETOJAS;

		SendFormat(playerid, GREEN, "+ Paskyr�te %s VIP nari� pri�i�r�tojumi", playerName[id]);
		SendFormat(id, GREEN, "� Savininkas %s paskyr� jus VIP nari� pri�i�r�tojumi", playerName[playerid]);

		format(pInfo[id][prizpareigosenuo], 31, "%s", GautiData(0));
		format(VIPPRIZINFO[prizvardas], 24, "%s", playerName[id]);
		format(VIPPRIZINFO[prizpareigosenuo], 24, "%s", GautiData(0));

		mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '1', prizisp = '0', prizpareigosenuo = '%s' WHERE vardas = '%e'", \
			pInfo[id][prizpareigosenuo], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE vip_priz SET prizpareigosenuo = '%s', prizisp = '0', vardas = '%e'", \
			pInfo[id][prizpareigosenuo], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:nuimtidprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, Vardas[MAX_PLAYER_NAME];
		if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Nuimti direktori� pri�i�r�toj� (OFFLINE): /nuimtidprizoff [Vardas_Pavard�]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");

		mysql_format(connectionHandle, query, 140, "SELECT priziuretojas FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "Nuimtidprizaoff", "is", playerid, Vardas);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function Nuimtidprizaoff(playerid, name[])
{
	if(cache_num_rows() > 0)
	{
		new dprizid;
		cache_get_value_index_int(0,0, dprizid);

		if(dprizid == 0 || dprizid != DPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra direktori� pri�i�r�tojas");

		SendFormat(playerid, GREEN, "+ Nu�m�te direktori� pri�i�r�toj� %s", name);

		mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE dpriz SET vardas = '', prizpareigosenuo = '', prizisp = '0'");
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		DPRIZINFO[prizvardas] = EOS;

		DPRIZINFO[prizpareigosenuo] = EOS;

		DPRIZINFO[prizisp] = 0;
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra!");
	return 1;
}

YCMD:nuimtidpriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Nuimti direktori� pri�i�r�toj�: /nuimtidpriz [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
		if(pInfo[id][priziuretojas] != DPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra direktori� pri�i�r�tojas");

		pInfo[id][priziuretojas] = 0;
		pInfo[id][priziuretojausisp] = 0;
		pInfo[id][prizpareigosenuo] = EOS;

		DPRIZINFO[prizvardas] = EOS;
		DPRIZINFO[prizpareigosenuo] = EOS;
		DPRIZINFO[prizisp] = 0;

		SendFormat(playerid, GREEN, "+ Nu�m�te direktoriaus pri�i�r�tojaus status� �aid�jui %s", playerName[id]);
		SendFormat(id, GREEN, "� Savininkas %s nu�m� jums direktoriaus pri�i�r�tojaus status�", playerName[playerid]);

		mysql_format(connectionHandle, query, 140, "UPDATE dpriz SET prizpareigosenuo = '', prizisp = '0', vardas = ''");
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}


YCMD:nuimtivippriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Nuimti V.I.P pri�i�r�toj�: /nuimtivippriz [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
		if(pInfo[id][priziuretojas] != VIPPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra V.I.P pri�i�r�tojas");

		pInfo[id][priziuretojas] = 0;
		pInfo[id][priziuretojausisp] = 0;
		pInfo[id][prizpareigosenuo] = EOS;

		VIPPRIZINFO[prizvardas] = EOS;
		VIPPRIZINFO[prizpareigosenuo] = EOS;
		VIPPRIZINFO[prizisp] = 0;

		mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE vip_priz SET prizpareigosenuo = '', vardas = '', prizisp = '0'");
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:nuimtiunbanpriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Nuimti UNBAN pri�i�r�toj�: /nuimtiapriz [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
		if(pInfo[id][priziuretojas] != UNBANPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra UNBAN pri�i�r�tojas");

		pInfo[id][priziuretojas] = 0;
		pInfo[id][priziuretojausisp] = 0;
		pInfo[id][prizpareigosenuo] = EOS;

		UNBANPRIZ_INFO[prizvardas] = EOS;
		UNBANPRIZ_INFO[prizpareigosenuo] = EOS;
		UNBANPRIZ_INFO[prizisp] = 0;

		mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE unban_priz SET prizpareigosenuo = '', vardas = '', prizisp = '0'");
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:nuimtiapriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Nuimti administratori� pri�i�r�toj�: /nuimtiapriz [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
		if(pInfo[id][priziuretojas] != ADMINPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra administratori� pri�i�r�tojas");

		pInfo[id][priziuretojas] = 0;
		pInfo[id][priziuretojausisp] = 0;
		pInfo[id][prizpareigosenuo] = EOS;

		ADMINPRIZINFO[prizvardas] = EOS;
		ADMINPRIZINFO[prizpareigosenuo] = EOS;
		ADMINPRIZINFO[prizisp] = 0;

		mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE admin_priz SET prizpareigosenuo = '', vardas = '', prizisp = '0'");
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:nuimtiaprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new Vardas[MAX_PLAYER_NAME], id;
		if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Nuimti administratori� pri�i�r�toj� (OFFLINE): /nuimtiaprizoff [Vardas_Pavard�]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");
		
		mysql_format(connectionHandle, query, 140, "SELECT priziuretojas FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "nuimtiadminpriz_off", "is", playerid, Vardas);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function nuimtiadminpriz_off(playerid, neim[])
{
	if(cache_num_rows() > 0)
	{
		new adminpriz_id;

		cache_get_value_index_int(0, 0, adminpriz_id);

		if(adminpriz_id == 0 || adminpriz_id != ADMINPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra administratori� pri�i�r�tojas");
		
		SendFormat(playerid, GREEN, "+ Nu�m�te administratori� pri�i�r�toj� �aid�jui %s", neim);

		ADMINPRIZINFO[prizvardas] = EOS;
		ADMINPRIZINFO[prizpareigosenuo] = EOS;
		ADMINPRIZINFO[prizisp] = 0;

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", neim);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE admin_priz SET prizpareigosenuo = '', vardas = '', prizisp = '0'");
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra");
	return 1;
}

YCMD:nuimtivipprizoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new Vardas[MAX_PLAYER_NAME], id;
		if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Nuimti V.I.P pri�i�r�toj� (OFFLINE): /nuimtivipprizoff [Vardas_Pavard�]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, RED, "- �aid�jas prisijung�s");
		
		mysql_format(connectionHandle, query, 140, "SELECT priziuretojas FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "nuimtivip_prizoff", "is", playerid, Vardas);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function nuimtivip_prizoff(playerid, name[])
{
	if(cache_num_rows() > 0)
	{
		new vippriz_id;

		cache_get_value_index_int(0,0, vippriz_id);

		if(vippriz_id == 0 || vippriz_id != VIPPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas n�ra V.I.P pri�i�r�tojas");

		SendFormat(playerid, GREEN, "+ Nu�m�te V.I.P pri�i�r�toj� �aid�jui %s", name);

		VIPPRIZINFO[prizvardas] = EOS;
		VIPPRIZINFO[prizpareigosenuo] = EOS;
		VIPPRIZINFO[prizisp] = 0;

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET priziuretojas = '0', prizisp = '0', prizpareigosenuo = '' WHERE vardas = '%e'", name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 140, "UPDATE vip_priz SET prizpareigosenuo = '', vardas = '', prizisp = '0'");
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra!");
	return 1;
}

YCMD:skirtidpriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Skirti direktori� pri�i�r�tojumi: /skirtidpriz [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
		if(pInfo[id][priziuretojas] == DPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas jau direktori� pri�i�r�tojas");

		pInfo[id][priziuretojas] = DPRIZIURETOJAS;

		SendFormat(playerid, GREEN, "+ Paskyr�te %s direktori� pri�i�r�tojumi", playerName[id]);
		SendFormat(id, GREEN, "� Savininkas %s paskyr� jus direktori� pri�i�r�tojumi", playerName[playerid]);

		format(pInfo[id][prizpareigosenuo], 31, "%s", GautiData(0));
		format(DPRIZINFO[prizvardas], 24, "%s", playerName[id]);
		format(DPRIZINFO[prizpareigosenuo], 24, "%s", GautiData(0));

		mysql_format(connectionHandle, query, 180, "UPDATE dpriz SET prizpareigosenuo = '%s', vardas = '%e'", GautiData(0), playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '1', prizisp = '0', prizpareigosenuo = '%s' WHERE vardas = '%e'", pInfo[id][prizpareigosenuo], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:skirtiadminpriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Skirti administratori� pri�i�r�tojumi: /skirtiadminpriz [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
		if(pInfo[id][priziuretojas] == ADMINPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas jau administratori� pri�i�r�tojas");

		pInfo[id][priziuretojas] = ADMINPRIZIURETOJAS;

		format(pInfo[id][prizpareigosenuo], 31, "%s", GautiData(0));
		format(ADMINPRIZINFO[prizvardas], 24, "%s", playerName[id]);
		format(ADMINPRIZINFO[prizpareigosenuo], 24, "%s", GautiData(0));

		SendFormat(playerid, GREEN, "+ Paskyr�te %s administratori� pri�i�r�tojumi", playerName[id]);
		SendFormat(id, GREEN, "� Savininkas %s paskyr� jus administratori� pri�i�r�tojumi", playerName[playerid]);

		mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '2', prizisp = '0', prizpareigosenuo = '%s' WHERE vardas = '%e'", pInfo[id][prizpareigosenuo], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 180, "UPDATE admin_priz SET prizpareigosenuo = '%s', prizisp = '0', vardas = '%e'", pInfo[id][prizpareigosenuo], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:skirtiunbanpriz(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Skirti UNBAN pri�i�r�tojumi: /skirtiunbanpriz [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
		if(pInfo[id][priziuretojas] == UNBANPRIZIURETOJAS) return MSG(playerid, RED, "- �aid�jas jau UNBAN pri�i�r�tojas");

		pInfo[id][priziuretojas] = UNBANPRIZIURETOJAS;

		format(pInfo[id][prizpareigosenuo], 31, "%s", GautiData(0));
		format(UNBANPRIZ_INFO[prizvardas], 24, "%s", playerName[id]);
		format(UNBANPRIZ_INFO[prizpareigosenuo], 24, "%s", GautiData(0));

		SendFormat(playerid, GREEN, "+ Paskyr�te %s UNBAN pri�i�r�tojumi", playerName[id]);
		SendFormat(id, GREEN, "� Savininkas %s paskyr� jus UNBAN pri�i�r�tojumi", playerName[playerid]);

		mysql_format(connectionHandle, query, 180, "UPDATE zaidejai SET priziuretojas = '4', prizisp = '0', prizpareigosenuo = '%s' WHERE vardas = '%e'", pInfo[id][prizpareigosenuo], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 180, "UPDATE unban_priz SET prizpareigosenuo = '%s', prizisp = '0', vardas = '%e'", pInfo[id][prizpareigosenuo], playerName[id]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:skirtivipoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, Vardas[MAX_PLAYER_NAME];
		if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Skirti V.I.P nariu (OFFLINE): /skvipoff [Vardas_Pavarde]");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID || online[id]) return MSG(playerid, RED, "- �aid�jas prisijung�s");
		if(!IsValidNickName(Vardas)) return MSG(playerid, RED, "- Netinkama vardo forma. Tinkama vardo forma: Vardas_Pavarde");

		mysql_format(connectionHandle, query, 140, "SELECT vip FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "onSkirtiVIPOFF", "is", playerid, Vardas);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function onSkirtiVIPOFF(playerid, name[])
{
	if(cache_num_rows() > 0)
	{
		new vip_id;
		cache_get_value_index_int(0, 0, vip_id);

		if(vip_id > 0) return MSG(playerid, RED, "- �aid�jas jau yra V.I.P narys");

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET vip = '1', VipLaikas = '%i' WHERE vardas = '%e'", gettime() + thirtyDays, name);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		SendFormat(playerid, GREEN, "+ Paskyr�te �aid�j� %s V.I.P nariu 30(-iai) dien�", name);
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra");
	return 1;
}

YCMD:skirtidrkoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == DPRIZIURETOJAS)
	{
		new Vardas[MAX_PLAYER_NAME], id;
		if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Skirti direktoriumi (OFFLINE): /skirtidrkoff [Vardas_Pavard�]");
		if(!IsValidNickName(Vardas)) return MSG(playerid, RED, "- Neteisinga vardo forma. Turi atrodyti taip: Vardas_Pavard�");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, 0xFF0000AA, "- �aid�jas prisijung�s!");

		mysql_format(connectionHandle, query, 140, "SELECT direktorius FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "onSkirtiDRKOff", "is", playerid, Vardas);
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

function onSkirtiDRKOff(playerid, name[])
{
	if(cache_num_rows() > 0)
	{
		new direktoriaus_id;
		cache_get_value_index_int(0, 0, direktoriaus_id);

		if(direktoriaus_id > 0) return MSG(playerid, RED, "- �aid�jas jau yra direktorius");

		format(pInfo[playerid][PasirinktasZaidejasOFF], 24, "%s", name);
		inline skirtidireku_off(pid, did, resp, litem, string:input[])
		{
			#pragma unused pid, did, input
			if(resp)
			{
				switch(litem)
				{
					case 0:
					{
						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET direktorius = '1', drkpareigosenuo = '%s', direktoriaus_ispejimai = '0' WHERE vardas = '%e'", GautiData(0), pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");

						mysql_format(connectionHandle, query, 140, "UPDATE darbai SET drk = '%e', drkpareigosenuo = '%s', drkisp = '0' WHERE jobID = '%i'", pInfo[playerid][PasirinktasZaidejasOFF], GautiData(0), 1);
						mysql_tquery(connectionHandle, query, "SendQuery");

						SendFormat(playerid, GREEN, "+ Paskyr�te %s medik� direktoriumi!", pInfo[playerid][PasirinktasZaidejasOFF]);
					}
					case 1:
					{
						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET direktorius = '2', drkpareigosenuo = '%s', direktoriaus_ispejimai = '0' WHERE vardas = '%e'", GautiData(0), pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");

						mysql_format(connectionHandle, query, 140, "UPDATE darbai SET drk = '%e', drkpareigosenuo = '%s', drkisp = '0' WHERE jobID = '%i'", pInfo[playerid][PasirinktasZaidejasOFF], GautiData(0), 2);
						mysql_tquery(connectionHandle, query, "SendQuery");

						SendFormat(playerid, GREEN, "+ Paskyr�te %s policijos generaliniu komisaru!", pInfo[playerid][PasirinktasZaidejasOFF]);
					}
					case 2:
					{
						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET direktorius = '3', drkpareigosenuo = '%s', direktoriaus_ispejimai = '0' WHERE vardas = '%e'", GautiData(0), pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");

						mysql_format(connectionHandle, query, 140, "UPDATE darbai SET drk = '%e', drkpareigosenuo = '%s', drkisp = '0' WHERE jobID = '%i'", pInfo[playerid][PasirinktasZaidejasOFF], GautiData(0), 3);
						mysql_tquery(connectionHandle, query, "SendQuery");

						SendFormat(playerid, GREEN, "+ Paskyr�te %s armijos generolu!", pInfo[playerid][PasirinktasZaidejasOFF]);
					}
				}
			}
		}
		new buffer[100];
		format(buffer, sizeof(buffer), "� �aid�jo %s paskyrimas direktoriumi", pInfo[playerid][PasirinktasZaidejasOFF]);
		Dialog_ShowCallback(playerid, using inline skirtidireku_off, DIALOG_STYLE_LIST, buffer, "{DB9999}�{ffffff} Medik�\n{DB9999}�{ffffff} Policijos\n{DB9999}�{ffffff} Armijos", "Paskirti", "I�eiti");
	}
	else return MSG(playerid, RED, "- Tokio �aid�jo duomen� baz�je n�ra");
	return 1;
}

YCMD:skirtiadminoff(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new Vardas[MAX_PLAYER_NAME], id;
		if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Skirti administratoriumi (OFFLINE): /skirtiadminoff [Vardas_Pavard�]");
		if(!IsValidNickName(Vardas)) return MSG(playerid, RED, "- Neteisinga vardo forma. Turi atrodyti taip: Vardas_Pavard�");

		id = GetPlayeridMid(Vardas);

		if(id != INVALID_PLAYER_ID) return MSG(playerid, 0xFF0000AA, "- �aid�jas prisijung�s!");

		mysql_format(connectionHandle, query, 140, "SELECT admin FROM zaidejai WHERE vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "onSkirtiAdminuOff", "is", playerid, Vardas);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

function onSkirtiAdminuOff(playerid, name[])
{
	if(cache_num_rows() > 0)
	{
		new admino_id;
		cache_get_value_index_int(0, 0, admino_id);
		if(admino_id > 0) return MSG(playerid, RED, "- �aid�jas jau yra administratorius");
		
		format(pInfo[playerid][PasirinktasZaidejasOFF], 24, "%s", name);

		inline skirtiadminu_off(pid, did, resp, litem, string:input[])
		{
			#pragma unused pid, did, input
			if(resp)
			{
				switch(litem)
				{
					case 0:
					{	
						SendFormat(playerid, GREEN, "+ Paskyr�te %s � I lvl administratoriaus pareigas 30-�iai dien�", pInfo[playerid][PasirinktasZaidejasOFF]);

						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET admin = '1', AdminLaikas = '%i' WHERE vardas = '%e'", \
							gettime() + thirtyDays, pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}	
					case 1:
					{
						SendFormat(playerid, GREEN, "+ Paskyr�te %s � II lvl administratoriaus pareigas 30-�iai dien�", pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET admin = '2', AdminLaikas = '%i' WHERE vardas = '%e'", \
							gettime() + thirtyDays, pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
					case 2:
					{
						SendFormat(playerid, GREEN, "+ Paskyr�te %s � III lvl administratoriaus pareigas 30-�iai dien�", pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET admin = '3', AdminLaikas = '%i' WHERE vardas = '%e'", \
							gettime() + thirtyDays, pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
					case 3:
					{
						SendFormat(playerid, GREEN, "+ Paskyr�te %s komandos nariu", pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET admin = '4', AdminLaikas = '%i' WHERE vardas = '%e'", \
							gettime() + thirtyDays, pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
					case 4:
					{
						SendFormat(playerid, GREEN, "+ Paskyr�te %s savininku", pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET admin = '5', AdminLaikas = '%i' WHERE vardas = '%e'", \
							gettime() + thirtyDays, pInfo[playerid][PasirinktasZaidejasOFF]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
				}
			}
		}
		Dialog_ShowCallback(playerid, using inline skirtiadminu_off, DIALOG_STYLE_LIST, "{ffffff}Paskyrimas � ADMIN", "I lvl\nII lvl\nIII lvl\nKomandos narys\nIV lvl", "Paskirti", "I�eiti");
	}
	else return MSG(playerid, RED, "Tokio �aid�jo duomen� baz�je n�ra");
	return 1;
}

YCMD:skirtiadmin(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Paskirti administratoriumi: /skirtiadmin [Dalis Vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s!");

		pInfo[playerid][PasirinktasZaidejas] = id;

		inline skirtiadminu(pid, did, resp, litem, string:input[])
		{
			#pragma unused pid, did, input
			if(resp)
			{
				switch(litem)
				{
					case 1: // I lvl
					{
						pInfo[id][ADMIN] = ILVLADMIN;
						pInfo[id][AdminLaikas] = gettime() + thirtyDays;
						SendFormat(playerid, 0x00B8D8AA, "+ Paskyr�te %s I lygio administratoriumi", playerName[id]);
						SendFormat(id, 0x00B8D8AA, "+ Savininkas %s paskyr� jus I lygio administratoriumi (galios 30 dien�)", playerName[playerid]);
						SetPlayerColor(id, ADMIN_COLOR);
					}
					case 2: // II
					{
						pInfo[id][ADMIN] = IILVLADMIN;
						pInfo[id][AdminLaikas] = gettime() + thirtyDays;
						SendFormat(playerid, 0x00B8D8AA, "+ Paskyr�te %s II lygio administratoriumi", playerName[id]);
						SendFormat(id, 0x00B8D8AA, "+ Savininkas %s paskyr� jus II lygio administratoriumi (galios 30 dien�)", playerName[playerid]);
						SetPlayerColor(id, ADMIN_COLOR);
					}
					case 3: // III
					{
						pInfo[id][ADMIN] = IIILVLADMIN;
						pInfo[id][AdminLaikas] = gettime() + thirtyDays;
						SendFormat(playerid, 0x00B8D8AA, "+ Paskyr�te %s III lygio administratoriumi", playerName[id]);
						SendFormat(id, 0x00B8D8AA, "+ Savininkas %s paskyr� jus III lygio administratoriumi (galios 30 dien�)", playerName[playerid]);
						SetPlayerColor(id, ADMIN_COLOR);
					}
					case 4: //sav
					{
						pInfo[id][ADMIN] = SAVININKAS;
						SendFormat(playerid, 0x00B8D8AA, "+ Paskyr�te %s savininku", playerName[id]);
						SendFormat(id, 0x00B8D8AA, "+ Savininkas %s paskyr� jus savininku", playerName[playerid]);
						SetPlayerColor(id, OWNER_COLOR);
					}
					default: return Dialog_ShowCallback(playerid, using inline skirtiadminu, DIALOG_STYLE_LIST, "{ffffff}�aid�jo paskyrimas � administratoriaus pareigas", "Pasirinkite kelinto lygio administratoriumi norite paskirti �aid�j�\n\nI lygio\nII lygio\nIII lygio\nSavininkas", "Skirti", "I�eiti");
				}
			}
		}
		Dialog_ShowCallback(playerid, using inline skirtiadminu, DIALOG_STYLE_LIST, "{ffffff}�aid�jo paskyrimas � administratoriaus pareigas", "Pasirinkite kelinto lygio administratoriumi norite paskirti �aid�j�\n\nI lygio\nII lygio\nIII lygio\nSavininkas", "Skirti", "I�eiti");
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:skydas(playerid, params[], help)
{
	if(IsJobFromLaw(pInfo[playerid][darbas]))
	{
		if(SUSKYDU[playerid] == 0)
		{
			inline u_skydas(pid, did, resp, litem, string:input[])
			{
				#pragma unused pid, did, litem, input
				if(resp)
				{
					SUSKYDU[playerid] = true;
					SetPlayerAttachedObject(playerid, 1 , 18637, 1, 0, -0.1, 0.18, 90, 0, 272, 1, 1, 1);
				}
				else
				{
					SUSKYDU[playerid] = true;
					SetPlayerAttachedObject(playerid, 1, 18637, 4, 0.3, 0, 0, 0, 170, 270, 1, 1, 1);
				}
			}
			Dialog_ShowCallback(playerid, using inline u_skydas, DIALOG_STYLE_MSGBOX, "{ffffff}Skydo u�d�jimas", "Ant kurios pus�s norite u�d�ti skyd�?", "Nugaros", "Rankos");
		}
		else
		{
			RemovePlayerAttachedObject(playerid, 0);
			RemovePlayerAttachedObject(playerid, 1);
			SUSKYDU[playerid] = false;
			SendClientMessage(playerid, GREEN, "Skydas nuimtas");
		}
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

YCMD:spalva(playerid, params[], help)
{
	inline spalvos(pid, did, resp, litem, string:input[])
	{
		#pragma unused pid, did, input
		if(resp)
		{
			switch(litem)
			{
				case 1:
				{
					if(pInfo[playerid][VIP] == 1) SetPlayerColor(playerid, VIP_COLOR);
				}
				case 2:
				{
					if(pInfo[playerid][ADMIN] > 0) SetPlayerColor(playerid, ADMIN_COLOR);
				}
				case 3:
				{
					if(pInfo[playerid][ADMIN] == SAVININKAS) SetPlayerColor(playerid, OWNER_COLOR);
				}
				default: SetPlayerColor(playerid, DEFAULT_COLOR);
			}
		}
	}
	Dialog_ShowCallback(playerid, using inline spalvos, DIALOG_STYLE_LIST, "{ffffff}Spalva", "Paprasta\nVIP\nAdmin\nSavininkas", "Pasirinkti", "I�eiti");
	return 1;
}

YCMD:perkrautiserveri(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		if(sscanf(params, "n", ServerRestartTime)) return MSG(playerid, 0x00B8D8AA, "� Perkrauti server�: /perkrautiserveri [Laikas sekund�mis (20-180)]");
		if(ServerRestartTime > 180) return MSG(playerid, RED, "- Laikas negali b�ti didesnis negu 3 min!");
		if(ServerRestartTime < 20) return MSG(playerid, RED, "- Laikas negali b�ti ma�esnis negu 20 sec!");

		SetTimer("restartinam_serveri", 1000, true);
		SendClientMessageToAll(-1, "{813281}[SERVERIS]{ffffff} Numatomas {813281}serverio{ffffff} perkrovimas");
		SendFormatToAll(-1, "{813281}[SERVERIS]{ffffff} Serveris bus perkrautas po {813281}%i{ffffff} sekund�i�, skai�iuojamas laikas", ServerRestartTime);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

function restartinam_serveri()
{
	ServerRestartTime--;

	if(ServerRestartTime > 10) SendFormatToAll(-1, "{ffffff}Iki {813281}serverio{ffffff} perkrovimo liko {813281}%i{ffffff} sekund�i�", ServerRestartTime);

	if(ServerRestartTime < 10 )
	{
		foreach(new i : Player)
		{
			MSG(i, -1, "{ffffff}Serveris {813281}perkraunamas");
			_Kick(i);
		}
		SendRconCommand("password VTesRXe#BcEY@Z5u");
	}
	if(ServerRestartTime == 0) SendRconCommand("gmx");
	return 1;
}

YCMD:atblokuoti(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == UNBANPRIZIURETOJAS)
	{
		new Vardas[MAX_PLAYER_NAME];
		if(sscanf(params, "s[24]", Vardas)) return MSG(playerid, 0x00B8D8AA, "� Atblokuoti �aid�j�: /atblokuoti [Vardas_Pavard�]");

		mysql_format(connectionHandle, query, 140, "SELECT Vardas FROM banlist WHERE Vardas = '%e'", Vardas);
		mysql_tquery(connectionHandle, query, "OnAtblokuotiZaideja", "is", playerid, Vardas);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

function OnAtblokuotiZaideja(playerid, neimas[])
{
	if(cache_num_rows() > 0)
	{
		mysql_format(connectionHandle, query, 140, "DELETE FROM `banlist` WHERE `Vardas` = '%e'", neimas);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
		
		SendFormat(playerid, -1, "{ffffff}Atblokavote {E4AF6E}%s{ffffff} �aid�j�!", neimas);
	}
	else MSG(playerid, -1, "{ffffff}�aid�jas n�ra{E4AF6E} u�blokuotas");
}

YCMD:atblokuoti_ip(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new IP[17];
		if(sscanf(params, "s[17]", IP)) return MSG(playerid, 0x00B8D8AA, "� Atblokuoti �aid�j�: /atblokuoti_ip [IP adresas] ( PVZ 127.0.0.1 )");

		mysql_format(connectionHandle, query, 140, "SELECT IP FROM banlist WHERE IP = '%s'", IP);
		mysql_tquery(connectionHandle, query, "OnAtblokuotiZaidejaIP", "is", playerid, IP);
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

function OnAtblokuotiZaidejaIP(playerid, ipukas[])
{
	if(cache_num_rows() > 0)
	{
		mysql_format(connectionHandle, query, 140, "DELETE FROM `banlist` WHERE `IP` = '%s'", ipukas);
		mysql_tquery(connectionHandle, query, "SendQuery", "");		
		
		SendFormat(playerid, -1, "{ffffff}Atblokavote {E4AF6E}%s{ffffff} IP adres�!", ipukas);
	}
	else MSG(playerid, -1, "{ffffff}�aid�jas n�ra{E4AF6E}u�blokuotas");
	return 1;
}


YCMD:skomandos(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new list[1000];

		strcat(list, "\t{CF9F94}Savininko komandos\n\n{CF9F94}/s{ffffff} - prane�ti vie�ai\n{CF9F94}/ac{ffffff} - administratori� chat'as\n{CF9F94}/bausti{ffffff} - �aid�jo baudimas\n{CF9F94}/to{ffffff} - atsiteleportuoti pas �aid�j�");
		strcat(list, "\n{CF9F94}/get{ffffff} - atiteleportuoti �aid�j� pas save\n{CF9F94}/takew{ffffff} - atimti ginklus\n{CF9F94}/uzsaldyti{ffffff} - u��aldyti �aid�j�\n{CF9F94}/atsaldyti{ffffff} - at�aldyti �aid�j�");
		strcat(list, "\n{CF9F94}/sc{ffffff} - savinink� chat'as\n{CF9F94}/nuimtivippriz{ffffff} - nuimti V.I.P pri�i�r�toj�\n{CF9F94}/nuimtivipprizoff{ffffff} - nuimti V.I.P pri�i�r�toj� atsijungusiam �aid�jui");
		strcat(list, "\n{CF9F94}/skirtidpriz{ffffff} - paskirti �aid�j� direktori� pri�i�r�tojumi\n{CF9F94}/skirtidprizoff{ffffff} - paskirti atsijungus� �aid�j� direktori� pri�i�r�tojumi");
		strcat(list, "\n{CF9F94}/skirtiadminpriz{ffffff} - paskirti �aid�j� administratori� pri�i�r�tojumi\n{CF9F94}/skirtiadminprizoff{ffffff} - paskirti atsijungus� �aid�j� administratori� pri�i�r�tojumi");

		ShowPlayerDialog(playerid, savkomandos, DIALOG_STYLE_MSGBOX, "Savinink� komandos", list, "2 psl", "");
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:mute(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS)
	{
		new id, time, tipas;
		if(sscanf(params, "unn", id, time, tipas)) return MSG(playerid, 0x00B8D8AA, "� U�tildyti �aid�j�: /mute [Dalis Vardo/ID][Laikas][Tipas 0 temp 1 perma]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra!");
		if(!online[id]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neprisijung�s");
		if(id == playerid) return MSG(playerid, 0xFF0000AA, "- Sav�s u�tildyti negalima!");
		if(tipas > 1 || tipas < 0) return MSG(playerid, RED, "- U�tildymo tipas gali b�ti tik 0 arba 1");
		if(pInfo[playerid][Muted] > 0 || pInfo[playerid][permamute] == 1) return MSG(playerid, RED, "- �aid�jas jau u�tildytas");

		if(tipas == 0)
		{
			pInfo[id][Muted] = gettime() + (time * 60);
			MuteTime[id] = SetTimerEx("Mute", 1000, true, "i",id);
			format(pInfo[id][KasUztilde], 24, "%s'", playerName[playerid]);
			SendFormatToAll(-1, "{75B244}��� {FFFFFF}Savininkas {33B7D3}%s {ffffff}u�tild� �aid�j� {33B7D3}%s{ffffff}!", playerName[playerid], playerName[id]);
			SendFormatToAll(-1, "{75B244}��� {FFFFFF}Laikas: {33B7D3}%s!", ConvertSeconds(pInfo[id][Muted]));

			mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET mutelaikas = '%i', perma_mute = '0', adminmutename = '%e' WHERE vardas = '%e'", pInfo[id][Muted], playerName[playerid], playerName[id]);
			mysql_tquery(connectionHandle, query, "SendQuery", "");
		}
		else
		{
			pInfo[id][Muted] = 0;
			MuteTime[id] = SetTimerEx("Mute", 1000, true, "i",id);
			pInfo[id][permamute] = 1;
			format(pInfo[id][KasUztilde], 24, "%s'", playerName[playerid]);
			SendFormatToAll(-1, "{75B244}��� {FFFFFF}Savininkas {33B7D3}%s {ffffff}u�tild� �aid�j� {33B7D3}%s{ffffff}!", playerName[playerid], playerName[id]);
			SendClientMessageToAll(-1, "{75B244}��� {FFFFFF}Laikas: {33B7D3}Visam!");

			mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET perma_mute = '1', adminmutename = '%e' WHERE vardas = '%e'", playerName[playerid], playerName[id]);
			mysql_tquery(connectionHandle, query, "SendQuery", "");
		}
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}


YCMD:vprizkomandos(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][priziuretojas] == VIPPRIZIURETOJAS)
	{
		new list[1000];
		strcat(list, "\t{CF9F94}V.I.P pri�i�r�tojaus komandos\n\n{CF9F94}/vispeti{ffffff} - �sp�ti V.I.P nar�\n{CF9F94}/pskelbti{ffffff} - skelbti prane�im�\n{CF9F94}/atsisakytivpriz{ffffff} - atsisakyti V.I.P nari� pri�i�r�tojaus");
		strcat(list, "\n{CF9F94}/vispetioff{ffffff} - �sp�ti atsijungus� V.I.P nar�\n{CF9F94}/nuispvip{ffffff} - nuimti �sp�jim� V.I.P nariui\n{CF9F94}/nuispvipoff{ffffff} - nuimti �sp�jim� atsijungusiam V.I.P nariui");
		ShowPlayerDialog(playerid, vipprizkomandos, DIALOG_STYLE_MSGBOX, "{ffffff}V.I.P pri�i�r�tojaus komandos", list, "Supratau", "");
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:aprizkomandos(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][priziuretojas] == ADMINPRIZIURETOJAS)
	{
		new list[1000];
		strcat(list, "\t{CF9F94}Administratori� pri�i�r�tojaus komandos\n\n{CF9F94}/aispeti{ffffff} - �sp�ti admin nar�\n{CF9F94}/pskelbti{ffffff} - skelbti prane�im�");
		strcat(list, "\n{CF9F94}/nuispadmin{ffffff} - nuimti �sp�jim� administratoriui\n{CF9F94}/nuispadminoff{ffffff} - nuimti �sp�jim� atsijungusiam administratoriui");
		strcat(list, "\n{CF9F94}/atsisakytiadminpriz{ffffff} - atsisakyti administratori� pri�i�r�tojaus pareig�\n{CF9F94}/aispetioff{ffffff} - �sp�ti atsijungus� administratori�");
		ShowPlayerDialog(playerid, aprizkomandos, DIALOG_STYLE_MSGBOX, "{ffffff}Admin pri�i�r�tojaus komandos", list, "Supratau", "");
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:unbanprizkomandos(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][priziuretojas] == UNBANPRIZIURETOJAS)
	{
		new list[1000];
		strcat(list, "\t{CF9F94}UNBAN pri�i�r�tojaus komandos\n\n{CF9F94}/atsisakytiunbanpriz{ffffff} - atsisakyti UNBAN pri�i�r�tojaus pareig�");
		strcat(list, "\n{CF9F94}/atblokuoti - atblokuoti �aid�j�");
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:dprizkomandos(playerid, params[], help)
{
	#pragma unused help
	if(pInfo[playerid][priziuretojas] == DPRIZIURETOJAS)
	{
		new list[1000];
		strcat(list, "\t{CF9F94}Direktori� pri�i�r�tojaus komandos\n\n{CF9F94}/ispetidrk{ffffff} - �sp�ti direktori�\n{CF9F94}/ispetidrkoff{ffffff} - �sp�ti atsijungus� direktori�");
		strcat(list, "\n{CF9F94}/nuispdrk{ffffff} - nuimti �sp�jim� direktoriui\n{CF9F94}/nuispdrkoff{ffffff} - nuimti �sp�jim� atsijungusiam direktoriui");
		strcat(list, "\n{CF9F94}/atsisakytidpriz{ffffff} - atsisakyti direktoriaus pri�i�r�tojaus pareig�\n{CF9F94}/skirtidrk{ffffff} - skirti �aid�j� direktoriumi");
		strcat(list, "\n{CF9F94}/skirtidrkoff{ffffff} - skirti atsijungus� �aid�j� direktoriumi");
		ShowPlayerDialog(playerid, dprizkomandos, DIALOG_STYLE_MSGBOX, "{ffffff}Direktori� pri�i�r�tojaus komandos", list, "Supratau", "");
	}
	else return MSG(playerid, -1, "{CC0000}KLAIDA: {ffffff}Apgailestaujame, tokia komanda neegzistuoja! Naudokite komand�: /komandos");
	return 1;
}

YCMD:skirtidrk(playerid, params[], help)
{
	if(pInfo[playerid][ADMIN] == SAVININKAS || pInfo[playerid][priziuretojas] == DPRIZIURETOJAS)
	{
		new id;
		if(sscanf(params, "u", id)) return MSG(playerid, 0x00B8D8AA, "� Skirti direktoriumi: /skirtidrk [Dalis vardo/ID]");
		if(!IsPlayerConnected(id)) return MSG(playerid, 0xFF0000AA, "- Tokio �aid�jo n�ra");
		if(!online[id]) return MSG(playerid, RED, "- �aid�jas neprisijung�s");
		if(pInfo[id][direktorius] > 0) return MSG(playerid, RED, "- �aid�jas kitos firmos direktorius");

		pInfo[playerid][PasirinktasZaidejas] = id;

		inline skirtidrk(pid, did, resp, litem, string:input[])
		{
			#pragma unused pid, did, input
			if(resp)
			{
				switch(litem)
				{
					case 0:
					{
						if(!isnull(DarboInfo[MEDIKAI][drk])) return MSG(playerid, RED, "- Medik� direktorius jau paskirtas");
						id = pInfo[playerid][PasirinktasZaidejas];

						pInfo[id][direktorius] = MEDIKAI;

						format(DarboInfo[MEDIKAI][drk], 24, "%s", playerName[id]);
						format(DarboInfo[MEDIKAI][drkpareigosenuo], 31, "%s", GautiData(0));
						format(pInfo[id][direkopareigosenuo], 31, "%s", GautiData(0));

						SendFormat(playerid, GREEN, "+ Paskyr�te %s(%i) medik� direktoriumi", playerName[id], id);

						SendFormat(id, GREEN, "� Direktori� pri�i�r�tojas %s(%i) paskyr� jus medik� direktoriumi", playerName[playerid], playerid);

						mysql_format(connectionHandle, query, 180, "UPDATE darbai SET drkpareigosenuo = '%s', drk = '%s' WHERE jobID = '%i'", GautiData(0), playerName[id], pInfo[id][direktorius]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");

						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET drkpareigosenuo = '%s' WHERE vardas = '%e'", pInfo[id][direkopareigosenuo], playerName[id]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");

					}
					case 1:
					{
						if(!isnull(DarboInfo[POLICININKAI][drk])) return MSG(playerid, RED, "- Policijos departamento generalinis komisaras jau paskirtas");
						id = pInfo[playerid][PasirinktasZaidejas];

						pInfo[id][direktorius] = POLICININKAI;

						format(DarboInfo[POLICININKAI][drk], 24, "%s", playerName[id]);
						format(DarboInfo[POLICININKAI][drkpareigosenuo], 31, "%s", GautiData(0));
						format(pInfo[id][direkopareigosenuo], 31, "%s", GautiData(0));

						SendFormat(playerid, GREEN, "+ Paskyr�te %s(%i) policijos generaliniu komisaru", playerName[id], id);

						SendFormat(id, GREEN, "� Direktori� pri�i�r�tojas %s(%i) paskyr� jus policijos generaliniu komisaru", playerName[playerid], playerid);

						mysql_format(connectionHandle, query, 180, "UPDATE darbai SET drkpareigosenuo = '%s', drk = '%s' WHERE jobID = '%i'", \
							GautiData(0), playerName[id], pInfo[id][direktorius]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					
						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET drkpareigosenuo = '%s' WHERE vardas = '%e'", pInfo[id][direkopareigosenuo], playerName[id]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
					case 2:
					{
						if(!isnull(DarboInfo[ARMIJA][drk])) return MSG(playerid, RED, "- Armijos generolas jau paskirtas");
						id = pInfo[playerid][PasirinktasZaidejas];

						pInfo[id][direktorius] = ARMIJA;

						format(DarboInfo[ARMIJA][drk], 24, "%s", playerName[id]);
						format(DarboInfo[ARMIJA][drkpareigosenuo], 31, "%s", GautiData(0));
						format(pInfo[id][direkopareigosenuo], 31, "%s", GautiData(0));

						SendFormat(playerid, GREEN, "+ Paskyr�te %s(%i) armijos generolu", playerName[id], id);

						SendFormat(id, GREEN, "� Direktori� pri�i�r�tojas %s(%i) paskyr� jus armijos generolu", playerName[playerid], playerid);

						mysql_format(connectionHandle, query, 180, "UPDATE darbai SET drkpareigosenuo = '%s', drk = '%s' WHERE jobID = '%i'", \
							GautiData(0), playerName[id], pInfo[id][direktorius]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
						
						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET drkpareigosenuo = '%s' WHERE vardas = '%e'", \
							pInfo[id][direkopareigosenuo], playerName[id]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
				}
			}
		}
		Dialog_ShowCallback(playerid, using inline skirtidrk, DIALOG_STYLE_LIST, "{ffffff}�aid�jo paskyrimas � direktoriaus pareigas", "Medik�\nPolicijos\nArmijos", "Paskirti", "I�eiti");
	}
	else return MSG(playerid, -1, "{e9967a}KLAIDA:{ffffff} Apgailestaujame, tokia komanda neegzistuoja");
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new m = GetVehicleModel(vehicleid);
	#pragma unused m//kolkas nenaudosim

	if(newstate == PLAYER_STATE_PASSENGER)
	{
		new ambulancedriver = GetVehicleDriver(vehicleid);
		if(IsPlayerInVehicle(ambulancedriver, sizeof(medikucar)))
		{
			if(bega[playerid]) return 1;
			inline medikupaslaugos(pid, dialogid, response, listitem, string:inputtext[])
			{
				#pragma unused pid, dialogid, inputtext
				if(response)
				{
					switch(listitem)
					{
						case 1: // heal
						{
							new rand = randomEx(30,80);
							if(pInfo[playerid][pinigai] < 1500) return MSG(playerid, RED, "- Neturite 1500 �");
							SetPlayerArmour(playerid, 100);
							pInfo[playerid][pinigai] -= 1500;
							MSG(playerid, GREEN, "+ Nusipirkote �arvus u� 1500�");
							SendFormat(ambulancedriver, -1, "{00FFAA}� %s {ffffff}nupirko i� j�s� �arvus u� {00FFAA}1500�{ffffff}, gaunate {00FFAA}%i\%{ffffff} nuo sumos: {00FFAA}%i�", playerName[playerid], rand, (1500 / 100) * rand);
							DarboInfo[1][DarboFondas] += 1500 - (1500/100) * rand;
							pInfo[ambulancedriver][pinigai] += (1500/100) * rand;
							Dialog_ShowCallback(playerid, using inline medikupaslaugos, DIALOG_STYLE_LIST, "Medik� paslaugos", "{228b22}�{ffffff} Pirkti �arvus - {228b22}1500�\n� {ffffff}Pirkti pagydym� - {228b22}700�", "Pirkti", "I�eiti");
						}
						default:
						{
							new rand = randomEx(30,80);
							if(pInfo[playerid][pinigai] < 700) return MSG(playerid, RED, "- Neturite 1500 �");
							SetPlayerHealth(playerid, 100);
							pInfo[playerid][pinigai] -= 700;
							MSG(playerid, GREEN, "+ Nusipirkote pagydym� u� 700�");
							SendFormat(ambulancedriver, GREEN, "{00FFAA}� %s {ffffff}nupirko i� j�s� pagydym� u� {00FFAA}700�{ffffff}, gaunate {00FFAA}%i\%{ffffff} nuo sumos, gausite: {00FFAA}%i�", playerName[playerid], rand, (1500/100) * rand);
							DarboInfo[1][DarboFondas] += 700 - (700/100) * rand;
							pInfo[ambulancedriver][pinigai] += (700/100) * rand;
							Dialog_ShowCallback(playerid, using inline medikupaslaugos, DIALOG_STYLE_LIST, "Medik� paslaugos", "{228b22}�{ffffff} Pirkti �arvus - {228b22}1500�\n�{ffffff} Pirkti pagydym� - {228b22}700�", "Pirkti", "I�eiti");
						}
					}
				}
			}
			Dialog_ShowCallback(playerid, using inline medikupaslaugos, DIALOG_STYLE_LIST, "Medik� paslaugos", "{228b22}�{ffffff} Pirkti �arvus - {228b22}1500�\n� {ffffff}Pirkti pagydym� - {228b22}700�", "Pirkti", "I�eiti");
		}
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
		if(vehicleid == medikucar[0])
		{
			if(pInfo[playerid][darbas] != MEDIKAI)
			{
				RemovePlayerFromVehicle(playerid);
				MSG(playerid, RED, "- J�s ne medikas");
			}
		}
		if(vehicleid == pdcar[0] || vehicleid == pdcar[1])
		{
			if(pInfo[playerid][darbas] != POLICININKAI)
			{
				RemovePlayerFromVehicle(playerid);
				MSG(playerid, RED, "- J�s ne pareig�nas");
			}
		}
		if(vehicleid == armijoscar[0])
		{
			if(pInfo[playerid][darbas] != ARMIJA)
			{
				RemovePlayerFromVehicle(playerid);
				MSG(playerid, RED, "- J�s ne kareivis");
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(IskvietimoCP[playerid])
	{
		new id, Float:cords[3];
		id = pInfo[playerid][PasirinktasZaidejas];
		GetPlayerPos(id, cords[0], cords[1], cords[2]);

		if(IsPlayerInRangeOfPoint(playerid, 2,cords[0], cords[1], cords[2]))
		{
			switch(pInfo[playerid][darbas])
			{
				case MEDIKAI:
				{
					KillTimer(Iskvietimotimer[playerid]);
					DisablePlayerCheckpoint(playerid);
					pInfo[playerid][viskvmed] = false;

					SendFormat(id, GREEN, "� Medikas %s atvyko pas jus!", playerName[playerid]);

					pInfo[id][kvieciaID] = 0;

					SendFormatToJob(MEDIKAI, -1, "{f49e42}[RACIJA]: %s atvyko pas %s", playerName[playerid], playerName[id]);

					SetPlayerColor(id, DEFAULT_COLOR);
				}
				case POLICININKAI:
				{
					KillTimer(Iskvietimotimer[playerid]);
					DisablePlayerCheckpoint(playerid);
					pInfo[playerid][viskvmed] = false;

					pInfo[id][kvieciaID] = 0;

					SendFormat(id, GREEN, "� Pareig�nas %s atvyko pas jus!", playerName[playerid]);

					SendFormatToJob(POLICININKAI, -1, "{f49e42}[RACIJA]: %s atvyko pas %s", playerName[playerid], playerName[id]);

					SetPlayerColor(id, DEFAULT_COLOR);
				}
			}
		}
	}
	return 1;
}


public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	foreach(new i : Player)
	{
		if(!online[i]) continue;
		if(!strcmp(ip, IPAS[i], true))
		{
			if(strcmp("Admin_MAXX", playerName[i], false) && strcmp("Admin_Mantas", playerName[i], false)) return _Kick(i);
		}
	}
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(!online[playerid]) return 0;
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == pickups[0][admbauda])
	{
		mysql_format(connectionHandle, query, 140, "SELECT * FROM zaideju_baudos_administracines WHERE kamskirta = '%e'", playerName[playerid]);
		mysql_tquery(connectionHandle, query, "OnPickupSumoketAdmBauda", "i", playerid);
	}
	if(pickupid == pickups[0][gunlicbuypickup])
	{
		if(pInfo[playerid][glic] == 1) return MSG(playerid, RED, "- J�s jau turite ginkl� licenzij�");

		inline buyglic(pid, did, resp, litem, string:input[])
		{
			#pragma unused pid, did, litem, input
			if(resp)
			{
				if(pInfo[playerid][pinigai] < 5000) return MSG(playerid, RED, "- J�s neturite pakankamai pinig�");

				pInfo[playerid][glic] = 1;
				pInfo[playerid][pinigai] -= 5000;
				MSG(playerid, -1, "{ffffff}Sveikiname {946a50}�sigijus {ffffff}ginkl� {946a50}licenzij�{ffffff}!");
			}
		}
		Dialog_ShowCallback(playerid, using inline buyglic, DIALOG_STYLE_MSGBOX, "{ffffff}Ginkl� licenzijos �sigyjimas", "{946a50}Ginkl� {ffffff}licenzija jums kainuos {946a50}5000�\n\n{ffffff}Ar tikrai norite j� {946a50}�sigyti{ffffff}?", "Taip", "Ne");
	}
	if(pickupid == pickups[0][ginklinesgun])
	{
		if(pInfo[playerid][glic] == 0)
		{
			ShowPlayerDialog(playerid, noglic, DIALOG_STYLE_MSGBOX, "Ginkl� parduotuv�", "Pirmiausia �sigykite ginkl� licenzij�!", "Supratau", "");
		}
		else
		{
			inline pirktigunpardej(pid, did, resp, litem, string:input[])
			{
				#pragma unused pid, did, input
				if(resp)
				{
					switch(litem)
					{
						case 0: // Ak
						{
							if(pInfo[playerid][pinigai] < 24000) return MSG(playerid, RED, "- Neturite tiek pinig�!");
							else
							{
								GivePlayerWeapon(playerid, WEAPON_AK47, 100);
								pInfo[playerid][pinigai] -= 24000;
								MSG(playerid, GREEN, "Nusipirkote AK-47 su 100 kulk� u� 24.000�");
							}
						}
						case 1: /// DGL
						{
							if(pInfo[playerid][pinigai] < 24000) return MSG(playerid, RED, "- Neturite tiek pinig�!");
							else
							{
								GivePlayerWeapon(playerid, WEAPON_DEAGLE, 100);
								pInfo[playerid][pinigai] -= 24000;
								MSG(playerid, GREEN, "Nusipirkote Deagle su 100 kulk� u� 24.000�");
							}
						}
						case 2: // shotgun
						{
							if(pInfo[playerid][pinigai] < 2400) return MSG(playerid, RED, "- Neturite tiek pinig�!");
							else
							{
								GivePlayerWeapon(playerid, WEAPON_SHOTGUN, 100);
								pInfo[playerid][pinigai] -= 24000;
								MSG(playerid, GREEN, "Nusipirkote Shotgun su 100 kulk� u� 24.000�");
							}
						}
					}
				}
			}
			Dialog_ShowCallback(playerid, using inline pirktigunpardej, DIALOG_STYLE_TABLIST_HEADERS, "{ffffff}Ginkl� parduotuv�", \
			"{ffffff}Ginklas\t{ff8c00}Kaina\t{ffffff}Kulk� skai�ius\n\
			{ffffff}AK-47\t{ff8c00}24.000�\t{ffffff}100\n\
			{ffffff}Deagle\t{ff8c00}24.000�\t{ffffff}100\n\
			{ffffff}Shotgun\t{ff8c00}24.000�\t{ffffff}100\n",\
			"Pasirinkti", "I�eiti");
		}
		return 1;
	}
	if(pickupid == pickups[0][medikuisidarbinimas])
	{
		if(pInfo[playerid][darbas] == 1) return MSG(playerid, 0xFF0000FF, "- Norint palikti darb� /paliktidarba");   // medikai
		if(pInfo[playerid][darbas] != 0) return MSG(playerid, 0xFF0000FF, "- J�s jau turite darb�");
		if(GetPlayerScore(playerid) < MEDIKU_XP) return MSG(playerid, 0xFF0000FF, "- Neturite pakankamai patirties!");
		if(pInfo[playerid][Invited] != MEDIKAI) return MSG(playerid, 0xFF0000FF, "{ff8c00}�{ffffff} Direktorius {ff8c00}nepakviet�{ffffff} j�s� dirbti �io darbo!");
		if(!pInfo[playerid][sveikatpaz]) return MSG(playerid, 0xFF0000FF, "- Neturite sveikatos pa�ym�jimo");
		PlayerPlaySound(playerid,1149,0.0,0.0,0.0 );

		pInfo[playerid][darbas] = MEDIKAI;
		pInfo[playerid][skin] = GetPlayerSkin(playerid);

		if(pInfo[playerid][lytis] == 0)
		{
			pInfo[playerid][wUniform] = 1;
			pInfo[playerid][uniforma] = 276;
			SetPlayerSkin(playerid, pInfo[playerid][uniforma]);
			ApplyAnimation(playerid,"PLAYIDLES","stretch",4.1,0,0,0,0,0);
		}
		else if(pInfo[playerid][lytis] == 1)
		{
			pInfo[playerid][wUniform] = 1;
			pInfo[playerid][uniforma] = 308;
			SetPlayerSkin(playerid, pInfo[playerid][uniforma]);
			ApplyAnimation(playerid,"PLAYIDLES","stretch",4.1,0,0,0,0,0);
		}

		SendFormatToJob(MEDIKAI, -1, "{f49e42}[RACIJA]: %s katik �sidarbino", playerName[playerid]);

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET darbas = '%i' WHERE vardas = '%e'", pInfo[playerid][darbas], playerName[playerid]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		pInfo[playerid][Invited] = 0;

		format(pInfo[playerid][workingSince], 31, "%s", GautiData(0));
	}
	if(pickupid == pickups[0][pdisidarbinimas])
	{
		if(pInfo[playerid][darbas] == POLICININKAI) return MSG(playerid, 0xFF0000FF, "� Norint palikti darba /paliktidarba");
		if(pInfo[playerid][darbas] != 0) return MSG(playerid, 0xFF0000FF, "� J�s jau turite darb�!");
		if(pInfo[playerid][Invited] != POLICININKAI) return MSG(playerid, 0xFF0000FF, "{ff8c00}�{ffffff} Direktorius {ff8c00}nepakviet�{ffffff} j�s� dirbti �io darbo!");
		if(GetPlayerScore(playerid) < POLICININKU_XP) return MSG(playerid, RED, "� Jus nepakankamai patyr�s!");
		if(!pInfo[playerid][sveikatpaz]) return MSG(playerid, 0xFF0000FF, "- Neturite sveikatos pa�ym�jimo");

		PlayerPlaySound(playerid,1149,0.0,0.0,0.0 );

		pInfo[playerid][darbas] = POLICININKAI;
		pInfo[playerid][skin] = GetPlayerSkin(playerid);
		MSG(playerid, 0xFF0000FF, "� Policijos darbo komandos - /policija");

		if(pInfo[playerid][lytis] == 0)
		{
			pInfo[playerid][uniforma] = 280;
			pInfo[playerid][wUniform] = 1;
			SetPlayerSkin(playerid, pInfo[playerid][uniforma]);
			ApplyAnimation(playerid,"PLAYIDLES","stretch",4.1,0,0,0,0,0);
		}
		else
		{
			pInfo[playerid][uniforma] = 307;
			pInfo[playerid][wUniform] = 1;
			SetPlayerSkin(playerid, pInfo[playerid][uniforma]);
			ApplyAnimation(playerid,"PLAYIDLES","stretch",4.1,0,0,0,0,0);
		}

		SendFormatToJob(POLICININKAI, -1, "{f49e42}[RACIJA]: %s katik �sidarbino!", playerName[playerid]);

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET darbas = '%i' WHERE vardas = '%e'", pInfo[playerid][darbas], playerName[playerid]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		pInfo[playerid][Invited] = 0;
		format(pInfo[playerid][workingSince], 31,"%s", GautiData(0));
	}
	if(pickupid == pickups[0][armijosisidarbinimas])
	{
		if(pInfo[playerid][darbas] == ARMIJA) return MSG(playerid, 0xFF0000FF, "� Norint palikti darba /paliktidarba");
		if(pInfo[playerid][darbas] != 0) return MSG(playerid, 0xFF0000FF, "� J�s jau turite darb�!");
		if(GetPlayerScore(playerid) < ARMIJOS_XP) return MSG(playerid, RED, "� Jus nepakankamai patyr�s!");
		if(pInfo[playerid][Invited] != ARMIJA) return MSG(playerid, 0xFF0000FF, "{ff8c00}�{ffffff} Direktorius {ff8c00}nepakviet�{ffffff} j�s� dirbti �io darbo!");
		if(!pInfo[playerid][sveikatpaz]) return MSG(playerid, 0xFF0000FF, "- Neturite sveikatos pa�ym�jimo");

		PlayerPlaySound(playerid,1149,0.0,0.0,0.0 );

		pInfo[playerid][darbas] = ARMIJA;
		pInfo[playerid][skin] = GetPlayerSkin(playerid);
		MSG(playerid, 0xFF0000FF, "� Armijos darbo komandos - /armija");

		if(pInfo[playerid][lytis] == 0)
		{
			pInfo[playerid][uniforma] = 287;
			pInfo[playerid][wUniform] = 1;
			SetPlayerSkin(playerid, pInfo[playerid][uniforma]);
			ApplyAnimation(playerid,"PLAYIDLES","stretch",4.1,0,0,0,0,0);
		}
		else
		{
			pInfo[playerid][uniforma] = 191;
			pInfo[playerid][wUniform] = 1;
			SetPlayerSkin(playerid, pInfo[playerid][uniforma]);
			ApplyAnimation(playerid,"PLAYIDLES","stretch",4.1,0,0,0,0,0);
		}

		SendFormatToJob(ARMIJA, -1, "{f49e42}[RACIJA]: %s katik �sidarbino!", playerName[playerid]);

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET darbas = '%i' WHERE vardas = '%e'", pInfo[playerid][darbas], playerName[playerid]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		pInfo[playerid][Invited] = 0;
		format(pInfo[playerid][workingSince], 31,"%s", GautiData(0));
	}
	if(pickupid == pickups[0][medinfo])
	{
		new str[200], fstr[700];
		format(str, 60 , "{A4CAA2}Sveiki, �ia ra�oma informacija apie darb�:\n\n");

		strcat(fstr, str);

		new id;

		id = GetPlayeridMid(DarboInfo[MEDIKAI][drk]);


		if(isnull(DarboInfo[MEDIKAI][drk])) format(str, 150 , "{ffffff}Direktorius: {A4CAA2}Nei�rinktas\n\n");

		else
		{
			if(id != INVALID_PLAYER_ID) format(str, sizeof(str) , "{ffffff}Direktorius: {A4CAA2}%s{ffffff}, pareigose nuo {A4CAA2}%s{ffffff} �iuo metu jis {A4CAA2}yra{ffffff} �aidime\n\n", DarboInfo[MEDIKAI][drk], DarboInfo[MEDIKAI][drkpareigosenuo]);
			else format(str, 150 , "{ffffff}Direktorius: {A4CAA2}%s{ffffff}, pareigose nuo {A4CAA2}%s{ffffff} �iuo metu jis {A4CAA2}n�ra {ffffff}�aidime\n\n", DarboInfo[MEDIKAI][drk], DarboInfo[MEDIKAI][drkpareigosenuo]);

		}

		strcat(fstr, str);

		format(str, sizeof(str) , "{ffffff}Darbas reikalauja {A4CAA2}direktoriaus{ffffff} pakvietimo\nNorint �sidarbinti reikia tur�ti {A4CAA2}%s{ffffff} XP\n\n", konvertuoti_pinigus(MEDIKU_XP));

		strcat(fstr, str);

		format(str, sizeof(str), "{ffffff}Dienos {A4CAA2}reikalavimai{ffffff}: {A4CAA2}%i min, %i pagydym�", DarboInfo[MEDIKAI][dienosminimumasMIN], DarboInfo[MEDIKAI][dienosminimumasPAGYD]);

		strcat(fstr, str);

		ShowPlayerDialog(playerid, MEDIKUINFO, DIALOG_STYLE_MSGBOX, "Informacija", fstr, "Supratau", "");
	}
	if(pickupid == pickups[0][pdinfo])
	{
		new str[200], fstr[700];
		format(str, 60 , "{A4CAA2}Sveiki, �ia ra�oma informacija apie darb�:\n\n");

		strcat(fstr, str);

		new id;

		id = GetPlayeridMid(DarboInfo[POLICININKAI][drk]);

		if(isnull(DarboInfo[POLICININKAI][drk])) format(str, 150 , "{ffffff}Direktorius: {A4CAA2}Nei�rinktas\n\n");

		else
		{
			if(id != INVALID_PLAYER_ID) format(str, 150 , "{ffffff}Direktorius: {A4CAA2}%s{ffffff}, pareigose nuo {A4CAA2}%s{ffffff} �iuo metu jis {A4CAA2}yra {ffffff}�aidime\n\n", DarboInfo[POLICININKAI][drk], DarboInfo[POLICININKAI][drkpareigosenuo]);
			else format(str, 150 , "{ffffff}Direktorius: {A4CAA2}%s{ffffff}, pareigose nuo {A4CAA2}%s{ffffff} �iuo metu jis {A4CAA2}n�ra{ffffff} {A4CAA2}�aidime\n\n", DarboInfo[POLICININKAI][drk], DarboInfo[POLICININKAI][drkpareigosenuo]);
		}

		strcat(fstr, str);

		format(str, sizeof(str) , "{ffffff}Darbas reikalauja {A4CAA2}direktoriaus{ffffff} pakvietimo\nNorint �sidarbinti reikia tur�ti {A4CAA2}%s{ffffff} XP\n\n", konvertuoti_pinigus(POLICININKU_XP));

		strcat(fstr, str);

		format(str, sizeof(str), "{ffffff}Dienos {A4CAA2}reikalavimai{ffffff}: {A4CAA2}%i min, %i baud�", DarboInfo[POLICININKAI][dienosminimumasMIN], DarboInfo[POLICININKAI][dienosminimumasBAUDOS]);

		strcat(fstr, str);

		ShowPlayerDialog(playerid, PDINFO, DIALOG_STYLE_MSGBOX, "Informacija", fstr, "Supratau", "");
	}
	if(pickupid == pickups[0][armijosinfo])
	{
		new str[200], fstr[700];
		format(str, 60 , "{A4CAA2}Sveiki, �ia ra�oma informacija apie darb�:\n\n");

		strcat(fstr, str);

		new id;

		id = GetPlayeridMid(DarboInfo[ARMIJA][drk]);

		if(isnull(DarboInfo[ARMIJA][drk])) format(str, 150 , "{ffffff}Direktorius: {A4CAA2}Nei�rinktas\n\n");

		else
		{
			if(id != INVALID_PLAYER_ID) format(str, 150 , "{ffffff}Generolas: {A4CAA2}%s{ffffff}, pareigose nuo {A4CAA2}%s{ffffff} �iuo metu jis {A4CAA2}yra {ffffff}�aidime\n\n", DarboInfo[ARMIJA][drk], DarboInfo[ARMIJA][drkpareigosenuo]);
			else format(str, 150, "{ffffff}Generolas: {A4CAA2}%s{ffffff}, pareigose nuo {A4CAA2}%s{ffffff} �iuo metu yra {A4CAA2}n�ra{ffffff} {A4CAA2}�aidime\n\n", DarboInfo[ARMIJA][drk], DarboInfo[ARMIJA][drkpareigosenuo]);
		}

		strcat(fstr, str);

		format(str, sizeof(str) , "{ffffff}Darbas reikalauja {A4CAA2}direktoriaus{ffffff} pakvietimo\nNorint �sidarbinti reikia tur�ti {A4CAA2}%s{ffffff} XP\n\n", konvertuoti_pinigus(POLICININKU_XP));

		strcat(fstr, str);

		format(str, sizeof(str), "{ffffff}Dienos {A4CAA2}reikalavimai{ffffff}: {A4CAA2}%i min, %i baud�", DarboInfo[ARMIJA][dienosminimumasMIN], DarboInfo[ARMIJA][dienosminimumasBAUDOS]);

		strcat(fstr, str);

		ShowPlayerDialog(playerid, PDINFO, DIALOG_STYLE_MSGBOX, "Informacija", fstr, "Supratau", "");
	}
	if(pickupid == pickups[0][sveikatospaz])
	{
		if(pInfo[playerid][sveikatpaz]) return MSG(playerid, RED, "- J�s jau turite sveikatos pa�ym�!");
		inline buypaz(pid, did, resp, litem, string:input[])
		{
			#pragma unused pid, did, litem, input
			if(resp)
			{
				if(pInfo[playerid][pinigai] < 5000) return MSG(playerid, RED, "- Neturite tiek pinig�!");
				pInfo[playerid][sveikatpaz] = true;
				pInfo[playerid][sveikatpazlaikas] = gettime() + sevenDays;
				pInfo[playerid][pinigai] -= 5000;

				MSG(playerid, GREEN, "+ Nusipirkote sveikatos pa�ym�! Ji galios 7 dienas");
			}
		}
		Dialog_ShowCallback(playerid, using inline buypaz, DIALOG_STYLE_MSGBOX, "Sveikatos pa�yma", "Ar tikrai norite pirkti sveikatos pa�ym�?\n\nPa�yma kainuoja 5.000�", "Taip", "Ne");
	}
	return 1;
}


public OnVehicleMod(playerid, vehicleid, componentid)
{
	if(GetPlayerInterior(playerid) == 0 && pInfo[playerid][ADMIN] != SAVININKAS)
	{
		//Tikrinti ar toje zonoje tuninimo nera
		SendFormatAdmin(0xFF0000FF, "�aid�jas %s tiuninguoja automobil� su nelegaliomis programomis!",playerName[playerid]);
		Kick(playerid);
		RemoveVehicleComponent(vehicleid, componentid);
		return 0;
	}
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_SECONDARY_ATTACK)
	{
		//-------------------------------------------------------------------------------------------------------------------
		/*if(IsPlayerInRangeOfPoint(playerid, 1.0, -2664.7969,640.1555,14.4531))//ligonines iejimas
		{
		    SetPlayerInterior(playerid, 3);
		    SetPlayerPos(playerid, -204.5060,-1736.0486,675.7687);
  		}
  		if(IsPlayerInRangeOfPoint(playerid, 1.0, -204.6047,-1736.0876,675.7687)) // ligonines isejimas
  		{ 
  			if(pInfo[playerid][LaikoLigoninej] > 0) return MSG(playerid, RED, "J�s� dar nepaleido i� ligonin�s!");
  		    SetPlayerInterior(playerid, 0);
  		    SetPlayerPos(playerid, -2664.7969,640.1555,14.4531);
  		}*/
  		//-------------------------------------------------------------------------------------------------------------------
  		if(IsPlayerInRangeOfPoint(playerid, 1.0, -2720.3792,127.8134,7.0391)) // bankas
  		{
  			SetPlayerInterior(playerid, 0);
  			SetPlayerPos(playerid, 2315.952880,-1.618174,26.742187);
  		}
  		if(IsPlayerInRangeOfPoint(playerid, 1.0, 2315.952880,-1.618174,26.742187))
  		{
  		    SetPlayerInterior(playerid, 0);
  		    SetPlayerPos(playerid, -2720.3792,127.8134,7.0391);
  		}
  		//-------------------------------------------------------------------------------------------------------------------
  		if(IsPlayerInRangeOfPoint(playerid, 1.0, -2719.2256,-318.3883,7.8438)) //viriausybe
  		{
  			SetPlayerInterior(playerid, 3);
  			SetPlayerPos(playerid, 384.808624,173.804992,1008.382812);
  		}
  		if(IsPlayerInRangeOfPoint(playerid, 1.0, 384.808624,173.804992,1008.382812))
  		{
  		    SetPlayerInterior(playerid, 0);
  		    SetPlayerPos(playerid, -2719.2256,-318.3883,7.8438);
  		}
  		//-------------------------------------------------------------------------------------------------------------------
  		if(IsPlayerInRangeOfPoint(playerid, 1.0, -2626.4158,208.4830,4.8125)) // g parduotuves iejimas
  		{
  			SetPlayerInterior(playerid, 1);
  			SetPlayerPos(playerid, 286.148986,-40.644397,1001.515625);
  		}
  		if(IsPlayerInRangeOfPoint(playerid, 1.0, 285.3084,-41.6712,1001.5156)) // g pardes isejimas
  		{
  			SetPlayerInterior(playerid, 0);
  			SetPlayerPos(playerid, -2626.4158,208.4830,4.8125);
  		}
  		//-------------------------------------------------------------------------------------------------------------------
  		if(IsPlayerInRangeOfPoint(playerid, 1.0,-2425.6616,337.7326,37.0011)) //Hotelis
  		{
  		    SetPlayerInterior(playerid, 15);
  		    SetPlayerPos(playerid, 2214.7173,-1150.7694,1025.7969);
  		}
  		if(IsPlayerInRangeOfPoint(playerid, 1.0,2214.7173,-1150.7694,1025.7969))
  		{
  		    SetPlayerInterior(playerid, 0);
  		    SetPlayerPos(playerid, -2425.6616,337.7326,37.0011);
  		}
  		//-------------------------------------------------------------------------------------------------------------------
  		if(IsPlayerInRangeOfPoint(playerid, 1.0,-2025.1653,-102.4753,35.1719)) //VM
  		{
  		    SetPlayerPos(playerid, -2016.5596,-92.9655,700.9688);
			SetPlayerInterior(playerid, 0);
  		}
  		if(IsPlayerInRangeOfPoint(playerid, 1.0,-2016.5596,-92.9655,700.9688)) // VM I��jimas
  		{
  		    SetPlayerPos(playerid, -2025.1653,-102.4753,35.1719);
  		    SetPlayerInterior(playerid, 0);
  		}
  		//-------------------------------------------------------------------------------------------------------------------

  		if(IsPlayerInRangeOfPoint(playerid, 1.0, -1605.4402,710.5978,13.8672)) // pd
		{
			SetPlayerInterior(playerid, 10);
			SetPlayerPos(playerid, 246.375991,109.245994,1003.218750);
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.0, 246.5946,108.4236,1003.2188))
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, -1605.4402,710.5978,13.8672); // pd
  		}
  		//-------------------------------------------------------------------------------------------------------------------
  	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(pInfo[playerid][AFK_Label] != Text3D:INVALID_3DTEXT_ID)
	{
		Delete3DTextLabel(pInfo[playerid][AFK_Label]);
		pInfo[playerid][AFK_Label] = Text3D:INVALID_3DTEXT_ID;
	}

	pInfo[playerid][AFK_Stat] = false;

	foreach(new i : Player)
	{
		if(online[i])
		{
			if(GetPlayerMoney(i) != pInfo[i][pinigai])
			{
				ResetPlayerMoney(i);
				GivePlayerMoney(i, pInfo[i][pinigai]);
			}
			if(GetPlayerScore(i) != pInfo[i][patirtis])
			{
				SetPlayerScore(i, pInfo[i][patirtis]);
			}
		}
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
		new VHicle = GetPlayerVehicleID(playerid);
		for(new SpikeID = 0;SpikeID <= GetPlayerPoolSize();SpikeID++)
		{
    		if(SpygliaiInfo[SpikeID][arPadeti] == true)
       		 {
          	 	if(IsPlayerInRangeOfPoint(playerid, 3, SpygliaiInfo[SpikeID][SpygliaiX],SpygliaiInfo[SpikeID][SpygliaiY],SpygliaiInfo[SpikeID][SpygliaiZ]))
        	    {	
               		new panels, doors, lights, tires;
                	GetVehicleDamageStatus(VHicle, panels, doors, lights, tires);
                	tires = encode_tires(1, 1, 1, 1);
                	UpdateVehicleDamageStatus(VHicle, panels, doors, lights, tires);
                	break;
           		}
			}
		}
	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == savkomandos)
	{
		if(response)
		{
			new list[1000];
			strcat(list, "\n{CF9F94}/skirtivippriz{ffffff} - skirti V.I.P pri�i�r�toj�\n{CF9F94}/skirtivipprizoff{ffffff} - skirti V.I.P pri�i�r�toju atsijungus� �aid�j�");
			strcat(list, "\n{CF9F94}/nuispdrk{ffffff} - nuimti �sp�jim� direktoriui\n{CF9F94}/nuispdrkoff{ffffff} - nuimti �sp�jim� atsijungusiam direktoriui");
			strcat(list, "\n{CF9F94}/ispetivippriz{ffffff} - �sp�ti V.I.P pri�i�r�toj�\n{CF9F94}/ispetivipprizoff{ffffff} - �sp�ti atsijungus� V.I.P pri�i�r�toj�\n{CF9F94}/nuispvippriz{ffffff} - nuimti �sp�jim� V.I.P pri�i�r�tojui");
			strcat(list, "\n{CF9F94}/nuispvipprizoff{ffffff} - nuimti �sp�jim� atsijungusiam V.I.P pri�i�r�tojui\n{CF9F94}/perkrautiserveri{ffffff} - perkrauti server�");
			strcat(list, "\n{CF9F94}/atblokuoti{ffffff} - atblokuoti �aid�j�\n{CF9F94}/atblokuoti_ip{ffffff} - atblokuoti �aid�j� pagal IP\n{CF9F94}/mute{ffffff} - u�tildyti �aid�j�(CUSTOM)");
			strcat(list, "\n{CF9F94}/nuimtivipoff{ffffff} - nuimti V.I.P nar� atsijungusiam �aid�jui\n{CF9F94}/aispetioff{ffffff} - �sp�ti atsijungus� administratori�");
			ShowPlayerDialog(playerid, savkomandos1, DIALOG_STYLE_MSGBOX, "{ffffff}Savinink� komandos | 2psl", list, "3 psl", "");
		}
		return 1;
	}
	if(dialogid == savkomandos1)
	{
		if(response)
		{
			new list[1000];
			strcat(list, "\n{CF9F94}/nuimtiapriz{ffffff} - nuimti administratori� pri�i�r�toj�\n{CF9F94}/nuimtiaprizoff{ffffff} - nuimti administratori� pri�i�r�toj� atsijungusiam �aid�jui");
			strcat(list, "\n{CF9F94}/ispetiapriz{ffffff} - �sp�ti administratori� pri�i�r�toj�\n{CF9F94}/ispetiaprizoff{ffffff} - �sp�ti atsijungus� administratori� pri�i�r�toj�");
			strcat(list, "\n{CF9F94}/nuispapriz{ffffff} - nuimti �sp�jim� administratori� pri�i�r�tojui\n{CF9F94}/nuispaprizoff{ffffff} - nuimti �sp�jim� atsijungusiam administratori� pri�i�r�tojui");
			strcat(list, "\n{CF9F94}/skirtiunbanpriz{ffffff} - skirti �aid�j� UNBAN pri�i�r�tojumi\n{CF9F94}/nuimtiunbanpriz{ffffff} - nuimti �aid�jui UNBAN pri�i�r�tojaus pareigas");
			strcat(list, "\n{CF9F94}/nuimtiadminoff{ffffff} - nuimti administratori� atsijungusiam �aid�jui\n{CF9F94}/ispetiunbanpriz{ffffff} - �sp�ti UNBAN pri�i�r�toj�");
			strcat(list, "\n{CF9F94}/ispetiunbanprizoff{ffffff} - �sp�ti atsijungus� UNBAN pri�i�r�toj�");
			ShowPlayerDialog(playerid, savkomandos2, DIALOG_STYLE_MSGBOX, "{ffffff}Savinink� komandos | 3psl", list, "4 psl", "");
		}
		return 1;
	}
	if(dialogid == savkomandos2)
	{
		if(response)
		{
			new list[1000];
			strcat(list, "\n{CF9F94}/skirtivipoff{ffffff} - paskirti atsijungus� �aid�j� V.I.P nariu\n{CF9F94}/skirtiadminoff{ffffff} - paskirti atsijungus� �aid�j� administratoriumi");
			strcat(list, "\n{CF9F94}/nuispunbanpriz{ffffff} - nuimti �sp�jim� UNBAN pri�i�r�tojui\n{CF9F94}/nuispunbanprizoff{ffffff} - nuimti �sp�jim� atsijungusiam UNBAN pri�i�r�tojui");
			strcat(list, "\n{CF9F94}/rlogas{ffffff} - racijos logai\n{CF9F94}/nuispvip{ffffff} - nuimti �sp�jim� V.I.P nariui\n{CF9F94}/nuispvipoff{ffffff} - nuimti �sp�jim� atsijungusiam V.I.P nariui");
			strcat(list, "\n");
			ShowPlayerDialog(playerid, savkomandos3, DIALOG_STYLE_MSGBOX, "{ffffff}Savinink� komandos | 4psl", list, "Supratau", "");
		}
		return 1;
	}
	if(dialogid == dvp)
	{
		switch(listitem)
		{
			case 0: // workers list
			{
				if(response)
				{
					mysql_format(connectionHandle, query, 140,  "SELECT vardas FROM `zaidejai` WHERE `darbas` = '%i'", pInfo[playerid][direktorius]);
					mysql_tquery(connectionHandle, query, "OnPlayerRequestWorkersList", "i", playerid);
				}
			}
			case 1: // Priimti darbuotoj�
			{
				if(response)
				{
					new string[300], xpKiekis;
					switch(pInfo[playerid][direktorius])
					{
						case MEDIKAI: xpKiekis = MEDIKU_XP;
						case POLICININKAI: xpKiekis = POLICININKU_XP;
						case ARMIJA: xpKiekis = ARMIJOS_XP;
					}
					format(string, sizeof(string), "{ffffff}Direktoriau, {4bbaed}%s{ffffff}, nor�damas priimti �aid�j� � darb� �sitikinkite, kad jis:\n\n\t1. Neturi {4bbaed}darbo{ffffff}\n\t2. Neturi galiojan�io {4bbaed}darbo{ffffff} pakvietimo\n\t3. Turi {4bbaed}%s{ffffff} patirties\n\t4. Turi galiojant� {4bbaed}sveikatos pa�ym�", \
						playerName[playerid], konvertuoti_pinigus(xpKiekis));
					ShowPlayerDialog(playerid, priimtidarbuotoja, DIALOG_STYLE_INPUT, "Priimti �aid�j� � darb�", string, "Priimti", "Atgal");
				}
			}
			case 2: // dzinute
			{
				if(response)
				{
					inline dzinute(pi, di, resp, litem, string:input[])
					{
						#pragma unused pi, di, input
						if(resp)
						{
							switch(litem)
							{
								case 0:
								{	
									inline dzinute1(pi1, di1, resp1, litem1, string:input1[])
									{
										#pragma unused pi1, di1, litem1
										if(resp1)
										{
											if(strlen(input1) > 120) return MSG(playerid, RED, "- �inut� negali b�ti ilgesn� nei 120 simboli�");
											strmid(DarboInfo[pInfo[playerid][direktorius]][direktoriauszinute], input1, 0,128,128);

											MSG(playerid, GREEN, "+ Pakeit�te darbo �inut�");
										}
										else return Dialog_ShowCallback(playerid, using inline dzinute,DIALOG_STYLE_LIST, "DVP � Darbo �inut�","{3abeff}�{ffffff} Keisti darbo �inut�\n{3abeff}�{ffffff} �jungti/i�jungti darbo �inut�", "Toliau", "Atgal");
									}
									new str[300];
									if(!isnull(DarboInfo[pInfo[playerid][direktorius]][direktoriauszinute])) format(str, sizeof(str), "{3abeff}�{ffffff} �ra�ykite nauj� darbo �inut�:\n\n{3abeff}�{ffffff} Dabartin� �inut�: {3abeff}%s", DarboInfo[pInfo[playerid][direktorius]][direktoriauszinute]);
									else format(str, sizeof(str), "{3abeff}�{ffffff} �ra�ykite nauj� darbo �inut�:\n\n{3abeff}�{ffffff} Dabartin�s �inut�s n�ra");
									Dialog_ShowCallback(playerid, using inline dzinute1, DIALOG_STYLE_INPUT, "DVP � Keisti darbo �inut�", str, "Pasirinkti", "Atgal");
								}
								case 1:
								{
									switch(DarboInfo[pInfo[playerid][direktorius]][arijungta])
									{
										case true:
										{
											DarboInfo[pInfo[playerid][direktorius]][arijungta] = false;
											MSG(playerid, GREEN, "+ I�jung�te darbo �inut�");
										}
										case false:
										{
											DarboInfo[pInfo[playerid][direktorius]][arijungta] = true;
											MSG(playerid, GREEN, "+ �jung�te darbo �inut�");
										}
									}		
								}
							}
						}
						else return ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");
					}
					Dialog_ShowCallback(playerid, using inline dzinute,DIALOG_STYLE_LIST, "Darbo �inut�", "{3abeff}�{ffffff} Keisti darbo �inut�\n{3abeff}�{ffffff} �jungti/i�jungti darbo �inut�", "Toliau", "Atgal");
				}
			}
			case 3: ShowPlayerDialog(playerid, dfondas, DIALOG_STYLE_LIST, "{ffffff}DVP � Darbo fondas","{3abeff}� {ffffff}Darbo {3abeff}pelnas\n{3abeff}� {ffffff}I�imti pinigus i� {3abeff}fondo\n{3abeff}� {ffffff}�d�ti pinig� � {3abeff}fond�\n{3abeff}� {ffffff}I�dalinti pinigus {3abeff}darbuotojams", "Toliau", "Atgal");// darbo fondas
			case 4: // Nenaudojam� darbo transporto priemoni� atstatymas
			{
				if(response)
				{
					SetTimerEx("ResetAllJobCars", 3000, false, "i", playerid);
					SendFormatToJob(pInfo[playerid][direktorius], -1, "{f49e42}[RACIJA]: Nenaudojamos darbin�s tr. priemon�s atsistatys po 3 sec");
					return 1;
				}
			}
			case 5:
			{
				inline switchdlaikas(pid, did, resp, litem, string:input[])
				{
					#pragma unused pid, did, input
					if(resp)
					{
						if(!DarboInfo[pInfo[playerid][direktorius]][dirba]) return MSG(playerid, RED, "- J�s� darbas �iuo metu jau nedirba!");
						switch(litem)
						{
							default:
							{
								inline nedarbas(pi, di, respp, litemm, string:inputt[])
								{
									#pragma unused pi, di, litemm
									if(respp)
									{
										if(!IsNumeric(inputt)) return MSG(playerid, RED, "- �vesti turite skai�ius!");
										if(strval(inputt) < 1 || strval(inputt) > 120) return MSG(playerid, RED, "- Laikas negali b�ti trumpesnis u� 1 min, arba ilgesnis u� 120 min ( 2 val )");

										inline nedarbasreason(pii, dii, resppp, litemmm, string:inputt1[])
										{
											#pragma unused pii, dii, litemmm
											if(resppp)
											{
												if(strlen(inputt1) > 20 || strlen(inputt1) < 3) return MSG(playerid, RED, "- Prie�astis negali b�ti trumpesn� nei 3 simboliai arba ilgesn� nei 20 simboli�");

												DarboInfo[pInfo[playerid][direktorius]][dirba] = false;

												new	DarboPav[50];

												switch(pInfo[playerid][direktorius])
												{
													case MEDIKAI: DarboPav = "Medikai";
													case POLICININKAI: DarboPav = "Policijos departamentas";
													case ARMIJA: DarboPav = "Armija";
												}

												DarboInfo[pInfo[playerid][direktorius]][nedirbsiki] = gettime() + ( strval(inputt) * 60 );

												SendFormatToAll(-1, "{9FACF3}%s{ffffff} nedirbs iki {9FACF3}%s", DarboPav, date(DarboInfo[pInfo[playerid][direktorius]][nedirbsiki]));
												SendFormatToAll(-1, "{ffffff}Prie�astis: {9FACF3}%s", inputt1);
											}
										}
										Dialog_ShowCallback(playerid, using inline nedarbasreason, DIALOG_STYLE_INPUT, "{ffffff}DVP � Skelbti nedarbo laik�", "{3abeff}�{ffffff} �ra�ykite prie�ast� d�l ko firma nedirbs [MAX 20 simboli�]:", "Toliau", "I�eiti");
									}
									else return ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");
								}
								Dialog_ShowCallback(playerid, using inline nedarbas, DIALOG_STYLE_INPUT, "{ffffff}DVP � Skelbti nedarbo laik�", "{3abeff}� {ffffff}�ra�ykite kiek laiko firma nedirbs [{3abeff}MIN{ffffff}] [MAX 120 MIN]: ", "Toliau", "Atgal");
							}
						}
					}
					else return ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");
				}
				Dialog_ShowCallback(playerid, using inline switchdlaikas, DIALOG_STYLE_LIST, "{ffffff}DVP � Darbo laikas","{3abeff}�{ffffff} Skelbti nedarbo laik�", "Toliau", "Atgal");
			}
			case 6:
			{
				inline dreikalavimai(pid, did, resp, litem, string:input[])
				{
					#pragma unused pid, did, input
					if(resp)
					{
						switch(litem)
						{
							case 0:
							{
								inline dminimumas(pidd, didd, respp, litemm, string:inputt1[])
								{
									#pragma unused pidd, didd, litemm
									if(respp)
									{
										if(!IsNumeric(inputt1)) return MSG(playerid, RED, "- Turi sudaryti skai�iai!");
                                        if(strval(inputt1) < 50 || strval(inputt1) > 70) return MSG(playerid, RED, "- Ma�iausiai galite nustatyti 50 min, daugiausiai 70min!");
 
                                        SendFormat(playerid, GREEN, "+ Pakeit�te dienos pra�aidimo reikalavim� i� %i min � %i min", DarboInfo[pInfo[playerid][direktorius]][dienosminimumasMIN], strval(inputt1));

                                        DarboInfo[pInfo[playerid][direktorius]][dienosminimumasMIN] = strval(inputt1);
									}
									else return ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");
								}
								Dialog_ShowCallback(playerid, using inline dminimumas, DIALOG_STYLE_INPUT, "{ffffff}DVP � Darbo reikalavimai", "{3abeff}�{ffffff} �veskite kiek laiko darbuotojas turi pradirbti per dien� [{3abeff}MIN{ffffff}]:", "Nustatyti", "Atgal");
							}
							case 1:
							{
								switch(pInfo[playerid][direktorius])
								{
									case MEDIKAI:
									{
										inline dminimumaspagydymai(pid1, did1, resp1, litem1, string:input1[])
										{
											#pragma unused pid1, did1, litem1
											if(resp1)
											{
												if(!IsNumeric(input1)) return MSG(playerid, RED, "- Turi sudaryti skai�iai!");
            	                            	if(strval(input1) < 10 || strval(input1) > 20) return MSG(playerid, RED, "- Ma�iausiai galite nustatyti 10 pagydym�, daugiausiai 20!");
	
	    	                                    SendFormat(playerid, GREEN, "+ Pakeit�te dienos pagydym� reikalavim� i� %i � %i", DarboInfo[MEDIKAI][dienosminimumasPAGYD], strval(input1));

		                                        DarboInfo[MEDIKAI][dienosminimumasPAGYD] = strval(input1);
											}
											else return ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");
										}
										Dialog_ShowCallback(playerid, using inline dminimumaspagydymai, DIALOG_STYLE_INPUT, "{ffffff}DVP � Darbo reikalavimai", "{3abeff}�{ffffff} �veskite kiek pagydym� darbuotojas turi surinkti per dien�:", "Nustatyti", "Atgal");
									}
									case POLICININKAI..ARMIJA:
									{
										inline dminimumasbaudos(pidd1, didd1, respp1, litemm1, string:inputt1[])
										{
											#pragma unused pidd1, didd1, litemm1
											if(respp1)
											{
												if(!IsNumeric(inputt1)) return MSG(playerid, RED, "- Turi sudaryti skai�iai!");
            	                            	if(strval(inputt1) < 10 || strval(inputt1) > 20) return MSG(playerid, RED, "- Ma�iausiai galite nustatyti 10 baud�, daugiausiai 20!");
	
	    	                                    SendFormat(playerid, GREEN, "+ Pakeit�te dienos baud� reikalavim� i� %i � %i", DarboInfo[pInfo[playerid][direktorius]][dienosminimumasBAUDOS], strval(inputt1));

		                                        DarboInfo[pInfo[playerid][direktorius]][dienosminimumasBAUDOS] = strval(inputt1);
											}
											else return ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");
										}
										Dialog_ShowCallback(playerid, using inline dminimumasbaudos, DIALOG_STYLE_INPUT, "{ffffff}DVP � Darbo reikalavimai", "{3abeff}�{ffffff} �veskite kiek baud� darbuotojas turi surinkti per dien�:", "Nustatyti", "Atgal");
									}
								}
							}
							case 2:
							{
								inline patirtiesreikalavimai(pi, di, respp, litemm, string:inputt[])
								{
									#pragma unused pi, di, litemm
									if(respp)
									{
										new updatedarbai[100];
										switch(pInfo[playerid][direktorius])
										{
											case MEDIKAI:
											{
												if(strval(inputt) < 5000 || strval(inputt) > 6000) return MSG(playerid, RED, "- Negali b�ti ma�iau 5.000 ar daugiau 6.000!");
												else
												{
													SendFormat(playerid, GREEN, "+ Pakeit�te medik� patirties reikalavimus. I� %sXP � %sXP", konvertuoti_pinigus(MEDIKU_XP), konvertuoti_pinigus(strval(inputt)));
													MEDIKU_XP = strval(inputt);
													format(updatedarbai, sizeof(updatedarbai), "{ff8c00}Medikai\n{ffffff}Reikalinga patirtis - {ff8c00}%s XP", konvertuoti_pinigus(strval(inputt)));
													UpdateDynamic3DTextLabelText(darbulabel[MEDIKAI], -1, updatedarbai);
												}
											}
											case POLICININKAI:
											{
												if(strval(inputt) < 9000 || strval(inputt) > 10000) return MSG(playerid, RED, "- Negali b�ti ma�iau 9.000 ar daugiau 10.000!");
												else
												{
													SendFormat(playerid, GREEN, "+ Pakeit�te policijos patirties reikalavimus. I� %sXP � %sXP", konvertuoti_pinigus(POLICININKU_XP), konvertuoti_pinigus(strval(inputt)));
													POLICININKU_XP = strval(inputt);
													format(updatedarbai,sizeof(updatedarbai), "{ff8c00}Policininkai\n{ffffff}Reikalinga patirtis - {ff8c00}%s XP", konvertuoti_pinigus(strval(inputt)));
													UpdateDynamic3DTextLabelText(darbulabel[POLICININKAI], -1, updatedarbai);
												}
											}
											case ARMIJA:
											{
												if(strval(inputt) < 20000 || strval(inputt) > 25000) return MSG(playerid, RED, "- Negali b�ti ma�iau 20.000 ar daugiau 25.000!");
												else
												{
													SendFormat(playerid, GREEN, "+ Pakeit�te armijos patirties reikalavimus. I� %sXP � %sXP", konvertuoti_pinigus(ARMIJOS_XP), konvertuoti_pinigus(strval(inputt)));
													ARMIJOS_XP = strval(inputt);
													format(updatedarbai,sizeof(updatedarbai), "{ff8c00}Armija\n{ffffff}Reikalinga patirtis - {ff8c00}%s XP", konvertuoti_pinigus(strval(inputt)));
													UpdateDynamic3DTextLabelText(darbulabel[ARMIJA], -1, updatedarbai);
												}
											}
										}
									}
									else
									{
										switch(pInfo[playerid][direktorius])
										{
											case MEDIKAI: Dialog_ShowCallback(playerid, using inline dreikalavimai, DIALOG_STYLE_LIST, "{ffffff}DVP � Darbo reikalavimai", "{3abeff}�{ffffff} Pradirbimo per dien�\n{3abeff}�{ffffff} Pagydym� per dien�\n{3abeff}�{ffffff} Darbo patirties reikalavimas", "Toliau", "Atgal");
											case POLICININKAI..ARMIJA: Dialog_ShowCallback(playerid, using inline dreikalavimai, DIALOG_STYLE_LIST, "{ffffff}DVP � Darbo reikalavimai", "{3abeff}�{ffffff} Pradirbimo per dien�\n{3abeff}�{ffffff} Baud� per dien�\n{3abeff}�{ffffff} Darbo patirties reikalavimas", "Toliau", "Atgal");
										}
									}
								}
								new string[200];
								switch(pInfo[playerid][direktorius])
								{
									case MEDIKAI: format(string, sizeof(string), "{3abeff}� {ffffff}�veskite koks patirties kiekis bus reikalavimas norint �sidarbinti, tarp: {3abeff}5.000-6.000");
									case POLICININKAI: format(string, sizeof(string), "{3abeff}� {ffffff}�veskite koks patirties kiekis bus reikalavimas norint �sidarbinti, tarp: {3abeff}9.000-10.000");
									case ARMIJA: format(string, sizeof(string), "{3abeff}� {ffffff}�veskite koks patirties kiekis bus reikalavimas norint �sidarbinti, tarp: {3abeff}20.000-25.000");
								}
								Dialog_ShowCallback(playerid, using inline patirtiesreikalavimai, DIALOG_STYLE_INPUT, "{ffffff}DVP � Reikalavim� keitimas � Patirties keitimas", string, "Keisti", "Atgal");
							}
						}
					}
					else return ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");
				}
				switch(pInfo[playerid][direktorius])
				{
					case MEDIKAI: Dialog_ShowCallback(playerid, using inline dreikalavimai, DIALOG_STYLE_LIST, "{ffffff}DVP � Dienos reikalavimai", "{3abeff}�{ffffff} Pradirbimo per dien�\n{3abeff}�{ffffff} Pagydym� per dien�\n{3abeff}�{ffffff} Darbo patirties reikalavimas", "Toliau", "Atgal");
					case POLICININKAI..ARMIJA: Dialog_ShowCallback(playerid, using inline dreikalavimai, DIALOG_STYLE_LIST, "{ffffff}DVP � Dienos reikalavimai", "{3abeff}�{ffffff} Pradirbimo per dien�\n{3abeff}�{ffffff} Baud� per dien�\n{3abeff}�{ffffff} Darbo patirties reikalavimas", "Toliau", "Atgal");
				}
			}
			case 7: // Rang� valdymas
			{	
				inline dvp_ranguvaldymas(pid, did, resp, litem, string:input[])
				{
					#pragma unused pid, did, input
					if(resp)
					{
						switch(litem)
						{
							case 0:
							{
								inline rangu_sarasas_dvp(pid1, did1, resp1, litem1, string:input1[])
								{
									#pragma unused pid1, did1, litem1, input1
									if(resp1) Dialog_ShowCallback(playerid, using inline dvp_ranguvaldymas, DIALOG_STYLE_LIST, "{ffffff}DVP � Rang� valdymas", "{3abeff}�{ffffff} Rang� s�ra�as\n{3abeff}�{ffffff} Valdyti rangus", "Toliau", "Atgal");
								}
								new str[1000];

								format(str, sizeof(str), "Pirmas rangas: �%s�\nAntras rangas: �%s�\nTrecias rangas: �%s�\nKetvirtas rangas: �%s�\nPenktas rangas: �%s�\n�e�tas rangas: �%s�",\
									DarboInfo[pInfo[playerid][direktorius]][Rangas1], DarboInfo[pInfo[playerid][direktorius]][Rangas2], DarboInfo[pInfo[playerid][direktorius]][Rangas3], DarboInfo[pInfo[playerid][direktorius]][Rangas4], DarboInfo[pInfo[playerid][direktorius]][Rangas5], DarboInfo[pInfo[playerid][direktorius]][Rangas6]);
								Dialog_ShowCallback(playerid, using inline rangu_sarasas_dvp, DIALOG_STYLE_MSGBOX, "{ffffff}DVP � Rang� s�ra�as", str, "Atgal", "");
							}
							case 1:
							{
								inline rango_valdymas(pid2, did2, resp2, litem2, string:input2[])
								{
									#pragma unused pid2, did2, input2
									if(resp2)
									{
										switch(litem2)
										{
											case 0..5:
											{
												inline rango_valdymas1(pid3, did3, resp3, litem3, string:input3[])
												{
													#pragma unused pid3, did3, input3
													if(resp3)
													{
														switch(litem3)
														{
															case 0: // Keisti rango pavadinima
															{
																inline keistirango_pavadinima(pid4, did4, resp4, litem4, string:input4[])
																{
																	#pragma unused pid4, did4, litem4
																	if(resp4)
																	{
																		if(strlen(input4) > 30) return MSG(playerid, RED, "- Rango pavadinimas gali b�ti daugiausiai 30 simboli�");
																		if(isnull(input4)) return MSG(playerid, RED, "- Rango pavadinimas negali b�ti tu��ias");

																		switch(litem2)
																		{
																			case 0: format(DarboInfo[pInfo[playerid][direktorius]][Rangas1], 30, "%s", input4);
																			case 1: format(DarboInfo[pInfo[playerid][direktorius]][Rangas2], 30, "%s", input4);
																			case 2: format(DarboInfo[pInfo[playerid][direktorius]][Rangas3], 30, "%s", input4);
																			case 3: format(DarboInfo[pInfo[playerid][direktorius]][Rangas4], 30, "%s", input4);
																			case 4: format(DarboInfo[pInfo[playerid][direktorius]][Rangas5], 30, "%s", input4);
																			case 5: format(DarboInfo[pInfo[playerid][direktorius]][Rangas6], 30, "%s", input4);
																		}
																		SendFormat(playerid, GREEN, "+ Pakeit�te %i darbo rang� � %s", litem2+1, input4);
																	}
																	else return Dialog_ShowCallback(playerid, using inline dvp_ranguvaldymas, DIALOG_STYLE_LIST, "{ffffff}DVP � Rang� valdymas", "{3abeff}�{ffffff} Rang� s�ra�as\n{3abeff}�{ffffff} Valdyti rangus", "Toliau", "Atgal");
																}
																Dialog_ShowCallback(playerid, using inline keistirango_pavadinima, DIALOG_STYLE_INPUT, "{ffffff}DVP � Rango pavadinimo keitimas", "{3abeff}�{ffffff} �ra�ykite nauj� rango pavadinim� [MAX 30 simb]", "Toliau", "Atgal");
															}
															case 1: // Keisti rango privilegijas
															{
																inline keistirango_privilegijas(pid5, did5, resp5, litem5, string:input5[])
																{
																	#pragma unused pid5, did5, input5	
																	if(resp5)
																	{
																		switch(litem5)
																		{
																			case 0: // I�vaizda
																			{
																				inline isvaizdos_keitimas(pid6, did6, resp6, litem6, string:input6[])
																				{
																					#pragma unused pid6, did6, input6
																					if(resp6)
																					{
																						switch(litem6)
																						{
																							case 0: // Vyr�
																							{
																								inline isvaizdoskeitimasvyr(pid7, did7, resp7, litem7, string:input7[])
																								{
																									#pragma unused pid7, did7, input7
																									if(resp7)
																									{
																										switch(litem2)
																										{
																											case 0:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_male] = pdskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);
																												
																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin1_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																													case MEDIKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_male] = medikuskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);
																												
																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == MEDIKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], MEDIKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin1_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 1);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																											case 1:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin2_male] = pdskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);

																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin2_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																													case MEDIKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_male] = medikuskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);
																												
																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == MEDIKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], MEDIKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin2_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 1);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																											case 2:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin3_male] = pdskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);

																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin3_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																													case MEDIKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_male] = medikuskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);
																												
																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == MEDIKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], MEDIKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin3_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 1);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																											case 3:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin4_male] = pdskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);

																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin4_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																													case MEDIKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_male] = medikuskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);
																												
																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == MEDIKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], MEDIKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin4_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 1);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																											case 4:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin5_male] = pdskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);

																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin5_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																													case MEDIKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_male] = medikuskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);
																												
																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == MEDIKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], MEDIKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin5_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 1);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																											case 5:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin6_male] = pdskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);

																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin6_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																													case MEDIKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_male] = medikuskinlistmale[litem7][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistmale[litem7][Skinas]);
																												
																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == MEDIKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 0)
																																{
																																	pInfo[i][uniforma] = pdskinlistmale[litem7][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '0'", pdskinlistmale[litem7][Skinas], MEDIKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin6_male = '%i' WHERE jobID = '%i'", pdskinlistmale[litem7][Skinas], 1);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																										}
																									}
																								}
																								switch(pInfo[playerid][direktorius])
																								{
																									case MEDIKAI:{Dialog_ShowCallback(playerid, using inline isvaizdoskeitimasvyr, DIALOG_STYLE_LIST, "{ffffff}DVP � Rango i�vaizdos keitimas (Vyr�)", \
																									"I�vaizda 1 [274ID]\nI�vaizda 2 [275ID]\nI�vaizda 3 [276ID]", "Pasirinkti", "Atgal");}
																									case POLICININKAI:{Dialog_ShowCallback(playerid, using inline isvaizdoskeitimasvyr, DIALOG_STYLE_LIST, "{ffffff}DVP � Rango i�vaizdos keitimas (Vyr�)", \
																									"I�vaizda 1 [280ID]\nI�vaizda 2 [281ID]\nI�vaizda 3 [282ID]\nI�vaizda 4 [283ID]\nI�vaizda 5 [284ID]\nI�vaizda 6 [288ID]\nI�vaizda 7 [300ID]\nI�vaizda 8 [301ID]\nI�vaizda 9 [302ID]\nI�vaizda 10 [310ID]\nI�vaizda 11 [311ID]", "Pasirinkti", "Atgal");}
																								}
																							}
																							case 1: // Moter�
																							{
																								inline isvaizdoskeitimasmot(pid8, did8, resp8, litem8, string:input8[])
																								{
																									#pragma unused pid8, did8, input8
																									if(resp8)
																									{
																										switch(litem2)
																										{
																											case 0:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_female] = pdskinlistfemale[litem8][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistfemale[litem8][Skinas]);

																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 1)
																																{
																																	pInfo[i][uniforma] = pdskinlistfemale[litem8][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '1'", pdskinlistfemale[litem8][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin1_female = '%i' WHERE jobID = '%i'", pdskinlistfemale[litem8][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																											case 1:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_female] = pdskinlistfemale[litem8][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistfemale[litem8][Skinas]);

																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 1)
																																{
																																	pInfo[i][uniforma] = pdskinlistfemale[litem8][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '1'", pdskinlistfemale[litem8][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin2_female = '%i' WHERE jobID = '%i'", pdskinlistfemale[litem8][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																											case 2:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_female] = pdskinlistfemale[litem8][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistfemale[litem8][Skinas]);

																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 1)
																																{
																																	pInfo[i][uniforma] = pdskinlistfemale[litem8][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '1'", pdskinlistfemale[litem8][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin3_female = '%i' WHERE jobID = '%i'", pdskinlistfemale[litem8][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																											case 3:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_female] = pdskinlistfemale[litem8][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistfemale[litem8][Skinas]);

																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 1)
																																{
																																	pInfo[i][uniforma] = pdskinlistfemale[litem8][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '1'", pdskinlistfemale[litem8][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin4_female = '%i' WHERE jobID = '%i'", pdskinlistfemale[litem8][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																											case 4:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_female] = pdskinlistfemale[litem8][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistfemale[litem8][Skinas]);

																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 1)
																																{
																																	pInfo[i][uniforma] = pdskinlistfemale[litem8][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '1'", pdskinlistfemale[litem8][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin5_female = '%i' WHERE jobID = '%i'", pdskinlistfemale[litem8][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																											case 5:
																											{
																												switch(pInfo[playerid][direktorius])
																												{
																													case POLICININKAI:
																													{
																														DarboInfo[pInfo[playerid][direktorius]][Skin1_female] = pdskinlistfemale[litem8][Skinas];

																														SendFormat(playerid, GREEN, "+ Pakeit�te %i rango i�vaizd� � %iID", litem2+1, pdskinlistfemale[litem8][Skinas]);

																														foreach(new i : Player)
																														{
																															if(online[i])
																															{
																																if(pInfo[i][darbas] == POLICININKAI && pInfo[i][DarboRangas] == litem2+1 && pInfo[i][lytis] == 1)
																																{
																																	pInfo[i][uniforma] = pdskinlistfemale[litem8][Skinas];
																																	if(pInfo[playerid][wUniform]){SetPlayerSkin(i, pInfo[i][uniforma]);}
																																}
																															}
																														}
																														mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET uniform = '%i' WHERE darbas = '%i' AND gender = '1'", pdskinlistfemale[litem8][Skinas], POLICININKAI);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");

																														mysql_format(connectionHandle, query, 140, "UPDATE darbai SET Skin6_female = '%i' WHERE jobID = '%i'", pdskinlistfemale[litem8][Skinas], 2);
																														mysql_tquery(connectionHandle, query, "SendQuery", "");
																													}
																												}
																											}
																										}
																									}
																								}
																								switch(pInfo[playerid][direktorius])
																								{
																									case MEDIKAI:{return MSG(playerid, RED, "- Medikai turi tik vien� moteri�k� i�vaizd�");}
																									case ARMIJA:{return MSG(playerid, RED, "- Armija turi tik vien� moteri�k� i�vaizd�");}
																									case POLICININKAI:{Dialog_ShowCallback(playerid, using inline isvaizdoskeitimasmot, DIALOG_STYLE_LIST, "{ffffff}DVP � Rango i�vaizdos keitimas (Vyr�)", \
																									"I�vaizda 1 [306ID]\nI�vaizda 2 [307ID]\nI�vaizda 3 [309ID]", "Pasirinkti", "Atgal");}
																								}
																							}
																						}
																					}
																				}
																				if(pInfo[playerid][direktorius] == ARMIJA) {return MSG(playerid, RED, "- Armija turi tik vien� i�vaizd�, d�ja negalite keisti i�vaizdos");}
																				Dialog_ShowCallback(playerid, using inline isvaizdos_keitimas, DIALOG_STYLE_LIST, "{ffffff}DVP � Rango i�vaizdos keitimas", "Vyr�\nMoter�", "Pasirinkti", "Atgal");
																			}
																			case 1:
																			{

																			}
																			case 2:
																			{

																			}
																		}
																	}
																}
																Dialog_ShowCallback(playerid, using inline keistirango_privilegijas, DIALOG_STYLE_LIST, "{ffffff}DVP � Rango nustatymai", "{3abeff}�{ffffff} I�vaizda\n{3abeff}�{ffffff} Transportas\n{3abeff}�{ffffff} Darbo komandos", "Toliau", "Atgal");
															}
														}
													}
													else return Dialog_ShowCallback(playerid, using inline rango_valdymas, DIALOG_STYLE_LIST, "{ffffff}DVP � Rang� valdymas", "{3abeff}�{ffffff} Pirmo rango valdymas\n{3abeff}�{ffffff} Antro rango valdymas\n{3abeff}�{ffffff} Tre�io rango valdymas\n{3abeff}�{ffffff} Ketvirto rango valdymas\n{3abeff}�{ffffff} Penkto rango valdymas\n{3abeff}�{ffffff} �e�to rango valdymas", "Toliau", "Atgal");
												}
												Dialog_ShowCallback(playerid, using inline rango_valdymas1, DIALOG_STYLE_LIST, "{ffffff}DVP � Rang� valdymas", "{3abeff}�{ffffff} Keisti rango vard�\n{3abeff}�{ffffff} Rango nustatymai", "Toliau", "Atgal");
											}
										}
									}
									else return Dialog_ShowCallback(playerid, using inline dvp_ranguvaldymas, DIALOG_STYLE_LIST, "{ffffff}DVP � Rang� valdymas", "{3abeff}�{ffffff} Rang� s�ra�as\n{3abeff}�{ffffff} Valdyti rangus", "Toliau", "Atgal");
								}
								Dialog_ShowCallback(playerid, using inline rango_valdymas, DIALOG_STYLE_LIST, "{ffffff}DVP � Rang� valdymas", "\
									{3abeff}�{ffffff} Pirmo rango valdymas\n{3abeff}�{ffffff} Antro rango valdymas\n{3abeff}�{ffffff} Tre�io rango valdymas\n{3abeff}�{ffffff} Ketvirto rango valdymas\n{3abeff}�{ffffff} Penkto rango valdymas\n{3abeff}�{ffffff} �e�to rango valdymas", "Toliau", "Atgal");
							}
						}
					}
					else return ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");
				}
				Dialog_ShowCallback(playerid, using inline dvp_ranguvaldymas, DIALOG_STYLE_LIST, "{ffffff}DVP � Rang� valdymas", "{3abeff}�{ffffff} Rang� s�ra�as\n{3abeff}�{ffffff} Valdyti rangus", "Toliau", "Atgal");
			}
			case 8: // Pavaduotojas
			{

			}
		}
	}
	if(dialogid == visidarbuotojai)
	{
		if(response)
		{
			new string[31];
			format(string, sizeof(string), "{ffffff}DVP � %s", DarbuotojuVardai[pInfo[playerid][direktorius]][listitem]);
    		pInfo[playerid][ziuridarbuotoja] = listitem;
    		ShowPlayerDialog(playerid, kontrole, DIALOG_STYLE_LIST, string, "{3abeff}�{ffffff} Darbuotojo informacija\n{3abeff}�{ffffff} �sp�ti darbuotoj�\n{3abeff}�{ffffff} Nuimti �sp�jim�\n{3abeff}�{ffffff} U�d�ti rang�", "Toliau", "Atgal");
		}
		else return ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");
		return 1;
	}
	if(dialogid == kontrole)
	{
		switch(listitem)
		{
			case 0:
			{
				if(response)
				{
					new string[300], status[30];
					new id = GetPlayeridMid(DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
					if(id != INVALID_PLAYER_ID)
    				{
    					status = "{00FF11}prisijung�s";
    					format(string, sizeof(string), "{ffffff}Darbuotojo {74C487}%s {ffffff}informacija\n\n\t{4bbaed}�{ffffff} Darbuotojas �iuo metu %s\n\t{4bbaed}�{ffffff} Darbuotojo �sp�jimai {4bbaed}%i/3\n\t{4bbaed}�{ffffff} Darbuotojas �iandien pradirbo {4bbaed}%imin\n\t{4bbaed}�{ffffff} Darbuotojas nuo {4bbaed}%s", \
    					DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], \
    					status,\
    					pInfo[id][disp],\
    					pInfo[id][siandienpradirbo],\
    					pInfo[id][workingSince]);
    					
    					inline darbuotojoinfo(pid, did, resp, litem, string:input[])
    					{
							#pragma unused pid, did, litem, input
							if(resp)
							{
								new workername[31];
								format(workername, sizeof(workername), "{ffffff}DVP � %s", DarbuotojuVardai[pInfo[playerid][direktorius]][listitem]);
    							ShowPlayerDialog(playerid, kontrole, DIALOG_STYLE_LIST, workername, "{3abeff}�{ffffff} Darbuotojo informacija\n{3abeff}�{ffffff} �sp�ti darbuotoj�\n{3abeff}�{ffffff} Nuimti �sp�jim�", "Toliau", "Atgal");
							}
    					}
    					Dialog_ShowCallback(playerid, using inline darbuotojoinfo, DIALOG_STYLE_MSGBOX, "Informacija", string, "Atgal", "");
       				}
    				else
    				{
    					mysql_format(connectionHandle, query, 200, "SELECT disp, siandienpradirbo, isidarbino FROM `zaidejai` WHERE `vardas` = '%e'",DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
    					mysql_tquery(connectionHandle, query, "OnPlayerRequestInfoAboutWorker", "i", playerid);
    				}
				}
				else
				{
					mysql_format(connectionHandle, query, 140, "SELECT vardas FROM `zaidejai` WHERE `darbas` = '%i'", pInfo[playerid][direktorius]);
					mysql_tquery(connectionHandle, query, "OnPlayerRequestWorkersList", "i", playerid);
				}
			}
			case 1: // �sp�ti
			{
				if(response)
				{
					inline ispetidarbuotoja(pid, did, resp, litem, string:input[])
					{
						#pragma unused pid, did, litem
						if(resp)
						{
							new string[45], string1[200];
							if(sscanf(inputtext, "s", input))
							{
								format(string, sizeof(string), "{ffffff}DVP � �sp�ti darbuotoj� %s", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
								format(string1, sizeof(string1), "{ff0000}Ne�ved�te prie�asties!\n{ffffff}Nor�dami �sp�ti {F0E678}%s{ffffff} �veskite {F0E678}prie�ast� {ffffff}apa�ioje:", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);

								Dialog_ShowCallback(playerid, using ispetidarbuotoja, DIALOG_STYLE_INPUT, string, string1, "�sp�ti", "Atgal");
							}
							new id = GetPlayeridMid(DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
							if(id == playerid) return MSG(playerid, RED, "- Sav�s �sp�ti negalima!");
							if(isnull(input)) return MSG(playerid, RED, "- Laukelis negali b�ti tu��ias!");
							if(strlen(input) > 24) return MSG(playerid, RED, "- Prie�astis negali b�ti ilgesn� nei 24 simboliai.");

							if(id != INVALID_PLAYER_ID && online[id])
							{
								pInfo[id][disp] += 1;
								if(pInfo[id][disp] < 3)
								{
									SendFormat(playerid, -1, "{BC7BC7}�{ffffff} �sp�jote darbuotoj� {BC7BC7}%s {ffffff}d�l {BC7BC7}%s", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], input);

									mysql_format(connectionHandle, query, 200, "INSERT INTO ispejimai (data, kasispejo, priezastis, vardas, isptipas) VALUES ('%s', '%s', '%s', '%s', '3')", GautiData(0), playerName[playerid], input, DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);

									mysql_tquery(connectionHandle, query, "SendQuery", "");

									SendFormatToJob(pInfo[playerid][direktorius], -1, "{DE5492}Direktorius {D490AF}%s {DE5492}�sp�jo darbuotoj� {D490AF}%s d�l {DE5492}%s", playerName[playerid], DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], input);
								}
								else if(pInfo[id][disp] >= 3)
								{
									pInfo[id][uniforma] = 0;
									pInfo[id][wUniform] = 0;
									pInfo[id][darbas] = 0;
									pInfo[id][workingSince] = EOS;

									SetPlayerSkin(id, pInfo[id][skin]);

									MSG(id, -1, "{BC7BC7}� {ffffff}J�s surinkote {BC7BC7}3 {ffffff}�sp�jimus ir esate i�metamas i� darbo!");

									SendFormat(playerid, -1, "{BC7BC7}� %s {ffffff} surinko {BC7BC7}3{ffffff} �sp�jimus ir buvo i�mestas i� darbo!", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);

									if(IsJobFromLaw(pInfo[playerid][darbas])) ResetPlayerWeapons(playerid);
								}
							}
							else
							{
								mysql_format(connectionHandle, query, 200, "SELECT disp FROM zaidejai WHERE vardas = '%e'",\
									DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
								mysql_tquery(connectionHandle, query, "OndirektoriusWarnOfflinePlayer", "is", playerid, input);
							}
						}
						else
						{
							new workername[31];
							format(workername, sizeof(workername), "{ffffff}DVP � %s", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
    						ShowPlayerDialog(playerid, kontrole, DIALOG_STYLE_LIST, workername, "{3abeff}�{ffffff} Darbuotojo informacija\n{3abeff}�{ffffff} �sp�ti darbuotoj�\n{3abeff}�{ffffff} Nuimti �sp�jim�", "Toliau", "Atgal");
						}
					}
					new string[50], string1[100];
    				format(string, sizeof(string), "{ffffff}DVP � �sp�ti darbuotoj� %s", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
    				format(string1, sizeof(string1), "{ffffff}Nor�dami �sp�ti {F0E678}%s{ffffff} �veskite {F0E678}prie�ast� {ffffff}apa�ioje:", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
    				Dialog_ShowCallback(playerid, using ispetidarbuotoja, DIALOG_STYLE_INPUT, string, string1, "�sp�ti", "Atgal");
				}
				else
				{
					mysql_format(connectionHandle, query, 140, "SELECT vardas FROM `zaidejai` WHERE `darbas` = '%i'", pInfo[playerid][direktorius]);
					mysql_tquery(connectionHandle, query, "OnPlayerRequestWorkersList", "i", playerid);
				}
			}
			case 2: // nuimti �sp
			{
				inline nuimtiispdarbuotojui(pid, did, resp, litem, string:input[])
				{
					#pragma unused pid, did, litem
					if(resp)
					{
						new id = GetPlayeridMid(DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
						if(isnull(input)) return MSG(playerid, RED, "- Laukelis negali b�ti tu��ias!");
						if(id != INVALID_PLAYER_ID)
						{
							if(pInfo[id][disp] == 0)
							{
								new string[50], string1[120];
                    			format(string, sizeof(string), "{ffffff}DVP � Nuimti �sp�jim� %s",DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
                    			format(string1, sizeof(string1), "{ffffff}Nor�dami nuimti �sp�jim� darbuotojui {F0E678}%s{ffffff} �veskite {F0E678}prie�ast� {ffffff}apa�ioje\n\n{8b0000}Darbuotojas neturi �sp�jim�", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
                    			Dialog_ShowCallback(playerid, using inline nuimtiispdarbuotojui, DIALOG_STYLE_INPUT, string, string1, "Nuimti", "Atgal");
							}
							else
							{
								pInfo[id][disp] --; 
                   				SendFormat(playerid, -1, "{BC7BC7}�{ffffff} Nu�m�te �sp�jim� {BC7BC7}%s {ffffff}darbuotojui d�l {BC7BC7}%s",DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], input);
 
                    			SendFormat(id, -1, "{BC7BC7}� {ffffff}Direktorius {BC7BC7}%s{ffffff} nu�m� jums �sp�jim� d�l: {BC7BC7}%s", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], input);
 
                    			SendFormatToJob(pInfo[playerid][direktorius], -1, "{DE5492}Direktorius {D490AF}%s {DE5492}nu�m� �sp�jim� darbuotojui {D490AF}%s {DE5492}d�l: {DE5492}%s", playerName[playerid], DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], input);								
							}
						}
						else
						{
                			mysql_format(connectionHandle, query, 200, "SELECT disp FROM zaidejai WHERE `vardas` = '%e'", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
               				mysql_tquery(connectionHandle, query, "OndirektoriusUnWarnWorker", "is", playerid, input);
						}
					}
					else
					{
						new workername[31];
						format(workername, sizeof(workername), "{ffffff}DVP � %s", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
    					ShowPlayerDialog(playerid, kontrole, DIALOG_STYLE_LIST, workername, "{3abeff}�{ffffff} Darbuotojo informacija\n{3abeff}�{ffffff} �sp�ti darbuotoj�\n{3abeff}�{ffffff} Nuimti �sp�jim�", "Toliau", "Atgal");
					}
				}
				new string[50], string1[120];
				format(string, sizeof(string), "{ffffff}DVP � Nuimti �sp�jim� %s",DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
				format(string1, sizeof(string1), "{ffffff}Nor�dami nuimti �sp�jim� darbuotojui {F0E678}%s{ffffff} �veskite {F0E678}prie�ast� {ffffff}apa�ioje:", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
				Dialog_ShowCallback(playerid, using inline nuimtiispdarbuotojui, DIALOG_STYLE_INPUT, string, string1, "Nuimti", "Atgal");
			}
			case 3: // U�d�ti rang�
			{
				inline uzdetiranga_darbuotojui(pid, did, resp, litem, string:input[])
				{
					#pragma unused pid, did, input
					if(resp)
					{
						new id = GetPlayeridMid(DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
						switch(litem)
						{
							case 0:
							{
								if(id != INVALID_PLAYER_ID && online[id])
								{
									pInfo[id][DarboRangas] = 1;

									if(pInfo[id][lytis] == 0) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin1_male];
									else if(pInfo[id][lytis] == 1) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin1_female];

									if(pInfo[id][wUniform]) SetPlayerSkin(id, pInfo[id][uniforma]);

									SendFormat(id, -1, "{BC7BC7}�{ffffff} Direktorius {BC7BC7}%s{ffffff} u�d�jo jums {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[playerid], 1, DarboInfo[pInfo[id][darbas]][Rangas1]);
									SendFormat(playerid, -1, "{BC7BC7}�{ffffff} U�d�jote darbuotojui {BC7BC7}%s{ffffff} {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[id], 1, DarboInfo[pInfo[id][darbas]][Rangas1]);
								}
								else
								{
                					mysql_format(connectionHandle, query, 140, "SELECT Rangas, gender FROM zaidejai WHERE `vardas` = '%e'", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
               						mysql_tquery(connectionHandle, query, "OndirektoriusSetRank", "ii", playerid, litem+1);
								}
							}
							case 1:
							{
								if(id != INVALID_PLAYER_ID && online[id])
								{
									pInfo[id][DarboRangas] = 2;

									if(pInfo[id][lytis] == 0) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin2_male];
									else if(pInfo[id][lytis] == 1) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin2_female];

									if(pInfo[id][wUniform]) SetPlayerSkin(id, pInfo[id][uniforma]);

									SendFormat(id, -1, "{BC7BC7}�{ffffff} Direktorius {BC7BC7}%s{ffffff} u�d�jo jums {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[playerid], 2, DarboInfo[pInfo[id][darbas]][Rangas2]);
									SendFormat(playerid, -1, "{BC7BC7}�{ffffff} U�d�jote darbuotojui {BC7BC7}%s{ffffff} {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[id], 2, DarboInfo[pInfo[id][darbas]][Rangas2]);
								}
								else
								{
                					mysql_format(connectionHandle, query, 140, "SELECT Rangas, gender FROM zaidejai WHERE `vardas` = '%e'", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
               						mysql_tquery(connectionHandle, query, "OndirektoriusSetRank", "ii", playerid, litem+1);
								}
							}
							case 2:
							{
								if(id != INVALID_PLAYER_ID && online[id])
								{
									pInfo[id][DarboRangas] = 3;

									if(pInfo[id][lytis] == 0) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin3_male];
									else if(pInfo[id][lytis] == 1) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin3_female];

									if(pInfo[id][wUniform]) SetPlayerSkin(id, pInfo[id][uniforma]);

									SendFormat(id, -1, "{BC7BC7}�{ffffff} Direktorius {BC7BC7}%s{ffffff} u�d�jo jums {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[playerid], 3, DarboInfo[pInfo[id][darbas]][Rangas3]);
									SendFormat(playerid, -1, "{BC7BC7}�{ffffff} U�d�jote darbuotojui {BC7BC7}%s{ffffff} {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[id], 3, DarboInfo[pInfo[id][darbas]][Rangas3]);
								}
								else
								{
                					mysql_format(connectionHandle, query, 140, "SELECT Rangas, gender FROM zaidejai WHERE `vardas` = '%e'", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
               						mysql_tquery(connectionHandle, query, "OndirektoriusSetRank", "ii", playerid, litem+1);
								}
							}
							case 3:
							{
								if(id != INVALID_PLAYER_ID && online[id])
								{
									pInfo[id][DarboRangas] = 4;

									if(pInfo[id][lytis] == 0) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin4_male];
									else if(pInfo[id][lytis] == 1) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin4_female];

									if(pInfo[id][wUniform]) SetPlayerSkin(id, pInfo[id][uniforma]);

									SendFormat(id, -1, "{BC7BC7}�{ffffff} Direktorius {BC7BC7}%s{ffffff} u�d�jo jums {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[playerid], 4, DarboInfo[pInfo[id][darbas]][Rangas4]);
									SendFormat(playerid, -1, "{BC7BC7}�{ffffff} U�d�jote darbuotojui {BC7BC7}%s{ffffff} {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[id], 4, DarboInfo[pInfo[id][darbas]][Rangas4]);
								}
								else
								{
                					mysql_format(connectionHandle, query, 140, "SELECT Rangas, gender FROM zaidejai WHERE `vardas` = '%e'", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
               						mysql_tquery(connectionHandle, query, "OndirektoriusSetRank", "ii", playerid, litem+1);
								}
							}	
							case 4:
							{
								if(id != INVALID_PLAYER_ID && online[id])
								{
									pInfo[id][DarboRangas] = 5;

									if(pInfo[id][lytis] == 0) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin5_male];
									else if(pInfo[id][lytis] == 1) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin5_female];

									if(pInfo[id][wUniform]) SetPlayerSkin(id, pInfo[id][uniforma]);

									SendFormat(id, -1, "{BC7BC7}�{ffffff} Direktorius {BC7BC7}%s{ffffff} u�d�jo jums {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[playerid], 5, DarboInfo[pInfo[id][darbas]][Rangas5]);
									SendFormat(playerid, -1, "{BC7BC7}�{ffffff} U�d�jote darbuotojui {BC7BC7}%s{ffffff} {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[id], 5, DarboInfo[pInfo[id][darbas]][Rangas5]);
								}
								else
								{
                					mysql_format(connectionHandle, query, 140, "SELECT Rangas, gender FROM zaidejai WHERE `vardas` = '%e'", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
               						mysql_tquery(connectionHandle, query, "OndirektoriusSetRank", "ii", playerid, litem+1);
								}
							}
							case 5:
							{
								if(id != INVALID_PLAYER_ID && online[id])
								{
									pInfo[id][DarboRangas] = 6;

									if(pInfo[id][lytis] == 0) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin6_male];
									else if(pInfo[id][lytis] == 1) pInfo[id][uniforma] = DarboInfo[pInfo[id][darbas]][Skin6_female];

									if(pInfo[id][wUniform]) SetPlayerSkin(id, pInfo[id][uniforma]);

									SendFormat(id, -1, "{BC7BC7}�{ffffff} Direktorius {BC7BC7}%s{ffffff} u�d�jo jums {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[playerid], 6, DarboInfo[pInfo[id][darbas]][Rangas6]);
									SendFormat(playerid, -1, "{BC7BC7}�{ffffff} U�d�jote darbuotojui {BC7BC7}%s{ffffff} {BC7BC7}%i{ffffff} rang� {BC7BC7}�%s�{ffffff}", playerName[id], 6, DarboInfo[pInfo[id][darbas]][Rangas6]);
								}
								else
								{
                					mysql_format(connectionHandle, query, 140, "SELECT Rangas, gender FROM zaidejai WHERE `vardas` = '%e'", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
               						mysql_tquery(connectionHandle, query, "OndirektoriusSetRank", "ii", playerid, litem+1);
								}
							}
						}
					}
				}
				new string[50];
				format(string, sizeof(string), "{ffffff}DVP � U�d�ti rang� %s",DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
				Dialog_ShowCallback(playerid, using inline uzdetiranga_darbuotojui, DIALOG_STYLE_LIST, string, "� Pirm� rang�\n� Antr� rang�\n� Tre�i� rang�\n� Ketvirt� rang�\n� Penkt� rang�", "U�d�ti", "Atgal");
			}
		}
		return 1;
	}
	if(dialogid == priimtidarbuotoja)
	{
		if(response)
		{
			new id, vardas[MAX_PLAYER_NAME], string[300], xpKiekis, darbotipas[50];
			id = GetPlayeridMid(vardas);

			switch(pInfo[playerid][direktorius])
			{
				case MEDIKAI:
				{
					xpKiekis = MEDIKU_XP;
					darbotipas = "Mediku";
				}
				case POLICININKAI:
				{
					xpKiekis = POLICININKU_XP;
					darbotipas = "Policininku";
				}
				case ARMIJA:
				{
					xpKiekis = ARMIJOS_XP;
					darbotipas = "Kareiviu";
				}
			}

			if(sscanf(inputtext, "u", id))
			{
				format(string, sizeof(string), "{ff0000}Ne�ved�te �aid�jo vardo!\n\n{ffffff}Direktoriau, {4bbaed}%s{ffffff}, nor�damas priimti �aid�j� � darb� �sitikinkite, kad jis:\n\n\t1. Neturi {4bbaed}darbo{ffffff}\n\t2. Neturi galiojan�io {4bbaed}darbo{ffffff} pakvietimo\n\t3. Turi {4bbaed}%i{ffffff} patirties\n\t4. Turi galiojant� {4bbaed}sveikatos pa�ym�jim�", playerName[playerid], konvertuoti_pinigus(xpKiekis));
    	    	ShowPlayerDialog(playerid, priimtidarbuotoja, DIALOG_STYLE_INPUT, "Priimti �aid�j� � darb�", string, "Priimti", "Atgal");
			}
			if(pInfo[id][darbas] != 0) return MSG(playerid, 0xFF0000AA, "- �aid�jas jau turi darb�");
    		if(pInfo[id][Invited] != 0) return MSG(playerid, 0xFF0000AA, "- �aid�jas jau yra pakviestas � �� ar kit� darb�!");
    		if(!pInfo[id][sveikatpaz]) return MSG(playerid, 0xFF0000AA, "- �aid�jas neturi galiojan�ios sveikatos pa�ymos");
	    	if(GetPlayerScore(playerid) < xpKiekis) return MSG(playerid, 0xFF0000AA, "- �aid�jas neturi pakankamai patirties!");

    		format(string, sizeof(string), "{74C487}�{ffffff} Pakviet�te {74C487}%s{ffffff} dirbti {74C487}%s", playerName[id], darbotipas);
    		MSG(playerid, -1, string);

    		format(string, sizeof(string), "{74C487}�{ffffff} Direktorius {74C487}%s{ffffff} pakviet� jus dirbti {74C487}%s", playerName[playerid], darbotipas);
    		MSG(id, -1, string);		

    		MSG(id, -1, "{74C487}�{ffffff} Pakvietimas galios {74C487}5{ffffff} minutes");

    		pInfo[id][Invited] = pInfo[playerid][direktorius]; 

			pInfo[id][pakvietimastimer] = gettime() + 300;
		}
		else return ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");
		return 1;
	}
	if(dialogid == dfondas)
	{
		if(!response) return ShowPlayerDialog(playerid, dvp, DIALOG_STYLE_LIST, "{ffffff}Direktoriaus valdymo panel�", "{3abeff}� {ffffff}Darbuotoj� s�ra�as\n{3abeff}� {ffffff}Priimti darbuotoj�\n{3abeff}� {ffffff}Darbo �inut�\n{3abeff}� {ffffff}Darbo fondas\n{3abeff}� {ffffff}Atstatyti darbines tr. priemones\n{3abeff}� {ffffff}Darbo laikas\n{3abeff}� {ffffff}Darbo reikalavimai\n{3abeff}� {ffffff}Rang� valdymas\n{3abeff}� {ffffff}Pavaduotojas", "Pasirinkti", "I�eiti");

		switch(listitem)
		{
			case 1:
			{
				inline isimtiisdfondo(id, did, resp, litem, string:input[])
				{
					#pragma unused id, did, litem
					if(resp)
					{
						if(!IsNumeric(input)) return MSG(playerid, RED, "- �vesti galite tik skai�ius!");
						if(strval(input) <= 0) return MSG(playerid, RED, "- Negalite i�imti ma�iau nei 1� !");
						if(DarboInfo[pInfo[playerid][direktorius]][DarboFondas] < strval(input)) return MSG(playerid, RED, "- Darbo fonde tiek n�ra!");

						SendFormat(playerid, GREEN, "+ I��m�te %s � i� darbo fondo", konvertuoti_pinigus(strval(input)));

						pInfo[playerid][pinigai] += strval(input);

						DarboInfo[pInfo[playerid][direktorius]][DarboFondas] -= strval(input);
					}
					else return ShowPlayerDialog(playerid, dfondas, DIALOG_STYLE_LIST, "{ffffff}DVP � Darbo fondas","{3abeff}� {ffffff}Darbo {3abeff}pelnas\n{3abeff}� {ffffff}I�imti pinigus i� {3abeff}fondo\n{3abeff}� {ffffff}�d�ti pinig� � {3abeff}fond�\n{3abeff}� {ffffff}I�dalinti pinigus {3abeff}darbuotojams", "Toliau", "Atgal");
				}
				Dialog_ShowCallback(playerid, using inline isimtiisdfondo, DIALOG_STYLE_INPUT, "{ffffff}DVP � Darbo fondas � I�imti pinigus", "{3abeff}� {ffffff}�veskite kiek norite i�imti i� {3abeff}darbo {ffffff}fondo:", "I�imti", "Atgal");
			}
			case 2:
			{
				inline idetiidfonda(id, did, resp, litem, string:input[])
				{
					#pragma unused id, did, litem
					if(resp)
					{
						if(!IsNumeric(input)) return MSG(playerid, RED, "- �vesti galite tik skai�ius!");
						if(strval(input) <= 0) return MSG(playerid, RED, "- Negalite �d�ti ma�iau nei 1� !");
						if(strval(input) > pInfo[playerid][pinigai]) return MSG(playerid, RED, "- Neturite tiek pinig�!");

						SendFormat(playerid, GREEN, "+ �d�jote %s � � darbo fond�!", konvertuoti_pinigus(strval(input)));

						DarboInfo[pInfo[playerid][direktorius]][DarboFondas] += strval(input);

						pInfo[playerid][pinigai] -= strval(input);
					}
					else return ShowPlayerDialog(playerid, dfondas, DIALOG_STYLE_LIST, "{ffffff}DVP � Darbo fondas","{3abeff}� {ffffff}Darbo {3abeff}pelnas\n{3abeff}� {ffffff}I�imti pinigus i� {3abeff}fondo\n� {ffffff}�d�ti pinig� � {3abeff}fond�\n{3abeff}� {ffffff}I�dalinti pinigus {3abeff}darbuotojams", "Toliau", "Atgal");
				}
				Dialog_ShowCallback(playerid, using inline idetiidfonda, DIALOG_STYLE_INPUT, "{ffffff}DVP � Darbo fondas � �d�ti pinig� � darbo fond�", "{3abeff}� {ffffff}�veskite kiek pinig� norite �d�ti � {3abeff}darbo {ffffff}fond�:", "�d�ti", "Atgal");
				//ideti
			}
			case 3:
			{
				inline isdalintisaibas(id, did, resp, litem, string:input[])
				{
					#pragma unused id, did, litem
					if(resp)
					{
						if(!IsNumeric(input)) return MSG(playerid, RED, "- �vesti galite tik skai�ius");
						if(strval(input) <= 0) return MSG(playerid, RED, "- Negalite i�dalinti ma�iau nei 1�");
						if(GetWorkersCount(pInfo[playerid][direktorius], false) == 0) return MSG(playerid, RED, "- Prisijungusi� darbuotoj� n�ra");
						if(strval(input) > DarboInfo[pInfo[playerid][direktorius]][DarboFondas]) return MSG(playerid, RED, "- Darbo fonde tiek n�ra!");
						new isvisoisdalino;
						if(GetWorkersCount(pInfo[playerid][direktorius], false) * strval(input) > DarboInfo[pInfo[playerid][direktorius]][DarboFondas]) return MSG(playerid, RED, "- Pinig� visiem neu�teks!");
						else
						{
							foreach(new i : Player)
							{
								if(pInfo[i][darbas] == pInfo[playerid][direktorius] && i != playerid)
								{
									isvisoisdalino += strval(input);
 									pInfo[i][pinigai] += strval(input);
									DarboInfo[pInfo[playerid][direktorius]][DarboFondas] -= strval(input);
								}
							}
							SendFormat(playerid, GREEN, "� I� darbo fondo i�dalinote %s� - %i darbuotojams", konvertuoti_pinigus(isvisoisdalino), GetWorkersCount(pInfo[playerid][direktorius], false));
						}
					}  
					else return ShowPlayerDialog(playerid, dfondas, DIALOG_STYLE_LIST, "{ffffff}DVP � Darbo fondas","{3abeff}� {ffffff}Darbo {3abeff}pelnas\n{3abeff}� {ffffff}I�imti pinigus i� {3abeff}fondo\n{3abeff}� {ffffff}�d�ti pinig� � {3abeff}fond�\n{3abeff}� {ffffff}I�dalinti pinigus {3abeff}darbuotojams", "Toliau", "Atgal");
				}
				Dialog_ShowCallback(playerid, using inline isdalintisaibas, DIALOG_STYLE_INPUT, "{ffffff}DVP � Darbo fondas � I�dalinti pinigus", "{3abeff}� {ffffff}�veskite kiek {3abeff}pinig�{ffffff} norite {3abeff}i�dalinti:", "I�dalinti", "Atgal");
			}
			default:
			{
				inline pinigaidfonde(id, did, resp, litem, string:input[])
				{
					#pragma unused id, did, litem, input
					if(resp) return ShowPlayerDialog(playerid, dfondas, DIALOG_STYLE_LIST, "{ffffff}DVP � Darbo fondas","{3abeff}� {ffffff}Darbo {3abeff}pelnas\n{3abeff}� {ffffff}I�imti pinigus i� {3abeff}fondo\n{3abeff}� {ffffff}�d�ti pinig� � {3abeff}fond�\n{3abeff}� {ffffff}I�dalinti pinigus {3abeff}darbuotojams", "Toliau", "Atgal");
				}
				new string[100];
				format(string, sizeof(string), "{3abeff}� {ffffff}�iuo metu darbo {3abeff}fonde{ffffff} yra: {3abeff}%s�", konvertuoti_pinigus(DarboInfo[pInfo[playerid][direktorius]][DarboFondas]));
				Dialog_ShowCallback(playerid, using inline pinigaidfonde, DIALOG_STYLE_MSGBOX, "{ffffff}DVP � Darbo fondas � Pelnas", string, "Atgal", "");
			}	
		}
		return 1;
	}
	if(dialogid == kviesti)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // med
				{
					if(GetWorkersCount(MEDIKAI, true) == 0) return MSG(playerid, RED, "- N�ra aktyvi� medik�!"); 
					if(DarboInfo[MEDIKAI][dirba] == false) return MSG(playerid, RED, "- Medikai �iuo metu nedirba");
					pInfo[playerid][kvieciaID] = MEDIKAI;
					SetPlayerColor(playerid, 0xAA3333AA);

					SendFormat(playerid, GREEN, "+ Medikai i�kviesti. �iuo metu aktyvi� darbuotoj�: %i", GetWorkersCount(MEDIKAI, true));

					SendFormatToJob(MEDIKAI, -1, "{f49e42}[RACIJA]: �aid�jas %s kvie�ia medikus (/vaziuoju %s)", playerName[playerid], playerName[playerid]);
				}
				case 1: // pd
				{
					if(GetWorkersCount(POLICININKAI, true) == 0) return MSG(playerid, RED, "- N�ra aktyvi� policinink�!"); 
					if(DarboInfo[POLICININKAI][dirba] == false) return MSG(playerid, RED, "- Medikai �iuo metu nedirba");
					pInfo[playerid][kvieciaID] = POLICININKAI;
					SetPlayerColor(playerid, 0x0000BBAA);

					SendFormat(playerid, GREEN, "+ Policija i�kviesta. �iuo metu aktyvi� darbuotoj�: %i", GetWorkersCount(POLICININKAI, true));

					SendFormatToJob(POLICININKAI, -1, "{f49e42}[RACIJA]: �aid�jas %s kvie�ia policij� (/vaziuoju %s)", playerName[playerid], playerName[playerid]);
				}	
			}
		}
		return 1;
	}
	if(dialogid == leisgyviss)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					KillTimer(leisgyvistimer[playerid]);
					if(GetWorkersCount(MEDIKAI, true) == 0)
					{
						ShowPlayerDialog(playerid, leisgyviss, DIALOG_STYLE_LIST, "Leisgyvis", "{74C487}�{ffffff} Prane�ti medikams ir laukti j� pagalbos\n{74C487}�{ffffff} Keliauti � ligonin�", "Pasirinkti", "");
						MSG(playerid, RED, "- Prisijungusi� medik� n�ra!");
					}
					else
					{
						pInfo[playerid][kvieciaID] = MEDIKAI;
						SendFormat(playerid, GREEN, "+ Medikai i�kviesti. �iuo metu aktyvi� darbuotoj�: %i", GetWorkersCount(MEDIKAI, true));

						SendFormatToJob(MEDIKAI, -1, "{f49e42}[RACIJA]: Leisgyvis �aid�jas %s kvie�ia medikus (/vaziuoju %s)", playerName[playerid], playerName[playerid]);

						SetPlayerColor(playerid, 0xAA3333AA);

						new Float:cords[3];
						GetPlayerPos(playerid, cords[0], cords[1], cords[2]);

						leisgyvistext[playerid] = Create3DTextLabel("{9ADBA9}�aid�jas leisgyvis\n{ffffff}Spaudin�kite {9ADBA9}�Y� {ffffff}klavi�� nor�dami suteikti pirmaj� pagalb�", -1, cords[0], cords[1], cords[2]+0.3, 10,0,0);
					}
				}
				case 1:
				{
					ClearAnimations(playerid);
					SetPlayerHealth(playerid, 0);
					KillTimer(leisgyvistimer[playerid]);
				}
			}
		}
		else return ShowPlayerDialog(playerid, leisgyviss, DIALOG_STYLE_LIST, "Leisgyvis", "{74C487}�{ffffff} Prane�ti medikams ir laukti j� pagalbos\n{74C487}�{ffffff} Keliauti � ligonin�", "Pasirinkti", "");
		return 1;
	}
	if(dialogid == get)
	{
		new
			id = pInfo[playerid][PasirinktasZaidejas],
			Float:cords[3]
		;
		if(!response)
		{
			SendFormat(id, 0x00B8D8AA, "- �aidejas %s nesutiko buti perkeltas pas jus!", playerName[playerid]);
			SendFormat(playerid, 0x00B8D8AA, "- Nesutikote buti perkeltas pas %s",playerName[id]);
		}
		SendFormat(id, 0x00B8D8AA, "+ �aidejas %s sutiko atsikelti pas jus", playerName[playerid]);
		SendFormat(playerid, 0x00B8D8AA, "� Buvote perkeltas pas %s",playerName[id]);
		SetPlayerInterior(playerid,GetPlayerInterior(id));
		GetPlayerPos(id,cords[0],cords[1],cords[2]);
		SetPlayerPos(playerid,cords[0],cords[1],cords[2]);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	if(dialogid == to)
	{
		if(response)
		{
			new id;
			id = pInfo[playerid][PasirinktasZaidejas];
			new Float:cords[3];
			GetPlayerPos(id, cords[0], cords[1], cords[2]);
			SetPlayerPos(playerid, cords[0], cords[1], cords[2]);
			SetCameraBehindPlayer(playerid);
			SetPlayerInterior(playerid, GetPlayerInterior(id));
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
		}
		else return MSG(playerid, RED, "- �aidejas nesutiko!");
		return 1;
	}
	if(dialogid == bausti)
	{
	    if(response)
	    {
	        new giveplayerid, String[216];
          	giveplayerid = pInfo[playerid][PasirinktasZaidejas];
	        {
	            switch(listitem)
	            {
	                case 1..5:
                 	{
						if(pInfo[giveplayerid][Muted] > 0) return MSG(playerid, RED, "- �aid�jas jau yra u�tildytas");
                		format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Administratorius {33B7D3}%s {ffffff}u�tild� �aid�j� {33B7D3}%s{ffffff}!", playerName[playerid], playerName[giveplayerid]);
						SendClientMessageToAll(-1, String);

						format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Prie�astis: {33B7D3}%s {ffffff}| Laikas: {33B7D3}%s{ffffff} min!", FAL[listitem][Bausme], konvertuoti_pinigus(FAL[listitem][bLaikas]));
						SendClientMessageToAll(-1, String);

						pInfo[giveplayerid][Muted] = gettime() + (FAL[listitem][bLaikas] * 60);
						MuteTime[giveplayerid] = SetTimerEx("Mute", 1000, true, "i",giveplayerid);
						format(pInfo[giveplayerid][KasUztilde], 24, "%s'", playerName[playerid]);

						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET mutelaikas = '%i', perma_mute = '0', adminmutename = '%e' WHERE vardas = '%e'", pInfo[giveplayerid][Muted], playerName[playerid], playerName[giveplayerid]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
	                case 7..10:
                 	{
                		format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Administratorius {33B7D3}%s {ffffff}i�met� �aid�j� {33B7D3}%s{ffffff}!", playerName[playerid], playerName[giveplayerid]);
						SendClientMessageToAll(-1, String);

						format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Prie�astis: {33B7D3}%s{ffffff}!", FAL[listitem][Bausme]);
						SendClientMessageToAll(-1, String);

						_Kick(giveplayerid);
					}
	            }
	        }
	    }
	}
 	if(dialogid == bausti2)
	{
	    if(response)
	    {
	        new playerid2, String[216];
          	playerid2 = pInfo[playerid][PasirinktasZaidejas];
	        {
	            switch(listitem)
	            {
	                case 1..5:
                 	{
						if(pInfo[playerid2][Muted] > 0) return MSG(playerid, RED, "- �aid�jas jau yra u�tildytas");
                		format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Administratorius {33B7D3}%s {ffffff}u�tild� �aid�j� {33B7D3}%s{ffffff}!", playerName[playerid], playerName[playerid2]);
						SendClientMessageToAll(-1, String);

						format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Prie�astis: {33B7D3}%s {ffffff}| Laikas: {33B7D3}%s{ffffff} min!", TAL[listitem][Bausme], konvertuoti_pinigus(TAL[listitem][bLaikas]));
						SendClientMessageToAll(-1, String);

						pInfo[playerid2][Muted] = gettime() + (TAL[listitem][bLaikas] * 60);
						MuteTime[playerid2] = SetTimerEx("Mute", 1000, true, "i",playerid2);
						format(pInfo[playerid2][KasUztilde], 24, "%s'", playerName[playerid]);

						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET mutelaikas = '%i', perma_mute = '0', adminmutename = '%e' WHERE vardas = '%e'", pInfo[playerid2][Muted], playerName[playerid], playerName[playerid2]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
	                case 8..10:
                 	{
                		format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Administratorius {33B7D3}%s {ffffff}i�met� �aid�j� {33B7D3}%s{ffffff}!", playerName[playerid], playerName[playerid2]);
						SendClientMessageToAll(-1, String);

						format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Prie�astis: {33B7D3}%s{ffffff}!", TAL[listitem][Bausme]);
						SendClientMessageToAll(-1, String);

						_Kick(playerid2);
					}
	                case 13..16:
                 	{
                		if(pInfo[playerid][BanTimer] > gettime()) return SendFormat(playerid, -1, "{75B244}��� {FFFFFF}Dar nepra�jo 10 minu�i� nuo praeito u�blokavimo, palaukite: %s!",ConvertSeconds(pInfo[playerid][BanTimer] - gettime()));

						pInfo[playerid2][BanLaikas] = gettime() + (TAL[listitem][bLaikas] * 60);

						pInfo[playerid][BanTimer] = gettime() + 300;
						Blokuoti(playerid2, 2, TAL[listitem][Bausme], playerid, gettime() + (TAL[listitem][bLaikas] * 60));
             		}
         		}
	    	}
		}
	}
	if(dialogid == bausti3)
	{
	    if(response)
	    {
	        new playerid2, String[216];
          	playerid2 = pInfo[playerid][PasirinktasZaidejas];
	        {
	            switch(listitem)
	            {
	                case 1..5:
                 	{
						if(pInfo[playerid2][Muted] > 0) return MSG(playerid, RED, "- �aid�jas jau yra u�tildytas");
                		format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Administratorius {33B7D3}%s {ffffff}u�tild� �aid�j� {33B7D3}%s{ffffff}!", playerName[playerid], playerName[playerid2]);
						SendClientMessageToAll(-1, String);

						format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Prie�astis: {33B7D3}%s {ffffff}| Laikas: {33B7D3}%s{ffffff} min!", SAL[listitem][Bausme], konvertuoti_pinigus(SAL[listitem][bLaikas]));
						SendClientMessageToAll(-1, String);

						pInfo[playerid2][Muted] = gettime() + (TAL[listitem][bLaikas] * 60);
						MuteTime[playerid2] = SetTimerEx("Mute", 1000, true, "i",playerid2);
						format(pInfo[playerid2][KasUztilde], 24, "%s'", playerName[playerid]);

						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET mutelaikas = '%i', perma_mute = '0', adminmutename = '%e' WHERE vardas = '%e'", pInfo[playerid2][Muted], playerName[playerid], playerName[playerid2]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
	                case 8..10:
                 	{
                		format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Administratorius {33B7D3}%s {ffffff}i�met� �aid�j� {33B7D3}%s{ffffff}!", playerName[playerid], playerName[playerid2]);
						SendClientMessageToAll(-1, String);

						format(String, sizeof(String),
						"{75B244}��� {FFFFFF}Prie�astis: {33B7D3}%s{ffffff}!", SAL[listitem][Bausme]);
						SendClientMessageToAll(-1, String);

						_Kick(playerid2);
					}
	                case 13..16:
                 	{
                		if(pInfo[playerid][BanTimer] > gettime() && pInfo[playerid][ADMIN] != SAVININKAS) return SendFormat(playerid, -1, "{75B244}��� {FFFFFF}Dar nepra�jo 10 minu�i� nuo praeito u�blokavimo, palaukite: %s!",ConvertSeconds(pInfo[playerid][BanTimer] - gettime()));

						pInfo[playerid2][BanLaikas] = gettime() + (SAL[listitem][bLaikas] * 60);

						pInfo[playerid][BanTimer] = gettime() + 300;
						Blokuoti(playerid2, 2, TAL[listitem][Bausme], playerid, gettime() + (SAL[listitem][bLaikas] * 60));
             		}
         		}
	    	}
		}
	}
	if(dialogid == admins)
	{
	    if(response)
		{
		    ShowPlayerDialog(playerid, rasytiadmins, DIALOG_STYLE_INPUT, "Ra�yti �inute administracijai", "{ffffff}Prie� i�siunciant �inute serverio administratoriams perskaitykite �ias taisykles:\n \n\
		    \t1. Nepra�yti pinigu, patirties ta�ku, direktoriu ir t.t.\n\t2. Nera�yti necenzurinius �od�ius\n\t3. Nei�eidineti administratori�\n\t4. Nefloodinti ra�ydami daug kartu ta pati prane�ima", "Siusti", "U�daryti");
		}
	}
	if(dialogid == rasytiadmins)
	{
	    if(response)
		{
		   if(strfind(inputtext, "%") != -1) return _Kick(playerid);
		   new String[128];
           if(pInfo[playerid][ParaseAdminams] > gettime() && pInfo[playerid][ADMIN] < SAVININKAS) SendFormat(playerid, -1, "{75B244}��� {FFFFFF}Administratoriams galima ra�yti tik kas 2min., kit� gal�site ras�yti po: %s!",ConvertSeconds(pInfo[playerid][ParaseAdminams] - gettime()));
           if(strlen(inputtext) > 128) MSG(playerid, -1, "{75B244}��� {FFFFFF}Tekstas per ilgas!");

		   for(new i, size = GetPlayerPoolSize(); i <= size; i ++)
		   {
				if(IsPlayerConnected(i) && pInfo[i][ADMIN] > ILVLADMIN)
				{
					format(String, sizeof(String), "{2DB2D0}%s(%d) administratoriams: {ffffff}%s (/padeti %i)", playerName[playerid], playerid, inputtext, playerid);
				 	MSG(i, -1, String);
				}
		   }
			
		   if(pInfo[playerid][ADMIN] < ILVLADMIN)
		   {
				format(String, sizeof(String), "{2DB2D0}Para��te administratoriams: {ffffff}%s", inputtext);
				MSG(playerid, -1, String);
		   }
			
		   pInfo[playerid][ParaseAdminams] = gettime() + 120; //2min
		   AHS[playerid][PaklausePagalbos] = true;
		}
	}
	return 1;
}

function OndirektoriusSetRank(playerid, rank)
{

	if(cache_num_rows() > 0)
	{
		new rangas, genderis;

		cache_get_value_index_int(0, 0, rangas);

		if(rangas == rank) return SendFormat(playerid, RED, "- �aid�jas jau yra %i rango", rank);

		cache_get_value_index_int(0, 1, genderis);

		new uniformakokia;

		switch(rank)
		{
			case 1:
			{
				if(genderis == 0) uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin1_male];
				else uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin1_female];
			}
			case 2:
			{
				if(genderis == 0) uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin2_male];
				else uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin2_female];
			}
			case 3:
			{
				if(genderis == 0) uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin3_male];
				else uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin3_female];
			}
			case 4:
			{
				if(genderis == 0) uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin4_male];
				else uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin4_female];
			}
			case 5:
			{
				if(genderis == 0) uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin5_male];
				else uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin5_female];
			}
			case 6:
			{
				if(genderis == 0) uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin6_male];
				else uniformakokia = DarboInfo[pInfo[playerid][direktorius]][Skin6_female];
			}
		}
		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET Rangas = '%i', uniforma = '%i' WHERE vardas = '%e'", rank, uniformakokia, DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);	
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		SendFormat(playerid, GREEN, "U�d�jote %i �aid�jui ");
	}
	else printf("ERROR SKIRTIRANGAS");
	return 1;
}

function OndirektoriusUnWarnWorker(playerid, reason[])
{
	new warnings;

	cache_get_value_index_int(0, 0, warnings);

	if(warnings == 0)
	{
		new string[50], string1[120];
		format(string, sizeof(string), "{ffffff}DVP � Nuimti �sp�jim�",DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
		format(string1, sizeof(string1), "{ffffff}Nor�dami nuimti �sp�jim� darbuotojui {F0E678}%s{ffffff} �veskite {F0E678}prie�ast� {ffffff}apa�ioje", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
		ShowPlayerDialog(playerid, nuimtiisp, DIALOG_STYLE_INPUT, string, string1, "�sp�ti", "Atgal");
		MSG(playerid, RED, "- Darbuotojas neturi �sp�jim�!");
	}
	else
	{
		warnings -= 1;

		SendFormat(playerid, -1, "{BC7BC7}�{ffffff} Nu�m�te �sp�jim� {BC7BC7}%s {ffffff}darbuotojui d�l {BC7BC7}%s",DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], reason);

		SendFormatToJob(pInfo[playerid][direktorius], -1, "{DE5492}Direktorius {D490AF}%s {DE5492}nu�m� �sp�jim� darbuotojui {D490AF}%s {DE5492}d�l: {DE5492}%s", playerName[playerid], DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], reason);

		mysql_format(connectionHandle, query, 200, "UPDATE `zaidejai` SET `disp` = '%i' WHERE `vardas` = '%e'", warnings, DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	return 1;
}

function OndirektoriusWarnOfflinePlayer(playerid, reason[])
{
	new warnings;
	cache_get_value_index_int(0, 0, warnings);

	warnings += 1;

	if(warnings < 3)
	{
		mysql_format(connectionHandle, query, 200, "UPDATE `zaidejai` SET `disp` = '%i' WHERE `vardas` = '%e'", warnings, DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		SendFormat(playerid, -1, "{BC7BC7}�{ffffff} �sp�jote {BC7BC7}%s{ffffff} darbuotoj� d�l {BC7BC7}%s", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], reason);

		mysql_format(connectionHandle, query, 200, "INSERT INTO `ispejimai` (`data`, `kasispejo`, `priezastis`, `vardas`, `isptipas`) VALUES ('%s', '%s', '%s', '%s', '%i')",GautiData(0), playerName[playerid], reason, DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], 3);
		mysql_tquery(connectionHandle, query, "SendQuery");

		SendFormatToJob(pInfo[playerid][direktorius], -1,"{DE5492}Direktorius {D490AF}%s {DE5492}�sp�jo darbuotoj� {D490AF}%s {DE5492}d�l {D490AF}%s", playerName[playerid], DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], reason);
	}
	else if(warnings >= 3)
	{
		mysql_format(connectionHandle, query, 200, "UPDATE `zaidejai` SET `darbas` = '0', `uniforma` = '0', `wUniform` = '0', `disp` = '0', `isidarbino` = '' WHERE `vardas` = '%e'", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);

		mysql_tquery(connectionHandle, query, "SendQuery", "");

		SendFormat(playerid, GREEN, "{BC7BC7}�{ffffff} {BC7BC7}%s {ffffff}surinko {BC7BC7}3{ffffff} �sp�jimus ir buvo i�mestas i� darbo!", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);

		SendFormatToJob(pInfo[playerid][direktorius], -1, "{DE5492}Direktorius {D490AF}%s {DE5492}�sp�jo darbuotoj� {D490AF}%s {DE5492}d�l {D490AF}%s{DE5492}, darbuotojas surinko 3 �sp�jimus ir buvo i�mestas i� darbo", playerName[playerid], DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], reason);
	}
	return 1;
}

function OnPlayerRequestInfoAboutWorker(playerid)
{
	if(cache_num_rows() > 0)
	{
		new data[14], warnings, sndpradirbo, string[400];

		cache_get_value_index_int(0,0, warnings);
		cache_get_value_index_int(0,1, sndpradirbo);
		cache_get_value_index(0, 2, data);

    	format(string, sizeof(string), "{ffffff}Darbuotojo {74C487}%s {ffffff}informacija\n\n\t{4bbaed}�{ffffff} Darbuotojas �iuo metu {FF3C00}atsijung�s\n\t{4bbaed}�{ffffff} Darbuotojo �sp�jimai {4bbaed}%i/3\n\t{4bbaed}�{ffffff} Darbuotojas �iandien pradirbo {4bbaed}%imin\n\t�{ffffff} Darbuotojas nuo {4bbaed}%s", \
    	DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]], \
    	warnings,\
    	sndpradirbo,\
    	data);
    	
    	inline workinfo(pid, did, resp, litem, string:input[])
    	{
			#pragma unused pid, did, litem, input
			if(resp)
			{
				new workername[31];
				format(workername, sizeof(workername), "{ffffff}DVP � %s", DarbuotojuVardai[pInfo[playerid][direktorius]][pInfo[playerid][ziuridarbuotoja]]);
    			ShowPlayerDialog(playerid, kontrole, DIALOG_STYLE_LIST, workername, "{3abeff}�{ffffff} Darbuotojo informacija\n{3abeff}�{ffffff} �sp�ti darbuotoj�\n{3abeff}�{ffffff} Nuimti �sp�jim�", "Toliau", "Atgal");
			}
    	}
    	Dialog_ShowCallback(playerid, using inline workinfo, DIALOG_STYLE_MSGBOX, "Informacija", string, "Atgal", "");
	}
}

function OnPlayerRequestWorkersList(playerid)
{
	if(cache_num_rows() > 0)
	{
		for(new g = 0; g < MAX_DARBU; g++)
		{	
			DarbuotojuVardai[pInfo[playerid][direktorius]][g][0] = EOS;
		}
		new rows, index = 0, str[200], fstr[3500], prisijunges[20]; 
		cache_get_row_count(rows);
		for(new i = 0; i < rows; i++)
		{
			cache_get_value_name(i, "vardas", DarbuotojuVardai[pInfo[playerid][direktorius]][i]);
            index ++;
		}
		for(new i = 0; i <= MAX_PLAYERS; i++)
		{
			if(isnull(DarbuotojuVardai[pInfo[playerid][direktorius]][i])) break;
			if(GetPlayeridMid(DarbuotojuVardai[pInfo[playerid][direktorius]][i]) != INVALID_PLAYER_ID){prisijunges = "{00FF11}yra";} else { prisijunges = "{FF3C00}n�ra";}
            format(str, sizeof(str), "{3abeff}�{ffffff} Darbuotojas %s �iuo metu %s {ffffff}�aidime\n",DarbuotojuVardai[pInfo[playerid][direktorius]][i], prisijunges);
            strcat(fstr, str);
		}
		ShowPlayerDialog(playerid, visidarbuotojai,DIALOG_STYLE_LIST, "{ffffff}DVP � Visi darbuotojai", fstr, "Pasirinkti", "Atgal");
	}
	else return MSG(playerid, 0xFF0000FF, "- Darbuotoj� n�ra");
	return 1;
}

function OnPickupSumoketAdmBauda(playerid)
{
	if(cache_num_rows() > 0)
	{	
		new rows;
		cache_get_row_count(rows);
		new fstr[1000], str[500];
		for(new row=0;row<rows; row++)
		{
			cache_get_value_index(row, 1, BauduInfo[playerid][row][BaudosVardas], 120);

			cache_get_value_index(row, 2, BauduInfo[playerid][row][kamskirta], 24);

			cache_get_value_index(row, 3, BauduInfo[playerid][row][kasisrase], 24);

			cache_get_value_index(row, 4, BauduInfo[playerid][row][kadaisrase], 31);

			cache_get_value_index_int(row, 5, BauduInfo[playerid][row][baudos_suma]);

			format(str, sizeof(str), "{ffffff}Numeris - Baudos pavadinimas - Kam skirta - Kas i�ra�� - Kada i�ra�yta - Baudos suma\n");
			
			strcat(fstr, str);

			format(str, sizeof(str), "{89BE8D}%i.{ffffff} %s - %s - %s - %s - {89BE8D}%s�{ffffff}\n", \
				row+1, BauduInfo[playerid][row][BaudosVardas], BauduInfo[playerid][row][kamskirta], BauduInfo[playerid][row][kasisrase], BauduInfo[playerid][row][kadaisrase], konvertuoti_pinigus(BauduInfo[playerid][row][baudos_suma]));
			strcat(fstr, str);

			MSG(playerid, GREEN, "+ S�kmingai sumok�jote baud�");
		}
		inline sumoket_adm_bauda(pid, did, resp, litem, string:input[])
		{
			#pragma unused pid, did, input
			if(resp)
			{
				if(litem==0) return Dialog_ShowCallback(playerid, using inline sumoket_adm_bauda, DIALOG_STYLE_LIST, "Policijos departamentas -> Baudos mok�jimas", fstr, "Sumok�ti", "I�eiti");
				if(pInfo[playerid][pinigai] < BauduInfo[playerid][litem-1][baudos_suma]) return MSG(playerid, RED, "- Neturite pakankamai pinig� baudai sumok�ti");
				pInfo[playerid][pinigai] -= BauduInfo[playerid][litem-1][baudos_suma];
				mysql_format(connectionHandle, query, 140, "DELETE FROM zaideju_baudos_administracines WHERE kamskirta = '%e' AND baudos_suma = '%i' LIMIT 1;", playerName[playerid], BauduInfo[playerid][litem-1][baudos_suma]);
				mysql_tquery(connectionHandle, query, "SendQuery", "");
			}
		}
		Dialog_ShowCallback(playerid, using inline sumoket_adm_bauda, DIALOG_STYLE_LIST, "{ffffff}Policijos departamentas -> Baudos mok�jimas", fstr, "Sumok�ti", "I�eiti");
	}
	else return MSG(playerid, RED, "- J�s neturite baud�");
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	ShowInfo(clickedplayerid, playerid);
	return 1;
}

//
function RemoveTazed(playerid)
{
	TogglePlayerControllable(playerid, 1);
	ClearAnimations(playerid);
	pInfo[playerid][Nutazintas] = false;
	pInfo[playerid][NutazintasTimer] = 0;
	KillTimer(nutazintas_idtimer[playerid]);
}

function Metam(playerid)
{
	Kick(playerid);
	return 1;
}

stock Reset(playerid)
{
	online[playerid] = false;
	poRegistracijos[playerid] = false;
	poPrisijungimo[playerid] = false;
	poMirties[playerid] = false;
	pInfo[playerid][skin] = 0;
	pInfo[playerid][patirtis] = 0;
	pInfo[playerid][pinigai] = 0;
	pInfo[playerid][ADMIN] = 0;
	pInfo[playerid][VIP] = 0;
	pInfo[playerid][lytis] = 0;
	pInfo[playerid][VipLaikas] = 0;
	pInfo[playerid][AdminLaikas] = 0;
	pInfo[playerid][Muted] = 0;
	pInfo[playerid][ParaseAdminams] = 0;
	pInfo[playerid][darbas] = 0;
	pInfo[playerid][wUniform] = 0;
	pInfo[playerid][uniforma] = 0;
	pInfo[playerid][gaudomumas] = 0;
	pInfo[playerid][aisp] = 0;
	pInfo[playerid][disp] = 0;
	pInfo[playerid][visp] = 0;
	pInfo[playerid][direktorius] = 0;
	pInfo[playerid][pavaduotojas] = 0;
	pInfo[playerid][Invited] = 0;
	pInfo[playerid][siandienpradirbo] = 0;
	pInfo[playerid][siandienprazaide] = 0;
	pInfo[playerid][Surakintas] = false;
	leisgyvis[playerid] = false;
	bega[playerid] = false;
	pInfo[playerid][kvieciaID] = 0;
	pInfo[playerid][viskvmed] = false;
	pInfo[playerid][viskvpd] = false;
	pInfo[playerid][LaikoLigoninej] = 0;
	pInfo[playerid][pagydymai] = 0;
	pInfo[playerid][baudos] = 0;
	pInfo[playerid][Nutazintas] = false;
	pInfo[playerid][direktorius] = 0;
	pInfo[playerid][pavaduotojas] = 0;
	pInfo[playerid][Invited] = 0;
	pInfo[playerid][siandienpradirbo] = 0;
	pInfo[playerid][siandienprazaide] = 0;
	pInfo[playerid][Surakintas] = false;
	leisgyvis[playerid] = false;
	bega[playerid] = false;
	pInfo[playerid][kvieciaID] = 0;
	pInfo[playerid][viskvmed] = false;
	pInfo[playerid][viskvpd] = false;
	pInfo[playerid][priziuretojas] = 0;
	SetPlayerInterior(playerid, 0);
}

stock GetPlayeridMid(name[]) //Boylett
{
	//printf("%s", name);
	for(new i = 0, size = GetPlayerPoolSize(); i <= size; i++)
	{
		if(IsPlayerConnected(i))
		{
			new gPlayerName[MAX_PLAYER_NAME];
			GetPlayerName(i, gPlayerName, MAX_PLAYER_NAME);
			if(strfind(gPlayerName, name, true) != -1)
			{
				return i;
			}
		}
	}
	return INVALID_PLAYER_ID;
}

stock OnPlayerRegister(playerid)
{
	TogglePlayerSpectating(playerid, false);
	MSG(playerid, GREEN, "+ S�kmingai u�siregistravote");
	online[playerid] = true;
	poRegistracijos[playerid] = true;

	if(pInfo[playerid][lytis] == 0) pInfo[playerid][skin] = 26;// vyras
	else if(pInfo[playerid][lytis] == 1) pInfo[playerid][skin] = 12;

	pInfo[playerid][VIP] = 1;
	pInfo[playerid][VipLaikas] = gettime() + 432000;
	MSG(playerid, GREEN, "- Kadangi u�siregistravote ir esate naujokas gaunate nemokam� VIP status� 5 dienoms!");
	SetPlayerColor(playerid, VIP_COLOR);
	SetSpawnInfo(playerid, NO_TEAM, pInfo[playerid][skin], -1972.6591, 137.9886, 27.6875, 91.9671, 0, 0, 0, 0, 0, 0);
	SetPlayerInterior(playerid, 0);
	SpawnPlayer(playerid);
	return true;
}

stock CheckAllowedChar(string[])
{
	new l=strlen(string), ll=sizeof(AllowedCharacters); 
	new n;
	for(new i=0; i<l; i++)
	{
	    for(n=0; n<ll; n++) 
	        if(string[i] == AllowedCharacters[n])
	            break;
		if(n==ll)
		    return false;
	}
	return true;
}


stock GautiData(type)
{
	/* gauname data ir laika tokiu formatu METAI.MENUO.DIENA, VALANDA:MINUTE */
	new string[31],data[6];
    getdate(data[0],data[1],data[2]);
	gettime(data[3],data[4],data[5]);
	if(type == 0) format(string,31,"%d-%02d-%02d %02d:%02d",data[0],data[1],data[2],data[3],data[4]);
	if(type == 1) format(string, 31, "%d-%02d-%02d", data[0], data[1], data[2]);
	return string;
}

function SendQuery()
{
	return 1;
}

stock randomString(strDest[], strLen = 10)
{
    while(strLen--)
        strDest[strLen] = random(2) ? (random(26) + (random(2) ? 'a' : 'A')) : (random(10) + '0');
}

stock ControlPlayerInTime(playerid, time, bool:mode) return (time <= 0) ? 0 : SetTimerEx("ToggleControlPlayer", time , 0, "db", playerid, (mode) ? true : false);
function ToggleControlPlayer(playerid, bool:mode) return TogglePlayerControllable(playerid, (mode) ? true : false);

stock SendFormatToJob(darboid, color, text[], va_args<>){

	new buffer[218];
	va_format(buffer, sizeof buffer, text, va_start<3>);
	return DarbuZinute(color, darboid, buffer);
}

function Nepaememinimumo(playerid)
{
	if(cache_num_rows() > 0)
	{
		new rowws = 0, name[MAX_PLAYER_NAME], playerjobid, totalpagydymai, totalbaudos, siandienpradirbes;
		cache_get_row_count(rowws);
		for(new i = 0; i < rowws; i++)
		{
			cache_get_value(i, 0, name);

			new id = GetPlayeridMid(name);

			if(id != INVALID_PLAYER_ID) continue;

			cache_get_value_index_int(i, 1, playerjobid);
			cache_get_value_index_int(i, 2, totalpagydymai);
			cache_get_value_index_int(i, 3, totalbaudos);
			cache_get_value_index_int(i, 4, siandienpradirbes);	

			switch(playerjobid)
			{
				case MEDIKAI:
				{
					if(totalpagydymai < DarboInfo[playerjobid][dienosminimumasPAGYD] || siandienpradirbes < DarboInfo[playerjobid][dienosminimumasMIN])
					{
						mysql_format(connectionHandle, query, 144, "INSERT INTO nepaememin (vardas, date, darbas, pradirbo, baudos, pagydymai) VALUES ('%s', '%s', '%i', '0', '%i')", name, GautiData(1), playerjobid, siandienpradirbes, totalpagydymai);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
				}
				case POLICININKAI..ARMIJA:
				{
					if(totalbaudos < DarboInfo[playerjobid][dienosminimumasBAUDOS] || siandienpradirbes < DarboInfo[playerjobid][dienosminimumasMIN])
					{
						mysql_format(connectionHandle, query, 144, "INSERT INTO nepaememin (vardas, date, darbas, pradirbo, baudos, pagydymai) VALUES ('%s', '%s', '%i', '%i', '%i', '0')", name, GautiData(1), playerjobid, siandienpradirbes, totalbaudos);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
				}
			}
		}
		mysql_format(connectionHandle, query, 144, "UPDATE zaidejai SET pagydymai = '0', baudos = '0', `siandienpradirbo` = '0', `siandienprazaide` = '0'");
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	return 1;
}


function OnDirectorTogglesZinute(playerid)
{
	if(cache_num_rows() > 0)
	{
		new toggle;
		cache_get_value_index_int(0, 0, toggle);
		if(toggle == 0)
		{
			mysql_format(connectionHandle, query, 140, "UPDATE darbai SET arijungta = '1' WHERE jobID = '%i'", pInfo[playerid][direktorius]);
			MSG(playerid, GREEN, "� �jung�te darbo �inut�");
		}
		else
		{
			mysql_format(connectionHandle, query, 140, "UPDATE darbai SET arijungta = '0' WHERE jobID = '%i'", pInfo[playerid][direktorius]);
			MSG(playerid, RED, "� I�jung�te darbo �inut�");
		}
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	else return MSG(playerid, RED, "- �vyko serverio klaida, susisiekite su pagr administracija!");
	return 1;
}

function ResetAllJobCars(playerid)
{
	foreach(new i : Player)
	{
		new vehID = GetVehiclePoolSize();

		for(new z = 0; z <= vehID; z++)
		{
			switch(pInfo[playerid][direktorius])
			{
				case MEDIKAI:
				{
					if(z == sizeof(medikucar))
					{
						if(!IsPlayerInVehicle(i, z)){SetVehicleToRespawn(z);}
					}
				}
				case POLICININKAI:
				{
					if(z == sizeof(pdcar))
					{
						if(!IsPlayerInVehicle(i, z)){SetVehicleToRespawn(z);}
					}
				}
				case ARMIJA:
				{
					if(z == sizeof(armijoscar))
					{
						if(!IsPlayerInVehicle(i, z)){SetVehicleToRespawn(z);}
					}
				}
			}
		}
	}
	SendFormatToJob(pInfo[playerid][direktorius], -1, "{DE5492}Direktorius {D490AF}%s{DE5492} atstat� nenaudojamas darbines tr. priemones!",playerName[playerid]);
	return 1;
}

stock isValidDate(str[],form=DDMMYY,seperator='/') 
{ 
    new count; 
    new daysinmonth[12]={31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}; 
    new bool:legit; 
    for(new i,j=strlen(str);i<j;i++) 
        if(str[i]==seperator)count++; 


    if(count != 2) return false; 

    new d,y,m,string[9]; 
    format(string,sizeof(string),"p<%c>iii",seperator); 

    if(form == DDMMYY) {
        if(sscanf(str, string,d, m, y)) return false; }

    else if(form == DDYYMM) {
        if(sscanf(str, string,d, y, m)) return false; }

    else if(form == MMDDYY) {
        if(sscanf(str, string,m, d, y)) return false; }
     
    else if(form == MMYYDD) {
        if(sscanf(str, string,m, y, d)) return false; }
     
    else if(form == YYDDMM) {
        if(sscanf(str, string,y, d, m)) return false; }
     
    else if(form == YYMMDD) {
        if(sscanf(str, string,y, m, d)) return false; }

    if(d < 1 && d > 31) return false; 

    if(m < 1 && m > 12) return false; 

     
    if(y % 400 == 0 || (y % 100 != 0 && y % 4 == 0)) 
                daysinmonth[1]=29; 

    if (m<13) 
    { 
      if( d <= daysinmonth[m-1] ) 
                legit=true; 
    } 

    if (!legit) return false; 

    return true; 

}  

stock IsWeaponAllowed(playerid)
{
	new weaponid = GetPlayerWeapon(playerid);

	if(weaponid == 16 || weaponid == 18 || weaponid == 26 || weaponid == 27 || weaponid == 32 || weaponid == 33 || weaponid == 35 || weaponid == 36 || weaponid == 37 || weaponid == 38 || weaponid == 39 || weaponid == 40 || weaponid == 44 || weaponid == 45) return true;
	
	return false;
}

stock randomEx(min, max)
{    
    //Credits to y_less    
    new rand = random(max-min)+min;   
    return rand;
}

stock ShowLogotipas(playerid){
	for(new i = 0; i < 3; i++){
		TextDrawShowForPlayer(playerid, Logotipas[i]);
	}
	return 1;
}

stock ShowDataIrLaikas(playerid){
	TextDrawShowForPlayer(playerid, Laikrodis[0]);
	TextDrawShowForPlayer(playerid, SiandienosData[0]);
	return 1;
}

stock LoadTextDraws(){
	/* LOGOTIPAS-----------------------------------------------------------*/
	Logotipas[0] = TextDrawCreate(125.000000, 328.000000, "ld_grav:leaf");
	TextDrawFont(Logotipas[0], 4);
	TextDrawLetterSize(Logotipas[0], 0.600000, 2.000000);
	TextDrawTextSize(Logotipas[0], 16.500000, 10.500000);
	TextDrawSetOutline(Logotipas[0], 1);
	TextDrawSetShadow(Logotipas[0], 0);
	TextDrawAlignment(Logotipas[0], 1);
	TextDrawColor(Logotipas[0], -1);
	TextDrawBackgroundColor(Logotipas[0], 255);
	TextDrawBoxColor(Logotipas[0], 50);
	TextDrawUseBox(Logotipas[0], 1);
	TextDrawSetProportional(Logotipas[0], 1);
	TextDrawSetSelectable(Logotipas[0], 0);

	Logotipas[1] = TextDrawCreate(49.000000, 325.000000, "LERG.LT");
	TextDrawFont(Logotipas[1], 1);
	TextDrawLetterSize(Logotipas[1], 0.600000, 1.549998);
	TextDrawTextSize(Logotipas[1], 400.000000, 17.000000);
	TextDrawSetOutline(Logotipas[1], 1);
	TextDrawSetShadow(Logotipas[1], 0);
	TextDrawAlignment(Logotipas[1], 1);
	TextDrawColor(Logotipas[1], -16776961);
	TextDrawBackgroundColor(Logotipas[1], -1);
	TextDrawBoxColor(Logotipas[1], 50);
	TextDrawUseBox(Logotipas[1], 0);
	TextDrawSetProportional(Logotipas[1], 1);
	TextDrawSetSelectable(Logotipas[1], 0);

	Logotipas[2] = TextDrawCreate(29.000000, 328.000000, "ld_grav:leaf");
	TextDrawFont(Logotipas[2], 4);
	TextDrawLetterSize(Logotipas[2], 0.600000, 2.000000);
	TextDrawTextSize(Logotipas[2], 16.500000, 10.500000);
	TextDrawSetOutline(Logotipas[2], 1);
	TextDrawSetShadow(Logotipas[2], 0);
	TextDrawAlignment(Logotipas[2], 1);
	TextDrawColor(Logotipas[2], -1);
	TextDrawBackgroundColor(Logotipas[2], 255);
	TextDrawBoxColor(Logotipas[2], 50);
	TextDrawUseBox(Logotipas[2], 1);
	TextDrawSetProportional(Logotipas[2], 1);
	TextDrawSetSelectable(Logotipas[2], 0);
	/* LOGOTIPAS-----------------------------------------------------------*/
	//

	/*LAIKRODIS------------------------------------------------------------*/

	Laikrodis[0] = TextDrawCreate(577.000000, 20.000000, "00:00");
	TextDrawFont(Laikrodis[0], 3);
	TextDrawLetterSize(Laikrodis[0], 0.441666, 1.299998);
	TextDrawTextSize(Laikrodis[0], 400.000000, 17.000000);
	TextDrawSetOutline(Laikrodis[0], 1);
	TextDrawSetShadow(Laikrodis[0], 0);
	TextDrawAlignment(Laikrodis[0], 2);
	TextDrawColor(Laikrodis[0], -1);
	TextDrawBackgroundColor(Laikrodis[0], 255);
	TextDrawBoxColor(Laikrodis[0], 50);
	TextDrawUseBox(Laikrodis[0], 0);
	TextDrawSetProportional(Laikrodis[0], 1);
	TextDrawSetSelectable(Laikrodis[0], 0);

	SiandienosData[0] = TextDrawCreate(577.000000, 4.000000, "0000-00-00");
	TextDrawFont(SiandienosData[0], 3);
	TextDrawLetterSize(SiandienosData[0], 0.308331, 1.699998);
	TextDrawTextSize(SiandienosData[0], 400.000000, 66.500000);
	TextDrawSetOutline(SiandienosData[0], 1);
	TextDrawSetShadow(SiandienosData[0], 0);
	TextDrawAlignment(SiandienosData[0], 2);
	TextDrawColor(SiandienosData[0], -1);
	TextDrawBackgroundColor(SiandienosData[0], 255);
	TextDrawBoxColor(SiandienosData[0], 50);
	TextDrawUseBox(SiandienosData[0], 0);
	TextDrawSetProportional(SiandienosData[0], 1);
	TextDrawSetSelectable(SiandienosData[0], 0);
}

stock LoadJobVehicles()
{
	medikucar[0] = CreateVehicle(416,-2591.7476,625.7371,14.0230,107.6049,3,8,600);
	pdcar[0] = CreateVehicle(596,-1581.8373,651.7789,6.7774,359.2187, 0, 1, 600);
	pdcar[1] = CreateVehicle(497,-1680.8640,705.7073,30.7780,270.6260,0,1,600); // helis

	armijoscar[0] = CreateVehicle(470,-1531.1593,448.6610,6.7534,88.9291, 0,1,600);
}

function LoadJobs()
{
	if(cache_num_rows() > 0)
	{
		new rows;
		cache_get_row_count(rows);
		for(new row=0;row<rows; row++)
		{
			new jobID;
			cache_get_value_index_int(row, 0, jobID);
			cache_get_value_index_int(row, 5, DarboInfo[jobID][DarboFondas]);

			cache_get_value_index(row, 1, DarboInfo[jobID][drk],24);
			cache_get_value_index(row, 12, DarboInfo[jobID][pav], 24);

			cache_get_value_index(row, 2, DarboInfo[jobID][drkpareigosenuo],31);
			cache_get_value_index(row, 13, DarboInfo[jobID][pavpareigosenuo],31);

			cache_get_value_index_bool(row, 6, DarboInfo[jobID][dirba]);
			cache_get_value_index_int(row, 7, DarboInfo[jobID][nedirbsiki]);

			if(DarboInfo[jobID][dirba] == false && DarboInfo[jobID][nedirbsiki] <= gettime())
			{
				DarboInfo[jobID][dirba] = true;
				DarboInfo[jobID][nedirbsiki] = 0;
			}

			cache_get_value_index_int(row, 8, DarboInfo[jobID][dienosminimumasMIN]);
			cache_get_value_index_int(row, 14, DarboInfo[jobID][dienosminimumasPAGYD]);
			cache_get_value_index_int(row, 9, DarboInfo[jobID][dienosminimumasBAUDOS]);

			cache_get_value_index_bool(row, 10, DarboInfo[jobID][arijungta]);
			cache_get_value_index(row, 11, DarboInfo[jobID][direktoriauszinute]);

			cache_get_value_index(row, 15, DarboInfo[jobID][Rangas1], 30);
			cache_get_value_index(row, 16, DarboInfo[jobID][Rangas2], 30);
			cache_get_value_index(row, 17, DarboInfo[jobID][Rangas3], 30);
			cache_get_value_index(row, 18, DarboInfo[jobID][Rangas4], 30);
			cache_get_value_index(row, 19, DarboInfo[jobID][Rangas5], 30);
			cache_get_value_index(row, 20, DarboInfo[jobID][Rangas6], 30);

			cache_get_value_index_int(row, 21, DarboInfo[jobID][Skin1_male]);
			cache_get_value_index_int(row, 22, DarboInfo[jobID][Skin2_male]);
			cache_get_value_index_int(row, 23, DarboInfo[jobID][Skin3_male]);
			cache_get_value_index_int(row, 24, DarboInfo[jobID][Skin4_male]);
			cache_get_value_index_int(row, 25, DarboInfo[jobID][Skin5_male]);
			cache_get_value_index_int(row, 26, DarboInfo[jobID][Skin6_male]);

			cache_get_value_index_int(row, 27, DarboInfo[jobID][Skin1_female]);
			cache_get_value_index_int(row, 28, DarboInfo[jobID][Skin2_female]);
			cache_get_value_index_int(row, 29, DarboInfo[jobID][Skin3_female]);
			cache_get_value_index_int(row, 30, DarboInfo[jobID][Skin4_female]);
			cache_get_value_index_int(row, 31, DarboInfo[jobID][Skin5_female]);
			cache_get_value_index_int(row, 32, DarboInfo[jobID][Skin6_female]);
		}

		cache_get_value_index_int(0, 4, MEDIKU_XP);
		cache_get_value_index_int(1, 4, POLICININKU_XP);
		cache_get_value_index_int(2, 4, ARMIJOS_XP);

		new isidarbinimai[100];
		format(isidarbinimai, sizeof(isidarbinimai), "{ff8c00}Medikai\n{ffffff}Reikalinga patirtis - {ff8c00}%s XP", konvertuoti_pinigus(MEDIKU_XP));

		pickups[0][medikuisidarbinimas]= CreateDynamicPickup(1314, 2, -201.8395,-1741.5638,675.7687);
    	darbulabel[MEDIKAI] = CreateDynamic3DTextLabel(isidarbinimai,-1, -201.8395,-1741.5638,675.7687,20);

    	format(isidarbinimai, sizeof(isidarbinimai), "{ff8c00}Policininkai\n{ffffff}Reikalinga patirtis - {ff8c00}%s XP", konvertuoti_pinigus(POLICININKU_XP));

		pickups[0][pdisidarbinimas]=CreateDynamicPickup(1314, 2, 236.3602,111.0627,1003.2188);
		darbulabel[POLICININKAI] = CreateDynamic3DTextLabel(isidarbinimai, -1,236.3602,111.0627,1003.2188,20);

		format(isidarbinimai, sizeof(isidarbinimai), "{ff8c00}Armija\n{ffffff}Reikalinga patirtis - {ff8c00}%s XP", konvertuoti_pinigus(ARMIJOS_XP));

		pickups[0][armijosisidarbinimas]=CreateDynamicPickup(1314, 2, -1521.5741,480.3042,7.1875);
		darbulabel[ARMIJA] = CreateDynamic3DTextLabel(isidarbinimai, -1, -1521.5741,480.3042,7.1875,20);

		mysql_format(connectionHandle, query, 140, "SELECT vardas, prizpareigosenuo, prizisp FROM dpriz");
		mysql_tquery(connectionHandle, query, "LoadDPRIZ", "");
	}
	return 1;
}

function LoadDPRIZ()
{
	if(cache_num_rows() > 0)
	{
		cache_get_value_name(0, "vardas", DPRIZINFO[prizvardas], 24);
		cache_get_value_name(0, "prizpareigosenuo", DPRIZINFO[prizpareigosenuo], 31);
		cache_get_value_index_int(0, 2, DPRIZINFO[prizisp]);

		mysql_format(connectionHandle, query, 140, "SELECT vardas, prizpareigosenuo, prizisp FROM vip_priz");
		mysql_tquery(connectionHandle, query, "LOAD_VIPPRIZ", "");
	}
	return 1;
}

function LOAD_VIPPRIZ()
{
	if(cache_num_rows() > 0)
	{
		cache_get_value_name(0, "vardas", VIPPRIZINFO[prizvardas], 24);
		cache_get_value_name(0, "prizpareigosenuo", VIPPRIZINFO[prizpareigosenuo], 31);
		cache_get_value_index_int(0, 2, VIPPRIZINFO[prizisp]);

		mysql_format(connectionHandle, query, 140, "SELECT vardas, prizpareigosenuo, prizisp FROM admin_priz");
		mysql_tquery(connectionHandle, query, "LOAD_ADMINPRIZ", "");
	}
	else print("Nepavyko u�krauti VIP pri� info");
	return 1;
}

function LOAD_ADMINPRIZ()
{
	if(cache_num_rows() > 0)
	{
		cache_get_value_name(0, "vardas", ADMINPRIZINFO[prizvardas], 24);
		cache_get_value_name(0, "prizpareigosenuo", ADMINPRIZINFO[prizpareigosenuo], 31);
		cache_get_value_index_int(0, 2, ADMINPRIZINFO[prizisp]);
	
		mysql_format(connectionHandle, query, 140, "SELECT vardas0, vardas1 FROM savininkai_list");
		mysql_tquery(connectionHandle, query, "LOAD_SAVININKAI", "");
	}
	else print("Nepavyko u�krauti admin pri� info");
	return 1;
}

function LOAD_SAVININKAI()
{
	if(cache_num_rows() > 0)
	{
		cache_get_value_name(0, "vardas0", SAVININKAI_INFO[sav_vardas0], 24);
		cache_get_value_name(0, "vardas1", SAVININKAI_INFO[sav_vardas1], 24);

		mysql_format(connectionHandle, query, 140, "SELECT vardas, prizpareigosenuo, prizisp FROM unban_priz");
		mysql_tquery(connectionHandle, query, "LOAD_UNBANPRIZ", "");
	}
	else print("Nepavyko u�krauti Savinink� info");
	return 1;
}

function LOAD_UNBANPRIZ()
{
	if(cache_num_rows() > 0)
	{
		cache_get_value_name(0, "vardas", UNBANPRIZ_INFO[prizvardas], 24);
		cache_get_value_name(0, "prizpareigosenuo", UNBANPRIZ_INFO[prizpareigosenuo], 31);
		cache_get_value_index_int(0, 2, UNBANPRIZ_INFO[prizisp]);
		//SendRconCommand("password 0");

		print("___________\n\nServerio krovimas baigtas\n\n___________");
	
		SendRconCommand("hostname LERG.LT | 0.3.7");
	}
	else print("Nepavyko u�krauti Unban Pri� info");
	return 1;
}

stock SendFormatForLaw(color, text[], va_args<>){

	new buffer[218];
	va_format(buffer, sizeof buffer, text, va_start<2>);
	return LawMessage(color, buffer);
}

IsNumeric(const string[])
{
    for (new i = 0, j = strlen(string); i < j; i++)
    {
        if (string[i] > '9' || string[i] < '0') return 0;
    }
    return 1;
}

stock SaugojamDarboPelnus()
{
	mysql_format(connectionHandle, query, 140, "UPDATE `darbai` SET pinigaifonde = '%i' WHERE jobID = '1'", DarboInfo[1][DarboFondas]); // medikai

	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 140, "UPDATE darbai SET pinigaifonde = '%i' WHERE jobID = '2'", DarboInfo[2][DarboFondas]); // pd

	mysql_tquery(connectionHandle, query, "SendQuery", "");
	return 1;
}

stock SaugojamDarba()
{
	mysql_format(connectionHandle, query, 400, "UPDATE darbai SET patirtis = '%i', pinigaifonde = '%i', dirba = '%i', nedirbsiki = '%i', dienosminimumasMIN = '%i', dienosminimumasPAGYD = '%i', arijungta = '%i', zinute = '%s' WHERE jobID = '1'", \
		MEDIKU_XP, DarboInfo[1][DarboFondas], DarboInfo[1][dirba], DarboInfo[1][nedirbsiki], DarboInfo[1][dienosminimumasMIN], DarboInfo[1][dienosminimumasPAGYD], DarboInfo[1][arijungta], DarboInfo[1][direktoriauszinute]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 400, "UPDATE darbai SET patirtis = '%i', pinigaifonde = '%i', dirba = '%i', nedirbsiki = '%i', dienosminimumasMIN = '%i', dienosminimumasBAUDOS = '%i', arijungta = '%i', zinute = '%s' WHERE jobID = '2'", \	
		POLICININKU_XP, DarboInfo[2][DarboFondas], DarboInfo[2][dirba], DarboInfo[2][nedirbsiki], DarboInfo[2][dienosminimumasMIN], DarboInfo[2][dienosminimumasBAUDOS], DarboInfo[2][arijungta], DarboInfo[2][direktoriauszinute]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 400, "UPDATE darbai SET patirtis = '%i', pinigaifonde = '%i', dirba = '%i', nedirbsiki = '%i', dienosminimumasMIN = '%i', dienosminimumasBAUDOS = '%i', arijungta = '%i', zinute = '%s' WHERE jobID = '3'", \
		ARMIJOS_XP, DarboInfo[3][DarboFondas], DarboInfo[3][dirba], DarboInfo[3][nedirbsiki], DarboInfo[3][dienosminimumasMIN], DarboInfo[3][dienosminimumasBAUDOS], DarboInfo[3][arijungta], DarboInfo[3][direktoriauszinute]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	for(new i = 1; i <= 3; i++)
	{
		mysql_format(connectionHandle, query, 400, "UPDATE darbai SET Rangas1 = '%s', Rangas2 = '%s', Rangas3 = '%s', Rangas4 = '%s', Rangas5 = '%s', Rangas6 = '%s' WHERE jobID = '%i'", \
			DarboInfo[i][Rangas1], DarboInfo[i][Rangas2], DarboInfo[i][Rangas3], DarboInfo[i][Rangas4], DarboInfo[i][Rangas5], DarboInfo[i][Rangas6], i);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 400, "UPDATE darbai SET Skin1_male = '%i', Skin2_male = '%i', Skin3_male = '%i', Skin4_male = '%i', Skin5_male = '%i', Skin6_male = '%i' WHERE jobID = '%i'", \
			DarboInfo[i][Skin1_male], DarboInfo[i][Skin2_male], DarboInfo[i][Skin3_male], DarboInfo[i][Skin4_male], DarboInfo[i][Skin5_male], DarboInfo[i][Skin6_male], i);
		mysql_tquery(connectionHandle, query, "SendQuery", "");

		mysql_format(connectionHandle, query, 400, "UPDATE darbai SET Skin1_female = '%i', Skin2_female = '%i', Skin3_female = '%i', Skin4_female = '%i', Skin5_female = '%i', Skin6_female = '%i' WHERE jobID = '%i'", \
			DarboInfo[i][Skin1_female], DarboInfo[i][Skin2_female], DarboInfo[i][Skin3_female], DarboInfo[i][Skin4_female], DarboInfo[i][Skin5_female], DarboInfo[i][Skin6_female], i);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	return 1;
}



stock LawMessage(color, text[]){
	foreach(new i : Player)
	{
		if(IsJobFromLaw(pInfo[i][darbas])){
			MSG(i, color, text);
		}
	}
	return 1;
}

stock SendFormat(playerid, color, text[], va_args<>)
{
    new buffer[218];
    va_format(buffer, sizeof buffer, text, va_start<3>);
    return MSG(playerid, color, buffer);
}
stock SendFormatToAll(color, text[], va_args<>)
{
	new buffer[400];
	va_format(buffer, sizeof buffer, text, va_start<2>);
	return SendClientMessageToAll(color, buffer);
}

stock SendFormatVip(color, text[], va_args<>)
{
	new buffer[218];
	va_format(buffer, sizeof buffer, text, va_start<2>);
	return ZinuteVip(color, buffer);
}

stock GetWorkersCount(darboID, bool:countdirector) // JimmyEXE
{
	new workerson;
	foreach(new i : Player)
	{
		if(pInfo[i][darbas] == darboID && pInfo[i][wUniform])
		{
			if(!IsPlayerInRangeOfPoint(i, 1.0, pInfo[i][AntiAFK][0], pInfo[i][AntiAFK][1], pInfo[i][AntiAFK][2]))
			{
				if(!countdirector)
				{
					if(pInfo[i][direktorius] == 0) workerson++;
				}
				else workerson++;
			}
		}
		return workerson;
	}
	return 1;
}

function ResetJobCar(playerid, vehid)
{	
	foreach(new i : Player)
	{
		if(!IsPlayerInVehicle(i, vehid))
		{
			SetVehicleToRespawn(vehid);
			GameTextForPlayer(playerid, "~y~Sunaikinote darbine masina", 2500, 5);
		}
	}
	return 1;
}

stock GetVehicleDriver(vehicleid)
{
	for(new i; i<MAX_PLAYERS; i++)
  	{
    	if(IsPlayerInVehicle(i, vehicleid))
    	{
	  		if(GetPlayerState(i) == 2)
	  		{
	  			return i;
	  		}
		}
  	}
  	return -1;
}

stock SendFormatSav(color, text[], va_args<>)
{
	new buffer[218];
	va_format(buffer, sizeof buffer, text, va_start<2>);
	return ZinuteSav(color, buffer);
}

stock ZinuteVip(color, text[])
{
	foreach(new i : Player)
	{
		if(online[i])
		{
			if(pInfo[i][VIP] == 1)
			{
				MSG(i,color,text);
			}
		}
	}
	return true;
}

stock ZinuteSav(color, text[])
{
	foreach(new i : Player)
	{
		if(online[i])
		{
			if(pInfo[i][ADMIN] == SAVININKAS)
			{
				MSG(i,color,text);
			}
		}
	}
	return true;
}

stock SendFormatAdmin(color, text[], va_args<>)
{
	new buffer[218];
	va_format(buffer, sizeof buffer, text, va_start<2>);
	return ZinuteAdmin(color, buffer);
}

stock ZinuteAdmin(color,text[])
{
	foreach(new i : Player)
	{
		if(online[i])
		{
			if(pInfo[i][ADMIN] > 0)
			{
				MSG(i,color,text);
			}
		}
	}
	return true;
}

stock konvertuoti_pinigus(pinigu_suma)
{
    new m_string[12];
    format(m_string, sizeof m_string, "%d", pinigu_suma);
    if(-1000 < pinigu_suma < 1000) return m_string;
    new _minusas = 0;
    if(pinigu_suma < 0) _minusas = 1;
    new m_ilgis = strlen(m_string);
    while((m_ilgis -= 3) > _minusas) strins(m_string, ".", m_ilgis);
    return m_string;
}

stock ShowInfo(playerid, pid)
{
	new adminlvl[50];
	if(pInfo[playerid][ADMIN] == 0) adminlvl = "n�ra";
	else if(pInfo[playerid][ADMIN] == 1) format(adminlvl, sizeof(adminlvl), "I lygio, galios %s", ConvertSeconds(pInfo[playerid][AdminLaikas] - gettime()));
	else if(pInfo[playerid][ADMIN] == 2) format(adminlvl, sizeof(adminlvl), "II lygio, galios %s", ConvertSeconds(pInfo[playerid][AdminLaikas] - gettime()));
	else if(pInfo[playerid][ADMIN] == 3) format(adminlvl, sizeof(adminlvl), "III lygio, galios %s", ConvertSeconds(pInfo[playerid][AdminLaikas] - gettime()));
	else if(pInfo[playerid][ADMIN] == 4) adminlvl = "Komandos narys";
	else if(pInfo[playerid][ADMIN] == 5) adminlvl = "Savininkas";
	
	new VIPAS[50];
	if(pInfo[playerid][VIP] == 0) VIPAS = "n�ra";
	else format(VIPAS, sizeof(VIPAS), "Yra, galios %s", ConvertSeconds(pInfo[playerid][VipLaikas] - gettime()));
	
	new playerLytis[14];
	if(pInfo[playerid][lytis] == 0) playerLytis = "Vyras";
	else if(pInfo[playerid][lytis] == 1) playerLytis = "Moteris";
	else playerLytis = "Nenustatyta";
	
	new isMuted[40];
	if(pInfo[playerid][Muted] > 0 && pInfo[playerid][permamute] == 0){format(isMuted, sizeof(isMuted),"Taip, dar %s",ConvertSeconds(pInfo[playerid][Muted] - gettime()));}
	else if(pInfo[playerid][Muted] == 0 && pInfo[playerid][permamute] == 0) isMuted = "Ne";
	
	if(pInfo[playerid][permamute] == 1){format(isMuted, sizeof(isMuted), "Taip, am�inai");}

	new Float:hp;
	GetPlayerHealth(playerid, hp);
	
	new Float:armour;
	GetPlayerArmour(playerid, armour);

	new workname[30];
	switch(pInfo[playerid][darbas])
	{
		case MEDIKAI:{workname = "Medikas";}
		case POLICININKAI:{workname = "Policijos pareig�nas";}
		case ARMIJA:{workname = "Kareivis";}
		case 0:{workname = "Bedarbis";}
	}

	new prizpav[40];
	if(pInfo[playerid][priziuretojas] == ADMINPRIZIURETOJAS) prizpav = "Administratori�";
	else if(pInfo[playerid][priziuretojas] == VIPPRIZIURETOJAS) prizpav = "V.I.P nari�";
	else if(pInfo[playerid][priziuretojas] == DPRIZIURETOJAS) prizpav = "Direktori�";
	else if(pInfo[playerid][priziuretojas] == UNBANPRIZIURETOJAS) prizpav = "UNBAN";
	else if(pInfo[playerid][priziuretojas] == 0) prizpav = "n�ra";

	new glicname[20];
	if(pInfo[playerid][glic] == 1) glicname = "turi";
	else glicname = "neturi";


	new sveikatpazname[50];
	if(pInfo[playerid][sveikatpaz] == true){format(sveikatpazname, sizeof(sveikatpazname), "Turi, galios dar %s"); ConvertSeconds(pInfo[playerid][sveikatpazlaikas] - gettime());}

	new str[1000], fstr[2000];

	format(str, sizeof(str), "{ffffff}Vardas: {1e90ff}%s\n{ffffff}Lytis: {1e90ff}%s\n{ffffff}Sveikata: {1e90ff}%s%%\n{ffffff}�arvai: {1e90ff}%s%%\n{ffffff}Pinigai rankose: {1e90ff}%s\n{ffffff}Darbas: {1e90ff}%i", \
		playerName[playerid], playerLytis, hp, armour, pInfo[playerid][pinigai], workname);

	strcat(fstr, str);

	format(str, sizeof(str), "\n{ffffff}Ie�komumas: {1e90ff}%i\n{ffffff}U�tildytas: {1e90ff}%s\n{ffffff}V.I.P: {1e90ff}%s\n{ffffff}Admin: {1e90ff}%s\n{ffffff}Pri�i�r�tojas: {1e90ff}%s", \
		GetPlayerWantedLevel(playerid), isMuted, VIPAS, adminlvl, prizpav);

	strcat(fstr, str);

	format(str, sizeof(str), "\n{ffffff}Sveikatos pa�yma: {1e90ff}%s\n{ffffff}Ginkl� licenzija: {1e90ff}%s", sveikatpazname, glicname);

	strcat(fstr, str);

	ShowPlayerDialog(pid, playerInfo, DIALOG_STYLE_MSGBOX, "�aid�jo informacija", fstr, "Supratau", "");
	return 1;
}

stock Blokuoti(playerid, type, reason[],adminID, duration)
{
	new banQuery[250];
	mysql_format(connectionHandle, banQuery, sizeof(banQuery), "INSERT INTO `banlist` (`ID`, `Vardas`, `reason`,`type`,`kasUzblokavo`,`likeslaikas`,`banDate`, `IP`) VALUES (NULL, '%e', '%s', '%i', '%s', '%i', '%s', '%s')",playerName[playerid], reason, type, playerName[adminID], duration, GautiData(0), IPAS[playerid]);
	mysql_tquery(connectionHandle, banQuery, "OnPlayerBanned", "iisii", playerid, type, reason, adminID, duration);
	return 1;
}

encode_tires(tires1, tires2, tires3, tires4) 
{
    return tires1 | (tires2 << 1) | (tires3 << 2) | (tires4 << 3);
}

stock CreateSpikes(playerid, Float:X, Float:Y, Float:Z, Float:R, VirtualW, Interior)
{
	new tmpObjectID = CreateDynamicObject(2899, X, Y, Z, 0, 0, R, VirtualW, Interior);
    SpygliaiInfo[playerid][SpygliaiX] = X;
    SpygliaiInfo[playerid][SpygliaiY] = Y;
    SpygliaiInfo[playerid][SpygliaiZ] = Z;
    SpygliaiInfo[playerid][arPadeti] = true;
    SpygliaiInfo[playerid][SpygliuObj] = tmpObjectID;
	new padejo[100];
	format(padejo, sizeof(padejo), "{C385E9}�{ffffff} Spyglius pad�jo {C385E9}%s", playerName[playerid]);
	SpygliaiInfo[playerid][SpygliuText] = Create3DTextLabel(padejo, -1, X, Y, Z+0.3, 10,0,0);
    return tmpObjectID;
}

stock IsJobFromLaw(jobid)
{
	switch(jobid)
	{
		case POLICININKAI: return POLICININKAI;
		case ARMIJA: return ARMIJA;
		default: return 0;
	}
	return 1;
}

stock IsJobWithInvite(jobid)
{
	switch(jobid)
	{
		case MEDIKAI: return MEDIKAI;
		case POLICININKAI: return POLICININKAI;
		case ARMIJA: return ARMIJA;
		default: return 0;
	}
	return 0;
}

stock IsAnyPlayerInVehicle(vehicleid)
{
	for(new p, size = GetPlayerPoolSize(); p <= size; p++)
	{	
		if(!IsPlayerConnected(p) || IsPlayerNPC(p)) continue;
		if(IsPlayerInVehicle(p, vehicleid)) return true;
	}
	return false;
}

stock DarbuZinute(color, darboid, text[])
{
	foreach(new i : Player)
	{
		if(pInfo[i][darbas] == darboid){MSG(i, color, text);}
	}
	return 1;
}

stock date( timestamp )
{
    /*
        ~ convert a Timestamp to a Date.
        ~ 10.07.2009

        date( 1247182451 )  will print >> 09.07.2009-23:34:11
        date( 1247182451, 1) will print >> 09/07/2009, 23:34:11
        date( 1247182451, 2) will print >> July 09, 2009, 23:34:11
        date( 1247182451, 3) will print >> 9 Jul 2009, 23:34
    */
    new year=1970, day=0, month=0, hour=0, mins=0, sec=0;

    new days_of_month[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };
    new returnstring[32];

    while(timestamp>31622400){
        timestamp -= 31536000;
        if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) timestamp -= 86400;
        year++;
    }

    if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )
        days_of_month[1] = 29;
    else
        days_of_month[1] = 28;


    while(timestamp>86400){
        timestamp -= 86400, day++;
        if(day==days_of_month[month]) day=0, month++;
    }

    while(timestamp>=60){
        timestamp -= 60, mins++;
        if( mins == 60) mins=0, hour++;
    }

    sec=timestamp;

	format(returnstring, 31, "%d-%02d-%02d %02d:%02d:%02d", year, month+1, day+1, hour, mins, sec);

    return returnstring;
}


stock formattext(divider, spacer[], text[])
{
    new returnstr[1028], lines, tmp[512];
    lines = floatround(strlen(text)/divider);
    for(new x = 0; x <= lines; x++)
    {
        strmid(tmp, text, x*divider, (x+1)*divider);
        if(x != lines) strcat(tmp, spacer); 
        format(returnstr, sizeof returnstr, "%s%s", returnstr, tmp);
    }
    return returnstr;
}

function OnPlayerBanned(playerid, type, reason[], adminID, duration)
{
	SendFormatToAll(-1, "{008b8b}[BAN] {3b878f}%s{008b8b} u�blokavo{3b878f} %s",playerName[adminID], playerName[playerid]);
	SendFormatToAll(-1, "{008b8b}� Prie�astis: {3b878f}[{008b8b}%s{3b878f}]", reason);

	MSG(adminID, RED, "Nepamir�kite u�pildyti u�blokavimo anketos forume: www.lerg.lt");
	MSG(adminID, RED, "D�l netinkamo u�blokavimo galite prarasti administratoriaus status�");

	MSG(playerid, RED, "Jeigu buvote neteisingai u�blokuotas pildykite atsiblokavimo anket� forume: www.lerg.lt");

	mysql_format(connectionHandle, query, 140, "UPDATE `zaidejai` SET ban_type = '%i', ban_time = '%i' WHERE vardas = '%e'", type, duration, playerid);
	mysql_tquery(connectionHandle, query, "SendQuery");

	_Kick(playerid);

	return true;
}

stock ClearChat(playerid, Eilutes)
{
	for(new i = 0; i != Eilutes; i ++) MSG(playerid, -1, " ");
}

function OnPlayerBanCheck(playerid)
{
	if(cache_num_rows() > 0)
	{
		// 1 VISAM | LAIKINAS 2 | IP BAN 3
		new reason[100], type, blokuotojas[24], likeslaikas;
		cache_get_value(0, "reason",reason);
		cache_get_value_int(0, "type", type);
		cache_get_value(0, "kasUzblokavo", blokuotojas);

		if(type == 1) // paprastas
		{
			new bandata[31];
			cache_get_value(0, "banDate", bandata);

			ClearChat(playerid, 3);
			MSG(playerid, RED, "- Esate u�blokuotas visam laikui!");

			SendFormat(playerid, RED, "� U�blokavo: %s", blokuotojas);

			SendFormat(playerid, RED, "� Prie�astis: %s", reason);

			SendFormat(playerid, RED, "� U�blokavimo data: %s", bandata);

			_Kick(playerid);
		}
		else if(type == 2) // laikinas
		{
			ClearChat(playerid, 3);
			cache_get_value_int(0, "likeslaikas", likeslaikas);
			
			if(likeslaikas <= gettime())
			{
				mysql_format(connectionHandle,query, 200, "DELETE FROM `banlist` WHERE `vardas` = '%e'", playerName[playerid]);
               	mysql_tquery(connectionHandle,query,"SendQuery","");
				MSG(playerid, RED, "- Junkit�s i� naujo j�s� u�blokavimas baig�si");
				_Kick(playerid);
			}

			MSG(playerid, RED, "- Esate laikinai u�blokuotas!");

			SendFormat(playerid, RED, "� U�blokavo: %s", blokuotojas);

			SendFormat(playerid, RED, "� Prie�astis: %s", reason);

			SendFormat(playerid, RED, "� U�blokavimas baigsis: %s", \
				ConvertSeconds(likeslaikas - gettime()));

			_Kick(playerid);
		}
		else if(type == 3) // ip
		{
			ClearChat(playerid, 3);
			MSG(playerid, RED, "- J�s� IP adresas u�blokuotas!");

			_Kick(playerid);
		}
	}
	else
	{
		Corrupt_Check[playerid]++;
		mysql_format(connectionHandle, query, 200, "SELECT * FROM zaidejai WHERE vardas = '%e'", playerName[playerid]);
		mysql_tquery(connectionHandle, query, "OnPlayerDataCheck", "ii", playerid, Corrupt_Check[playerid]);
	}
	return 1;
}

function Mute(playerid)
{
	if(pInfo[playerid][Muted] == 0 && pInfo[playerid][permamute] == 0)
	{
 		MSG(playerid,0x00CC00AA,"Kalbejimo u�draudimas pasibaige, galite kalbeti");
		KillTimer(MuteTime[playerid]);

		mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET adminmutename = '', mutelaikas = '0' WHERE vardas = '%e'", pInfo[playerid][KasUztilde], playerName[playerid]);
		mysql_tquery(connectionHandle, query, "SendQuery");

		return 1;
	}
	pInfo[playerid][Muted] -= 1;
	new msgs[90];

	if(pInfo[playerid][permamute] == 0 && pInfo[playerid][Muted] > 0)
	{
		format(msgs,sizeof(msgs),"U�tildytas: %s",ConvertSeconds(pInfo[playerid][Muted] - gettime()));
		SetPlayerChatBubble(playerid, msgs, 0xFF0000FF, 10.0, 2000);
	}
	else if(pInfo[playerid][permamute] == 1)
	{
		format(msgs,sizeof(msgs),"U�tildytas visam");
		SetPlayerChatBubble(playerid, msgs, 0xFF0000FF, 10.0, 2000);
	}
	return 1;
}

function SecondsTimer()
{
	chatClear++;
	if(chatClear == 15) // Kas 15 sec clearinamas chatas
	{
		foreach(new i : Player)
		{
			if(online[i])
			{
				MSG(i, -1, "");
			}
		}
		chatClear = 0;
	}
	new Metai,Menuo,Diena, h, m,s;
	gettime(h, m,s);
	getdate(Metai, Menuo, Diena);

	new LaikrodzioString[30];

	format(LaikrodzioString, 10, "%02d:%02d", h,m);
	TextDrawSetString(Laikrodis[0], LaikrodzioString);

	format(LaikrodzioString,30,"%d-%02d-%02d", Metai,Menuo,Diena);
	
	TextDrawSetString(SiandienosData[0], LaikrodzioString);

	foreach(new i : Player)
	{
		if(online[i])
		{
			if(GetPlayerMoney(i) != pInfo[i][pinigai])
			{
				ResetPlayerMoney(i);
				GivePlayerMoney(i, pInfo[i][pinigai]);
			}
			if(GetPlayerWantedLevel(i) != pInfo[i][gaudomumas])
			{
				SetPlayerWantedLevel(i, pInfo[i][gaudomumas]);
			}

			/*if(pInfo[i][LaikoLigoninej] > 0)
			{
				if(pInfo[i][LaikoLigoninej] == 1)
				{
					pInfo[i][LaikoLigoninej] = 0;
					GameTextForPlayer(i, "~g~JUS PALEISTAS IS LIGONINES", 3000, 5);

					SetPlayerPos(i, -2661.1096,631.1872,14.4531);
					SetPlayerFacingAngle(i, 175.0527);

					SetPlayerInterior(i, 0);
					SetPlayerVirtualWorld(i, 0);
				}
				else
				{
					pInfo[i][LaikoLigoninej] --;
					new string[15];
					format(string, 15, "~g~%.0d sec", pInfo[i][LaikoLigoninej]);
					GameTextForPlayer(i, string, 1000, 5);
				}
			}
			*/
		}
	}
	return 1;
}

function Game()
{
	new time[3];
	gettime(time[0], time[1], time[2]);
	SetWorldTime(time[0]);

	SaveTimer++;
	if(SaveTimer == 20)
	{
		SendFormatToAll(RED, "[INFO] Saugojame �aid�j� informacij�");
		foreach(new i : Player)
		{
			if(online[i])
			{
				_SAVE(i);
				SaveTimer = 0;
			}
		}
	}

	if(time[0] == 00 && time[1] == 00)
	{
		foreach(new i : Player)
		{
			if(pInfo[i][siandienpradirbo] < DarboInfo[pInfo[i][darbas]][dienosminimumasMIN])
			{
				switch(pInfo[i][darbas])
				{
					case MEDIKAI:
					{
						mysql_format(connectionHandle, query, 144, "INSERT INTO nepaememin (vardas, date, darbas, pradirbo, baudos, pagydymai) VALUES ('%s', '%s', '%i', '%i', '0', '%i')", playerName[i], GautiData(1), pInfo[i][darbas], pInfo[i][siandienpradirbo], pInfo[i][pagydymai]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
					case POLICININKAI..ARMIJA:
					{
						mysql_format(connectionHandle, query, 144, "INSERT INTO nepaememin (vardas, date, darbas, pradirbo, baudos) VALUES ('%s', '%s', '%i', '%i', '%s')", playerName[i], GautiData(1), pInfo[i][darbas], pInfo[i][siandienpradirbo], pInfo[i][baudos]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
				}
			}
		}
		mysql_format(connectionHandle, query, 144, "SELECT vardas, darbas, pagydymai, baudos, siandienpradirbo FROM zaidejai");
		mysql_tquery(connectionHandle, query, "Nepaememinimumo", "");
	}

	SaugojamDarboPelnus();
	SaugojamDarba();

	for(new p, size = GetPlayerPoolSize(); p <= size; p++)
	{
		if(time[0] == 00 && time[1] == 00)
		{
			pInfo[p][siandienprazaide] = 0;
			pInfo[p][siandienpradirbo] = 0;
		}
		if(online[p])
		{
			if(!IsPlayerInRangeOfPoint(p, 1.0, pInfo[p][AntiAFK][0], pInfo[p][AntiAFK][1], pInfo[p][AntiAFK][2]))
			{
				pInfo[p][siandienprazaide] ++;
				if(pInfo[p][wUniform] == 1) pInfo[p][siandienpradirbo] ++;

				if(pInfo[p][ADMIN] > 0 && pInfo[p][VIP] == 0) PlusPlayerScore(p, randomEx(6,8)); // JEI TIK ADMIN
				else if(pInfo[p][VIP] > 0 && pInfo[p][ADMIN] == 0) PlusPlayerScore(p, randomEx(3,5)); // JEI TIK VIP
				else if(pInfo[p][ADMIN] > 0 && pInfo[p][VIP] > 0) PlusPlayerScore(p, randomEx(6,8)); // JEI IR VIP IR ADMIN
				else if(pInfo[p][VIP] == 0 && pInfo[p][ADMIN] == 0) PlusPlayerScore(p, randomEx(1,3));// JEI NEI VIP NEI ADMIN
			}
			GetPlayerPos(p, pInfo[p][AntiAFK][0], pInfo[p][AntiAFK][1], pInfo[p][AntiAFK][2]);

			switch(pInfo[p][darbas])
			{
				case MEDIKAI:{pInfo[p][zaidejoMedikuXP] += randomEx(1, 5);}
				case POLICININKAI:{pInfo[p][zaidejoPolicijosXP] += randomEx(1, 5);}
				case ARMIJA:{pInfo[p][zaidejoArmijosXP] += randomEx(1, 5);}
			}
		}	
	}

	for(new i = 1; i < MAX_DARBU; i++)
	{
		switch(i)
		{
			case 1:
			{
				if(!DarboInfo[MEDIKAI][dirba])
				{
					if(gettime() >= DarboInfo[MEDIKAI][nedirbsiki])
					{
						DarboInfo[MEDIKAI][dirba] = true;
						DarboInfo[MEDIKAI][nedirbsiki] = 0;
						SendClientMessageToAll(-1, "{9FACF3}[INFO] {ffffff}Medik� darbo laikas v�l prasid�jo");
						mysql_format(connectionHandle, query, 140, "UPDATE `darbai` SET `dirba` = '1', `nedirbsiki` = '0' WHERE jobID = '1'");
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
				}
			}	
			case 2:
			{
				if(!DarboInfo[POLICININKAI][dirba])
				{
					if(gettime() >= DarboInfo[POLICININKAI][nedirbsiki])
					{
						DarboInfo[POLICININKAI][dirba] = true;
						DarboInfo[POLICININKAI][nedirbsiki] = 0;
						SendClientMessageToAll(-1, "{9FACF3}[INFO] {ffffff}Policijos departamento darbo laikas v�l prasid�jo");
						mysql_format(connectionHandle, query, 140, "UPDATE `darbai` SET `dirba` = '1', `nedirbsiki` = '0' WHERE jobID = '2'");
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
				}
			}
			case 3:
			{
				if(!DarboInfo[ARMIJA][dirba])
				{
					if(gettime() >= DarboInfo[ARMIJA][nedirbsiki])
					{
						DarboInfo[ARMIJA][dirba] = true;
						DarboInfo[ARMIJA][nedirbsiki] = 0;
						SendClientMessageToAll(-1, "{9FACF3}[INFO] {ffffff}Armijos darbo laikas v�l prasid�jo");
						mysql_format(connectionHandle, query, 140, "UPDATE `darbai` SET `dirba` = '1', `nedirbsiki` = '0' WHERE jobID = '3'");
						mysql_tquery(connectionHandle, query, "SendQuery", "");
					}
				}
			}
		}
	}
	return 1;
}

function AFK()
{
	for(new p = 0, size = GetPlayerPoolSize(); p <= size; p++)
	{
		if(IsPlayerConnected(p))
		{
			if(online[p])
			{
				if(pInfo[p][AFK_Stat] && pInfo[p][AFK_Label] == Text3D:INVALID_3DTEXT_ID)
				{
					pInfo[p][AFK_Label] = Create3DTextLabel("AFK", 0x66ff00FF, 0.0, 0.0, 0.0, 15.0, 0, 1);
					Attach3DTextLabelToPlayer(pInfo[p][AFK_Label], p, 0.0, 0.0, 0.5);
				}
			}
			pInfo[p][AFK_Stat] = true;
		}
	}
	return 1;
}


stock ConvertSeconds(sekundes) // by Johurt
{
	new str[37], msg[10], minutes, valandos, dienos;
 	while(sekundes > 59) { sekundes -= 60; minutes ++; }
  	while(minutes > 59) { minutes -= 60; valandos ++; }
   	while(valandos > 23) { valandos -= 24; dienos ++; }
   	if(dienos > 0) { format(msg, 7, "%dd. ", dienos); strcat(str, msg); }
    if(valandos > 0) { format(msg, 10, "%dval. ", valandos); strcat(str, msg); }
    if(minutes > 0) { format(msg, 10, "%dmin. ", minutes); strcat(str, msg); }
    if(sekundes > 0)
    {
    	if(minutes < 1 && valandos < 1 && dienos < 1)
     	{
      		str = "1min.";
        }
        else
        {
        	format(msg, 9, "%dsec.", sekundes);
         	strcat(str, msg);
        }
      }
	return str;
}


//

function OnPlayerJobXPLoad(playerid)
{
	if(cache_num_rows() > 0)
	{
		cache_get_value_index_int(0, 0, pInfo[playerid][zaidejoMedikuXP]);
		cache_get_value_index_int(0, 1, pInfo[playerid][zaidejoPolicijosXP]);
		cache_get_value_index_int(0, 2, pInfo[playerid][zaidejoArmijosXP]);
	}
	else
	{
		mysql_format(connectionHandle, query, 144, "INSERT INTO `darbaiSuPakvietimais_xp` (`Vardas`, `MedikoXP`, `PolicininkoXP`, `ArmijosXP`) VALUES ('%e', '%i', '%i', '%i')", \
		playerName[playerid], pInfo[playerid][zaidejoMedikuXP], pInfo[playerid][zaidejoPolicijosXP], pInfo[playerid][zaidejoArmijosXP]);
		mysql_tquery(connectionHandle, query, "SendQuery", "");
	}
	return 1;
}

function OnPlayerDataCheck(playerid, corrupt_check)
{
	if(corrupt_check != Corrupt_Check[playerid]) return Kick(playerid);

	if(cache_num_rows() > 0)
	{
		pInfo[playerid][Player_Cache] = cache_save();

		new confirmedemail, emailas[41];

		cache_get_value_int(0, "emailconfirmed", confirmedemail);
		cache_get_value(0, "email", emailas);

		if(isnull(emailas))
		{
			inline setupemail(pid, did, resp, litem, string:input[])
			{
				#pragma unused pid, did, litem
				if(resp)
				{
					if(IsValidEmail(input))
					{
						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET email = '%s' WHERE vardas = '%e'", input, playerName[playerid]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");

						new emailstring[13];
						randomString(emailstring, 12);

						SendEmail("LERG.LT Patvirtinimo kodas", input, "LERG.LT patvirtinimo kodas", emailstring);

						inline confemail(pid1, did1, resp1, litem1, string:input1[])
						{
							#pragma unused pid1, did1, litem1
							if(resp1)
							{
								if(strcmp(input1, emailstring, true) == 0 && !isnull(input1))
								{
									mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET emailconfirmed = '1' WHERE vardas = '%e'", playerName[playerid]);
									mysql_tquery(connectionHandle, query, "SendQuery", "");

									inline login(pid2, did2, resp2, litem2, string:input2[])
									{
										#pragma unused pid2, did2, litem2
										if(resp2)
										{
											mysql_format(connectionHandle, query, 140, "SELECT skin, x, y, z, facing FROM zaidejai WHERE vardas = '%e' AND slaptazodis = MD5('%s') LIMIT 1;", playerName[playerid], input2);
											mysql_tquery(connectionHandle, query, "OnPlayerTryingLogin", "di", playerid, 0);
										}
										else return Kick(playerid);
									}
									Dialog_ShowCallback(playerid, using inline login, DIALOG_STYLE_PASSWORD, "{ffffff}Prisijungimas", "{3299DF}-{ffffff} Nor�dami{3299DF} prisijungti{ffffff} �veskite slapta�od�:", "Prisijungti", "I�eiti");
								}
								else
								{
									MSG(playerid, -1, "{CC0000}-{ffffff} �vestas {CC0000}kodas {ffffff}neatitinka atsi�sto {CC0000}kodo{ffffff}!");
									Dialog_ShowCallback(playerid, using inline confemail, DIALOG_STYLE_INPUT, "{ffffff}El. pa�to patvirtinimas", "{CC0000}-{ffffff} �vestas {CC0000}kodas {ffffff}neatitinka atsi�sto {CC0000}kodo{ffffff}!\n\n{3299DF}-{ffffff} �veskite � {3299DF}el. pa�t�{ffffff} atsi�st�{3299DF} patvirtinimo{ffffff} kod�:", "Toliau", "I�eiti");
								}
							}
							else return Kick(playerid);
						}
						Dialog_ShowCallback(playerid, using inline confemail, DIALOG_STYLE_INPUT, "{ffffff}El. pa�to patvirtinimas", "{3299DF}-{ffffff} �veskite � {3299DF}el. pa�t�{ffffff} atsi�st�{3299DF} patvirtinimo{ffffff} kod�:", "Toliau", "I�eiti");
					}
					else
					{
						MSG(playerid, -1, "{CC0000}-{ffffff} �vestas el. pa�to {CC0000}adresas{ffffff} neatitinka {CC0000}reikalavim�{ffffff}!");
						Dialog_ShowCallback(playerid, using inline setupemail, DIALOG_STYLE_INPUT, "{ffffff}El. pa�to nustatymas", "{CC0000}-{ffffff} �vestas el. pa�to {CC0000}adresas{ffffff} neatitinka {CC0000}reikalavim�{ffffff}!\n\n{3299DF}�veskite{ffffff} el. pa�to adres�:", "Toliau", "I�eiti");
					}
				}
				else return Kick(playerid);
			}
			Dialog_ShowCallback(playerid, using inline setupemail, DIALOG_STYLE_INPUT, "{ffffff}El. pa�to nustatymas", "{CC0000}-{ffffff} Sveiki, registruodamiesi ne�ved�te {3299DF}el. pa�to{ffffff} adreso\n\n{3299DF}�veskite{ffffff} el. pa�to adres�:", "Toliau", "I�eiti");
		}
		else if(confirmedemail == 0)
		{
			new emailstring[13];
			randomString(emailstring, 12);
			printf("%s", emailstring);

			inline emailconf(pid, did, resp, litem, string:input[])
			{
				#pragma unused pid, did, litem
				if(resp)
				{
					if(strcmp(input, emailstring, true) == 0 && !isnull(input))
					{
						mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET emailconfirmed = '1' WHERE vardas = '%e'", playerName[playerid]);
						mysql_tquery(connectionHandle, query, "SendQuery", "");

						inline login(pid1, did1, resp1, litem1, string:input1[])
						{
							#pragma unused pid1, did1, litem1, input1
							if(resp1)
							{
								mysql_format(connectionHandle, query, 140, "SELECT skin, x, y, z, facing FROM zaidejai WHERE vardas = '%e' AND slaptazodis = MD5('%s') LIMIT 1;", playerName[playerid], input1);
								mysql_tquery(connectionHandle, query, "OnPlayerTryingLogin", "di", playerid, 0);
							}
							else return Kick(playerid);
						}
						Dialog_ShowCallback(playerid, using inline login, DIALOG_STYLE_PASSWORD, "{ffffff}Prisijungimas", "{3299DF}-{ffffff} Nor�dami{3299DF} prisijungti{ffffff} �veskite slapta�od�:", "Prisijungti", "I�eiti");
					}
					else
					{
						MSG(playerid, -1, "{CC0000}-{ffffff} �vestas {CC0000}patvirtinimo{ffffff} kodas neatitinka atsi�sto {CC0000}kodo{ffffff}!");
						Dialog_ShowCallback(playerid, using inline emailconf, DIALOG_STYLE_INPUT, "{ffffff}El. pa�to patvirtinimas", "{CC0000}-{ffffff} �vestas {CC0000}patvirtinimo{ffffff} kodas neatitinka atsi�sto {CC0000}kodo{ffffff}!\n\n{3299DF} �veskite{ffffff} � {3299DF}el. pa�t�{ffffff} atsi�st�{3299DF} patvirtinimo{ffffff} kod�:", "Toliau", "I�eiti");
					}
				}
				else return Kick(playerid);
			}
			Dialog_ShowCallback(playerid, using inline emailconf, DIALOG_STYLE_INPUT, "{ffffff}El. pa�to patvirtinimas", "{CC0000}-{ffffff} Sveiki, registruodamiesi {CC0000}ne�ved�te{ffffff} patvirtinimo kodo\n\n{3299DF} �veskite{ffffff} � {3299DF}el. pa�t�{ffffff} atsi�st�{3299DF} patvirtinimo{ffffff} kod�:", "Toliau", "I�eiti");
		}
		else
		{
			inline login(pid, did, resp, litem, string:input[])
			{
				#pragma unused pid, did, litem
				if(resp)
				{
					mysql_format(connectionHandle, query, 140, "SELECT skin, x, y, z, facing FROM zaidejai WHERE vardas = '%e' AND slaptazodis = MD5('%s') LIMIT 1;", playerName[playerid], input);
					mysql_tquery(connectionHandle, query, "OnPlayerTryingLogin", "di", playerid, 0);
				}
				else return Kick(playerid);
			}
			Dialog_ShowCallback(playerid, using inline login, DIALOG_STYLE_PASSWORD, "{ffffff}Prisijungimas", "{3299DF}-{ffffff} Nor�dami{3299DF} prisijungti{ffffff} �veskite slapta�od�:", "Prisijungti", "I�eiti");
		}
	}
	else
	{
		new registertext[200];
		inline registracija(pid, did, resp, litem, input[])
		{
			#pragma unused pid, did, litem
			if(resp)
			{
				if(CheckAllowedChar(input))
				{
					if(strlen(input) > 40 || strlen(input) < 4)
					{
						MSG(playerid, -1, "{CC0000}[LERG.LT]: {ffffff}J�s� sugalvotas slapta�odis yra {CC0000}trumpesnis nei 4 simboli�, arba ilgesnis nei 20 simboli�");
						Dialog_ShowCallback(playerid, using inline registracija, DIALOG_STYLE_PASSWORD, "{ffffff}Registracija", "{CC0000}- {ffffff}Per {CC0000}ilgas{ffffff} arba per {CC0000}trumpas{ffffff} slapta�odis\n\nNor�dami {3299DF}u�siregistruoti{ffffff} - �veskite sugalvot� {3299DF}slapta�od�{ffffff} [{3299DF}4-40simb{ffffff}]:", "Toliau", "I�eiti");
					}
					else
					{
						inline gender(pid1, did1, resp1, litem1, input1[])
						{
							#pragma unused pid1, did1, input1, litem1
							if(resp1) pInfo[playerid][lytis] = 0; // vyras
 							else pInfo[playerid][lytis] = 1; // moteris

							mysql_format(connectionHandle, query, 200, "INSERT INTO `zaidejai` (`vardas`, `slaptazodis`, `pinigai`, `patirtis`, `regdate`, `gender`) \
								VALUES ('%s', MD5('%s'), '5000', '5000', '%s', '%i')", playerName[playerid], input, GautiData(0), strval(pInfo[playerid][lytis]));

							mysql_tquery(connectionHandle, query, "SendQuery", "");

							inline emailsetup(pid2, did2, resp2, litem2, input2[])
							{
								#pragma unused pid2, did2, litem2
								if(resp2)
								{
									if(IsValidEmail(input2))
									{
										mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET email = '%s' WHERE vardas = '%e'", input2, playerName[playerid]);
										mysql_tquery(connectionHandle, query, "SendQuery");

										new emailstring[13];
										randomString(emailstring, 12);

										SendEmail("LERG.LT Patvirtinimo kodas", input2, "LERG.LT patvirtinimo kodas", emailstring);


										inline emailconfirm(pid3, did3, resp3, litem3, input3[])
										{
											#pragma unused pid3, did3, litem3
											if(resp3)
											{
												if(strcmp(input3, emailstring, true) == 0 && !isnull(input3))
												{
													mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET emailconfirmed = 1 WHERE vardas = '%e'", playerName[playerid]);
													mysql_tquery(connectionHandle, query, "SendQuery", "");

													OnPlayerRegister(playerid);
												}
												else
												{
													MSG(playerid, -1, "{CC0000}- {ffffff}�vestas {CC0000}netinkamas{ffffff} el. pa�to {CC0000}patvirtinimo{ffffff} kodas!");
													Dialog_ShowCallback(playerid, using inline emailconfirm, DIALOG_STYLE_INPUT, "{ffffff}El. pa�to patvirtinimas", "{CC0000}-{ffffff} �vestas patvirtinimo kodas {CC0000}netinkamas{ffffff}\n{3299DF}�veskite{ffffff} el. pa�tu atsi�st� {3299DF}patvirtinimo {ffffff} kod�:", "Toliau", "I�eiti");
												}
											}
											else
											{
												mysql_format(connectionHandle, query, 140, "UPDATE `zaidejai` SET `emailconfirmed` = '0' WHERE `vardas` = '%e'", playerName[playerid]);
												mysql_tquery(connectionHandle, query, "SendQuery", "");
												Kick(playerid);
											}
										}
										Dialog_ShowCallback(playerid, using inline emailconfirm, DIALOG_STYLE_INPUT, "{ffffff}El. pa�to patvirtinimas", "{3299DF}-{ffffff} �veskite el. pa�tu atsi�st� {3299DF}patvirtinimo{ffffff} kod�:", "Toliau", "I�eiti");
									}
									else
									{
										MSG(playerid, -1, "{CC0000}- {ffffff}�vestas {CC0000}el. pa�tas{ffffff} neatitinka reikalavim�!");
										Dialog_ShowCallback(playerid, using inline emailsetup, DIALOG_STYLE_INPUT, "{ffffff}El. pa�to patvirtinimas", "{CC0000}-{ffffff} �vestas el. pa�tas {ffffff}neatitinka{ffffff} reikalavim�\n{3299DF}�veskite {ffffff}savo el. pa�to adres�, nor�dami {3299DF}patvirtinti{ffffff} paskyr�", "Toliau", "I�eiti");
									}
								}
								else
								{
									mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET emailconfirmed = 0, email = '' WHERE vardas = '%e'", playerName[playerid]);
									mysql_tquery(connectionHandle, query, "SendQuery", "");
									Kick(playerid);
								}
							}
							Dialog_ShowCallback(playerid, using inline emailsetup, DIALOG_STYLE_INPUT, "{ffffff}El. pa�to patvirtinimas", "{3299DF}�veskite{ffffff} savo el. pa�to{3299DF} adres�{ffffff}, nor�dami {3299DF}patvirtinti {ffffff}paskyr�:", "Toliau", "I�eiti");

						}
						Dialog_ShowCallback(playerid, using inline gender, DIALOG_STYLE_MSGBOX, "{ffffff}Lyties pasirinkimas", "{3299DF}- {ffffff}Pasirinkite {3299DF}lyt�:", "Vyras", "Moteris");
					}
				}
				else
				{
					MSG(playerid, -1, "{CC0000}- {ffffff}J�s� sugalvot� {CC0000}slapta�od�{ffffff} gali {CC0000}sudaryti{ffffff} tik {CC0000}raid�s{ffffff} ir {CC0000}skai�iai");
					Dialog_ShowCallback(playerid, using inline registracija, DIALOG_STYLE_PASSWORD, "{ffffff}Registracija", "{3299DF}-{ffffff} J�s� sugalvot� slapta�od� gali {3299DF}sudaryti{ffffff} tik raid�s ir skai�iai\n\n{ffffff}Nor�dami {3299DF}u�siregistruoti{ffffff} - �veskite sugalvot� {3299DF}slapta�od�{ffffff} [{3299DF}6-20simb{ffffff}]:", "Toliau", "I�eiti");
				}
			}
			else return Kick(playerid);
		}
		format(registertext, sizeof(registertext), "{3299DF}%s{ffffff}, sveiki atvyk� � {3299DF}LERG.LT{ffffff}\n\n Nor�dami {3299DF}u�siregistruoti{ffffff} - �veskite sugalvot� {3299DF}slapta�od�{ffffff} [{3299DF}4 - 40simb{ffffff}]:", playerName[playerid]);
		Dialog_ShowCallback(playerid, using inline registracija, DIALOG_STYLE_PASSWORD, "{FFFFFF}Registracija", registertext, "Toliau", "I�eiti");
	}
	return 1;
}

function OnPlayerTryingLogin(playerid, attempts)
{
	if(cache_num_rows() > 0)
	{
		online[playerid] = true;
		poPrisijungimo[playerid] = true;
		MSG(playerid, GREEN, "+ S�kmingai prisijung�te prie paskyros!");

		new Float:cords[4];

		cache_get_value_index_int(0, 0, pInfo[playerid][skin]);

		cache_get_value_index_float(0, 1, cords[0]);

		cache_get_value_index_float(0, 2, cords[1]);

		cache_get_value_index_float(0, 3, cords[2]);

		cache_get_value_index_float(0, 4, cords[3]);
		TogglePlayerSpectating(playerid, false);
		SetSpawnInfo(playerid, NO_TEAM, pInfo[playerid][skin], cords[0], cords[1], cords[2] + 0.75, cords[3], 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
	}
	else
	{
		MSG(playerid, -1, "{CC0000}[LERG.LT]:{ffffff} Neteisingas {CC0000}slapta�odis{ffffff}!");
		inline login(pid, did, resp, litem, string:input[])
		{
			#pragma unused pid, did, litem
			if(resp)
			{
				mysql_format(connectionHandle, query, 140, "SELECT skin, x, y, z, facing FROM zaidejai WHERE vardas = '%e' AND slaptazodis = MD5('%s') LIMIT 1;", playerName[playerid], input);
				mysql_tquery(connectionHandle, query, "OnPlayerTryingLogin", "di", playerid, 0);
			}
			else return Kick(playerid);
		}
		Dialog_ShowCallback(playerid, using inline login, DIALOG_STYLE_PASSWORD, "{ffffff}Prisijungimas", "{3299DF}-{ffffff} Nor�dami{3299DF} prisijungti{ffffff} �veskite slapta�od�:", "Prisijungti", "I�eiti");
	}
	return 1;
}

function _LOAD(playerid)
{
	ControlPlayerInTime(playerid, 2000, true);
	GameTextForPlayer(playerid, "~g~KRAUNAMA", 2500, 5);
	cache_set_active(pInfo[playerid][Player_Cache]);

	cache_get_value_int(0, "pinigai", pInfo[playerid][pinigai]);
	GivePlayerMoney(playerid, pInfo[playerid][pinigai]);

	cache_get_value_int(0, "patirtis", pInfo[playerid][patirtis]);
	SetPlayerScore(playerid, pInfo[playerid][patirtis]);

	new Float:HP, Float:Armour;

	cache_get_value_float(0, "hp", HP);
	cache_get_value_float(0, "armour", Armour);

	SetPlayerHealth(playerid, HP);
	SetPlayerArmour(playerid, Armour);

    cache_get_value_int(0, "skin", pInfo[playerid][skin]);
 	cache_get_value_int(0, "gender", pInfo[playerid][lytis]);

	cache_get_value_int(0, "admin", pInfo[playerid][ADMIN]);
	cache_get_value_int(0, "AdminLaikas", pInfo[playerid][AdminLaikas]);
	
	cache_get_value_int(0, "vip", pInfo[playerid][VIP]);
	cache_get_value_int(0, "VipLaikas", pInfo[playerid][VipLaikas]);
	
	new weapon,ammo;

	cache_get_value_int(0, "Ginklas0", weapon);
	cache_get_value_int(0, "Ammo0", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	cache_get_value_int(0, "Ginklas1", weapon);
	cache_get_value_int(0, "Ammo1", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	cache_get_value_int(0, "Ginklas2", weapon);
	cache_get_value_int(0, "Ammo2", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	cache_get_value_int(0, "Ginklas3", weapon);
	cache_get_value_int(0, "Ammo3", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	cache_get_value_int(0, "Ginklas4", weapon);
	cache_get_value_int(0, "Ammo4", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	cache_get_value_int(0, "Ginklas5", weapon);
	cache_get_value_int(0, "Ammo5", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	cache_get_value_int(0, "Ginklas6", weapon);
	cache_get_value_int(0, "Ammo6", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	cache_get_value_int(0, "Ginklas7", weapon);
	cache_get_value_int(0, "Ammo7", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	cache_get_value_int(0, "Ginklas8", weapon);
	cache_get_value_int(0, "Ammo8", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	cache_get_value_int(0, "Ginklas9", weapon);
	cache_get_value_int(0, "Ammo9", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	cache_get_value_int(0, "Ginklas10", weapon);
	cache_get_value_int(0, "Ammo10", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	cache_get_value_int(0, "Ginklas11", weapon);
	cache_get_value_int(0, "Ammo11", ammo);
	GivePlayerWeapon(playerid, weapon, ammo);

	new interior;
	cache_get_value_int(0, "Interior", interior);

	SetPlayerInterior(playerid, interior);

    SetPlayerSkin(playerid, pInfo[playerid][skin]);
    
    cache_get_value_name(0, "lastloginIP", pInfo[playerid][lastloginIP], 16);
	cache_get_value_name(0, "lastloginDATE", pInfo[playerid][lastloginDATE], 31);

	cache_get_value_int(0, "darbas", pInfo[playerid][darbas]);

	cache_get_value_int(0, "uniforma", pInfo[playerid][uniforma]);

	cache_get_value_int(0, "wUniform",pInfo[playerid][wUniform]);

	cache_get_value_int(0, "wantedlevel", pInfo[playerid][gaudomumas]);

	cache_get_value_int(0, "glic", pInfo[playerid][glic]);

	cache_get_value_int(0, "direktorius", pInfo[playerid][direktorius]);

	cache_get_value_int(0, "gender", pInfo[playerid][lytis]);

	cache_get_value_int(0, "visp", pInfo[playerid][visp]);

	cache_get_value_int(0, "aisp", pInfo[playerid][aisp]);

	cache_get_value_int(0, "disp", pInfo[playerid][disp]);

	cache_get_value_name(0, "isidarbino", pInfo[playerid][workingSince], 31);

	cache_get_value_name(0, "drkpareigosenuo", pInfo[playerid][direkopareigosenuo]);

	cache_get_value_int(0, "priziuretojas", pInfo[playerid][priziuretojas]);

	cache_get_value_int(0, "laikoligonineje", pInfo[playerid][LaikoLigoninej]);
	
	cache_get_value_bool(0, "sveikatospazyma", pInfo[playerid][sveikatpaz]);

	cache_get_value_int(0, "sveikatospazymoslaikas", pInfo[playerid][sveikatpazlaikas]);

	cache_get_value_int(0, "direktoriaus_ispejimai", pInfo[playerid][drkisp]);

	cache_get_value_int(0, "perma_mute", pInfo[playerid][permamute]);

    cache_get_value_int(0, "mutelaikas", pInfo[playerid][Muted]);

	cache_get_value_int(0, "prizisp", pInfo[playerid][priziuretojausisp]);

	cache_get_value_name(0, "prizpareigosenuo", pInfo[playerid][prizpareigosenuo], 31);

	cache_get_value_int(0, "Rangas", pInfo[playerid][DarboRangas]);

	cache_get_value_name(0, "adminmutename", pInfo[playerid][KasUztilde], 24);

    if(pInfo[playerid][Muted] > 0 || pInfo[playerid][permamute] == 1) MuteTime[playerid] = SetTimerEx("Mute", 1000, true, "i",playerid);

	if(pInfo[playerid][wUniform] > 0)
	{
		SetPlayerSkin(playerid, pInfo[playerid][uniforma]);
	}
	else
	{
		SetPlayerSkin(playerid, pInfo[playerid][skin]);
	}

	if(pInfo[playerid][ADMIN] > 0 && gettime() >= pInfo[playerid][AdminLaikas] && pInfo[playerid][ADMIN] != SAVININKAS)
	{
		if(pInfo[playerid][ADMIN] != KOMANDOSNARIAI)
		{
			pInfo[playerid][ADMIN] = 0;
			pInfo[playerid][AdminLaikas] = 0;
			MSG(playerid, 0xFF0000AA, "- J�s� �Administratorius� paslaugos 30 D. galiojimo laikas baig�si. Galite �sigyti i� naujo /paslaugos");
		}
	}

	if(pInfo[playerid][VIP] == 1 && gettime() >= pInfo[playerid][VipLaikas] && pInfo[playerid][ADMIN] != SAVININKAS)
	{
		if(pInfo[playerid][ADMIN] != KOMANDOSNARIAI)
		{
			pInfo[playerid][VIP] = 0;
			pInfo[playerid][VipLaikas] = 0;
			MSG(playerid, 0xFF0000AA, "- J�s� �VIP� paslaugos 30 D. galiojimo laikas baig�si. Galite �sigyti i� naujo /paslaugos");
		}
	}

	switch(pInfo[playerid][ADMIN])
	{
		case ILVLADMIN..KOMANDOSNARIAI: 
		{
			SetPlayerColor(playerid, ADMIN_COLOR);
			SendFormatToAll(-1, "{05c54e}Administratorius {67ab04}%s {05c54e}prisijung�!", playerName[playerid]);
		}
		case SAVININKAS:
		{	
			SetPlayerColor(playerid, OWNER_COLOR);
			SendFormatToAll(-1, "{3abeff}Savininkas {6699ff}%s {3abeff}prisijung�!", playerName[playerid]);
		}
		default: SetPlayerColor(playerid, DEFAULT_COLOR);
	}

	cache_get_value_name(0, "lastloginIP", pInfo[playerid][lastloginIP], 16);

	cache_get_value_name(0, "lastloginDATE", pInfo[playerid][lastloginDATE], 31);

	if(!isnull(pInfo[playerid][lastloginIP]) || !isnull(pInfo[playerid][lastloginDATE])) SendFormat(playerid, -1, "{EE870B}� {ffffff}Paskutin� kart� {EE870B}prisijung�s{ffffff} buvote {EE870B}%s{ffffff} i� {EE870B}%s{ffffff} IP adreso", pInfo[playerid][lastloginDATE], pInfo[playerid][lastloginIP]);

	printf("Pakrautas �aid�jas %s - [%d ms]", playerName[playerid], cache_get_query_exec_time(MILLISECONDS));
	
	cache_delete(pInfo[playerid][Player_Cache]);
	pInfo[playerid][Player_Cache] = MYSQL_INVALID_CACHE;
}

function Galiojimas(playerid)
{
	if(online[playerid])
	{
		new string[250];
		if(!IsPlayerInRangeOfPoint(playerid, 1.0, pInfo[playerid][AntiAFK][0], pInfo[playerid][AntiAFK][1], pInfo[playerid][AntiAFK][2]))
		{
			if(pInfo[playerid][ADMIN] == 1 && gettime() >= pInfo[playerid][AdminLaikas] && pInfo[playerid][ADMIN] != SAVININKAS)
			{
				pInfo[playerid][VIP] = 0;
				pInfo[playerid][VipLaikas] = 0;
				format(string, sizeof(string), "{ffffff}�aid�jau {F0E678}%s{ffffff},\n\nJ�s� {F0E678}VIP {ffffff}galiojimo laikas baig�si\nJeigu norite {F0E678}prasit�sti{ffffff} galiojim� ra�ykite {F0E678}/paslaugos",playerName[playerid]);
				ShowPlayerDialog(playerid, vipgaliojimas, DIALOG_STYLE_MSGBOX, "Pasibaig�s galiojimas", string, "Supratau", "");
				SetPlayerColor(playerid, DEFAULT_COLOR);
			}
			if(pInfo[playerid][ADMIN] == 1 && gettime() >= pInfo[playerid][AdminLaikas] && pInfo[playerid][ADMIN] != SAVININKAS)
			{
				pInfo[playerid][ADMIN] = 0;
				pInfo[playerid][AdminLaikas] = 0;
				format(string, sizeof(string), "{ffffff}�aid�jau {F0E678}%s{ffffff},\n\nJ�s� {F0E678}Administratoriaus {ffffff}galiojimo laikas baig�si\nJeigu norite {F0E678}prasit�sti{ffffff} galiojim� ra�ykite {F0E678}/paslaugos",playerName[playerid]);
				ShowPlayerDialog(playerid, admingaliojimas, DIALOG_STYLE_MSGBOX, "Pasibaig�s galiojimas", string, "Supratau", "");
				SetPlayerColor(playerid, DEFAULT_COLOR);
			}
			if(pInfo[playerid][sveikatpaz] && gettime() >= pInfo[playerid][sveikatpazlaikas] && pInfo[playerid][ADMIN] != SAVININKAS)
			{
				pInfo[playerid][sveikatpaz] = false;
				pInfo[playerid][sveikatpazlaikas] = 0;
				MSG(playerid, RED, "- J�s� sveikatos pa�ymos laikas pasibaig�!");
			}
			if(pInfo[playerid][Invited] > 0 && gettime() >= pInfo[playerid][pakvietimastimer])
			{
				pInfo[playerid][Invited] = 0;
				pInfo[playerid][pakvietimastimer] = 0;
			}
		}
	}
	return 1;
}

function _SAVE(playerid)
{
	new Float:cords[4], weps[2][12], Float:HP, Float:Armour;

	GetPlayerPos(playerid, cords[0], cords[1], cords[2]);
	GetPlayerFacingAngle(playerid, cords[3]);

	GetPlayerHealth(playerid, HP);
	GetPlayerArmour(playerid, Armour);

	mysql_format(connectionHandle, query, 300, "UPDATE `zaidejai` SET `pinigai` = '%i', `patirtis` = '%i', `x` = '%f', `y` = '%f', `z` = '%f', `facing` = '%f', `hp` = '%f', `armour` = '%f', `admin` = '%i', `AdminLaikas` = '%i', `mutelaikas` = '%i' WHERE `vardas` = '%e' LIMIT 1;", \
		pInfo[playerid][pinigai], GetPlayerScore(playerid), cords[0], cords[1], cords[2], cords[3], HP, Armour, pInfo[playerid][ADMIN], pInfo[playerid][AdminLaikas], pInfo[playerid][Muted], playerName[playerid]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

    for (new tmp=0; tmp<12; tmp++) GetPlayerWeaponData(playerid,tmp,weps[0][tmp],weps[1][tmp]);
	
	mysql_format(connectionHandle, query, 300, "UPDATE `zaidejai` SET `Ginklas0` = '%d', `Ginklas1` = '%d', `Ginklas2` = '%d', `Ginklas3` = '%d', `Ginklas4` = '%d', `Ginklas5` = '%d', `Ginklas6` = '%d', `Ginklas7` = '%d', `Ginklas8` = '%d', `Ginklas9` = '%d', `Ginklas10` = '%d', `Ginklas11` = '%d' WHERE `vardas` = '%e' LIMIT 1;", \
		weps[0][0],weps[0][1],weps[0][2],weps[0][3],weps[0][4],weps[0][5],weps[0][6],weps[0][7],weps[0][8],weps[0][9],weps[0][10],weps[0][11],playerName[playerid]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 300, "UPDATE `zaidejai` SET `Ammo0` = '%d', `Ammo1` = '%d', `Ammo2` = '%d', `Ammo3` = '%d', `Ammo4` = '%d', `Ammo5` = '%d', `Ammo6` = '%d', `Ammo7` = '%d', `Ammo8` = '%d', `Ammo9` = '%d', `Ammo10` = '%d', `Ammo11` = '%d', `Interior` = '%i' WHERE `vardas` = '%e' LIMIT 1;", \
		weps[1][0],weps[1][1],weps[1][2],weps[1][3],weps[1][4], weps[1][5],weps[1][6],weps[1][7],weps[1][8],weps[1][9], weps[1][10],weps[1][11],GetPlayerInterior(playerid),playerName[playerid]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 300, "UPDATE `zaidejai` SET `vip` = '%i', `VipLaikas` = '%i', `darbas` = '%i', `isidarbino` = '%s', `direktorius` = '%i' WHERE `vardas` = '%e' LIMIT 1;", \
		pInfo[playerid][VIP], pInfo[playerid][VipLaikas], pInfo[playerid][darbas], pInfo[playerid][workingSince], pInfo[playerid][direktorius],playerName[playerid]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 300, "UPDATE `zaidejai` SET `uniforma` = '%i', `wUniform` = '%i', `wantedlevel` = '%i', `gender` = '%i', `glic` = '%i' WHERE `vardas` = '%e' LIMIT 1;", \
		pInfo[playerid][uniforma], pInfo[playerid][wUniform], pInfo[playerid][gaudomumas], pInfo[playerid][lytis], pInfo[playerid][glic],playerName[playerid]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 300, "UPDATE `zaidejai` SET `pavaduotojas` = '%i', `aisp` = '%i', `disp` = '%i', `visp` = '%i', `siandienprazaide` = '%i', `siandienpradirbo` = '%i', `priziuretojas` = '%i' WHERE `vardas` = '%e' LIMIT 1;", \
		pInfo[playerid][pavaduotojas], pInfo[playerid][aisp], pInfo[playerid][disp], pInfo[playerid][visp], pInfo[playerid][siandienprazaide], pInfo[playerid][siandienpradirbo], pInfo[playerid][priziuretojas], playerName[playerid]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 300, "UPDATE zaidejai SET `lastloginDATE` = '%s', `lastloginIP` = '%s', `laikoligonineje` = '%i', `pagydymai` = '%i', `baudos` = '%i', `sveikatospazyma` = '%i', `sveikatospazymoslaikas` = '%i' WHERE vardas = '%e' LIMIT 1;", \
		GautiData(0), IPAS[playerid], pInfo[playerid][LaikoLigoninej], pInfo[playerid][pagydymai], pInfo[playerid][baudos], pInfo[playerid][sveikatpaz], pInfo[playerid][sveikatpazlaikas], playerName[playerid]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 250, "UPDATE zaidejai SET `prizisp` = '%i', `direktoriaus_ispejimai` = '%i', `perma_mute` = '%i' WHERE vardas = '%e' LIMIT 1;", \
		pInfo[playerid][priziuretojausisp], pInfo[playerid][drkisp], pInfo[playerid][permamute], playerName[playerid]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 300, "UPDATE darbaiSuPakvietimais_xp SET `MedikoXP` = '%i', `PolicininkoXP` = '%i', `ArmijosXP` = '%i' WHERE Vardas = '%e' LIMIT 1;", \
		pInfo[playerid][zaidejoMedikuXP], pInfo[playerid][zaidejoPolicijosXP], pInfo[playerid][zaidejoArmijosXP], playerName[playerid]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");

	mysql_format(connectionHandle, query, 140, "UPDATE zaidejai SET `skin` = '%i', Rangas = '%i', adminmutename = '%s' WHERE vardas = '%e' LIMIT 1;", \
		pInfo[playerid][skin], pInfo[playerid][DarboRangas], pInfo[playerid][KasUztilde], playerName[playerid]);
	mysql_tquery(connectionHandle, query, "SendQuery", "");
	return 1;

}

function LoadPickups()
{
	pickups[0][ginkline] = CreateDynamicPickup(19197, 1,-2626.4158,208.4830,4.8125); 
	CreateDynamic3DTextLabel("{4bbaed}Ginkl�{ffffff} parduotuv�\nNor�damas �eiti spausk {4bbaed}ENTER", -1, -2626.4158,208.4830,4.8125, 20);

	pickups[0][ginklinesisejimas] = CreateDynamicPickup(19197, 1,285.4547,-40.8078,1001.5156);
	CreateDynamic3DTextLabel("{4bbaed}Ginkl�{ffffff} parduotuv�\nNor�damas i�eiti spausk {4bbaed}ENTER", -1, 285.4547,-40.8078,1001.5156, 20);

	pickups[0][ginklinesgun] = CreateDynamicPickup(1274,2,291.1360,-34.7810,1001.5156);
	CreateDynamic3DTextLabel("{1fbf79}Ginkl�{ffffff} pardavimas", -1, 291.1360,-34.7810,1001.5156, 20);

	pickups[0][ligoninesiejimas]=CreateDynamicPickup(19197, 1, -2664.7969,640.1555,14.4531);
	CreateDynamic3DTextLabel("{4bbaed}Ligonin�{ffffff}\nNor�damas �eiti spausk {4bbaed}ENTER",-1,-2664.7969,640.1555,14.4531, 20);

	pickups[0][ligoninesisejimas]=CreateDynamicPickup(19197, 1, -204.6047,-1736.0876,675.7687);
	CreateDynamic3DTextLabel("{4bbaed}Ligonin�{ffffff}\nNor�damas i�eiti spausk {4bbaed}ENTER",-1,-204.6047,-1736.0876,675.7687, 20);

	pickups[0][bankoiejimas]=CreateDynamicPickup(19197,1, -2720.3792,127.8134,7.0391 );
	CreateDynamic3DTextLabel("{4bbaed}Bankas{ffffff}\nNor�damas �eiti spausk {4bbaed}ENTER",-1, -2720.3792,127.8134,7.0391, 20);

	pickups[0][bankoisejimas]=CreateDynamicPickup(19197,1, 2315.952880,-1.618174,26.742187);
	CreateDynamic3DTextLabel("{4bbaed}Bankas{ffffff}\nNor�damas i�eiti spausk {4bbaed}ENTER",-1, 2315.952880,-1.618174,26.742187, 20);

    pickups[0][viriausybesiejimas]=CreateDynamicPickup(19197,1, -2719.2256,-318.3883,7.8438);
    CreateDynamic3DTextLabel("{4bbaed}Vyriausyb�{ffffff}\nNor�damas �eiti spausk {4bbaed}ENTER",-1, -2719.2256,-318.3883,7.8438, 20);

	pickups[0][viriausybesisejimas]=CreateDynamicPickup(19197,1, 384.808624,173.804992,1008.382812);
	CreateDynamic3DTextLabel("{4bbaed}Vyriausyb�{ffffff}\nNor�damas i�eiti spausk {4bbaed}ENTER",-1, 384.808624,173.804992,1008.382812, 20);

	pickups[0][hotelioiejimas]=CreateDynamicPickup(19197,1, -2425.6616,337.7326,37.0011);
	CreateDynamic3DTextLabel("{4bbaed}Vie�butis{ffffff}\nNor�damas �eiti spausk {4bbaed}ENTER",-1, -2425.6616,337.7326,37.0011, 20);

	pickups[0][hotelioisejimas]=CreateDynamicPickup(19197,1, 2214.7173,-1150.7694,1025.7969);
	CreateDynamic3DTextLabel("{4bbaed}Vie�butis{ffffff}\nNor�damas i�eiti spausk {4bbaed}ENTER",-1, 2214.7173,-1150.7694,1025.7969, 20);

 	pickups[0][vmiejimas]=CreateDynamicPickup(19197,1,-2025.1653,-102.4753,35.1719);
	CreateDynamic3DTextLabel("{4bbaed}Vairavimo{ffffff} mokykla\nNor�damas �eiti spausk {4bbaed}ENTER",-1, -2025.1653,-102.4753,35.1719, 20);

 	pickups[0][vmisejimas]=CreateDynamicPickup(19197,1, -2016.5596,-92.9655,700.9688);
	CreateDynamic3DTextLabel("{4bbaed}Vairavimo{ffffff} mokykla\nNor�damas i�eiti spausk {4bbaed}ENTER",-1, -2016.5596,-92.9655,700.9688, 20);

   	pickups[0][pdiejimas]=CreateDynamicPickup(19197, 1,-1605.5330,711.6919,13.8672);
	CreateDynamic3DTextLabel("{4bbaed}Policijos {ffffff}departamentas\nNor�damas �eiti spausk {4bbaed}ENTER", -1, -1605.5330,711.6919,13.8672, 20);

	pickups[0][pdisejimas]=CreateDynamicPickup(19197, 1, 246.5946,108.4236,1003.2188);
	CreateDynamic3DTextLabel("{4bbaed}Policijos {ffffff}departamentas\nNor�damas i�eiti spausk {4bbaed}ENTER",-1, 246.5946,108.4236,1003.2188, 20);

	pickups[0][medinfo]=CreateDynamicPickup(1239, 2, -202.0198,-1739.5759,675.7687);
	CreateDynamic3DTextLabel("{2E9525}Medicinos departamento informacija",-1, -202.0198,-1739.5759,675.7687, 20);

	pickups[0][pdinfo]=CreateDynamicPickup(1239, 2, 246.5785,118.5371,1003.2188);
	CreateDynamic3DTextLabel("{2E9525}Policijos departamento informacija",-1, 246.5785,118.5371,1003.2188, 20);

	pickups[0][sveikatospaz]=CreateDynamicPickup(1240, 2, -201.5365,-1743.0869,675.7687);
	CreateDynamic3DTextLabel("{2E9525}Sveikatos pa�yma", -1, -201.5365,-1743.0869,675.7687, 20);

	pickups[0][armijosinfo]=CreateDynamicPickup(1239, 2,-1519.5092,479.7615,7.1875);
	CreateDynamic3DTextLabel("{2E9525}Armijos informacija", -1, -1519.5092,479.7615,7.1875, 20);

	pickups[0][gunlicbuypickup] = CreateDynamicPickup(1274, 2, 292.0857, -30.8236, 1001.5156);
	CreateDynamic3DTextLabel("{2E9525}Ginkl� licenzija", -1, 292.0857, -30.8236, 1001.5156, 20);

	pickups[0][admbauda] = CreateDynamicPickup(1274, 2, 251.9027,117.3558,1003.2188);
	CreateDynamic3DTextLabel("{ffffff}Susimok�jimas u� {8B7152}administracines{ffffff} baudas", -1, 251.9027,117.3558,1003.2188, 20);
	return 1;
}	

function TikrinamGyvybes(playerid)
{
	new Float:Health;
	GetPlayerHealth(playerid, Health);
 
	if(poMirties[playerid]) return 0;

	if(Health >= 1 && Health <= 10)
	{
		if(!leisgyvis[playerid]){ShowPlayerDialog(playerid, leisgyviss, DIALOG_STYLE_LIST, "Leisgyvis", "{74C487}�{ffffff} Prane�ti medikams ir laukti j� pagalbos\n{74C487}�{ffffff} Keliauti � ligonin�", "Pasirinkti", "");}
		ClearAnimations(playerid);
		TogglePlayerControllable(playerid, 0);
		ApplyAnimation(playerid,"CRACK","crckdeth2",4.0,0,0,0,1,1);
		leisgyvis[playerid] = true;
	}
	return 1;
}

function Iskvietimas(playerid, iskvietusioID)
{
	if(pInfo[iskvietusioID][kvieciaID] == 0)
	{
		switch(pInfo[playerid][darbas])
		{
			case MEDIKAI:{pInfo[playerid][viskvmed] = false;}
			case POLICININKAI:{pInfo[playerid][viskvpd] = false;}
		}
		SendFormatToJob(pInfo[playerid][darbas], GREEN, "[RACIJA]: %s at�auk� i�kvietim�.", playerName[iskvietusioID]);
		KillTimer(Iskvietimotimer[playerid]);
		pInfo[playerid][PasirinktasZaidejas] = EOS;
	}
	new Float:cords[3];
	GetPlayerPos(iskvietusioID, cords[0], cords[1], cords[2]);
	SetPlayerCheckpoint(playerid, cords[0], cords[1], cords[2], 2);
	return 1;
}