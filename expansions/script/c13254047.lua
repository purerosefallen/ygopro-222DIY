 --元始·飞球之崩炎
function c13254047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c13254047.cost1)
	e1:SetTarget(c13254047.target1)
	e1:SetOperation(c13254047.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c13254047.regop)
	c:RegisterEffect(e4)
end
function c13254047.costfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254047.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254047.costfilter,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c13254047.costfilter,tp,LOCATION_HAND,0,2,2,nil)
		Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
end
function c13254047.filter(c,tp)
	return c:GetSummonPlayer()~=tp and c:IsDestructable()
end
function c13254047.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c13254047.filter,1,nil,tp) end
	local g=eg:Filter(c13254047.filter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c13254047.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() and not tc:IsDisabled() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
	Duel.Destroy(g,REASON_EFFECT)
end
function c13254047.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCost(c13254047.cost2)
	e5:SetTarget(c13254047.target1)
	e5:SetOperation(c13254047.activate1)
	e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
end
function c13254047.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c13254047.costfilter,tp,LOCATION_HAND,0,3,e:GetHandler()) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c13254047.costfilter,tp,LOCATION_HAND,0,3,3,nil)
		Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
end
