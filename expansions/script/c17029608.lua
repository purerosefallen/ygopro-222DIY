--Psychether Priestess, Joan
function c17029608.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17029608,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17029608+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17029608.tgtg)
	e1:SetOperation(c17029608.tgop)
	c:RegisterEffect(e1)
	--Activate, SS self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17029608,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,17029608+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c17029608.spcost)
	e2:SetTarget(c17029608.sptg)
	e2:SetOperation(c17029608.spop)
	c:RegisterEffect(e2)
	--reveal
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17029608,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c17029608.revcon)
	e3:SetTarget(c17029608.revtg)
	e3:SetOperation(c17029608.revop)
	c:RegisterEffect(e3)
end
function c17029608.tgfilter(c)
	return c:IsSetCard(0x720) and c:IsAbleToGrave()
end
function c17029608.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c17029608.tgfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>1
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c17029608.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c17029608.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	Duel.SendtoGrave(tg1,REASON_EFFECT)
end
function c17029608.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x720) and c:IsAbleToRemoveAsCost()
end
function c17029608.cfcost(c)
	return c:IsCode(17029609) and c:IsAbleToRemoveAsCost()
end
function c17029608.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c17029608.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c17029608.cfcost,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(17029609,1))) then
		local tg=Duel.GetFirstMatchingCard(c17029608.cfcost,tp,LOCATION_GRAVE,0,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,c17029608.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c17029608.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,17029608,0x720,0x21,1500,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17029608.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,17029608,0x720,0x21,1500,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		c:AddMonsterAttributeComplete()
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(17029602,4))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetCountLimit(1)
		e2:SetValue(c17029608.valct)
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
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(17029608,3))
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EFFECT_DESTROY_REPLACE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetTarget(c17029608.reptg)
		e5:SetValue(c17029608.repval)
		e5:SetOperation(c17029608.repop)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e5,true)
		Duel.SpecialSummonComplete()
	end
end
function c17029608.valct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c17029608.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x720) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c17029608.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c17029608.repfilter,1,nil,tp,e:GetHandler()) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c17029608.repval(e,c)
	return c17029608.repfilter(c,e:GetHandlerPlayer())
end
function c17029608.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c17029608.cfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x720) and not c:IsCode(17029608)
end
function c17029608.revcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17029608.cfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler())
end
function c17029608.revfilter(c)
	return not c:IsPublic()
end
function c17029608.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17029608.revfilter,tp,0,LOCATION_HAND,1,nil) end
end
function c17029608.revop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c17029608.revfilter,tp,0,LOCATION_HAND,1,1,nil)
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
