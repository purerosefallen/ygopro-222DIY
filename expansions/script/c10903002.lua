--东煌·宁海
local m=10903002
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(cm.spcon)
    c:RegisterEffect(e1)    
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetCondition(cm.atkcon)
    e2:SetValue(500)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CHANGE_DAMAGE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(0,1)
    e4:SetCondition(cm.valcon)
    e4:SetValue(cm.val)
    c:RegisterEffect(e4)  
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(23571046,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCountLimit(1,m)
    e5:SetCondition(cm.condition)
    e5:SetTarget(cm.target)
    e5:SetOperation(cm.operation)
    c:RegisterEffect(e5)
end
function cm.spfilter(c)
    return c:IsFaceup() and c:IsCode(10903001)
end
function cm.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.atkcon(e)
    return Duel.IsExistingMatchingCard(cm.spfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.valcon(e)
    local ph=Duel.GetCurrentPhase()
    return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.filter2(c)
    return c:IsSetCard(0x1236) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.val(e,re,dam,r,rp,rc)
    return dam+Duel.GetMatchingGroupCount(cm.filter2,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*600
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.cfilter2(c)
    return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0x1236)
end 
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x47e0000)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1,true)
    end
end
