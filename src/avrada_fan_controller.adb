-- AVRAda PC fan controller
-- The AVR microcontroller will control two PC PWM fans
-- Based on the temperature read from a MCP9808 sensor
-- The fans will do a startup to 100% duty cycle for five seconds
-- Then will fall down to 0% duty cycle and the temperature monitoring
-- will begin

with AVRAda_RTS_Config;
with AVR.UART; 			use AVR.UART;
with Interfaces;
with AVR.Wait;
with MCP9808;			use MCP9808;
with MCP9808.I2C;
with PWM_Controller;	use PWM_Controller;

procedure Avrada_Fan_Controller is
	Temperature_Sensor : MCP9808.I2C.MCP9808_Temperature_Sensor_I2C;
	Fan_Controller     : PWM_Controller;
   Temp               : Temperature;
	Stat               : Boolean;
	Res                : Resolution_Bits;

   procedure Wait_1_Sec is new
     AVR.Wait.Generic_Wait_USecs (AVRAda_Rts_Config.Clock_Frequency,
                                  1_000_000);
begin
   Init (Baud_19200_16MHz);

   Put ("Initializing AVRAda Fan Controller...");
   New_Line;

   Temperature_Sensor.Initialize;

   Put ("Getting temperature resolution...");
   Temperature_Sensor.Get_Resolution (Resolution => Res,
                                      Status => Stat);
	Put ("Resolution is: ");
	begin
   case Res is
      when Res_05C =>
         Put ("0.5C");
      when Res_025C =>
         Put ("0.25C");
      when Res_0125C =>
         Put ("0.125C");
      when Res_00625C =>
         Put ("0.0625C");
		end case;
	exception
		when others =>
			Put ("Exception happened! Resolution unknown.");
	end;
   New_Line;

	Fan_Controller.Initialize;

   Endless :
   loop
      Put ("Getting temperature...");
      Temperature_Sensor.Get_Ambient_Temperature (Temp, Stat);

      Put ("Status: ");
      if Stat = True then
         Put ("True");
      else
         Put ("False");
      end if;

      begin
         Put ("Temperature read: ");
         Put (Interfaces.Unsigned_16 (Integer (Temp * 1000.0)));
         New_Line;
      exception
         when others =>
            Put ("Exception happened! Temperature unknown.");
      end;

      Wait_1_Sec;
   end loop Endless;

end Avrada_Fan_Controller;
