extends Node
static var alias: String = "database"

var episode_pattern = "res://scenes/1_EpisodeScreen/Episode_%d.tscn"

#TITLE SCREEN
const TITLE_SCREEN = preload("uid://bv2ak3akkk522")
const MAIN_MENU    = preload("uid://c3qghmm8xroso")
const EPISODE_MENU   = preload("uid://2esoqd25qk6i")
const OPTIONS_MENU = preload("uid://bvrynu0sj71r7")


#EPISODES
const EPISODE_1    = preload("uid://cskkxp7khnm4a")
const EPISODE_2    = preload("uid://djuydmkfbukwa")


#LEVELS
const DEVICE = preload("uid://4et77lr0bmg")
const LEVEL_1 = preload("uid://4dguscwpt33s")
const LEVEL_2 = preload("uid://dnhgyilps2nbw")


#MUSIC
const MAIN_MENU_MUSIC = preload("uid://cier46qra6fbx")


#SOUND EFFECTS
const SE_MENU_BACK     = preload("uid://dwdnbbhcurf4d")
const SE_MENU_HOVER    = preload("uid://b5ba5h3amwsrx")
const SE_MENU_OPEN     = preload("uid://bve86kskqpohs")
const SE_MENU_ERROR    = preload("uid://cwbvsw78lsh5h")
const SE_START         = preload("uid://d00dl5muqqfms")
