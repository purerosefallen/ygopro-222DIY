--精灵魔装-灭杀魔王之圣剑
function c5200020.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCost(c5200020.cost)
    e1:SetTarget(c5200020.target)
    e1:SetOperation(c5200020.operation)
    c:RegisterEffect(e1)
    --Atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(2000)
    c:RegisterEffect(e2)
    --Equip limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetValue(c5200020.eqlimit)
    c:RegisterEffect(e3)
    --Destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(5200020,0))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCountLimit(1)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END,TIMING_BATTLE_START+TIMING_BATTLE_END)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCondition(c5200020.descon1)
    e4:SetTarget(c5200020.destg)
    e4:SetOperation(c5200020.desop)
    c:RegisterEffect(e4)
    --xyz effect
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(5200020,1))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_SZONE)
    e5:SetHintTiming(0,TIMING_END_PHASE+0x1c0)
    e5:SetCountLimit(1,5200020)
    e5:SetCost(c5200020.xyzcost)
    e5:SetTarget(c5200020.xyztg)
    e5:SetOperation(c5200020.xyzop)
    c:RegisterEffect(e5)
    Duel.AddCustomActivityCounter(5200020,ACTIVITY_SPSUMMON,c5200020.counterfilter)
end
function c5200020.eqlimit(e,c)
    return c:IsCode(5200001) or c:IsCode(5200011)
end
function c5200020.refilter(c)
    return c:IsCode(5200006) and c:IsAbleToRemoveAsCost()
end
function c5200020.filter(c)
    return c:IsFaceup() and (c:IsCode(5200001) or c:IsCode(5200011))
end
function c5200020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c5200020.refilter,tp,0x16,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c5200020.refilter,tp,0x16,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c5200020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c5200020.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c5200020.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c5200020.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c5200020.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c5200020.descon1(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return  (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) 
end
function c5200020.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetHandler():GetEquipTarget()
    local ph=Duel.GetCurrentPhase()
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
        and tc and tc:GetAttack()>0 and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) end
    local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c5200020.desop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=e:GetHandler():GetEquipTarget()
    if tc and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(0)
        tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CHANGE_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(0,1)
    e2:SetValue(0)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
    local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
    end
end

function c5200020.counterfilter(c)
    return c:IsSetCard(0x360)
end
function c5200020.xyzfilter(c)
    return c:IsSetCard(0x360) and c:IsXyzSummonable(nil)
end
function c5200020.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c5200020.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c5200020.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c5200020.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c5200020.xyzfilter,tp,LOCATION_EXTRA,0,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=g:Select(tp,1,1,nil)
        Duel.XyzSummon(tp,tg:GetFirst(),nil)
    end
end