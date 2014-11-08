// Global Variables
EAST setFriend [WEST, 0];			// AI Units
EAST setFriend [RESISTANCE, 0];
EAST setFriend [CIVILIAN, 0];
EAST setFriend [EAST, 0];

WEST setFriend [WEST, 0];				// Other / Observers
WEST setFriend [RESISTANCE, 0];
WEST setFriend [CIVILIAN, 0];
WEST setFriend [EAST, 0];

CIVILIAN setFriend [WEST, 0];			// Human players
CIVILIAN setFriend [RESISTANCE, 0];
CIVILIAN setFriend [CIVILIAN, 1];		// Set to 1 as needed to access crates. :/
CIVILIAN setFriend [EAST, 0];

RESISTANCE setFriend [WEST, 0];
RESISTANCE setFriend [RESISTANCE, 0];
RESISTANCE setFriend [CIVILIAN, 0];
RESISTANCE setFriend [EAST, 0];

VERSION = "v1.4.30";
GAMEMODEZ = (paramsArray select 0);
ZONELIMIT = (paramsArray select 1);
ZONECREEP = (paramsArray select 2);
TRACKINTERVAL = (paramsArray select 3);
CRATESIZE = (paramsArray select 4);
CRATEINTERVAL = (paramsArray select 5);
ZONEBOMB = (paramsArray select 6);
ZONEBOMBDELAY = (paramsArray select 7);
ALLOWCARS = (paramsArray select 8);
SHIELDCARS = (paramsArray select 9);
PLACECARS = (paramsArray select 10);
AIENABLE = (paramsArray select 11);
STARTGUN = (paramsArray select 12);

enableSaving [false, false];

killerScored = objNull;
aiMarks = [];
aiLife = [];
aiM = 0;
while {aiM < 50} do {
	_pre = "0";
	if (aiM > 9) then {
		_pre = "";
	};
	aiMarks = aiMarks + [ format["aim%1%2", _pre, aiM] ];
	aiLife = aiLife + [ 0 ];
	aiM = aiM + 1;
};

CombatPlayerScore = 0;
carMarks = ["car01m","car02m","car03m","car04m","car05m","car06m","car07m","car08m","car09m","car10m","car11m","car12m","car13m","car14m","car15m","car16m","car17m","car18m","car19m","car20m"];
SAFEZONE = 54;
introText = format["Welcome to Combat Royale Altis\nVersion %1\n\nBy Darren 'Dabbo' Edmonds.", VERSION];
ZoneDialogMessage = "Zone Status...";
zonesRemainUpdate = 0;
ZoneDialogAlert = 0;
EndGameUpdate = 0;
if (isNil "ServerReady") then {
	ServerReady = 0;
};
if (isNil "MissionEndTrigger") then {
	MissionEndTrigger = 0;
};
if (isNil "Score1") then {
	Score1 = "1st : ---------- 0 Kills";
};
if (isNil "Score2") then {
	Score2 = "2nd : ---------- 0 Kills";
};
if (isNil "Score3") then {
	Score3 = "3rd : ---------- 0 Kills";
};
if (isNil "Score4") then {
	Score4 = "4th : ---------- 0 Kills";
};
if (isNil "Score5") then {
	Score5 = "5th : ---------- 0 Kills";
};

obj_guns = [
	"hgun_ACPC2_F",									// Hand Guns
	"hgun_P07_F",
	"hgun_Rook40_F",
	"hgun_Pistol_heavy_01_F",
	"hgun_Pistol_heavy_02_F",
	"SMG_01_F",										// SMGs
	"SMG_02_F",
	"hgun_PDW2000_F",
	"arifle_Katiba_F",								// Assault Rifles
	"arifle_Katiba_C_F",
	"arifle_Mk20_F",
	"arifle_MX_F",
	"arifle_MX_Black_F",
	"arifle_MXC_F",
	"arifle_MXC_Black_F",
	"arifle_MXM_F",
	"arifle_MXM_Black_F",
	"arifle_SDAR_F",
	"arifle_TRG20_F",
	"arifle_TRG21_F",
	"arifle_MX_SW_F",								// LMGs
	"LMG_Mk200_F",
	"LMG_Zafir_F",
	"srifle_EBR_F",									// Sniper Rifles
	"srifle_GM6_F",
	"srifle_LRR_F",
	"srifle_DMR_01_F",
	"arifle_Katiba_GL_F",							// Grenade Launchers
	"arifle_MX_GL_F",
	"arifle_Mk20_GL_F",
	"arifle_MX_GL_Black_F",
	"arifle_TRG21_GL_F",
	"launch_NLAW_F",								// Launchers
	"launch_RPG32_F"
];

