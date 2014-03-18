 _player = _this select 3;
if ((name _player)!="Error: No unit") then {
    baseMembers set [count baseMembers, (name _player)];
};