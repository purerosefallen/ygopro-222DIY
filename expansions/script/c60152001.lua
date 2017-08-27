--复燃的微光 佐仓杏子
function c60152001.initial_effect(c)
	--
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152001,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,6012001)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetCondition(c60152001.condition)
    e1:SetTarget(c60152001.target)
    e1:SetOperation(c60152001.activate)
    c:RegisterEffect(e1)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60152001,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,60152001)
    e3:SetTarget(c60152001.target2)
    e3:SetOperation(c60152001.activate2)
    c:RegisterEffect(e3)
end
function c60152001.cfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c60152001.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60152001.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c60152001.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152001.cfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c60152001.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60152001.cfilter,tp,LOCATION_MZONE,0,nil)
    if g:GetCount()>0 then
        local sc=g:GetFirst()
        while sc do
            local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            e1:SetValue(500)
            sc:RegisterEffect(e1)
            sc=g:GetNext()
        end
    end
end
function c60152001.filter(c)
    return c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER) and not c:IsCode(60152001) and c:IsAbleToHand()
end
function c60152001.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152001.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60152001.activate2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60152001.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end