global class PlanCost implements Comparable{
    public String planId { get; set; }
    public String planName { get; set; }
    public Decimal rate { get; set; }
    public Decimal cost { get; set; }

    public PlanCost(PricePlan__c plan, Decimal cost){
        planId = plan.Id;
        planName = plan.Name;
        rate = plan.Rate__c;
        this.cost = cost;
    }

    global Integer compareTo(Object compareTo) {
        PlanCost compareToCost = (PlanCost)compareTo;
        return cost > compareToCost.cost ? 1 : -1;
    }
}
