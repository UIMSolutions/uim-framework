/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opc.types.status;

@safe:

// OPC UA status codes (Part 4, Annex B)
enum OpcStatusCode : uint {
  good                             = 0x00000000,
  goodNoData                       = 0x00A50000,
  goodEntryInserted                = 0x00A60000,
  goodEntryReplaced                = 0x00A70000,
  uncertain                        = 0x40000000,
  uncertainNoCommunicationLastUsableValue = 0x408F0000,
  uncertainLastUsableValue         = 0x40900000,
  uncertainSubstituteValue         = 0x40910000,
  uncertainInitialValue            = 0x40920000,
  uncertainSensorNotAccurate       = 0x40930000,
  uncertainEngineeringUnitsExceeded = 0x40940000,
  uncertainSubNormal               = 0x40950000,
  bad                              = 0x80000000,
  badUnexpectedError               = 0x80010000,
  badInternalError                 = 0x80020000,
  badOutOfMemory                   = 0x80030000,
  badResourceUnavailable           = 0x80040000,
  badCommunicationError            = 0x80050000,
  badEncodingError                 = 0x80060000,
  badDecodingError                 = 0x80070000,
  badRequestTooLarge               = 0x80080000,
  badResponseTooLarge              = 0x80090000,
  badUnknownResponse               = 0x800A0000,
  badTimeout                       = 0x800B0000,
  badServiceUnsupported            = 0x800C0000,
  badShutdown                      = 0x800D0000,
  badServerNotConnected            = 0x800E0000,
  badServerHalted                  = 0x800F0000,
  badNothingToDo                   = 0x80100000,
  badTooManyOperations             = 0x80110000,
  badTooManyMonitoredItems         = 0x80120000,
  badDataTypeIdUnknown             = 0x80130000,
  badCertificateInvalid            = 0x80140000,
  badSecurityChecksFailed          = 0x80150000,
  badCertificateTimeInvalid        = 0x80160000,
  badCertificateIssuerTimeInvalid  = 0x80170000,
  badCertificateHostNameInvalid    = 0x80180000,
  badCertificateUriInvalid         = 0x80190000,
  badCertificateUseNotAllowed      = 0x801A0000,
  badCertificateIssuerUseNotAllowed = 0x801B0000,
  badCertificateUntrusted          = 0x801C0000,
  badCertificateRevocationUnknown  = 0x801D0000,
  badCertificateIssuerRevocationUnknown = 0x801E0000,
  badCertificateRevoked            = 0x801F0000,
  badCertificateIssuerRevoked      = 0x80200000,
  badCertificateChainIncomplete    = 0x810D0000,
  badUserAccessDenied              = 0x801F0000,
  badIdentityTokenInvalid          = 0x80200000,
  badIdentityTokenRejected         = 0x80210000,
  badSecureChannelIdInvalid        = 0x80220000,
  badInvalidTimestamp              = 0x80230000,
  badNonceInvalid                  = 0x80240000,
  badSessionIdInvalid              = 0x80250000,
  badSessionClosed                 = 0x80260000,
  badSessionNotActivated           = 0x80270000,
  badSubscriptionIdInvalid         = 0x80280000,
  badRequestHeaderInvalid          = 0x802A0000,
  badTimestampsToReturnInvalid     = 0x802B0000,
  badRequestCancelledByClient      = 0x802C0000,
  badTooManyArguments              = 0x80E50000,
  badLicenseExpired                = 0x810E0000,
  badLicenseLimitsExceeded         = 0x810F0000,
  badLicenseNotAvailable           = 0x81100000,
  badNodeIdInvalid                 = 0x80330000,
  badNodeIdUnknown                 = 0x80340000,
  badAttributeIdInvalid            = 0x80350000,
  badIndexRangeInvalid             = 0x80360000,
  badIndexRangeNoData              = 0x80370000,
  badDataEncodingInvalid           = 0x80380000,
  badDataEncodingUnsupported       = 0x80390000,
  badNotReadable                   = 0x803A0000,
  badNotWritable                   = 0x803B0000,
  badOutOfRange                    = 0x803C0000,
  badNotSupported                  = 0x803D0000,
  badNotFound                      = 0x803E0000,
  badObjectDeleted                 = 0x803F0000,
  badNotImplemented                = 0x80400000,
  badMonitoringModeInvalid         = 0x80410000,
  badMonitoredItemIdInvalid        = 0x80420000,
  badMonitoredItemFilterInvalid    = 0x80430000,
  badMonitoredItemFilterUnsupported = 0x80440000,
  badFilterNotAllowed              = 0x80450000,
  badStructureMissing              = 0x80460000,
  badEventFilterInvalid            = 0x80470000,
  badContentFilterInvalid          = 0x80480000,
  badFilterOperatorInvalid         = 0x80C10000,
  badFilterOperatorUnsupported     = 0x80C20000,
  badFilterOperandCountMismatch    = 0x80C30000,
  badFilterOperandInvalid          = 0x80490000,
  badFilterElementInvalid          = 0x80C40000,
  badFilterLiteralInvalid          = 0x80C50000,
  badContinuationPointInvalid      = 0x804A0000,
  badNoContinuationPoints          = 0x804B0000,
  badReferenceTypeIdInvalid        = 0x804C0000,
  badBrowseDirectionInvalid        = 0x804D0000,
  badNodeNotInView                 = 0x804E0000,
  badNumericOverflow               = 0x81120000,
  badServerUriInvalid              = 0x804F0000,
  badServerNameMissing             = 0x80500000,
  badDiscoveryUrlMissing           = 0x80510000,
  badSempahoreFileMissing          = 0x80520000,
  badRequestTypeInvalid            = 0x80530000,
  badSecurityModeRejected          = 0x80540000,
  badSecurityPolicyRejected        = 0x80550000,
  badTooManySessions               = 0x80560000,
  badUserSignatureInvalid          = 0x80570000,
  badApplicationSignatureInvalid   = 0x80580000,
  badNoValidCertificates           = 0x80590000,
  badIdentityChangeNotSupported    = 0x80C60000,
  badRequestCancelledByRequest     = 0x805A0000,
  badParentNodeIdInvalid           = 0x805B0000,
  badReferenceNotAllowed           = 0x805C0000,
  badNodeIdRejected                = 0x805D0000,
  badNodeIdExists                  = 0x805E0000,
  badNodeClassInvalid              = 0x805F0000,
  badBrowseNameInvalid             = 0x80600000,
  badBrowseNameDuplicated          = 0x80610000,
  badNodeAttributesInvalid         = 0x80620000,
  badTypeDefinitionInvalid         = 0x80630000,
  badSourceNodeIdInvalid           = 0x80640000,
  badTargetNodeIdInvalid           = 0x80650000,
  badDuplicateReferenceNotAllowed  = 0x80660000,
  badInvalidSelfReference          = 0x80670000,
  badReferenceLocalOnly            = 0x80680000,
  badNoDeleteRights                = 0x80690000,
  uncertainReferenceNotDeleted     = 0x40BC0000,
  badServerIndexInvalid            = 0x806A0000,
  badViewIdUnknown                 = 0x806B0000,
  badViewTimestampInvalid          = 0x80C90000,
  badViewParameterMismatch         = 0x80CA0000,
  badViewVersionInvalid            = 0x80CB0000,
  uncertainNotAllNodesAvailable    = 0x40C00000,
  goodResultsMayBeIncomplete       = 0x00BA0000,
  badNotTypeDefinition             = 0x80C80000,
  uncertainReferenceOutOfServer    = 0x406C0000,
  badTooManyMatches                = 0x806D0000,
  badQueryTooComplex               = 0x806E0000,
  badNoMatch                       = 0x806F0000,
  badMaxAgeInvalid                 = 0x80700000,
  badSecurityModeInsufficient      = 0x80E60000,
  badHistoryOperationInvalid       = 0x80710000,
  badHistoryOperationUnsupported   = 0x80720000,
  badInvalidTimestampArgument      = 0x80BD0000,
  badWriteNotSupported             = 0x80730000,
  badTypeMismatch                  = 0x80740000,
  badMethodInvalid                 = 0x80750000,
  badArgumentsMissing              = 0x80760000,
  badNotExecutable                 = 0x81110000,
  badTooManySubscriptions          = 0x80770000,
  badTooManyPublishRequests        = 0x80780000,
  badNoSubscription                = 0x80790000,
  badSequenceNumberUnknown         = 0x807A0000,
  badMessageNotAvailable           = 0x807B0000,
  badInsufficientClientProfile     = 0x807C0000,
  badStateNotActive                = 0x80BF0000,
  badAlreadyExists                 = 0x81150000,
  badTcpServerTooBusy              = 0x807D0000,
  badTcpMessageTypeInvalid         = 0x807E0000,
  badTcpSecureChannelUnknown       = 0x807F0000,
  badTcpMessageTooLarge            = 0x80800000,
  badTcpNotEnoughResources         = 0x80810000,
  badTcpInternalError              = 0x80820000,
  badTcpEndpointUrlInvalid         = 0x80830000,
  badRequestInterrupted            = 0x80840000,
  badRequestTimeout                = 0x80850000,
  badSecureChannelClosed           = 0x80860000,
  badSecureChannelTokenUnknown     = 0x80870000,
  badSequenceNumberInvalid         = 0x80880000,
  badProtocolVersionUnsupported    = 0x80BE0000,
  badConfigurationError            = 0x80890000,
  badNotConnected                  = 0x808A0000,
  badDeviceFailure                 = 0x808B0000,
  badSensorFailure                 = 0x808C0000,
  badOutOfService                  = 0x808D0000,
  badDeadbandFilterInvalid         = 0x808E0000,
  uncertainNoCommunicationLastUsableValue2 = 0x408F0000,
}

