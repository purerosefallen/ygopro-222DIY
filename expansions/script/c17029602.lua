--Psychether Guide, Luuht
function c17029602.initial_effect(c)
	--Activate, to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17029602,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17029602+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17029602.thtg)
	e1:SetOperation(c17029602.thop)
	c:RegisterEffect(e1)
	--Activate, SS self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17029602,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,17029602+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c17029602.spcon)
	e2:SetTarget(c17029602.sptg)
	e2:SetOperation(c17029602.spop)
	c:RegisterEffect(e2)
	--reveal
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17029602,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c17029602.revcon)
	e3:SetTarget(c17029602.revtg)
	e3:SetOperation(c17029602.revop)
	c:RegisterEffect(e3)
end
function c17029602.thfilter(c)
	return c:IsSetCard(0x720) and c:IsAbleToHand() and not c:IsCode(17029602)
end
function c17029602.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17029602.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17029602.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17029602.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c17029602.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x720)
end
function c17029602.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17029602.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c17029602.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,17029602,0x720,0x11,1000,1000,4,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17029602.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,17029603,0x720,0x11,1000,1000,4,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		c:AddMonsterAttributeComplete()
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(17029602,4))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetCountLimit(1)
		e2:SetValue(c17029602.valct)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetReset(RESET_EVENT+0x47e0000)
		e4:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e4,true)
	end
end
function c17029602.valct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c17029602.cfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x720) and not c:IsCode(17029602)
end
function c17029602.revcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17029602.cfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler())
end
function c17029602.revfilter(c)
	return not c:IsPublic()
end
function c17029602.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17029602.revfilter,tp,0,LOCATION_HAND,1,nil) end
end
function c17029602.revop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c17029602.revfilter,tp,0,LOCATION_HAND,1,1,nil)
    Duel.HintSelection(g)
    local tc=g:GetFirst()
    if tc then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PUBLIC)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