obj_mags = [
	"9Rnd_45ACP_Mag",								// Hand Guns
	"30Rnd_9x21_Mag",
	"30Rnd_9x21_Mag",
	"11Rnd_45ACP_Mag",
	"6Rnd_45ACP_Cylinder",
	"30Rnd_45ACP_Mag_SMG_01_tracer_green",			// SMGs
	"30Rnd_9x21_Mag",
	"30Rnd_9x21_Mag",
	"30Rnd_65x39_caseless_green_mag_Tracer",		// Assault Rifles
	"30Rnd_65x39_caseless_green_mag_Tracer",
	"30Rnd_556x45_Stanag_Tracer_Yellow",
	"30Rnd_65x39_caseless_mag_Tracer",
	"30Rnd_65x39_caseless_mag_Tracer",
	"30Rnd_65x39_caseless_mag_Tracer",
	"30Rnd_65x39_caseless_mag_Tracer",
	"30Rnd_65x39_caseless_mag_Tracer",
	"30Rnd_65x39_caseless_mag_Tracer",
	"30Rnd_556x45_Stanag_Tracer_Yellow",
	"30Rnd_556x45_Stanag_Tracer_Yellow",
	"30Rnd_556x45_Stanag_Tracer_Yellow",
	"100Rnd_65x39_caseless_mag_Tracer",				// LMGs
	"200Rnd_65x39_cased_Box_Tracer",
	"150Rnd_762x51_Box_Tracer",
	"20Rnd_762x51_Mag",								// Sniper Rifles
	"5Rnd_127x108_APDS_Mag",
	"7Rnd_408_Mag",
	"10Rnd_762x51_Mag",
	"30Rnd_65x39_caseless_green_mag_Tracer",		// Grenade Launchers
	"30Rnd_65x39_caseless_mag_Tracer",
	"30Rnd_556x45_Stanag_Tracer_Yellow",
	"30Rnd_65x39_caseless_mag_Tracer",
	"30Rnd_556x45_Stanag_Tracer_Yellow",
	"NLAW_F",										// Launchers
	"RPG32_HE_F"
];

obj_backpacks = [ 
	"B_AssaultPack_Base",
	"B_AssaultPack_blk",
	"B_FieldPack_khk",
	"B_AssaultPack_cbr",
	"B_AssaultPack_dgtl",
	"B_AssaultPack_khk",
	"B_AssaultPack_mcamo",
	"B_AssaultPack_ocamo",
	"B_AssaultPack_rgr",
	"B_AssaultPack_sgg",
	"B_Bergen_Base",
	"B_Bergen_sgg",
	"B_Carryall_Base",
	"B_Carryall_ocamo"
];
obj_items = [	
	"Binocular",
	"ItemGPS",
	"H_Bandanna_camo",
	"H_Bandanna_khk",
	"H_Bandanna_surfer",
	"H_Bandanna_gry",
	"H_BandMask_reaper",
	"H_BandMask_demon",
	"H_Beret_brn_SF",
	"H_Beret_red",
	"H_Beret_ocamo",
	"H_Booniehat_dgtl",
	"H_Booniehat_dirty",
	"H_Booniehat_indp",
	"H_Booniehat_tan",
	"H_Cap_blk",
	"H_Cap_blu",
	"H_Cap_red",
	"H_Cap_tan_specops_US",
	"H_CrewHelmetHeli_B",
	"H_Hat_checker",
	"H_HelmetIA",
	"H_HelmetSpecB",
	"H_MilCap_blue",
	"H_StrawHat",
	"H_TurbanO_blk",
	"muzzle_snds_acp",
	"muzzle_snds_B",
	"muzzle_snds_H",
	"muzzle_snds_H_MG",
	"muzzle_snds_L",
	"muzzle_snds_M",
	"optic_Aco",
	"optic_Aco_grn",
	"optic_Aco_grn_smg",
	"optic_Aco_smg",
	"optic_Arco",
	"optic_Hamr",
	"optic_Holosight",
	"optic_Holosight_smg",
	"optic_MRCO",
	"optic_Nightstalker",
	"optic_NVS",
	"optic_SOS",
	"optic_tws",
	"optic_tws_mg",
	"U_B_CombatUniform_mcam",
	"U_B_CombatUniform_mcam_tshirt",
	"U_B_CombatUniform_mcam_vest",
	"U_B_CombatUniform_mcam_worn",
	"U_B_GhillieSuit",
	"U_B_HeliPilotCoveralls",
	"U_B_PilotCoveralls",
	"U_B_SpecopsUniform_sgg",
	"U_B_Wetsuit",
	"V_BandollierB_blk",
	"V_BandollierB_cbr",
	"V_BandollierB_oli",
	"V_Chestrig_khk",
	"V_Chestrig_rgr",
	"V_HarnessO_brn",
	"V_HarnessOGL_gry",
	"V_PlateCarrier1_blk",
	"V_PlateCarrier1_rgr",
	"V_PlateCarrier2_rgr",
	"V_PlateCarrierGL_rgr",
	"V_PlateCarrierSpec_rgr",
	"V_TacVest_blk",
	"V_TacVest_blk_POLICE",
	"V_TacVest_brn",
	"V_TacVest_camo",
	"V_TacVestIR_blk"
];

// Server init
if (isServer) then {
	// Server specific tasks
	execVM "serverInit.sqf";
};
if (!isServer || !(isNull player)) then {
	// Listen Server + Client only tasks
	execVM "clientInit.sqf";
};

// Unknowns
crateTicker = -1;

// END
