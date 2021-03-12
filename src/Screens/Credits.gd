extends Control
#Title
var title = "Terre Puanteur"
var ir = "IR Studios"
var title_credits = [title,ir]
#Producer
var dw_2020 = "David W"
var producer_credits = [dw_2020]

#Developers
var aa_2021 = "Andie A"
var nl_2020 = "Nicole L"
var developer_credits = [aa_2021,nl_2020]
#Network


#Music
var prelude_in_c_attribution = "Prelude in C (BWV 846) Kevin MacLeod (incompetech.com)\nLicensed under Creative Commons: By Attribution 3.0 License\nhttp://creativecommons.org/licenses/by/3.0/"

var music_credits = [prelude_in_c_attribution]

#SFX
var placeholder_sfx = "Some SFX!\nLicensed under Creative Commons: By Attribution 3.0 License\nhttp://creativecommons.org/licenses/by/3.0/"

var sfx_credits = [placeholder_sfx,placeholder_sfx,placeholder_sfx,placeholder_sfx,placeholder_sfx]

onready var back_button = $BackButton
onready var credit_list = $ScrollContainer/CreditList
onready var scroll_container = $ScrollContainer
var scroll_rate = 60
var scroll_position = 0
var auto_scroll = true

func _ready():
	credit_list.add_text("\n\n")
	add_section("The Game",title_credits)
	add_section("Producer",producer_credits)
	add_section("Developers",developer_credits)
	add_section("Music",music_credits)
	add_section("SFX",sfx_credits)


func _process(delta:float):
	if auto_scroll:
		scroll_position += (delta * scroll_rate)
		scroll_container.scroll_vertical = scroll_position
		#If we have scrolled to the end, then we can shutdown autoscroll
		if _did_scroll_end():
			auto_scroll = false
	
func add_section(title,credits:Array):
	credit_list.add_text(title)
	credit_list.add_text("\n")
	for name in credits:
		credit_list.add_text(name)
		credit_list.add_text("\n")
	credit_list.add_text("\n\n")


func _did_scroll_end():
	return scroll_position >= credit_list.rect_size.y - scroll_container.rect_size.y


func _on_CreditList_gui_input(event):
	if event.is_action_pressed("ui_select",true) || event.is_action_pressed("ui_accept",true):
		if auto_scroll:
			auto_scroll = false
		else:
			scroll_position = scroll_container.scroll_vertical
			if _did_scroll_end():
				scroll_position = 0
				scroll_container.scroll_vertical = 0
			auto_scroll = true


func _on_CreditsScreen_gui_input(event):
	if event.is_action_pressed("ui_cancel",true):
		back_button._on_Button_pressed()

