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
   begin
      null;
   end Get_Temperature;
   
end MCP9808.I2C;
