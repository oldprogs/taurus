{**************************************************************************************************}
{                                                                                                  }
{ Project JEDI Code Library (JCL)                                                                  }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is JclResources.pas.                                                           }
{                                                                                                  }
{ The Initial Developer of the Original Code is documented in the accompanying                     }
{ help file JCL.chm. Portions created by these individuals are Copyright (C) of these individuals. }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Unit which provides a central place for all resource strings used in the JCL                     }
{                                                                                                  }
{ Unit owner: Marcel van Brakel                                                                    }
{ Last modified: September 5, 2002                                                                 }
{                                                                                                  }
{**************************************************************************************************}

unit JclResources;

{$I jcl.inc}

{$WEAKPACKAGEUNIT ON}

interface

//--------------------------------------------------------------------------------------------------
// JclBase
//--------------------------------------------------------------------------------------------------

resourcestring
  RsWin32Prefix        = 'Win32: %s (%u)';
  RsDynArrayError      = 'DynArrayInitialize: ElementSize out of bounds';
  RsSysErrorMessageFmt = 'Win32 Error %d (%x)';

//--------------------------------------------------------------------------------------------------
// JclClasses
//--------------------------------------------------------------------------------------------------

resourcestring
  RsVMTMemoryWriteError = 'Error writing VMT memory (%s)';

//--------------------------------------------------------------------------------------------------
// JclCOM
//--------------------------------------------------------------------------------------------------

resourcestring
  RsComInvalidParam      = 'An invalid parameter was passed to the routine. If a parameter was' +
   ' expected, it might be an unassigned item or nil pointer';
  RsComFailedStreamRead  = 'Failed to read all of the data from the specified stream';
  RsComFailedStreamWrite = 'Failed to write all of the data into the specified stream';

//--------------------------------------------------------------------------------------------------
// JclComplex
//--------------------------------------------------------------------------------------------------

resourcestring
  RsComplexInvalidString = 'Failed to create a complex number from the string provided';

//--------------------------------------------------------------------------------------------------
// JclConsole
//--------------------------------------------------------------------------------------------------

resourcestring
  RsCannotRaiseSignal = 'Cannot raise %s signal.';

//--------------------------------------------------------------------------------------------------
// JclCounter
//--------------------------------------------------------------------------------------------------

resourcestring
  RsNoCounter = 'No high performance counters supported';

//--------------------------------------------------------------------------------------------------
// JclDateTime
//--------------------------------------------------------------------------------------------------

resourcestring
  RsMakeUTCTime    = 'Error converting to UTC time. Time zone could not be determined';
  RsDateConversion = 'Error illegal date or time format';

//--------------------------------------------------------------------------------------------------
// JclDebug
//--------------------------------------------------------------------------------------------------

  // Diagnostics

resourcestring
  RsDebugAssertValidPointer = 'Invalid Pointer passed to AssertValid';
  RsDebugAssertValidString  = 'Invalid string passed to AssertValid';

  // TMapFiles

  RsDebugMapFileExtension = '.map'; // do not localize
  RsDebugNoProcessInfo    = 'Unable to obtain process information';
  RsDebugSnapshot         = 'Failure creating toolhelp32 snapshot';

//--------------------------------------------------------------------------------------------------
// JclEDI
//--------------------------------------------------------------------------------------------------

