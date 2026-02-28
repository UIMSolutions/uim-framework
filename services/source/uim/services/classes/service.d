/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.classes.service;

import uim.services.classes.configuration;
import uim.services.interfaces.service;

@safe:

class UIMService : IService {
    private ServiceConfiguration config;
    private bool running;
    
    this(ServiceConfiguration config = new ServiceConfiguration()) {
        this.config = config;
    }
    
    override void start() nothrow {
        running = true;
    }

    override void stop() nothrow {
        running = false;
    }

    @property bool isRunning() const nothrow {
        return running;
    }

    string name() const nothrow {
        return config.name;
    }
    
    string description() const nothrow {
        return config.description;
    }
    
    string version_() const nothrow {
        return config.version_;
    }
    
    string author() const nothrow {
        return config.author;
    }
    
    string license() const nothrow {
        return config.license;
    }
}