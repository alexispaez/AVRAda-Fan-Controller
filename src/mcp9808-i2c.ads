-- MCP9808 temperature controller I2C definitions

with AVR.I2C;

package MCP9808.I2C is

   type MCP9808_Temperature_Sensor_I2C is
     new MCP9808_Temperature_Sensor with private;
   
   overriding
   procedure Initialize (This : in out MCP9808_Temperature_Sensor_I2C);
   
   overriding
   procedure Get_Ambient_Temperature
     (This   : in out MCP9808_Temperature_Sensor_I2C;
      Temp   : out Temperature;
      Status : out Boolean);

   procedure Get_Resolution
     (This : in out MCP9808_Temperature_Sensor_I2C;
      Resolution : out Resolution_Bits;
      Status : out Boolean);

private
   
   MCP9808_Address : AVR.I2C.I2C_Address :=  16#18#;
   
   type MCP9808_Temperature_Sensor_I2C is
     new MCP9808_Temperature_Sensor with record
      I2C_Address : AVR.I2C.I2C_Address;
   end record;

end MCP9808.I2C;