resourcestring
  EDIError001 = 'Could not set interchange at index [%s], Index too high.';
  EDIError002 = 'Could not set interchange at index [%s], Index too low.';
  EDIError003 = 'Could not set interchange at index [%s].';
  EDIError004 = 'Could not save edi file.  File name and path not specified.';
  EDIError005 = 'Could not save edi file.  File name and path not specified.';
  EDIError006 = 'Could not open edi file.  File not specified.';
  EDIError007 = 'Could not get interchange at index [%s], Interchanges does not exist.';
  EDIError008 = 'Could not get interchange at index [%s], Index too high.';
  EDIError009 = 'Could not get interchange at index [%s], Index too low.';
  EDIError010 = 'Could not get interchanges at index [%s], There were no interchanges to get.';
  EDIError011 = 'Could not find interchange control header.';
  EDIError012 = 'Could not find interchange control trailer segment terminator.';
  EDIError013 = 'Could not find interchange control trailer.';
  EDIError014 = 'Could not find interchange control trailer or garbage at end of file.';
  EDIError015 = 'Could not delete interchanges at index [%s].';
  EDIError016 = 'Could not delete interchange at index [%s].';
  EDIError017 = 'Could not set functional group at index [%s], Index too high.';
  EDIError018 = 'Could not set functional group at index [%s], Index too low.';
  EDIError019 = 'Could not set functional group at index [%s].';
  EDIError020 = 'Could not get functional group at index [%s], Functional Group does not exist.';
  EDIError021 = 'Could not get functional group at index [%s], Index too high.';
  EDIError022 = 'Could not get functional group at index [%s], Index too low.';
  EDIError023 = 'Could not get functional group at index [%s], There were no functional groups to get.';
  EDIError024 = 'Delimiters have not been assigned to interchange.  Dissassemble cancelled.';
  EDIError025 = 'Could not find interchange control header segment terminator.';
  EDIError026 = 'Could not find interchange control header.';
  EDIError027 = 'Could not find functional group header.';
  EDIError028 = 'Could not find functional group trailer segment terminator.';
  EDIError029 = 'Could not find functional group trailer.';
  EDIError030 = 'Could not find interchange control trailer segment terminator.';
  EDIError031 = 'Could not find interchange control trailer.';
  EDIError032 = 'Could not delete functional groups at index [%s].';
  EDIError033 = 'Could not delete functional group at index [%s].';
  EDIError034 = 'Delimiters have not been assigned to interchange.  Assemble cancelled.';
  EDIError035 = 'Could not set transaction set at index [%s], Index too high.';
  EDIError036 = 'Could not set transaction set at index [%s], Index too low.';
  EDIError037 = 'Could not set transaction set at index [%s].';
  EDIError038 = 'Could not get transaction set at index [%s], Transaction Set does not exist.';
  EDIError039 = 'Could not get transaction set at index [%s], Index too high.';
  EDIError040 = 'Could not get transaction set at index [%s], Index too low.';
  EDIError041 = 'Could not get transaction set at index [%s], There were no Transaction Sets to get.';
  EDIError042 = 'Could not assign delimiters to functional group.  Dissassemble cancelled.';
  EDIError043 = 'Could not find functional group header segment terminator.';
  EDIError044 = 'Could not find functional group header.';
  EDIError045 = 'Could not find transaction set header.';
  EDIError046 = 'Could not find transaction set trailer segment terminator.';
  EDIError047 = 'Could not find transaction set trailer.';
  EDIError048 = 'Could not find functional group trailer segment terminator.';
  EDIError049 = 'Could not find functional group trailer..';
  EDIError050 = 'Could not delete transaction sets at index [%s].';
  EDIError051 = 'Could not delete transaction set at index [%s].';
  EDIError052 = 'Could not assign delimiters to functional group.  Assemble cancelled.';
  EDIError053 = 'Could not set segment at index [%s], Index too high.';
  EDIError054 = 'Could not set segment at index [%s], Index too low.';
  EDIError055 = 'Could not set segment at index [%s].';
  EDIError056 = 'Could not get segment at index [%s], Segment does not exist.';
  EDIError057 = 'Could not get segment at index [%s], Index too high.';
  EDIError058 = 'Could not get segment at index [%s], Index too low.';
  EDIError059 = 'Could not get segment at index [%s], There were no segments to get.';
  EDIError060 = 'Could not assign delimiters to transaction set.  Dissassemble cancelled.';
  EDIError061 = 'Could not delete segment at index [%s].';
  EDIError062 = 'Could not delete segment at index [%s].';
  EDIError063 = 'Could not assign delimiters to transaction set.  Assemble cancelled.';
  EDIError064 = 'Could not set element at index [%s], Index too high.';
  EDIError065 = 'Could not set element at index [%s], Index too low.';
  EDIError066 = 'Could not set element at index [%s].';
  EDIError067 = 'Could not get element at index [%s], Element does not exist.';
  EDIError068 = 'Could not get element at index [%s], Index too high.';
  EDIError069 = 'Could not get element at index [%s], Index too low.';
  EDIError070 = 'Could not get element at index [%s], There were no elements to get.';
  EDIError071 = 'Could not assign delimiters to segment.  Dissassemble cancelled.';
  EDIError072 = 'Could not delete element at index [%s].';
  EDIError073 = 'Could not delete element at index [%s].';
  EDIError074 = 'Could not assign delimiters to segment.  Assemble cancelled.';

//--------------------------------------------------------------------------------------------------
// JclExprEval
//--------------------------------------------------------------------------------------------------

resourcestring
  RsExprEvalRParenExpected = 'Parse error: '')'' expected';
  RsExprEvalFactorExpected = 'Parse error: Factor expected';
  RsExprEvalUnknownSymbol = 'Parse error: Unknown symbol: ''%s''';

  RsExprEvalFirstArg = 'Parse error: ''('' and function''s first parameter expected';
  RsExprEvalNextArg = 'Parse error: '','' and another parameter expected';
  RsExprEvalEndArgs = 'Parse error: '')'' to close function''s parameters expected';

  RsExprEvalExprNotFound = 'Expression compiler error: Expression ''%s'' not found';
  RsExprEvalExprPtrNotFound = 'Expression compiler error: Expression pointer not found';


//--------------------------------------------------------------------------------------------------
// JclStrHashMap
//--------------------------------------------------------------------------------------------------

resourcestring
  RsStringHashMapMustBeEmpty = 'HashList: must be empty to set size to zero';
  RsStringHashMapDuplicate = 'Duplicate hash list entry: %s';
  RsStringHashMapInvalidNode = 'Tried to remove invalid node: %s';


//--------------------------------------------------------------------------------------------------
// JclFileUtils
//--------------------------------------------------------------------------------------------------