bool opcIsGood(OpcStatusCode code) pure nothrow {
  return (cast(uint) code & 0xC0000000) == 0;
}

bool opcIsUncertain(OpcStatusCode code) pure nothrow {
  return (cast(uint) code & 0xC0000000) == 0x40000000;
}

bool opcIsBad(OpcStatusCode code) pure nothrow {
  return (cast(uint) code & 0x80000000) != 0;
}

struct OpcStatus {
  OpcStatusCode code    = OpcStatusCode.good;
  string        message = "Good";

  bool good()     const nothrow { return opcIsGood(code);      }
  bool uncertain() const nothrow { return opcIsUncertain(code); }
  bool bad()      const nothrow { return opcIsBad(code);       }

  unittest {
    auto ok = OpcStatus(OpcStatusCode.good, "Good");
    assert(ok.good);
    assert(!ok.bad);

    auto err = OpcStatus(OpcStatusCode.badNodeIdUnknown, "Unknown node");
    assert(err.bad);
    assert(!err.good);
  }
}

OpcStatus opcGoodStatus(string msg = "Good") nothrow {
  return OpcStatus(OpcStatusCode.good, msg);
}

OpcStatus opcBadStatus(OpcStatusCode code, string msg = "") nothrow {
  return OpcStatus(code, msg.length > 0 ? msg : "Bad");
}

OpcStatus opcUncertainStatus(OpcStatusCode code, string msg = "") nothrow {
  return OpcStatus(code, msg.length > 0 ? msg : "Uncertain");
}
