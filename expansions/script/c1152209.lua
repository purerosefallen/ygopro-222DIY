--QED『495年的波纹』
function c1152209.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1152209.con1)
	e1:SetTarget(c1152209.tg1)
	e1:SetOperation(c1152209.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c1152209.tg2)
	e2:SetOperation(c1152209.op2)
	c:RegisterEffect(e2)
--
end
--
function c1152209.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152209.named_with_Fulsp=1
function c1152209.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152209.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c1152209.IsFulan(c)
end
function c1152209.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c1152209.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
--
function c1152209.tfilter1(c)
	return c:IsType(TYPE_MONSTER) and c1152209.IsFulan(c) and c:IsAbleToHand()
end
function c1152209.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1152209.tfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
--
function c1152209.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
	local g=Duel.GetMatchingGroup(c1152209.tfilter1,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if spcard:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		if dcount-seq==1 then 
			Duel.SendtoHand(spcard,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,spcard)
			Duel.ShuffleHand(tp)
		else
			local gn=Duel.GetDecktopGroup(tp,dcount-seq-1)
			local gr=Group.CreateGroup()
			Duel.SendtoHand(spcard,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,spcard)
			if gn:GetCount()>0 then
				local tc=gn:GetFirst()  
				while tc do
					if tc:IsType(TYPE_MONSTER) then
						gr:AddCard(tc)
					end
					tc=gn:GetNext()
				end
				if gr:GetCount()>0 then
					Duel.Remove(gr,POS_FACEDOWN,REASON_EFFECT)
				end
			end
			Duel.ShuffleDeck(tp)
			Duel.ShuffleHand(tp)
		end
	else
		local gn=Duel.GetDecktopGroup(tp,dcount-seq-1)
		local gr=Group.CreateGroup()
		if gn:GetCount()>0 then
			local tc=gn:GetFirst()  
			while tc do
				if tc:IsType(TYPE_MONSTER) then
					gr:AddCard(tc)
				end
				tc=gn:GetNext()
			end
			if gr:GetCount()>0 then
				Duel.Remove(gr,POS_FACEDOWN,REASON_EFFECT)
			end
		end
		Duel.ShuffleDeck(tp)
		Duel.ShuffleHand(tp)
	end
end
--
function c1152209.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	e:SetLabelObject(rc)
	local loc,np=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	if chk==0 then return loc==LOCATION_MZONE and np==tp and re:IsActiveType(TYPE_MONSTER) and c1152209.IsFulan(rc) end
	return Duel.SelectYesNo(tp,aux.Stringid(1152209,0))
end
--
function c1152209.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	local rc=e:GetLabelObject()
	local e2_1=Effect.CreateEffect(rc)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetCode(EFFECT_IMMUNE_EFFECT)
	e2_1:SetValue(c1152209.efilter2_1)
	e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	rc:RegisterEffect(e2_1)
end
function c1152209.efilter2_1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--