resourcestring

  // Path manipulation

  RsPathInvalidDrive = '%s is not a valid drive';

  // Files and directories

  RsFileUtilsAttrUnavailable = 'Unable to retrieve attributes of %s';

  RsCannotCreateDir = 'Unable to create directory';

  // TJclFileVersionInfo

  RsFileUtilsNoVersionInfo = 'File contains no version information';
  RsFileUtilsLanguageIndex = 'Illegal language index';

  // Strings returned from OSIdentTOString()

  RsVosUnknown      = 'Unknown';
  RsVosDos          = 'MS-DOS';
  RsVosOS216        = '16-bit OS/2';
  RsVosOS232        = '32-bit OS/2';
  RsVosNT           = 'Windows NT';
  RsVosWindows16    = '16-bit Windows';
  RsVosPM16         = '16-bit PM';
  RsVosPM32         = '32-bit PM';
  RsVosWindows32    = '32-bit Windows';
  RsVosDosWindows16 = '16-bit Windows, running on MS-DOS';
  RsVosDosWindows32 = 'Win32 API, running on MS-DOS';
  RsVosOS216PM16    = '16-bit PM, running on 16-bit OS/2';
  RsVosOS232PM32    = '32-bit PM, running on 32-bit OS/2';
  RsVosNTWindows32  = 'Win32 API, running on Windows/NT';
  RsVosDesignedFor  = 'Designed for ';

  // Strings returned from OSFileTypeToString()

  RsVftUnknown         = 'Unknown';
  RsVftApp             = 'Application';
  RsVftDll             = 'Library';
  RsVftDrv             = 'Driver';
  RsVftFont            = 'Font';
  RsVftVxd             = 'Virtual device';
  RsVftStaticLib       = 'Static-link library';
  RsVft2DrvPRINTER     = 'Printer';
  RsVft2DrvKEYBOARD    = 'Keyboard';
  RsVft2DrvLANGUAGE    = 'Language';
  RsVft2DrvDISPLAY     = 'Display';
  RsVft2DrvMOUSE       = 'Mouse';
  RsVft2DrvNETWORK     = 'Network';
  RsVft2DrvSYSTEM      = 'System';
  RsVft2DrvINSTALLABLE = 'Installable';
  RsVft2DrvSOUND       = 'Sound';
  RsVft2DrvCOMM        = 'Communications';
  RsVft2FontRASTER     = 'Raster';
  RsVft2FontVECTOR     = 'Vector';
  RsVft2FontTRUETYPE   = 'TrueType';

  // TJclFileStream

  RsFileStreamCreate         = 'Unable to create temporary file stream';

  // TJclFileMapping

  RsCreateFileMapping        = 'Failed to create FileMapping';
  RsCreateFileMappingView    = 'Failed to create FileMappingView';
  RsLoadFromStreamSize       = 'Not enough space in View in procedure LoadFromStream';
  RsFileMappingInvalidHandle = 'Invalid file handle';
  RsViewNeedsMapping         = 'FileMap argument of TJclFileMappingView constructor cannot be nil';
  RsFailedToObtainSize       = 'Failed to obtain size of file';

  // GetDriveTypeStr()

  RsUnknownDrive   = 'Unknown drive type';
  RsRemovableDrive = 'Removable Drive';
  RsHardDisk       = 'Hard Disk';
  RsRemoteDrive    = 'Remote Drive';
  RsCDRomDrive     = 'CD-ROM';
  RsRamDisk        = 'RAM-Disk';

  // GetFileAttributeList()

  RsAttrDirectory  = 'Directory';
  RsAttrReadOnly   = 'ReadOnly';
  RsAttrSystemFile = 'SystemFile';
  RsAttrVolumeID   = 'Volume ID';
  RsAttrArchive    = 'Archive';
  RsAttrAnyFile    = 'AnyFile';
  RsAttrHidden     = 'Hidden';

  // GetFileAttributeListEx()

  RsAttrNormal       = 'Normal';
  RsAttrTemporary    = 'Temporary';
  RsAttrCompressed   = 'Compressed';
  RsAttrOffline      = 'Offline';
  RsAttrEncrypted    = 'Encrypted';
  RsAttrReparsePoint = 'Reparse Point';
  RsAttrSparseFile   = 'Sparse';

  // TJclFileMapping.Create

  RsFileMappingOpenFile = 'Unable to open the file';

  // TJclMappedTextReader

  RsFileIndexOutOfRange = 'Index of out range';

  // FileGetTypeName()

  RsDefaultFileTypeName = ' File';

//--------------------------------------------------------------------------------------------------
// JclGraphics, JclGraphUtils
//--------------------------------------------------------------------------------------------------

resourcestring
  RsAssertUnpairedEndUpdate  = 'Unpaired BeginUpdate EndUpdate';
  RsCreateCompatibleDc       = 'Could not create compatible DC';
  RsDestinationBitmapEmpty   = 'Destination bitmap is empty';
  RsDibHandleAllocation      = 'Could not allocate handle for DIB';
  RsMapSizeFmt               = 'Could not set size on class "%s"';
  RsSelectObjectInDc         = 'Could not select object in DC';
  RsSourceBitmapEmpty        = 'Source bitmap is empty';
  RsSourceBitmapInvalid      = 'Source bitmap is invalid';
  RsNoBitmapForRegion        = 'No bitmap for region';
  RsNoDeviceContextForWindow = 'Cannot get device context of the window';
  RsInvalidRegion            = 'Invalid Region defined for RegionInfo';
  RsRegionDataOutOfBound     = 'Out of bound index on RegionData';
  RsRegionCouldNotCreated    = 'Region could not be created';
  RsInvalidHandleForRegion   = 'Invalid handle for region';
  RsInvalidRegionInfo        = 'Invalid RegionInfo';

  RsBitmapExtension          = '.bmp';
  RsJpegExtension            = '.jpg';

//--------------------------------------------------------------------------------------------------
// JclMapi
//--------------------------------------------------------------------------------------------------

