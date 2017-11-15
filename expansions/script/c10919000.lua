--Traitorous Witch Honoka
function c10919000.initial_effect(c)
    c:SetSPSummonOnce(10919000)
    --special summon
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_GRAVE)
    e0:SetCondition(c10919000.spcon)
    e0:SetOperation(c10919000.spop)
    c:RegisterEffect(e0)
    local e4=e0:Clone()
    e4:SetRange(LOCATION_HAND)
    e4:SetCondition(c10919000.spcon2)
    c:RegisterEffect(e4)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10919000,0))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
    e1:SetTarget(c10919000.damtg)
    e1:SetOperation(c10919000.damop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
end
function c10919000.spfilter(c,ft)
    return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(5) and c:IsAbleToHandAsCost()
        and (ft>0 or c:GetSequence()<5)
end
function c10919000.spcon(e,c)
    if c==nil then return true end
    if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.IsExistingMatchingCard(c10919000.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c10919000.spcon2(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.IsExistingMatchingCard(c10919000.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c10919000.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c10919000.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
    Duel.SendtoHand(g,nil,REASON_COST)
end
function c10919000.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(800)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,800)
end
function c10919000.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
