-- AVRAda PC fan controller
-- The AVR microcontroller will control two PC PWM fans
-- Based on the temperature read from a MCP9808 sensor
-- The fans will do a startup to 100% duty cycle for five seconds
-- Then will fall down to 0% duty cycle and the temperature monitoring
-- will begin
pragma Ada_2022;

with AVRAda_RTS_Config;
with AVR.UART; 			use AVR.UART;
with Interfaces;		use Interfaces;
with AVR.Wait;
with MCP9808;			use MCP9808;
with MCP9808.I2C;
with PWM_Controller;	use PWM_Controller;

procedure Avrada_Fan_Controller is

   Temperature_Sensor : MCP9808.I2C.MCP9808_Temperature_Sensor_I2C;
   Fan_Controller     : PWM_Fan_Controller;

   procedure Wait_1_Sec is new
     AVR.Wait.Generic_Wait_USecs (AVRAda_Rts_Config.Clock_Frequency,
											 1_000_000);

	procedure Put (Res : Resolution_Bits) is
	begin
		Put ("Resolution is: ");

		case Res is
		when Res_05C    => Put ("0.5C");
		when Res_025C   => Put ("0.25C");
		when Res_0125C  =>	Put ("0.125C");
		when Res_00625C =>	Put ("0.0625C");
		end case;
	exception
		when others =>
			Put ("Exception raised while printing resolution.");
	end;

	procedure Put (Temp : Temperature) is
		Full_Value      : Unsigned_16;
		Integer_Part    : Unsigned_16;
		Fractional_Part : Unsigned_16;
	begin
		begin
			Full_Value := Unsigned_16 (Temp * 1000.0);
			Integer_Part := Unsigned_16 (Temperature'Truncation (Temp));
			Fractional_Part := Full_Value - (Integer_Part * 1000);

			Put ("Temperature: ");
			Put (Integer_Part);
			Put (".");
			Put (Fractional_Part);
			Put (". ");
		exception
			when others =>
				Put ("Exception raised while printing temperature.");
		end;
	end;

	procedure Set_Fan_Speed (Temp : Temperature; Active : in out Boolean) is

		type Float_Range_Type is record
			Min : Float;
			Max : Float;
		end record
		  with Dynamic_Predicate =>
			 Float_Range_Type.Min < Float_Range_Type.Max and
			 Float_Range_Type.Max - Float_Range_Type.Min /= 0.0;

      function Convert_Range (
                              From_Value  : in Float;
                              From_Range  : in Float_Range_Type;
                              To_Range    : in Float_Range_Type) return Float
      is
			From_Range_Span : Float;
			To_Range_Span   : Float;
			To_Value        : Float;
		begin
			begin
				From_Range_Span := From_Range.Max - From_Range.Min;
				To_Range_Span   := To_Range.Max - To_Range.Min;

				To_Value := (((From_Value - From_Range.Min) * To_Range_Span)
					  / From_Range_Span)
				  + To_Range.Min;
			exception
				when others =>
					To_Value := 0.0;
			end;

			return To_Value;

		end Convert_Range;

      --  Activation temperature threshold
      Activation_Temperature : Temperature := 24.0;
		-- Active temperature range
		Active_Temperature_Range : Float_Range_Type := (23.0, 35.0);
		-- Active duty cycle to be 3% to 100%
      Active_Duty_Cycle_Range  : Float_Range_Type := (3.0, 100.0);
   begin
      if Temp >= Activation_Temperature then
         Active := True;
      elsif Temp < Active_Temperature_Range.Min then
         Active := False;
      end if;

      if Active then
         if Temp >= Active_Temperature_Range.Max then
            Fan_Controller.Set_Duty_Cycle (100);
         else
            begin
               Fan_Controller.Set_Duty_Cycle (Duty_Cycle (
                                              Convert_Range (Temp,
                                                Active_Temperature_Range,
                                                Active_Duty_Cycle_Range)));
            exception
               when others =>
                  Fan_Controller.Set_Duty_Cycle (0);
                  Put ("Exception raised while setting fan speed.");
            end;
         end if;
      else
         Fan_Controller.Set_Duty_Cycle (0);
      end if;
   end Set_Fan_Speed;

   Ambient_Temp       : Temperature;
   Status             : Boolean;
   Resolution         : Resolution_Bits;
   Active             : Boolean := False;
begin
   Init (Baud_19200_16MHz);

   Put ("Initializing AVRAda Fan Controller...");
   New_Line;

   Temperature_Sensor.Initialize;

   Temperature_Sensor.Get_Resolution (Resolution, Status);
	Put (Resolution);
   New_Line;

	Fan_Controller.Initialize;

	Fan_Controller.Startup;

	Endless :
	loop
		Temperature_Sensor.Get_Ambient_Temperature (Ambient_Temp, Status);

		if Status = True then
			Put (Ambient_Temp);
			Set_Fan_Speed (Ambient_Temp, Active);
		end if;

		Wait_1_Sec;
	end loop Endless;

end Avrada_Fan_Controller;
