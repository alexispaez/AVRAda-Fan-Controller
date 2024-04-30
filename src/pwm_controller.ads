-- AVR PWM controller

package PWM_Controller is

   type PWM_Fan_Controller is tagged limited private;

   type Duty_Cycle is range 0 .. 100;

   procedure Initialize;

   procedure Set_Duty_Cycle (Duty : in Duty_Cycle);
   procedure Get_Duty_Cycle (Duty : out Duty_Cycle);

private
   type PWM_Fan_Controller is tagged limited record
      PB_Duty     : Duty_Cycle;
      Initialized : Boolean;
   end record;

end PWM_Controller;
