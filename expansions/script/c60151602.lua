--粉色的回忆 鹿目圆香
function c60151602.initial_effect(c)
	--pendulum summon
    aux.EnablePendulumAttribute(c)
	--
    local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
    e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EVENT_CHAIN_ACTIVATING)
    e11:SetOperation(c60151602.disop)
    c:RegisterEffect(e11)
	--negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151602,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e1:SetCountLimit(1,60151602)
    e1:SetCondition(c60151602.condition)
    e1:SetTarget(c60151602.target)
    e1:SetOperation(c60151602.operation)
    c:RegisterEffect(e1)
	--spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151602,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCountLimit(1,60151602)
    e3:SetTarget(c60151602.sptg)
    e3:SetOperation(c60151602.spop)
    c:RegisterEffect(e3)
	local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c60151602.spcondition)
    c:RegisterEffect(e4)
end
function c60151602.spcondition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c60151602.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb25) and c:IsType(TYPE_MONSTER)
end
function c60151602.disop(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp or not (re:IsActiveType(TYPE_MONSTER) and re:IsActivated()) then return end
    Duel.Hint(HINT_CARD,0,60151602)
	Duel.Recover(tp,300,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c60151602.filter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(100)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c60151602.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and re:IsActivated() and rc:IsSetCard(0xcb25)
end
function c60151602.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60151602.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if c:GetSummonLocation()==LOCATION_EXTRA then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(60151601,0))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+0x47e0000)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1,true)
		end
	end
end
function c60151602.filter3(c)
    return c:IsSetCard(0xcb25) and c:IsType(TYPE_PENDULUM) and not c:IsCode(60151602) and c:IsAbleToHand()
end
function c60151602.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151602.filter3,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60151602.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60151602.filter3,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end