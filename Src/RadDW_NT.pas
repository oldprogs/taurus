{

  Radius NT Directory Watcher

  Based on FnugryDirWatch Component
   Copyright (C) 1998 Gleb Yourchenko
}

{$A-,B-,I-,R-,X+}

{.$define PlatformCheck}  // Check platform before allocating
                         // DirWatch instance.


unit RadDW_NT;

interface
uses
   Windows, SysUtils, Classes, Messages, xbase{, syncobjs};

const

   FILE_ACTION_ADDED               = $00000001;
   FILE_ACTION_REMOVED             = $00000002;
   FILE_ACTION_MODIFIED            = $00000003;
   FILE_ACTION_RENAMED_OLD_NAME    = $00000004;
   FILE_ACTION_RENAMED_NEW_NAME    = $00000005;


type

   EDirWatchError = class(Exception);

   TDirWatchOption = (
      dw_file_name,
      dw_dir_name,
      dw_file_attr,
      dw_file_size,
      dw_file_write_date,
      dw_file_access_date,
      dw_file_creation_date,
      dw_file_security
   );

   TDirWatchOptions = set of TDirWatchOption;

   TFileChangeNotifyEvent = procedure(Sender :TObject;
      Action :Integer; const FileName :string) of object;

   TRadiusNTDirWatch = class(TComponent)
   private
      FWatchThread  :TThread;
      FOptions      :TDirWatchOptions;
      FWndHandle    :HWND;
      FErrorMsg     :String;
      FWatchSubtree :Boolean;
      FDirectory    :String;
      FOnChange     :TNotifyEvent;
      FOnNotify     :TFileChangeNotifyEvent;
      function GetEnabled :Boolean;
      procedure SetEnabled(const Value :Boolean);
      procedure SetOptions(const Value :TDirWatchOptions);
      procedure WatchWndProc(var M :TMessage);
      function MakeFilter :Cardinal;
      procedure SetWatchSubTree(const Value :Boolean);
      function GetDirectory :String;
      procedure SetDirectory(const Value :String);
      procedure EvWatchNotify(Sender :TObject);
      procedure EvWatchError(Sender :TObject);
   protected
      procedure AllocWatchThread;
      procedure ReleaseWatchThread;
      procedure RestartWatchThread;
      procedure CHange; virtual;
      procedure Notify(Action :Integer; const FileName :String); virtual;
   public
      constructor Create(AOwner :TComponent); override;
      destructor Destroy; override;
      function ActionName(Action :Integer):String;
      property ErrorMsg :String
        read FErrorMsg;
   published
      property Enabled :Boolean
        read GetEnabled write SetEnabled;
      property Options :TDirWatchOptions
        read FOptions write SetOptions;
      property WatchSubTree :Boolean
        read FWatchSubTree write SetWatchSubTree;
      property Directory :String
        read GetDirectory write SetDirectory;
      property OnChange :TNotifyEvent
        read FOnChange write FOnChange;
      property OnNotify :TFileChangeNotifyEvent
        read FOnNotify write FOnNotify;
   end;


procedure Register;

implementation

uses
   forms;



procedure Register;
begin
   RegisterComponents('Argus', [TRadiusNTDirWatch]);
end;

{ Types & constants from winnt.h not
  included in windows.pas: }

type

  LPOVERLAPPED_COMPLETION_ROUTINE = procedure (
    dwErrorCode :Longint;
    dwNumberOfBytesTransfered :Longint;
    lpOverlapped :POverlapped); stdcall;

  TReadDirectoryChangesWProc = function(
    hDirectory :THandle; lpBuffer :Pointer;
    nBufferLength :Longint; bWatchSubtree :Bool;
    dwNotifyFilter :Longint; var lpBytesReturned :Longint;
    lpOverlapped :POVERLAPPED;
    lpCompletionRoutine :LPOVERLAPPED_COMPLETION_ROUTINE):Bool; stdcall;


   PFILE_NOTIFY_INFORMATION = ^TFILE_NOTIFY_INFORMATION;
   TFILE_NOTIFY_INFORMATION = record
     NextEntryOffset :Longint;
     Action          :Longint;
     FileNameLength  :Longint;
     FileName        :array[0..MAX_PATH-1] of WideChar;
   end;

   

