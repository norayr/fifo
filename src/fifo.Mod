MODULE fifo;
IMPORT SYSTEM, Platform, Strings;

TYPE
  fifo* = POINTER TO fifoDesc;
  fifoDesc* = RECORD
        fd-  : Platform.FileHandle;
      name- : ARRAY 32 OF CHAR
  END;
(*
PROCEDURE -inclSignal "#include <signal.h>";
PROCEDURE -ignPipe "signal(SIGPIPE, SIG_IGN)";
*)
PROCEDURE -inclUnistd "#include <unistd.h>";
PROCEDURE -mkfifo(VAR name: ARRAY OF CHAR): LONGINT
  "(LONGINT)mkfifo (name, 0666)";
PROCEDURE -unlink(VAR name: ARRAY OF CHAR): LONGINT
  "(LONGINT)unlink (name)";

PROCEDURE -inclFcntl() "#include <fcntl.h>"; (* for O_NONBLOCK *)

PROCEDURE -getFlags(VAR fd: LONGINT): LONGINT
  "(LONGINT)fcntl( *fd, F_GETFL)";

(* here be careful with the parentheses and the following asterisk, it is interpreted as an open comment by oberon parser *)

PROCEDURE -setNonBlocking(VAR fd: LONGINT; flags: LONGINT): LONGINT
  "(LONGINT)fcntl( *fd, F_SETFL, flags| O_NONBLOCK)";

PROCEDURE SetNonBlocking*(VAR f: fifo): BOOLEAN;
VAR
  currentFlags, res: LONGINT;
BEGIN
  currentFlags := getFlags(f^.fd);
  IF currentFlags # -1 THEN
    res := setNonBlocking(f^.fd, currentFlags);
    IF res = -1 THEN RETURN FALSE ELSE RETURN TRUE END;
  ELSE
    RETURN FALSE
  END;
END SetNonBlocking;

(*
PROCEDURE -opn(VAR name: ARRAY OF CHAR): LONGINT
  "(LONGINT)open(name, O_RDWR | O_NONBLOCK)";
*)

PROCEDURE Create*(name: ARRAY OF CHAR): fifo;
VAR
  i: LONGINT;
  f: fifo;
BEGIN
  f := NIL;
  i := mkfifo(name); 
  IF i = 0 THEN
    NEW(f);
    i := Platform.OldRW(name, f^.fd);
    (*f^.fd := opn(name);*)
    COPY(name, f^.name);
  END;
  RETURN f;
END Create;

PROCEDURE Destroy*(VAR f: fifo): BOOLEAN;
VAR
  i : LONGINT;
BEGIN
  i := unlink(f^.name);
  IF i = 0 THEN
    f := NIL;
    RETURN TRUE
  ELSE
    RETURN FALSE
  END
END Destroy;

PROCEDURE Write*(VAR f: fifo; msg: ARRAY OF CHAR): BOOLEAN;
VAR
  adr: SYSTEM.ADDRESS;
  len: LONGINT;
  res: INTEGER;
BEGIN
  adr := SYSTEM.ADR(msg[0]);
  len := Strings.Length(msg);
  res := Platform.Write(f^.fd, adr, len);
  IF res = 0 THEN
    res := Platform.Sync(f^.fd);
    RETURN TRUE
  ELSE
    RETURN FALSE
  END
END Write;

PROCEDURE Read*(VAR f: fifo; VAR msg: ARRAY OF CHAR): BOOLEAN;
VAR
  adr: SYSTEM.ADDRESS;
l, n: LONGINT;
  res: INTEGER;
BEGIN
  COPY("", msg);
  adr := SYSTEM.ADR(msg[0]);
  l := LEN(msg)-1;
  n := 0;
  res := Platform.Read(f^.fd, adr, l, n);
  IF (res = -1) OR (msg = "") THEN RETURN FALSE ELSE RETURN TRUE END
END Read;

END fifo.
