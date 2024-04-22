-- MCP9808 temperature controller I2C definitions

with AVR.I2C;

package MCP9808.I2C is

   type MCP9808_Temperature_Sensor_I2C is
     new MCP9808_Temperature_Sensor with private;
   
   overriding
   procedure Initialize (This : in out MCP9808_Temperature_Sensor_I2C);
   
   overriding
   procedure Get_Temperature
     (This   : in out MCP9808_Temperature_Sensor_I2C;
      Temp   : out Temperature;
      Status : out Boolean);

private
   
   type MCP9808_Temperature_Sensor_I2C is
     new MCP9808_Temperature_Sensor with record
      I2C_Address : AVR.I2C.I2C_Address;
   end record;

end MCP9808.I2C;
