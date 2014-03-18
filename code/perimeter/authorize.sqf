_panel = _this select 3;


if(!bb_user_authorized) then {
    bb_user_authorized=true;
    cutText ["You can tow / remove / build restricted objects your base", "PLAIN DOWN"];
    
    while{player distance _panel < baseSize}do {
    
        sleep 3;
    
    };
    cutText ["You can tow / remove / build restricted objects anymore. You are too far.", "PLAIN DOWN"];
    bb_user_authorized=false;
} else {
    cutText ["You are already bb_user_authorized!", "PLAIN DOWN"];
};