resourcestring
  RsMapiError         = 'MAPI Error: (%d) "%s"';
  RsMapiMissingExport = 'Function "%s" is not exported by client';
  RsMapiInvalidIndex  = 'Index is out ot range';
  RsMapiMailNoClient  = 'No Simple MAPI client installed, cannot send the message';

  RsMapiErrUSER_ABORT               = 'User abort';
  RsMapiErrFAILURE                  = 'General MAPI failure';
  RsMapiErrLOGIN_FAILURE            = 'MAPI login failure';
  RsMapiErrDISK_FULL                = 'Disk full';
  RsMapiErrINSUFFICIENT_MEMORY      = 'Insufficient memory';
  RsMapiErrACCESS_DENIED            = 'Access denied';
  RsMapiErrTOO_MANY_SESSIONS        = 'Too many sessions';
  RsMapiErrTOO_MANY_FILES           = 'Too many files were specified';
  RsMapiErrTOO_MANY_RECIPIENTS      = 'Too many recipients were specified';
  RsMapiErrATTACHMENT_NOT_FOUND     = 'A specified attachment was not found';
  RsMapiErrATTACHMENT_OPEN_FAILURE  = 'Attachment open failure';
  RsMapiErrATTACHMENT_WRITE_FAILURE = 'Attachment write failure';
  RsMapiErrUNKNOWN_RECIPIENT        = 'Unknown recipient';
  RsMapiErrBAD_RECIPTYPE            = 'Bad recipient type';
  RsMapiErrNO_MESSAGES              = 'No messages';
  RsMapiErrINVALID_MESSAGE          = 'Invalid message';
  RsMapiErrTEXT_TOO_LARGE           = 'Text too large';
  RsMapiErrINVALID_SESSION          = 'Invalid session';
  RsMapiErrTYPE_NOT_SUPPORTED       = 'Type not supported';
  RsMapiErrAMBIGUOUS_RECIPIENT      = 'A recipient was specified ambiguously';
  RsMapiErrMESSAGE_IN_USE           = 'Message in use';
  RsMapiErrNETWORK_FAILURE          = 'Network failure';
  RsMapiErrINVALID_EDITFIELDS       = 'Invalid edit fields';
  RsMapiErrINVALID_RECIPS           = 'Invalid recipients';
  RsMapiErrNOT_SUPPORTED            = 'Not supported';

  RsMapiMailORIG        = 'From';
  RsMapiMailTO          = 'To';
  RsMapiMailCC          = 'Cc';
  RsMapiMailBCC         = 'Bcc';
  RsMapiMailSubject     = 'Subject';
  RsMapiMailBody        = 'Body';

//--------------------------------------------------------------------------------------------------
// JclMath
//--------------------------------------------------------------------------------------------------

resourcestring
  RsMathDomainError    = 'Domain check failure in JclMath';
  RsEmptyArray         = 'Empty array is not allowed as input parameter';
  RsNonPositiveArray   = 'Input array contains non-positive or zero values';
  RsUnexpectedDataType = 'Unexpected data type';
  RsUnexpectedValue    = 'Unexpected data value';
  RsRangeError         = 'Cannot merge range';
  RsInvalidRational    = 'Invalid rational number';
  RsDivByZero          = 'Division by zero';
  RsRationalDivByZero  = 'Rational division by zero';
  RsNoNaN              = 'NaN expected';
  RsNaNTagError        = 'NaN Tag value %d out of range';
  RsNaNSignal          = 'NaN signaling %d';

//--------------------------------------------------------------------------------------------------
// JclMidi
//--------------------------------------------------------------------------------------------------

resourcestring
  RsOctaveC      = 'C';
  RsOctaveCSharp = 'C#';
  RsOctaveD      = 'D';
  RsOctaveDSharp = 'D#';
  RsOctaveE      = 'E';
  RsOctaveF      = 'F';
  RsOctaveFSharp = 'F#';
  RsOctaveG      = 'G';
  RsOctaveGSharp = 'G#';
  RsOctaveA      = 'A';
  RsOctaveASharp = 'A#';
  RsOctaveB      = 'B';

  RsMidiInUnknownError    = 'Unknown MIDI-In error No. %d';
  RsMidiOutUnknownError   = 'Unknown MIDI-Out error No. %d';
  RsInvalidMidiChannelNum = 'Invalid MIDI channel number (%d)';

//--------------------------------------------------------------------------------------------------
// JclMiscel
//--------------------------------------------------------------------------------------------------

resourcestring
  // CreateProcAsUser
  RsCreateProcOSVersionError          = 'Unable to determine OS version';
  RsCreateProcNTRequiredError         = 'Windows NT required';
  RsCreateProcBuild1057Error          = 'NT version 3.51 build 1057 or later required';

  RsCreateProcPrivilegeMissing        = 'This account does not have the privilege "%s" (%s)';
  RsCreateProcLogonUserError          = 'LogonUser failed';
  RsCreateProcAccessDenied            = 'Access denied';
  RsCreateProcLogonFailed             = 'Unable to logon';
  RsCreateProcSetStationSecurityError = 'Cannot set WindowStation "%s" security.';
  RsCreateProcSetDesktopSecurityError = 'Cannot set Desktop "%s" security.';
  RsCreateProcPrivilegesMissing       = 'This account does not have one (or more) of ' +
    'the following privileges: ' + '"%s"(%s)' + #13 + '"%s"(%s)' + #13;
  RsCreateProcCommandNotFound         = 'Command or filename not found: "%s"';
  RsCreateProcFailed                  = 'CreateProcessAsUser failed';

//--------------------------------------------------------------------------------------------------
// JclMultimedia
//--------------------------------------------------------------------------------------------------

