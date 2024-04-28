-- AVR PWM controller

package PWM_Controller is

	type Duty_Cycle is range 0 .. 100;
	
	procedure Initialize;
	
	procedure Set_Duty_Cycle (Duty : in Duty_Cycle);
	procedure Get_Duty_Cycle (Duty : out Duty_Cycle);

end PWM_Controller;