const

   WM_DIRWATCH_ERROR    = WM_USER + 137;
   WM_DIRWATCH_NOTIFY   = WM_USER + 138;

   FILE_NOTIFY_CHANGE_FILE_NAME    = $00000001;
   FILE_NOTIFY_CHANGE_DIR_NAME     = $00000002;
   FILE_NOTIFY_CHANGE_ATTRIBUTES   = $00000004;
   FILE_NOTIFY_CHANGE_SIZE         = $00000008;
   FILE_NOTIFY_CHANGE_LAST_WRITE   = $00000010;
   FILE_NOTIFY_CHANGE_LAST_ACCESS  = $00000020;
   FILE_NOTIFY_CHANGE_CREATION     = $00000040;
   FILE_NOTIFY_CHANGE_SECURITY     = $00000100;


   FILE_LIST_DIRECTORY             = $0001;


{ Error messages: }

const

   m_err_platform     = 'TRadiusNTDirWatch requires MS Windows NT Version 4 or higher';
   m_err_opendir      = 'Could not open directory "%s"'#13#10'Error code: %d';
   m_err_link         = 'Could not find procedure "%s" in module "%s"';
   m_err_readchanges  = 'ReadDirectoryChanges call failed.';
   m_err_getresult    = 'GetOverlappedResult call failed';
   
{ TDirWatchThread }

const

  szKernel32 = 'kernel32';
  szReadDirectoryChangesW = 'ReadDirectoryChangesW';

const

  IO_BUFFER_LEN = 32*sizeof(TFILE_NOTIFY_INFORMATION);
  
type

  CException = class of Exception;

  TDirWatchThread = class(TThread)
  private
     FWatchSubTree :Bool;
     FIOResult     :Pointer;
     FIOResultLen  :cardinal;
     FDirHandle    :THandle;
     FDirectory    :String;
     FFilter       :Cardinal;
     FErrorClass   :TClass;
     FErrorMsg     :String;
     FOnError      :TNotifyEvent;
     FOnNotify     :TNotifyEvent;
     FCompletionEvent : THandle;
     FKernelHandle    :Thandle;
     FReadDirectoryChangesProc :TReadDirectoryChangesWProc;
  protected
     procedure Execute; override;
     procedure DoError;
     procedure DoNotify;
  public
     constructor Create(const aDir :String; aFilter :Cardinal;
       aWatchSubTree :Bool; aNotifyProc, aErrorProc :TNotifyEvent);
     destructor Destroy; override;
     procedure ClearError;
     property ErrorClass :TClass
        read FErrorClass;
     property ErrorMsg :String
        read FErrorMsg;
     property OnError :TNotifyEvent
        read FOnError write FOnError;
     property OnNotify :TNotifyEvent
        read FOnNotify write FOnNotify;
     property IOResult :Pointer
        read FIOResult;
  end;


procedure TDirWatchThread.ClearError;
begin
   FErrorMsg := '';
   FErrorClass := Nil;
end;

procedure TDirWatchThread.DoError;
begin
   if assigned(FOnError) then
      FOnError(Self);
end;

procedure TDirWatchThread.DoNotify;
begin
   if assigned(FOnNotify) then
      FOnNotify(Self);
end;


procedure TDirWatchThread.Execute;
var
   Overlapped :TOVERLAPPED;
   WaitResult :DWORD;
begin

   while not terminated do
   try
      //
      // Do nothing if an error occured.
      // (Waiting for owner to release the
      // thread or clear error state)
      //
      if assigned(FErrorClass) then
         begin
            sleep(0);
            continue;
         end;
      //
      //

      fillchar(overlapped, sizeof(overlapped), 0);
      FCompletionEvent := CreateEvent(nil, False, False, PCHAR('RadiusComplitionEvent'));
      ResetEvent(FCompletionEvent);
      overlapped.hEvent := FCompletionEvent;

      if not FReadDirectoryChangesProc(FDirHandle,
        FIOResult, IO_BUFFER_LEN, FWatchSubtree,
        FFilter, integer(FIOResultLen), @Overlapped, nil) then
        raise EDirWatchError.Create(m_err_readchanges);

      repeat
         WaitResult := WaitForSingleObject(FCompletionEvent, 100);

         if WaitResult = WAIT_OBJECT_0 then
            begin
               //
               // retrieve overlapped result
               // and generate Notify event
               //
               if not GetOverlappedResult(FDirHandle,
                  Overlapped, FIOResultLen, true) then
                  raise EDirWatchError.Create(m_err_getresult);

               DoNotify;
               
            end;

      until terminated or (WaitResult <> WAIT_TIMEOUT);

   except
      on E :Exception do
         begin
            FErrorClass := E.ClassType;
            FErrorMsg := E.Message;
            DoError;
         end
      else
         raise;
   end;

end;

constructor TDirWatchThread.Create(const aDir :String;
  aFilter :Cardinal; aWatchSubTree :Bool; aNotifyProc,
  aErrorProc :TNotifyEvent);
