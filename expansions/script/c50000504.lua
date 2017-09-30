--被侵蚀的星之援军
function c50000504.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_NORMAL),3)
    c:EnableReviveLimit()
    --IMMUNE
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetValue(c50000504.efilter)
    e1:SetTarget(c50000504.tgtg)
    c:RegisterEffect(e1)
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c50000504.desreptg)
    e2:SetOperation(c50000504.desrepop)
    c:RegisterEffect(e2)
    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50000504,0))
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,50000504)
    e3:SetCondition(c50000504.tdcon)
    e3:SetTarget(c50000504.tdtg)
    e3:SetOperation(c50000504.tdop)
    c:RegisterEffect(e3)
end
--

function c50000504.tgtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c50000504.efilter(e,te)
    return not te:IsActiveType(TYPE_LINK)
end
--
function c50000504.repfilter(c,e,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
        and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c50000504.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        local g=c:GetLinkedGroup()
        return not c:IsReason(REASON_REPLACE) and g:IsExists(c50000504.repfilter,1,nil,e,tp)
    end
    if Duel.SelectEffectYesNo(tp,c,96) then
        local g=c:GetLinkedGroup()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
        local sg=g:FilterSelect(tp,c50000504.repfilter,1,1,nil,e,tp)
        e:SetLabelObject(sg:GetFirst())
        sg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
        return true
    else return false end
end
function c50000504.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
    Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
---

function c50000504.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c50000504.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
    local ct=e:GetHandler():GetMutualLinkedGroupCount()
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and ct>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c50000504.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local g=tg:Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end