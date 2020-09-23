-- luacheck: globals core cm effect out
-- luacheck: globals find_uicomponent UIComponent Util Button TextButton FlowLayout Container ListView Frame
-- luacheck: globals call_for_aid

local function table_contains(t, val)
    for _, v in ipairs(t) do
        if v == val then
            return true
        end
    end
    return false
end

_G.call_for_aid = _G.call_for_aid or {}
local call_for_aid = _G.call_for_aid
call_for_aid.spawn_funcs = call_for_aid.spawn_funcs or {}
call_for_aid.localizations = call_for_aid.localizations or {}
-------------------distance at which they will reinforce
distance_reinforce = 20
if not cm:get_saved_value("button_is_green") then cm:set_saved_value("button_is_green", 0); end;
-------------------BUTTON Dilemma function

function CallForAid()
local ai_character_faction_key =  cm:get_saved_value("temp_faction_call_for_aid_latest_AI");
local ai_character_faction = cm:get_faction(ai_character_faction_key)
local ai_character_cqi = cm:get_saved_value("temp_character_call_for_aid_latest_AI");
local ai_character = cm:get_character_by_cqi(ai_character_cqi)
local ai_character_x = ai_character:logical_position_x();
local ai_character_y = ai_character:logical_position_y();
local ai_character_string = cm:char_lookup_str(ai_character_cqi)

local player_faction = cm:model():world():whose_turn_is_it()
local player_faction_key = cm:model():world():whose_turn_is_it():name()
local player_character_cqi = cm:get_saved_value("temp_character_call_for_aid_player", cqi);
local player_character = cm:get_character_by_cqi(player_character_cqi)
local player_character_x = player_character:logical_position_x();
local player_character_y = player_character:logical_position_y();

local x_difference = player_character_x - ai_character_x
out("x difference is")
out(x_difference)
local y_difference = player_character_y - ai_character_y
out("y difference is")
out(y_difference)

local viable_x, viable_y = cm:find_valid_spawn_location_for_character_from_position(cm:model():world():whose_turn_is_it():name(), player_character_x, player_character_y, false, 2);

if x_difference > -distance_reinforce and x_difference < distance_reinforce then 
out("x difference is low enough!")
if y_difference > -distance_reinforce and y_difference < distance_reinforce then
out("y difference is low enough!")
if ai_character_faction:is_ally_vassal_or_client_state_of(player_faction) then
out("it is an ally!")
cm:teleport_to(ai_character_string, viable_x, viable_y, true)
if not ai_character:has_effect_bundle("reinforcement_range_bonus_hire") then
out("it has the effect")
cm:apply_effect_bundle_to_character("reinforcement_range_bonus_hire", ai_character, 1)
end;

end;
end;
end;
end;
-------------------Button
call_for_aid.create_main_button = function()
    local buttonParent =
        find_uicomponent(
        core:get_ui_root(),
        "layout",
        "info_panel_holder"
		
    )

    local call_for_aid_main_ui_button = Util.digForComponent(core:get_ui_root(), "call_for_aid_main_ui_button")
    if not call_for_aid_main_ui_button then
	if cm:get_saved_value("button_is_green") == 1 then
        call_for_aid_main_ui_button = Button.new("call_for_aid_main_ui_button", buttonParent, "SQUARE", "ui/skins/default/icon_filter_income.png")
	else
		 call_for_aid_main_ui_button = Button.new("call_for_aid_main_ui_button", buttonParent, "SQUARE", "ui/skins/default/icon_disband.png")
    end
	end;
    call_for_aid_main_ui_button.uic:PropagatePriority(102)
    -- call_for_aid_main_ui_button:SetImagePath("ui/skins/default/icon_build.png")

    local army_abilities_panel =
        find_uicomponent(
        core:get_ui_root(),
        "layout",
        "info_panel_holder"
    )
    call_for_aid_main_ui_button:Resize(40, 40)
    call_for_aid_main_ui_button:PositionRelativeTo(army_abilities_panel, 1, 1)
    call_for_aid_main_ui_button:SetState("hover")
	if cm:get_saved_value("button_is_green") == 1 then
    call_for_aid_main_ui_button.uic:SetTooltipText("Call Ally for Aid (Ally army is nearby)")
	else
	call_for_aid_main_ui_button.uic:SetTooltipText("Call Ally for Aid (Ally army is not near enough!)")
	end;
    call_for_aid_main_ui_button.uic:PropagatePriority(102)
    call_for_aid_main_ui_button:SetState("active")
    call_for_aid_main_ui_button.uic:PropagatePriority(102)
    call_for_aid_main_ui_button:RegisterForClick(
        function()
            local minimise_unit_panel_button =
                find_uicomponent(
                core:get_ui_root(),
                "units_panel",
                "main_units_panel"
            )
out("you clicked ze button!")
CallForAid()
        end
    )
    call_for_aid.call_for_aid_main_ui_button = call_for_aid_main_ui_button
end

