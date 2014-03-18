if(!bb_state_inProgress) then {
     closeDialog 0;
     _ok = createDialog "Build_Recipe_Dialog";
     [] call refresh_build_recipe_dialog;
     waitUntil { !dialog }; // hit ESC to close it
};