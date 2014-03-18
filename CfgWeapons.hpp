class cfgWeapons {
	class Default;	// External class reference
	class ItemCore;	// External class reference
	class ItemRadio;

	
	class BB_ItemRadio : ItemRadio {
		scope = 2;
		displayName="Base Radio";
		class ItemActions {
			class Use {
				text = "Connect to base cameras";
				script = "spawn fnc_camera_startup;";
			};
		};
	};
};