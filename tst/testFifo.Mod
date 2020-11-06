MODULE testFifo;

IMPORT fifo, Platform, Out;

VAR f: fifo.fifo;
    b: BOOLEAN;
BEGIN
(*fifo.setNonBlocking;*)
f := fifo.Create("aoe");
IF f # NIL THEN
  Out.String("fifo created!"); Out.Ln;
  Platform.Delay(5000);
  b := fifo.Write(f, "helloooo");
  IF b THEN Out.String("write succesful") ELSE Out.String("write failed") END;
  Out.Ln
ELSE
  Out.String("fifo creation failed"); Out.Ln;
END

END testFifo.
