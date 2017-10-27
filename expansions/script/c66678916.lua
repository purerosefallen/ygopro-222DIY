--遗世之都
function c66678916.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,66678916+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c66678916.target)
	e1:SetOperation(c66678916.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c66678916.limcon)
	e2:SetOperation(c66678916.limop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetOperation(c66678916.limop2)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if not tg or not tg:IsExists(function(c,tp)
			return c:IsFaceup() and c:IsSetCard(0x665) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_XYZ) and c:IsControler(tp)
		end,1,nil,tp) then return false end
		return Duel.IsChainNegatable(ev)
	end)
	e4:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(function(c,tp)
			return c:IsFaceup() and c:IsSetCard(0x665) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_XYZ) and c:IsControler(tp)
		end,nil,tp)
		if chk==0 then return tg:GetSum(Card.GetOverlayCount)>=2 end
		tg=tg:Filter(function(c) return c:GetOverlayCount()>0 end,nil)
		if tg:GetSum(Card.GetOverlayCount)==2 then
			local tc,gg=tg:GetFirst(),Group.CreateGroup()
			while tc do
				gg:Merge(tc:GetOverlayGroup())
				tc=tg:GetNext()
			end
			Duel.SendtoGrave(gg,REASON_COST)
			return
		end
		if tg:GetCount()==1 then
			Duel.Hint(HINT_SELECTMSG,tp,519)
			local gg=tg:GetFirst():GetOverlayGroup():Select(tp,2,2,nil)
			Duel.SendtoGrave(gg,REASON_COST)
		else
			local count=2
			while count>0 do
				Duel.Hint(HINT_SELECTMSG,tp,532)
				local sc=tg:Select(tp,1,1,nil):GetFirst()
				Duel.Hint(HINT_SELECTMSG,tp,519)
				local gg=sc:GetOverlayGroup():Select(tp,1,count,nil)
				if sc:GetOverlayCount()==0 then tg:RemoveCard(sc) end
				count=count-Duel.SendtoGrave(gg,REASON_COST)
			end
		end
	end)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e4)
end
function c66678916.filter(c,e,tp)
	return c:IsSetCard(0x665) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66678916.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c66678916.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c66678916.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66678916.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c66678916.limfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0x665) and c:IsType(TYPE_XYZ)
end
function c66678916.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66678916.limfilter,1,nil,tp)
end
function c66678916.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c66678916.chainlm)
	else
		e:GetHandler():RegisterFlagEffect(66678916,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c66678916.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(66678916)~=0 then
		Duel.SetChainLimitTillChainEnd(c66678916.chainlm)
	end
	e:GetHandler():ResetFlagEffect(66678916)
end
function c66678916.chainlm(e,rp,tp)
	return tp==rp
end