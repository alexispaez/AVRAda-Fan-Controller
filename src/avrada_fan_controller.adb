-- AVRAda PC fan controller
-- The AVR microcontroller will control two PC PWM fans
-- Based on the temperature read from a MCP9808 sensor
-- The fans will do a startup to 100% duty cycle for five seconds
-- Then will fall down to 0% duty cycle and the temperature monitoring
-- will begin

with AVR.UART; use AVR.UART;
with Avrada_Rts_Config;

procedure Avrada_Fan_Controller is
begin
   Init (Baud_19200_16MHz);

   Put ("Hello world!");
   New_Line;

end Avrada_Fan_Controller;