resourcestring

  // Multimedia timer

  RsMmTimerGetCaps     = 'Error retrieving multimedia timer device capabilities';
  RsMmTimerBeginPeriod = 'The supplied timer period value is out of range';
  RsMmSetEvent         = 'Error setting multimedia event timer';
  RsMmInconsistentId   = 'Multimedia timer callback was called with inconsistent Id';
  RsMmTimerActive      = 'This operation cannot be performed while the timer is active';

  // Audio Mixer

  RsMmMixerSource      = 'Source';
  RsMmMixerDestination = 'Destination';
  RsMmMixerUndefined   = 'Undefined';
  RsMmMixerDigital     = 'Digital';
  RsMmMixerLine        = 'Line';
  RsMmMixerMonitor     = 'Monitor';
  RsMmMixerSpeakers    = 'Speakers';
  RsMmMixerHeadphones  = 'Headphones';
  RsMmMixerTelephone   = 'Telephone';
  RsMmMixerWaveIn      = 'Waveform-audio input';
  RsMmMixerVoiceIn     = 'Voice input';
  RsMmMixerMicrophone  = 'Microphone';
  RsMmMixerSynthesizer = 'Synthesizer';
  RsMmMixerCompactDisc = 'Compact disc';
  RsMmMixerPcSpeaker   = 'PC speaker';
  RsMmMixerWaveOut     = 'Waveform-audio output';
  RsMmMixerAuxiliary   = 'Auxiliary audio line';
  RsMmMixerAnalog      = 'Analog';
  RsMmMixerNoDevices   = 'No mixer device found';
  RsMmMixerCtlNotFound = 'Line control (%s, %.8x) not found';

  // EJclMciError

  RsMmUnknownError     = 'Unknown MCI error No. %d';
  RsMmMciErrorPrefix   = 'MCI-Error: ';

  // CD audio routines

  RsMmNoCdAudio        = 'Cannot open CDAUDIO-Device';
  RsMmCdTrackNo        = 'Track: %.2u';
  RsMMCdTimeFormat     = '%2u:%.2u';
  RsMMTrackAudio       = 'Audio';
  RsMMTrackOther       = 'Other';

//--------------------------------------------------------------------------------------------------
// JclNTFS
//--------------------------------------------------------------------------------------------------

resourcestring
  RsInvalidArgument = '%s: Invalid argument <%s>';
  RsNtfsUnableToDeleteSymbolicLink = 'Unable to delete temporary symbolic link';

//--------------------------------------------------------------------------------------------------
// JclPeImage
//--------------------------------------------------------------------------------------------------

  // TJclPeImage

