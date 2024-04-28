-- AVR PWM controller
with AVR;				use AVR;
with AVR.MCU;
with AVR.Timer1;
with Interfaces; 	use Interfaces;

package body PWM_Controller is
	
	-- PWM output signal pins
	PB1     : Boolean renames MCU.DDRB_Bits (1);   -- pin 9
	PB2     : Boolean renames MCU.DDRB_Bits (2);   -- pin 10

	-- PWM Duty cycle values
	PB_Duty : Duty_Cycle;

	procedure Initialize is
	begin
		-- set the PWM pins to output
		PB1 := DD_Output;
		PB2 := DD_Output;
		
		-- Initialize timers
		Timer1.Init_PWM (Timer1.No_Prescaling, Timer1.Phase_Correct_PWM_ICR, Inverted => False);
		Timer1.Init_PWM_B (Timer1.No_Prescaling, Timer1.Phase_Correct_PWM_ICR, Inverted => False);
		
		-- Set top value
		MCU.ICR1 := 320;
		
		-- Initialize duty cycle in Output Compare Registers A and B
		MCU.OCR1A := 0;
		MCU.OCR1B := 0;
	end Initialize;
	
	function Duty_Cycle_To_Unsigned_16 (Duty : in Duty_Cycle)
												 return Unsigned_16 is
	begin
		return 0;
	end Duty_Cycle_To_Unsigned_16;

	function Unsigned_16_To_Duty_Cycle (Value : in Unsigned_16)
												 return Duty_Cycle is
	begin
		return 0;
	end Unsigned_16_To_Duty_Cycle;
	
	procedure Set_Duty_Cycle (Duty : in Duty_Cycle) is
	begin
		MCU.OCR1A := 0;
		MCU.OCR1B := 0;
	end Set_Duty_Cycle;
	
	procedure Get_Duty_Cycle (Duty : out Duty_Cycle) is
	begin
		null;
	end Get_Duty_Cycle;

end PWM_Controller;
