package MCP9808 is

   type MCP9008_Temperature_Sensor is abstract tagged limited private;
   
   procedure Initialize (This : in out MCP9008_Temperature_Sensor) is abstract;
   
   subtype Temperature is Float range -45.0 .. 125.0; -- in degrees Celsius
   
   function Is_Initialized (This : MCP9008_Temperature_Sensor) return Boolean;
   
   procedure Get_Temperature
     (This : in out MCP9008_Temperature_Sensor;
      Temp : out Temperature;
      Status : out Boolean) is abstract
     with Pre'Class => Is_Initialized (This);

private
   type MCP9080_Temperature_Sensor is abstract tagged limited record
      Initialized : Boolean := False;
   end record;

end MCP9808;
