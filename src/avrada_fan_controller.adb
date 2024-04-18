-- AVRAda PC fan controller

with AVR.UART; use AVR.UART;
with Avrada_Rts_Config;

procedure Avrada_Fan_Controller is
begin
   Init (Baud_19200_16MHz);

   Put ("Hello world!");
   New_Line;

end Avrada_Fan_Controller;