begin

   //
   // Retrieve proc pointer, open directory to
   // watch and allocate buffer for notification data.
   // (note, it is done before calling inherited
   // create (that calls BeginThread) so any exception
   // will be still raised in caller's thread)
   //
   FKernelHandle := LoadLibrary(szKernel32);
   assert(FKernelHandle <> 0);

   FReadDirectoryChangesProc := GetProcAddress(
     FKernelHandle, szReadDirectoryChangesW);

   if not assigned(FReadDirectoryChangesProc) then
      raise EDirWatchError.CreateFmt(m_err_link,
        [szReadDirectoryChangesW, szKernel32]);

   FDirHandle := CreateFile(
      PChar(aDir),
      FILE_LIST_DIRECTORY,
      FILE_SHARE_READ OR FILE_SHARE_DELETE OR FILE_SHARE_WRITE,
      Nil, OPEN_EXISTING,
      FILE_FLAG_BACKUP_SEMANTICS OR FILE_FLAG_OVERLAPPED,
      0
   );

   if FDirHandle = INVALID_HANDLE_VALUE then
      raise EDirWatchError.CreateFmt(
         m_err_opendir, [aDir, GetLastError]);

   GetMem(FIOResult, IO_BUFFER_LEN);

   inherited Create(true);

   FOnError := aErrorProc;
   FOnNotify := aNotifyProc;
   FFilter := aFilter;
   FWatchSubTree := aWatchSubtree;
   FDirectory := aDir;
   FreeOnTerminate := false;
   FCompletionEvent := OpenEvent(EVENT_MODIFY_STATE, False, PCHAR('RadiusComplitionEvent'));

   //
   // Start the thread
   //

   Resume;
end;


destructor TDirWatchThread.Destroy;
begin
   Terminate;
   WaitFor;
   if FCompletionEvent <> INVALID_HANDLE_VALUE then
      CloseHandle(FCompletionEvent);
   if FDirHandle <> INVALID_HANDLE_VALUE  then
      CloseHandle(FDirHandle);
   if assigned(FIOResult) then
      FreeMem(FIOResult);
   if FKernelHandle <> 0 then
      FreeLibrary(FKernelHandle);
   inherited Destroy;
end;

{ TRadiusNTDirWatch }

procedure TRadiusNTDirWatch.AllocWatchThread;
begin
   assert(FWatchThread = Nil);
   FWatchThread := TDirWatchThread.Create(Directory,
     MakeFilter, WatchSubtree, EvWatchNotify, EvWatchError);
end;

procedure TRadiusNTDirWatch.ReleaseWatchThread;
begin
   assert(assigned(FWatchThread));
   FWatchThread.Free;
   FWatchThread := Nil;
end;

procedure TRadiusNTDirWatch.RestartWatchThread;
begin
   Enabled := false;
   Enabled := true;
end;


function TRadiusNTDirWatch.GetEnabled :Boolean;
begin
   result := assigned(FWatchThread);
end;

procedure TRadiusNTDirWatch.SetEnabled(const Value :Boolean);
begin
   if Value <> Enabled then
      begin
        if Value then
           AllocWatchThread
        else
           ReleaseWatchThread;
        Change;
      end;
end;

destructor TRadiusNTDirWatch.Destroy;
begin
   Enabled := false;
   if FWndHandle <> 0 then
      DeallocateHWnd(FWndHandle);
   inherited Destroy;
end;

constructor TRadiusNTDirWatch.Create(AOwner :TComponent);
begin
   {$ifdef PlatformCheck}
   if (Win32Platform <> VER_PLATFORM_WIN32_NT) then
      raise EDirWatchError.Create(m_err_platform);
   {$endif}
   inherited Create(AOwner);
   FWndHandle := AllocateHWnd(WatchWndProc);
   FOptions := [dw_file_name, dw_dir_name, dw_file_size,
      dw_file_attr, dw_file_creation_date, dw_file_access_date,
      dw_file_write_date, dw_file_security];
   FWatchSubtree := true;
end;



procedure TRadiusNTDirWatch.SetOptions(const Value :TDirWatchOptions);
begin
   if FOptions <> Value then
      begin
         FOptions := Value;
         if Enabled then RestartWatchThread;
         Change;
      end;
end;

procedure TRadiusNTDirWatch.WatchWndProc(var M :TMessage);
var
   ErrorClass :CException;