core:remove_listener("call_for_aid_reinforcements_UnitsPanelOpenedListener")
core:add_listener(
    "call_for_aid_reinforcements_UnitsPanelOpenedListener",
    "CharacterSelected",
    function(context)
        local player_faction = cm:model():world():whose_turn_is_it()
		temp_ai_character_button = context:character();
        return context:character():character_type_key() == "general" and context:character():faction():is_ally_vassal_or_client_state_of(player_faction)
    end,
    function()
	local player_faction = cm:model():world():whose_turn_is_it()
	local player_faction_key = cm:model():world():whose_turn_is_it():name()
	local player_character_cqi = cm:get_saved_value("temp_character_call_for_aid_player", cqi);
	local player_character = cm:get_character_by_cqi(player_character_cqi)
	local player_character_x = player_character:logical_position_x();
	local player_character_y = player_character:logical_position_y();
	local ai_character_cqi = temp_ai_character_button:cqi();
	local ai_character_x = temp_ai_character_button:logical_position_x();
	local ai_character_y = temp_ai_character_button:logical_position_y();
	local ai_character_string = cm:char_lookup_str(ai_character_cqi)
	local x_difference = player_character_x - ai_character_x
	out("x difference is")
	out(x_difference)
	local y_difference = player_character_y - ai_character_y
	out("y difference is")
	out(y_difference)
	local viable_x, viable_y = cm:find_valid_spawn_location_for_character_from_position(cm:model():world():whose_turn_is_it():name(), player_character_x, player_character_y, false, 2);

	if x_difference > -distance_reinforce and x_difference < distance_reinforce and y_difference > -distance_reinforce and y_difference < distance_reinforce then
	out("x, y difference is low enough!") cm:set_saved_value("button_is_green", 1) out("button is green!"); 
	elseif x_difference < -distance_reinforce or x_difference > distance_reinforce or y_difference < -distance_reinforce or y_difference > distance_reinforce then
	cm:set_saved_value("button_is_green", 0) out("button is red!")
	end;
        local call_for_aid_main_ui_button = Util.digForComponent(core:get_ui_root(), "call_for_aid_main_ui_button")
        if not call_for_aid_main_ui_button then
            call_for_aid.create_main_button()
        end
    end,
    true
)

core:remove_listener("call_for_aid_reinforcements_UnitsPanelClosedListener")
core:add_listener(
    "call_for_aid_reinforcements_UnitsPanelclosed_selectListener",
    "CharacterSelected",
    function(context)
        local player_faction = cm:model():world():whose_turn_is_it()
        return context:character():character_type_key() == "general" and not context:character():faction():is_ally_vassal_or_client_state_of(player_faction)
    end,
    function()
	cm:remove_callback("call_for_aid_reinforcements_remove_main_button_cb")
        cm:callback(
            function()
                local call_for_aid_main_ui_button = Util.digForComponent(core:get_ui_root(), "call_for_aid_main_ui_button")
                if call_for_aid_main_ui_button then
                    Util.delete(call_for_aid_main_ui_button)
                    call_for_aid.call_for_aid_main_ui_button = nil
                end
                core:remove_listener("call_for_aid_main_button_click_listener")
            end,
            0.2,
            "call_for_aid_reinforcements_remove_main_button_cb"
        )
    end,
    true
)

core:remove_listener("call_for_aid_reinforcements_UnitsPanelClosedListener")
core:add_listener(
    "call_for_aid_reinforcements_UnitsPanelClosedListener",
    "PanelClosedCampaign",
    function(context)
        return context.string == "units_panel"
    end,
    function()
        cm:remove_callback("call_for_aid_reinforcements_remove_main_button_cb")
        cm:callback(
            function()
                local call_for_aid_main_ui_button = Util.digForComponent(core:get_ui_root(), "call_for_aid_main_ui_button")
                if call_for_aid_main_ui_button then
                    Util.delete(call_for_aid_main_ui_button)
                    call_for_aid.call_for_aid_main_ui_button = nil
                end
                core:remove_listener("call_for_aid_main_button_click_listener")
            end,
            0.2,
            "call_for_aid_reinforcements_remove_main_button_cb"
        )
    end,
    true
)

core:add_listener(
    "call_for_aid_character_listener",
    "CharacterSelected",
    function(context)
        return context:character():character_type_key() == "general"
    end,
    function(context)
    local cqi = context:character():cqi()
	local ai_faction = context:character():faction()
	local ai_faction_key = context:character():faction():name()
	if ai_faction == cm:model():world():whose_turn_is_it() then
	else
	 	local selected_character = context:character()
		local cqi = context:character():cqi()
		out(cqi)
		out(ai_faction_key)
		cm:set_saved_value("temp_character_call_for_aid_latest_AI", cqi);
		cm:set_saved_value("temp_faction_call_for_aid_latest_AI", context:character():faction():name());
	end;
    end,
    true
)

core:add_listener(
    "call_for_aid_character_listener1a",
    "CharacterSelected",
    function(context)
        local faction_name = context:character():faction():name()
        return cm:model():world():whose_turn_is_it():name() == faction_name and
            context:character():character_type_key() == "general"
    end,
    function(context)
        local cqi = context:character():cqi()
	local selected_character = context:character()
	local cqi = context:character():cqi()
	cm:set_saved_value("temp_character_call_for_aid_player", cqi);
    end,
    true
)