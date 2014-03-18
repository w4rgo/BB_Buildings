
private ["_target","_caller","_id","_loop2","_vec","_inrepairzone"];

_target = _this select 0;
_caller = _this select 1;
_id = _this select 2;
_vehicule = _this select 3;
_action= _this select 4;



_inrepairzone = count ( nearestObjects [position _vehicule,["HeliHCivil","Helipadsmall"], 10]) > 0;

if(_inrepairzone) then
{
    titleText ["Servicing", "PLAIN DOWN",0.3];
    _vehicule setFuel 1;
    _vehicule setDamage 0;
    _vehicule setVehicleAmmo 1;
}else {
    titleText ["You must be near a helipad", "PLAIN DOWN", 3];
    titleFadeOut 3;
};

