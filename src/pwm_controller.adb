-- AVR PWM controller
with AVR; 				use AVR;
with AVR.MCU;
with AVR.Timer1;
with Interfaces; 	use Interfaces;
with AVRAda_RTS_Config;
with AVR.Wait;
with AVR.UART; 			use AVR.UART;

package body PWM_Controller is
	
	-- PWM output signal pins
	PB1         : Boolean renames MCU.DDRB_Bits (1);   -- pin 9
	PB2         : Boolean renames MCU.DDRB_Bits (2);   -- pin 10

	procedure Initialize (This : in out PWM_Fan_Controller) is
	begin
		-- set the PWM pins to output
		PB1 := DD_Output;
		PB2 := DD_Output;
		
		-- Initialize timers
		Timer1.Init_PWM (Timer1.No_Prescaling, Timer1.Phase_Correct_PWM_ICR, Inverted => False);
		-- Set compare mode on timer B
		Timer1.Set_Output_Compare_Mode_B_Non_Inverted;
		
		
		-- Set top value
		MCU.ICR1 := Duty_Top;
		
		-- Initialize duty cycle in Output Compare Registers A and B
		MCU.OCR1A := 0;
		MCU.OCR1B := 0;
	end Initialize;
	
	procedure Startup (This : in out PWM_Fan_Controller) is
		   procedure Wait_5_Sec is new
     AVR.Wait.Generic_Wait_USecs (AVRAda_Rts_Config.Clock_Frequency,
                                  5_000_000);
	begin
		Put ("Fan controller startup initiated.");
		New_Line;
		This.Set_Duty_Cycle (100);
		Wait_5_Sec;
		This.Set_Duty_Cycle (0);
		Put ("Fan controller startup completed.");
		New_Line;
	end Startup;
	
	
	procedure Set_Duty_Cycle (This : in out PWM_Fan_Controller;
									Duty : in Duty_Cycle) is
		function Duty_Cycle_To_Unsigned_16 (Duty : in Duty_Cycle)
													return Unsigned_16 is
		begin
			return (Unsigned_16 (Duty) * Duty_Top) / 100;
		end Duty_Cycle_To_Unsigned_16;

	begin
		This.PB_Duty := Duty;
		
		MCU.OCR1A := Duty_Cycle_To_Unsigned_16 (Duty);
		MCU.OCR1B := Duty_Cycle_To_Unsigned_16 (Duty);
		
		Put ("Duty cycle set to: ");
		Put (Unsigned_16 (Duty));
		New_Line;
	end Set_Duty_Cycle;
	
	procedure Get_Duty_Cycle (This : in out PWM_Fan_Controller;
									Duty : out Duty_Cycle) is
	begin
		Duty := This.PB_Duty;
	end Get_Duty_Cycle;

end PWM_Controller;
