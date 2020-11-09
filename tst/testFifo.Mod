MODULE testFifo;

IMPORT fifo, Platform, Out;

VAR f: fifo.fifo;
    b: BOOLEAN;
    buf: ARRAY 64 OF CHAR;
BEGIN
  f := fifo.Create("aoe");
  IF f # NIL THEN
    Out.String("fifo created!"); Out.Ln;
    Platform.Delay(500);
      (*  b := fifo.Write(f, "helloooo");
      IF b THEN Out.String("write succesful") ELSE Out.String("write failed") END;
      Out.Ln*)
    IF fifo.SetNonBlocking(f) THEN
      Out.String("set non blocking successfully")
    ELSE
      Out.String("failed set not blocking")
    END;
    Out.Ln;
    Out.String("reading "); Out.Ln;
  
    REPEAT
      b := fifo.Read(f, buf);
      IF ~b THEN
        Out.String("nothing to read"); Out.Ln;
      ELSE
        Out.String("got "); Out.String(buf); Out.Ln;
      END;
      Platform.Delay(500);
    UNTIL buf = "bye";
  ELSE
    Out.String("fifo creation failed"); Out.Ln;
  END

END testFifo.
