with Interfaces;
with AVR.I2C;        use AVR.I2C;
with AVR.I2C.Master;
with AVR.Interrupts;

with AVR.UART; use AVR.UART;

package body MCP9808.I2C is
   
   procedure Initialize (This : in out MCP9808_Temperature_Sensor_I2C) is
   begin
      This.I2C_Address := MCP9808_Address;
      
      Master.Init;
      
      This.Initialized := True;
   end Initialize;
   
   procedure Get_Ambient_Temperature
     (This   : in out MCP9808_Temperature_Sensor_I2C;
      Temp   : out Temperature;
      Status : out Boolean) is
      Temperature_Data_Raw : aliased Unsigned_16;
      Temperature_Data     : Ambient_Temperature_Register
        with Address => Temperature_Data_Raw'Address;
      Temperature_Raw      : aliased Unsigned_16;
      Temperature          : Ambient_Temperature
        with Address => Temperature_Raw'Address;
   begin
		-- Get the raw temperature data from the sensor
		AVR.Interrupts.Enable;
      Master.Send_And_Receive (This.I2C_Address,
                                       Unsigned_8 (TEMP_AMBIENT),
                                       Temperature_Data_Raw);

      if Master.Get_Error = OK then
         Status := True;
      else
         Status := False;
         return;
      end if;
      
      -- Calculate the temperature
      if Temperature_Data.T_SIGN = False then
         -- Calculate using >= 0ºC formula
         Temperature_Raw := Unsigned_16(Temperature_Data.T_Buffer);
      else
         -- Calculate using < 0ºC formula
         Temperature_Raw := 4096 - Unsigned_16(Temperature_Data.T_Buffer);
      end if;
      
      Temp := Float(Temperature.Whole);
      
      -- Calculate correct value for fraction
      declare
         Fraction : Float := 0.0;
      begin
         for Bit_Number in 0 .. 3 loop
            if Temperature.Fraction (Bit_Number) = 1 then
               case Bit_Number is
                  when 0 =>
                     Fraction := Fraction + 2.0 ** (-4);
                  when 1 =>
                     Fraction := Fraction + 2.0 ** (-3);
                  when 2 =>
                     Fraction := Fraction + 2.0 ** (-2);
                  when 3 =>
                     Fraction := Fraction + 2.0 ** (-1);
               end case;
            end if;
         end loop;
         
         Temp := Temp + Fraction;
      end;
      
   end Get_Ambient_Temperature;
   
   procedure Get_Resolution
     (This       : in out MCP9808_Temperature_Sensor_I2C;
      Resolution : out Resolution_Bits;
      Status     : out Boolean) is
      Resolution_Data_Raw : Unsigned_8;
      Resolution_Data     : Resolution_Register
        with Address => Resolution_Data_Raw'Address;
   begin
		-- Get the raw resolution data from the sensor
		AVR.Interrupts.Enable;
      Master.Send_And_Receive (This.I2C_Address,
                               Unsigned_8(RESOLUTION_REG),
                               Resolution_Data_Raw);

      if Master.Get_Error = OK then
         Status := True;
      else
         Status := False;
         return;
      end if;
      
      Resolution := Resolution_Data.Resolution;

   end Get_Resolution;
	
end MCP9808.I2C;
