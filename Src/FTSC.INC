type

  PackedMsgHeaderRec    = record
    MsgType,
    OrigNode,
    DestNode,
    OrigNet,
    DestNet,
    Attribute,
    Cost          : system.word;
    DateTime      : array[1..20] of char;
  end;


  PktHeaderRec    = record
    OrigNode,
    DestNode,
    Year,
    Month,
    Day,
    Hour,
    Minute,
    Second,
    Baud,
    PktType,
    OrigNet,
    DestNet       : system.word;
    ProdCode,
    SerialNo      : byte;
    Password      : array[1..8] of byte;
    OrigZone,
    DestZone      : system.word;
    FillArea      : array[1..8] of byte;
    OrigZoneGate,
    DestZoneGate,
    OrigPoint,
    DestPoint    : system.word;
    Mark         : array[1..4] of byte;
  end;

  _fido_fromtype    = array [0..35] of char;
  _fido_totype      = array [0..35] of char;
  _fido_subtype     = array [0..71] of char;
  _fido_datetype    = array [0..19] of char;

 _fidomsgtype = packed
    record
      from         : _fido_fromtype; (* 0 *)
      towhom       : _fido_totype;   (* 35 *)
      subject      : _fido_subtype;  (* 71 *)
      azdate       : _fido_datetype; (* 142 Obsolete/unused ASCII date information        *)
      timesread    : system.word;    (* 162 FIDO<tm>: Number of times read                *)
      dest_node    : system.word;    (* 164 Destination node                              *)
      orig_node    : system.word;    (* 166 Origination node number                       *)
      cost         : system.word;    (* 168 Unit cost charged to send the message         *)
      orig_net     : system.word;    (* 170 Origination network number                    *)
      dest_net     : system.word;    (* 172 Destination network number                    *)

      date_written : longint;        (* 176 When user wrote the msg              *)
      date_arrived : longint;        (* 180 When msg arrived on-line             *)
      reply        : system.word;    (* 184 Current msg is a reply to this msg number     *)
      attr         : system.word;    (* 186 Attribute (behavior) of the message           *)
      up           : system.word;    (* 188 Next message in the thread
 *) end;

  ExtFlags = (NoFlag, Dir, Imm, Locked, ZoneGate, HubHostRoute, Xmail, CnfmRcpReq,
              EraseFileSnt, ArchFileSnt, TruncFileSnt, ForcePickUp);

  const

    Pvt                  = $0001; {00}  {Личное     } {+   }
    Crash_               = $0002; {01}  {Особое     } {+  s}
    Recd                 = $0004; {02}  {Получено   }
    Sent_                = $0008; {03}  {Отослано   }
    FileAttached         = $0010; {04}  {С файлом   } {+   }
    InTransit            = $0020; {05}  {Транзитное }
    Orphan               = $0040; {06}  {Сирота     }
    KillSent             = $0080; {07}  {Удалить    }
    Local                = $0100; {08}  {Местное    }
    HoldForPickup        = $0200; {09}  {Задержано  }
    unused               = $0400; {10}                {+   }
    FileRequest          = $0800; {11}  {С запросом } {   s}
    ReturnReceiptRequest = $1000; {12}  {С уведомл. }
    IsReturnReceipt      = $2000; {13}  {Уведомл.   } { + s}
    AuditRequest         = $4000; {14}  {Переговоры } { + s}
    FileUpdateReq        = $8000; {15}  {Обновить   } {   s}

{s - не обязательно должен распознаваться, но допускается
 + - не обнуляется перед пакетированием}

  ExtFlag : array[ExtFlags] of string[3] =
    ('   ', 'DIR', 'IMM', 'LOK', 'ZON', 'HUB', 'XMA', 'CFM', 'KFS', 'A/S',
     'TFS', 'FPU');

  Month   : array[1..12] of string[3] =
    ('Jan', 'Fab', 'Mar', 'Apr', 'May', 'Jun',
     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
