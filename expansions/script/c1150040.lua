--两人的旅途
function c1150040.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150040+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c1150040.con1)
	e1:SetTarget(c1150040.tg1)
	e1:SetOperation(c1150040.op1)
	c:RegisterEffect(e1)	
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c1150040.cost2)
	e2:SetTarget(c1150040.tg2)
	e2:SetOperation(c1150040.op2)
	c:RegisterEffect(e2)
end
--
function c1150040.cfilter1(c)
	return c:IsFaceup()
end
--
function c1150040.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1150040.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1150040.lr(c)
	local lv=0
	if c:GetLevel()>0 then lv=c:GetLevel() end
	if c:GetRank()>0 then lv=c:GetRank() end
	return lv
end
function c1150040.ofilter1(c,e,slv)
	return c:IsFaceup() and c1150040.lr(c)>=slv
end
function c1150040.tfilter1(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c1150040.ofilter1,tp,LOCATION_MZONE,0,1,nil,e,c:GetLevel())
end
--
function c1150040.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150040.tfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
--
function c1150040.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1150040.tfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1150040.tfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
				local e1_1=Effect.CreateEffect(e:GetHandler())
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetCode(EFFECT_DISABLE)
				e1_1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_1,true)
				local e1_2=Effect.CreateEffect(e:GetHandler())
				e1_2:SetType(EFFECT_TYPE_SINGLE)
				e1_2:SetCode(EFFECT_DISABLE_EFFECT)
				e1_2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_2,true)			   
				local e1_3=Effect.CreateEffect(e:GetHandler())
				e1_3:SetType(EFFECT_TYPE_SINGLE)
				e1_3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1_3:SetRange(LOCATION_MZONE)
				e1_3:SetCode(EFFECT_IMMUNE_EFFECT)
				e1_3:SetReset(RESET_EVENT+0x1fe0000)
				e1_3:SetValue(c1150040.efilter)
				tc:RegisterEffect(e1_3,true)
			end
		end
	end
end
--
function c1150040.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
--
function c1150040.cfilter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c1150040.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c1150040.cfilter2,tp,LOCATION_HAND,0,nil)==1 and e:GetHandler():IsAbleToRemoveAsCost()end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--
function c1150040.tfilter2(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand()
end
function c1150040.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150040.tfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1150040.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1150040.tfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



