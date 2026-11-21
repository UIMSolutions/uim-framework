module uim.service.mixins.repositories.id;
import uim.service;

mixin(ShowModule!());

@safe:

template IdRepositoryTemplate(alias Repository, TEntity, TId) {
    this() {
        super();
    }


}