resourcestring
  RsPeCantOpen                = 'Cannot open file "%s"';
  RsPeNotPE                   = 'This is not a PE format';
  RsPeNotResDir               = 'Not a resource directory';
  RsPeNotAvailableForAttached = 'Feature is not available for attached images';
  RsPeSectionNotFound         = 'Section "%s" not found';

  // PE directory names

  RsPeImg_00 = 'Exports';
  RsPeImg_01 = 'Imports';
  RsPeImg_02 = 'Resources';
  RsPeImg_03 = 'Exceptions';
  RsPeImg_04 = 'Security';
  RsPeImg_05 = 'Base Relocations';
  RsPeImg_06 = 'Debug';
  RsPeImg_07 = 'Description';
  RsPeImg_08 = 'Machine Value';
  RsPeImg_09 = 'TLS';
  RsPeImg_10 = 'Load configuration';
  RsPeImg_11 = 'Bound Import';
  RsPeImg_12 = 'IAT';
  RsPeImg_13 = 'Delay load import';
  RsPeImg_14 = 'COM run-time';

  // NT Header names

  RsPeSignature               = 'Signature';
  RsPeMachine                 = 'Machine';
  RsPeNumberOfSections        = 'Number of Sections';
  RsPeTimeDateStamp           = 'Time Date Stamp';
  RsPePointerToSymbolTable    = 'Symbols Pointer';
  RsPeNumberOfSymbols         = 'Number of Symbols';
  RsPeSizeOfOptionalHeader    = 'Size of Optional Header';
  RsPeCharacteristics         = 'Characteristics';
  RsPeMagic                   = 'Magic';
  RsPeLinkerVersion           = 'Linker Version';
  RsPeSizeOfCode              = 'Size of Code';
  RsPeSizeOfInitializedData   = 'Size of Initialized Data';
  RsPeSizeOfUninitializedData = 'Size of Uninitialized Data';
  RsPeAddressOfEntryPoint     = 'Address of Entry Point';
  RsPeBaseOfCode              = 'Base of Code';
  RsPeBaseOfData              = 'Base of Data';
  RsPeImageBase               = 'Image Base';
  RsPeSectionAlignment        = 'Section Alignment';
  RsPeFileAlignment           = 'File Alignment';
  RsPeOperatingSystemVersion  = 'Operating System Version';
  RsPeImageVersion            = 'Image Version';
  RsPeSubsystemVersion        = 'Subsystem Version';
  RsPeWin32VersionValue       = 'Win32 Version';
  RsPeSizeOfImage             = 'Size of Image';
  RsPeSizeOfHeaders           = 'Size of Headers';
  RsPeCheckSum                = 'CheckSum';
  RsPeSubsystem               = 'Subsystem';
  RsPeDllCharacteristics      = 'Dll Characteristics';
  RsPeSizeOfStackReserve      = 'Size of Stack Reserve';
  RsPeSizeOfStackCommit       = 'Size of Stack Commit';
  RsPeSizeOfHeapReserve       = 'Size of Heap Reserve';
  RsPeSizeOfHeapCommit        = 'Size of Heap Commit';
  RsPeLoaderFlags             = 'Loader Flags';
  RsPeNumberOfRvaAndSizes     = 'Number of RVA';

  // Load config names

  RsPeVersion                       = 'Version';
  RsPeGlobalFlagsClear              = 'GlobalFlagsClear';
  RsPeGlobalFlagsSet                = 'GlobalFlagsSet';
  RsPeCriticalSectionDefaultTimeout = 'CriticalSectionDefaultTimeout';
  RsPeDeCommitFreeBlockThreshold    = 'DeCommitFreeBlockThreshold';
  RsPeDeCommitTotalFreeThreshold    = 'DeCommitTotalFreeThreshold';
  RsPeLockPrefixTable               = 'LockPrefixTable';
  RsPeMaximumAllocationSize         = 'MaximumAllocationSize';
  RsPeVirtualMemoryThreshold        = 'VirtualMemoryThreshold';
  RsPeProcessHeapFlags              = 'ProcessHeapFlags';
  RsPeProcessAffinityMask           = 'ProcessAffinityMask';
  RsPeCSDVersion                    = 'CSDVersion';
  RsPeReserved                      = 'Reserved';
  RsPeEditList                      = 'EditList';

  // Machine names

  RsPeMACHINE_UNKNOWN = 'Unknown';
  RsPeMACHINE_I386    = 'Intel 386';
  RsPeMACHINE_R3000   = 'MIPS little-endian R3000';
  RsPeMACHINE_R4000   = 'MIPS little-endian R4000';
  RsPeMACHINE_R10000  = 'MIPS little-endian R10000';
  RsPeMACHINE_ALPHA   = 'Alpha_AXP';
  RsPeMACHINE_POWERPC = 'IBM PowerPC Little-Endian';

  // Subsystem names

  RsPeSUBSYSTEM_UNKNOWN     = 'Unknown';
  RsPeSUBSYSTEM_NATIVE      = 'Native';
  RsPeSUBSYSTEM_WINDOWS_GUI = 'GUI';
  RsPeSUBSYSTEM_WINDOWS_CUI = 'Console';
  RsPeSUBSYSTEM_OS2_CUI     = 'OS/2';
  RsPeSUBSYSTEM_POSIX_CUI   = 'Posix';
  RsPeSUBSYSTEM_RESERVED8   = 'Reserved 8';

  // Debug symbol type names

  RsPeDEBUG_UNKNOWN       = 'UNKNOWN';
  RsPeDEBUG_COFF          = 'COFF';
  RsPeDEBUG_CODEVIEW      = 'CODEVIEW';
  RsPeDEBUG_FPO           = 'FPO';
  RsPeDEBUG_MISC          = 'MISC';
  RsPeDEBUG_EXCEPTION     = 'EXCEPTION';
  RsPeDEBUG_FIXUP         = 'FIXUP';
  RsPeDEBUG_OMAP_TO_SRC   = 'OMAP_TO_SRC';
  RsPeDEBUG_OMAP_FROM_SRC = 'OMAP_FROM_SRC';
  RsPeDEBUG_BORLAND       = 'BORLAND';

  // TJclPePackageInfo.PackageModuleTypeToString

  RsPePkgExecutable = 'Executable';
  RsPePkgPackage    = 'Package';
  PsPePkgLibrary    = 'Library';

  // TJclPePackageInfo.PackageOptionsToString

  RsPePkgNeverBuild     = 'NeverBuild';
  RsPePkgDesignOnly     = 'DesignOnly';
  RsPePkgRunOnly        = 'RunOnly';
  RsPePkgIgnoreDupUnits = 'IgnoreDupUnits';

  // TJclPePackageInfo.ProducerToString

  RsPePkgV3Produced        = 'Delphi 3 or C++ Builder 3';
  RsPePkgProducerUndefined = 'Undefined';
  RsPePkgBCB4Produced      = 'C++ Builder 4 or later';
  RsPePkgDelphi4Produced   = 'Delphi 4 or later';

  // TJclPePackageInfo.UnitInfoFlagsToString

  RsPePkgMain     = 'Main';
  RsPePkgWeak     = 'Weak';
  RsPePkgOrgWeak  = 'OrgWeak';
  RsPePkgImplicit = 'Implicit';

//--------------------------------------------------------------------------------------------------
// JclPrint
//--------------------------------------------------------------------------------------------------

