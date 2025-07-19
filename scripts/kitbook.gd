extends Control

@onready var kitbook_tab_container: TabContainer = $VBoxContainer/KitbookTabContainer

@onready var prev_page: TextureButton = $VBoxContainer/FlipPageButtons/PrevPage
@onready var next_page: TextureButton = $VBoxContainer/FlipPageButtons/NextPage

var maxTabCount: int;
var kitbookCurrentTab: int;

func _ready() -> void:
	maxTabCount = kitbook_tab_container.get_tab_count() - 1;
	prev_page.focus_mode = Control.FOCUS_NONE;
	next_page.focus_mode = Control.FOCUS_NONE;


func change_page_to(page : int) -> void: # allows for other scripts to change the kitbook's page, ex. for the tutorial
	show();
	kitbook_tab_container.current_tab = page;

func _on_prev_page_pressed() -> void: # switches to previous page
	if (kitbook_tab_container.current_tab == 0): # if current page is first, then goes to last page.
		print("prev page on")
		print("cur page:" + str(kitbook_tab_container.current_tab))
		kitbook_tab_container.current_tab = maxTabCount;
	else:
		print("prev page off")
		print("cur page:" + str(kitbook_tab_container.current_tab))
		kitbook_tab_container.current_tab -= 1;
	SoundManager.button_sfx.play();

func _on_next_page_pressed() -> void: # switches to next page
	if (kitbook_tab_container.current_tab == maxTabCount): # if current page is last, then goes to first page.
		print("next page on")
		print("cur page:" + str(kitbook_tab_container.current_tab))
		kitbook_tab_container.current_tab = 0;
	else:
		print("next page off")
		print("cur page:" + str(kitbook_tab_container.current_tab))
		kitbook_tab_container.current_tab += 1;
	SoundManager.button_sfx.play();
