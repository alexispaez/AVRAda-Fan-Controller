-- AVR PWM controller

package PWM_Controller is

   type PWM_Fan_Controller is tagged limited private;

   type Duty_Cycle is range 0 .. 100;

	procedure Initialize (This : in out PWM_Fan_Controller);

	procedure Startup (This : in out PWM_Fan_Controller);

	procedure Set_Duty_Cycle (This : in out PWM_Fan_Controller;
									Duty : in Duty_Cycle);
	procedure Get_Duty_Cycle (This : in out PWM_Fan_Controller;
									Duty : out Duty_Cycle);

private
	Duty_Top    : constant := 320;

	type PWM_Fan_Controller is tagged limited record
		Initialized : Boolean;
		PB_Duty     : Duty_Cycle;
   end record;

end PWM_Controller;