resourcestring
  RsInvalidPrinter        = 'Invalid printer';
  RsNAStartDocument       = 'Unable to "Start document"';
  RsNASendData            = 'Unable to send data to printer';
  RsNAStartPage           = 'Unable to "Start page"';
  RsNAEndPage             = 'Unable to "End page"';
  RsNAEndDocument         = 'Unable to "End document"';
  RsNATransmission        = 'Not all chars have been sent correctly to printer';
  RsDeviceMode            = 'Error retrieving DeviceMode';
  RsUpdatingPrinter       = 'Error updating printer driver';
  RsIndexOutOfRange       = 'Index out of range setting bin';
  RsRetrievingSource      = 'Error retrieving Bin Source Info';
  RsRetrievingPaperSource = 'Error retrieving Paper Source Info';
  RsIndexOutOfRangePaper  = 'Index out of range setting paper';

  // Paper Styles (PS)

  RsPSLetter      = 'Letter 8 1/2 x 11 in';
  RsPSLetterSmall = 'Letter Small 8 1/2 x 11 in';
  RsPSTabloid     = 'Tabloid 11 x 17 in';
  RsPSLedger      = 'Ledger 17 x 11 in';
  RsPSLegal       = 'Legal 8 1/2 x 14 in';
  RsPSStatement   = 'Statement 5 1/2 x 8 1/2 in';
  RsPSExecutive   = 'Executive 7 1/2 x 10 in';
  RsPSA3          = 'A3 297 x 420 mm';
  RsPSA4          = 'A4 210 x 297 mm';
  RsPSA4Small     = 'A4 Small 210 x 297 mm';
  RsPSA5          = 'A5 148 x 210 mm';
  RsPSB4          = 'B4 250 x 354';
  RsPSB5          = 'B5 182 x 257 mm';
  RsPSFolio       = 'Folio 8 1/2 x 13 in';
  RsPSQuarto      = 'Quarto 215 x 275 mm';
  RsPS10X14       = '10 x 14 in';
  RsPS11X17       = '11 x 17 in';
  RsPSNote        = 'Note 8 1/2 x 11 in';
  RsPSEnv9        = 'Envelope #9 3 7/8 x 8 7/8 in';
  RsPSEnv10       = 'Envelope #10 4 1/8 x 9 1/2 in';
  RsPSEnv11       = 'Envelope #11 4 1/2 x 10 3/8 in';
  RsPSEnv12       = 'Envelope #12 4 \276 x 11 in';
  RsPSEnv14       = 'Envelope #14 5 x 11 1/2 in';
  RsPSCSheet      = 'C size sheet';
  RsPSDSheet      = 'D size sheet';
  RsPSESheet      = 'E size sheet';
  RsPSUser        = 'User Defined Size';
  RsPSUnknown     = 'Unknown Paper Size';

  RsPrintIniPrinterName   = 'PrinterName';
  RsPrintIniPrinterPort   = 'PrinterPort';
  RsPrintIniOrientation   = 'Orientation';
  RsPrintIniPaperSize     = 'PaperSize';
  RsPrintIniPaperLength   = 'PaperLength';
  RsPrintIniPaperWidth    = 'PaperWidth';
  RsPrintIniScale         = 'Scale';
  RsPrintIniCopies        = 'Copies';
  RsPrintIniDefaultSource = 'DefaultSource';
  RsPrintIniPrintQuality  = 'PrintQuality';
  RsPrintIniColor         = 'Color';
  RsPrintIniDuplex        = 'Duplex';
  RsPrintIniYResolution   = 'YResolution';
  RsPrintIniTTOption      = 'TTOption';

//--------------------------------------------------------------------------------------------------
// JclRegistry
//--------------------------------------------------------------------------------------------------

resourcestring
  RsUnableToOpenKeyRead  = 'Unable to open key "%s" for read';
  RsUnableToOpenKeyWrite = 'Unable to open key "%s" for write';
  RsUnableToAccessValue  = 'Unable to open key "%s" and access value "%s"';

//--------------------------------------------------------------------------------------------------
// JclRTTI
//--------------------------------------------------------------------------------------------------

resourcestring
  RsRTTIValueOutOfRange =   'Value out of range (%s).';
  RsRTTIUnknownIdentifier = 'Unknown identifier ''%s''.';
  RsRTTIInvalidGUIDString = 'Invalid conversion from string to GUID (%s).';
  RsRTTIInvalidBaseType   = 'Invalid base type (%s is of type %s).';

  RsRTTIVar =               'var ';
  RsRTTIConst =             'const ';
  RsRTTIArrayOf =           'array of ';
  RsRTTIOut =               'out ';
  RsRTTIBits =              'bits';
  RsRTTIOrdinal =           'ordinal=';
  RsRTTITrue =              'True';
  RsRTTIFalse =             'False';
  RsRTTITypeError =         '???';
  RsRTTITypeInfoAt =        'Type info: %p';

  RsRTTIPropRead =          'read';
  RsRTTIPropWrite =         'write';
  RsRTTIPropStored =        'stored';

  RsRTTIField =             'field';
  RsRTTIStaticMethod =      'static method';
  RsRTTIVirtualMethod =     'virtual method';

  RsRTTIIndex =             'index';
  RsRTTIDefault =           'default';

  RsRTTIName =              'Name: ';
  RsRTTIType =              'Type: ';
  RsRTTIFlags =             'Flags: ';
  RsRTTIGUID =              'GUID: ';
  RsRTTITypeKind =          'Type kind: ';
  RsRTTIOrdinalType =       'Ordinal type: ';
  RsRTTIMinValue =          'Min value: ';
  RsRTTIMaxValue =          'Max value: ';
  RsRTTINameList =          'Names: ';
  RsRTTIClassName =         'Class name: ';
  RsRTTIParent =            'Parent: ';
  RsRTTIPropCount =         'Property count: ';
  RsRTTIUnitName =          'Unit name: ';
  RsRTTIBasedOn =           'Based on: ';
  RsRTTIFloatType =         'Float type: ';
  RsRTTIMethodKind =        'Method kind: ';
  RsRTTIParamCount =        'Parameter count: ';
  RsRTTIReturnType =        'Return type: ';
  RsRTTIMaxLen =            'Max length: ';
  RsRTTIElSize =            'Element size: ';
  RsRTTIElType =            'Element type: ';
  RsRTTIElNeedCleanup =     'Elements need clean up: ';
  RsRTTIVarType =           'Variant type: ';

//--------------------------------------------------------------------------------------------------
// JclSchedule
//--------------------------------------------------------------------------------------------------

resourcestring
  RsScheduleInvalidTime     = 'Invalid time specification';
  RsScheduleEndBeforeStart  = 'End time can not be before start time';
  RsScheduleIntervalZero    = 'Interval should be larger than 0';
  RsScheduleNoDaySpecified  = 'At least one day of the week should be specified';
  RsScheduleIndexValueSup   = 'Property IndexValue not supported for current IndexKind';
  RsScheduleIndexValueZero  = 'IndexValue can not be 0';
  RsScheduleDayNotSupported = 'Property Day not supported for current IndexKind';
  RsScheduleDayInRange      = 'Day values should fall in the range 1 .. 31';
  RsScheduleMonthInRange    = 'Month values should fall in the range 1 .. 12';
  
