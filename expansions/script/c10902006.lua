--小小的星辉
local m=10902006
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)  
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(cm.discon)
    e2:SetOperation(cm.disop)
    c:RegisterEffect(e2) 
    --Equip
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMING_END_PHASE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCost(cm.cost)
    e3:SetTarget(cm.target)
    e3:SetOperation(cm.operation)
    c:RegisterEffect(e3)  
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x235))
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(aux.indoval)
    Duel.RegisterEffect(e1,tp)
end
function cm.ngfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x235)
end
function cm.cnfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsSetCard(0x235)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():GetColumnGroup():FilterCount(cm.cnfilter,nil,tp)>0 then return end
    return rp~=tp and re:IsActiveType(TYPE_SPELL)  and Duel.IsExistingMatchingCard(cm.ngfilter,tp,LOCATION_SZONE,0,2,nil)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end
function cm.cpfilter(c,ft)
    return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0x235)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.cfilter(c)
    return c:IsFaceup() 
end
function cm.filter2(c)
    return c:IsSetCard(0x235) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.cfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local sg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
    local sc=sg:GetFirst()
    if sc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        if not Duel.Equip(tp,sc,tc,true) then return end
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(cm.eqlimit)
        e1:SetLabelObject(tc)
        sc:RegisterEffect(e1)
    end
end
function cm.eqlimit(e,c)
    return e:GetLabelObject()==c
end
