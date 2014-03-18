//[_cam] call fnc_camera_startup;
_panel = _this select 3;

[_panel] call fnc_search_cameras;

_numCam = count bb_base_cameras;
if(_numCam> 0 ) then {
    cutText [format["Camera system activated: %1 cameras detected",_numCam], "PLAIN DOWN"];
    [] call fnc_camera_startup;
} else {
    cutText [format["You have no cameras..."], "PLAIN DOWN"];

};