//--------------------------------------------------------------------------------------------------
// JclStrings
//--------------------------------------------------------------------------------------------------

resourcestring
  RsInvalidEmptyStringItem  = 'String list passed to StringsToMultiSz cannot contain empty strings.';
  RsNumericConstantTooLarge = 'Numeric constant too large.';
  
//--------------------------------------------------------------------------------------------------
// JclSynch
//--------------------------------------------------------------------------------------------------

resourcestring
  RsSynchAttachWin32Handle    = 'Invalid handle to TJclWin32HandleObject.Attach';
  RsSynchDuplicateWin32Handle = 'Invalid handle to TJclWin32HandleObject.Duplicate';
  RsSynchInitCriticalSection  = 'Failed to initalize critical section';
  RsSynchAttachDispatcher     = 'Invalid handle to TJclDispatcherObject.Attach';
  RsSynchCreateEvent          = 'Failed to create event';
  RsSynchOpenEvent            = 'Failed to open event';
  RsSynchCreateWaitableTimer  = 'Failed to create waitable timer';
  RsSynchOpenWaitableTimer    = 'Failed to open waitable timer';
  RsSynchCreateSemaphore      = 'Failed to create semaphore';
  RsSynchOpenSemaphore        = 'Failed to open semaphore';
  RsSynchCreateMutex          = 'Failed to create mutex';
  RsSynchOpenMutex            = 'Failed to open mutex';
  RsMetSectInvalidParameter   = 'An invalid parameter was passed to the constructor.';
  RsMetSectInitialize         = 'Failed to initialize the metered section.';
  RsMetSectNameEmpty          = 'Name cannot be empty when using the Open constructor.';

//--------------------------------------------------------------------------------------------------
// JclSysInfo
//--------------------------------------------------------------------------------------------------

resourcestring
  RsSystemProcess = 'System Process';
  RsSystemIdleProcess = 'System Idle Process';

  RsIntelCacheDescr01 = 'Instruction TLB, 4Kb pages, 4-way set associative, 32 entries';
  RsIntelCacheDescr02 = 'Instruction TLB, 4Mb pages, fully associative, 2 entries';
  RsIntelCacheDescr03 = 'Data TLB, 4Kb pages, 4-way set associative, 64 entries';
  RsIntelCacheDescr04 = 'Data TLB, 4Mb pages, 4-way set associative, 8 entries';
  RsIntelCacheDescr06 = '8KB instruction cache, 4-way set associative, 32 byte line size';
  RsIntelCacheDescr08 = '16KB instruction cache, 4-way set associative, 32 byte line size';
  RsIntelCacheDescr0A = '8KB data cache 2-way set associative, 32 byte line size';
  RsIntelCacheDescr0C = '16KB data cache, 4-way set associative, 32 byte line size';
  RsIntelCacheDescr40 = 'No L2 cache';
  RsIntelCacheDescr41 = 'Unified cache, 32 byte cache line, 4-way set associative, 128Kb';
  RsIntelCacheDescr42 = 'Unified cache, 32 byte cache line, 4-way set associative, 256Kb';
  RsIntelCacheDescr43 = 'Unified cache, 32 byte cache line, 4-way set associative, 512Kb';
  RsIntelCacheDescr44 = 'Unified cache, 32 byte cache line, 4-way set associative, 1Mb';
  RsIntelCacheDescr45 = 'Unified cache, 32 byte cache line, 4-way set associative, 2Mb';

resourcestring
  RsOSVersionWin95 = 'Windows 95';
  RsOSVersionWin95OSR2 = 'Windows 95 OSR2';
  RsOSVersionWin98 = 'Windows 98';
  RsOSVersionWin98SE = 'Windows 98 SE';
  RsOSVersionWinME = 'Windows ME';
  RsOSVersionWinNT3 = 'Windows NT 3.%u';
  RsOSVersionWinNT4 = 'Windows NT 4.%u';
  RsOSVersionWin2000 = 'Windows 2000';
  RsOSVersionWinXP = 'Windows XP';

resourcestring
  RsProductTypeWorkStation = 'Workstation';
  RsProductTypeServer = 'Server';
  RsProductTypeAdvancedServer = 'Advanced Server';
  RsProductTypePersonal = 'Home Edition';
  RsProductTypeProfessional = 'Professional';
  RsProductTypeDatacenterServer = 'Datacenter Server';

//--------------------------------------------------------------------------------------------------
// JclSysUtils
//--------------------------------------------------------------------------------------------------

resourcestring
  RsCannotWriteRefStream = 'Can not write to a read-only memory stream';
  RsStringToBoolean = 'Unable to convert the string "%s" to a boolean';

//--------------------------------------------------------------------------------------------------
// JclTD32
//--------------------------------------------------------------------------------------------------

resourcestring
  RsHasNotTD32Info       = 'File [%s] has not TD32 debug information!';

//--------------------------------------------------------------------------------------------------
// JclUnicode
//--------------------------------------------------------------------------------------------------

resourcestring
  RsUREBaseString = 'Error in regular expression: %s' + #13;
  RsUREUnexpectedEOS       = 'Unexpected end of pattern.';
  RsURECharacterClassOpen  = 'Character class not closed, '']'' is missing.';
  RsUREUnbalancedGroup     = 'Unbalanced group expression, '')'' is missing.';
  RsUREInvalidCharProperty = 'A character property is invalid';
  RsUREInvalidRepeatRange  = 'Invalid repetition range.';
  RsURERepeatRangeOpen     = 'Repetition range not closed, ''}'' is missing.';
  RsUREExpressionEmpty     = 'Expression is empty.';

implementation

end.
