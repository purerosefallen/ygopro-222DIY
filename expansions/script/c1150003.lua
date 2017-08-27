--真红的情人节
function c1150003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150003+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1150003.cost1)
	e1:SetTarget(c1150003.tg1)
	e1:SetOperation(c1150003.op1)
	c:RegisterEffect(e1)   
	if not c1150003.global_check then
		c1150003.global_check=true
		local e1_0=Effect.CreateEffect(c)
		e1_0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_0:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1_0:SetOperation(c1150003.op1_0)
		Duel.RegisterEffect(e1_0,0)
		local e2_0=Effect.CreateEffect(c)
		e2_0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2_0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2_0:SetOperation(c1150003.clear2_0)
		Duel.RegisterEffect(e2_0,0)
	end
end
--
function c1150003.op1_0(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetReasonEffect():IsHasType(EFFECT_TYPE_ACTIONS) then
			c1150003[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
--
function c1150003.clear2_0(e,tp,eg,ep,ev,re,r,rp)
	c1150003[0]=true
	c1150003[1]=true
end
--
function c1150003.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) and c1150003[tp] end
	Duel.PayLPCost(tp,500)
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1_1:SetTargetRange(1,0)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	e1_1:SetTarget(c1150003.limit1_1)
	Duel.RegisterEffect(e1_1,tp)
end
--
function c1150003.limit1_1(e,c,sump,sumtype,sumpos,targetp,se)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
--
function c1150003.tfilter1(c)
	return c:IsAbleToHand()
end
function c1150003.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1150002.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1150003.tfilter1,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1150003.tfilter1,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE) 
end
--
function c1150003.ofilter1(c)
	return c:IsControlerCanBeChanged() and c:IsLocation(LOCATION_MZONE)
end
function c1150003.ofilter01(c)
	return c:IsAbleToRemove()
end
function c1150003.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.SelectYesNo(1-tp,aux.Stringid(1150003,0)) then
			if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
		else
			if Duel.IsExistingMatchingCard(c1150003.ofilter1,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1150003,3)) then
				if Duel.IsChainDisablable(0) then
					local sel=1
					local cg=Duel.GetMatchingGroup(c1150003.ofilter01,tp,0,LOCATION_HAND,nil)
					if cg:GetCount()>0 then
						sel=Duel.SelectOption(1-tp,aux.Stringid(1150003,1),aux.Stringid(1150003,2))
					else
						sel=Duel.SelectOption(1-tp,aux.Stringid(1150003,2))+1
					end
					if sel==0 then
						Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
						local sg=cg:Select(1-tp,1,1,nil)
						Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
						Duel.NegateEffect(0)
						return
					end
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
				local g=Duel.SelectMatchingCard(tp,c1150003.ofilter01,tp,0,LOCATION_MZONE,1,1,nil)
				if g:GetCount()>0 then
					local tc2=g:GetFirst()
					Duel.GetControl(tc2,tp)
				end
			end
		end
	end
end




