--电光石火
function c50000054.initial_effect(c)
    c:EnableCounterPermit(0x150c,LOCATION_SZONE)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --add counter
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c50000054.ctcon)
    e2:SetOperation(c50000054.ctop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --atk/def
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetValue(c50000054.val)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e5)
    --destroy
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetDescription(aux.Stringid(50000054,0))
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_SZONE)
    e6:SetCountLimit(1,50000054)
    e6:SetCost(c50000054.cost2)
    e6:SetTarget(c50000054.tg2)
    e6:SetOperation(c50000054.op2)
    c:RegisterEffect(e6)
    --special summon
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetDescription(aux.Stringid(50000054,1))
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_SZONE)
    e7:SetCountLimit(1,50000054)
    e7:SetCost(c50000054.spcost3)
    e7:SetTarget(c50000054.sptg3)
    e7:SetOperation(c50000054.spop3)
    c:RegisterEffect(e7)
    --duel status
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetRange(LOCATION_FZONE)
    e8:SetTargetRange(LOCATION_MZONE,0)
    e8:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x50c))
    e8:SetCode(EFFECT_DUAL_STATUS)
    c:RegisterEffect(e8)
end
function c50000054.ctfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x50c) and c:IsControler(tp)
end
function c50000054.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c50000054.ctfilter,1,nil,tp)
end
function c50000054.ctop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x150c,1)
end
function c50000054.val(e,c)
    return e:GetHandler():GetCounter(0x150c)*100
end
----
function c50000054.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x150c,2,REASON_COST) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    e:GetHandler():RemoveCounter(tp,0x150c,2,REASON_COST)
end
function c50000054.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c50000054.op2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
-----
function c50000054.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x150c,4,REASON_COST) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    e:GetHandler():RemoveCounter(tp,0x150c,4,REASON_COST)
end
function c50000054.spfilter3(c,e,tp)
    return c:IsSetCard(0x50c)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50000054.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c50000054.spfilter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50000054.spop3(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50000054.spfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end