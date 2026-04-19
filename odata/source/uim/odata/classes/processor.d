/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.classes.processor;

import uim.odata.interfaces.processor;
import uim.odata.interfaces.repository;
import uim.odata.types.model;
import uim.odata.types.request;
import uim.odata.usecases;

@safe:

/// Default IODataProcessor implementation — the application-layer orchestrator.
///
/// Routes each ODataRequest to the appropriate use case based on request type
/// and HTTP method.  This is the core of the hexagonal "inside" — it depends
/// only on ports (interfaces) and domain types, never on HTTP or storage
/// specifics.
class ODataProcessor : IODataProcessor {
    private QueryEntitiesUseCase _queryUC;
    private GetEntityUseCase     _getUC;
    private CreateEntityUseCase  _createUC;
    private UpdateEntityUseCase  _updateUC;
    private DeleteEntityUseCase  _deleteUC;
    private MetadataUseCase      _metadataUC;

    this(IEntityRepository repository, EdmModel model) {
        _queryUC    = new QueryEntitiesUseCase(repository);
        _getUC      = new GetEntityUseCase(repository);
        _createUC   = new CreateEntityUseCase(repository);
        _updateUC   = new UpdateEntityUseCase(repository);
        _deleteUC   = new DeleteEntityUseCase(repository);
        _metadataUC = new MetadataUseCase(model);
    }

    override ODataResponse process(ODataRequest request) @trusted {
        final switch (request.type) {
            case RequestType.metadata:
                return _metadataUC.execute();

            case RequestType.serviceDocument:
                return _metadataUC.executeServiceDocument();

            case RequestType.entitySet:
                if (request.method == "GET")
                    return _queryUC.execute(request.entitySetName, request.queryOptions);
                if (request.method == "POST")
                    return _createUC.execute(request.entitySetName, request.body_);
                return ODataResponse.methodNotAllowed();

            case RequestType.entity:
                if (request.method == "GET")
                    return _getUC.execute(request.entitySetName, request.entityKey);
                if (request.method == "PUT")
                    return _updateUC.execute(
                        request.entitySetName, request.entityKey, request.body_);
                if (request.method == "PATCH")
                    return _updateUC.executePatch(
                        request.entitySetName, request.entityKey, request.body_);
                if (request.method == "DELETE")
                    return _deleteUC.execute(request.entitySetName, request.entityKey);
                return ODataResponse.methodNotAllowed();

            case RequestType.entityCount:
                return _queryUC.executeCount(request.entitySetName);

            case RequestType.property:
                return ODataResponse.badRequest("Property access not yet implemented");
        }
    }
}
