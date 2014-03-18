cutText ["Dumping the backpack in tent...", "PLAIN DOWN"];

_tent = _this select 3;
_bag = unitBackpack player;

[_bag,_tent] call fnc_dump_backpack;