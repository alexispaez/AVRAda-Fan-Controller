with AVR.I2C.Master;

package body MCP9808.I2C is
   
   procedure Initialize (This : in out MCP9808_Temperature_Sensor_I2C) is
   begin
      This.I2C_Address := 16#05#;
      
      AVR.I2C.Master.Init;
      
      This.Initialized := True;
   end Initialize;
   
	procedure Get_Temperature
	  (This   : in out MCP9808_Temperature_Sensor_I2C;
	 	Temp   : out Temperature;
	   Status : out Boolean) is
		Temperature_Data_Raw : aliased Unsigned_16;
		Temperature_Data     : Ambient_Temperature_Register
		  with Address => Temperature_Data_Raw'Address;
	begin
		AVR.I2C.Master.Send_And_Receive
		  (This.I2C_Address,
	  		Unsigned_8 (TEMP_AMBIENT),
	  		Temperature_Data_Raw);
	end Get_Temperature;
	
end MCP9808.I2C;
