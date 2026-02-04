module uim.oop.patterns.chains.usecases.purchaseapproval;
import uim.oop;
@safe:
// Real-world example: Purchase Approval

/**
 * Purchase request.
 */
class PurchaseRequest {
    private string _item;
    private double _amount;
    
    this(string item, double amount) {
        _item = item;
        _amount = amount;
    }
    
    string item() const {
        return _item;
    }
    
    double amount() const {
        return _amount;
    }
}

/**
 * Team lead approval handler.
 */
class TeamLeadApproval : BaseHandler {
    private double _approvalLimit = 1000.0;
    
    override string handle(string request) {
        auto amount = parseAmount(request);
        if (amount <= _approvalLimit) {
            return "Team Lead approved: " ~ request;
        }
        return super.handle(request);
    }
    
    private double parseAmount(string request) {
        auto idx = request.indexOf("$");
        if (idx >= 0 && idx + 1 < request.length) {
            try {
                return to!double(request[idx+1..$]);
            } catch (Exception e) {
                return 0.0;
            }
        }
        return 0.0;
    }
}

/**
 * Manager approval handler.
 */
class ManagerApproval : BaseHandler {
    private double _approvalLimit = 5000.0;
    
    override string handle(string request) {
        auto amount = parseAmount(request);
        if (amount <= _approvalLimit) {
            return "Manager approved: " ~ request;
        }
        return super.handle(request);
    }
    
    private double parseAmount(string request) {
        auto idx = request.indexOf("$");
        if (idx >= 0 && idx + 1 < request.length) {
            try {
                return to!double(request[idx+1..$]);
            } catch (Exception e) {
                return 0.0;
            }
        }
        return 0.0;
    }
}

/**
 * Director approval handler.
 */
class DirectorApproval : BaseHandler {
    override string handle(string request) {
        return "Director approved: " ~ request;
    }
}

unittest {
    // Test purchase approval chain
    auto teamLead = new TeamLeadApproval();
    auto manager = new ManagerApproval();
    auto director = new DirectorApproval();
    
    teamLead.setNext(manager);
    manager.setNext(director);
    
    auto result1 = teamLead.handle("Purchase: $500");
    assert(result1.indexOf("Team Lead") >= 0);
    
    auto result2 = teamLead.handle("Purchase: $3000");
    assert(result2.indexOf("Manager") >= 0);
    
    auto result3 = teamLead.handle("Purchase: $10000");
    assert(result3.indexOf("Director") >= 0);
}