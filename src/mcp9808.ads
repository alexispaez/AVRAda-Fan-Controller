-- MCP9808 temperature controller definitions

with Interfaces; use Interfaces;

package MCP9808 is

   type MCP9808_Temperature_Sensor is abstract tagged limited private;
   
   subtype Temperature is Float range -45.0 .. 125.0; -- in degrees Celsius
   
	type Resolution_Bits is (Res_05C,
								  Res_025C,
								  Res_0125C,
								  Res_00625C)
     with Size => 2;
	for Resolution_Bits use (Res_05C   => 0,
								  Res_025C   => 1,
								  Res_0125C  => 2,
								  Res_00625C => 3);
   
   procedure Initialize (This : in out MCP9808_Temperature_Sensor) is abstract;
   
   function Is_Initialized (This : MCP9808_Temperature_Sensor) return Boolean;
   
	procedure Get_Ambient_Temperature (This : in out MCP9808_Temperature_Sensor;
												Temp : out Temperature;
												Status : out Boolean) is abstract
	  with Pre'Class => Is_Initialized (This);

	procedure Get_Resolution (This      : in out MCP9808_Temperature_Sensor;
									Resolution : out Resolution_Bits;
									Status     : out Boolean) is abstract
	  with Pre'Class => Is_Initialized (This);

private
   type MCP9808_Temperature_Sensor is abstract tagged limited record
      Initialized : Boolean := False;
	end record;

   type Register_Address is new Unsigned_8;

	function Is_Initialized (This : MCP9808_Temperature_Sensor) return Boolean
	  is (This.Initialized);

	-- Register addresses taken from the MCP9808 data sheet
	CONFIG              : constant Register_Address := 16#01#;
	TEMP_UPPER_LIMIT    : constant Register_Address := 16#02#;
	TEMP_LOWER_LIMIT    : constant Register_Address := 16#03#;
	TEMP_CRITICAL_LIMIT : constant Register_Address := 16#04#;
	TEMP_AMBIENT        : constant Register_Address := 16#05#;
	MANUFACTURER_ID     : constant Register_Address := 16#06#;
	DEVICE_ID           : constant Register_Address := 16#07#;
	RESOLUTION_REG      : constant Register_Address := 16#08#;
	
	-- Bit helper representations
   type Bit is range 0 .. 1 with Size => 1;
   type Bits is array (Natural range <>) of Bit
     with Component_Size => 1;
	type Zero_Bit is range 0 .. 0 with Size => 1;
	type Zero_Bits is array (Natural range <>) of Zero_Bit
	  with Component_Size => 1;
	
	-- Register representations
	type Register_Data_16 is new Unsigned_16;
	type Register_Data_8 is new Unsigned_8;
	
	-- Configuration register - 16 bit
	type Temperature_Hysteresis_Bits is (Hys_00C,
												  Hys_15C,
												  Hys_30C,
												  Hys_60C)
	  with Size => 2;
	for Temperature_Hysteresis_Bits use (Hys_00C => 0,
												  Hys_15C => 1,
												  Hys_30C => 2,
												  Hys_60C => 3);

	type Configuration_Register is record
		Unimplemented : Zero_Bits (11 .. 15);
		T_HIST        : Temperature_Hysteresis_Bits;
		SHDN          : Bit;
		Crit_Lock     : Bit;
		Win_Lock      : Bit;
		Int_Clear     : Bit;
		Alert_Stat    : Bit;
		Alert_Cnt     : Bit;
		Alert_Sel     : Bit;
		Alert_Pol     : Bit;
		Alert_Mod     : Bit;
	end record
	  with Size => 16,
	  Independent;
	for Configuration_Register use record
		Unimplemented at 0 range 11 .. 15;
		T_HIST        at 0 range 9 .. 10;
		SHDN          at 0 range 8 .. 8;
		Crit_Lock     at 0 range 7 .. 7;
		Win_Lock      at 0 range 6 .. 6;
		Int_Clear     at 0 range 5 .. 5;
		Alert_Stat    at 0 range 4 .. 4;
		Alert_Cnt     at 0 range 3 .. 3;
		Alert_Sel     at 0 range 2 .. 2;
		Alert_Pol     at 0 range 1 .. 1;
		Alert_Mod     at 0 range 0 .. 0;
	end record;
	
	-- Upper, lower and critital temperature limit register - 16 bit
	type Temperature_Limit_Bits is mod 2 ** 10 with Size => 10;

	type Temperature_Limit_Register is record
		Unimplemented_1  : Zero_Bits (13 .. 15);
		T_SIGN           : Boolean;
		Temperature_Bits : Temperature_Limit_Bits;
		Unimplemented_2  : Zero_Bits (0 .. 1);
	end record
	  with Size => 16,
	  Independent;
	for Temperature_Limit_Register use record
		Unimplemented_1  at 0 range 13 .. 15;
		T_SIGN           at 0 range 12 .. 12;
		Temperature_Bits at 0 range 2 .. 11;
		Unimplemented_2  at 0 range 0 .. 1;
	end record;
	
	-- Ambient temperature register - 16 bit
	type Ambient_Temperature_Bits is mod 2 ** 12 with Size => 12;

   type Ambient_Temperature_Register is record
      T_CRIT   : Boolean;
      T_UPPER  : Boolean;
      T_LOWER  : Boolean;
      T_SIGN   : Boolean;
      T_Buffer : Ambient_Temperature_Bits;
   end record
     with Size => 16,
     Independent;
   for Ambient_Temperature_Register use record
      T_CRIT   at 0 range 15 .. 15;
      T_UPPER  at 0 range 14 .. 14;
      T_LOWER  at 0 range 13 .. 13;
      T_SIGN   at 0 range 12 .. 12;
      T_Buffer at 0 range 0 .. 11;
   end record;
   
   type Ambient_Temperature is record
      Filler   : Zero_Bits (12 .. 15);
      Whole    : Unsigned_8;
      Fraction : Bits (0 .. 3);
   end record
     with Size => 16,
     Independent;
   for Ambient_Temperature use record
      Filler   at 0 range 12 .. 15;
      Whole    at 0 range 4 .. 11;
      Fraction at 0 range 0 .. 3;
   end record;
	
	-- Manufacturer ID register - 16 bit
	-- It is a straight 16 bit field, so no special bit representation
	-- is needed
	
	
	-- Device ID register - 16 bit
	type Device_Id_And_Revision_Register is record
		Device_Id : Unsigned_8;
		Revision  : Unsigned_8;
	end record
	  with Size => 16,
	  Independent;
	for Device_Id_And_Revision_Register use record
		Device_Id at 0 range 8 .. 15;
		Revision  at 0 range 0 .. 7;
	end record;
	
	-- Resolution register - 8 bit
	type Resolution_Register is record
		Unimplemented : Zero_Bits (2 .. 7);
		Resolution    : Resolution_Bits;
	end record
	  with Size => 8,
	  Independent;
	for Resolution_Register use record
		Unimplemented at 0 range 2 .. 7;
		Resolution    at 0 range 0 .. 1;
	end record;

end MCP9808;