begin
   case m.msg of

     WM_DIRWATCH_NOTIFY   :
     //
     // Retrieve notify data and forward
     // the event to TRadiusNTDirWatch's notify
     // handler. Free filename string (allocated
     // in WatchThread's notify handler.)
     //
     begin
        try
           Notify(m.wParam, WideCharToString(PWideChar(m.lParam)));
        finally
           if m.lParam <> 0 then
              FreeMem(Pointer(m.lParam));
        end;
     end;

     WM_DIRWATCH_ERROR   :
     //
     // Disable dir watch and re-raise
     // exception on error
     //
     begin
        ErrorClass := CException(m.lParam);
        assert(assigned(ErrorClass));
        Enabled := false;
        raise ErrorClass.Create(ErrorMsg);
     end;
   end;
end;

function TRadiusNTDirWatch.MakeFilter :Cardinal;
const
   FilterFlags :array[TDirWatchOption] of Integer = (
      FILE_NOTIFY_CHANGE_FILE_NAME,
      FILE_NOTIFY_CHANGE_DIR_NAME,
      FILE_NOTIFY_CHANGE_ATTRIBUTES,
      FILE_NOTIFY_CHANGE_SIZE,
      FILE_NOTIFY_CHANGE_LAST_WRITE,
      FILE_NOTIFY_CHANGE_LAST_ACCESS,
      FILE_NOTIFY_CHANGE_CREATION,
      FILE_NOTIFY_CHANGE_SECURITY);
var
   f :TDirWatchOption;
begin
   result := 0;
   for f := low(TDirWatchOption) to high(TDirWatchOption) do
     if f in FOptions then
        result := result or dword(FilterFlags[f]);
end;

procedure TRadiusNTDirWatch.EvWatchNotify(Sender :TObject);
var
   NotifyData :PFILE_NOTIFY_INFORMATION;
   FileName   :PWideChar;
   NextEntry  :Integer;
begin
   assert(Sender is TDirWatchThread);
   NotifyData := TDirWatchThread(Sender).IOResult;
   repeat
      FileName := nil;
      if NotifyData^.FileNameLength > 0 then
         begin
            GetMem(FileName, NotifyData^.FileNameLength + 2);
            move(NotifyData^.FileName, Pointer(FileName)^, NotifyData^.FileNameLength);
            PWord(Integer(FileName)+NotifyData^.FileNameLength)^ := 0;
         end;
      PostMessage(FWndHandle, WM_DIRWATCH_NOTIFY, NotifyData^.Action, LPARAM(FileName));
      NextEntry := NotifyData^.NextEntryOffset;
      inc(longint(NotifyData), NextEntry);
   until (NextEntry = 0);
end;


procedure TRadiusNTDirWatch.EvWatchError(Sender :TObject);
begin
   assert(Sender is TDirWatchThread);
   FErrorMsg := TDirWatchThread(Sender).ErrorMsg;
   PostMessage(FWndHandle, WM_DIRWATCH_ERROR, 0,
     LPARAM(TDirWatchThread(Sender).ErrorClass));
end;

procedure TRadiusNTDirWatch.SetWatchSubTree(const Value :Boolean);
begin
   if Value <> FWatchSubtree then
      begin
        FWatchSubtree := Value;
        if Enabled then RestartWatchThread;
        Change;
      end;
end;


function TRadiusNTDirWatch.GetDirectory :String;
begin
   result := FDirectory;
   if result = '' then result := '.\';
end;

procedure TRadiusNTDirWatch.SetDirectory(const Value :String);
begin
   if stricomp(PChar(trim(Value)), PChar(FDirectory)) <> 0 then
      begin
         FDirectory := trim(Value);
         if Enabled then RestartWatchThread;
         Change;
      end;
end;

procedure TRadiusNTDirWatch.CHange;
begin
  if assigned(FOnChange) then FOnChange(Self);
end;

procedure TRadiusNTDirWatch.Notify(
 Action :Integer; const FileName :String);
begin
  if assigned(FOnNotify) then
     FOnNotify(Self, Action, FileName);
end;


function TRadiusNTDirWatch.ActionName(Action :Integer):String;
const
   ActionNames :array[FILE_ACTION_ADDED..FILE_ACTION_RENAMED_NEW_NAME] of string = (
     'FILE_ACTION_ADDED', 'FILE_ACTION_REMOVED', 'FILE_ACTION_MODIFIED',
     'FILE_ACTION_RENAMED_OLD_NAME', 'FILE_ACTION_RENAMED_NEW_NAME');
begin
    if Action in [FILE_ACTION_ADDED..FILE_ACTION_RENAMED_NEW_NAME] then
       result := ActionNames[Action]
    else
       result := 'FILE_ACTION_UNKNOWN';
end;


end.
